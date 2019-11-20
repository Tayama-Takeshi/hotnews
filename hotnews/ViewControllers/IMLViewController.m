//
//  IMLViewController
//
//  Created by tym on 2014/03/30.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//

#import "IMLViewController.h"
#import "IMLNavigationTitleView.h"
#import "IMLConstants.h"
#import "UIViewController+CustomBackButton.h"

@interface IMLViewController () <UIGestureRecognizerDelegate>

@end

@implementation IMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomBackButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        NSArray *controllers = self.navigationController.viewControllers;
        if ([[controllers firstObject] isEqual:self]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else if ([controllers count] > 1) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        if ([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    IMLNavigationTitleView *titleView;
    if (![self.navigationItem.titleView isKindOfClass:[IMLNavigationTitleView class]]) {
        titleView = [[IMLNavigationTitleView alloc] initWithFrame:CGRectZero];   // the frame will be set by navigationItem automatically. Zero is OK.
        self.navigationItem.titleView = titleView;
    } else {
        titleView = (IMLNavigationTitleView *)self.navigationItem.titleView;
    }
    if (!title) {
        titleView.attributedText = nil; // No title
    } else {
        titleView.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[UINavigationBar appearance].titleTextAttributes];
    }
}

@end
