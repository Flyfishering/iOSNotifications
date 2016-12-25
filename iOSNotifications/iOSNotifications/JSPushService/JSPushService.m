//
//  NewPushManager.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/9/19.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushService.h"

NSString *const JSPUSHSERVICE_LOCALNOTI_IDENTIFIER       = @"com.jspush.kLocalNotificationIdentifier";

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
@interface JSPushService()<UNUserNotificationCenterDelegate>
#else
@interface JSPushService()
#endif

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
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        JSPUSH_NOTIFICATIONCENTER.delegate = self;
#endif
    }
    return self;
}

# pragma mark - Register

+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories
{
    
    if (JSPUSH_IOS_10){
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        [JSPUSH_NOTIFICATIONCENTER requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                [JSPUSH_NOTIFICATIONCENTER setNotificationCategories:categories];
            }
        }];
#endif
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {

        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
}

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

+ (void)registerForRemoteNotificationConfig:(JSPushRegisterConfig *)config delegate:(id<JSPushRegisterDelegate>)delegate
{
    if (config == nil) {
        JSPUSHLog(@"if you want to register remote notification,config musn't be nil");
        return;
    }
    [[self class] registerForRemoteNotificationTypes:config.types categories:config.categories];
    [JSPushService sharedManager].delegate = delegate;
    
}
#endif

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
    
    if (JSPUSH_IOS_10) {
        
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        //convert JSPushNotificationRequest to UNNotificationRequest
        UNNotificationRequest *request = [self convertJSPushNotificationRequestToUNNotificationRequest:jsRequest];
        if (request != nil) {
            [JSPUSH_NOTIFICATIONCENTER addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                //注册或更新通知成功回调，iOS10以上成功则result为UNNotificationRequest对象，失败则result为nil
                id result = error ? nil : request;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (jsRequest.completionHandler) {
                        jsRequest.completionHandler(result);
                    }
                });

            }];
        }
