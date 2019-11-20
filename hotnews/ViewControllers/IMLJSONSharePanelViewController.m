//
//  IMLJSONSharePanelViewController.m
//  ht-ios
//
//  Created by dev on 7/8/15.
//  Copyright © 2015 dev.COM. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <NSBKeyframeAnimation/NSBKeyframeAnimation.h>
#import "WeixinService.h"

#import "IMLJSONSharePanelViewController.h"
#import "IMLHTTPRequest.h"
#import "IMLAPIClient.h"

@interface IMLSharePanelViewController (PrivateMethods)

- (NSString *)string:(NSString *)string appendingStringIfNeeded:(NSString *)newStr;
- (void)close;
- (void)closeWithOutAnimation:(void(^)(void))completion;
- (void)makeNewWindow;
@end

@interface IMLJSONSharePanelViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation IMLJSONSharePanelViewController

- (void)close {
    if (_type != IMLJSONSharePanelShareTypeAll) {
        [self closeWithOutAnimation:nil];
    } else {
        [super close];
    }
}

- (void)show:(void (^)(void))completion {
    if (_type != IMLJSONSharePanelShareTypeAll) {
        [self makeNewWindow];
        self.view.alpha = 0;
        if (completion) {
            completion();
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            switch (_type) {
                case IMLJSONSharePanelShareTypeCopy:{
                    [self copyLink];
                    break;
                }
                case IMLJSONSharePanelShareTypeLine:{
                    break;
                }
                case IMLJSONSharePanelShareTypeMail:{
                    [self shareWithMail];
                    break;
                }
                case IMLJSONSharePanelShareTypeSafari:{
                    [self openInSafari];
                    break;
                }
                case IMLJSONSharePanelShareTypeSMS:{
                    [self shareToSMS];
                    break;
                }
                case IMLJSONSharePanelShareTypeWeChat:{
                    [self shareToWeChat:NO];
                    break;
                }
                case IMLJSONSharePanelShareTypeWeChatTimeline:{
                    [self shareToWeChat:YES];
                    break;
                }
                case IMLJSONSharePanelShareTypeWeibo:{
                    [self shareTo:SLServiceTypeSinaWeibo];
                    break;
                }
                default:{
                    [self close];
                    break;
                }
            }
        });
    } else {
        [super show:completion];
    }
}

- (void)downloadImage:(NSString *)imageURLStr localImage:(UIImage *)localImage completion:(void (^)(UIImage *))completion failure:(IMLAPIClientFailureBlock)failure {
    void (^failureBlock)(UIImage *) = ^(UIImage *image) {
        if (image) {
            completion(image);
        } else {
            failure(nil);
        }
    };
    if (imageURLStr && [imageURLStr length] > 0) {
        void (^hideAlertView)(void) = ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[NonblockingAlertView hide:YES];
            });
        };
        //[NonblockingAlertView showLoadingViewWithMessage:M(@"share.msg.loading") animated:YES];
        [IMLAPIClient downloadImageFromURLStr:imageURLStr completion:^(UIImage *image) {
            completion(image);
            hideAlertView();
        } failure:^(NSError *error) {
            failureBlock(localImage);
            hideAlertView();
        } timeout:5];
    } else {
        failureBlock(localImage);
    }
}

- (void)shareTo:(NSString *)type {
    
    SLComposeViewController *viewController = [SLComposeViewController composeViewControllerForServiceType:type];
    if (!viewController) {
        [self close];
        //[[IMLURLRouter defaultHandler] sendErrorMessage:[NSString stringWithFormat:M(@"share.msg.permission.failed"), M(@"app.name")]];
        return;
    }
    NSDictionary *data = _defaultData;
    if ([type isEqualToString:SLServiceTypeSinaWeibo] && _weiboData) {
        data = _weiboData;
    }
    if (_URL) {
        [viewController addURL:_URL];
    }
    NSString *body = [self string:data[@"title"] appendingStringIfNeeded:data[@"content"]];
    [viewController setInitialText:body];
    
    viewController.completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            [IMLAPIClient taskTrackingShareSuccess:self.messageId];
        }
        [self close];
    };
    //[NonblockingAlertView showLoadingViewWithMessage:M(@"share.msg.loading") animated:YES];
    [self downloadImage:data[@"image"] localImage:data[@"localImage"] completion:^(UIImage *image) {
        [viewController addImage:image];
        [self presentViewController:viewController animated:YES completion:nil];
    } failure:^(NSError *error) {
        [self presentViewController:viewController animated:YES completion:nil];
    }];
}

