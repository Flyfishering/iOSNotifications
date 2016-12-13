//
//  JSPushNotificationIdentifier.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSPushNotificationIdentifier : NSObject<NSCopying, NSCoding>

/**
 推送的标识数组
 */
@property (nonatomic, copy) NSArray<NSString *> *identifiers;

/**
 iOS10以下可以传UILocalNotification对象数据，iOS10以上无效
 用于查找或者移除通知
 */
@property (nonatomic, copy) UILocalNotification *notificationObj    NS_DEPRECATED_IOS(4_0, 10_0);


/**
 在通知中心显示的或待推送的标志，默认为NO
 YES:在通知中心显示的，
 NO:表示待推送的
 */
@property (nonatomic, assign) BOOL delivered NS_AVAILABLE_IOS(10_0);

/**
 用于查询回调，调用[findNotification:]方法前必须设置
 results为返回相应对象数组
 iOS10以下返回UILocalNotification对象数组；
 iOS10以上根据delivered传入值返回UNNotification或UNNotificationRequest对象数组
 （delivered传入YES，则返回UNNotification对象数组，否则返回UNNotificationRequest对象数组）
 */
@property (nonatomic, copy) void (^findCompletionHandler)(NSArray *results);

@end
