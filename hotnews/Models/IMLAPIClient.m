//
//  IMLAPIClient.m
//  NBXenophrys
//
//  Created by tym on 2014/04/01.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <AFNetworking/AFNetworking.h>
#import "IMLConstants.h"
#import "IMLHTTPRequest.h"
#import "IMLAPIClient.h"
#import "UIApplication+IMLAppInfo.h"
//#import "IMLURLRouter.h"
#import "NSJSONSerialization+RNJSON.h"

@interface SVHTTPRequest (PrivateMethods)
- (SVHTTPRequest*)initWithAddress:(NSString*)urlString
                           method:(SVHTTPRequestMethod)method
                       parameters:(NSObject*)parameters
                       saveToPath:(NSString*)savePath
                         progress:(void (^)(float))progressBlock
                       completion:(SVHTTPRequestCompletionHandler)completionBlock;

@end

@implementation IMLAPIClient

+ (NSString *)makeLoadableURLString:(NSString *)URLString {
    if (!URLString || [URLString length] == 0) return nil;
    
    URLString = [[NSURL URLWithString:URLString relativeToURL:
                  [NSURL URLWithString:kBaseURL]]
                 absoluteString];
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)URLString, CFSTR("%#"), NULL, kCFStringEncodingUTF8);
}

+ (void)downloadImageFromURLStr:(NSString *)URLStr completion:(void (^)(UIImage *))completion failure:(IMLAPIClientFailureBlock)failure timeout:(NSUInteger)timeout {
    SVHTTPRequest *requestObject = [[SVHTTPRequest alloc] initWithAddress:URLStr method:SVHTTPRequestMethodGET parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSError *inBlockError = error;
                UIImage *image = nil;
                if (!inBlockError) {
                    if ([response isKindOfClass:[NSData class]]) {
                        image = [UIImage imageWithData:response];
                        if (!image) inBlockError = [NSError errorWithDomain:[UIApplication appName] code:kAPIServerErrorCode userInfo:nil];
                    } else {
                        inBlockError = [NSError errorWithDomain:[UIApplication appName] code:kAPIServerErrorCode userInfo:nil];
                    }
                }
                if (inBlockError) {
                    if (failure) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure(inBlockError);
                        });
                    }
                    return; // do not call completion block if there is any error
                }
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(image);
                    });
                }
            });
    }];
    requestObject.timeoutInterval = timeout;
    [requestObject start];
}

+ (void)uploadAvatarToURLString:(NSString *)URLStr image:(UIImage *)image progress:(void (^)(float))progressBlock completion:(void (^)(NSString *referenceURLStr, NSString *fullURLStr))completion failure:(IMLAPIClientFailureBlock)failure {
    if (!image || !URLStr || [URLStr length] == 0) {
        NSError *error = [NSError errorWithDomain:kBaseURL code:500 userInfo:@{NSLocalizedDescriptionKey: @"Nothing to upload."}];
        failure(error);
        return;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"userfile" fileName:@"userfile.jpg" mimeType:@"image/jpg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:nil
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      id result = [self handleResponse:responseObject urlResponse:response requiredClass:[NSDictionary class] error:error failure:failure];
                      if (result && completion) {
                          if ([[result[@"status"] lowercaseString] isEqualToString:@"success"]) {
                              completion(result[@"url"], result[@"avatar"]);
                          } else if (failure) {
                              NSError *error = [NSError errorWithDomain:kBaseURL code:500 userInfo:@{NSLocalizedDescriptionKey : result[@"msg"]}];
                              failure(error);
                          }
                      }
                  }];
    
    [uploadTask resume];
}

+ (void)getNewsInfo:(NSString *)newsId completion:(void (^)(NSString *title, NSString *subTitle, UIImage *image))block failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"news", newsId] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && block) {
            NSString *title = result[@"title"];
            NSString *subTitle = result[@"subtitle"];
            NSString *imageURLStr = result[@"cover"];
            [self downloadImageFromURLStr:imageURLStr completion:^(UIImage *image) {
                block(title, subTitle, image);
            } failure:failure timeout:20];
        }
    }];
}

+ (void)getItemInfo:(NSString *)itemId completion:(void (^)(NSString *title, NSString *subTitle, UIImage *image))block failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"items", itemId] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && block) {
            NSString *title = result[@"name"];
            NSString *subTitle = result[@"original_name"];
            NSString *imageURLStr = result[@"cover"];
            [self downloadImageFromURLStr:imageURLStr completion:^(UIImage *image) {
                block(title, subTitle, image);
            } failure:failure timeout:20];
        }
    }];
}

