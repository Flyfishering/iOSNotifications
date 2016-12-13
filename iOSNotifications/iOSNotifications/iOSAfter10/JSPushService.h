//
//  NewPushManager.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/9/19.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "JSPushRegisterDelegate.h"
#import "JSPushNotificationIdentifier.h"
#import "JSPushNotificationContent.h"
#import "JSPushNotificationTrigger.h"
#import "JSPushNotificationRequest.h"
#import "JSPushUtilities.h"

#define kLocalNotificationIdentifier        @"kLocalNotificationIdentifier"
#define kLocalNotificationContent           @"kLocalNotificationContent"

#define iOSAbove10 ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOSBelow10 ([[ [UIDevice currentDevice] systemVersion] floatValue] < 10.0)

#define iOS8_10 ([[ [UIDevice currentDevice] systemVersion] floatValue] < 10.0) && ( [[ [UIDevice currentDevice] systemVersion] floatValue] >= 8.0 )
#define iOSBelow8 ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 10.0)


//#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_10_0
#define NewPushSwitchOpen 1
//#endif

/**
 针对iOS 10
 参考：https://onevcat.com/2016/08/notification/
 */
@interface JSPushService : NSObject

+ (instancetype)sharedManager;


/**
 *  register notication
 *  @param types 注册类型 0~7
 *  typs是由三位二进制位构成的，Alert|Sound|Badge
 */
+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories;

+ (void)registerForRemoteNotificationConfig:(JPUSHRegisterEntity *)config delegate:(id<JSPushRegisterDelegate>)delegate;

/**
 *  send device token to your server
 */
+ (void)registerDeviceToken:(NSData*)deviceToken;

#pragma mark - Test

+ (void)buildLocalNotificationForTest;

+ (void)removeDeliveredNotificationForTest;

+ (void)updateDeliveredNotificationForTest;

#pragma makr - Notification

///----------------------------------------------------
/// @name Local Notification 本地通知
///----------------------------------------------------
/*!
 * @abstract 注册或更新推送 (支持iOS10，并兼容iOS10以下版本)
 *
 * JPush 2.1.9新接口
 * @param request JPushNotificationRequest类型，设置推送的属性，设置已有推送的request.requestIdentifier即更新已有的推送，否则为注册新推送，更新推送仅仅在iOS10以上有效，结果通过request.completionHandler返回
 * @discussion 旧的注册本地推送接口被废弃，使用此接口可以替换
 *
 */
+ (void)addNotification:(JSPushNotificationRequest *)jsRequest;

/**
 移除推送

 @param identifier JSPushNotificationIdentifier类型
 
    iOS10以上：
        优先级1：identifier设置为nil，则移除所有在通知中心显示推送和待推送请求；
        优先级2：identifier.identifiers如果设置为nil或空数组，则移除相应标志下所有在通知中心显示通知或待通知请求；
        优先级3：设置identifier.delivered和identifier.identifiers，来除相应在通知中心显示通知或待通知请求对应的多条通知；
 
    iOS10以下：移除通知只针对本地通知，且identifier.delivered属性无效；
        优先级1：identifier设置为nil，则移除所有通知；
        优先级2：identifier.notificationObj传入特定推送对象，移除单条通知；
        优先级3：identifier.identifiers为nil或为空数组，移除所有通知；
        优先级4：identifier.identifiers有效数组，移除多条通知；

 */
+ (void)removeNotification:(JSPushNotificationIdentifier *)identifier;

/**
 查找推送
 @param identifier JSPushNotificationIdentifier类型
    必现设置identifier.findCompletionHandler回调才能得到查找结果，通过(NSArray *results)返回相应对象数组。
    iOS10以上：
        设置identifier.delivered和identifier.identifiers来查找相应在通知中心显示通知或待通知请求，identifier.identifiers如果设置为nil或空数组则返回相应标志下所有在通知中心显示通知或待推送请求；
    iOS10以下：identifier.delivered属性无效
        identifier.identifiers如果设置nil或空数组则，返回所有通知。
 */
+ (void)findNotification:(JSPushNotificationIdentifier *)identifier;

#pragma mark - Push

/*!
 * @abstract 处理收到的 APNs 消息
 */
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

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
