//
//  UIApplication(IMLAppInfo)
//
//  Created by tym on 2014/03/21.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface UIApplication (IMLAppInfo)

+ (NSString *)appVersion;
+ (NSString *)appBuildVersion;
+ (NSString *)appName;
+ (NSString *)appBundleId;

+ (NSString *)hwMachine;
@end
