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
/*假如带小图文的通知，通知界面未经过这里修改，则会展示成带图片的通知
未经过Content Extension：
  1.通知不带图片，直接显示title/body的通知；
  2.通知带图片，显示为title/图片/body的通知；
 
经过Content Extension，直接加载定制的通知界面。
*/


/*
 
 {
    "aps":{
        "alert":{
            "title":"斯沃驰2016秋冬系列华丽上市",
            "body":"Swatch推出Magies D'Hiver系列新品！"
        },
        "sound":"default",
        "mutable-content":1,
        "category":"customUI",
        "mutable-content":1
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

