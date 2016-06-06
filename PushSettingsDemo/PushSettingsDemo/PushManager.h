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

@interface PushManager : NSObject

/**
 *  for test
 */
+ (void)testLocalNotification;


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

@end
