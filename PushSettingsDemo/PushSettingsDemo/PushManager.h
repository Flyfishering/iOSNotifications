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

#define kLocalNotificationIdentifier        @"kLocalNotificationIdentifier"
#define kLocalNotificationContent           @"kLocalNotificationContent"

@interface PushManager : NSObject

+ (instancetype)sharedManager;
/**
 *  启动时处理应用缓存消息
 *  @param launchOptions
 */
+ (void)setupWithOption:(NSDictionary *)launchOptions;
/**
 *  register notication
 *  @param types 注册类型 0~7
 *  typs是由三位二进制位构成的，Alert|Sound|Badge
 */
+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories;


/**
 *  send device token to your server
 */
+ (void)registerDeviceToken:(NSData*)deviceToken;

/**
 *  handle remote/local notification
 */
+ (void)handleRemoteNotification:(NSDictionary *)userinfo;


///----------------------------------------------------
/// @name badge
///----------------------------------------------------

/*
 
 应用角标
 
 1.假如本地推送和远程推送的消息payload都不带有badge字段，那么不管角标如何设置。
    *点击推送，点击一条消除一条；
    *点击APP，推送不会消除；
 2.如何本地推送或远程推送中含有payload带有badge字段，
    * 假如角标设为“当前角标-1”，且不为0，推送点击一条消除一条，点击主应用，通知中心推送不改变；
    * 假如角标设为0，不管点击推送，还是点击应用，那么推送会全部清除。
 
 */


/**
 *  设置应用角标
 */
+ (void)setBadge:(NSInteger)badge;
/**
 *  重置脚标(为0)
*/
+ (void)resetBadge;


@end
