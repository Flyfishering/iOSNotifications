//
//  NewPushManager.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/9/19.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushService.h"

@interface JSPushService()<UNUserNotificationCenterDelegate>

@property (nonatomic ,weak)id<JSPushRegisterDelegate> delegate;

@end

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
        JSPUSH_NOTIFICATIONCENTER.delegate = self;
    }
    return self;
}

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


# pragma mark - Register

+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        
        [JSPUSH_NOTIFICATIONCENTER requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                [JSPUSH_NOTIFICATIONCENTER setNotificationCategories:categories];
            }
        }];
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {

        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
}

+ (void)registerForRemoteNotificationConfig:(JSPushRegisterConfig *)config delegate:(id<JSPushRegisterDelegate>)delegate
{
    if (config == nil) {
        JSPUSHLog(@"if you want to register remote notification,config musn't be nil");
        return;
    }
    [[self class] registerForRemoteNotificationTypes:config.types categories:config.categories];
    [JSPushService sharedManager].delegate = delegate;
    
}

#pragma mark - device token

+ (void)registerDeviceToken:(NSData *)deviceToken completionHandler:(void (^)(NSString *))completionHandler
{
    NSString *dt = [JSPushUtilities jspush_parseDeviceToken:deviceToken];
    if (completionHandler) {
        completionHandler(dt);
    }

}

#pragma mark - badge

+ (void)resetBadge {
    [JSPushService setBadge:0];
}

+ (void)setBadge:(NSInteger)badge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}


#pragma mark - Public Methods

+ (void)addNotification:(JSPushNotificationRequest *)jsRequest {
    
    if (iOSAbove10) {
        
        //convert JSPushNotificationRequest to UNNotificationRequest
        UNNotificationRequest *request = [self convertJSPushNotificationRequestToUNNotificationRequest:jsRequest];
        if (request != nil) {
            [JSPUSH_NOTIFICATIONCENTER addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                //注册或更新通知成功回调，iOS10以上成功则result为UNNotificationRequest对象，失败则result为nil
                id result = error ? nil : request;
                
                if (jsRequest.completionHandler) {
                    jsRequest.completionHandler(result);
                }
            }];
        }

    }else{
        
        UILocalNotification *noti = [self convertJSPushNotificationRequestToUILocalNotification:jsRequest];
        //iOS10以下成功result为UILocalNotification对象，失败则result为nil
        id result = noti ? noti : nil;
        if (result) {
            [[UIApplication sharedApplication] scheduleLocalNotification:noti];
        }
        if (jsRequest.completionHandler) {
            jsRequest.completionHandler(result);
        }
        
    }
}

+ (void)removeNotification:(JSPushNotificationIdentifier *)identifier {

    if (iOSAbove10) {
        if (identifier == nil) {
            [JSPUSH_NOTIFICATIONCENTER removeAllDeliveredNotifications];
            [JSPUSH_NOTIFICATIONCENTER removeAllPendingNotificationRequests];
        }else{
            if (identifier.delivered) {
                if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                    [JSPUSH_NOTIFICATIONCENTER removeAllDeliveredNotifications];
                }else{
                    [JSPUSH_NOTIFICATIONCENTER removeDeliveredNotificationsWithIdentifiers:identifier.identifiers];
                }
            }else{
                if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                    [JSPUSH_NOTIFICATIONCENTER removeAllPendingNotificationRequests];
                }else{
                    [JSPUSH_NOTIFICATIONCENTER removePendingNotificationRequestsWithIdentifiers:identifier.identifiers];
                }
            }
        }

    }else{
        
        if (identifier == nil) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }else if(identifier.notificationObj != nil){
            [[UIApplication sharedApplication] cancelLocalNotification:identifier.notificationObj];
        }else if (![JSPushUtilities jspush_validateArray:identifier.identifiers]){
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }else{
            NSArray *notis = [[UIApplication sharedApplication] scheduledLocalNotifications];
            for (UILocalNotification *noti in notis) {
                for (NSString *iden in identifier.identifiers) {
                    NSString *notiIden =  noti.userInfo[kLocalNotificationIdentifier];
                    if ([notiIden isEqualToString:iden]) {
                        [[UIApplication sharedApplication] cancelLocalNotification:noti];
                    }
                }
            }
        }
    }

}

