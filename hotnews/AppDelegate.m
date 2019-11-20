//
//  AppDelegate.m
//  hotnews
//
//  Created by tian on 2017/09/07.
//  Copyright © 2017年 tian. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "NonblockingAlertView.h"
#import "AppDelegate.h"
#import "UIApplication+MultiLanguage.h"
#import "FirstViewController.h"
#import "NoBarWebUIViewController.h"
#import "LoginViewController.h"
#import "ShareViewController.h"
#import "UserViewController.h"
#import "SettingViewController.h"
#import "InfoViewController.h"
#import "MyTabViewController.h"


#import "UIColor+IMLColors.h"
#import "IMLConstants.h"
#import "WXApi.h"
#import "WeixinService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize tabBarController;

+ (instancetype)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication prepareLanguage];
    [UIApplication prepareAPI];
    [self prepareServices];
    
    //[self updateData];
    [self prepareUI];
    
    
 
    
    // Override point for customization after application launch.
    return YES;
}

- (void)prepareServices {
    [[WeixinService sharedService] registerApp];
}

-(void)resetViews{

    self.tabBarController = [[MyTabViewController alloc] initWithNibName:nil bundle:nil];
    
    
    
    self.tabBarController.navigationController.navigationBarHidden = YES;
    
    
    
    FirstViewController *tab1Controller = [FirstViewController new];
    ShareViewController *tab2Controller = [ShareViewController new];
    UserViewController *tab3Controller = [UserViewController new];
    InfoViewController *tab4Controller = [InfoViewController new];
    SettingViewController *tab5Controller = [SettingViewController new];
    
    
    UINavigationController *tab1NaviCtrl = [[UINavigationController alloc] initWithRootViewController:tab1Controller];
    tab1NaviCtrl.navigationBarHidden = NO;
    UINavigationController *tab2NaviCtrl = [[UINavigationController alloc] initWithRootViewController:tab2Controller];
    tab1NaviCtrl.navigationBarHidden = NO;
    UINavigationController *tab3NaviCtrl = [[UINavigationController alloc] initWithRootViewController:tab3Controller];
    tab1NaviCtrl.navigationBarHidden = NO;
    UINavigationController *tab4NaviCtrl = [[UINavigationController alloc] initWithRootViewController:tab4Controller];
    tab1NaviCtrl.navigationBarHidden = NO;
    UINavigationController *tab5NaviCtrl = [[UINavigationController alloc] initWithRootViewController:tab5Controller];
    tab1NaviCtrl.navigationBarHidden = NO;
    
    
    //DetailViewController *tab2Controller = [DetailViewController new];
    
    
    
    //    FirstViewController *tab3Controller = [[UITabBarController alloc] initWithNibName:@"tab1" bundle:nil];
    //    UITabBarController *tab4Controller = [[UITabBarController alloc] initWithNibName:@"tab1" bundle:nil];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:tab1NaviCtrl, tab2NaviCtrl,tab3NaviCtrl,tab4NaviCtrl,tab5NaviCtrl, nil];
    
    
    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    //    navigationController.navigationBarHidden = YES;
    
    
    
    tab1Controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_news"] tag:0];
    
    
    tab2Controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_share"] tag:1];
    tab3Controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"tab_my"] imageWithRenderingMode:UIImageRenderingModeAutomatic] tag:2];
    tab4Controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"tab_info"] imageWithRenderingMode:UIImageRenderingModeAutomatic] tag:3];
    tab5Controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"tab_setting"] imageWithRenderingMode:UIImageRenderingModeAutomatic] tag:4];
    //    tab3Controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_share"] tag:2];
    //    tab4Controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_setting"] tag:3];
    
    
    
    tab1Controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    tab2Controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    tab3Controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    tab4Controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    tab5Controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    UINavigationController *rootnavigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    rootnavigationController.navigationBarHidden = YES;
    
    
    
    self.window.rootViewController = rootnavigationController;
    self.navigationController = rootnavigationController;
}

