//
//  IMLExternConstants.h
//  ht-ios
//
//  Created by tym on 12/5/15.
//  Copyright © 2015 tym. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kJavaScriptTriggerPrefix;
extern NSString *const kAppDefaultScheme;
extern NSString *const kUAClientString;
extern NSString *const kAPIBasicURL;
extern NSString *const kSecret;
extern int const kAPIServerErrorCode;
extern NSTimeInterval kGlobleWebViewTimeoutInterval;

//////////////////////////////////////////
// Online Services ID
//////////////////////////////////////////
extern NSString *const kAppleAppId;

extern NSString *const kAllpayScheme;

extern NSString *const kGAIID;
extern NSString *const kFlurryKey;
extern NSString *const kAppiraterID;

extern NSString *const kAVOSAPPID;
extern NSString *const kAVOSAPPKEY;

extern NSString *const kAppsFlyerDevKey;
extern NSString *const kAppleMerchantID;
extern NSString *const kPayjpPublicKey;

// Release 版设置
extern NSString *const kWeiboAppKey;
extern NSString *const WEIXIN_APP_ID;
extern NSString *const WEIXIN_APP_SECRET;

extern NSString *const kWeiboRedirectURL;

extern NSString *const kIMLFreeSubscribeId;

// 融云
extern NSString *const kRongCloudIMAppKey;
//extern NSString *const kRongCloudDebugSupportID;

// Bugtags
extern NSString *const kIMLBugTagsAppKey;

// AES256
extern NSString *const kAESKey0;
extern NSString *const kAESKey1;
extern NSString *const kAESKey2;
extern NSString *const kAESKey3;

//////////////////////////////////////////
// Notifications
//////////////////////////////////////////

// Events
extern NSString *const kIMLUserLogout;
extern NSString *const kIMLUserLogin;
extern NSString *const kIMLUpdateUserAvatar;
extern NSString *const kIMLCenterPanelToggled;
extern NSString *const kIMLItemsViewControllerShown;
extern NSString *const kIMLItemsViewControllerDisappearing;
extern NSString *const kIMLNetworkReachable;
extern NSString *const kIMLNetworkUnreachable;
extern NSString *const kIMLRouteMapUpdated;
extern NSString *const kIMLPageInfoLoaded;

extern NSString *const kIMLRegisteredFontsModified;
extern NSString *const kIMLCurrentLocationUpdated;
extern NSString *const kIMLCurrentLocationUpdatedFailed;

// Actions
extern NSString *const kIMLRefreshWebView;
extern NSString *const kIMLPresentSearch;


//////////////////////////////////////////
// NSUserDefaults Keys
//////////////////////////////////////////

extern NSString *const kIMLUserDefaultIntroductionDidAppear;
extern NSString *const kIMLUserDefaultRemoteRouters;
extern NSString *const kIMLUserDefaultLastAppVersion;
extern NSString *const kIMLUserDefaultLastAppCheckedVersion;
extern NSString *const kIMLUserDefaultNewsUpdateTime;
extern NSString *const kIMLUserDefaultFontList;
extern NSString *const kIMLUserDefaultSearchHistory;
extern NSString *const kIMLUserDefaultStartUpAdInfo;
extern NSString *const kIMLUserDefaultCurrentIconImageName;
extern NSString *const kIMLUserDefaultAutoOffline;
extern NSString *const kIMLUserDefaultLastestUpdateColumn_;

extern NSString *const kIMLUserDefaultLastOutlineUpdateTime;
extern NSString *const kIMLUserDefaultLastOutlineData;


//////////////////////////////////////////
// Other Keys
//////////////////////////////////////////
extern NSString *const kIMLRongCloudTokenKeyService;
extern NSString *const kIMLRongCloudTokenKeyAccount;
