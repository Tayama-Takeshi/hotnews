//
//  NonblockingAlertView.m
//
//  Created by tym on 05/01/14.
//  Copyright 2014 dev.COM. All rights reserved.
//

#import "NonblockingAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "IMLConstants.h"

#define kLabelPadding           20.0
#define kLabelPadding_iPad      40.0
#define kItemSpacing             5.0
#define kDefaultBGColor         [UIColor colorWithWhite:0.0 alpha:0.6]

#define NBAV_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define NBAV_I_AM_IPAD()                                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

static __strong NonblockingAlertView *__currentNonblockAlertView = nil;
static __strong NonblockingAlertView *__curentNonblockLoadingView = nil;
static __strong UIFont *__labelFont = nil;
static __strong UIColor *__textColor = nil;

@interface NonblockingView (PrivateMethods)
@property (nonatomic, weak) UIView *userInteractionBlockedView;
@end

@implementation NonblockingAlertView

+ (void)setLabelFont:(UIFont *)font {
    __labelFont = font;
}

+ (void)setLabelTextColor:(UIColor *)color {
    __textColor = color;
}

- (instancetype)initWithMessage:(NSString *)message {
    return [self initWithMessage:message image:nil];
}

- (instancetype)initWithMessage:(NSString *)message image:(UIImage *)image {
    return [self initWithMessage:message image:image indicatorView:nil];
}

- (instancetype)initWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator {
    return [self initWithMessage:message image:image indicatorView:indicator backgroundColor:kDefaultBGColor];
}

- (instancetype)initWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator backgroundColor:(UIColor *)bgColor {
    if ((self = [super initWithFrame:CGRectZero])) {
        self.userInteractionEnabled = NO;
        self.hidden = YES;
        self.autoCountHideTime = 0.0;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _contentView = self;
        if (NBAV_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            self.backgroundColor = [UIColor clearColor];
            if (bgColor) {
                UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
                UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                blurView.frame = self.bounds;
                blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [self insertSubview:blurView atIndex:0];
                
                UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:blurEffect]];
                vibrancyEffectView.frame = blurView.bounds;
                vibrancyEffectView.autoresizingMask = blurView.autoresizingMask;
                [blurView.contentView addSubview:vibrancyEffectView];
                
                _contentView = vibrancyEffectView.contentView;
            }
        } else {
            self.backgroundColor = bgColor;
        }
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        UIFont *labelFont = __labelFont ? __labelFont : kChineseFont(14);
        CGSize maxSize = CGSizeMake(160.0, 200.0);
        CGSize labelSize = CGSizeZero;
        if (message) {
            
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
            NSDictionary *attributes = @{NSFontAttributeName: labelFont};
            labelSize = [message boundingRectWithSize:maxSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil].size;
#else
            if (NBAV_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                NSDictionary *attributes = @{NSFontAttributeName: labelFont};
                labelSize = [message boundingRectWithSize:maxSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil].size;
            } else {
                labelSize = [message sizeWithFont:labelFont
                                constrainedToSize:maxSize
                                    lineBreakMode:NSLineBreakByWordWrapping];
            }            labelSize = CGSizeMake(ceilf(labelSize.width), ceilf(labelSize.height));
#endif
            labelSize = CGSizeMake(ceilf(labelSize.width), ceilf(labelSize.height));
        }
        
        CGRect f = self.frame;
        CGFloat padding = NBAV_I_AM_IPAD() ? kLabelPadding_iPad : kLabelPadding;
        CGFloat yOffset = padding;
        if (indicator) {
            f.size = CGSizeMake(MAX(labelSize.width, indicator.bounds.size.width) + padding * 2.0,
                                labelSize.height + indicator.bounds.size.height + padding + kItemSpacing);
            indicator.frame = CGRectMake(ceilf((f.size.width - indicator.frame.size.width) * 0.5), ceilf(padding * 0.5), indicator.bounds.size.width, indicator.bounds.size.height);
            if ([indicator respondsToSelector:@selector(setHidesWhenStopped:)]) {
                indicator.hidesWhenStopped = YES;
            }
            [self addSubview:indicator];
            if ([indicator respondsToSelector:@selector(startAnimating)]) {
                [indicator startAnimating];
            }
            yOffset = CGRectGetMaxY(indicator.frame) + kItemSpacing;
        } else if (image) {
            f.size = CGSizeMake(MAX(labelSize.width, image.size.width) + padding * 2.0,
                                labelSize.height + image.size.height + padding + kItemSpacing);
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(ceilf((f.size.width - image.size.width) * 0.5), ceilf(padding * 0.5), image.size.width, image.size.height);
            [self addSubview:imageView];
            yOffset = CGRectGetMaxY(imageView.frame) + kItemSpacing;
        } else {
            f.size = CGSizeMake(labelSize.width + padding * 2.0, labelSize.height + padding * 2.0);
        }
        self.frame = f;
        
        if (message) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, yOffset, f.size.width - padding * 2.0, labelSize.height)];
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.numberOfLines = 0;
            label.font = labelFont;
            if (__textColor) {
                label.textColor = __textColor;
            } else {
                if (NBAV_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    label.textColor = [UIColor darkGrayColor];
                } else {
                    label.textColor = [UIColor whiteColor];
                }
            }
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = message;
            
            [self addSubview:label];
            
            // auto count hide time
            self.autoCountHideTime = MAX(round(MAX(round(labelSize.height / [labelFont lineHeight]), 1.0) * 0.75), 1.0);
        }
    }
    return self;
}

