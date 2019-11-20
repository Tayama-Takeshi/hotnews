//
//  NonblockingAlertView.h
//
//  Created by tym on 05/01/14.
//  Copyright 2014 dev.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NonblockingView.h"

@protocol NonblockingAlertIndicatorViewDelegate <NSObject>

@optional
- (void)startAnimating;
- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped;

@end

@interface NonblockingAlertView : NonblockingView
@property(nonatomic, readonly)UIView *contentView;

- (instancetype)initWithMessage:(NSString *)message;
- (instancetype)initWithMessage:(NSString *)message image:(UIImage *)image;
- (instancetype)initWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator;
- (instancetype)initWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator backgroundColor:(UIColor *)bgColor;

+ (void)showAlertViewWithMessage:(NSString *)message;
+ (void)showAlertViewWithMessage:(NSString *)message animated:(BOOL)animated;
+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image;
+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image animated:(BOOL)animated;
+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator;
+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator animated:(BOOL)animated;
+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator animated:(BOOL)animated blockUserInteraction:(BOOL)blockUserInteraction;
+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator animated:(BOOL)animated backgroundColor:(UIColor *)bgColor;
+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator animated:(BOOL)animated backgroundColor:(UIColor *)bgColor blockUserInteraction:(BOOL)blockUserInteraction;
+ (void)showFailureAlertViewWithMessage:(NSString *)message;
+ (void)showFailureAlertViewWithMessage:(NSString *)message animated:(BOOL)animated;
+ (void)showSuccessAlertViewWithMessage:(NSString *)message;
+ (void)showSuccessAlertViewWithMessage:(NSString *)message animated:(BOOL)animated;
+ (void)showWarningAlertViewWithMessage:(NSString *)message animated:(BOOL)animated;
+ (void)showWarningAlertViewWithMessage:(NSString *)message;
+ (void)showLoadingViewWithMessage:(NSString *)message;
+ (void)showLoadingViewWithMessage:(NSString *)message animated:(BOOL)animated;
+ (void)showLoadingViewWithMessage:(NSString *)message animated:(BOOL)animated blockUserInteraction:(BOOL)blockUserInteraction;
+ (void)hide:(BOOL)animated;
+ (void)setLabelFont:(UIFont *)font;
+ (void)setLabelTextColor:(UIColor *)color;
@end