#endif

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

    if (JSPUSH_IOS_10) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        if (identifier == nil) {
            [JSPUSH_NOTIFICATIONCENTER removeAllDeliveredNotifications];
            [JSPUSH_NOTIFICATIONCENTER removeAllPendingNotificationRequests];
        }else{
            
            if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                switch (identifier.state) {
                    case JSPushNotificationStateAll:
                    {
                        [JSPUSH_NOTIFICATIONCENTER removeDeliveredNotificationsWithIdentifiers:identifier.identifiers];
                        [JSPUSH_NOTIFICATIONCENTER removePendingNotificationRequestsWithIdentifiers:identifier.identifiers];
                        break;
                    }
                    case JSPushNotificationStatePending:
                    {
                        [JSPUSH_NOTIFICATIONCENTER removePendingNotificationRequestsWithIdentifiers:identifier.identifiers];
                        break;
                    }
                    case JSPushNotificationStateDelivered:
                    {
                        [JSPUSH_NOTIFICATIONCENTER removeDeliveredNotificationsWithIdentifiers:identifier.identifiers];
                        break;
                    }
                    default:
                        break;
                }
            }else{
                switch (identifier.state) {
                    case JSPushNotificationStateAll:
                    {
                        [JSPUSH_NOTIFICATIONCENTER removeAllPendingNotificationRequests];
                        [JSPUSH_NOTIFICATIONCENTER removeAllDeliveredNotifications];
                        break;
                    }
                    case JSPushNotificationStatePending:
                    {
                        [JSPUSH_NOTIFICATIONCENTER removeAllPendingNotificationRequests];
                        break;
                    }
                    case JSPushNotificationStateDelivered:
                    {
                        [JSPUSH_NOTIFICATIONCENTER removeAllDeliveredNotifications];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
#endif
    }else{
        
        if(identifier.notificationObj != nil){
            [[UIApplication sharedApplication] cancelLocalNotification:identifier.notificationObj];
        }else if ( (identifier == nil) || (![JSPushUtilities jspush_validateArray:identifier.identifiers]) ){
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }else{
            NSArray *notis = [[UIApplication sharedApplication] scheduledLocalNotifications];
            for (UILocalNotification *noti in notis) {
                for (NSString *iden in identifier.identifiers) {
                    NSString *notiIden =  noti.userInfo[JSPUSHSERVICE_LOCALNOTI_IDENTIFIER];
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
    
    if (JSPUSH_IOS_10) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        switch (identifier.state) {
            case JSPushNotificationStateAll:
            {
                
                [JSPUSH_NOTIFICATIONCENTER getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                    
                    __block NSMutableArray *finds = [NSMutableArray array];

                    __block NSArray *pendingResults = nil;
                    if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                        pendingResults = requests;
                    }else{
                        NSMutableArray *findRequests = [NSMutableArray array];
                        for (UNNotificationRequest *request in requests) {
                            for (NSString *iden in identifier.identifiers) {
                                if ([iden isEqualToString:request.identifier]) {
                                    [findRequests addObject:request];
                                }
                            }
                        }
                        pendingResults = [findRequests copy];
                    }
                    
                    
                    [JSPUSH_NOTIFICATIONCENTER getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
                        
                        NSArray *deliveredResults = nil;
                        if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                            deliveredResults = notifications;
                        }else{
                            NSMutableArray *findNotifications = [NSMutableArray array];
                            for (UNNotification *noti in notifications) {
                                for (NSString *iden in identifier.identifiers) {
                                    if ([iden isEqualToString:noti.request.identifier]) {
                                        [findNotifications addObject:noti];
                                    }
                                }
                            }
                            deliveredResults = [findNotifications copy];
                        }
                        
                        [finds addObjectsFromArray:pendingResults];
                        [finds addObjectsFromArray:deliveredResults];
                    
                        NSArray *allFinds = [finds copy];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (identifier.findCompletionHandler) {
                                identifier.findCompletionHandler(allFinds);
                            }else{
                                JSPUSHLog(@"identifier.findCompletionHandler is nil");
                            }
                        });


                    }];
                    
                    
                }];
                
                break;
            }
            case JSPushNotificationStatePending:
            {
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
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (identifier.findCompletionHandler) {
                            identifier.findCompletionHandler(results);
                        }else{
                            JSPUSHLog(@"identifier.findCompletionHandler is nil");
                        }
                    });
                }];

                break;
            }
            case JSPushNotificationStateDelivered:
            {
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
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (identifier.findCompletionHandler) {
                            identifier.findCompletionHandler(results);
                        }else{
                            JSPUSHLog(@"identifier.findCompletionHandler is nil");
                        }
                    });
                }];
                break;
            }
            default:
                break;
        }

#endif
    }else{
        
        NSArray *results = nil;
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];

        if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
            results = localNotifications;
        }else{
            
            NSMutableArray *findNotifications = [NSMutableArray array];

            for (UILocalNotification *noti in localNotifications) {
                for (NSString *iden in identifier.identifiers) {
                    if ([iden isEqualToString:noti.userInfo[JSPUSHSERVICE_LOCALNOTI_IDENTIFIER]]) {
                        [findNotifications addObject:noti];
                    }
                }
            }
            results = [findNotifications copy];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (identifier.findCompletionHandler) {
                identifier.findCompletionHandler(results);
            }else{
                JSPUSHLog(@"identifier.findCompletionHandler is nil");
            }
        });
    }
    
}


# pragma mark - UNUserNotificationCenterDelegate

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

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
#endif

#pragma mark - other

- (UIViewController *)viewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    return vc;
}



#pragma mark - Private Methods

# pragma mark  iOS 10 以上创建通知

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

