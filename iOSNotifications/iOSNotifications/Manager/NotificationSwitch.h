//
//  PushSwitch.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/16.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "UINotificationManager.h"
#import "JSPushService.h"

#import "UILocalNotificationManager.h"

#define iOS10 ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

//#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_10_0
#define NewPushSwitchOpen 1
//#endif

@interface NotificationSwitch : NSObject

+ (void)registePushWithClass:(id<UNUserNotificationCenterDelegate>)class  option:(NSDictionary*)launchOptions;

+ (void)resetBadge;

+ (void)registerDeviceToken:(NSData*)deviceToken;

+ (void)handleLocalNotification:(UILocalNotification *)notification;

+ (void)handleRemoteNotification:(NSDictionary *)userInfo;

+ (BOOL)supportIOS10NewFramework;

@end