+ (void)bindWeiboWithUserId:(NSString *)uid email:(NSString *)email nickname:(NSString *)nickname token:(NSString *)token completion:(void (^)(NSString *msg, NSString *status))completion failure:(IMLAPIClientFailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (uid) dict[@"sinaid"] = uid;
    if (email) dict[@"username"] = email;
    if (email) dict[@"nickname"] = nickname;
//    if (token) dict[@"token"] = token;
    dict[@"deviceid"] = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
//    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        [IMLHTTPRequest GET:@[@"user", @"bind_sina"] parameters:dict needSign:NO
                  completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                      id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
                      if (result && completion) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              completion(result[@"msg"], result[@"token"]);
                          });
                      }
                  }];
//    } else {
//        [[IMLHiddenWebViewManager sharedInstance] loadRequest:[IMLHTTPRequest apiPathForArray:@[@"user", @"bind_sina"]] parameter:[IMLHTTPRequest sign:dict] completion:^(NSString * result, NSError * error) {
//            id resultObj = [self handleResult:result requiredClass:[NSDictionary class] error:error failure:failure];
//            if (resultObj && completion) {
//                completion(resultObj[@"msg"], resultObj[@"token"]);
//            }
//        }];
//    }
}

+ (void)signupSSO:(NSDictionary *)params completion:(void (^)(NSDictionary *result, NSString *status))completion failure:(IMLAPIClientFailureBlock)failure {
//    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        [IMLHTTPRequest POST:@[@"auth", @"signup"] parameters:params needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
            id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
            if (result && completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(result, result[@"isValidFlg"]);
                });
            }
        }];
//    } else {
//        [[IMLHiddenWebViewManager sharedInstance] loadRequest:[IMLHTTPRequest apiPathForArray:@[@"auth", @"signup"]] parameter:[IMLHTTPRequest sign:params] completion:^(NSString * result, NSError * error) {
//            id resultObj = [self handleResult:result requiredClass:[NSDictionary class] error:error failure:failure];
//            if (resultObj && completion) {
//                completion(resultObj[@"msg"], resultObj[@"token"]);
//            }
//        }];
//    }
}

+ (void)logout:(void (^)(NSString *msg))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"user", @"logout"] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result[@"msg"]);
            });
        }
    }];
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[deviceToken description]
                        stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];

    ////LOG_MESSAGE(@"Remote Notification Token: %@", token);

    NSDictionary *dict = @{@"token" : token,
                           @"type" : @"ios"};
    [IMLHTTPRequest POST:@[@"installations"] parameters:dict needSign:YES completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//        NSDictionary *dict = [IMLHTTPRequest processResponse:urlResponse response:response requiredClass:[NSDictionary class] failure:nil];
//        //LOG_MESSAGE(@"Register device Token result:%@ \n%@\nError: %@", dict, urlResponse, error);
    }];
}
+ (void)getListViews:(void (^)(NSArray *dict))block failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"channel/user"] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // make sure call block on mainThread
            block([IMLHTTPRequest processResponse:urlResponse response:response requiredClass:[NSArray class] failure:failure]);
        });
    }];
}

+ (void)getRouters:(void (^)(NSDictionary *dict))block failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"app-config"] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // make sure call block on mainThread
            block([IMLHTTPRequest processResponse:urlResponse response:response requiredClass:[NSDictionary class] failure:failure]);
        });
    }];
}

+ (void)getAPI:(NSString *)APIURL parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *dict))block failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:APIURL parameters:parameters completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
    }];
}

+ (void)callAPIWithURLString:(NSString *)URLStr failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:URLStr parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error && failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // make sure call block on mainThread
                failure(error);
            });
        }
    }];
}

+ (void)getAdInfo:(void (^)(NSDictionary *adInfo))block failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"advertise"] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && block) {
            NSArray *adList = [result[@"data"][@"ad_list"] allValues];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (adList) {
                dict[@"ad_list"] = adList;
            }
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(dict);
                });
            }
        }
    }];
}

+ (void)downloadFileFromURLStr:(NSString *)URLStr saveToPath:(NSString *)path completion:(void (^)(NSUInteger operationCount))completion failure:(IMLAPIClientFailureBlock)failure timeout:(NSUInteger)timeout {
    static NSOperationQueue *queue = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        queue = [NSOperationQueue new];
        queue.maxConcurrentOperationCount = 1;
    });
    SVHTTPRequest *requestObject = [[SVHTTPRequest alloc] initWithAddress:URLStr method:SVHTTPRequestMethodGET parameters:nil saveToPath:path progress:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error && failure) {
                failure(error);
            } else if (completion) {
                ////LOG_MESSAGE(@"queue operation count: %lu", (unsigned long)[queue operationCount]);
                completion([queue operationCount]);
            }
        });
    }];
    requestObject.timeoutInterval = timeout;
    requestObject.queuePriority = NSOperationQueuePriorityLow;
    [queue addOperation:requestObject];
    [queue setSuspended:NO];
}

