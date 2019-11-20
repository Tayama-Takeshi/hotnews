//
//  NonblockingView.m
//
//  Created by tym on 05/01/14.
//  Copyright 2014 dev.COM. All rights reserved.
//

#import "NonblockingView.h"

#define kAnimationDuration  0.3

@interface NonblockingView ()
@property (nonatomic, weak) UIView *userInteractionBlockedView;
@end

@implementation NonblockingView {
    NSTimeInterval _autoHideAfter;
}

- (void)didHide {
    // do nothing, just for override
}

- (void)showMessageView:(BOOL)animated autoHideAfter:(NSTimeInterval)time {
    // set 0.0 if you don't need auto hide
    // set -1.0 if you want to use auto count hide time
    if (!self.hidden) {
        return;
    }
    if (time < 0.0) {
        time = _autoCountHideTime;
    }
    self.hidden = NO;
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:animated ? kAnimationDuration : 0.0 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (time > 0.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideMessageView:YES];
            });
        }
        if (_messageDidShowBlock) {
            _messageDidShowBlock(animated);
        }
        if (_delegate && [_delegate respondsToSelector:@selector(messageDidShow:animated:)]) {
            [_delegate messageDidShow:self animated:YES];
        }
    }];
}

- (void)hideMessageView:(BOOL)animated {
    if (self.hidden) {
        return;
    }
    
    [UIView animateWithDuration:animated ? kAnimationDuration : 0.0 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        self.hidden = YES;
        if (_messageDidHideBlock) {
            _messageDidHideBlock(animated);
        }
        if (_delegate && [_delegate respondsToSelector:@selector(messageDidHide:animated:)]) {
            [_delegate messageDidHide:self animated:YES];
        }
        if (_autoRemoveFromSuperview) {
            self.delegate = nil;
            [self removeFromSuperview];
        }
        [self didHide];
    }];
}

- (void)show {
    [self showMessageView:NO autoHideAfter:0.0];
}

- (void)hide {
    [self hideMessageView:NO];
}

@end
