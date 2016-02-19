#import "RoomUser.h"
#import "message_vchat.h"
#import "LSTcpSocket.h"
#import "cmd_vchat.h"

@implementation RoomUser

- (BOOL)isHide
{
    return _m_nInRoomState & 0x00000800 ? YES : NO;
}

- (int)GetRoomMgrLevel
{
//    int nLevel = 0;
//    if([self isOnMic])
//    {
//        nLevel = 200;
//    }
//    else if(self.m_nUserType == 1)
//    {
//        nLevel = 190;
//    }
//    else if(rInfo != 0 && [rInfo IsRoomFangzhu:_m_nUserId])
//    {
//        nLevel = 180;
//    }
//    else if(rInfo != 0 && [rInfo IsRoomFuFangzhu:_m_nUserId])
//    {
//        nLevel = 109;
//    }
//    else if(_m_nInRoomState & FT_ROOMUSER_STATUS_IS_TEMPOP)  //临管
//    {
//        nLevel = 104;
//    }
//    else if([self isManager])
//    {
//        nLevel = _m_nVipLevel;
//    }
    return _nLevel;
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
        case 1:
        case 2:
            isMgr = NO;
            break;
        default:
            isMgr = YES;
    }
    return isMgr;
}

@end

