//
//  JSPushUtilities.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/13.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
/***  Log */
# define JSPUSHLog(str, ...) [self jspush_file:((char *)__FILE__) function:((char *)__FUNCTION__) line:(__LINE__) format:(str),##__VA_ARGS__]

#define JSPUSH_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

# define JSPUSH_NOTIFICATIONCENTER   ([UNUserNotificationCenter currentNotificationCenter])


@interface JSPushUtilities : NSObject

+ (BOOL)jspush_validateString:(NSString *)str;

+ (BOOL)jspush_validateDictionary:(NSDictionary *)dic;

+ (BOOL)jspush_validateArray:(NSArray *)arr;

@end
