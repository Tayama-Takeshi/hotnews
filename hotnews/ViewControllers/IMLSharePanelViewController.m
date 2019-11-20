//
//  IMLSharePanelViewController.m
//  NBXenophrys
//
//  Created by tym on 3/19/14.
//  Copyright (c) 2014 dev.COM. All rights reserved.
//

#import "AppDelegate.h"
#import "UIApplication+MultiLanguage.h"

#import "UIControl+ALActionBlocks.h"
#import "IMLConstants.h"
#import "UIColor+IMLColors.h"

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <NSBKeyframeAnimation/NSBKeyframeAnimation.h>
#import <Masonry/Masonry.h>

#import "WeixinService.h"
#import "UIButton+CenterVertically.h"

#import "IMLSharePanelViewController.h"
#import "IMLAPIClient.h"

#define kButtonSize     CGSizeMake(80.0f, 50.0f)
#define kHeight         236.0f;

@interface IMLSharePanelViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation IMLSharePanelViewController {
    UIView *_backgroundView;
    UIView *_contentView;
    NSInteger _heightOfWebView;
    NSArray *_buttons;
    UIWindow *_lastKeyWindow;
    MASConstraint *_moveDown;
    MASConstraint *_moveUp;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _heightOfWebView = kHeight;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarPreferHidden;
}

- (UIButton *)makeButtonWithImageName:(NSString *)name verticalTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kButtonSize.width, kButtonSize.height);
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor foregroundColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor foregroundColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = kChineseFont(12);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.imageView.bounds = CGRectMake(0, 0, 32, 32);
    [button centerVertically];
    return button;
}

