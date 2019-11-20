//
//  UIApplication+MultiLanguage.h
//  rbms-iOS
//
//  Created by tym on 2016/11/01.
//  Copyright © 2016年 rbms. All rights reserved.
//

#import "AppDelegate.h"

@interface UIApplication (MultiLanguage)

+ (void)prepareAPI;
+ (void)prepareLanguage;
+ (void)resetLanguage:(NSString *)language;
+ (NSBundle *)localizeBundle;
+ (NSString *)getLocaleTitleWith:(NSDictionary *)params;
@end
