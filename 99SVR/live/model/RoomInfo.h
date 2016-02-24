//
//  RoomInfo.h
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmd_vchat.h"
#import "yc_datatypes.h"

@class RoomUser;

@interface RoomInfo : NSObject
{
    int _m_nOp[4];
    char cCarName[NAMELEN];
//    SiegeInfo_t *_m_tSiegeInfo;
    char cRoomName[NAMELEN];
}

- (id)initWithRoom:(CMDJoinRoomResp_t*)pResp;

- (BOOL)IsRoomFangzhu:(int) userid;   //是不是房主
- (BOOL)IsRoomFuFangzhu:(int)userid;  //是不是副房主
- (int)getUserCount;
- (BOOL)removeUser:(int)userId;
- (BOOL)addUser:(RoomUser *)user;
- (RoomUser *)findUser:(int)nUserId;
- (SiegeInfo_t *)siegeInfo;
- (char *)getRoomName;
- (void)insertRUser:(RoomUser *)user;
- (int)getUserLevel:(RoomUser *)user;

@property (nonatomic,assign) int m_nRoomId;        //房间id
@property (nonatomic,assign) int m_nVipLevel;      //vip房间等级
@property (nonatomic,assign) int m_nGroupId;
@property (nonatomic,assign) short m_nAttributeId;   //房间属性
@property (nonatomic,assign) short m_nPubMicNum;     //公麦人数,该房间类型的最大公麦人数
@property (nonatomic,assign) short m_nSeats;
@property (nonatomic,assign) short m_nCurUserCount;
@property (nonatomic,assign) int  m_nCreatorId;    //房主
@property (nonatomic,assign) unsigned int m_nOpState;         //房间管理状态
@property (nonatomic,assign) int  m_bGetUserListFinished;   //用户列表是否下载完成
@property (nonatomic,copy) NSString *strGateURL;
@property (nonatomic,copy) NSString *strRoomName;
//@property (nonatomic,strong) NSMutableArray *aryNotice;
@property (nonatomic,assign) uint32 m_nMaxWaitMicUser;
@property (nonatomic,assign) uint32 m_nMaxUserWitMic;
@property (nonatomic,assign) uint32 m_bUsePwd;
@property (nonatomic,assign) uint32 m_bCollectRoom;
@property (nonatomic,assign) int ncarid;
@property (nonatomic,copy) NSString *strPwd;

@property (nonatomic,strong) NSMutableDictionary *dictUser;
//@property (nonatomic,strong) NSMutableArray *aryWaitMic;
//@property (nonatomic,strong) NSMutableArray *arySendFireWork;
//@property (nonatomic,copy) NSString *strStatus;
@property (nonatomic,strong) NSMutableArray *aryUser;

@end
