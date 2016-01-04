#import "RoomUser.h"
#import "RoomInfo.h"
#import "message_vchat.h"
#import "LSTcpSocket.h"

@implementation RoomUser

- (BOOL)isHide
{
    return _m_nInRoomState & 0x00000800 ? YES : NO;
}

- (int)GetRoomMgrLevel
{
    RoomInfo *rInfo = [[LSTcpSocket sharedLSTcpSocket] getRoomInfo];
    int nLevel = 0;
    
    if([self isOnMic])
    {
        nLevel = 200;
    }
    else if(self.m_nUserType == 1)
    {
        nLevel = 190;
    }
    else if(_m_nRoomLevel == RoomMgrType_Daili)  //代理
    {
        nLevel = 106;
    }
    else if(_m_nRoomLevel == RoomMgrType_Quzhang)  //区长
    {
        nLevel = 105;
    }
    else if(rInfo != 0 && [rInfo IsRoomFangzhu:_m_nUserId])
    {
        nLevel = 180;
    }
    else if(rInfo != 0 && [rInfo IsRoomFuFangzhu:_m_nUserId])
    {
        nLevel = 109;
    }
    else if(_m_nRoomLevel == RoomMgrType_Guan)  //管理
    {
        nLevel = 103;
    }
    else if(_m_nInRoomState & FT_ROOMUSER_STATUS_IS_TEMPOP)  //临管
    {
        nLevel = 104;
    }
    else if([self isManager])
    {
        nLevel = _m_nVipLevel;
    }
    return nLevel;
}
- (BOOL)isOnMic
{
    
    if(_m_nInRoomState&(FT_ROOMUSER_STATUS_PUBLIC_MIC |
                        FT_ROOMUSER_STATUS_PRIVE_MIC  |
                        FT_ROOMUSER_STATUS_SECRET_MIC |
                        FT_ROOMUSER_STATUS_CHARGE_MIC))
        return YES;
    return NO;
}

- (int)isManager
{
    BOOL isMgr = YES;
    switch (_m_nVipLevel ) {
        case 21:
        case 22:
        case 23:
        case 24:
        case 25:
        case 31:
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
            isMgr = YES;
            break;
        default:
            isMgr = NO;
    }
    return isMgr;
}

@end

