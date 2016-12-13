//
//  JSPushUtilities.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/13.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSPushUtilities : NSObject

+ (BOOL)jspush_validateString:(NSString *)str;

+ (BOOL)jspush_validateDictionary:(NSDictionary *)dic;

+ (BOOL)jspush_validateArray:(NSArray *)arr;

@end
