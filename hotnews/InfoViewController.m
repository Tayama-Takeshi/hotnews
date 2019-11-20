//
//  InfoViewController.m
//  hotnews
//
//  Created by tian on 2017/09/12.
//  Copyright © 2017年 tian. All rights reserved.
//

#import "InfoViewController.h"
#import "IMLAPIClient.h"
#import "IMLExternConstants.h"
#import "IntlRoutes.h"

@interface InfoViewController ()

@end

static NSString * const InfoURL = @"http://xxxxx.stg.aaa.com/app/notification";


@implementation InfoViewController

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
    self.navigationItem.title = @"通知";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    
    [self initwebView];
    
    //[self loadSharePage];
}


- (void)viewWillAppear:(BOOL)animated{
    
    NSString *pageurl = [NSString stringWithFormat:@"%@",self.webView.URL];
    
    
    if (self.webView.URL == nil){
        
        [self loadSharePage];
        
    }else{
        if (![pageurl isEqualToString:InfoURL]) {
            [self loadSharePage];
        }
        
        
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
    
    
    NSString *ustr = [NSString stringWithFormat:@"%@",[IMLAPIClient makeLoadableURLString:InfoURL]];
    
    
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
