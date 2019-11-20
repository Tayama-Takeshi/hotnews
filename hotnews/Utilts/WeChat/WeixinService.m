//
//  WeixinService.m
//  iMW
//
//  Created by James Chen on 10/23/12.
//  Copyright (c) 2012 dev.COM. All rights reserved.
//
#import "IMLExternConstants.h"
#import "IMLAPIClient.h"

#import "WXApi.h"

#import "WeixinService.h"

@interface WeixinService () <WXApiDelegate>
@end

@implementation WeixinService {
    NSString *_authCheckState;
    NSString *_sharedMessageId;
    void (^_authCompletionBlock)(BOOL success, NSString *openID, NSString *accessToken, NSString *refreshToken);
}

+ (id)sharedService {
    static id service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _authCheckState = nil;
    }
    return self;
}

- (void)registerApp {
    [WXApi registerApp:WEIXIN_APP_ID];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)isAvailable {
    NSLog(@"isWXAppInstalled =%d",[WXApi isWXAppInstalled]);
    NSLog(@"isWXAppSupportApi = %d",[WXApi isWXAppSupportApi]);
    
    
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (void)sendMessageWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image url:(NSString *)url viaTimeline:(BOOL)viaTimeline messageId:(NSString *)messageId {
    _sharedMessageId = messageId;
    WXMediaMessage *msg = [WXMediaMessage message];
    
    WXWebpageObject *page = [WXWebpageObject object];
    page.webpageUrl = url;
    msg.mediaObject = page;
    
    msg.title = title;
    msg.description = description;
    
    if (image) {
        [msg setThumbImage:[self generateThumbnail:image]];
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = viaTimeline ? WXSceneTimeline : WXSceneSession;
    req.message = msg;
    req.bText = NO;
    [WXApi sendReq:req];
}

- (void)sendMessageWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image url:(NSString *)url messageId:(NSString *)messageId {
    [self sendMessageWithTitle:title description:description image:image url:url viaTimeline:NO messageId:messageId];
}

- (UIImage *)generateThumbnail:(UIImage *)image {
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratio = 64.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    
    return thumbnail;
}

- (void)sendAuthRequest:(UIViewController *)viewController completion:(void (^)(BOOL, NSString *, NSString *, NSString *))completion {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    _authCheckState = [NSUUID UUID].UUIDString;
    req.state = _authCheckState;
    _authCompletionBlock = completion;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:req viewController:viewController delegate:self];
}

- (void)sendJumpToBizProfileRequest:(NSString *)originId {
    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc] init];
    req.profileType = WXBizProfileType_Normal;
    req.username = originId;
    [WXApi sendReq:req];
}

- (void)sendAuthCompletion:(BOOL)success openID:(NSString *)openID accessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken {
    if (_authCompletionBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _authCompletionBlock(success, openID, accessToken, refreshToken);
        });
    }
}

- (void)sendFailedAuthCompletion {
    [self sendAuthCompletion:NO openID:nil accessToken:nil refreshToken:nil];
}

#pragma mark - Weixin Delegate

- (void)onReq:(BaseReq *)req {
    //
}

- (void)onResp:(BaseResp *)resp {
    //
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == WXSuccess) {
            if (![authResp.state isEqualToString:_authCheckState] ||
                [authResp.code length] == 0) {
                [self sendFailedAuthCompletion];
                return;
            }
            
            NSDictionary *params = @{@"appid": WEIXIN_APP_ID, @"secret": WEIXIN_APP_SECRET, @"code": authResp.code, @"grant_type": @"authorization_code"};
            [IMLAPIClient getOutsideAPI:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:params completion:^(NSDictionary *result) {
                NSLog(@"weixin login: %@", result);
                NSString *refreshToken = result[@"refresh_token"];
                NSString *accessToken = result[@"access_token"];
                if ([refreshToken length] == 0 || [accessToken length] == 0) {
                    [self sendFailedAuthCompletion];
                    return;
                }
                [self sendAuthCompletion:YES openID:result[@"openid"] accessToken:accessToken refreshToken:refreshToken];
            } failure:^(NSError *error) {
                [self sendFailedAuthCompletion];
                NSLog(@"weixin login error: %@", error);
            }];
        }/* else if (authResp.errCode == WXErrCodeUserCancel) {
          // do nothing
          } else if (authResp.errCode == WXErrCodeAuthDeny) {
          // should do something here?
          }*/ else {
              [self sendFailedAuthCompletion];
          }
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *sendMessageResp = (SendMessageToWXResp *)resp;
        if (sendMessageResp.errCode == WXSuccess) {
            [IMLAPIClient taskTrackingShareSuccess:_sharedMessageId];
        }
    }
}

@end
