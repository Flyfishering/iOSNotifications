//
//  JSNotificationIdentifier.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSNotificationIdentifier.h"

@implementation JSNotificationIdentifier

- (id)copyWithZone:(NSZone *)zone {
    
    JSNotificationIdentifier *iden = [JSNotificationIdentifier new];
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
    JSNotificationIdentifier *iden = [[JSNotificationIdentifier alloc] init];
    iden.notificationObj = noti;
    return iden;
}

/**
 移除identifiers对应通知，可通过该方法创建
 */
+ (instancetype)identifireWithIdentifiers:(NSArray <NSString *> *)identifiers
{
    JSNotificationIdentifier *iden = [[JSNotificationIdentifier alloc] init];
    iden.identifiers = identifiers;
    return iden;
}

/**
 iOS 10以上，查找或移除通知
 */
+ (instancetype)identifireWithIdentifiers:(NSArray <NSString *> *)identifiers  state:(JSPushNotificationState)state
{
    JSNotificationIdentifier *iden = [[JSNotificationIdentifier alloc] init];
    iden.identifiers = identifiers;
    iden.state = state;
    return iden;
}

/**
 iOS 10以上查找，可通过该方法创建
 */
+ (instancetype)identifireWithIdentifiers:(NSArray <NSString *> *)identifiers  state:(JSPushNotificationState)state withFindCompletionHandler:(void(^)(NSArray * __nullable results))findCompletionHandler
{
    JSNotificationIdentifier *iden = [[JSNotificationIdentifier alloc] init];
    iden.identifiers = identifiers;
    iden.state = state;
    iden.findCompletionHandler = findCompletionHandler;
    return iden;
}

@end
