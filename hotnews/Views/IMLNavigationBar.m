//
//  IMLNavigationBar.m
//  NBXenophrys
//
//  Created by tym on 2014/02/05.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//

#import "IMLNavigationBar.h"

@interface IMLNavigationBar () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation IMLNavigationBar {
    UIPanGestureRecognizer *_panGesture;
    NSTimer *_checkTimer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initGesture];
    }
    return self;
}

- (void)initGesture {
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _panGesture.delegate = self;
    _fadeOut = YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    if (!self.scrollView || _panGesture.view != self.scrollView) {
        return;
    }
    
    if (panGesture.state != UIGestureRecognizerStateChanged) {
        return;
    }
    
    BOOL fadeOut;
    if ([panGesture velocityInView:self.scrollView].y > 400 && _scrollView.contentOffset.y < _scrollView.contentSize.height - _scrollView.frame.size.height) {
        fadeOut = YES;
    } else if ([panGesture velocityInView:self.scrollView].y < 0 && _scrollView.contentOffset.y > 0.0) {
        fadeOut = NO;
    } else {
        return;
    }
    
    if (fadeOut != _fadeOut) {
        [self setFadeOut:fadeOut animated:YES];
        NSLog(@"fadeOut %d", _fadeOut);
    }
    
}

- (void)scrollViewChecking {
    if (_scrollView.isDragging || _scrollView.isTracking || _scrollView.isDecelerating) {
//        NSLog(@"scrolling");
    }
}

- (void)setGestureOversever:(UIScrollView *)scrollView {
    if (_panGesture.view) {
        [_panGesture.view removeGestureRecognizer:_panGesture];
    }
    
    if ([_checkTimer isValid]) {
        [_checkTimer invalidate];
    }
    
    if (scrollView) {
        [scrollView addGestureRecognizer:_panGesture];
        _checkTimer = [NSTimer timerWithTimeInterval:0.42 target:self selector:@selector(scrollViewChecking) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_checkTimer forMode:NSRunLoopCommonModes];
    }
    
    _scrollView = scrollView;
}

- (void)setFadeOut:(BOOL)fadeOut animated:(BOOL)animated {
    _fadeOut = fadeOut;
    [UIView beginAnimations:@"FadeAnimations" context:nil];
    [UIView setAnimationDuration:animated ? 0.2 : 0.0];
    
    self.frame = CGRectMake(0.0, fadeOut ? 20.0 : -24.0, self.bounds.size.width, self.bounds.size.height);
    
    CGFloat value = fadeOut ? 1.0 : 0.0;
    for (UIView *view in self.subviews) {
        if (![[[view class] description] containsString:@"UINavigationBarBackground"] &&
            ![[[view class] description] containsString:@"UINavigationBarBackIndicatorView"]) {
            view.alpha = value;
        }
    }

    [UIView commitAnimations];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNavbarFrameDidChange object:@{@"frame": NSStringFromCGRect(self.frame), @"animated": [NSNumber numberWithBool:animated]}];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
