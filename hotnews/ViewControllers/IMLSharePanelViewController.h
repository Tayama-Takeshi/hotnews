//
//  IMLSharePanelViewController.h
//  NBXenophrys
//
//  Created by tym on 3/19/14.
//  Copyright (c) 2014 dev.COM. All rights reserved.
//

#import "IMLViewController.h"

@interface IMLSharePanelViewController : IMLViewController

@property (nonatomic, strong) UIPopoverController *popOverController;
@property (nonatomic, strong, readonly) UIWindow *window;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *URLs;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *shareFromInfo;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, assign) BOOL statusBarPreferHidden;

- (void)close:(void(^)(void))completion;
- (void)show:(void(^)(void))completion;
@end