- (void)didHide {
    if ([self isEqual:__currentNonblockAlertView]) __currentNonblockAlertView = nil;
    if ([self isEqual:__curentNonblockLoadingView]) __curentNonblockLoadingView = nil;
}

+ (void)showAlertViewWithMessage:(NSString *)message {
    [self showAlertViewWithMessage:message animated:YES];
}

+ (void)showAlertViewWithMessage:(NSString *)message animated:(BOOL)animated {
    [self showAlertViewWithMessage:message image:nil animated:animated];
}

+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator {
    [self showAlertViewWithMessage:message image:image indicatorView:indicator animated:YES];
}

+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image {
    [self showAlertViewWithMessage:message image:image animated:YES];
}

+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image animated:(BOOL)animated {
    [self showAlertViewWithMessage:message image:image indicatorView:nil animated:animated];
}

+ (void)showFailureAlertViewWithMessage:(NSString *)message {
    [self showFailureAlertViewWithMessage:message animated:YES];
}

+ (void)showWarningAlertViewWithMessage:(NSString *)message animated:(BOOL)animated {
//    FAKIonIcons *warning = [FAKIonIcons alertCircledIconWithSize:28];
//    [warning addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
//    [self showAlertViewWithMessage:message image:[UIImage imageWithStackedIcons:@[warning] imageSize:CGSizeMake(40, 40)] animated:animated];
    [self showAlertViewWithMessage:message image:nil animated:animated];
}

+ (void)showWarningAlertViewWithMessage:(NSString *)message {
    [self showWarningAlertViewWithMessage:message animated:YES];
}

+ (void)showFailureAlertViewWithMessage:(NSString *)message animated:(BOOL)animated {
//    FAKIonIcons *failed = [FAKIonIcons closeRoundIconWithSize:28];
//    [failed addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
//    [self showAlertViewWithMessage:message image:[UIImage imageWithStackedIcons:@[failed] imageSize:CGSizeMake(40, 40)] animated:animated];
    [self showAlertViewWithMessage:message image:nil animated:animated];
}

+ (void)showSuccessAlertViewWithMessage:(NSString *)message {
    [self showSuccessAlertViewWithMessage:message animated:YES];
}