- (void)shareToWeChat:(BOOL)viaTimeline {
    if (![[WeixinService sharedService] isAvailable]) {
        [self close];
        //[[IMLURLRouter defaultHandler] sendErrorMessage:M(@"share.msg.error.no.wechat")];
        return;
    }
    
    NSDictionary *data = _defaultData;
    if (_wechatData) {
        data = _wechatData;
    }
    
    [self downloadImage:data[@"image"] localImage:data[@"localImage"] completion:^(UIImage *image) {
        [[WeixinService sharedService] sendMessageWithTitle:data[@"title"]
                                                description:data[@"content"]
                                                      image:image
                                                        url:_URL ? [_URL absoluteString] : nil
                                                viaTimeline:viaTimeline messageId:self.messageId];
        [self close];
    } failure:^(NSError *error) {
        [[WeixinService sharedService] sendMessageWithTitle:data[@"title"]
                                                description:data[@"content"]
                                                      image:nil
                                                        url:_URL ? [_URL absoluteString] : nil
                                                viaTimeline:viaTimeline messageId:self.messageId];
        [self close];
    }];
}

- (void)openInSafari {
    if (!_URL) {
        [self close];
        //[[IMLURLRouter defaultHandler] sendErrorMessage:M(@"share.msg.error.no.link.open")];
        return;
    }


    [[UIApplication sharedApplication] openURL:_URL];
    [self close];
}

- (void)copyLink {
    NSString *body = [self string:_defaultData[@"title"] appendingStringIfNeeded:_defaultData[@"content"]];
    body = [self string:body appendingStringIfNeeded:_URL ? [_URL absoluteString] : nil];
    
    if ([body length] == 0) {
        [self close];
        //[[IMLURLRouter defaultHandler] sendErrorMessage:M(@"share.msg.error.no.link.copy")];
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = body;
    
    //[[IMLURLRouter defaultHandler] sendSuccessMessage:NSLocalizedString(@"msg.did.copy.link", nil)];
    [self close];
}

- (void)shareToSMS {
    
    MFMessageComposeViewController *messageController = [MFMessageComposeViewController new];
    if ([MFMessageComposeViewController canSendText] && messageController) {
        NSString *body = [self string:_defaultData[@"title"] appendingStringIfNeeded:_defaultData[@"content"]];
        body = [self string:body appendingStringIfNeeded:_URL ? [_URL absoluteString] : nil];
        messageController.body = body;
//        if ([MFMessageComposeViewController canSendSubject]) {
//            messageController.subject = _defaultData[kRouterTitleKey];
//        }
        messageController.messageComposeDelegate = self;
        [self presentViewController:messageController animated:YES completion:nil];
    } else {
        //[[IMLURLRouter defaultHandler] sendErrorMessage:[NSString stringWithFormat:M(@"share.msg.permission.failed.sms"), M(@"app.name")]];
        [self close];
    }
}

- (void)shareWithMail {
    
    MFMailComposeViewController *mailViewController = [MFMailComposeViewController new];
    if ([MFMailComposeViewController canSendMail] && mailViewController) {
        NSString *body = [self string:nil appendingStringIfNeeded:_defaultData[@"content"]];
        body = [self string:body appendingStringIfNeeded:_URL ? [_URL absoluteString] : nil];
        
        [mailViewController setSubject:_defaultData[@"title"]];
        [mailViewController setMessageBody:body isHTML:NO];
        mailViewController.mailComposeDelegate = self;
        
        [self downloadImage:_defaultData[@"image"] localImage:_defaultData[@"localImage"] completion:^(UIImage *image) {
            [mailViewController addAttachmentData:UIImageJPEGRepresentation(image, 1.0)
                                         mimeType:@"image/jpeg"
                                         fileName:[[[NSUUID UUID] UUIDString] stringByAppendingPathExtension:@"jpg"]];
            [self presentViewController:mailViewController animated:YES completion:nil];
        } failure:^(NSError *error) {
            [self presentViewController:mailViewController animated:YES completion:nil];
        }];
    } else {
        //[[IMLURLRouter defaultHandler] sendErrorMessage:M(@"share.msg.permission.failed.mail")];
        [self close];
    }
}

- (void)messageComposeViewController:(nonnull MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (result == MFMailComposeResultSent) {
        [IMLAPIClient taskTrackingShareSuccess:self.messageId];
    }
    [controller dismissViewControllerAnimated:YES completion:^{
        [self close];
    }];
}

@end