- (void)prepareUI {
    UINavigationBar.appearance.tintColor = [UIColor subColor];
    UINavigationBar.appearance.titleTextAttributes = @{NSFontAttributeName : kChineseFont(18.0), NSForegroundColorAttributeName:[UIColor subColor]};
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //UITabBarController *tabViewCtrl = [[UITabBarController alloc] init];
    //tabViewCtrl.tabBar.tintColor = [UIColor orangeColor];
    
    
    [self resetViews];
    
    
    [self.window makeKeyAndVisible];
    
    //[Routable sharedRouter].navigationController = navigationController;
    
    
    
    IntlRoutes *routes = [IntlRoutes routesForScheme:kAppDefaultScheme];
    
    [routes addRoute:@"ui/:url/:title" handler:^BOOL(NSDictionary *parameters) {
        
        DetailViewController *controller = [[DetailViewController alloc] initWithParams:parameters];
        
        controller.navigationController.navigationBarHidden = NO;
        if (controller == nil) {
            return YES;
        }
        
        
        
        [self.navigationController pushViewController:controller animated:YES];
        
        return YES; // return YES to say we have handled the route
    }];
    
    
    [routes addRoute:@"event/navbar-action/:parsed-json"handler:^BOOL(NSDictionary *parameters) {
        NSDictionary *item;
        
        NSError * err;
        NSData *data =[parameters[@"parsed-json"] dataUsingEncoding:NSUTF8StringEncoding];
        //NSDictionary * response;
        if(data!=nil){
            item = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        }
        UIViewController *vctr =[[IntlRoutes routesForScheme:kAppDefaultScheme] visibleViewController];
        
        if ([vctr isKindOfClass:[UINavigationController class]]){
        
            UINavigationController *tabnaviviewctrl = (UINavigationController*)vctr;
            
            if ([tabnaviviewctrl.topViewController isKindOfClass:[FirstViewController class]]){
            
                [(FirstViewController *)tabnaviviewctrl.topViewController setNavigationBarItemParams:item];
            }else if ([tabnaviviewctrl.topViewController isKindOfClass:[UserViewController class]]){
            
                [(UserViewController *)tabnaviviewctrl.topViewController setNavigationBarItemParams:item];
                
            }
            //[(UserViewController *)[[IntlRoutes routesForScheme:kAppDefaultScheme] visibleViewController] setNavigationBarItemParams:item];
        }
        
        NSLog(@"item = %@",item);
        //self.navigationController
        
        
        // present UI for viewing user with ID 'userID'
        
        return YES; // return YES to say we have handled the route
    }];

    
    [routes addRoute:@"event/close" handler:^BOOL(NSDictionary *parameters) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return YES;
        
    }];
    
    [routes addRoute:@"event/did-logout" handler:^BOOL(NSDictionary *parameters) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IMLUserLogout" object:nil];
        
        return YES;
        
    }];
    

    [routes addRoute:@"login/:url" handler:^BOOL(NSDictionary *parameters) {

        NSLog(@"parameters = %@",parameters);
        
       // [[IntlRoutes routesForScheme:kAppDefaultScheme] routeURL:req.URL];

        LoginViewController *controller = [[LoginViewController alloc] initWithParams:parameters];
        
        if (controller == nil) {
            return YES;
        }
        
        // 画面遷移のアニメーションを設定
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        // UINavigationControllerに向けてモーダルで画面遷移
        [self.navigationController presentViewController:controller animated:YES completion:nil];
 

        tabBarController.selectedIndex = 0;
        
        return YES;
        
    }];

    [routes addRoute:@"event/go/:direction" handler:^BOOL(NSDictionary *parameters) {
        
        NSString *direction = parameters[@"direction"];
        
        tabBarController.selectedIndex = [direction integerValue];
        [self resetViews];
        
        return YES;
        
    }];
    

    
    [routes addRoute:@"event/authenticated" handler:^BOOL(NSDictionary *parameters) {
     
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IMLUserLogin" object:nil];
        
        return YES;
        
    }];
    

    [routes addRoute:@"event/photo-upload/:url" handler:^BOOL(NSDictionary *parameters) {
        NSLog(@"parameters = %@",parameters);
        
        
        return YES;
        
    }];
    
    
    [routes addRoute:@"event/close-modal" handler:^BOOL(NSDictionary *params) {
        
        UIViewController *controller = [[IntlRoutes routesForScheme:kAppDefaultScheme] visibleViewController];
        
        if ([controller isKindOfClass:[LoginViewController class]]) {
            
            [(LoginViewController*)controller closeMe];
        }

        
        return YES;
    }];
    
    [routes addRoute:@"event/share/:parsed-json" handler:^BOOL(NSDictionary *parameters) {
        NSDictionary *item;
        
        NSError * err;
        NSData *data =[parameters[@"parsed-json"] dataUsingEncoding:NSUTF8StringEncoding];
        //NSDictionary * response;
        if(data!=nil){
            item = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        }
        
        
        UIViewController *controller = [[IntlRoutes routesForScheme:kAppDefaultScheme] visibleViewController];
        
        if ([controller isKindOfClass:[UINavigationController class]]){
            
            UINavigationController *tabnaviviewctrl = (UINavigationController*)controller;
            
            if ([tabnaviviewctrl.topViewController isKindOfClass:[FirstViewController class]]){
                
                [(FirstViewController *)tabnaviviewctrl.topViewController showSharePanelWithJson:parameters[@"parsed-json"]];
                
            }             //[(UserViewController *)[[IntlRoutes routesForScheme:kAppDefaultScheme] visibleViewController] setNavigationBarItemParams:item];
        }
        
        if ([controller isKindOfClass:[DetailViewController class]]){
            
            [(DetailViewController *)controller showSharePanelWithJson:parameters[@"parsed-json"]];
        }

        
        
//        if ([controller isKindOfClass:[FirstViewController class]]) {
//            
//            NSLog(@"item = %@",item);
//            
//            [(FirstViewController *)controller showSharePanelWithJson:parameters[@"parsed-json"]];
//        }
//        
//        if ([controller isKindOfClass:[DetailViewController class]]) {
//            
//            NSLog(@"item = %@",item);
//            
//            [(DetailViewController *)controller showSharePanelWithJson:parameters[@"parsed-json"]];
//        }
        
        
       
        
        return YES; // return YES to say we have handled the route
    }];
    
    
    [routes addRoute:@"event/message/:type/:message" handler:^BOOL(NSDictionary *parameters) {
        
        
        NSString *typeStr = [parameters[@"type"] lowercaseString];
        NSString *message = parameters[@"message"];

        
        if ([typeStr isEqualToString:@"error"]) {
            [NonblockingAlertView showFailureAlertViewWithMessage:message];
        } else if ([typeStr isEqualToString:@"success"]) {
            [NonblockingAlertView showSuccessAlertViewWithMessage:message];
        } else if ([typeStr isEqualToString:@"warn"]) {
            [NonblockingAlertView showWarningAlertViewWithMessage:message];
        } else if ([typeStr isEqualToString:@"loading"]) {
            [NonblockingAlertView showLoadingViewWithMessage:parameters[@"message"] animated:YES blockUserInteraction:YES];
        } else {
            [NonblockingAlertView showAlertViewWithMessage:message];
        }
        
        return YES; // return YES to say we have handled the route

    }];
    
    routes.tabBarController = tabBarController;
    routes.navigationController = self.navigationController;
    

    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    NSLog(@"url = %@",url);
    
    
//    if ([IMLURLRouter fbHandleURL:app openURL:url options:options]) {
//        return YES;
//    }
    return [self handleURL:url ];
}


- (BOOL)handleURL:(NSURL *)URL {
    //LOG_MESSAGE(@"got URL: %@", URL);
    
    //return [[JLRoutes globalRoutes] routeURL:URL];
    
    if ([[URL.scheme lowercaseString] isEqualToString:kAllpayScheme]) {
        //[AllPaySDK openURL:URL];
        return YES;
    }
    
//    if (![[URL.scheme lowercaseString] isEqualToString:[IMLURLRouter defaultHandler].scheme]) {
//        BOOL forWeiXin = [[WeixinService sharedService] handleOpenURL:URL];
//        if (forWeiXin) {
//            return YES;
//        }
//    }
    
    //return [[IMLURLRouter defaultHandler] parseURL:URL];
    return YES;
    
}



@end
