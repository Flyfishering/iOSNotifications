//
//  PushTestingController.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/14.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "PushTestingController.h"

@interface PushTestingController ()


/**
 各类开关
 */
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pictureSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *videoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mutipleSwtich;
@property (weak, nonatomic) IBOutlet UISwitch *slientSwitch;

/**
 时间轴
 */
@property (weak, nonatomic) IBOutlet UISlider *timeSlide;
@property (weak, nonatomic) IBOutlet UILabel *timeDesL;

/**
 输入ID文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *notiIdenLbl;

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation PushTestingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mutipleSwtich.on = NO;
    self.pictureSwitch.on = NO;
    self.videoSwitch.on = NO;
    self.soundSwitch.on = NO;
    self.slientSwitch.on = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePushFireTime:(id)sender {
    
    UISlider *sli = (UISlider *)sender;
    float value = sli.value;
    sli.value = (int)(value+0.5);
    self.timeDesL.text = [NSString stringWithFormat:@"%.0fs",sli.value];
}

- (IBAction)addNotification:(id)sender {
    
    if (self.mutipleSwtich.isOn) {
        [self test_addMutipleNotification];
    }else if (self.videoSwitch.isOn){
        [self test_addVideoNotication];
    }else if (self.pictureSwitch.isOn){
        [self test_addPictureNotication];
    }else {
        [self test_addTextNotofication];
    }
}

- (IBAction)removeNotification:(id)sender {
    [self test_removeNotification];
}

- (IBAction)updateNotification:(id)sender {
    [self test_updateTextNotofication];
}

- (IBAction)findNotification:(id)sender {
    [self test_findNotification];
}

/**
 开关值更改
 */
- (IBAction)switchValueChanged:(id)sender {
    
}

- (void)test_removeNotification
{
    JSPushNotificationIdentifier *iden = [JSPushNotificationIdentifier identifireWithIdentifiers:@[self.notiIdenLbl.text] state:JSPushNotificationStateAll];
    [JSPushService removeNotification:iden];
    
    NSString *logStr = [NSString stringWithFormat:@"移除通知：id-%@",iden.identifiers];
    [self logNextActionString:logStr];
}


- (void)test_findNotification
{
    JSPushNotificationIdentifier *iden = [JSPushNotificationIdentifier identifireWithIdentifiers:@[self.notiIdenLbl.text] state:JSPushNotificationStateAll withFindCompletionHandler:^(NSArray * _Nullable results) {
        NSString *logStr = [NSString stringWithFormat:@"查找通知：id-%@-%lu",iden.identifiers,results.count];
        [self logNextActionString:logStr];
    }];
    [JSPushService findNotification:iden];
}

- (void)test_updateTextNotofication
{
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"需求评审更新为-测试用例评审";
    content.subtitle = @"测试用例评审-新消息接入";
    content.body = @"测试用例评审-针对本期接入的新消息进行验证，保证落地页跳转正确，落参正确。";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"研发、测试、产品、项目",@"与会人员",@"12月15日",@"时间",nil];
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    
    //传递NSTimeInterval作为触发时间
    JSPushNotificationTrigger *trigger = [JSPushNotificationTrigger triggerWithTimeInterval:self.timeSlide.value repeats:NO];
    NSString *logStr = [NSString stringWithFormat:@"更新通知：%@-%@",content.title,content.body];
    JSPushNotificationRequest *request = [JSPushNotificationRequest requestWithIdentifier:self.notiIdenLbl.text content:content trigger:trigger withCompletionHandler:^(id  _Nullable result) {
        [self logNextActionString:logStr];
    }];
    
    [JSPushService addNotification:request];
}

# pragma mark - Notification Types

- (void)test_addTextNotofication
{
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"需求评审";
    content.subtitle = @"iOS 10适配工作";
    content.body = @"全面采用iOS 10新框架，需要封装一套完整的API供其他模块调用。";
    content.badge = @1;
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"研发、测试、产品、项目",@"与会人员",@"12月5日",@"时间",nil];
    
    //传递NSDateComponents作为触发时间
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateC = [cal components:unitFlags fromDate:date];
    dateC.second = dateC.second + self.timeSlide.value;

    JSPushNotificationTrigger *trigger = [JSPushNotificationTrigger triggerWithDateMatchingComponents:dateC repeats:NO];

    JSPushNotificationRequest *request = [[JSPushNotificationRequest alloc]init];
    request.requestIdentifier = self.notiIdenLbl.text;
    request.content = content;
    request.trigger = trigger;
    NSString *logStr = [NSString stringWithFormat:@"添加文本通知：%@-%@",content.title,content.body];
    request.completionHandler = ^void (id result){
        [self logNextActionString:logStr];
    };
    
    [JSPushService addNotification:request];
}