- (void)makeShareButtons {
    __weak __typeof(self) weakMe = self;
    
    BOOL isWeChatAvaliable = [[WeixinService sharedService] isAvailable];
    UIButton *weChatBtn = [self makeButtonWithImageName:@"ShareWeChatIcon" verticalTitle:M(@"share.channel.wechat.friends")];
    [_contentView addSubview:weChatBtn];
    weChatBtn.enabled = isWeChatAvaliable;
    [weChatBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        __strong __typeof(weakMe) strongMe = weakMe;
        if (!strongMe) {
            return;
        }
        
        [strongMe shareToWeChat:NO];
    }];
    
    UIButton *weChatTimelineBtn = [self makeButtonWithImageName:@"ShareWeChatTimelineIcon" verticalTitle:M(@"share.channel.wechat.timeline")];
    [_contentView addSubview:weChatTimelineBtn];
    weChatTimelineBtn.enabled = isWeChatAvaliable;
    [weChatTimelineBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        __strong __typeof(weakMe) strongMe = weakMe;
        if (!strongMe) {
            return;
        }
        
        [strongMe shareToWeChat:YES];
    }];
    
    UIButton *weiboBtn = [self makeButtonWithImageName:@"ShareWeiboIcon" verticalTitle:M(@"share.channel.weibo")];
    [_contentView addSubview:weiboBtn];
    weiboBtn.enabled = ([SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo] != nil);  // I am not using isAvailableForServiceType here to make sure iOS will pop up a setting guide alertView incase the service is disabbled just because the setting was not finished.
    [weiboBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        __strong __typeof(weakMe) strongMe = weakMe;
        if (!strongMe) {
            return;
        }
        
        [strongMe shareTo:SLServiceTypeSinaWeibo];
    }];
    
    _buttons = @[weChatBtn, weChatTimelineBtn, weiboBtn];
    
    UIView *spaceView1 = [UIView new];
    spaceView1.hidden = YES;
    [_contentView addSubview:spaceView1];
    UIView *spaceView2 = [UIView new];
    spaceView2.hidden = YES;
    [_contentView addSubview:spaceView2];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_contentView addSubview:cancelBtn];
    [cancelBtn setTitle:M(@"msg.dialog.cancel.space") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor subColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1f];
    cancelBtn.titleLabel.font = kChineseFont(16);
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5.0f;
    [cancelBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        __strong __typeof(weakMe) strongMe = weakMe;
        if (!strongMe) {
            return;
        }
        
        [strongMe close];
    }];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_contentView addSubview:copyBtn];
    [copyBtn setTitle:M(@"share.channel.copy") forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor subColor] forState:UIControlStateNormal];
    copyBtn.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1f];
    copyBtn.titleLabel.font = kChineseFont(16);
    copyBtn.layer.masksToBounds = YES;
    copyBtn.layer.cornerRadius = 5.0f;
    [copyBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        __strong __typeof(weakMe) strongMe = weakMe;
        if (!strongMe) {
            return;
        }
        
        [strongMe copyLink];
    }];
    
    UIButton *firstButton = _buttons[0];
    [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.equalTo(@(kButtonSize.width));
        make.height.equalTo(@(kButtonSize.height));
        make.top.equalTo(firstButton.superview).offset(55);
    }];
    [spaceView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(firstButton.mas_trailing);
        make.trailing.equalTo(((UIView *)_buttons[1]).mas_leading);
        make.centerY.equalTo(firstButton);
        make.height.equalTo(@1);
        make.width.equalTo(spaceView2);
    }];
    [_buttons[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(spaceView1.mas_trailing);
        make.width.equalTo(@(kButtonSize.width));
        make.height.equalTo(@(kButtonSize.height));
        make.centerY.equalTo(firstButton);
    }];
    [spaceView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(((UIView *)_buttons[1]).mas_trailing);
        make.trailing.equalTo(((UIView *)_buttons[2]).mas_leading);
        make.centerY.equalTo(firstButton);
        make.height.equalTo(@1);
        make.width.equalTo(spaceView1);
    }];
    [_buttons[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.width.equalTo(@(kButtonSize.width));
        make.height.equalTo(@(kButtonSize.height));
        make.centerY.equalTo(firstButton);
    }];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancelBtn.mas_top).offset(-10);
        make.leading.equalTo(@(12));
        make.trailing.equalTo(cancelBtn.superview).offset(-12);
        make.height.equalTo(@40);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancelBtn.superview.mas_bottom).offset(-12);
        make.leading.equalTo(@(12));
        make.trailing.equalTo(cancelBtn.superview).offset(-12);
        make.height.equalTo(@40);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.alpha = 0.0f;
    [self.view addSubview:_backgroundView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.view insertSubview:blurView aboveSubview:_backgroundView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backgroundView addSubview:closeButton];
    closeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = M(@"share.channel.panel.title");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor foregroundColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = kChineseBoldFont(16);
    [_contentView addSubview:titleLabel];
    
    // Add Share Buttons
    [self makeShareButtons];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_backgroundView.superview);
        make.edges.equalTo(_backgroundView.superview);
    }];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@(_heightOfWebView));
        _moveDown = make.top.equalTo(self.view.mas_bottom);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(10);
        make.left.equalTo(@0);
        make.width.equalTo(_contentView);
        make.height.equalTo(@28);
    }];
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_contentView);
        make.edges.equalTo(_contentView);
    }];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(closeButton.superview);
        make.width.equalTo(closeButton.superview);
        make.top.equalTo(closeButton.superview);
        make.bottom.equalTo(_contentView.mas_top);
    }];
}

- (void)makeNewWindow {
    UIWindow *optionSelectWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window = optionSelectWindow;
    optionSelectWindow.rootViewController = self;
    optionSelectWindow.backgroundColor = [UIColor clearColor];
    optionSelectWindow.windowLevel = UIWindowLevelStatusBar - 1;
    _lastKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    [optionSelectWindow makeKeyAndVisible];
}

- (void)show:(void (^)(void))completion {
    [self makeNewWindow];
    
    _backgroundView.alpha = 0.0f;
    [self.view layoutIfNeeded]; // layout before animate to make sure not used animation will not show
    
    [_moveDown uninstall];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        _moveUp = make.bottom.equalTo(self.view.mas_bottom);
    }];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _backgroundView.alpha = 1.0f;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];}

- (void)close {
    [self close:nil];
}

- (void)closeWithOutAnimation:(void(^)(void))completion {
    [_moveUp uninstall];
    [_moveDown install];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _backgroundView.alpha = 0.0f;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         _window = nil;
                         [[AppDelegate appDelegate].window makeKeyAndVisible];
                         if (SYSTEM_VERSION_LESS_THAN(@"7.1") && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                             // Workaround: iOS below 7.1 will not update statusBar automatically
                             [[AppDelegate appDelegate].window.rootViewController setNeedsStatusBarAppearanceUpdate];
                         }
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)close:(void(^)(void))completion {
    [_moveUp uninstall];
    [_moveDown install];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _backgroundView.alpha = 0.0f;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         _window = nil;
                         [[AppDelegate appDelegate].window makeKeyAndVisible];
                         if (SYSTEM_VERSION_LESS_THAN(@"7.1") && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                             // Workaround: iOS below 7.1 will not update statusBar automatically
                             [[AppDelegate appDelegate].window.rootViewController setNeedsStatusBarAppearanceUpdate];
                         }
                         if (completion) {
                             completion();
                         }
                     }];
}

