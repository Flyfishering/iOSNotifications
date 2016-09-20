//
//  NotificationViewController.m
//  NotificationContent
//
//  Created by WengHengcong on 2016/9/20.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

/*
对应的payload可以如此：

{
    "aps":{
        "alert":{
            "title":"快起床第十三",
            "body":"真的起不来？"
        },
        "category":"customUI",
        "mutable-content":1
    },
}
 
 注意：category必须和Info.plist中的UNNotificationExtensionCategory一致。

 */

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    /*
    
     注意加载图片的机制，要么在NotificationContent中文件夹中放置对应的图片
     

     
     */
    self.imageView.image = [UIImage imageNamed:@"dog.png"];
    self.label.text = notification.request.content.body;
}

// If implemented, the method will be called when the user taps on one
// of the notification actions. The completion handler can be called
// after handling the action to dismiss the notification and forward the
// action to the app if necessary.
//- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion
//{
//    completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
//}



@end
