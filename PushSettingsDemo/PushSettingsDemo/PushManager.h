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
//type is 7,that means notification type contain alert、alert and sound，no category
+ (void)registerForRemoteNotificationAllTypesWithcategories:(NSSet *)categories;

/**
 *  send device token to your server
 */
+ (void)registerDeviceToken:(NSData*)deviceToken;

/**
 *  handle remote/local notification
 */
+ (void)handleLocalNotification:(UILocalNotification *)notification;
+ (void)handleRemoteNotification:(NSDictionary *)userinfo;



///----------------------------------------------------
/// @name Local Notification 本地通知
///----------------------------------------------------


+ (void)buildUILocalNotificationWithNSDate:(NSDate *)date alert:(NSString *)alert badge:(int)badge identifierKey:(NSString *)identitifierKey userInfo:(NSDictionary *)userInfo;
/*!
 * @abstract 本地推送，最多支持64个
 *
 * @param fireDate 本地推送触发的时间
 * @param alertBody 本地推送需要显示的内容
 * @param badge 角标的数字。如果不需要改变角标传-1
 * @param alertAction 弹框的按钮显示的内容（IOS 8默认为"打开", 其他默认为"启动"）
 * @param notificationKey 本地推送标示符
 * @param userInfo 自定义参数，可以用来标识推送和增加附加信息
 * @param soundName 自定义通知声音，设置为nil为默认声音
 *
 * @discussion 最多支持 64 个定义
 */
+ (UILocalNotification *)setLocalNotification:(NSDate *)fireDate
                                    alertBody:(NSString *)alertBody
                                        badge:(int)badge
                                  alertAction:(NSString *)alertAction
                                identifierKey:(NSString *)notificationKey
                                     userInfo:(NSDictionary *)userInfo
                                    soundName:(NSString *)soundName;

/*!
 * @abstract 本地推送 (支持 iOS8 新参数)
 *
 * IOS8新参数
 * @param region 自定义参数
 * @param regionTriggersOnce 自定义参数
 * @param category 自定义参数
 */
+ (UILocalNotification *)setLocalNotification:(NSDate *)fireDate
                                   alertTitle:(NSString *)alertTitle
                                    alertBody:(NSString *)alertBody
                                        badge:(int)badge
                                  alertAction:(NSString *)alertAction
                                identifierKey:(NSString *)notificationKey
                                     userInfo:(NSDictionary *)userInfo
                                    soundName:(NSString *)soundName
                                       region:(CLRegion *)region
                           regionTriggersOnce:(BOOL)regionTriggersOnce
                                     category:(NSString *)category NS_AVAILABLE_IOS(8_0);

/*!
 * @abstract 前台展示本地推送
 *
 * @param notification 本地推送对象
 * @param notificationKey 需要前台显示的本地推送通知的标示符
 *
 * @discussion 默认App在前台运行时不会进行弹窗，在程序接收通知调用此接口可实现指定的推送弹窗。
 */
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification
                       identifierKey:(NSString *)notificationKey;
/*!
 * @abstract 删除本地推送定义
 *
 * @param notificationKey 本地推送标示符
 * @param myUILocalNotification 本地推送对象
 */
+ (void)deleteLocalNotificationWithIdentifierKey:(NSString *)notificationKey;

/*!
 * @abstract 删除本地推送定义
 */
+ (void)deleteLocalNotification:(UILocalNotification *)localNotification;

/*!
 * @abstract 获取指定通知
 *
 * @param notificationKey 本地推送标示符
 * @return 本地推送对象数组, [array count]为0时表示没找到
 */
+ (NSArray *)findLocalNotificationWithIdentifier:(NSString *)notificationKey;

/*
 *  清除所有本地推送对象
 */
+ (void)clearAllLocalNotifications;


///----------------------------------------------------
/// @name badge
///----------------------------------------------------

/**
 *  设置应用角标
 */
+ (void)setBadge:(NSInteger)badge;
/**
 *  重置脚标(为0)
*/
+ (void)resetBadge;


@end
