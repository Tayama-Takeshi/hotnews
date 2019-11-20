//
//  IMLNavigationBar.h
//  NBXenophrys
//
//  Created by tym on 2014/02/05.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//
#import <UIKit/UIkit.h>

static NSString *NotificationNavbarFrameDidChange = @"kNotificationNavbarFrameDidChange";

@interface IMLNavigationBar : UINavigationBar

@property (nonatomic, assign) BOOL enableWebViewLoadProgress;
@property (readonly, assign) BOOL fadeOut;

- (void)setGestureOversever:(UIScrollView *)scrollView;
- (void)setFadeOut:(BOOL)fadeOut animated:(BOOL)animated;
@end
