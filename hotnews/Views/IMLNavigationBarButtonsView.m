//
//  IMLNavigationBarButtonsView.h
//  ht-ios
//
//  Created by tym on 11/30/15.
//  Copyright (c) 2013 tym.COM. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "IMLNavigationBarButtonsView.h"

@implementation IMLNavigationBarButtonsView {
    MASConstraint *_lastEdge;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(false, @"use -initWithFrame:type: insdead");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame type:(IMLiOS7BarItemViewType)type {
    self = [super initWithFrame:frame type:type];
    if (self) {
        _items = [NSMutableArray new];
        _itemParams = [NSMutableArray new];
        _itemWithKeys = [NSMutableDictionary new];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self systemLayoutSizeFittingSize:CGSizeMake(320, frame.size.height)];
    }
    return self;
}

- (void)addItem:(UIView *)view withParams:(NSDictionary *)params baseOnRight:(BOOL)right {
    id constraint = nil;
    CGFloat offset = 0;
    if ([_items count]) {
        if (right) {
            constraint = ((UIView *)[_items lastObject]).mas_left;
        } else {
            constraint = ((UIView *)[_items lastObject]).mas_right;
        }
    } else {
        constraint = self;
        offset = 0;
    }
    [self addSubview:view];
    
    [_lastEdge uninstall];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@(view.frame.size.width)).priorityHigh();
        make.height.equalTo(@(view.frame.size.height)).priorityHigh();
        if (right) {
            make.right.equalTo(constraint).with.offset(- offset);
            _lastEdge = make.left.equalTo(self);
        } else {
            make.left.equalTo(constraint).with.offset(offset);
            _lastEdge = make.right.equalTo(self);
        }
    }];
    
    [_items addObject:view];
    [_itemParams addObject:params];
    [_itemWithKeys setObject:view forKey:params[@"action-name"]];
    
    CGRect f = self.frame;
    f.size = [self systemLayoutSizeFittingSize:CGSizeMake(320, self.frame.size.height)];
    self.frame = f;
}

- (void)updateItemFrame {
    for (int i = 0; i < [_items count]; i++) {
        UIView *view = _items[i];
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(view.frame.size.width)).priorityHigh();
        }];
    }
    
    CGRect f = self.bounds;
    f.size = [self systemLayoutSizeFittingSize:CGSizeMake(320, self.frame.size.height)];
    self.bounds = f;
}

- (void)removeAllButtons {
    [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(UIView *)obj removeFromSuperview];
    }];
    [_items removeAllObjects];
    [_itemWithKeys removeAllObjects];
    [_itemParams removeAllObjects];
    
    [self updateItemFrame];
}

@end