+ (void)getOpenURL:(NSDictionary *)parameters completion:(void (^)(NSString *URLStr))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"push", @"open_url"] parameters:parameters needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && completion) {
//            NSString *URLStr = result[kRouterURLKey];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completion(URLStr);
//            });
        }
    }];
}

+ (void)getLatestAPI:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"latest"] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result);
            });
        }
    }];
}

+ (void)getUserAvatar:(void (^)(UIImage *))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"user", @"avatar"] parameters:nil needSign:YES completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && completion) {
            NSString *avatarURLString = result[@"data"][@"avatar"];
            if ([avatarURLString length] > 0) {
                [self downloadImageFromURLStr:avatarURLString completion:completion failure:failure timeout:30];
            } else if (failure) {
                NSString *message = result[@"msg"];
                if (!message) message = @"Unknown Error";
                failure([NSError errorWithDomain:[UIApplication appName] code:kAPIServerErrorCode userInfo:@{NSLocalizedDescriptionKey: message}]);
            }
        }
    }];
}

+ (id)handleResponse:(id)response urlResponse:(NSURLResponse *)urlResponse requiredClass:(Class)class error:(NSError *)error failure:(IMLAPIClientFailureBlock)failure {
    if (error && failure) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
        return nil;
    }
    id result = [IMLHTTPRequest processResponse:urlResponse response:response requiredClass:class failure:failure];
    return result;
}

+ (id)handleResult:(NSString *)result requiredClass:(Class)class error:(NSError *)error failure:(IMLAPIClientFailureBlock)failure {
    if (error && failure) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
        return nil;
    }
    return [IMLHTTPRequest processResult:result requiredClass:class failure:failure];
}

+ (void)getOutsideAPI:(NSString *)api parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest callAPIURL:api parameters:parameters method:SVHTTPRequestMethodGET innerClient:NO saveToPath:nil timeout:[IMLHTTPRequest sharedInstance].timeoutInterval progress:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result);
            });
        }
    }];
}

+ (void)getOutlineData:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"outline"] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result);
            });
        }
    }];
}

+ (void)convertScannResult:(NSString *)scanResult completion:(void (^)(NSString *, NSString *))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"scan-convert"] parameters:@{@"v": scanResult} needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result && completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result[@"url"], result[@"message"]);
            });
        }
    }];
}

+ (void)taskTrackingAppOpen {
    [IMLHTTPRequest GET:@[@"coin", @"sign"] parameters:nil needSign:YES completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:nil];
        if (result) {
            //[[IMLURLRouter defaultHandler] sendCoinNotification:[NSJSONSerialization stringWithJSONObject:result options:0 error:nil]];
        }
    }];
}

+ (void)taskTrackingShareSuccess:(NSString *)sharedId {
    [IMLHTTPRequest GET:@[@"coin", @"share"] parameters:sharedId ? @{@"id" : sharedId} : nil needSign:YES completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:nil];
        if (result) {
            //[[IMLURLRouter defaultHandler] sendCoinNotification:[NSJSONSerialization stringWithJSONObject:result options:0 error:nil]];
        }
    }];
}

+ (void)getShareInfoForURIString:(NSString *)URLStr completion:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure {
    if (!URLStr) {
        URLStr = @"";
    }
    [IMLHTTPRequest GET:@[@"share-info"] parameters:@{@"url": URLStr} needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result) {
            completion(result);
        }
    }];
}

+ (void)getRongCloudToken:(void (^)(NSString *))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest GET:@[@"me", @"support", @"token"] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result) {
            completion(result[@"token"]);
        }
    }];
}

+ (void)updateRongCloudToken:(void (^)(NSString *))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest POST:@[@"me", @"support", @"token"] parameters:nil needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result) {
            completion(result[@"token"]);
        }
    }];
}

+ (void)continueCharge:(NSString *)path orderId:(NSString *)orderId token:(NSString *)token completion:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure {
    [IMLHTTPRequest POST:@[path, orderId, @"pay"] parameters:@{@"token": token} needSign:NO completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        id result = [self handleResponse:response urlResponse:urlResponse requiredClass:[NSDictionary class] error:error failure:failure];
        if (result) {
            completion(result);
        }
    }];
}
@end
