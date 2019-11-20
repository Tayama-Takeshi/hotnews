//
//  SettingViewController.h
//  hotnews
//
//  Created by tian on 2017/09/12.
//  Copyright © 2017年 tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface SettingViewController : UIViewController<WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;


@end
