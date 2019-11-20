//
// Created by tym on 2014/04/03.
// Copyright (c) 2014 tym.COM. All rights reserved.
//

#import "SVHTTPRequest.h"

typedef void (^IMLAPIClientFailureBlock)(NSError *error);

@interface IMLHTTPRequest : SVHTTPRequest

@property(nonatomic, strong) SVHTTPClient *client;

+ (IMLHTTPRequest *)sharedInstance;

+ (SVHTTPRequest *)GET:(NSArray *)path parameters:(NSDictionary *)parameters needSign:(BOOL)needSign completion:(SVHTTPRequestCompletionHandler)block;

+ (SVHTTPRequest *)POST:(NSArray *)path parameters:(NSDictionary *)parameters needSign:(BOOL)needSign completion:(SVHTTPRequestCompletionHandler)block;

+ (SVHTTPRequest *)callAPI:(NSArray *)path parameters:(NSDictionary *)parameters method:(SVHTTPRequestMethod)method innerClient:(BOOL)innerClient;

+ (SVHTTPRequest *)callAPI:(NSArray *)path parameters:(NSDictionary *)parameters method:(SVHTTPRequestMethod)method innerClient:(BOOL)innerClient saveToPath:(NSString *)savePath timeout:(NSTimeInterval)timeout progress:(void (^)(float))progressBlock needSign:(BOOL)needSign completion:(SVHTTPRequestCompletionHandler)block;
+ (SVHTTPRequest *)callAPIURL:(NSString *)URLStr parameters:(NSDictionary *)parameters method:(SVHTTPRequestMethod)method innerClient:(BOOL)innerClient saveToPath:(NSString *)savePath timeout:(NSTimeInterval)timeout progress:(void (^)(float))progressBlock needSign:(BOOL)needSign completion:(SVHTTPRequestCompletionHandler)block;

+ (id)processResponse:(NSURLResponse *)urlResponse response:(id)response requiredClass:(Class)className failure:(IMLAPIClientFailureBlock)failure;
+ (id)processResult:(NSString *)result requiredClass:(Class)className failure:(IMLAPIClientFailureBlock)failure;

+ (NSString *)apiPathForArray:(NSArray *)components;
+ (NSDictionary *)sign:(NSDictionary *)parameters;

- (NSDictionary *)signParametersIfNeeded:(NSDictionary *)parameters needSign:(BOOL)needSign;
- (void)reloadUA;
@end
