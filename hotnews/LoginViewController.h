//
//  LoginViewController.h
//  hotnews
//
//  Created by tian on 2017/09/12.
//  Copyright © 2017年 tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "IMLViewController.h"

@interface LoginViewController : UIViewController<WKNavigationDelegate,WKUIDelegate>


@property (nonatomic, strong)NSDictionary *paramsDic;


@property (strong, nonatomic) WKWebView *webView;

- (instancetype)initWithParams:(NSDictionary *)params;
-(void)closeMe;

@end
