//
//  JSPushUtilities.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/13.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

/***  Log */
# define JSPUSHLog(str, ...) [JSPushUtilities jspush_file:((char *)__FILE__) function:((char *)__FUNCTION__) line:(__LINE__) format:(str),##__VA_ARGS__]

#define JSPUSH_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= JSPUSH_IPHONE_10_0) )
# define JSPUSH_NOTIFICATIONCENTER   ([UNUserNotificationCenter currentNotificationCenter])
#endif

#define iOSAbove10 ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOSBelow10 ([[ [UIDevice currentDevice] systemVersion] floatValue] < 10.0)

#define iOS8_10 ([[ [UIDevice currentDevice] systemVersion] floatValue] < 10.0) && ( [[ [UIDevice currentDevice] systemVersion] floatValue] >= 8.0 )
#define iOSBelow8 ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

#define kLocalNotificationIdentifier        @"com.jspush.kLocalNotificationIdentifier"
#define kLocalNotificationContent           @"kLocalNotificationContent"

#define JSPUSH_IPHONE_10_0  100000

@interface JSPushUtilities : NSObject

+ (BOOL)jspush_validateString:(NSString *)str;

+ (BOOL)jspush_validateDictionary:(NSDictionary *)dic;

+ (BOOL)jspush_validateArray:(NSArray *)arr;

+ (NSString *)jspush_parseDeviceToken:(id)devicetoken;

+ (NSDate *)jspush_dateWithNSDateComponents:(NSDateComponents *)dateComponents;

+ (NSDateComponents *)jspush_dateComponentsWithNSDate:(NSDate *)date;

+ (void)jspush_file:(char *)sourceFile function:(char *)functionName line:(int)lineNumber format:(NSString *)format, ...;

@end
