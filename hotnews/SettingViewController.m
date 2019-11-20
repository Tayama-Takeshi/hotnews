//
//  SettingViewController.m
//  hotnews
//
//  Created by tian on 2017/09/12.
//  Copyright © 2017年 tian. All rights reserved.
//

#import "SettingViewController.h"
#import "IMLAPIClient.h"
#import "IMLExternConstants.h"
#import "IntlRoutes.h"
@interface SettingViewController ()

@end

static NSString * const SettingURL = @"http://xxxxx.stg.aaa.com/app/setting";

@implementation SettingViewController

- (void)initwebView
{
    
    // WKWebView インスタンスの生成
    self.webView = [WKWebView new];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
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
    
    [self.webView setFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60)];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initwebView];
    self.navigationItem.title = @"設定";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    //[self loadSharePage];
}


- (void)viewWillAppear:(BOOL)animated{
    
    NSString *pageurl = [NSString stringWithFormat:@"%@",self.webView.URL];
    
    
    if (self.webView.URL == nil){
        
        [self loadSharePage];
        
    }
    
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


-(void)loadSharePage{
    
    
    NSString *ustr = [NSString stringWithFormat:@"%@",[IMLAPIClient makeLoadableURLString:SettingURL]];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
