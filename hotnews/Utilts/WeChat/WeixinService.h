//
//  WeixinService.h
//  iMW
//
//  Created by James Chen on 10/23/12.
//  Copyright (c) 2012 dev.COM. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface WeixinService : NSObject

+ (instancetype)sharedService;

- (void)registerApp;
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)isAvailable;
- (void)sendAuthRequest:(UIViewController *)viewController completion:(void (^)(BOOL, NSString *, NSString *, NSString *))completion;
- (void)sendJumpToBizProfileRequest:(NSString *)originId;
- (void)sendMessageWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image url:(NSString *)url messageId:(NSString *)messageId;
- (void)sendMessageWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image url:(NSString *)url viaTimeline:(BOOL)viaTimeline messageId:(NSString *)messageId;

@end


