//
//  AppDelegate.h
//  hotnews
//
//  Created by tian on 2017/09/07.
//  Copyright © 2017年 tian. All rights reserved.
//


#import "IntlRoutes.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    UITabBarController *tabBarController;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIViewController *firstViewController;



@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

+ (instancetype)appDelegate;


@end