+ (void)showSuccessAlertViewWithMessage:(NSString *)message animated:(BOOL)animated {
//    FAKIonIcons *success = [FAKIonIcons checkmarkRoundIconWithSize:28];
//    [success addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
//    [self showAlertViewWithMessage:message image:[UIImage imageWithStackedIcons:@[success] imageSize:CGSizeMake(40, 40)] animated:animated];
    [self showAlertViewWithMessage:message image:nil animated:animated];
}

+ (void)showLoadingViewWithMessage:(NSString *)message {
    [self showLoadingViewWithMessage:message animated:YES];
}

+ (void)showLoadingViewWithMessage:(NSString *)message animated:(BOOL)animated {
    [self showLoadingViewWithMessage:message animated:animated blockUserInteraction:NO];
}

+ (void)showLoadingViewWithMessage:(NSString *)message animated:(BOOL)animated blockUserInteraction:(BOOL)blockUserInteraction {
    [self showAlertViewWithMessage:message
                             image:nil
                     indicatorView:(UIActivityIndicatorView<NonblockingAlertIndicatorViewDelegate> *)[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]
                          animated:animated
              blockUserInteraction:blockUserInteraction];
}

+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator animated:(BOOL)animated {
    [self showAlertViewWithMessage:message image:image indicatorView:indicator animated:animated backgroundColor:kDefaultBGColor];
}

+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator animated:(BOOL)animated blockUserInteraction:(BOOL)blockUserInteraction {
    [self showAlertViewWithMessage:message image:image indicatorView:indicator animated:animated backgroundColor:kDefaultBGColor blockUserInteraction:blockUserInteraction];
}

+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator animated:(BOOL)animated backgroundColor:(UIColor *)bgColor {
    [self showAlertViewWithMessage:message image:image indicatorView:indicator animated:animated backgroundColor:bgColor blockUserInteraction:NO];
}

+ (void)showAlertViewWithMessage:(NSString *)message image:(UIImage *)image indicatorView:(UIView<NonblockingAlertIndicatorViewDelegate> *)indicator animated:(BOOL)animated backgroundColor:(UIColor *)bgColor blockUserInteraction:(BOOL)blockUserInteraction {
    
    if ((!message || [message length] == 0) && !image && !indicator) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (!controller) {
            return;
        }
        if (controller.presentedViewController) {
            controller = controller.presentedViewController;
        }
        UIView *view = controller.view;
        if (!view) {
            return;
        }
        if (__currentNonblockAlertView || __curentNonblockLoadingView) {
            [self hide:YES];
        }
        NonblockingAlertView *alertView = [[NonblockingAlertView alloc] initWithMessage:message image:image indicatorView:indicator backgroundColor:bgColor];
        [view addSubview:alertView];
        if (blockUserInteraction) {
            view.userInteractionEnabled = !blockUserInteraction;
            alertView.userInteractionBlockedView = view;
        }
        if (indicator) {
            __curentNonblockLoadingView = alertView;
        } else {
            __currentNonblockAlertView = alertView;
        }
        alertView.autoRemoveFromSuperview = YES;
        alertView.center = CGPointMake(ceilf(CGRectGetMidX(view.bounds)), ceilf(CGRectGetMidY(view.bounds)));
        
        [alertView showMessageView:animated autoHideAfter:indicator ? 0.0 : -1.0];
    });
}

+ (void)hide:(BOOL)animated {
    if (__curentNonblockLoadingView) {
        [__curentNonblockLoadingView hideMessageView:animated];
        
        if (__curentNonblockLoadingView.userInteractionBlockedView) {
            __curentNonblockLoadingView.userInteractionBlockedView.userInteractionEnabled = YES;
            __curentNonblockLoadingView.userInteractionBlockedView = nil;
        }
    }
    if (__currentNonblockAlertView) {
        [__currentNonblockAlertView hideMessageView:animated];
        
        if (__currentNonblockAlertView.userInteractionBlockedView) {
            __currentNonblockAlertView.userInteractionBlockedView.userInteractionEnabled = YES;
            __currentNonblockAlertView.userInteractionBlockedView = nil;
        }
    }
}

@end
