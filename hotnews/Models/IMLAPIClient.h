//
//  IMLAPIClient.h
//  NBXenophrys
//
//  Created by tym on 2014/04/01.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "IMLHTTPRequest.h"

@interface IMLAPIClient : NSObject

+ (NSString *)makeLoadableURLString:(NSString *)URLString;
// Public API Methods
+ (void)getNewsInfo:(NSString *)newsId completion:(void (^)(NSString *title, NSString *subTitle, UIImage *image))block failure:(IMLAPIClientFailureBlock)failure;

+ (void)getItemInfo:(NSString *)itemId completion:(void (^)(NSString *title, NSString *subTitle, UIImage *image))block failure:(IMLAPIClientFailureBlock)failure;

+ (void)logout:(void (^)(NSString *msg))completion failure:(IMLAPIClientFailureBlock)failure;

+ (void)downloadImageFromURLStr:(NSString *)URLStr completion:(void (^)(UIImage *image))completion failure:(IMLAPIClientFailureBlock)failure timeout:(NSUInteger)timeout;

+ (void)uploadAvatarToURLString:(NSString *)URLStr image:(UIImage *)image progress:(void (^)(float))progressBlock completion:(void (^)(NSString *referenceURLStr, NSString *fullURLStr))completion failure:(IMLAPIClientFailureBlock)failure;

+ (void)registerDeviceToken:(NSData *)deviceToken;

+ (void)getRouters:(void (^)(NSDictionary *))block failure:(IMLAPIClientFailureBlock)failure;
+ (void)getListViews:(void (^)(NSArray *))block failure:(IMLAPIClientFailureBlock)failure;

+ (void)callAPIWithURLString:(NSString *)URLStr failure:(IMLAPIClientFailureBlock)failure;

+ (void)getAPI:(NSString *)APIURL parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *dict))block failure:(IMLAPIClientFailureBlock)failure;

+ (void)getAdInfo:(void (^)(NSDictionary *adInfo))block failure:(IMLAPIClientFailureBlock)failure;

+ (void)downloadFileFromURLStr:(NSString *)URLStr saveToPath:(NSString *)path completion:(void (^)(NSUInteger operationCount))completion failure:(IMLAPIClientFailureBlock)failure timeout:(NSUInteger)timeout;

+ (void)bindWeiboWithUserId:(NSString *)uid email:(NSString *)email nickname:(NSString *)nickname token:(NSString *)token completion:(void (^)(NSString *msg, NSString *status))completion failure:(IMLAPIClientFailureBlock)failure;
+ (void)signupSSO:(NSDictionary *)params completion:(void (^)(NSDictionary *result, NSString *status))completion failure:(IMLAPIClientFailureBlock)failure;

+ (void)getOpenURL:(NSDictionary *)parameters completion:(void (^)(NSString *URLStr))completion failure:(IMLAPIClientFailureBlock)failure;

+ (void)getLatestAPI:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure;

+ (void)getUserAvatar:(void (^)(UIImage *))completion failure:(IMLAPIClientFailureBlock)failure;

+ (void)convertScannResult:(NSString *)scanResult completion:(void (^)(NSString *, NSString *))completion failure:(IMLAPIClientFailureBlock)failure;

+ (void)getOutsideAPI:(NSString *)api parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure;
+ (void)getOutlineData:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure;

+ (void)taskTrackingAppOpen;
+ (void)taskTrackingShareSuccess:(NSString *)sharedId;

+ (void)getShareInfoForURIString:(NSString *)URLStr completion:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure;

+ (void)getRongCloudToken:(void (^)(NSString *))completion failure:(IMLAPIClientFailureBlock)failure;
+ (void)updateRongCloudToken:(void (^)(NSString *))completion failure:(IMLAPIClientFailureBlock)failure;
+ (void)continueCharge:(NSString *)path orderId:(NSString *)orderId token:(NSString *)token completion:(void (^)(NSDictionary *))completion failure:(IMLAPIClientFailureBlock)failure;
@end
