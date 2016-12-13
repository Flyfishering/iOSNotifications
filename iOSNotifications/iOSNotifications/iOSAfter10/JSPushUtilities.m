//
//  JSPushUtilities.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/13.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushUtilities.h"

@implementation JSPushUtilities


+ (BOOL)jspush_validateString:(NSString *)str
{
    if (str && [str isKindOfClass:[NSString class]] && str.length > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)jspush_validateDictionary:(NSDictionary *)dic
{
    if (dic && [dic isKindOfClass:[NSDictionary class]] && dic.allKeys.count > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)jspush_validateArray:(NSArray *)arr
{
    if (arr && [arr isKindOfClass:[NSArray class]] && (arr.count > 0)) {
        return YES;
    }
    return NO;
}

@end
