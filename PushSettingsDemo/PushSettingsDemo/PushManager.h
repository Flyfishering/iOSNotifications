//
//  PushManager.h
//  PushSettingsDemo
//
//  Created by WengHengcong on 16/6/6.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define kLocalNotificationCategory      @"kLocalNotificationCategory"
#define kLocalNotificationContent      @"kLocalNotificationContent"

@interface PushManager : NSObject

+ (instancetype)sharedManager;
/**
 *  register notication
 */
+ (void)registerPushNotification:(NSDictionary *)launchOptions;

+ (void)handleNotificationApplicationLaunching:(NSDictionary *)launchOptions;
/**
 *  send device token to your server
 */
+ (void)registerDeviceToken:(NSData*)deviceToken;

/**
 *  handle remote/local notification
 */
+ (void)handleLocalNotification:(UILocalNotification *)notification;
+ (void)handleRemoteNotification:(NSDictionary *)userinfo;

//badge
+ (void)resetBadge;
+ (void)setBadge:(NSInteger)badge;

//local notification
+ (void)buildUILocalNotificationWithNSDate:(NSDate *)date alert:(NSString *)alert badge:(int)badge identifierKey:(NSString *)identitifierKey userInfo:(NSDictionary *)userInfo;


@end
