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

+ (void)registerPushNotification:(NSDictionary *)launchOptions {
    
    //极光推送
    [JPUSHService setupWithOption:launchOptions appKey:@"0d16cdd32fbdf6849b0a5214" channel:nil apsForProduction:NO];
    [JPUSHService registerForRemoteNotificationTypes:7 categories:nil];
    [JPUSHService setDebugMode];
    
    // Override point for customization after application launch.
    /*
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
     {
     [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
     }
     else
     {
     [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
     }
     */
}

+ (void)handleNotificationApplicationLaunching:(NSDictionary *)launchOptions {
    
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

#pragma mark - device token

+ (void)registerDeviceToken:(NSData*)deviceToken {
    
    if (!deviceToken || ![deviceToken isKindOfClass:[NSData class]])
        return;
    
    NSString * newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"device token is: %@", newToken);
    
    //向服务器注册设备
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

        NSString *mes = dic[kLocalNotificationContent];
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
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        NSDate *currentDate   = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = [currentDate dateByAddingTimeInterval:5.0];
        
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        
        // 设置提醒的文字内容
//        notification.alertTitle = @"起床的闹钟";     //8.2才支持
        notification.alertBody   = @"快起床，快快起床~";
        notification.alertAction = NSLocalizedString(@"删除", nil);
        notification.category = @"life";
        notification.hasAction = YES;
        
        // 通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        
        // 设置应用程序右上角的提醒个数
        notification.applicationIconBadgeNumber++;
        
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
        aUserInfo[kLocalNotificationCategory] = @"生活闹钟";
        aUserInfo[kLocalNotificationContent] = @"起床跑步去，起床背课文啦，马上高考啦。";
        notification.userInfo = aUserInfo;
        
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
}

#pragma mark - badge

+ (void)resetBadge {
    [PushManager setBadge:0];
}

+ (void)setBadge:(NSInteger)badge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;

}

#pragma mark - other

- (UIViewController *)viewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    return vc;
}



@end
