//
//  AlertFactory.h
//  99SVR
//
//  Created by xia zhonglin  on 4/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoomHttp;
@interface AlertFactory : NSObject

+ (void)createLoginAlert:(UIViewController *)sender block:(void (^)())block;

+ (void)createPassswordAlert:(UIViewController *)sender room:(RoomHttp *)room;

@end
