//
//  NotificationService.h
//  NotificationService
//
//  Created by WengHengcong on 2017/1/4.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>


//Service Extension 现在只对远程通知的通知起效，你可以在通知 payload 中增加一个 mutable-content 值为 1 的项来启用内容修改
/*
{
    "aps":{
        "alert":{
            "title":"Hurry Up!",
            "body":"Go to School~"
        },
        "sound":"default",
        "mutable-content":1,
    },
}
*/
@interface NotificationService : UNNotificationServiceExtension

@end
