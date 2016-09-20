//
//  NewPushManager.h
//  PushSettingsDemo
//
//  Created by WengHengcong on 2016/9/19.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"


/**
 针对iOS 10 的Push Manager
 参考：https://onevcat.com/2016/08/notification/
 */
@interface NewPushManager : NSObject

+ (instancetype)sharedManager;


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

#pragma mark - Test

+ (void)buildLocalNotificationForTest;

+ (void)removeDeliveredNotificationForTest;

+ (void)updateDeliveredNotificationForTest;

/**
 *  设置应用角标
 */
+ (void)setBadge:(NSInteger)badge;
/**
 *  重置脚标(为0)
 */
+ (void)resetBadge;

@end
