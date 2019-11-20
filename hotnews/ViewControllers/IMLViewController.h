//
//  IMLViewController
//
//  Created by tym on 2014/03/30.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "IMLViewController+WrapNavigationController.h"

@interface IMLViewController : UIViewController

@property (nonatomic, strong) NSString *defaultTitle;
@property (nonatomic, assign) BOOL navigationBarHidden;

@property (nonatomic, assign) IMLBackButtonStyle backButtonStyle;

@end
