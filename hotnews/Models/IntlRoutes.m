//
//  IntlRoutes.m
//  hotnews
//
//  Created by tian on 2017/09/08.
//  Copyright © 2017年 tian. All rights reserved.
//

#import "IntlRoutes.h"

@implementation IntlRoutes

- (UIViewController *)visibleViewController {
    //sRoutable *routable = [Routable sharedRouter];
    UIViewController *controller = self.navigationController.presentedViewController;
    if (controller && ![controller isBeingDismissed] && ![controller isMovingFromParentViewController]) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            controller = ((UINavigationController *) controller).visibleViewController;
        }
        
    
        if ([controller isKindOfClass:[UITabBarController class]]) {
            
            NSLog(@"%@",[[(UITabBarController*)controller selectedViewController] class]);
            
            controller = [(UITabBarController*)controller selectedViewController];
            
        }
        
    } else {
        controller = self.navigationController.topViewController;
        
        if ([controller isKindOfClass:[UITabBarController class]]) {
            
            NSLog(@"%@",[[(UITabBarController*)controller selectedViewController] class]);
            
            controller = [(UITabBarController*)controller selectedViewController];
            
        }
        
    }
    return controller;
}


@end
