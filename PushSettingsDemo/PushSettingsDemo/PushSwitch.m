//
//  PushSwitch.m
//  PushSettingsDemo
//
//  Created by WengHengcong on 2016/11/16.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "PushSwitch.h"

#import "PushManager.h"
#import "NewPushManager.h"
#import "UILocalNotificationManager.h"
#import "UNLocalNotificationManager.h"

@implementation PushSwitch

+ (void)registePushWithClass:(id<UNUserNotificationCenterDelegate>)class  option:(NSDictionary*)launchOptions
{
    if (NewPushSwitchOpen) {
        //iOS 10以上，通知代理设置，不设置，代理不调用。
        //在锁屏界面，通知栏，需要点击“查看”，才会显示“接受”、“拒绝”的按钮
        
        [UNUserNotificationCenter currentNotificationCenter].delegate = class;
        
        UNNotificationAction *acceptAction = [UNNotificationAction actionWithIdentifier:@"acceptAction" title:@"接受" options:UNNotificationActionOptionDestructive];
        
        UNNotificationAction *rejectAction = [UNNotificationAction actionWithIdentifier:@"rejectAction" title:@"拒绝" options:UNNotificationActionOptionForeground];
        
        //注意，输入的action，点击action后，会在Action列表显示：接受、拒绝、输入你想几点起
        UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"inputAction" title:@"输入你想几点起" options:UNNotificationActionOptionForeground textInputButtonTitle:@"确定" textInputPlaceholder:@"再晚1小时吧"];
        
        UNNotificationCategory *categorys = [UNNotificationCategory categoryWithIdentifier:@"wakeup" actions:@[acceptAction,rejectAction,inputAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        
        
        [NewPushManager registerForRemoteNotificationTypes:7 categories:[NSSet setWithObjects:categorys,nil]];

    }else{
        /***************************测试category*******************************/
        /*注意：以下action注册，只在iOS10之前有效！！！  */
        //apns: {"aps":{"alert":"测试推送的快捷回复", "sound":"default", "badge": 1, "category":"alert"}}
        
        [PushManager setupWithOption:launchOptions];

         //接受按钮
         UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
         acceptAction.identifier = @"acceptAction";
         acceptAction.title = @"接受";
         acceptAction.activationMode = UIUserNotificationActivationModeForeground;  //当点击的时候，启动应用
         //拒绝按钮
         UIMutableUserNotificationAction *rejectAction = [[UIMutableUserNotificationAction alloc] init];
         rejectAction.identifier = @"rejectAction";
         rejectAction.title = @"拒绝";
         rejectAction.activationMode = UIUserNotificationActivationModeBackground;   //当点击的时候，不启动应用程序，在后台处理
         rejectAction.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
         rejectAction.destructive = YES; //显示红色按钮（销毁、警告类按钮）
         
         UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
         categorys.identifier = @"wakeup";
         NSArray *actions = @[acceptAction, rejectAction];
         [categorys setActions:actions forContext:UIUserNotificationActionContextMinimal];
         
         [PushManager registerForRemoteNotificationTypes:7 categories:[NSSet setWithObjects:categorys,nil]];
        
    }
}

+ (void)resetBadge
{
    if (NewPushSwitchOpen) {
        [NewPushManager resetBadge];
    }else{
        [PushManager resetBadge];
    }
}

+ (void)registerDeviceToken:(NSData*)deviceToken
{
    if (NewPushSwitchOpen) {
        [NewPushManager registerDeviceToken:deviceToken];
    }else{
        [PushManager registerDeviceToken:deviceToken];
    }
}

+ (void)handleLocalNotification:(UILocalNotification *)notification {
    
    if (NewPushSwitchOpen) {
        [UILocalNotificationManager handleLocalNotification:notification];
    }else{
        
    }
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo {
    
    if (NewPushSwitchOpen) {

    }else{
        [PushManager handleRemoteNotification:userInfo];
    }
}

@end
