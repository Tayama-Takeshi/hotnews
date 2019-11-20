//
//  IMLConstants.h
//  ht-ios
//
//  Created by tym on 4/24/14.
//  Copyright (c) 2014 tym.COM. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef IMLConstants_h
#define IMLConstants_h

//////////////////////////////////////////
// Network Related
//////////////////////////////////////////
//#   define kBaseHostName  @"localhost"
//#   define kBaseHostName  @"10.0.1.2"
//#   define kBaseHostName  @"192.168.2.104"
//#   define kBaseHostSchema @"http://"
//#   define kBaseHostPort @":3020"

#   define kBaseHostSchema @"http://"
#ifdef IN_HOUSE
#   define kBaseHostName  @"xxxxx.stg.aaa.com"
//#   define kBaseHostPort ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_preference"] ? @":3000" : @":3000")    // You should add ":" before port number. For example: @":3000"
#   define kBaseHostPort ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_preference"] ? @"" : @"")    // You should add ":" before port number. For example: @":3000"
#elif defined(DEBUG)
#   define kBaseHostName  @"xxxxx.stg.aaa.com"
//#   define kBaseHostPort @":3020"    // You should add ":" before port number. For example: @":3000"
#   define kBaseHostPort @""    // You should add ":" before port number. For example: @":3000"
#else
#   define kBaseHostName  @"xxxxx.stg.aaa.com"
#   define kBaseHostPort @""    // You should add ":" before port number. For example: @":3000"
#endif

#define kBaseURL    [(kBaseHostSchema kBaseHostName) stringByAppendingString:kBaseHostPort]

#import "IMLExternConstants.h"

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve)
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
    }
}

//////////////////////////////////////////
// Global Functions
//////////////////////////////////////////
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define I_AM_IPAD()                                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define NSLOG_CURRENT_METHOD(c)                     NSLog(@"%@ %@", NSStringFromClass(c), NSStringFromSelector(_cmd))
#define LOG_MESSAGE_CURRENT_METHOD(c)               //LOG_MESSAGE(@"%@ %@", NSStringFromClass(c), NSStringFromSelector(_cmd))

#define kChineseBoldFont(s) [UIFont systemFontOfSize:s]
#define kChineseFont(s) [UIFont systemFontOfSize:s]
#define kEnglishThinFont(s) [UIFont systemFontOfSize:s]
#define kEnglishFont(s) [UIFont systemFontOfSize:s]
#define kNavbarTitleAttributes @{NSFontAttributeName : kChineseFont(20.0), NSForegroundColorAttributeName : [UIColor darkGrayColor], NSShadowAttributeName : [UIColor whiteColor]}

#define M(K) NSLocalizedStringFromTableInBundle(K, @"Localizable", [UIApplication localizeBundle], nil)

#define AESKEY() @""
#endif
