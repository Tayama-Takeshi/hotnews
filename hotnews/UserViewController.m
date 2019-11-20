//
//  MyInfoViewController.m
//  hotnews
//
//  Created by tian on 2017/09/12.
//  Copyright © 2017年 tian. All rights reserved.
//
#import "UIBarButtonItem+ALActionBlocks.h"
#import "UserViewController.h"
#import "IMLAPIClient.h"
#import "IMLExternConstants.h"
#import "IntlRoutes.h"
#import "IMLNavigationBarButtonsView.h"
#import "IMLWebTrigger.h"

@interface UserViewController ()

@end

static NSString * const UserURL = @"http://xxxxx.stg.aaa.com/app/user";


@implementation UserViewController

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
    self.navigationItem.title = @"我的";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    
    _rightButtonsView = [[IMLNavigationBarButtonsView alloc] initWithFrame:CGRectMake(0.0, 0.0, 36.0, self.navigationController.navigationBar.bounds.size.height) type:IMLiOS7BarItemViewTypeRight];
    _rightButtonsView.backgroundColor = [UIColor clearColor];
    _leftButtonsView = [[IMLNavigationBarButtonsView alloc] initWithFrame:CGRectMake(0.0, 0.0, 36.0, self.navigationController.navigationBar.bounds.size.height) type:IMLiOS7BarItemViewTypeLeft];
    _leftButtonsView.backgroundColor = [UIColor clearColor];
    

    
    [self initwebView];
    
    //[self loadSharePage];
}


- (void)viewWillAppear:(BOOL)animated{
    
    NSString *pageurl = [NSString stringWithFormat:@"%@",self.webView.URL];
    
    
    if (self.webView.URL == nil){
        
        [self loadSharePage];
        
    }else{
        if (![pageurl isEqualToString:UserURL]) {
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
    
    
    NSString *ustr = [NSString stringWithFormat:@"%@",[IMLAPIClient makeLoadableURLString:UserURL]];
    
    
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


- (void)setNavigationBarItemParams:(NSDictionary *)params {
    
    NSLog(@"setNavigationBarItemParams = %@",params[@"position"]);
    
    IMLNavigationBarButtonsView *buttonView = nil;
    if ([params[@"position"] isEqualToString:@"left"]) {
        buttonView = _leftButtonsView;
    } else {
        buttonView = _rightButtonsView;
    }
    
    UIButton *button = nil;
    NSString *targetAction = params[@"replace-action"] ? params[@"replace-action"] : params[@"action-name"];
    for (NSDictionary *cached in buttonView.itemParams) {
        if ([cached isEqualToDictionary:params]) {
            return;
        } else if ([targetAction isEqualToString:cached[@"action-name"]]) {
            button = [buttonView.itemWithKeys objectForKey:targetAction];
            
            NSInteger index = [buttonView.itemParams indexOfObject:cached];
            [buttonView.itemParams replaceObjectAtIndex:index withObject:params];
            [buttonView.itemWithKeys removeObjectForKey:targetAction];
            [buttonView.itemWithKeys setObject:button forKey:params[@"action-name"]];
            [button removeActionBlocksForControlEvents:UIControlEventTouchUpInside];
            [button setImage:nil forState:UIControlStateNormal];
            [button setTitle:@"aaa" forState:UIControlStateNormal];
            break;
        }
    }
    
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    
    CGSize fitSize = CGSizeMake(36.0, 44.0);
    
    NSString *title = params[@"title"];
    NSString *imageName = params[@"image"];
    NSString *icon = params[@"icon"];
    
    if (imageName && [imageName length] > 0) {
        NSURL *url = [NSURL URLWithString:imageName];
        //        if ([[IMLURLRouter defaultHandler] isWebViewScheme:url]) {
        //            [button setImageForState:UIControlStateNormal withURL:url];
        //        } else {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        //        }
        NSString *selectedImageName = [params[@"imageNameSelected"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([selectedImageName length] > 0) {
            url = [NSURL URLWithString:selectedImageName];
            //if ([[IMLURLRouter defaultHandler] isWebViewScheme:url]) {
            //    [button setImageForState:UIControlStateSelected withURL:url];
            //} else {
            [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
            //s}
        }
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //    } else if (icon && [icon length] > 0){
        //        Class theClass = NSClassFromString(icon);
        //        if (theClass && [theClass isSubclassOfClass:[FAKIcon class]]) {
        //            FAKIcon *fontIcon = [theClass iconWithCode:title size:28.0f];
        //            [fontIcon addAttribute:NSForegroundColorAttributeName value:iconColor];
        //            [button setAttributedTitle:[fontIcon attributedString] forState:UIControlStateNormal];
        //        }
        //    } else if (title && [title length] > 0) {
        //        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        //        [style setAlignment:NSTextAlignmentCenter];
        //        [button setTitle:title forState:UIControlStateNormal];
        //        [button setTitleColor:iconColor forState:UIControlStateNormal];
        //        button.titleLabel.font = kChineseFont(16);
        //
        //        NSDictionary *attr = @{NSParagraphStyleAttributeName : style,
        //                               NSFontAttributeName : kChineseFont(16)
        //                               };
        //        CGSize size = [title sizeWithAttributes:attr];
        //        size.width += 4.0;
        //        fitSize = CGSizeMake(MAX(size.width, fitSize.width), fitSize.height);
    }
    
    
    button.backgroundColor = [UIColor clearColor];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.showsTouchWhenHighlighted = NO;
    button.bounds = CGRectMake(0.0, 0.0, fitSize.width, fitSize.height);
    if (![buttonView.items containsObject:button]) {
        [buttonView addItem:button withParams:params baseOnRight:buttonView == _rightButtonsView ? YES : NO];
    }
    [buttonView updateItemFrame];
    
    __weak typeof(self) weakMe = self;
    if (params[@"action-name"]) {
        [button handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
            [IMLWebTrigger triggerServerEvent:params[@"action-name"] inWebView:weakMe.webView];
        }];
    }
    
    //if (self.navigationController) {
    [UIView animateWithDuration:[buttonView.items count] == 1 ? 0.0 : 0.2 animations:^{
        if ([params[@"position"] isEqualToString:@"left"]) {
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
            //if (_searchView.showing) {
            //self.tempLeftBarButtonItem = buttonItem;
            //} else {
            self.navigationItem.leftBarButtonItem = buttonItem;
            //}
        } else {
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
            //if (_searchView.showing) {
            //self.tempRightBarButtonItem = buttonItem;
            //} else {
            self.navigationItem.rightBarButtonItem = buttonItem;
            //}
        }
    }];
    //}
    
    
    
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