- (void)test_addPictureNotication
{
    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * imageUrl = [[NSBundle mainBundle] URLForResource:@"joy" withExtension:@"png"];
    UNNotificationAttachment *imgAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:imageUrl options:nil error:&error];
    
    
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"物流通知";
    content.subtitle = @"你的宝贝在路上，注意查收~";
    content.attachments = @[imgAtt];
    content.body = @"预计今天下午3：00~5：00准时送达。";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"商品",@"iPhone",@"白色",@"颜色",@"1月5日下午五点前",@"时间",nil];
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    
    //传递NSDate作为触发时间
    JSPushNotificationTrigger *trigger = [[JSPushNotificationTrigger alloc] init];
    NSDate *currentDate   = [NSDate date];
    currentDate = [currentDate dateByAddingTimeInterval:self.timeSlide.value];
    trigger.fireDate = currentDate;
    
    NSString *logStr = [NSString stringWithFormat:@"添加图片通知：%@-%@",content.title,content.body];
    JSPushNotificationRequest *request = [JSPushNotificationRequest requestWithIdentifier:self.notiIdenLbl.text content:content trigger:trigger withCompletionHandler:^(id  _Nullable result) {
        [self logNextActionString:logStr];
    }];
    [JSPushService addNotification:request];

}

- (void)test_addVideoNotication
{
    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * mp4Url = [[NSBundle mainBundle] URLForResource:@"media" withExtension:@"mp4"];
    UNNotificationAttachment *mediaAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:mp4Url options:nil error:&error];
    
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"导购..";
    content.subtitle = @"如何选电脑";
    content.attachments = @[mediaAtt];
    content.body = @"电脑小白，如何挑选自己心仪的电脑，技术达人分分钟教会你~";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"白色",@"颜色",@"1月5日下午三点",@"时间",nil];
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    
    JSPushNotificationTrigger *trigger = [JSPushNotificationTrigger triggerWithTimeInterval:self.timeSlide.value repeats:NO];
    
    JSPushNotificationRequest *request = [[JSPushNotificationRequest alloc]init];
    request.requestIdentifier = self.notiIdenLbl.text;
    request.content = content;
    request.trigger = trigger;
    NSString *logStr = [NSString stringWithFormat:@"添加视频通知：%@-%@",content.title,content.body];
    request.completionHandler = ^void (id result){
        [self logNextActionString:logStr];
    };
    [JSPushService addNotification:request];
}

- (void)test_addMutipleNotification
{

    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * imageUrl = [[NSBundle mainBundle] URLForResource:@"joy" withExtension:@"png"];
    UNNotificationAttachment *imgAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:imageUrl options:nil error:&error];
    
    NSURL * mp4Url = [[NSBundle mainBundle] URLForResource:@"media" withExtension:@"mp4"];
    UNNotificationAttachment *mediaAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:mp4Url options:nil error:&error];
    
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"来，听歌";
    content.subtitle = @"许嵩新曲-素颜";
    content.attachments = @[imgAtt,mediaAtt];
    content.body = @"~~~~~~~~~~播放中~~~~~";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"白色",@"颜色",@"1月5日下午三点",@"时间",nil];
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    
    JSPushNotificationTrigger *trigger = [JSPushNotificationTrigger triggerWithTimeInterval:self.timeSlide.value repeats:NO];

    JSPushNotificationRequest *request = [[JSPushNotificationRequest alloc]init];
    request.requestIdentifier = self.notiIdenLbl.text;
    request.content = content;
    request.trigger = trigger;
    
    NSString *logStr = [NSString stringWithFormat:@"添加混合通知：%@-%@",content.title,content.body];
    request.completionHandler = ^void (id result){
        [self logNextActionString:logStr];
    };
    [JSPushService addNotification:request];

}

- (void)logNextActionString:(NSString *)next
{
    NSString *nextLog = [NSString stringWithFormat:@"%@\n%@",self.logTextView.text,next];
    self.logTextView.text = nextLog;
}

@end
