//
//  ViewController.h
//  iOSNotifications
//
//  Created by WengHengcong on 4/20/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushViewController : UIViewController

@property (nonatomic,copy)  NSString *devicetoken;

@property (nonatomic,strong)  NSDictionary *remoteNoti;

@property (nonatomic,strong)  UILocalNotification *localNoti;

@end

