//
//  UIApplication+MultiLanguage.m
//  rbms-iOS
//
//  Created by tym on 2016/11/01.
//  Copyright © 2016年 rbms. All rights reserved.
//

#import "UIApplication+MultiLanguage.h"
#import "UIApplication+IMLAppInfo.h"
#import "NSString+MD5.h"
#import "IMLExternConstants.h"
//#import "IMLURLRouter.h"
#import "IMLConstants.h"

@implementation UIApplication (MultiLanguage)

+ (void)resetUAWithLanguage:(NSString *)la {
    NSString *defaultUserAgent = [[[UIWebView alloc] initWithFrame:CGRectZero] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSRange range = [defaultUserAgent rangeOfString:kUAClientString];
    if (range.location != NSNotFound) {
        defaultUserAgent = [defaultUserAgent substringWithRange:NSMakeRange(0, range.location)];
    }
    
    NSString *clientKey = [[[[[UIDevice currentDevice] identifierForVendor] UUIDString] md5] substringToIndex:12];
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSString *agent = [NSString stringWithFormat:@" %@/%@/%@/%@/%@ iOS/%@",
                       kUAClientString,
                       [UIApplication appVersion],
                       [UIApplication appBuildVersion],
                       la,
                       clientKey,
                       systemVersion];
    agent = [defaultUserAgent stringByAppendingString:agent];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": agent}];
    ////LOG_MESSAGE(@"Use app scope User-Agent: %@", agent);

}

+ (void)prepareAPI {
    NSString *setLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    if (!setLanguage) {
        setLanguage = [[NSLocale preferredLanguages] firstObject];
    }
    
    [self resetUAWithLanguage:setLanguage];
    
    // Faster access for resources that NSURLProtocol won't handle
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 * 16 // 16MB
                                                      diskCapacity:1000 * 1000 * 128 // 128MB (The New Apple Style Disk Size)
                                                          diskPath:@"NSURLCache"];
    [NSURLCache setSharedURLCache:cache];
}

+ (void)prepareLanguage {
    NSString *settingLa = [[NSUserDefaults standardUserDefaults] objectForKey:@"setting-language"];
    if (settingLa) {
        [[NSUserDefaults standardUserDefaults] setObject:settingLa forKey:@"language"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setting-language"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[[IMLURLRouter defaultHandler] sendInfoMessage:M(@"msg.current-language.set")];
            //make sure this is running after router is inited
        });
    }
}

+ (void)resetLanguage:(NSString *)language {
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"setting-language"];
}

+ (NSString *)localizeCode {
    NSString *la = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    if (!la) {
        la = [[NSLocale preferredLanguages] firstObject];
    }
    
    NSString *lowcast = [la lowercaseString];
    if ([lowcast hasPrefix:@"zh-"]) {
        if ([lowcast hasPrefix:@"zh-hans"]) {
            la = @"cn";
        } else {
            la = @"tw";
        }
    } else if ([la length] >= 2) {
        la = [la substringToIndex:2];
    }
    
    if (![la isEqualToString:@"cn"] &&
        ![la isEqualToString:@"tw"] &&
        ![la isEqualToString:@"ja"] &&
        ![la isEqualToString:@"en"]) {
        return @"cn";
    }
    return la;
}

+ (NSBundle *)localizeBundle {
    NSString *la = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    if (!la) {
        la = [[NSLocale preferredLanguages] firstObject];
    }
    
    NSString *lowcast = [la lowercaseString];
    if ([lowcast hasPrefix:@"zh-"] || [lowcast isEqualToString:@"cn"] || [lowcast isEqualToString:@"tw"]) {
        if ([lowcast isEqualToString:@"cn"] || [lowcast hasPrefix:@"zh-hans"]) {
            la = @"zh-Hans";
        } else {
            la = @"zh-Hant";
        }
    } else if ([la length] >= 2) {
        la = [la substringToIndex:2];
    }
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:la ofType:@"lproj"]];
    if (!bundle) {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"]];
    }
    return bundle;
}

+ (NSString *)getLocaleTitleWith:(NSDictionary *)params {
    NSString *localizeCode = [UIApplication localizeCode];
    NSArray *keys = @[@"nav-title", @"title"];
    for (NSString *key in keys) {
        NSString *localizeKey = [key stringByAppendingString:@"-i18n"];
        if (params[localizeKey]) {
            if (params[localizeKey][localizeCode]) {
                return params[localizeKey][localizeCode];
            }
        }
        if (params[key]){
            return params[key];
        }
    }
    return nil;
}
@end
