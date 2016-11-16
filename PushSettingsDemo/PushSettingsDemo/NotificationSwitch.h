//
//  PushSwitch.h
//  PushSettingsDemo
//
//  Created by WengHengcong on 2016/11/16.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#define NewPushSwitchOpen 1

@interface NotificationSwitch : NSObject

+ (void)registePushWithClass:(id<UNUserNotificationCenterDelegate>)class  option:(NSDictionary*)launchOptions;

+ (void)resetBadge;

+ (void)registerDeviceToken:(NSData*)deviceToken;

+ (void)handleLocalNotification:(UILocalNotification *)notification;

+ (void)handleRemoteNotification:(NSDictionary *)userInfo;


@end
