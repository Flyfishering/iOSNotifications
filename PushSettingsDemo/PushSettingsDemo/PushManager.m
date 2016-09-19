//
//  PushManager.m
//  PushSettingsDemo
//
//  Created by WengHengcong on 16/6/6.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "PushManager.h"
#import "JPUSHService.h"
#import "PushViewController.h"


#define JSPUSH_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


@implementation PushManager

+ (instancetype)sharedManager {
    
    static PushManager *shared = nil;
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

#pragma mark - registe push notification

+ (void)setupWithOption:(NSDictionary *)launchOptions {
    
    //极光推送
//    [JPUSHService setupWithOption:launchOptions appKey:@"0d16cdd32fbdf6849b0a5214" channel:nil apsForProduction:NO];
    
    //在app没有被启动的时候，接收到了消息通知。这时候操作系统会按照默认的方式来展现一个alert消息，在app icon上标记一个数字，甚至播放一段声音。
    
    //用户看到消息之后，点击了一下action按钮或者点击了应用图标。如果action按钮被点击了，系统会通过调用application:didFinishLaunchingWithOptions:这个代理方法来启动应用，并且会把notification的payload数据传递进去。如果应用图标被点击了，系统也一样会调用application:didFinishLaunchingWithOptions:这个代理方法来启动应用，唯一不同的是这时候启动参数里面不会有任何notification的信息。
    NSLog(@"*** push original info:%@",launchOptions);
    
    NSDictionary* remoteDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSDictionary* localDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    //iOS8.0新增Today Widget
    NSURL * launchUrl              = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    NSString * sourceApplicationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
    if (remoteDictionary != nil)
    {
        //处理app未启动的情况下，push跳转
        
    }
    
    // 本地消息
    else if (localDictionary != nil)
    {
        // 本地消息
        
    }
}

+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories
{
    //极光推送
//    [JPUSHService registerForRemoteNotificationTypes:7 categories:nil];
//    [JPUSHService setDebugMode];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
            }
        }];
        
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        UIUserNotificationType types = UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
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
    
    //HCTODO:向服务器注册设备
    [JPUSHService registerDeviceToken:deviceToken];
    //show
    PushViewController *pushVC = (PushViewController *)[[PushManager sharedManager]viewController];
    pushVC.devicetoken = newToken;
}

#pragma mark - handle remote/local notification

+ (void)handleLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"***local noticaion ***\n%@",notification);
    
    PushViewController *pushVC = (PushViewController *)[[PushManager sharedManager]viewController];

    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSDictionary *dic = notification.userInfo;
        pushVC.localNoti = notification;

        NSString *mes = [dic objectForKey:kLocalNotificationContent];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"本地通知" message:mes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        [alert show];
        
    }else{
        pushVC.localNoti = notification;
    }
}

+ (void)handleRemoteNotification:(NSDictionary *)userinfo {
    
    NSLog(@"***remote notication ***\n%@",userinfo);
    //show
    PushViewController *pushVC = (PushViewController *)[[PushManager sharedManager]viewController];
    pushVC.remoteNoti = userinfo;
    
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"App Background");
        
    }else {
        NSLog(@"App Foreground");
        
    }
}

#pragma mark - local notification

+ (void)buildUILocalNotificationWithNSDate:(NSDate *)date alert:(NSString *)alert badge:(int)badge identifierKey:(NSString *)identitifierKey userInfo:(NSDictionary *)userInfo {
    
    /*
     //极光推送
     NSDate *now = [NSDate date];
     NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar] ;
     NSDateComponents *componentsForFireDate = [calendar components:(NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit ) fromDate:now];
     NSInteger fireSeconds = [componentsForFireDate second]+1;
     [componentsForFireDate setSecond:fireSeconds] ;
     
     NSDate *fireDateOfNotification = [calendar dateFromComponents: componentsForFireDate];
     
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0f ) {
     
     UILocalNotification *localNoti = [JPUSHService setLocalNotification:fireDateOfNotification alertBody:alert badge:0 alertAction:nil identifierKey:identitifierKey userInfo:userInfo soundName:UILocalNotificationDefaultSoundName region:nil regionTriggersOnce:NO category:nil];
     localNoti.repeatInterval = 0;
     }else
     {
     UILocalNotification *localNoti = [JPUSHService setLocalNotification:fireDateOfNotification alertBody:alert badge:0 alertAction:nil identifierKey:identitifierKey userInfo:userInfo soundName:UILocalNotificationDefaultSoundName];
     localNoti.repeatInterval = 0;
     }
     */
    
    // 初始化本地通知对象
    UILocalNotification *notification = [PushManager setLocalNotification:date alertBody:@"快起床，快快起床~" badge:badge alertAction:@"起床" identifierKey:identitifierKey userInfo:userInfo soundName:nil];
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
   UILocalNotification *notification = [PushManager setLocalNotification:fireDate alertTitle:nil alertBody:alertBody badge:badge alertAction:nil identifierKey:notificationKey userInfo:userInfo soundName:soundName region:nil regionTriggersOnce:NO category:nil];
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
    
    NSArray *notis = [[PushManager sharedManager]getAllLocalNofication];
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
    
    NSArray *notis = [[PushManager sharedManager]getAllLocalNofication];
    
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
    
    NSArray *notis = [[PushManager sharedManager]getAllLocalNofication];
    
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

#pragma mark - badge

+ (void)resetBadge {
    [PushManager setBadge:0];
}

+ (void)setBadge:(NSInteger)badge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}

#pragma mark - private

- (NSArray *)getAllLocalNofication {
    return [[UIApplication sharedApplication] scheduledLocalNotifications];
}

#pragma mark - other

- (UIViewController *)viewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    return vc;
}




@end
