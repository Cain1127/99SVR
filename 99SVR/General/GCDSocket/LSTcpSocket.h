//
//  LSTcpSocket.h
//  FreeCar
//
//  Created by xiongchi on 15/7/8.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoomInfo;

@interface LSTcpSocket : NSObject

DEFINE_SINGLETON_FOR_HEADER(LSTcpSocket);

-(BOOL)connectServerHost;

-(void)closeSocket;

- (void)loginServer:(NSString *)strUser pwd:(NSString *)strPwd;

- (void)setUserInfo;

@end
