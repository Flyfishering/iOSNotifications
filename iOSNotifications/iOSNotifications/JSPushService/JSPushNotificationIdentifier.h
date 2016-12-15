//
//  JSPushNotificationIdentifier.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UILocalNotification.h>


/**
 通知的推送状态

 - JSPushNotificationStateAll: 包括pending与delivered
 - JSPushNotificationStatePending: 待推送的通知
 - JSPushNotificationStateDelivered: 已经推送的通知
 */
typedef NS_ENUM(NSUInteger, JSPushNotificationState) {
    JSPushNotificationStateAll,
    JSPushNotificationStatePending,
    JSPushNotificationStateDelivered,
};

@interface JSPushNotificationIdentifier : NSObject<NSCopying, NSCoding>

/**
 通知的标识数组
 */
@property (nonatomic, copy) NSArray<NSString *> *identifiers;

/**
 仅适用与iOS10以下:可以传UILocalNotification对象数据，iOS10以上无效
 用于移除通知
 不适用查找通知
 */
@property (nonatomic, copy) UILocalNotification *notificationObj    NS_DEPRECATED_IOS(4_0, 10_0);

/**
 仅支持iOS 10以上
 标志需要查找或者删除通知的通知状态
 */
@property (nonatomic ,assign) JSPushNotificationState   state  NS_AVAILABLE_IOS(10_0);

/**
 用于查询回调，调用[findNotification:]方法前必须设置
 results为返回相应对象数组
 iOS10以下：返回UILocalNotification对象数组；
 iOS10以上：根据delivered传入值返回UNNotification或UNNotificationRequest对象数组
 （delivered传入YES，则返回UNNotification对象数组，否则返回UNNotificationRequest对象数组）
 */
@property (nonatomic, copy) void (^findCompletionHandler)(NSArray *results);

@end
