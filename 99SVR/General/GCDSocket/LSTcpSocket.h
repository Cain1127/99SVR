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

@property (nonatomic,strong) NSMutableArray *aryNotice;

@property (nonatomic,strong) NSMutableArray *aryChat;

@property (nonatomic,assign) int nMId;

DEFINE_SINGLETON_FOR_HEADER(LSTcpSocket);

- (NSArray *)aryUser;

- (NSString *)getRoomId;

-(BOOL)connectServerHost;

-(void)closeSocket;

- (void)loginServer:(NSString *)strUser pwd:(NSString *)strPwd;

- (BOOL)connectRoomInfo:(NSString *)strId address:(NSString *)strIp port:(int)nPort;

- (BOOL)connectRoomAndPwd:(NSString *)strPwd;

- (void)reConnectRoomInfo;

- (BOOL)joinRoomInfo;

- (void)sendColletRoom:(int)nCollet;

- (void)exit_Room;

- (void)exit_Room:(BOOL)bClose;

- (void)sendChatInfo:(NSString *)strInfo toid:(int)userId;

- (NSString *)getRoomName;

- (void)setUserInfo;

- (RoomInfo *)getRoomInfo;

- (void)enterBackGroud;

- (void)sendGift:(int)userId;

@end
