//
//  JSPushNotificationTrigger.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*!
 * 推送触发方式实体类
 * 注：dateComponents、timeInterval、region在iOS10以上可选择其中一个参数传入有效值，如果同时传入值会根据优先级I、II、III使其中一种触发方式生效，fireDate为iOS10以下根据时间触发时须传入的参数
 */
@interface JSPushNotificationTrigger : NSObject<NSCopying, NSCoding>

/**
 设置是否重复，默认为NO
 */
@property (nonatomic, assign) BOOL repeat;

/**
 iOS 10以下，用来设置触发推送的时间
 注意：iOS10以上无效
 */
@property (nonatomic, copy) NSDate      *fireDate NS_DEPRECATED_IOS(2_0, 10_0);

/**
 iOS8以上有效，用来设置触发推送的位置
 iOS10以上优先级为I，应用需要有允许使用定位的授权
 */
@property (nonatomic, copy) CLRegion    *region NS_AVAILABLE_IOS(8_0);

/**
 用来设置触发推送的日期时间
 iOS10以上有效，优先级为II
 */
@property (nonatomic, copy) NSDateComponents *dateComponents NS_AVAILABLE_IOS(10_0);

/**
 用来设置触发推送的时间
 iOS10以上有效，优先级为III
 */
@property (nonatomic, assign) NSTimeInterval timeInterval NS_AVAILABLE_IOS(10_0);

@end
