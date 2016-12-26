//
//  JSNotificationTrigger.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSNotificationTrigger.h"

@implementation JSNotificationTrigger

- (id)copyWithZone:(NSZone *)zone {
    
    JSNotificationTrigger *trigger = [JSNotificationTrigger new];
    trigger.repeat = self.repeat;
    trigger.fireDate = self.fireDate;
    trigger.region = self.region;
    trigger.dateComponents = self.dateComponents;
    trigger.timeInterval = self.timeInterval;
    
    return trigger;
}

+ (instancetype)triggerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats
{
    JSNotificationTrigger *trigger = [[JSNotificationTrigger alloc] init];
    NSDate *currentDate   = [NSDate date];
    currentDate = [currentDate dateByAddingTimeInterval:timeInterval];
    trigger.fireDate = currentDate;
    trigger.repeat = repeats;
    
    return trigger;
}

+ (instancetype)triggerWithDateMatchingComponents:(NSDateComponents *)dateComponents repeats:(BOOL)repeats
{
    JSNotificationTrigger *trigger = [[JSNotificationTrigger alloc] init];
    trigger.dateComponents = dateComponents;
    trigger.repeat = repeats;
    
    return trigger;
}

+ (instancetype)triggerWithRegion:(CLRegion *)region repeats:(BOOL)repeats __WATCHOS_PROHIBITED
{
    JSNotificationTrigger *trigger = [[JSNotificationTrigger alloc] init];
    trigger.region = region;
    trigger.repeat = repeats;
    
    return trigger;
}

@end
