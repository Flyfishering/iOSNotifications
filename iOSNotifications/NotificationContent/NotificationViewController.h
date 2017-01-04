//
//  NotificationViewController.h
//  NotificationContent
//
//  Created by WengHengcong on 2017/1/4.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

//Content Extension 用来修改通知弹出的界面，并且通过category来进行加以定制。

/*
 
 {
    "aps":{
        "alert":{
            "title":"Hurry Up!",
            "body":"Go to School~"
        },
        "sound":"default",
        "mutable-content":1,
        "category":"customUI",
    },
    "image":"http://p2.so.qhmsg.com/t01570d67d63111d3e7.jpg"
 }
 
 */

@interface NotificationViewController : UIViewController <UNNotificationContentExtension>
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property IBOutlet UILabel *topText;
@property IBOutlet UIImageView *contentImg;
@property IBOutlet UILabel *botText;

@end

