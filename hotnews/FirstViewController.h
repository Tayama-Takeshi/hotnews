//
//  FirstViewController.h
//  hotnews
//
//  Created by tian on 2017/09/07.
//  Copyright © 2017年 tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "IMLNavigationBarButtonsView.h"

@interface FirstViewController : UIViewController<WKNavigationDelegate,WKUIDelegate>
{
    IMLNavigationBarButtonsView *_rightButtonsView;
    IMLNavigationBarButtonsView *_leftButtonsView;

}
- (void)setNavigationBarItemParams:(NSDictionary *)params;
- (void)showSharePanelWithJson:(NSString *)jsonStr;


@end

