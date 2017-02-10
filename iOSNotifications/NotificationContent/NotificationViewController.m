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


/*
 
 apns payload test demo
 
 {
 "aps": {
 "alert": {
 "title": "斯沃驰2016秋冬系列华丽上市",
 "body": "Swatch推出Magies D'Hiver系列新品！"
 },
 "sound": "default",
 "category": "pictureCat",
 "mutable-content": 1
 },
 "isqImgPath": "https://cdn.pixabay.com/photo/2017/01/06/22/24/giraffe-1959110_1280.jpg",
 "tImgPath": "https://cdn.pixabay.com/photo/2017/01/06/22/24/giraffe-1959110_1280.jpg",
 "title": "斯沃驰2016秋冬系列华丽上市",
 "content": "Swatch推出MagiesD'Hiver系列新品。该系列灵感来源于雪花的结晶构造，技术感十足，配以新潮迷彩色和爱尔兰式粗花呢，宛若置身壁炉旁。"
 }
 
 以上图片若无效，尝试：https://img30.360buyimg.com/EdmPlatform/jfs/t4000/43/1883011713/62578/a8ef6739/589ac88dNdacd97ed.jpg
 
 */

//内容
static NSString *forceTouchImageKey = @"tImgPath";
static NSString *forceTouchTitleKey = @"title";
static NSString *forceTouchContentKey = @"content";

static NSString *forceTouchCategoryPic = @"pictureCat";

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    //    self.botText.numberOfLines = 3;
    self.contentImg.backgroundColor = [UIColor clearColor];
    self.contentImg.layer.borderColor = [UIColor clearColor].CGColor;
    self.botText.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 243);
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
    
    if ( (notification == nil) || (notification.request == nil) || (notification.request.content == nil) || (notification.request.content.userInfo) == nil) {
        return;
    }
    
    NSString *pushTitle = notification.request.content.userInfo[forceTouchTitleKey];
    NSString *pushContent = notification.request.content.userInfo[forceTouchContentKey];
    
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGSize botTextSize = CGSizeMake(screenWidth-2*15-2*15, MAXFLOAT);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect botTextRect = [pushContent boundingRectWithSize:botTextSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    
    self.topText.text = pushTitle;
    self.botText.text = pushContent;
    
    CGFloat subHeight = 47-botTextRect.size.height;
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-subHeight);
    
    [self.view layoutIfNeeded];
    
    __weak __typeof__(self) weakSelf = self;
    if ([notification.request.content.categoryIdentifier isEqualToString:forceTouchCategoryPic]) {
        __strong __typeof__(self) strongSelf = weakSelf;
        //注意：image读取的层次结构
        NSString *urlFromNoti = notification.request.content.userInfo[forceTouchImageKey];
        if (strongSelf) {
            if (urlFromNoti) {
                [self downloadImageWithURL:urlFromNoti withCompletedHanlder:^(NSURL *fileUrl, NSData *data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (data==nil) {
                            [strongSelf defaultCategoryLayoutView];
                        }else{
                            UIImage *image = [UIImage imageWithData:data];
                            if (image) {
                                strongSelf.contentImg.image = [UIImage imageWithData:data] ;
                                [strongSelf.view layoutIfNeeded];
                            }else{
                                [strongSelf defaultCategoryLayoutView];
                            }
                        }
                    });
                }];
            }else{
                [self defaultCategoryLayoutView];
            }
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

- (void)defaultCategoryLayoutView
{
    self.topBackground.hidden = YES;
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-138);
    self.contentTop.constant = 0;
    self.imageHeight.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)downloadImageWithURL:(NSString *)urlStr withCompletedHanlder:(void  (^)(NSURL *fileUrl , NSData *data))completedHanlder
{
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
                }else{
                    completedHanlder(nil,nil);
                }
            }else{
                if (completedHanlder) {
                    completedHanlder(documentsDirectoryURL,data);
                }else{
                    completedHanlder(nil,nil);
                }
            }
            
        }];
        
        [task resume];
    }
}

@end
