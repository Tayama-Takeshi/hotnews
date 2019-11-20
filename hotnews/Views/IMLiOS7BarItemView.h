//
//  IMLiOS7BarItemView.h
//  ht-ios
//
//  Created by tym on 11/30/15.
//  Copyright (c) 2013 tym.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMLiOS7BarItemViewType) {
    IMLiOS7BarItemViewTypeUnknown = 0,
    IMLiOS7BarItemViewTypeLeft,
    IMLiOS7BarItemViewTypeRight,
};

@interface IMLiOS7BarItemView : UIView

@property (nonatomic, assign) IMLiOS7BarItemViewType type;

- (instancetype)initWithFrame:(CGRect)frame type:(IMLiOS7BarItemViewType)type;
@end
