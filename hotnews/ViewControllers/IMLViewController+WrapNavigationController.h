//
//  IMLViewController+WrapNavigationController.h
//  iCart
//
//  Created by tym on 2013/11/28.
//  Copyright (c) 2014年 tym.COM. All rights reserved.
//

typedef NS_ENUM(NSInteger, IMLBackButtonStyle) {
    IMLBackButtonStyleNone = -1,
    IMLBackButtonStyleNormal = 0
};

@interface UIViewController (IMLViewController_WrapNavigationController)

- (UINavigationController *)wrapByNavigationController;

@end