- (NSString *)mergeAllURLs {
    NSString *URLStr = @"";
    for (NSURL *URL in _URLs) {
        URLStr = [URLStr stringByAppendingFormat:@" %@", [URL absoluteString]];
    }
    return [URLStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)string:(NSString *)string appendingStringIfNeeded:(NSString *)newStr {
    if (!string) {
        string = @"";
    }
    if (newStr && [newStr length] > 0) {
        string = [string stringByAppendingFormat:@" %@", newStr];
    }
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)shareTo:(NSString *)type {
    
    SLComposeViewController *viewController = [SLComposeViewController composeViewControllerForServiceType:type];
    if (!viewController) {
        return;
    }
    [_images enumerateObjectsUsingBlock:^(UIImage *img, NSUInteger idx, BOOL *stop) {
        [viewController addImage:img];
    }];
    [_URLs enumerateObjectsUsingBlock:^(NSURL *URL, NSUInteger idx, BOOL *stop) {
        [viewController addURL:URL];
    }];
    
    NSString *str = [self string:nil appendingStringIfNeeded:_subject];
    str = [self string:str appendingStringIfNeeded:_content];
    str = [self string:str appendingStringIfNeeded:_shareFromInfo];
    [viewController setInitialText:str];
    
    viewController.completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            [IMLAPIClient taskTrackingShareSuccess:_messageId];
        }
        [self close];
    };
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)shareToLine {
    
    NSString *body = [self string:nil appendingStringIfNeeded:_subject];
    body = [self string:body appendingStringIfNeeded:_content];
    body = [self string:body appendingStringIfNeeded:[self mergeAllURLs]];
    body = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)body, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"line://msg/text/%@", body]]];
    [self close];
}

- (void)shareToWeChat:(BOOL)viaTimeline {

    [[WeixinService sharedService] sendMessageWithTitle:_subject
                                            description:_content
                                                  image:[_images firstObject]
                                                    url:[[_URLs firstObject] absoluteString]
                                            viaTimeline:viaTimeline messageId:_messageId];
    [self close];
}

- (void)openInSafari {
    
    if ([_URLs count] > 0) {
        [[UIApplication sharedApplication] openURL:[_URLs firstObject]];
    }
    [self close];
}

- (void)copyLink {
    
    if ([_URLs count] > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [[_URLs firstObject] absoluteString];
    }
    
    //[[IMLURLRouter defaultHandler] sendSuccessMessage:NSLocalizedString(@"msg.did.copy.link", nil)];
    [self close];
}

- (void)shareWithMail {
    
    MFMailComposeViewController *mailViewController = [MFMailComposeViewController new];
    if ([MFMailComposeViewController canSendMail] && mailViewController) {
        NSString *body = [self string:nil appendingStringIfNeeded:_content];
        body = [self string:body appendingStringIfNeeded:_shareFromInfo];
        body = [self string:body appendingStringIfNeeded:[self mergeAllURLs]];
        
        [mailViewController setSubject:_subject];
        [mailViewController setMessageBody:body isHTML:NO];
        mailViewController.mailComposeDelegate = self;
        [_images enumerateObjectsUsingBlock:^(UIImage *img, NSUInteger idx, BOOL *stop) {
            [mailViewController addAttachmentData:UIImageJPEGRepresentation(img, 1.0)
                                         mimeType:@"image/jpeg"
                                         fileName:[[[NSUUID UUID] UUIDString] stringByAppendingPathExtension:@"jpg"]];
        }];
        [self presentViewController:mailViewController animated:YES completion:nil];
    } else {
        [self close];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        [IMLAPIClient taskTrackingShareSuccess:_messageId];
    }
    [controller dismissViewControllerAnimated:YES completion:^{

        [self close];
    }];
}

- (BOOL)canShareWithLine {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]];
}

@end
