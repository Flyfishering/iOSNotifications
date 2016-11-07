//
//  LocalNotificationManager.m
//  PushSettingsDemo
//
//  Created by WengHengcong on 2016/9/23.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "UILocalNotificationManager.h"

#define JSPUSH_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

@implementation UILocalNotificationManager

+ (void)handleRemoteNotification:(NSDictionary *)userinfo {
    
    NSLog(@"***remote notication ***\n%@",userinfo);
    //show
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"App Background");
        
    }else {
        NSLog(@"App Foreground");
        
    }
}

#pragma mark - local notification

+ (void)buildUILocalNotificationWithNSDate:(NSDate *)date alert:(NSString *)alert badge:(int)badge identifierKey:(NSString *)identitifierKey userInfo:(NSDictionary *)userInfo {
    
    // 初始化本地通知对象
    UILocalNotification *notification = [UILocalNotificationManager setLocalNotification:date alertBody:@"快起床，快快起床~" badge:badge alertAction:@"起床" identifierKey:identitifierKey userInfo:userInfo soundName:nil];
    // 将通知添加到系统中
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

+ (UILocalNotification *)setLocalNotification:(NSDate *)fireDate
                                    alertBody:(NSString *)alertBody
                                        badge:(int)badge
                                  alertAction:(NSString *)alertAction
                                identifierKey:(NSString *)notificationKey
                                     userInfo:(NSDictionary *)userInfo
                                    soundName:(NSString *)soundName
{
    UILocalNotification *notification = [UILocalNotificationManager setLocalNotification:fireDate alertTitle:nil alertBody:alertBody badge:badge alertAction:nil identifierKey:notificationKey userInfo:userInfo soundName:soundName region:nil regionTriggersOnce:NO category:nil];
    return notification;
}


+ (UILocalNotification *)setLocalNotification:(NSDate *)fireDate
                                   alertTitle:(NSString *)alertTitle
                                    alertBody:(NSString *)alertBody
                                        badge:(int)badge
                                  alertAction:(NSString *)alertAction
                                identifierKey:(NSString *)notificationKey
                                     userInfo:(NSDictionary *)userInfo
                                    soundName:(NSString *)soundName
                                       region:(CLRegion *)region
                           regionTriggersOnce:(BOOL)regionTriggersOnce
                                     category:(NSString *)category NS_AVAILABLE_IOS(8_0) {
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = fireDate;
        
        // 设置重复间隔
        //        notification.repeatInterval = kCFCalendarUnitDay;
        
        // 设置提醒的文字内容
        if(JSPUSH_SYSTEM_VERSION_GREATER_THAN(@"8.2")){
            notification.alertTitle = alertTitle;     //8.2才支持,默认是应用名称
        }
        notification.alertBody   = alertBody;     //显示主体
        notification.category = category;
        
        //设置侧滑按钮文字
        notification.hasAction = YES;
        notification.alertAction = alertAction;
        
        // 通知提示音
        if(soundName){
            notification.soundName = soundName;     //默认提示音：UILocalNotificationDefaultSoundName
        }else{
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        
        // 设置应用程序右上角的提醒个数
        if(badge == -1){
            //-1,不改变
        }else if(badge == 0){
            //applicationIconBadgeNumber,
            //0 means no change. defaults to 0
            notification.applicationIconBadgeNumber++;
        }else{
            notification.applicationIconBadgeNumber = badge;
        }
        
        //设置地理位置
        if(region){
            notification.region = region;
            notification.regionTriggersOnce = regionTriggersOnce;
        }
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = nil;
        if(userInfo){
            aUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        }else{
            aUserInfo = [NSMutableDictionary dictionary];
        }
        aUserInfo[kLocalNotificationIdentifier] = notificationKey;
        notification.userInfo = [aUserInfo copy];
        
    }
    return notification;
}


+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification identifierKey:(NSString *)notificationKey {
    
}

+ (void)deleteLocalNotificationWithIdentifierKey:(NSString *)notificationKey {
    
    if ( (notificationKey == nil) || (notificationKey.length <= 0) || ([notificationKey isEqualToString:@" "]) ) return;
    
    NSArray *notis = [UILocalNotificationManager getAllLocalNofication];
    for (UILocalNotification *noti in notis) {
        if (noti.userInfo == nil)  return;
        NSString *identifier =  noti.userInfo[kLocalNotificationIdentifier];
        if ([identifier isEqualToString:notificationKey]) {
            [[UIApplication sharedApplication]cancelLocalNotification:noti];
        }
    }
}


+ (void)deleteLocalNotification:(UILocalNotification *)localNotification {
    
    if (localNotification == nil) return;
    if (localNotification.userInfo == nil)  return;
    NSString *notificationKey = localNotification.userInfo[kLocalNotificationIdentifier];
    
    if ( (notificationKey == nil) || (notificationKey.length <= 0) || ([notificationKey isEqualToString:@" "]) ) return;
    
    NSArray *notis = [UILocalNotificationManager getAllLocalNofication];
    
    for (UILocalNotification *noti in notis) {
        NSString *identifier =  noti.userInfo[kLocalNotificationIdentifier];
        if ([identifier isEqualToString:notificationKey]) {
            [[UIApplication sharedApplication]cancelLocalNotification:noti];
        }
    }
}


+ (NSArray *)findLocalNotificationWithIdentifier:(NSString *)notificationKey {
    
    NSMutableArray *finds = [NSMutableArray array];
    
    if ( (notificationKey == nil) || (notificationKey.length <= 0) || ([notificationKey isEqualToString:@" "]) ){
        return [finds copy];
    }
    
    NSArray *notis = [UILocalNotificationManager getAllLocalNofication];
    
    for (UILocalNotification *noti in notis) {
        NSString *identifier =  noti.userInfo[kLocalNotificationIdentifier];
        if ([identifier isEqualToString:notificationKey]) {
            [finds addObject:noti];
        }
    }
    
    return [finds copy];
}


+ (void)clearAllLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - private
                      
+ (NSArray *)getAllLocalNofication {
  return [[UIApplication sharedApplication] scheduledLocalNotifications];
}
              
#pragma mark - Handle
                      
+ (void)handleLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"***local noticaion ***\n%@",notification);
    
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSDictionary *dic = notification.userInfo;
        
        NSString *mes = [dic objectForKey:kLocalNotificationContent];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"本地通知" message:mes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        [alert show];
        
    }else{
        
    }
}
@end
