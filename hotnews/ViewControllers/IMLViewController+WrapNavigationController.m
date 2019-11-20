//
//  IMLViewController+WrapNavigationController.m
//  iCart
//
//  Created by tym on 2013/11/28.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//

#import "ALActionBlocks.h"
#import "IMLNavigationController.h"
#import "IMLViewController.h"
#import "IMLiOS7BarItemButton.h"

#import "IMLViewController+WrapNavigationController.h"
#import "IMLConstants.h"
#import "UIApplication+MultiLanguage.h"
//#import "IMLURLRouter.h"

@interface UIViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation UIViewController (IMLViewController_WrapNavigationController)

- (UINavigationController *)wrapByNavigationController {
    UINavigationController *controller = ([self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController);
    if (!controller) {
        controller = [[IMLNavigationController alloc] initWithRootViewController:self];
    }

    void (^block)(id weakSender) = ^(id weakSender) {
        //[[IMLURLRouter defaultHandler] sendCloseEvent];
    };
    UIBarButtonItem *item = nil;
    if (I_AM_IPAD()) {
        item = [[UIBarButtonItem alloc] initWithTitle:M(@"Done") style:UIBarButtonItemStylePlain block:block];
    } else {
        IMLBackButtonStyle style = IMLBackButtonStyleNormal;
        if ([self isKindOfClass:([IMLViewController class])]) {
            style = ((IMLViewController *)self).backButtonStyle;
        }
        if (style == IMLBackButtonStyleNone) {
            // No BackButton
            return controller;
        }
        IMLiOS7BarItemButton *button = [IMLiOS7BarItemButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navbar_back_btn"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button handleControlEvents:UIControlEventTouchUpInside withBlock:block];
        item = [[UIBarButtonItem alloc] initWithCustomView:button];
//        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone block:block];
    }
//    [item setTitleTextAttributes:@{NSFontAttributeName: kChineseFont(18), NSForegroundColorAttributeName:[UIColor subColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:[UINavigationBar appearance].titleTextAttributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = item;

    return controller;
}

@end
