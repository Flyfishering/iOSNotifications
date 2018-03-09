//
//  PushHandle.h
//  iOSNotifications
//
//  Created by WengHengcong on 2018/3/8.
//  Copyright © 2018年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushHandle : NSObject

- (void)handlePushWithUserinfo:(NSDictionary *)userinfo;

@end
