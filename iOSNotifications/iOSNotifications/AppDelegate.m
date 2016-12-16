//
//  AppDelegate.m
//  iOSNotifications
//
//  Created by WengHengcong on 4/20/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "AppDelegate.h"
#import "JSPushService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [JSPushService registerForRemoteNotificationTypes:7 categories:nil];
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
#endif

    //HCTEST:
    if (iOSAbove10) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

        //iOS 10以上，通知代理设置，不设置，代理不调用。
        //在锁屏界面，通知栏，需要点击“查看”，才会显示“接受”、“拒绝”的按钮
        
        /**第一组按钮*/
        UNNotificationAction *acceptAction = [UNNotificationAction actionWithIdentifier:@"acceptAction" title:@"接受" options:UNNotificationActionOptionDestructive];
        
        UNNotificationAction *rejectAction = [UNNotificationAction actionWithIdentifier:@"rejectAction" title:@"拒绝" options:UNNotificationActionOptionForeground];
        
        //注意，输入的action，点击action后，会在Action列表显示：接受、拒绝、输入你想几点起
        UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"inputAction" title:@"输入你想几点起" options:UNNotificationActionOptionForeground textInputButtonTitle:@"确定" textInputPlaceholder:@"再晚1小时吧"];
        
        UNNotificationCategory *wakeUpCate = [UNNotificationCategory categoryWithIdentifier:@"customUI" actions:@[acceptAction,rejectAction,inputAction] intentIdentifiers:@[@"wakeup"] options:UNNotificationCategoryOptionNone];
        
        /**第一组按钮结束**/
        
        /**第二组按钮*/
        
        UNNotificationAction *customAction1 = [UNNotificationAction actionWithIdentifier:@"acceptAction" title:@"购物" options:UNNotificationActionOptionDestructive];
        
        UNNotificationAction *customAction2 = [UNNotificationAction actionWithIdentifier:@"rejectAction" title:@"收藏" options:UNNotificationActionOptionForeground];
        
        //注意，输入的action，点击action后，会在Action列表显示：接受、拒绝、输入你想几点起
        UNTextInputNotificationAction *customAction3 = [UNTextInputNotificationAction actionWithIdentifier:@"inputAction" title:@"输入文本" options:UNNotificationActionOptionForeground textInputButtonTitle:@"确定" textInputPlaceholder:@"输入文本默认占位符"];
        
        
        UNNotificationCategory *customCate = [UNNotificationCategory categoryWithIdentifier:@"customUIWeb" actions:@[customAction1,customAction2] intentIdentifiers:@[@"customUI"] options:UNNotificationCategoryOptionNone];
        
        /**第二组按钮结束**/
        
        [JSPushService registerForRemoteNotificationTypes:7 categories:[NSSet setWithObjects:wakeUpCate,customCate,nil]];
#endif
    }else{
        /***************************测试category*******************************/
        /*注意：以下action注册，只在iOS10之前有效！！！  */
        //apns: {"aps":{"alert":"测试通知的快捷回复", "sound":"default", "badge": 1, "category":"alert"}}
        
        [JSPushService setupWithOption:launchOptions];
        
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
        categorys.identifier = @"customUI";
        NSArray *actions = @[acceptAction, rejectAction];
        [categorys setActions:actions forContext:UIUserNotificationActionContextMinimal];
        
        [JSPushService registerForRemoteNotificationTypes:7 categories:[NSSet setWithObjects:categorys,nil]];
        
    }

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //重置角标
//    [JSPushService resetBadge];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
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

#pragma mark - 唯二不在UserNotifications框架内的API
/**
 *  registerForRemoteNotifications的回调
 */
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [JSPushService registerDeviceToken:deviceToken completionHandler:^(NSString *devicetoken) {
       //将devicetoken传给你的服务器或者保存
        NSLog(@"device token:%@",devicetoken);
    }];
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
 * iOS 10之前，在前台，收到本地通知，会进入这里
 * iOS 10之前，在后台，点击本地通知，会进入这里
 * 假如未设置UNUserNotificationCenter代理，iOS 10收到本地通知也会进入这里。
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification %@",notification.userInfo);
}

