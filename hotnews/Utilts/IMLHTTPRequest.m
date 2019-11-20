//
// Created by tym on 2014/04/03.
// Copyright (c) 2014 tym.COM. All rights reserved.
//
#import "IMLConstants.h"
#import "NSString+MD5.h"
//
#import "IMLHTTPRequest.h"
#import "UIApplication+IMLAppInfo.h"
#import "IMLExternConstants.h"
#import "NSJSONSerialization+RNJSON.h"

@interface SVHTTPRequest (PrivateMethods)
- (SVHTTPRequest*)initWithAddress:(NSString*)urlString
                           method:(SVHTTPRequestMethod)method
                       parameters:(NSObject*)parameters
                       saveToPath:(NSString*)savePath
                         progress:(void (^)(float))progressBlock
                       completion:(SVHTTPRequestCompletionHandler)completionBlock;

@end

@interface SVHTTPClient (PrivateMethods)
@property (nonatomic, strong) NSMutableDictionary *HTTPHeaderFields;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

static IMLHTTPRequest *__sharedInstance = nil;

@implementation IMLHTTPRequest

- (instancetype)initWithInnerClient {
    self = [super init];
    if (self) {
        _client = [SVHTTPClient sharedClientWithIdentifier:@"IMLAPIClient"];
        _client.userAgent = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserAgent"];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _client = [SVHTTPClient sharedClient];
        _client.userAgent = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserAgent"];
    }
    return self;
}

- (void)reloadUA {
    _client.userAgent = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserAgent"];
}

+ (IMLHTTPRequest *)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        __sharedInstance = [[IMLHTTPRequest alloc] initWithInnerClient];
    });
    return __sharedInstance;
}

+ (NSString *)apiPathForArray:(NSArray *)components {
    NSMutableString *path = [NSMutableString stringWithString:kAPIBasicURL];
    for (NSUInteger i = 0; i < components.count; i++) {
        NSString *component = components[i];
        if (component.length == 0) continue;    // Skip empty string
        
        if ([path rangeOfString:@"/"].location != (path.length - 1) &&
            [component rangeOfString:@"/"].location != 0) {
            [path appendString:@"/"];
        }
        [path appendString:[component stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
    }
    return [kBaseURL stringByAppendingString:path];
}

+ (NSDictionary *)sign:(NSDictionary *)parameters {
    NSMutableDictionary *signedParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *timestamp = [NSString stringWithFormat:@"%.f", ([[NSDate date] timeIntervalSince1970] * 1000.0)];
    signedParameters[@"t"] = timestamp;
    NSArray *keys = [[signedParameters allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableString *signString = [[NSMutableString alloc] init];
    for (id key in keys) {
        [signString appendString:key];
        id value = signedParameters[key];
        if ([value isKindOfClass:[NSNumber class]]) {
            [signString appendString:[NSString stringWithFormat:@"%ld", (long)[value integerValue]]];
        } else {
            [signString appendString:value];
        }
    }
    [signString appendString:kSecret];
    NSString *sign = [signString md5];
    signedParameters[@"sign"] = sign;
    
    return signedParameters;
}

- (NSDictionary *)signParametersIfNeeded:(NSDictionary *)parameters needSign:(BOOL)needSign {
    return needSign ? [[self class] sign:parameters] : parameters;
}

+ (SVHTTPRequest *)GET:(NSArray *)path parameters:(NSDictionary *)parameters needSign:(BOOL)needSign completion:(SVHTTPRequestCompletionHandler)block {
    NSString *pathStr = [IMLHTTPRequest apiPathForArray:path];
    
    
    return [[IMLHTTPRequest sharedInstance].client GET:pathStr parameters:[[IMLHTTPRequest sharedInstance] signParametersIfNeeded:parameters needSign:needSign] completion:block];
}

+ (SVHTTPRequest *)POST:(NSArray *)path parameters:(NSDictionary *)parameters needSign:(BOOL)needSign completion:(SVHTTPRequestCompletionHandler)block {
    NSString *pathStr = [IMLHTTPRequest apiPathForArray:path];
    
    return [[IMLHTTPRequest sharedInstance].client POST:pathStr parameters:[[IMLHTTPRequest sharedInstance] signParametersIfNeeded:parameters needSign:needSign] completion:block];
}

+ (SVHTTPRequest *)callAPI:(NSArray *)path parameters:(NSDictionary *)parameters method:(SVHTTPRequestMethod)method innerClient:(BOOL)innerClient {
    NSString *URLStr = [IMLHTTPRequest apiPathForArray:path];
    return [self callAPIURL:URLStr parameters:parameters method:method innerClient:innerClient saveToPath:nil timeout:[IMLHTTPRequest sharedInstance].timeoutInterval progress:nil needSign:NO completion:nil];
}

+ (SVHTTPRequest *)callAPI:(NSArray *)path parameters:(NSDictionary *)parameters method:(SVHTTPRequestMethod)method innerClient:(BOOL)innerClient saveToPath:(NSString *)savePath timeout:(NSTimeInterval)timeout progress:(void (^)(float))progressBlock needSign:(BOOL)needSign completion:(SVHTTPRequestCompletionHandler)block {
    NSString *URLStr = [IMLHTTPRequest apiPathForArray:path];
    return [self callAPIURL:URLStr parameters:parameters method:method innerClient:innerClient saveToPath:savePath timeout:timeout progress:progressBlock needSign:needSign completion:block];
}

+ (SVHTTPRequest *)callAPIURL:(NSString *)URLStr parameters:(NSDictionary *)parameters method:(SVHTTPRequestMethod)method innerClient:(BOOL)innerClient saveToPath:(NSString *)savePath timeout:(NSTimeInterval)timeout progress:(void (^)(float))progressBlock needSign:(BOOL)needSign completion:(SVHTTPRequestCompletionHandler)block {
    SVHTTPClient *client = innerClient ? [self sharedInstance].client : ([[IMLHTTPRequest alloc] init].client);
    NSString *completeURLString = [NSString stringWithFormat:@"%@%@", client.basePath, URLStr];
    id mergedParameters;
    
    if ((method == SVHTTPRequestMethodPOST || method == SVHTTPRequestMethodPUT) && client.sendParametersAsJSON && ![parameters isKindOfClass:[NSDictionary class]])
        mergedParameters = parameters;
    else {
        mergedParameters = [NSMutableDictionary dictionary];
        [mergedParameters addEntriesFromDictionary:parameters];
        [mergedParameters addEntriesFromDictionary:client.baseParameters];
    }
    
    SVHTTPRequest *requestOperation = [[SVHTTPRequest alloc] initWithAddress:completeURLString method:method parameters:parameters
                                                                  saveToPath:savePath progress:progressBlock completion:block];
    requestOperation.timeoutInterval = timeout;
    requestOperation.sendParametersAsJSON = client.sendParametersAsJSON;
    requestOperation.cachePolicy = client.cachePolicy;
    requestOperation.userAgent = client.userAgent;
    requestOperation.timeoutInterval = client.timeoutInterval;
    
    [(id<SVHTTPRequestPrivateMethods>)requestOperation setClient:client];
    
    [client.HTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *field, NSString *value, BOOL *stop) {
        [requestOperation setValue:value forHTTPHeaderField:field];
    }];
    
    if(client.username && client.password)
        [(id<SVHTTPRequestPrivateMethods>)requestOperation signRequestWithUsername:client.username password:client.password];
    
    [(id<SVHTTPRequestPrivateMethods>)requestOperation setRequestPath:URLStr];
    [client.operationQueue addOperation:requestOperation];
    
    return requestOperation;
}

+ (id)processResult:(NSString *)result requiredClass:(Class)class failure:(IMLAPIClientFailureBlock)failure {
    void (^failureBlock)(NSError *err) = ^(NSError *err) {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(err);
            });
        }
    };
    
    id jsonObject = [NSJSONSerialization JSONObjectWithString:result];
    if ([jsonObject isKindOfClass:class]) {
        return jsonObject;
    } else {
        NSMutableDictionary *userInfo = [@{NSLocalizedDescriptionKey : @"Bad Server Response"} mutableCopy];
        if ([jsonObject isKindOfClass:[NSDictionary class]] && jsonObject[@"message"]) {
            userInfo[NSLocalizedDescriptionKey] = jsonObject[@"message"];
            userInfo[@"server-message"] = @(YES);
        }
        NSError *error = [NSError errorWithDomain:kBaseHostName code:kAPIServerErrorCode userInfo:userInfo];
        failureBlock(error);
        return nil;
    }
}

