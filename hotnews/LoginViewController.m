//
//  LoginViewController.m
//  hotnews
//
//  Created by tian on 2017/09/12.
//  Copyright © 2017年 tian. All rights reserved.
//

#import "LoginViewController.h"
#import "IMLAPIClient.h"
#import "IMLExternConstants.h"
#import "IntlRoutes.h"

@interface LoginViewController ()

@end

static NSString * const InitialURL = @"http://xxxxx.stg.aaa.com";


@implementation LoginViewController


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
    //    self.webView.translatesAutoresizingMaskIntoConstraints = YES;
    // 生成したレイアウトを配列でまとめて設定する
    //[self.webView addConstraints:layoutConstraints];
    
    // デリゲートにこのビューコントローラを設定する
    self.webView.navigationDelegate = self;
    
    // フリップでの戻る・進むを有効にする
    self.webView.allowsBackForwardNavigationGestures = NO;
    
    // WKWebView インスタンスを画面に配置する
    [self.view insertSubview:self.webView atIndex:0];
    
    [self.webView setFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60)];
    
    
}
-(void)colseme{

    NSLog(@"colseme =");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
    [self initwebView];
    
    if (_paramsDic) {
        [self initViewByParams:_paramsDic];
    }
    
    NSLog(@"isNavigationBarHidden = %d",self.navigationController.isNavigationBarHidden);
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn setTitle:@"close" forState:UIControlStateNormal];
    
    [closeBtn addTarget:self action:@selector(closeMe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    
}

-(void)closeMe{

    [self dismissViewControllerAnimated:YES completion:nil];
    
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