/**
 *  iOS 10之前，若未实现该代理application didReceiveRemoteNotification: fetchCompletionHandler:
 不管在前台还是在后台，收到远程通知（包括静默通知）会进入didReceiveRemoteNotification代理方法；
 *  假如实现了，收到远程通知（包括静默通知）就会进入application didReceiveRemoteNotification: fetchCompletionHandler:方法
 *  假如未设置UNUserNotificationCenter代理，iOS 10收到远程通知也会进入这里。
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"didReceiveRemoteNotification %@",userInfo);
}

/*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
 
 This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
/**
 *  iOS 10之前，不管在前台还是在后台，收到远程通知会进入此处；
 *  iOS 10之前，若未实现该代理，不管在前台还是在后台，收到远程通知会进入didReceiveRemoteNotification代理方法；
 *  iOS 10之前，静默通知，会进入到这里；
 *  iOS 10之后，在前台，静默通知，也会进入到这里
        如果为设置代理，再调用- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler。
        否则，不会调用上面方法；
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"push notification completionHandler %@",userInfo);
    NSLog(@"didReceiveRemoteNotification %@",userInfo);
}

# pragma mark iOS 10

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
// 会屏蔽iOS10之前方法（设置对应的代理后）

/**
 *  在前台如何处理，通过completionHandler指定。如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
 // completionHandler(0)
 *  前台收到远程通知，进入这里
 *  前台收到本地通知，进入这里
 *  前台收到带有其他字段alert/sound/badge的静默通知，进入这里
 *  后台收到静默通知不会调用该方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到通知的请求
    UNNotificationContent *content = request.content; // 收到通知的消息内容
    
    NSNumber *badge = content.badge;  // 通知消息的角标
    NSString *body = content.body;    // 通知消息体
    UNNotificationSound *sound = content.sound;  // 通知消息的声音
    NSString *subtitle = content.subtitle;  // 通知消息的副标题
    NSString *title = content.title;  // 通知消息的标题
    
    //远程通知
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"push");
    }else{
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}


/**
 * 在用户与你通知的通知进行交互时被调用，包括用户通过通知打开了你的应用，或者点击或者触发了某个action
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
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到通知的请求
    UNNotificationContent *content = request.content; // 收到通知的消息内容
    
    NSNumber *badge = content.badge;  // 通知消息的角标
    NSString *body = content.body;    // 通知消息体
    UNNotificationSound *sound = content.sound;  // 通知消息的声音
    NSString *subtitle = content.subtitle;  // 通知消息的副标题
    NSString *title = content.title;  // 通知消息的标题
    
    //远程通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        NSString *actionIdentifier = response.actionIdentifier;
        if ([actionIdentifier isEqualToString:@"acceptAction"]) {
            
        }else if ([actionIdentifier isEqualToString:@"rejectAction"])
        {
            
        }else if ([actionIdentifier isEqualToString:@"inputAction"]){
            
            if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
                
                NSString *inputText = ((UNTextInputNotificationResponse *)response).userText;
                NSLog(@"%@",inputText);
            }
            
        }
        
    }else{
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        
        NSString *actionIdentifier = response.actionIdentifier;
        if ([actionIdentifier isEqualToString:@"acceptAction"]) {
            
        }else if ([actionIdentifier isEqualToString:@"rejectAction"])
        {
            
        }else if ([actionIdentifier isEqualToString:@"inputAction"]){
            
            if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
                
                NSString *inputText = ((UNTextInputNotificationResponse *)response).userText;
                NSLog(@"%@",inputText);
            }
            
        }
        
    }
    
    completionHandler();
    
}

#endif

@end
