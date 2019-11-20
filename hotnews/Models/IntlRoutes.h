//
//  IntlRoutes.h
//  hotnews
//
//  Created by tian on 2017/09/08.
//  Copyright © 2017年 tian. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JLRoutes.h"

@interface IntlRoutes : JLRoutes

/**
 The `UINavigationController` instance which mapped `UIViewController`s will be pushed onto.
 */
@property (readwrite, nonatomic, strong) UINavigationController *navigationController;
@property (readwrite, nonatomic, strong) UITabBarController *tabBarController;

- (UIViewController *)visibleViewController;

@end
