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
 
 The UNNotificationContentExtension protocol provides the entry point for a Notification Content app extension, which displays a custom interface for your app’s notifications. You adopt this protocol in the custom UIViewController subclass that you use to present your interface. You create this type of extension to improve the way your notifications are presented, possibly by adding custom colors and branding or by incorporating media and other dynamic content into your notification interface.
 
 To define a Notification Content app extension, add a Notification Content extension target to the Xcode project containing your app. The default Xcode template contains a source file and storyboard for your view controller. The Info.plist file of the extension comes mostly configured. Specifically, the NSExtensionPointIdentifier key is set to the value com.apple.usernotifications.content-extension and the NSExtensionMainStoryboard key is set to the name of the project’s storyboard file. However, the NSExtensionAttribute key contains a dictionary of additional keys and values, some of which you must configure manually:
 
 UNNotificationExtensionCategory. (Required) The value of this key is a string or an array of strings. Each string contains the identifier of a category declared by the app using the UNNotificationCategory class.
 
 UNNotificationExtensionInitialContentSizeRatio. (Required) The value of this key is a floating-point number that represents the initial size of your view controller’s view expressed as a ratio of its height to its width. The system uses this value to set the initial size of the view controller while your extension is loading. For example, a value of 0.5 results in a view controller whose height is half its width. You can change the size of your view controller after your extension loads.
 
 UNNotificationExtensionDefaultContentHidden. (Optional) The value of this key is a Boolean. When set to YES, the system displays only your custom view controller in the notification interface. When set to NO, the system displays the default notification content in addition to your view controller’s content. Custom action buttons and the Dismiss button are always displayed, regardless of this setting. If you do not specify this key, the default value is set to NO.
 
 
 
 UNNotificationExtensionDefaultContentHidden          YES，就会隐藏通知的头部与尾部
 UNNotificationExtensionCategory                      对应的Category，是一个字符串数组，定义后，可以根据
 UNNotificationExtensionInitialContentSizeRatio       高度/宽度=ratio,该比例是基于sb文件中定制好的。

 NSExtensionMainStoryboard                            storyboard文件的名字
 NSExtensionPointIdentifier                           Notification Content的bundle id
 
 */


/*
对应的payload可以如此：

{
    "aps":{
        "alert":{
            "title":"快起床第十三",
            "body":"真的起不来？"
        },
        "sound":"default",
        "category":"customUI",
        "mutable-content":1
    },
}
 
 注意：category必须和Info.plist中的UNNotificationExtensionCategory一致。

 */

@interface NotificationViewController () <UNNotificationContentExtension,UIWebViewDelegate>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.

    //先加载viewDidLoad
    
    
}

- (void)didReceiveNotification:(UNNotification *)notification {
    
    //后加载didReceiveNotification
    
    
    /*
     注意加载图片的机制，要么在NotificationContent中文件夹中放置对应的图片
     */

    if ([notification.request.content.categoryIdentifier isEqualToString:@"customUIWeb"]) {
        
        self.webView.hidden = NO;
        NSString *urlFromNoti = notification.request.content.userInfo[@"url"];
        NSURL* url = [NSURL URLWithString:urlFromNoti];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.webView loadRequest:request];//加载
        
    }else if([notification.request.content.categoryIdentifier isEqualToString:@"customUI"]){
        self.webView.hidden = YES;
        self.imageView.image = [UIImage imageNamed:@"dog.png"];
        self.label.text = notification.request.content.body;
    }
}

/*
  无法定位点击
 */
- (IBAction)jumpUrl:(id)sender {
    
    
    
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
