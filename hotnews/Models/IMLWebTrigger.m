//
//  WKWebView.m
//  ht-ios
//
//  Created by tym on 2016/04/07.
//  Copyright © 2016年 hetaoapp.com. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "IMLWebTrigger.h"
#import "IMLExternConstants.h"
//#import "MSActivityWebView.h"

@implementation IMLWebTrigger

+ (void)triggerAppResume:(WKWebView *)webView {
    [self triggerServerEvent:@"app-resume" inWebView:webView];
}

+ (NSString *)makeServerEventJS:(NSString *)event args:(va_list)args {
    if (!event) {
        return nil;
    }
    event = [event stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([event length] == 0) {
        return nil;
    }
    
    NSString *paramsStr = @"";
    id arg = nil;
    if (args && (arg = va_arg(args, id))) {
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:[self correctJSType:arg]];
        
        while ( nil != (arg = va_arg(args, id)) ) {
            [params addObject:[self correctJSType:arg]];
        }
        paramsStr = [NSString stringWithFormat:@",[%@]", [params componentsJoinedByString:@","]];
    }
    
    NSString *javaScript = [NSString stringWithFormat:@"$%@trigger('jp.%@'%@);", kJavaScriptTriggerPrefix, event, paramsStr];
    return javaScript;
}

+ (NSString *)makeServerEventJS:(NSString *)event {
    return [self makeServerEventJSWithParaments:event, nil];
}

+ (NSString *)makeServerEventJSWithParaments:(NSString *)event, ... {
    NSString *javaScript = @"";
    va_list args;
    va_start(args, event);
    javaScript = [self makeServerEventJS:event args:args];
    va_end(args);
    return javaScript;
}

+ (NSString *)correctJSType:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", obj];
    } else if ([obj isKindOfClass:[NSString class]]){
        return [NSString stringWithFormat:@"'%@'", obj];
    } else {
        NSAssert(FALSE, @"Not supported parament type");
        return nil;
    }
}

+ (void)triggerServerEvent:(NSString *)event inWebView:(WKWebView *)webView {
    [self triggerServerEventInWebView:webView withEvent:event, nil];
}

+ (void)triggerServerEventInWebView:(WKWebView *)webView withEvent:(NSString *)event args:(va_list)args {
    NSString *javaScript = [self makeServerEventJS:event args:args];
    
    
    [webView evaluateJavaScript:javaScript completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        
    }];
    
    ////LOG_MESSAGE(@"Run JavaScript: %@", javaScript);
    //[webView stringByEvaluatingJavaScriptFromString:javaScript];
}

+ (void)triggerServerEventInWebView:(WKWebView *)webView withEvent:(NSString *)event, ... {
    NSString *javaScript = @"";
    va_list args;
    va_start(args, event);
    javaScript = [self makeServerEventJS:event args:args];
    va_end(args);
    
    [webView evaluateJavaScript:javaScript completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Run JavaScript: %@", javaScript);
        
    }];
    ////LOG_MESSAGE(@"Run JavaScript: %@", javaScript);
    //[webView stringByEvaluatingJavaScriptFromString:javaScript];
}

+ (void)runJavaScriptWith:(WKWebView *)webView js:(NSString *)javaScript {
    if (javaScript && [javaScript length] > 0) {
        [webView evaluateJavaScript:javaScript completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            
            
        }];
        
        //[webView stringByEvaluatingJavaScriptFromString:javaScript];
    }
}

+ (void)triggerServerEventCallbackInWebView:(WKWebView *)webView callbackHash:(NSString *)hash params:(NSDictionary *)params errorMessage:(NSString *)error {
    if (!hash) {
        return;
    }
    
    NSString *jsonString = nil;
    if (params) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    if (!jsonString) {
        jsonString = @"";
    }

    NSString *event = @"app-event-callback";
    if (error) {
        [[self class] triggerServerEventInWebView:webView withEvent:event, hash, jsonString, error, nil];
    } else {
        [[self class] triggerServerEventInWebView:webView withEvent:event, hash, jsonString, nil];
    }
}
@end
