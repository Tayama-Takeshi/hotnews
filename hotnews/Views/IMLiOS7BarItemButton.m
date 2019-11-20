//
//  IMLiOS7BarItemButton.m
//  NBXenophrys
//
//  Created by tym on 9/30/13.
//  Copyright (c) 2013 tym.COM. All rights reserved.
//

#import "IMLiOS7BarItemButton.h"
#import "IMLConstants.h"

@implementation IMLiOS7BarItemButton

+ (id)buttonWithType:(UIButtonType)type iOS7BarButtonType:(IMLiOS7BarItemButtonType)barButtonType {
    IMLiOS7BarItemButton *button = [IMLiOS7BarItemButton buttonWithType:type];
    button.type = barButtonType;
    return button;
}

- (UIEdgeInsets)alignmentRectInsets {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        // iOS 7 bug workaround
        if (_type == IMLiOS7BarItemButtonTypeUnknown) {
            return UIEdgeInsetsMake(-1.0f, 4.0f, 0, 0);
        }
        return UIEdgeInsetsMake(-1, (_type == IMLiOS7BarItemButtonTypeLeft ? 4.0f : 0),
                                0, (_type == IMLiOS7BarItemButtonTypeRight ? 4.0f : 0));
    }
    
    return UIEdgeInsetsMake(-1.0f, -7.0f, 0, 0);
}

@end
