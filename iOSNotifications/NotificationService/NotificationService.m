//
//  NotificationService.m
//  NotificationService
//
//  Created by WengHengcong on 2017/1/4.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//

#import "NotificationService.h"

/*
 
 apns payload test demo
 
 {
 "aps": {
 "alert": {
 "title": "斯沃驰2016秋冬系列华丽上市",
 "body": "Swatch推出Magies D'Hiver系列新品！"
 },
 "sound": "default",
 "mutable-content": 1
 },
 "isqImgPath": "https://cdn.pixabay.com/photo/2017/01/06/22/24/giraffe-1959110_1280.jpg",
 "tImgPath": "https://cdn.pixabay.com/photo/2017/01/06/22/24/giraffe-1959110_1280.jpg",
 "title": "斯沃驰2016秋冬系列华丽上市",
 "content": "Swatch推出MagiesD'Hiver系列新品。该系列灵感来源于雪花的结晶构造，技术感十足，配以新潮迷彩色和爱尔兰式粗花呢，宛若置身壁炉旁。"
 }
 
 以上图片若无效，尝试：https://img30.360buyimg.com/EdmPlatform/jfs/t4000/43/1883011713/62578/a8ef6739/589ac88dNdacd97ed.jpg
 
 */

static NSString *notiSmallImageKey = @"isqImgPath";

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    
    if ( (request == nil) || (request.content == nil) || (request.content.userInfo == nil) ) {
        return;
    }
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];

    //在此处修改category，可达到对应category的手段！！！
    //可以配合服务端针对category来进行不同的自定义页面的设置。
    //NSString *categoryFormServer = [self.bestAttemptContent.userInfo objectForKey:@"js_category"];
    //self.bestAttemptContent.categoryIdentifier = categoryFormServer;
    
    //自定义一个字段image，用于下载地址：
    //同时，需要注意的是，在下载图片是采用http时，需要在extension info.plist加上 app transport
    NSString *urlStr = [self.bestAttemptContent.userInfo objectForKey:notiSmallImageKey];
    
    __weak __typeof__ (self) wself = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __strong __typeof__ (self) sself = wself;
        
        if (sself) {
            if (urlStr) {
                // load the attachment
                [sself loadAttachmentForUrlString:urlStr withType:@"png" completionHandler:^(UNNotificationAttachment *attachment) {
                    if (attachment) {
                        sself.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
                    }
                    //返回给系统执行
                    sself.contentHandler(sself.bestAttemptContent);
                    
                }];
            }else{
                sself.contentHandler(sself.bestAttemptContent);
            }
            
        }
        
    });

}


/*
 在一定时间内没有调用 contentHandler 的话，系统会调用这个方法，来告诉你大限已到。你可以选择什么都不做，这样的话系统将当作什么都没发生，简单地显示原来的通知。可能你其实已经设置好了绝大部分内容，只是有很少一部分没有完成，这时你也可以像例子中这样调用 contentHandler 来显示一个变更“中途”的通知
 */
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}


- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    
    return [@"." stringByAppendingString:ext];
}

- (void)loadAttachmentForUrlString:(NSString *)urlString withType:(NSString *)type
                 completionHandler:(void(^)(UNNotificationAttachment *))completionHandler  {
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlString];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                        [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                        
                        NSError *attachmentError = nil;
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:notiSmallImageKey URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                            NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionHandler) {
                            completionHandler(attachment);
                        }
                    });
                }]
     resume];
}

@end
