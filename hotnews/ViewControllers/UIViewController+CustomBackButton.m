//
//  UIViewController+CustomBackButton.m
//  iDaily
//
//  Created by James Chen on 7/26/10.
//  Copyright (c) 2015 dev.COM. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIViewController+CustomBackButton.h"
#import "IMLiOS7BarItemButton.h"
#import "IMLViewController+WrapNavigationController.h"
#import "IMLViewController.h"

@implementation UIViewController (CustomBackButton)

- (void)backButtonPressed {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setCustomBackButton {
    IMLBackButtonStyle style = IMLBackButtonStyleNormal;
    if ([self isKindOfClass:([IMLViewController class])]) {
        style = ((IMLViewController *)self).backButtonStyle;
    }

    if (style == IMLBackButtonStyleNone || [self.navigationController.viewControllers count] < 2) {
        // no back button needed.
        return;
    }
    
//    FAKIonIcons *backIcon = [FAKIonIcons iosArrowLeftIconWithSize:28.0f];
//    [backIcon addAttribute:NSForegroundColorAttributeName value:[UIColor subColor]];
    
    IMLiOS7BarItemButton *backButton = [IMLiOS7BarItemButton buttonWithType:UIButtonTypeCustom iOS7BarButtonType:IMLiOS7BarItemButtonTypeLeft];
	[backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
//  UIImage *image = [UIImage imageNamed:style == IMLBackButtonStyleBlue ? @"navbar_back_blue~iPhone" : @"navbar_back_btn~iPhone"];
//	[backButton setImage:image forState:UIControlStateNormal];
    
//	backButton.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
//	backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 14.0, 0.0, 10.0);
	
    backButton.frame = CGRectMake(0.0, 0.0, 15, 40);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[backButton setAttributedTitle:[backIcon attributedString] forState:UIControlStateNormal];
    
	UIBarButtonItem *customBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = customBackItem;
}

@end
