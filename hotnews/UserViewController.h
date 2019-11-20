//
//  MyInfoViewController.h
//  hotnews
//
//  Created by tian on 2017/09/12.
//  Copyright © 2017年 tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "IMLNavigationBarButtonsView.h"


@interface UserViewController : UIViewController<WKNavigationDelegate,WKUIDelegate>
{
    IMLNavigationBarButtonsView *_rightButtonsView;
    IMLNavigationBarButtonsView *_leftButtonsView;
    

}
@property (strong, nonatomic) WKWebView *webView;

- (void)setNavigationBarItemParams:(NSDictionary *)params;

@end
