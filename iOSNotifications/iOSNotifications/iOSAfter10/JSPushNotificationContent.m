//
//  JSPushNotificationContent.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushNotificationContent.h"

@implementation JSPushNotificationContent

- (id)copyWithZone:(NSZone *)zone {
    
    JSPushNotificationContent *content = [JSPushNotificationContent new];
    content.title = self.title;
    content.subtitle = self.subtitle;
    content.body = self.body;
    content.badge = self.badge;
    content.action = self.action;
    content.categoryIdentifier = self.categoryIdentifier;
    content.userInfo = self.userInfo;
    content.sound = self.sound;
    content.attachments = self.attachments;
    content.threadIdentifier = self.threadIdentifier;
    content.launchImageName = self.launchImageName;
    
    return content;
    
}

@end
