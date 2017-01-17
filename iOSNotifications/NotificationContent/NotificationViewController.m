//
//  NotificationViewController.m
//  NotificationContent
//
//  Created by WengHengcong on 2017/1/4.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//

#import "NotificationViewController.h"

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
 
 注意：category必须和Info.plist中的UNNotificationExtensionCategory一致。
 
 */

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 256);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}

- (void)didReceiveNotification:(UNNotification *)notification {
    
    //后加载didReceiveNotification
    /*
     注意加载图片的机制，要么在NotificationContent中文件夹中放置对应的图片
     */
    
    if ([notification.request.content.categoryIdentifier isEqualToString:@"customUI"]) {
        //注意：image读取的层次结构
        NSString *urlFromNoti = notification.request.content.userInfo[@"image"];
        if (urlFromNoti) {
            [self downloadImageWithURL:urlFromNoti withCompletedHanlder:^(NSURL *fileUrl, NSData *data) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
//                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    //NSString *extension = [imageName pathExtension];
                    //NSString *fileName = [imageName componentsSeparatedByString:@"."].firstObject;
//                    NSString *localFileURLStr = [NSString stringWithFormat:@"%@/%@",documentsDirectory,imageName];
//                    NSURL *localFileURL = [NSURL URLWithString:localFileURLStr];
//                    NSData *tempData = [NSData dataWithContentsOfURL:localFileURL];
                    self.contentImg.image = [UIImage imageWithData:data] ;
                });
                
            }];
        }else{
            self.topBackground.hidden = YES;
            self.botBackground.hidden = YES;
            self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-138);
            self.imageHeight.constant = 0;
            [self.view layoutIfNeeded];
        }
    }
}

// If implemented, the method will be called when the user taps on one
// of the notification actions. The completion handler can be called
// after handling the action to dismiss the notification and forward the
// action to the app if necessary.
- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion
{
    completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
}

- (void)downloadImageWithURL:(NSString *)urlStr withCompletedHanlder:(void  (^)(NSURL *fileUrl , NSData *data))completedHanlder
{
    //http://p2.so.qhmsg.com/t01570d67d63111d3e7.jpg
    if (urlStr) {
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSString *imageName = [response suggestedFilename];
            documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:imageName];
            
            if (data && (error == nil)) {
                if (completedHanlder) {
                    completedHanlder(documentsDirectoryURL,data);
                }
            }
            
        }];
        
        [task resume];
        
        
    }
}

@end
