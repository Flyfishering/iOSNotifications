//
//  AppDelegate.m
//  PushSettingsDemo
//
//  Created by WengHengcong on 4/20/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import "PushManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [PushManager setupWithOption:launchOptions];
    
    /***************************测试category*******************************/
    /*注意：以下action注册，只在iOS10之前有效！！！  */
    //apns: {"aps":{"alert":"测试推送的快捷回复", "sound":"default", "badge": 1, "category":"alert"}}
    
    /*
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
     */
    
    /**********************************************************/
    //iOS 10以上，通知代理设置，不设置，代理不调用。
    //Above iOS 10,you must set the UNUserNotificationCenter delegate first before invoke the UNUserNotificationCenterDelegate
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    UNNotificationAction *acceptAction = [UNNotificationAction actionWithIdentifier:@"acceptAction" title:@"接受" options:UNNotificationActionOptionDestructive];
    
    UNNotificationAction *rejectAction = [UNNotificationAction actionWithIdentifier:@"rejectAction" title:@"拒绝" options:UNNotificationActionOptionForeground];
    
    UNNotificationCategory *categorys = [UNNotificationCategory categoryWithIdentifier:@"wakeup" actions:@[acceptAction,rejectAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    
    [PushManager registerForRemoteNotificationTypes:7 categories:[NSSet setWithObjects:categorys,nil]];

    [PushManager resetBadge];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Push Message Handler
/**
 *  This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
 *  iOS8后需要支持
 *  根据我们提供的注册通知类型，就是UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge
 *  以及用户在“设置”中开关的值做比较。
 *  来决定本地和远程支持的类型。
 *  其中在第二个参数的notificationSettings是“设置”中的值。
 *
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Calling this will result in either application:didRegisterForRemoteNotificationsWithDeviceToken: or application:didFailToRegisterForRemoteNotificationsWithError: to be called on the application delegate. Note: these callbacks will be made only if the application has successfully registered for user notifications with registerUserNotificationSettings:, or if it is enabled for Background App Refresh.
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        //registerForRemoteNotifications方法调用后会application:didRegisterForRemoteNotificationsWithDeviceToken或application:didFailToRegisterForRemoteNotificationsWithError
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

/**
 *  registerForRemoteNotifications的回调
 */
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [PushManager registerDeviceToken:deviceToken];
}
/**
 *  registerForRemoteNotifications的回调
 */
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"*** register failed.");
}

#pragma mark - action remote
/**
 *  Called when your app has been activated by the user selecting an action from a remote notification.
 *  8.0 above
 *  当操作交互式通知时，进入这里
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"acceptAction"]){
    }
    else if ([identifier isEqualToString:@"rejectAction"]){
    }
     //注意调用该函数！！！！
    completionHandler();
}
/**
 *  Called when your app has been activated by the user selecting an action from a remote notification.
 *  9.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    
    //注意调用该函数！！！！
    completionHandler();
}


#pragma mark - action local
/**
 *  Called when your app has been activated by the user selecting an action from a local notification.
 *  8.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
    //注意调用该函数！！！！
    completionHandler();
}
/**
 *  Called when your app has been activated by the user selecting an action from a local notification.
 *  9.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler {

    //注意调用该函数！！！！
    completionHandler();
}

#pragma mark - local/remote handle

/**
 *  iOS 10之前，若未实现该代理application didReceiveRemoteNotification: fetchCompletionHandler:
        不管在前台还是在后台，收到远程推送会进入didReceiveRemoteNotification代理方法；
 *  假如未设置UNUserNotificationCenter代理，iOS 10收到远程通知也会进入这里。
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [PushManager handleRemoteNotification:userInfo];
}


/**
 * iOS 10之前，在前台，收到本地通知，会进入这里
 * iOS 10之前，在后台，点击本地通知，会进入这里
 * 假如未设置UNUserNotificationCenter代理，iOS 10收到本地通知也会进入这里。
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [PushManager handleLocalNotification:notification];
}

/*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
 
 This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
/**
 *  iOS 10之前，不管在前台还是在后台，收到远程通知会进入此处；
 *  iOS 10之前，若未实现该代理，不管在前台还是在后台，收到远程推送会进入didReceiveRemoteNotification代理方法；
 *  iOS 10之前，静默推送，会进入到这里；
 *  iOS 10之后，在前台，静默推送，也会进入到这里
        如果为设置代理，再调用- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler。
        否则，不会调用上面方法；
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"push notification %@",userInfo);
}

# pragma mark iOS 10

// 会屏蔽iOS10之前方法（设置对应的代理后）

/**
 *  前台收到远程通知，进入这里
 *  前台收到本地通知，进入这里
 *  前台收到带有其他字段alert/sound/badge的静默推送，进入这里
 *  后台收到静默推送不会调用该方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSLog(@"%@",notification);
}


/**
 * 后台收到远程通知，点击进入
 * 后台收到本地通知，点击进入
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    /*
    >UNNotificationResponse
        >NSString *actionIdentifier
        >UNNotification *notification
            >NSDate *date
            >UNNotificationRequest *request
                >NSString *identifier
                >UNNotificationTrigger *trigger
                >UNNotificationContent *content
                    >NSNumber *badge
                    >NSString *body
                    >NSString *categoryIdentifier
                    >NSString *launchImageName
                    >NSString *subtitle
                    >NSString *title
                    >NSString *threadIdentifier
                    >UNNotificationSound *sound
                    >NSArray <UNNotificationAttachment *> *attachments
                    >NSDictionary *userInfo
     */
    NSLog(@"%@",response);
}

@end
