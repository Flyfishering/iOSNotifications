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

# define JSPUSH_NOTIFICATIONCENTER   ([UNUserNotificationCenter currentNotificationCenter])

#define iOSAbove10 ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOSBelow10 ([[ [UIDevice currentDevice] systemVersion] floatValue] < 10.0)

#define iOS8_10 ([[ [UIDevice currentDevice] systemVersion] floatValue] < 10.0) && ( [[ [UIDevice currentDevice] systemVersion] floatValue] >= 8.0 )
#define iOSBelow8 ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

#define kLocalNotificationIdentifier        @"kLocalNotificationIdentifier"
#define kLocalNotificationContent           @"kLocalNotificationContent"

//#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_10_0
#define NewPushSwitchOpen 1
//#endif

@interface JSPushUtilities : NSObject

+ (BOOL)jspush_validateString:(NSString *)str;

+ (BOOL)jspush_validateDictionary:(NSDictionary *)dic;

+ (BOOL)jspush_validateArray:(NSArray *)arr;

+ (NSString *)jspush_parseDeviceToken:(id)devicetoken;

+ (void)jspush_file:(char *)sourceFile function:(char *)functionName line:(int)lineNumber format:(NSString *)format, ...;

@end
