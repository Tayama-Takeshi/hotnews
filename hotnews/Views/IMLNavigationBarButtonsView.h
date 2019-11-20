//
//  IMLNavigationBarButtonsView.h
//  ht-ios
//
//  Created by tym on 11/30/15.
//  Copyright (c) 2013 tym.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMLiOS7BarItemView.h"

@interface IMLNavigationBarButtonsView : IMLiOS7BarItemView
@property (nonatomic, readonly) NSMutableArray *items;
@property (nonatomic, readonly) NSMutableArray *itemParams;
@property (nonatomic, readonly) NSMutableDictionary *itemWithKeys;

- (instancetype)initWithFrame:(CGRect)frame type:(IMLiOS7BarItemViewType)type;
- (void)addItem:(UIView *)view withParams:(NSDictionary *)params baseOnRight:(BOOL)right;
- (void)removeAllButtons;
- (void)updateItemFrame;
@end
