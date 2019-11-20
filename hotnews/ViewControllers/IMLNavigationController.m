//
//  IMLNavigationController.m
//  NBXenophrys
//
//  Created by tym on 10/11/13.
//  Copyright (c) 2014 tym.COM. All rights reserved.
//

#import "IMLNavigationController.h"
//#import "IMLWebViewController.h"
#import "IMLNavigationBar.h"
#import "IMLConstants.h"

@interface IMLNavigationController () <UINavigationControllerDelegate>

@end

@implementation IMLNavigationController

- (instancetype)init {
    self = [super initWithNavigationBarClass:[IMLNavigationBar class] toolbarClass:nil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[IMLNavigationBar class] toolbarClass:nil];
    if (self) {
        self.delegate = self;
        [self setViewControllers:@[rootViewController] animated:NO];
    }
    return self;
}

- (void)dealloc {
    //LOG_MESSAGE_CURRENT_METHOD([self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
}

#pragma mark - Autorotate
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0") && SYSTEM_VERSION_LESS_THAN(@"10.0")) {
        if ([self.visibleViewController isKindOfClass:[UIAlertController class]]) {
            // This is a workaround for iOS 9 UIWebRotatingAlertController crash problem.
            return self.topViewController.supportedInterfaceOrientations;
        }
    }
    return self.visibleViewController.supportedInterfaceOrientations;
}

- (BOOL)prefersStatusBarHidden {
    return self.visibleViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.visibleViewController.preferredStatusBarStyle;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (_viewControllersStackChangeCompletionBlock) {
        _viewControllersStackChangeCompletionBlock();
        _viewControllersStackChangeCompletionBlock = nil;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}
@end
