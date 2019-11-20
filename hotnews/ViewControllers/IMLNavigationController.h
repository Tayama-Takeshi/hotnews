//
//  IMLNavigationController.h
//  NBXenophrys
//
//  Created by tym on 10/11/13.
//  Copyright (c) 2014 tym.COM. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface IMLNavigationController : UINavigationController

@property (nonatomic, copy) void(^viewControllersStackChangeCompletionBlock)(void);
@end
