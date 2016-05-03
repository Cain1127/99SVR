//
//  UnreadModel.h
//  99SVR
//
//  Created by Jiangys on 16/5/3.
//  Copyright © 2016年 Jiangys . All rights reserved.
//  消息未读数

#import <Foundation/Foundation.h>

@interface UnreadModel : NSObject
/** 系统数 */
@property(nonatomic, assign) NSUInteger system;
/**  */
@property(nonatomic, assign) NSUInteger answer;
/**  */
@property(nonatomic, assign) NSUInteger reply;
/**  */
@property(nonatomic, assign) NSUInteger privateservice;
@end
