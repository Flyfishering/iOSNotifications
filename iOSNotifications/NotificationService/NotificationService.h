//
//  NotificationService.h
//  NotificationService
//
//  Created by WengHengcong on 2016/9/20.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@interface NotificationService : UNNotificationServiceExtension

@end
#endif