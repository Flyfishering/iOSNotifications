//
//  ViewController.m
//  iOSNotifications
//
//  Created by WengHengcong on 4/20/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "PushViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface PushViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // [PushManager setBadge:8];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self findMe];
}


#pragma mark - send/remove/change

- (IBAction)sendNotiAction:(id)sender {
    
    JSPushNotificationContent *content = [[JSPushNotificationContent alloc] init];
    content.title = @"起床闹钟";
    content.subtitle = @"第一次起床";
    content.body = @"起床上学去";
    content.badge = @1;
//    content.action = @"查看";
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"5:00",@"第一次",@"6:00",@"第二次",nil];
    content.categoryIdentifier = @"customUI";
    content.sound = @"wake.caf";
    
    JSPushNotificationTrigger *trigger = [[JSPushNotificationTrigger alloc] init];
//    trigger.region =    第一优先级
    NSDateComponents *dateC = [[NSDateComponents alloc ]init];
    dateC.hour = 10;
    dateC.minute = 5;
    dateC.second = 5;
    trigger.dateComponents = dateC;
    
//    trigger.timeInterval = 5;
//    trigger.repeat = NO;
    
    JSPushNotificationRequest *request = [[JSPushNotificationRequest alloc]init];
    request.requestIdentifier = @"com.junglesong.wakeup";
    request.content = content;
    request.trigger = trigger;
    request.completionHandler = ^void (id result){
        NSLog(@"request done");
    };
    
    [JSPushService addNotification:request];
}

# pragma mark 定位

- (void)findMe
{

    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    
    if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
        && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
        //位置服务是在设置中禁用
    {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            NSLog(@"requestAlwaysAuthorization");
            [self.locationManager requestAlwaysAuthorization];
        }
        
        //开始定位，不断调用其代理方法
        [self.locationManager startUpdatingLocation];
        NSLog(@"start gps");
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 2.停止定位
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

@end
