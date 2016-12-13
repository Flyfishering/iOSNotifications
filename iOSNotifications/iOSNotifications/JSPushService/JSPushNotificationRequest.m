//
//  JSPushNotificationRequest.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushNotificationRequest.h"

@implementation JSPushNotificationRequest

- (id)copyWithZone:(NSZone *)zone {
    
    JSPushNotificationRequest *request = [JSPushNotificationRequest new];
    request.requestIdentifier = self.requestIdentifier;
    request.content = self.content;
    request.trigger = self.trigger;
    request.completionHandler = self.completionHandler;
    
    return request;
}

@end
