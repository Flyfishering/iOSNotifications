//
//  PushTestingController.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/14.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "PushTestingController.h"

@interface PushTestingController ()<UITextFieldDelegate,JSPushRegisterDelegate>


/**
 各类开关
 */
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pictureSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *videoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mutipleSwtich;
@property (weak, nonatomic) IBOutlet UISwitch *slientSwitch;

@property (strong, nonatomic) NSArray   *switchArr;
/**
 时间轴
 */
@property (weak, nonatomic) IBOutlet UISlider *timeSlide;
@property (weak, nonatomic) IBOutlet UILabel *timeDesL;

/**
 输入ID文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *notiIdenLbl;

@property (weak, nonatomic) IBOutlet UILabel *logLabel;

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
    self.logLabel.numberOfLines = 0;
    self.notiIdenLbl.delegate = self;
    [JSPushService sharedManager].delegate = self;
    
    self.switchArr = [NSArray arrayWithObjects:self.mutipleSwtich,self.pictureSwitch,self.videoSwitch,self.slientSwitch, nil];
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
    
    UISwitch *swi = (UISwitch *)sender;
    if (swi == self.soundSwitch) {
        
    }else{
        if (swi.isOn) {
            for (UISwitch *other in self.switchArr) {
                if (other != swi) {
                    other.on = NO;
                }
            }
        }
    }
    
}


#pragma mark - JSPushRegisterDelegate

/**
 收到通知的代理方法
 参考 UNUserNotificationCenterDelegate
 */
- (void)jspushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSLog(@"JSPushRegisterDelegate receive notification%@",notification);
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

- (void)jspushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSLog(@"JSPushRegisterDelegate receive response%@",response);
    completionHandler();
}

#pragma mark - private method

- (void)test_removeNotification
{
    JSPushNotificationIdentifier *iden = [JSPushNotificationIdentifier identifireWithIdentifiers:@[self.notiIdenLbl.text] state:JSPushNotificationStateAll];
    [JSPushService removeNotification:iden];
    
    NSString *logStr = [NSString stringWithFormat:@"移除通知：id-%@",iden.identifiers];
    [self logNextActionString:logStr];
}

- (void)test_findNotification
{
    JSPushNotificationIdentifier *iden = [JSPushNotificationIdentifier identifireWithIdentifiers:@[self.notiIdenLbl.text] state:JSPushNotificationStateAll];
   
    __block NSArray * identifiers = [iden.identifiers copy];
    iden.findCompletionHandler = ^(NSArray * result){
        NSString *logStr = [NSString stringWithFormat:@"查找通知：id-%@-%lu",identifiers,result.count];
        [self logNextActionString:logStr];
    };

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
    
    JSPushNotificationRequest *request = [JSPushNotificationRequest requestWithIdentifier:self.notiIdenLbl.text content:content trigger:trigger withCompletionHandler:^(id  _Nullable result) {
    }];
    
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"更新通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];
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
    request.completionHandler = ^void (id result){
    };
    
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"添加文本通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];
}

- (void)test_addPictureNotication
{
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"物流通知";
    content.subtitle = @"你的宝贝在路上，注意查收~";
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * imageUrl = [[NSBundle mainBundle] URLForResource:@"joy" withExtension:@"png"];
    UNNotificationAttachment *imgAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:imageUrl options:nil error:&error];
    content.attachments = @[imgAtt];
#endif
    
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
    
    JSPushNotificationRequest *request = [JSPushNotificationRequest requestWithIdentifier:self.notiIdenLbl.text content:content trigger:trigger withCompletionHandler:^(id  _Nullable result) {
    }];
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"添加图片通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];

}

- (void)test_addVideoNotication
{
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"导购..";
    content.subtitle = @"如何选电脑";
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * mp4Url = [[NSBundle mainBundle] URLForResource:@"media" withExtension:@"mp4"];
    UNNotificationAttachment *mediaAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:mp4Url options:nil error:&error];
    content.attachments = @[mediaAtt];
#endif
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
    request.completionHandler = ^void (id result){
    };
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"添加视频通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];
}

- (void)test_addMutipleNotification
{
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"来，听歌";
    content.subtitle = @"许嵩新曲-素颜";
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * imageUrl = [[NSBundle mainBundle] URLForResource:@"joy" withExtension:@"png"];
    UNNotificationAttachment *imgAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:imageUrl options:nil error:&error];
    
    NSURL * mp4Url = [[NSBundle mainBundle] URLForResource:@"media" withExtension:@"mp4"];
    UNNotificationAttachment *mediaAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:mp4Url options:nil error:&error];
    content.attachments = @[imgAtt,mediaAtt];
#endif
    
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
    
    request.completionHandler = ^void (id result){
    };
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"添加混合通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];
}

- (void)logNextActionString:(NSString *)next
{
    NSString *nextLog = [NSString stringWithFormat:@"%@\n%@",self.logLabel.text,next];
    self.logLabel.text = nextLog;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};

    CGRect rect = [self.logLabel.text boundingRectWithSize:CGSizeMake(self.logLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    if (rect.size.height > self.logLabel.frame.size.height) {
        self.logLabel.text = @"";
    }
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

@end
