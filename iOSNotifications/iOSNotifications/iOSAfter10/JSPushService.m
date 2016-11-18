//
//  NewPushManager.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/9/19.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushService.h"
#import "PushViewController.h"

/***  Log */
# define JSPUSHLog(str, ...) [self jspush_file:((char *)__FILE__) function:((char *)__FUNCTION__) line:(__LINE__) format:(str),##__VA_ARGS__]

@implementation JSPushService

+ (instancetype)sharedManager {
    
    static JSPushService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}



+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
            }
        }];
        
    }
    
    
}

#pragma mark - device token

+ (void)registerDeviceToken:(NSData*)deviceToken {
    
    if (!deviceToken || ![deviceToken isKindOfClass:[NSData class]])
        return;
    
    NSString * newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"device token is: %@", newToken);
    
    //show
    PushViewController *pushVC = (PushViewController *)[[JSPushService sharedManager] viewController];
    pushVC.devicetoken = newToken;
}

#pragma mark - badge

+ (void)resetBadge {
    [JSPushService setBadge:0];
}

+ (void)setBadge:(NSInteger)badge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}

#pragma mark - local notification for test

+ (void)buildLocalNotificationForTest
{
    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * imageUrl = [[NSBundle mainBundle] URLForResource:@"dog" withExtension:@"png"];
    UNNotificationAttachment *imgAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:imageUrl options:nil error:&error];
    
    NSURL * mp4Url = [[NSBundle mainBundle] URLForResource:@"media" withExtension:@"mp4"];
    UNNotificationAttachment *mediaAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:mp4Url options:nil error:&error];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    //在通知中心显示的总是第一个多媒体资源
    content.attachments = @[mediaAtt,imgAtt];
    content.badge = @1;
    content.title = @"起床闹钟";
    content.subtitle = @"第一次起床";
    content.body = @"起床反反复复。。。 ";
    content.categoryIdentifier = @"wakeup";
    content.launchImageName = @"dog";
    content.sound = [UNNotificationSound soundNamed:@"wake.caf"];
//    content.threadIdentifier = @"";
    content.userInfo = @{@"first":@"5:00 am",@"second":@"6:00"};
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5.0 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"com.junglesong.pushtestdemo.wakeup" content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"wake up message has been deliverd!");
    }];
}

+ (void)removeDeliveredNotificationForTest
{
    //移除展示过的通知
    [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        
        for (UNNotification *noti in notifications) {
            NSLog(@"Delivered Notification %@-%@",noti.request.content.title,noti.request.content.body);
        }
        
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[@"com.junglesong.pushtestdemo.wakeup"]];

    }];
    
    //移除未展示过的通知
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        
        for (UNNotificationRequest *req in requests) {
            NSLog(@"Pending Notification %@-%@",req.content.title,req.content.body);
        }
        
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[@"com.junglesong.pushtestdemo.wakeup"]];
        
    }];
    
}

+ (void)updateDeliveredNotificationForTest
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.badge = @1;
    content.title = @"更新啦！亲，快起床";
    content.subtitle = @"更新啦！亲，求你了";
    content.body = @"更新啦！吃早餐去!";
    content.categoryIdentifier = @"wakeup";
    content.launchImageName = @"dog";
    content.sound = [UNNotificationSound defaultSound];
    //    content.threadIdentifier = @"";
    content.userInfo = @{@"first":@"5:00 am",@"second":@"6:00"};
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5.0 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"com.junglesong.pushtestdemo.wakeup" content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"wake up message has been updated!");
    }];

}

#pragma mark - Public Methods

+ (void)addNotification:(JSPushNotificationRequest *)jsRequest {
    
    if (iOSAbove10) {
        
        //convert JSPushNotificationRequest to UNNotificationRequest
        UNNotificationRequest *request = [self convertJSPushNotificationRequestToUNNotificationRequest:jsRequest];
        if (request != nil) {
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                //注册或更新推送成功回调，iOS10以上成功则result为UNNotificationRequest对象，失败则result为nil
                id result = error ? nil : request;
                
                if (jsRequest.completionHandler) {
                    jsRequest.completionHandler(result);
                }
            }];
        }

    }else{
        
    }
}