+ (id)processResponse:(NSURLResponse *)urlResponse response:(id)response requiredClass:(Class)class failure:(IMLAPIClientFailureBlock)failure {
    NSError *error = nil;
    void (^failureBlock)(NSError *err) = ^(NSError *err) {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(err);
            });
        }
    };
    NSLog(@"[element className] = %@",[response class]);
    //NSLog(@"response = %@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    
    if ([response isKindOfClass:[NSData class]]  ) {
        if ([class isSubclassOfClass:[NSString class]]) {
            return [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        } else {
            id result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                failureBlock(error);
                return nil;
            }
            return [IMLHTTPRequest processResponse:urlResponse response:result requiredClass:class failure:failure];
        }
    } else if ([response isKindOfClass:[NSArray class]]) {
        return response;
        
    } else if ([response isKindOfClass:class]) {
        NSUInteger statusCode = ((NSHTTPURLResponse *)urlResponse).statusCode;
        if (statusCode < 200 || statusCode > 299) {
            NSMutableDictionary *userInfo = [@{NSLocalizedDescriptionKey : @"Bad Server Response"} mutableCopy];
            if ([response isKindOfClass:[NSDictionary class]] && response[@"message"]) {
                userInfo[NSLocalizedDescriptionKey] = response[@"message"];
                userInfo[@"server-message"] = @(YES);
            }
            NSError *error = [NSError errorWithDomain:kBaseHostName code:((NSHTTPURLResponse *)urlResponse).statusCode userInfo:userInfo];
            failureBlock(error);
            return nil;
        }
        return response;
    } else {
        // API Server Error
        error = [NSError errorWithDomain:[UIApplication appName] code:kAPIServerErrorCode userInfo:nil];
        failureBlock(error);
        return nil;
    }
}

@end
