//
//  NonblockingView.h
//
//  Created by tym on 05/01/14.
//  Copyright 2014 dev.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NonblockingViewDelegate;
//@protocol MMLHUDViewProtocol;

@interface NonblockingView : UIView 

@property (nonatomic, weak) id<NonblockingViewDelegate> delegate;
@property (nonatomic, assign) BOOL autoRemoveFromSuperview;
@property (nonatomic, assign) NSTimeInterval autoCountHideTime;
@property (nonatomic, weak, readonly) UIView *userInteractionBlockedView;

@property (nonatomic, strong) void (^messageDidShowBlock)(BOOL animated);
@property (nonatomic, strong) void (^messageDidHideBlock)(BOOL animated);

- (void)showMessageView:(BOOL)animated autoHideAfter:(NSTimeInterval)time;
- (void)hideMessageView:(BOOL)animated;
- (void)show;
- (void)hide;

//! @abstract Do nothing, just for override
- (void)didHide;

@end

@protocol NonblockingViewDelegate <NSObject>
@optional
- (void)messageDidHide:(NonblockingView *)aView animated:(BOOL)animated;
- (void)messageDidShow:(NonblockingView *)aView animated:(BOOL)animated;
@end
