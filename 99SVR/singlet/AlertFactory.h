//
//  AlertFactory.h
//  99SVR
//
//  Created by xia zhonglin  on 4/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoomHttp;

typedef void(^AlertFactoryBlock)(NSInteger buttonIndex);

@interface AlertFactory : NSObject

@property (nonatomic,copy) AlertFactoryBlock alertBlock;

/**
 *  未登录的提示
 *
 *  @param sender 当前控制器
 *  @param msg    提示 (前缀统一为：登录后才能xxxxxxxxxx)
 *  @param block  回调
 */
+ (void)createLoginAlert:(UIViewController *)sender withMsg:(NSString *)msg block:(void (^)())block;

+ (void)createLoginAlert:(UIViewController *)sender block:(void (^)())block;

+ (void)createPassswordAlert:(UIViewController *)sender room:(RoomHttp *)room;

+ (void)createPassswordAlert:(UIViewController *)sender room:(RoomHttp*)room block:(void (^)(NSString *pwd))block;

@end
