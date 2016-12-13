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
    iden.delivered = self.delivered;
    iden.findCompletionHandler = self.findCompletionHandler;
    
    return iden;
    
}

@end
