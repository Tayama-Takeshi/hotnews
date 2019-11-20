//
//  IMLiOS7BarItemView.m
//  ht-ios
//
//  Created by tym on 11/30/15.
//  Copyright (c) 2013 tym.COM. All rights reserved.
//

#import "IMLiOS7BarItemView.h"

@implementation IMLiOS7BarItemView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self init];
}

- (instancetype)init {
    NSAssert(NO, @"You should always use initWithFrame:type: to initialize");
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (instancetype)initWithFrame:(CGRect)frame type:(IMLiOS7BarItemViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
    }
    return self;
}

// Look like the workaround will cause some spaces cannot be clicked.
//- (UIEdgeInsets)alignmentRectInsets {
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        // iOS 7 bug workaround
//        return UIEdgeInsetsMake(0, (_type == IMLiOS7BarItemViewTypeLeft ? 10.0f : 0),
//                                0, (_type == IMLiOS7BarItemViewTypeRight ? -10.0f : 0));
//    }
//    return UIEdgeInsetsZero;
//}

@end
