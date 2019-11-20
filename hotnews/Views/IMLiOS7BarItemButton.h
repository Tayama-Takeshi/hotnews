//
//  IMLiOS7BarItemButton.h
//  NBXenophrys
//
//  Created by tym on 9/30/13.
//  Copyright (c) 2013 tym.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMLiOS7BarItemButtonType) {
    IMLiOS7BarItemButtonTypeUnknown = 0,
    IMLiOS7BarItemButtonTypeLeft,
    IMLiOS7BarItemButtonTypeRight,
};

@interface IMLiOS7BarItemButton : UIButton

@property (nonatomic, assign) IMLiOS7BarItemButtonType type;

+ (instancetype)buttonWithType:(UIButtonType)type iOS7BarButtonType:(IMLiOS7BarItemButtonType)barButtonType;

@end
