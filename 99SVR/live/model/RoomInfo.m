//
//  RoomInfo.m
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomInfo.h"
#import "RoomUser.h"

@implementation RoomInfo

- (id)initWithRoom:(CMDJoinRoomResp_t *)pResp
{
    self = [super init];
    //清除房间信息
    _m_nRoomId = pResp->vcbid;
    _m_nVipLevel =0;
    _m_nGroupId = pResp->groupid;
    _m_nAttributeId =pResp->roomtype;
    _m_nSeats=pResp->seats;
    _m_nCurUserCount =0;
    _m_nCreatorId =pResp->creatorid;
    _m_nOp[0] = pResp->op1id;
    _m_nOp[1] = pResp->op2id;
    _m_nOp[2] = pResp->op3id;
    _m_nOp[3] = pResp->op4id;
    _m_nOpState =pResp->runstate;
    
    memset(cRoomName, 0, NAMELEN);
    
    sprintf(cRoomName,"%s",pResp->cname);
    _strRoomName = [NSString stringWithCString:pResp->cname encoding:GBK_ENCODING];
    
    _strPwd = [NSString stringWithCString:pResp->cpwd encoding:GBK_ENCODING];
    
    _m_bCollectRoom=pResp->bIsCollectRoom;
    memset(cCarName, 0, NAMELEN);
    sprintf(cCarName, "%s",pResp->carname);
    _ncarid = pResp->ncarid;
    
    int nSize = sizeof(SiegeInfo_t);
    _m_tSiegeInfo = malloc(nSize);
    memcpy(_m_tSiegeInfo,&pResp->siege_info,sizeof(SiegeInfo_t));
    
    //关闭房间等待窗口
    //重置自己的全局对象房间状态
    
    return self;
}

- (BOOL)IsRoomFangzhu:(int) userid   //是不是房主
{
    return _m_nCreatorId == userid;
}

- (BOOL)IsRoomFuFangzhu:(int)userid  //是不是副房主
{
    if(userid == 0) return NO;
    for(int i=0;i<4;i++)
    {
        if(_m_nOp[i] == userid)
            return YES;
    }
    return NO;
}

- (int)getUserCount
{
    return 1;
}

- (BOOL)removeUser:(int)userId
{
    if (_dictUser)
    {
        [_dictUser removeObjectForKey:[NSNumber numberWithInt:userId]];
    }
    return YES;
}

- (int)getUserLevel:(RoomUser *)user
{
    int nLevel = 0;
    if(user.m_nInRoomState&(FT_ROOMUSER_STATUS_PUBLIC_MIC |
                               FT_ROOMUSER_STATUS_PRIVE_MIC  |
                               FT_ROOMUSER_STATUS_SECRET_MIC |
                               FT_ROOMUSER_STATUS_CHARGE_MIC))
    {
        nLevel = 200;
    }
    else if(user.m_nUserType == 1)
    {
        nLevel = 190;
    }
    else if([self IsRoomFangzhu:user.m_nUserId])
    {
        nLevel = 180;
    }
    else if([self IsRoomFuFangzhu:user.m_nUserId])
    {
        nLevel = 109;
    }
    else if(user.m_nInRoomState & FT_ROOMUSER_STATUS_IS_TEMPOP)  //临管
    {
        nLevel = 104;
    }
    else if(user.m_nVipLevel!=1 && user.m_nVipLevel != 2)
    {
        nLevel = user.m_nVipLevel;
    }
    return nLevel;
}

- (BOOL)addUser:(RoomUser *)user
{
    if (_dictUser == nil)
    {
        _dictUser = [NSMutableDictionary dictionary];
    }
    [_dictUser setObject:user forKey:[NSNumber numberWithInt:user.m_nUserId]];
    return YES;
}

- (RoomUser *)findUser:(int)nUserId
{
    RoomUser *user = [_dictUser objectForKey:[NSNumber numberWithInt:nUserId]];
    if (user)
    {
        return user;
    }
    else
    {
        return nil;
    }
}

- (SiegeInfo_t *)siegeInfo
{
    return _m_tSiegeInfo;
}

- (char *)getRoomName
{
    return cRoomName;
}

NSComparator cmptr = ^(id omUser1, id omUser2)
{
    RoomUser *user1 = (RoomUser *)omUser1;
    RoomUser *user2 = (RoomUser *)omUser2;
    
    if ([user1 isOnMic])
    {
        return (NSComparisonResult)NSOrderedAscending;
    }
    else if ([user2 isOnMic])
    {
        return (NSComparisonResult)NSOrderedDescending;
    }
    else if(user1.m_nUserType > user2.m_nUserType)
    {
        return (NSComparisonResult)NSOrderedAscending;
    }
    else if(user2.m_nUserType > user1.m_nUserType)
    {
        return (NSComparisonResult)NSOrderedDescending;
    }
    else if ([user1 GetRoomMgrLevel] > [user2 GetRoomMgrLevel])
    {
        return (NSComparisonResult)NSOrderedAscending;
    }
    else if([user2 GetRoomMgrLevel] > [user1 GetRoomMgrLevel])
    {
        return (NSComparisonResult)NSOrderedDescending;
    }
    return (NSComparisonResult)NSOrderedSame;
};

- (void)sortUserDict
{
    NSArray *array = [_dictUser allValues];
    NSArray *sortArray = [array sortedArrayUsingComparator:cmptr];
    if (_aryUser==nil)
    {
        _aryUser = [NSMutableArray array];
    }
    [_aryUser removeAllObjects];
    [_aryUser addObjectsFromArray:sortArray];
}

- (void)insertRUser:(RoomUser *)user
{
    if (_aryUser==nil)
    {
        _aryUser = [NSMutableArray array];
    }
    if(_aryUser.count == 0)
    {
        [_aryUser insertObject:user atIndex:0];
        return ;
    }
    if(![user isManager] && [user GetRoomMgrLevel]==0)
    {
        [_aryUser insertObject:user atIndex:_aryUser.count];
        return ;
    }

//    DLog(@"userid:%d--vipmanager:%d--getroom:%d",user.m_nUserId,user.m_nVipLevel,[user GetRoomMgrLevel]);
    for (int i=0; i<_aryUser.count; i++)
    {
        RoomUser *user1 = [_aryUser objectAtIndex:i];
        if ([user GetRoomMgrLevel] >= [user1 GetRoomMgrLevel])
        {
            [_aryUser insertObject:user atIndex:i];
            break;
        }
        else
        {
            if (i==_aryUser.count-1)
            {
                [_aryUser insertObject:user atIndex:_aryUser.count];
                break;
            }
        }
    }
}

@end
