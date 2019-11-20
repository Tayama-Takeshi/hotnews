//
//  SecondViewController.m
//  hotnews
//
//  Created by tian on 2017/09/07.
//  Copyright © 2017年 tian. All rights reserved.
//

#import "DetailViewController.h"
#import "IMLAPIClient.h"
#import "IMLExternConstants.h"
#import "IntlRoutes.h"
#import "IMLWebTrigger.h"
#import "IMLConstants.h"
#import "NSJSONSerialization+RNJSON.h"
#import "IMLJSONSharePanelViewController.h"


@interface DetailViewController ()

@end

static NSString * const InitialURL = @"http://xxxxx.stg.aaa.com";


@implementation DetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if ((self = [super init])) {
        _paramsDic = params;
    }
    return self;
}

- (void)initwebView
{
    
    // WKWebView インスタンスの生成
    self.webView = [WKWebView new];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    
    // Auto Layout の設定
    // 画面いっぱいに WKWebView を表示するようにする
    //    [self.view addConstraints:@[
    //                                [NSLayoutConstraint constraintWithItem:self.webView
    //                                                             attribute:NSLayoutAttributeTop
    //                                                             relatedBy:NSLayoutRelationEqual
    //                                                                toItem:self.view
    //                                                             attribute:NSLayoutAttributeTop
    //                                                            multiplier:1.0
    //                                                              constant:0]
    //                                ]];
    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.webView.translatesAutoresizingMaskIntoConstraints = YES;
    // 生成したレイアウトを配列でまとめて設定する
    //[self.webView addConstraints:layoutConstraints];
    
    // デリゲートにこのビューコントローラを設定する
    self.webView.navigationDelegate = self;
    
    // フリップでの戻る・進むを有効にする
    self.webView.allowsBackForwardNavigationGestures = NO;
    
    // WKWebView インスタンスを画面に配置する
    [self.view insertSubview:self.webView atIndex:0];
    
    [self.webView setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initwebView];


    
    if (_paramsDic) {
        [self initViewByParams:_paramsDic];
    }
    
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.webView addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.webView addGestureRecognizer:swipeGesture2];

    
}



-(void)handleSwipeGesture:(UISwipeGestureRecognizer *) sender
{
    //Gesture detect - swipe up/down , can be recognized direction
    if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"UISwipeGestureRecognizerDirectionLeft");
        //[IMLWebTrigger triggerServerEventInWebView:self.webView withEvent:params[@“action-name”],params[@“currentindex”], nil];
        //[IMLWebTrigger triggerServerEventInWebView:self.webView withEvent:@"movetags",@"left",nil];
        
    }
    else if(sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        NSLog(@"UISwipeGestureRecognizerDirectionRight");
        //[IMLWebTrigger triggerServerEventInWebView:self.webView withEvent:@"movetags",@"right",nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


-(void)initViewByParams:(NSDictionary*)params{
    
    NSString *url = params[@"url"]; // defined in the route by specifying ":userID"
    NSString *title = params[@"title"]; // defined in the route by specifying ":userID"
    
    NSLog(@"url = %@",url);
    NSLog(@"title = %@",title);
    
    NSString *ustr = [NSString stringWithFormat:@"%@%@",[IMLAPIClient makeLoadableURLString:InitialURL],url];
    
    
    NSURL *URL = [NSURL URLWithString:ustr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kGlobleWebViewTimeoutInterval];
    if (!request) {
        return;
    }
    
    
    [self.webView loadRequest:request];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"decidePolicyForNavigationAction");
    //NSURLの取得
    NSURL *url= [webView URL];
    //NSURLRequestの取得
    NSURLRequest *req = [navigationAction request];
    
    NSLog(@"req.URL.scheme = %@",req.URL.scheme);
    NSLog(@"req.URL.scheme = %@",req.URL);
    
    
    [[IntlRoutes routesForScheme:kAppDefaultScheme] routeURL:req.URL];
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)showSharePanelWithJson:(NSString *)jsonStr {
    
    NSLog(@"jsonStr = %@",jsonStr);
    
    
    NSURL *baseURL = [NSURL URLWithString:kBaseURL];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithString:jsonStr];
    NSString *URLStr = json[@"url"];
    
    IMLJSONSharePanelViewController *sharePanelViewController = [IMLJSONSharePanelViewController new];
    if (URLStr && [URLStr length] > 0) {
        NSURL *URL = [NSURL URLWithString:URLStr];
        if (URL) {
            NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:YES];
            if (components) {
                URL = [components URLRelativeToURL:baseURL]; // Add baseURL if there is no one
            }
        }
        //sharePanelViewController.URLs = URL;
    }
    NSString *type = [json[@"type"] lowercaseString];
    if ([type isEqualToString:@"copy"]) {
        sharePanelViewController.type = IMLJSONSharePanelShareTypeCopy;
    } else if ([type isEqualToString:@"line"]) {
        sharePanelViewController.type = IMLJSONSharePanelShareTypeLine;
    } else if ([type isEqualToString:@"mail"]) {
        sharePanelViewController.type = IMLJSONSharePanelShareTypeMail;
    } else if ([type isEqualToString:@"safari"]) {
        sharePanelViewController.type = IMLJSONSharePanelShareTypeSafari;
    } else if ([type isEqualToString:@"sms"]) {
        sharePanelViewController.type = IMLJSONSharePanelShareTypeSMS;
    } else if ([type isEqualToString:@"wechat"]) {
        sharePanelViewController.type = IMLJSONSharePanelShareTypeWeChat;
    } else if ([type isEqualToString:@"wechat-timeline"]) {
        sharePanelViewController.type = IMLJSONSharePanelShareTypeWeChatTimeline;
    } else if ([type isEqualToString:@"weibo"]) {
        sharePanelViewController.type = IMLJSONSharePanelShareTypeWeibo;
    } else {    // default is "all"
        sharePanelViewController.type = IMLJSONSharePanelShareTypeAll;
    }
    sharePanelViewController.statusBarPreferHidden = self.prefersStatusBarHidden;
    sharePanelViewController.defaultData = json[@"default"];
    sharePanelViewController.wechatData = json[@"wechat"];
    sharePanelViewController.weiboData = json[@"weibo"];
    sharePanelViewController.messageId = json[@"id"];
    
    //    sharePanelViewController.backButtonHidden = YES;
    [sharePanelViewController show:nil];
}


@end
