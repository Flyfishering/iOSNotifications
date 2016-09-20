//
//  NewPushManager.m
//  PushSettingsDemo
//
//  Created by WengHengcong on 2016/9/19.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "NewPushManager.h"
#import "PushViewController.h"

@implementation NewPushManager

+ (instancetype)sharedManager {
    
    static NewPushManager *shared = nil;
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
    PushViewController *pushVC = (PushViewController *)[[NewPushManager sharedManager] viewController];
    pushVC.devicetoken = newToken;
}

#pragma mark - badge

+ (void)resetBadge {
    [NewPushManager setBadge:0];
}

+ (void)setBadge:(NSInteger)badge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}

#pragma mark - local notification

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
    content.title = @"快起床啦啦啦啦";
    content.subtitle = @"求你了";
    content.body = @"吃早餐去!";
    content.categoryIdentifier = @"wakeup";
    content.launchImageName = @"dog";
    content.sound = [UNNotificationSound defaultSound];
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

#pragma mark - other

- (UIViewController *)viewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    return vc;
}

@end
