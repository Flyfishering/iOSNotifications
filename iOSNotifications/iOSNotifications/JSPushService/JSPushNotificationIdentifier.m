//
//  JSPushNotificationIdentifier.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushNotificationIdentifier.h"

@implementation JSPushNotificationIdentifier

- (id)copyWithZone:(NSZone *)zone {
    
    JSPushNotificationIdentifier *iden = [JSPushNotificationIdentifier new];
    iden.identifiers = self.identifiers;
    iden.state = self.state;
    iden.findCompletionHandler = self.findCompletionHandler;
    
    return iden;
    
}


/**
 iOS 10 以下，移除UILocalNotification可通过该方法创建
 */
+ (instancetype)identifireWithNnotificationObj:(UILocalNotification *)noti
{
    JSPushNotificationIdentifier *iden = [[JSPushNotificationIdentifier alloc] init];
    iden.notificationObj = noti;
    return iden;
}

/**
 移除identifiers对应通知，可通过该方法创建
 */
+ (instancetype)identifireWithIdentifiers:(NSArray <NSString *> *)identifiers
{
    JSPushNotificationIdentifier *iden = [[JSPushNotificationIdentifier alloc] init];
    iden.identifiers = identifiers;
    return iden;
}


/**
 iOS 10以上查找，可通过该方法创建
 */
+ (instancetype)identifireWithIdentifiers:(NSArray <NSString *> *)identifiers  state:(JSPushNotificationState)state withFindCompletionHandler:(void(^)(NSArray * __nullable results))findCompletionHandler
{
    JSPushNotificationIdentifier *iden = [[JSPushNotificationIdentifier alloc] init];
    iden.identifiers = identifiers;
    iden.state = state;
    iden.findCompletionHandler = findCompletionHandler;
    return iden;
}

/**
 iOS 10以上移除通知，可通过该方法创建
 */
+ (instancetype)identifireWithIdentifiers:(NSArray <NSString *> *)identifiers  state:(JSPushNotificationState)state
{
    JSPushNotificationIdentifier *iden = [[JSPushNotificationIdentifier alloc] init];
    iden.identifiers = identifiers;
    iden.state = state;
    return iden;
}

@end
