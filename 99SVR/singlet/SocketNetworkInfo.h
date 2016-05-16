//
//  SocketNetworkInfo.h
//  99SVR
//
//  Created by jiangys on 16/5/16.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//  socket 网络状态

#import <Foundation/Foundation.h>

@interface SocketNetworkInfo : NSObject

DEFINE_SINGLETON_FOR_HEADER(SocketNetworkInfo)

/**
 *  当前push的子view总数，0表示是根目录
 */
@property (nonatomic) NSInteger childVcCount;
/**
 *  1连接成功，0连接失败
 */
@property (nonatomic) NSInteger socketState;

@end