+ (nullable UNNotificationRequest *)convertJSPushNotificationRequestToUNNotificationRequest:(JSPushNotificationRequest *)jsRequest {
    
    if (jsRequest == nil) {
        JSPUSHLog(@"error-request is nil!");
        return nil;
    }
    
    if (jsRequest.requestIdentifier == nil) {
        JSPUSHLog(@"error requestIdentifier is nil!");
        return nil;
    }
    
    UNNotificationContent *content = [self convertJSPushNotificationContentToUNNotificationContent:jsRequest.content];
    if (content == nil) {
        JSPUSHLog(@"error-request content is nil!");
        return nil;
    }
    //trigger为nil，则为立即触发
    UNNotificationTrigger *trigger = [self convertJSPushNotificationTriggerToUNPushNotificationTrigger:jsRequest.trigger];
    if (trigger == nil) {
        trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.0 repeats:NO];
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
       UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.0 repeats:NO];
        return trigger;
    }
    //当fireDate不为nil，dateComponents为nil
    if ( (jsTrigger.fireDate != nil) && (jsTrigger.dateComponents == nil) ){
        NSDateComponents *dateC = [JSPushUtilities jspush_dateComponentsWithNSDate:jsTrigger.fireDate];
        if (dateC) {
            jsTrigger.dateComponents = dateC;
        }
    }
    
    UNNotificationTrigger *trigger = nil;
    
    if (jsTrigger.region != nil) {
        trigger = [UNLocationNotificationTrigger triggerWithRegion:jsTrigger.region repeats:jsTrigger.repeat];
    }else if (jsTrigger.dateComponents != nil){
        trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:jsTrigger.dateComponents repeats:jsTrigger.repeat];
    }else {
        trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:jsTrigger.timeInterval repeats:jsTrigger.repeat];
    }
    
    return trigger;
}

#endif

# pragma mark  iOS 10 以下创建本地通知

+ (UILocalNotification *)convertJSPushNotificationRequestToUILocalNotification:(JSPushNotificationRequest *)jsRequest {

    if (jsRequest == nil) {
        JSPUSHLog(@"error-request is nil!");
        return nil;
    }

    if (jsRequest.content == nil) {
        JSPUSHLog(@"error-content is nil!");
        return nil;
    }
    
    NSDate *fireDate = nil;
    
    if (jsRequest.trigger == nil) {
        fireDate = [NSDate date];
    }else if ( (jsRequest.trigger.fireDate == nil) && (jsRequest.trigger.dateComponents != nil) ) {
        //假如使用时，fireDate未设置，则将dateComponents转换为对应的fireDate
        NSDate *date = [JSPushUtilities jspush_dateWithNSDateComponents:jsRequest.trigger.dateComponents];
        if (date) {
            fireDate = date;
        }
    }else if((jsRequest.trigger.fireDate != nil) && (jsRequest.trigger.dateComponents == nil)){
        fireDate = jsRequest.trigger.fireDate;
    }
    
    UILocalNotification *noti = [self setLocalNotification:fireDate alertTitle:jsRequest.content.title alertBody:jsRequest.content.body badge:jsRequest.content.badge alertAction:jsRequest.content.action identifierKey:jsRequest.requestIdentifier userInfo:jsRequest.content.userInfo soundName:jsRequest.content.sound region:jsRequest.trigger.region regionTriggersOnce:jsRequest.trigger.repeat category:jsRequest.content.categoryIdentifier];
    
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
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= JSPUSH_IPHONE_8_2) )
            notification.alertTitle = alertTitle;     //8.2才支持,默认是应用名称
#endif
        }
        notification.alertBody   = alertBody;     //显示主体
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= JSPUSH_IPHONE_8_0) )
        if(JSPUSH_IOS_8){
            notification.category = category;
            //设置地理位置
            if(region){
                notification.region = region;
                notification.regionTriggersOnce = regionTriggersOnce;
            }
        }
#endif
        
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
        if(badge != nil){
            NSInteger badgeNum = [badge integerValue];
            if(badgeNum == 0){
                notification.applicationIconBadgeNumber = 0;
            }else if(badgeNum > 0){
                notification.applicationIconBadgeNumber = badgeNum;
            }else if(badgeNum < 0){
                notification.applicationIconBadgeNumber++;
            }
        }
 
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = nil;
        if(userInfo){
            aUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        }else{
            aUserInfo = [NSMutableDictionary dictionary];
        }
        aUserInfo[JSPUSHSERVICE_LOCALNOTI_IDENTIFIER] = notificationKey;
        notification.userInfo = [aUserInfo copy];
        
    }
    return notification;
}

@end