#pragma mark - other

- (UIViewController *)viewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    return vc;
}

#pragma mark - Private Methods

+ (nullable UNNotificationRequest *)convertJSPushNotificationRequestToUNNotificationRequest:(JSPushNotificationRequest *)jsRequest {
    
    if (jsRequest == nil) {
        JSPUSHLog(@"error-request is nil!");
        return nil;
    }
    
    UNNotificationContent *content = [self convertJSPushNotificationContentToUNNotificationContent:jsRequest.content];
    if (content == nil) {
        JSPUSHLog(@"error-request content is nil!");
        return nil;
    }
    UNNotificationTrigger *trigger = [self convertJSPushNotificationTriggerToUNPushNotificationTrigger:jsRequest.trigger];
    if (trigger == nil) {
        JSPUSHLog(@"error-request trigger is nil!");
        return nil;
    }
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:jsRequest.requestIdentifier content:content trigger:trigger];
    return request;
}

+ (nullable UNNotificationContent *)convertJSPushNotificationContentToUNNotificationContent:(JSPushNotificationContent *)jsContent {
    
    if (jsContent == nil) {
        JSPUSHLog(@"error-content is nil!");
        return nil;
    }
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = jsContent.title;
    content.subtitle = jsContent.subtitle;
    content.body = jsContent.body;
    content.badge = jsContent.badge;
    content.categoryIdentifier = jsContent.categoryIdentifier;
    content.userInfo = jsContent.userInfo;
    
    //假如sound为空，或者为default，设置为默认声音
    if (jspush_validateString(jsContent.sound)  || [jsContent.sound isEqualToString:@"default"]) {
        content.sound = [UNNotificationSound defaultSound];
    }else{
        content.sound = [UNNotificationSound soundNamed:jsContent.sound];
    }
    
    content.attachments = jsContent.attachments;
    content.threadIdentifier = jsContent.threadIdentifier;
    content.launchImageName = jsContent.launchImageName;
    
    return content;
}

+ (nullable UNNotificationTrigger *)convertJSPushNotificationTriggerToUNPushNotificationTrigger:(JSPushNotificationTrigger *)jsTrigger {
    
    if (jsTrigger == nil) {
        JSPUSHLog(@"error-trigger is nil!");
        return nil;
    }
    
    UNNotificationTrigger *trigger = nil;
    
    if (jsTrigger.region != nil) {
        trigger = [UNLocationNotificationTrigger triggerWithRegion:jsTrigger.region repeats:jsTrigger.repeat];
    }else if (jsTrigger.dateComponents != nil){
        trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:jsTrigger.dateComponents repeats:jsTrigger.repeat];
    }else{
        trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:jsTrigger.timeInterval repeats:jsTrigger.repeat];
    }
    
    return trigger;
}


# pragma mark - Check Nil

BOOL jspush_validateString(NSString * str)
{
    if (str && [str isKindOfClass:[NSString class]] && str.length > 0)
    {
        return YES;
    }
    return NO;
}

BOOL jspush_validateDictionary(NSDictionary * dic)
{
    if (dic && [dic isKindOfClass:[NSDictionary class]] && dic.allKeys.count > 0)
    {
        return YES;
    }
    return NO;
}

# pragma mark - Log

+ (void)jspush_file:(char *)sourceFile function:(char *)functionName line:(int)lineNumber format:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
//    NSString * file = [NSString stringWithCString:sourceFile encoding:NSUTF8StringEncoding];
    //        NSString * func = [NSString stringWithCString:functionName encoding:NSUTF8StringEncoding];
    NSString * log  = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
//    NSLog(@"%@:%d %@; ", [file lastPathComponent], lineNumber, log);
    NSLog(@"JSPUSHLog:%@",log);

}

@end
