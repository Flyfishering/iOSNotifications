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
    
    NSString *urlStr = [self.bestAttemptContent.userInfo objectForKey:@"image"];
    
    if (urlStr) {
        // load the attachment
        [self loadAttachmentForUrlString:urlStr withType:@"jpg" completionHandler:^(UNNotificationAttachment *attachment) {
            if (attachment) {
                self.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
            }
            //返回给系统执行
            self.contentHandler(self.bestAttemptContent);
            
        }];
    }else{
        self.contentHandler(self.bestAttemptContent);
    }
    

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
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                            NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    completionHandler(attachment);
                }] resume];
}

- (void)downloadImageWithURL:(NSString *)urlStr withCompletedHanlder:(void  (^)(NSURL *fileUrl))completedHanlder
{
    //http://p2.so.qhmsg.com/t01570d67d63111d3e7.jpg
    if (urlStr) {
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];

            if (data && (error == nil)) {
                if (completedHanlder) {
                    completedHanlder(documentsDirectoryURL);
                }
            }
            
        }];
        
        [task resume];
        
        
    }
}

@end
