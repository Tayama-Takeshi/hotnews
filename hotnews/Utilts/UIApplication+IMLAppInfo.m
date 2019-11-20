//
//  UIApplication(IMLAppInfo)
//
//  Created by tym on 2014/03/21.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//

#import "UIApplication+IMLAppInfo.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIApplication (IMLAppInfo)

+ (NSString *)appVersion {
    static NSString *appVersion = nil;
    if (!appVersion) {
        appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    }
    return appVersion;
}

+ (NSString *)appBuildVersion {
    static NSString *appBuildVersion = nil;
    if (!appBuildVersion) {
        appBuildVersion = [[NSBundle mainBundle] infoDictionary][(NSString *) kCFBundleVersionKey];
    }
    return appBuildVersion;
}

+ (NSString *)appName {
    static NSString *appName = nil;
    if (!appName) {
        appName = [[NSBundle mainBundle] localizedInfoDictionary][@"CFBundleDisplayName"];
        if (!appName) {
            appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
        }
    }
    return appName;
}

+ (NSString *)appBundleId {
    static NSString *appBundleId = nil;
    if (!appBundleId) {
        appBundleId = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleIdentifierKey];
    }
    return appBundleId;
}

+ (NSString *)hwMachine {
    int mib[2];
    size_t len;
    char *p;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    p = malloc(len);
    sysctl(mib, 2, p, &len, NULL, 0);
    
    NSString *s = [NSString stringWithCString:p
                                     encoding:NSUTF8StringEncoding];
    free(p);
    return s;
}

@end
