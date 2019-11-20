//
//  IMLExternConstants.m
//  ht-ios
//
//  Created by tym on 12/5/15.
//  Copyright © 2015 tym. All rights reserved.
//
#import "IMLExternConstants.h"

NSString *const kJavaScriptTriggerPrefix = @"applink.";
#if defined(IN_HOUSE) //&& !defined(DEBUG)
NSString *const kAppDefaultScheme = @"com.gmaspark";
#else
NSString *const kAppDefaultScheme = @"com.gmaspark";
#endif
//http://73.stg.gmaspark.com/app/home
NSString *const kUAClientString = @"com.gmaspark.iphone";
//NSString *const kUAClientString = @"com.ribenmeishi.iphone";
NSString *const kAPIBasicURL = @"/api";
NSString *const kPAGEBasicURL = @"/app";
NSString *const kSecret = @"";
int const kAPIServerErrorCode = 500;
NSTimeInterval kGlobleWebViewTimeoutInterval = 15.0;

//////////////////////////////////////////
// Online Services ID
//////////////////////////////////////////

NSString *const kAppleAppId = @"1269076759";

NSString *const kAllpayScheme = @"com.allpay.ribenmeishi";

NSString *const kGAIID = @"";
NSString *const kFlurryKey = @"";
NSString *const kAppiraterID = @"";

//NSString *const kAVOSAPPID = @"-gzGzoHsz";
//NSString *const kAVOSAPPKEY = @"Yd0TKWotaYTibhqi4pvXCUOo";

//NSString *const kAppsFlyerDevKey = @"7fz8jAamuBsLaeAMxuDvNB";

NSString *const kAppleMerchantID = @"merchant.jp.pay.ribenmeishi";

#if defined(IN_HOUSE)
NSString *const kPayjpPublicKey = @"pk_test_f36f2b3c2a937bec7071b58b";
#else
NSString *const kPayjpPublicKey = @"";
#endif

// Release 版设置
NSString *const kWeiboAppKey = @"";    // #Warning! Don't forget to change the URL Scheme in info.plist
NSString *const WEIXIN_APP_ID = @"wxdd15b6922237eac5";    // #Warning! Don’t forget to change the URL Scheme in info.plist
NSString *const WEIXIN_APP_SECRET = @"27aa4557403e98236af283d70b5ae920";

NSString *const kWeiboRedirectURL = @"http://www.sina.com.cn";

NSString *const kIMLFreeSubscribeId = @"";

// Bugtags
NSString *const kIMLBugTagsAppKey = @"5ed718831da4da41c2d4264c2dad014a";
// AES256
NSString *const kAESKey0 = @"";
NSString *const kAESKey1 = @"";
NSString *const kAESKey2 = @"";
NSString *const kAESKey3 = @"";

//////////////////////////////////////////
// Notifications
//////////////////////////////////////////

// Events
NSString *const kIMLUserLogout = @"IMLUserLogout";
NSString *const kIMLUserLogin = @"IMLUserLogin";
NSString *const kIMLUpdateUserAvatar = @"IMLUpdateUserAvatar";
NSString *const kIMLCenterPanelToggled = @"IMLCenterPanelToggled";
NSString *const kIMLItemsViewControllerShown = @"IMLItemsViewControllerShown";
NSString *const kIMLItemsViewControllerDisappearing = @"IMLItemsViewControllerDisappearing";
NSString *const kIMLNetworkReachable = @"IMLNetworkReachable";
NSString *const kIMLNetworkUnreachable = @"IMLNetworkUnreachable";
NSString *const kIMLRouteMapUpdated = @"IMLRouteMapUpdated";
NSString *const kIMLPageInfoLoaded = @"kIMLPageInfoLoaded";
NSString *const kIMLRegisteredFontsModified = @"IMLRegisteredFontsModified";
NSString *const kIMLCurrentLocationUpdated = @"IMLCurrentLocationUpdated";
NSString *const kIMLCurrentLocationUpdatedFailed = @"";

// Actions
NSString *const kIMLRefreshWebView = @"IMLRefreshWebView";
NSString *const kIMLPresentSearch = @"IMLPresentSearch";


//////////////////////////////////////////
// NSUserDefaults Keys
//////////////////////////////////////////

NSString *const kIMLUserDefaultIntroductionDidAppear = @"IMLUserDefaultIntroductionDidAppear";
NSString *const kIMLUserDefaultRemoteRouters = @"IMLUserDefaultRemoteRouters";
NSString *const kIMLUserDefaultLastAppVersion = @"IMLUserDefaultLastAppVersion";
NSString *const kIMLUserDefaultLastAppCheckedVersion = @"IMLUserDefaultLastAppCheckedVersion";
NSString *const kIMLUserDefaultNewsUpdateTime = @"IMLUserDefaultNewsUpdateTime";
NSString *const kIMLUserDefaultFontList = @"IMLUserDefaultFontList";
NSString *const kIMLUserDefaultSearchHistory = @"IMLUserDefaultSearchHistory";
NSString *const kIMLUserDefaultStartUpAdInfo = @"IMLUserDefaultStartUpAdInfo";
NSString *const kIMLUserDefaultCurrentIconImageName = @"IMLUserDefaultCurrentIconImageName";
NSString *const kIMLUserDefaultAutoOffline = @"IMLUserDefaultAutoOffline";
NSString *const kIMLUserDefaultLastestUpdateColumn_ = @"IMLUserDefaultLastestUpdateColumn_";

NSString *const kIMLUserDefaultLastOutlineUpdateTime = @"IMLUserDefaultLastOutlineUpdateTime";
NSString *const kIMLUserDefaultLastOutlineData = @"IMLUserDefaultLastOutlineData";

//////////////////////////////////////////
// Other Keys
//////////////////////////////////////////
NSString *const kIMLRongCloudTokenKeyService = @"IMLRongCloudTokenKeyService";
NSString *const kIMLRongCloudTokenKeyAccount = @"IMLRongCloudTokenKeyAccount";
