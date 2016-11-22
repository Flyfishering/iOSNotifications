//
//  JSPushNotificationTrigger.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushNotificationTrigger.h"

@implementation JSPushNotificationTrigger

- (id)copyWithZone:(NSZone *)zone {
    
    JSPushNotificationTrigger *trigger = [JSPushNotificationTrigger new];
    trigger.repeat = self.repeat;
    trigger.fireDate = self.fireDate;
    trigger.region = self.region;
    trigger.dateComponents = self.dateComponents;
    trigger.timeInterval = self.timeInterval;
    
    return trigger;
}

@end
