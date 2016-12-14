//
//  PushTestingController.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/14.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "PushTestingController.h"

#define NotificationIdentifier_Text        @"com.junglesong.review"

@interface PushTestingController ()

@end

@implementation PushTestingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNotification:(id)sender {
    [self test_addTextNotofication];
}
- (IBAction)removeNotification:(id)sender {
    [self test_removeNotification];
}
- (IBAction)updateNotification:(id)sender {
    
}
- (IBAction)findNotification:(id)sender {
    
}

- (void)test_removeNotification
{
    JSPushNotificationIdentifier *iden = [[JSPushNotificationIdentifier alloc] init];
    iden.identifiers = @[NotificationIdentifier_Text];
    [JSPushService removeNotification:iden];
}

- (void)test_updateNotification
{
    
}

- (void)test_findNotification
{
    
}

# pragma mark - Notification Types

- (void)test_addTextNotofication
{
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"需求评审";
    content.subtitle = @"iOS 10适配工作";
    content.body = @"全面采用iOS 10新框架，需要封装一套完整的API供其他模块调用。";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"研发、测试、产品、项目",@"与会人员",@"12月5日",@"时间",nil];
    
    JSPushNotificationTrigger *trigger = [[JSPushNotificationTrigger alloc] init];
    
    // 设置通知的提醒时间
//    NSDate *currentDate   = [NSDate date];
//    currentDate = [currentDate dateByAddingTimeInterval:5.0];
//    trigger.fireDate = currentDate;

    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateC = [cal components:unitFlags fromDate:date];
    dateC.second = dateC.second + 15;
    trigger.dateComponents = dateC;

    NSLog(@"%@-%@",[NSDate date],trigger.fireDate);
    
    JSPushNotificationRequest *request = [[JSPushNotificationRequest alloc]init];
    request.requestIdentifier = NotificationIdentifier_Text;
    request.content = content;
    request.trigger = trigger;
    request.completionHandler = ^void (id result){
        NSLog(@"需求评审通知添加成功");
    };
    
    [JSPushService addNotification:request];
}


- (void)test_addTextNotofication1
{
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"测试用例评审";
    content.subtitle = @"新消息接入";
    content.body = @"针对本期接入的新消息进行验证，保证落地页跳转正确，落参正确。";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"研发、测试、产品、项目",@"与会人员",@"12月5日",@"时间",nil];
    
    JSPushNotificationTrigger *trigger = [[JSPushNotificationTrigger alloc] init];
    
    // 设置通知的提醒时间
    //    NSDate *currentDate   = [NSDate date];
    //    currentDate = [currentDate dateByAddingTimeInterval:5.0];
    //    trigger.fireDate = currentDate;
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateC = [cal components:unitFlags fromDate:date];
    dateC.second = dateC.second + 15;
    trigger.dateComponents = dateC;
    
    NSLog(@"%@-%@",[NSDate date],trigger.fireDate);
    
    JSPushNotificationRequest *request = [[JSPushNotificationRequest alloc]init];
    request.requestIdentifier = NotificationIdentifier_Text;
    request.content = content;
    request.trigger = trigger;
    request.completionHandler = ^void (id result){
        NSLog(@"需求评审通知添加成功");
    };
    
    [JSPushService addNotification:request];
}

- (void)test_addPictureNotication
{
    
}

- (void)test_addVideoNotication
{
    
}


@end
