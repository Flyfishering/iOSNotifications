//
//  JSNotificationContent.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSNotificationContent.h"

@implementation JSNotificationContent

- (id)copyWithZone:(NSZone *)zone {
    
    JSNotificationContent *content = [JSNotificationContent new];
    content.title = self.title;
    content.subtitle = self.subtitle;
    content.body = self.body;
    content.badge = self.badge;
    content.action = self.action;
    content.categoryIdentifier = self.categoryIdentifier;
    content.userInfo = self.userInfo;
    content.sound = self.sound;
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    content.attachments = self.attachments;
    content.threadIdentifier = self.threadIdentifier;
    content.launchImageName = self.launchImageName;
#endif
    return content;
}

@end
