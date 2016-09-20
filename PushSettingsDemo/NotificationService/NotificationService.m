//
//  NotificationService.m
//  NotificationService
//
//  Created by WengHengcong on 2016/9/20.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "NotificationService.h"

//Service Extension 现在只对远程推送的通知起效，你可以在推送 payload 中增加一个 mutable-content 值为 1 的项来启用内容修改
/*
 
 {
 "aps":{
 "alert":{
 "title":"快起床",
 "body":"真的起不来？"
 },
 "mutable-content":1
 }

 */

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService


/**
方法中有一个等待发送的通知请求，我们通过修改这个请求中的 content 内容，然后在限制的时间内将修改后的内容调用通过 contentHandler 返还给系统，就可以显示这个修改过的通知了。
 */
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [修改过哦]", self.bestAttemptContent.title];
    //返回给系统执行
    self.contentHandler(self.bestAttemptContent);
}

/*
 在一定时间内没有调用 contentHandler 的话，系统会调用这个方法，来告诉你大限已到。你可以选择什么都不做，这样的话系统将当作什么都没发生，简单地显示原来的通知。可能你其实已经设置好了绝大部分内容，只是有很少一部分没有完成，这时你也可以像例子中这样调用 contentHandler 来显示一个变更“中途”的通知
 */
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
