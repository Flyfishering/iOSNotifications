//
//  JSNotificationRequest.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSNotificationRequest.h"

@implementation JSNotificationRequest

- (id)copyWithZone:(NSZone *)zone {
    
    JSNotificationRequest *request = [JSNotificationRequest new];
    request.requestIdentifier = self.requestIdentifier;
    request.content = self.content;
    request.trigger = self.trigger;
    request.completionHandler = self.completionHandler;
    
    return request;
}

+ (instancetype)requestWithIdentifier:(NSString *)identifier content:(JSNotificationContent *)content trigger:(nullable JSNotificationTrigger *)trigger withCompletionHandler:(void(^)(id __nullable result))completionHandler
{
    JSNotificationRequest *request = [[JSNotificationRequest alloc] init];
    request.requestIdentifier = identifier;
    request.content = content;
    request.trigger = trigger;
    request.completionHandler = completionHandler;
    
    return request;
}

@end
