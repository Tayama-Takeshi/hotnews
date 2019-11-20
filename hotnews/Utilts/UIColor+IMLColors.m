//
//  UIColor(IMLColors)
//
// Created by tym on 2014/03/27.
// Copyright (c) 2014 tym.COM. All rights reserved.
//

#import "UIColor+IMLColors.h"
#import "HexColors.h"

@implementation UIColor (IMLColors)

+ (UIColor *)mainColor {
    return [UIColor clearColor];
}

+ (UIColor *)mainColorInBarTintColor {
    return nil;
}

+ (UIColor *)highlightColor {
    return [UIColor hx_colorWithHexRGBAString:@"ea2e49"];
}

+ (UIColor *)foregroundColor {
    return [UIColor hx_colorWithHexRGBAString:@"333333"];
}





+ (UIColor *)lightColor {
    return [UIColor hx_colorWithHexRGBAString:@"ddd"];
}

+ (UIColor *)subColor {
    return [UIColor hx_colorWithHexRGBAString:@"404040"];
}

+ (UIColor *)panelBackgroundColor {
    return [UIColor colorWithRed:0.93f green:0.93f blue:0.89f alpha:1.00f];
}

+ (UIColor *)webViewBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)blackWebViewBackgroundColor {
    return [self colorWithWhite:0.95f alpha:1.0f];
}

+ (UIColor *)unreadIconColor {
    return [self mainColor];
}

+ (UIColor *)sharePanelBGColor {
    return [UIColor hx_colorWithHexRGBAString:@"f5f5f5" alpha:0.7f];
    //return [self whiteColor];
}

+ (UIColor *)darkFontColor {
    return [UIColor hx_colorWithHexRGBAString:@"999"];
}

@end