+ (void)findNotification:(JSPushNotificationIdentifier *)identifier {
    
    if (identifier == nil) {
        JSPUSHLog(@"if you want to find notification.identifier musn't nil");
        return;
    }
    
    if (iOSAbove10) {
        if (identifier.delivered) {
            [JSPUSH_NOTIFICATIONCENTER getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                
                NSArray *results = nil;
                if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                    results = requests;
                }else{
                    NSMutableArray *findRequests = [NSMutableArray array];
                    for (UNNotificationRequest *request in requests) {
                        for (NSString *iden in identifier.identifiers) {
                            if ([iden isEqualToString:request.identifier]) {
                                [findRequests addObject:request];
                            }
                        }
                    }
                    results = [findRequests copy];
                }
                
                if (identifier.findCompletionHandler) {
                    identifier.findCompletionHandler(results);
                }else{
                    JSPUSHLog(@"identifier.findCompletionHandler is nil");
                }
            }];
        }else{
            [JSPUSH_NOTIFICATIONCENTER getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
                
                NSArray *results = nil;
                if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                    results = notifications;
                }else{
                    NSMutableArray *findNotifications = [NSMutableArray array];
                    for (UNNotification *noti in notifications) {
                        for (NSString *iden in identifier.identifiers) {
                            if ([iden isEqualToString:noti.request.identifier]) {
                                [findNotifications addObject:noti];
                            }
                        }
                    }
                    results = [findNotifications copy];
                }
                

                if (identifier.findCompletionHandler) {
                    identifier.findCompletionHandler(results);
                }else{
                    JSPUSHLog(@"identifier.findCompletionHandler is nil");
                }
            }];
        }
        
    }else{
        
        NSArray *results = nil;
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];

        if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
            results = localNotifications;
        }else{
            
            NSMutableArray *findNotifications = [NSMutableArray array];

            for (UILocalNotification *noti in localNotifications) {
                for (NSString *iden in identifier.identifiers) {
                    if ([iden isEqualToString:noti.userInfo[kLocalNotificationIdentifier]]) {
                        [findNotifications addObject:noti];
                    }
                }
            }
            results = [findNotifications copy];

        }
        
        if (identifier.findCompletionHandler) {
            identifier.findCompletionHandler(results);
        }else{
            JSPUSHLog(@"identifier.findCompletionHandler is nil");
        }
    }
    
}

# pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jspushNotificationCenter:willPresentNotification:withCompletionHandler:)] ) {
        [self.delegate jspushNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jspushNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)]) {
        [self.delegate jspushNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
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

# pragma mark  iOS 10 以上创建通知

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
    if ( ([JSPushUtilities jspush_validateString:jsContent.sound]) || [jsContent.sound isEqualToString:@"default"]) {
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
    //当fireDate不为nil，dateComponents为nil
    if ( (jsTrigger.fireDate != nil) && (jsTrigger.dateComponents == nil) ){
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSCalendar * cal = [NSCalendar currentCalendar];
        NSDateComponents *dateC = [cal components:unitFlags fromDate:jsTrigger.fireDate];
        if (dateC) {
            jsTrigger.dateComponents = dateC;
        }
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

# pragma mark  iOS 10 以下创建本地通知

+ (UILocalNotification *)convertJSPushNotificationRequestToUILocalNotification:(JSPushNotificationRequest *)jsRequest {

    if (jsRequest == nil) {
        JSPUSHLog(@"error-request is nil!");
        return nil;
    }
    
    if (jsRequest.trigger == nil) {
        JSPUSHLog(@"error-trigger is nil!");
        return nil;
    }
    
    if (jsRequest.content == nil) {
        JSPUSHLog(@"error-content is nil!");
        return nil;
    }
    //假如使用时，fireDate未设置，则将dateComponents转换为对应的fireDate
    if ( (jsRequest.trigger.fireDate == nil) && (jsRequest.trigger.dateComponents != nil) ) {
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        gregorian.timeZone = [NSTimeZone defaultTimeZone];
        NSDate *date = [gregorian dateFromComponents:jsRequest.trigger.dateComponents];
        if (date) {
            jsRequest.trigger.fireDate = date;
        }
    }
    
    UILocalNotification *noti = [self setLocalNotification:jsRequest.trigger.fireDate alertTitle:jsRequest.content.title alertBody:jsRequest.content.body badge:jsRequest.content.badge alertAction:jsRequest.content.action identifierKey:jsRequest.requestIdentifier userInfo:jsRequest.content.userInfo soundName:jsRequest.content.sound region:jsRequest.trigger.region regionTriggersOnce:jsRequest.trigger.repeat category:jsRequest.content.categoryIdentifier];
    
    return noti;
}

+ (UILocalNotification *)setLocalNotification:(NSDate *)fireDate
                                   alertTitle:(NSString *)alertTitle
                                    alertBody:(NSString *)alertBody
                                        badge:(NSNumber *)badge
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
        NSInteger badgeNum = [badge integerValue];
        if(badgeNum == -1){
            //-1,不改变
        }else if(badgeNum == 0){
            //applicationIconBadgeNumber,
            //0 means no change. defaults to 0
            notification.applicationIconBadgeNumber++;
        }else{
            notification.applicationIconBadgeNumber = badgeNum;
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

@end
