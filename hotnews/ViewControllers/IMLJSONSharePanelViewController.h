//
//  IMLJSONSharePanelViewController.h
//  ht-ios
//
//  Created by dev on 7/8/15.
//  Copyright © 2015 dev.COM. All rights reserved.
//

#import "IMLSharePanelViewController.h"

typedef NS_ENUM(NSUInteger, IMLJSONSharePanelShareType) {
    IMLJSONSharePanelShareTypeAll,
    IMLJSONSharePanelShareTypeWeChat,
    IMLJSONSharePanelShareTypeWeChatTimeline,
    IMLJSONSharePanelShareTypeWeibo,
    IMLJSONSharePanelShareTypeSMS,
    IMLJSONSharePanelShareTypeSafari,
    IMLJSONSharePanelShareTypeLine,
    IMLJSONSharePanelShareTypeCopy,
    IMLJSONSharePanelShareTypeMail
};

@interface IMLJSONSharePanelViewController : IMLSharePanelViewController

@property (nonatomic, strong) NSDictionary *wechatData;
//@property (nonatomic, strong) NSDictionary *wechatTimeLineData;
@property (nonatomic, strong) NSDictionary *weiboData;
@property (nonatomic, strong) NSDictionary *defaultData;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, assign) IMLJSONSharePanelShareType type;

@end
