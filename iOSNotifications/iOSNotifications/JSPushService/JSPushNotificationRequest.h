//
//  JSPushNotificationRequest.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSPushNotificationContent.h"
#import "JSPushNotificationTrigger.h"

/*!
 * 注册或更新推送实体类
 */
@interface JSPushNotificationRequest : NSObject<NSCopying, NSCoding>

@property (nonatomic, copy) NSString *requestIdentifier;    // 推送请求标识
@property (nonatomic, copy) JSPushNotificationContent *content; // 设置推送的具体内容
@property (nonatomic, copy) JSPushNotificationTrigger *trigger; // 设置推送的触发方式
@property (nonatomic, copy) void (^completionHandler)(id result); // 注册或更新推送成功回调，iOS10以上成功则result为UNNotificationRequest对象，失败则result为nil;iOS10以下成功result为UILocalNotification对象，失败则result为nil

@end
