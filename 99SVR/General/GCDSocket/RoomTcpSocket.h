//
//  RoomTcpSocket.h
//  99SVR
//
//  Created by xia zhonglin  on 2/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoomInfo;

@interface RoomTcpSocket : NSObject

@property (nonatomic,strong) RoomInfo *rInfo;

@property (nonatomic,strong) NSMutableArray *aryNotice;

@property (nonatomic,strong) NSMutableArray *aryChat;

@property (nonatomic,strong) NSMutableArray *aryPriChat;

@property (nonatomic,assign) int nMId;

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

- (void)sendMediaInfo:(NSString *)strInfo;

- (void)addChatInfo:(NSString *)strInfo;
/**
 *  送礼物
 *
 *  @param giftId   礼物Id
 *  @param giftNum  礼物number
 */
- (void)sendGift:(int)giftId num:(int)giftNum;

@end


@interface SVRMesssage : NSObject
@property (nonatomic,strong)    NSString    *messageID;
@property (nonatomic,strong)    NSString    *text;
+ (SVRMesssage *)message:(NSString *)strInfo;
@end
