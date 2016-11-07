//
//  PushManager.m
//  PushSettingsDemo
//
//  Created by WengHengcong on 16/6/6.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "PushManager.h"
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

+ (void)setupWithOption:(NSDictionary *)launchOptions {
    
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
        NSLog(@"setup-%@",remoteDictionary[@"seg"]);
    }
    
    // 本地消息
    else if (localDictionary != nil)
    {
        // 本地消息
        NSLog(@"setup-%@",remoteDictionary[@"seg"]);
    }
}

+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
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
    
    //show
    PushViewController *pushVC = (PushViewController *)[[PushManager sharedManager]viewController];
    pushVC.devicetoken = newToken;
}

#pragma mark - handle remote/local notification

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

#pragma mark - badge

+ (void)resetBadge {
    [PushManager setBadge:0];
}

+ (void)setBadge:(NSInteger)badge {
    [UIApplication sharedApplication].applicationIconBadgeNumber--;
}


#pragma mark - other

- (UIViewController *)viewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    return vc;
}

@end
