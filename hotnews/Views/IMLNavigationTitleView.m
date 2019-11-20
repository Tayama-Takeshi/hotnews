//
//  IMLNavigationTitleView.m
//  NBXenophrys
//
//  Created by dev on 2014/02/08.
//  Copyright (c) 2014年 dev.COM. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "IMLNavigationTitleView.h"

@implementation IMLNavigationTitleView {
    UILabel *_label;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:frame];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.adjustsFontSizeToFitWidth = NO;
        _label.minimumScaleFactor = 0.8f;
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_label];
        
//        CGFloat width = [UIScreen mainScreen].bounds.size.width - 160.0;    //TODO: how about landscape mode?
//        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.lessThanOrEqualTo(@(width));
//            make.height.equalTo(@44);
//            make.center.equalTo(self);
//        }];
    }
    
    return self;
}

- (void)setAttributedText:(NSAttributedString *)text {
    _label.attributedText = text;
}

@end
