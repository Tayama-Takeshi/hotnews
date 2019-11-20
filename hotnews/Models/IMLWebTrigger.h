//
//  IMLWebTrigger.h
//  ht-ios
//
//  Created by tym on 2016/04/07.
//  Copyright © 2016年 hetaoapp.com. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class WKWebView;

@interface IMLWebTrigger : NSObject
+ (void)triggerAppResume:(WKWebView *)webView;
+ (NSString *)makeServerEventJS:(NSString *)event;
+ (NSString *)makeServerEventJSWithParaments:(NSString *)event, ...;
+ (NSString *)makeServerEventJS:(NSString *)event args:(va_list)args;
+ (void)triggerServerEvent:(NSString *)event inWebView:(WKWebView *)webView;
+ (void)triggerServerEventInWebView:(WKWebView *)webView withEvent:(NSString *)event, ...;
+ (void)triggerServerEventInWebView:(WKWebView *)webView withEvent:(NSString *)event args:(va_list)args;
+ (void)runJavaScriptWith:(WKWebView *)webView js:(NSString *)javaScript;
+ (void)triggerServerEventCallbackInWebView:(WKWebView *)webView callbackHash:(NSString *)hash params:(NSDictionary *)params errorMessage:(NSString *)error;
@end
