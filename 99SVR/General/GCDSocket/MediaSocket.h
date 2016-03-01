//
//  TestMedia.h
//  99SVR
//
//  Created by xia zhonglin  on 1/25/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReciveMessage)(unsigned char *cBuf,int nLen,int pt);

@interface MediaSocket : NSObject

@property (nonatomic,copy) ReciveMessage block;

@property (nonatomic,strong) NSMutableArray *videoBuf;

@property (nonatomic,strong) NSMutableArray *audioBuf;

- (void)connectIpAndPort:(NSString *)strIp port:(int)nPort;

- (void)connectRoomId:(int)roomid mic:(int)userid;

- (void)closeSocket;

- (void)setEnableAudio:(BOOL)enable;

- (void)setEnableVideo:(BOOL)enable;

- (void)settingBackVideo:(BOOL)enable;

@end
