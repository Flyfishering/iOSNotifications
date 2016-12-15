//
//  AppDelegate.h
//  iOSNotifications
//
//  Created by WengHengcong on 4/20/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= JSPUSH_IPHONE_10_0) )
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>
#else
@interface AppDelegate : UIResponder <UIApplicationDelegate>
#endif

@property (strong, nonatomic) UIWindow *window;

@end
