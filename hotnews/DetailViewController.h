//
//  SecondViewController.h
//  hotnews
//
//  Created by tian on 2017/09/07.
//  Copyright © 2017年 tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "IMLViewController.h"

@interface DetailViewController : UIViewController<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong)NSDictionary *paramsDic;


@property (strong, nonatomic) WKWebView *webView;

- (instancetype)initWithParams:(NSDictionary *)params;
- (void)showSharePanelWithJson:(NSString *)jsonStr;

@end

