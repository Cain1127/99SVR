//
//  RoomService.m
//  99SVR
//
//  Created by xia zhonglin  on 4/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomService.h"
#import "VideoRoomMessage.pb.h"
#import "NoticeModel.h"
#import "RoomUser.h"
#import "DecodeJson.h"

@implementation RoomService




+ (NSString *)getToUser:(int)userId name:(NSString *)strName vip:(int)vipInfo
{
    if(userId == 0)
    {
        return @"";
    }
    NSString *strVip = @"";
    if (vipInfo>2)
    {
        strVip = [NSString stringWithFormat:@"<img src=\"vip_header_%d\" width=\"13\" height=\"13\" style=\"vertical-align:middle;\"></img>",vipInfo];
    }
    
    if(userId == KUserSingleton.nUserId)
    {
        return [NSString stringWithFormat:@"<span value=\"forme--%d\" style=\"color:#919191;font-size:12px;\">%@%@</span>",userId,strVip,KUserSingleton.strName];
    }
    else
    {
        if (strName)
        {
            return [NSString stringWithFormat:@"<a style=\"color:#919191;font-size:12px;\" href=\"sqchatid://%d\" value=\"%@\">%@%@</a>",
                    userId,strName,strVip,strName];
        }
        else
        {
            return [NSString stringWithFormat:@"<a style=\"color:#919191;font-size:12px;\" href=\"sqchatid://%d\">%@%d</a>",
                    userId,strVip,userId];
        }
    }
}

+ (BOOL )getChatInfo:(RoomChatMsg *)msg array:(NSMutableArray *)aryChat prichat:(NSMutableArray *)aryPriChat
{
    
    NSString *strContent = [NSString stringWithCString:msg->content().c_str() encoding:GBK_ENCODING];
    strContent = [DecodeJson replaceEmojiNewString:strContent];
    NSString *strSrcName = [NSString stringWithCString:msg->srcalias().c_str() encoding:GBK_ENCODING];
    NSString *strFrom = [RoomService getToUser:msg->srcid() name:strSrcName vip:msg->srcviplevel()];
    NSString *strToName = [NSString stringWithCString:msg->toalias().c_str() encoding:GBK_ENCODING];
    NSString *strTo = [RoomService getToUser:msg->toid() name:strToName vip:msg->toviplevel()];
    NSString *strInfo = nil;
    
    //记录是不是我@别人
    BOOL meToOtherBool = NO;
    
    if (msg->toid() == 0)
    {
        strInfo = [NSString stringWithFormat:@"<span style=\"ccolor:#919191;font-size:12px;line-height:15px;\">%@ :</span><br><span style=\"line-height:20px;\">%@</span>",strFrom,strContent];
    }
    else
    {
        strInfo = [NSString stringWithFormat:@"<span style=\"color:#919191;font-size:12px;line-height:20px;\"> %@  @ %@ :</span><br> \
                   <span style=\"line-height:20px;\">%@</span>",strFrom,strTo,strContent];
        if ([strFrom rangeOfString:[NSString stringWithFormat:@"%d",[UserInfo sharedUserInfo].nUserId]].location != NSNotFound)
        {
            meToOtherBool = YES;
        }
    }
    strInfo = [DecodeJson replaceEmojiNewString:strInfo];    
    [aryChat addObject:strInfo];
    
    NSString *query = [NSString stringWithFormat:@"value=\"forme--%d\"",[UserInfo sharedUserInfo].nUserId];
    //查询是否有对我说的记录 或者我@别人的信息 msg->toid() == [UserInfo sharedUserInfo].nUserId  说明是存在@别人了
    if ([strTo rangeOfString:query].location != NSNotFound || (meToOtherBool))
    {
        [aryPriChat addObject:strInfo];
        [RoomService clearChatInfo:aryChat];
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_TO_ME_VC object:nil];
    }
    [RoomService clearChatInfo:aryChat];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:aryChat];
    
    return YES;
}

+ (BOOL )clearChatInfo:(NSMutableArray *)array{
    if (array.count>100)
    {
        @synchronized(array)
        {
            for (int i=0 ;i < 50 ;i++)
            {
                [array removeObjectAtIndex:0];
            }
        }
    }
    return YES;
}
+ (BOOL)addRoomUser:(RoomInfo*)_rInfo user:(RoomUserInfo *)pItem
{
    RoomUser *pUser = nil;
    if(!_rInfo){return NO;}
    pUser = [_rInfo findUser:pItem->userid()];
    if (pUser==nil)
    {
        pUser = [[RoomUser alloc] init];
    }
    else
    {
        return NO;
    }
    pUser.m_nUserId = pItem->userid();
    pUser.m_nHeadId  = pItem->headicon();
    pUser.m_nVipLevel = pItem->viplevel();
    pUser.m_nInRoomState = pItem->userstate();
    pUser.m_strUserAlias = [NSString stringWithCString:pItem->useralias().c_str() encoding:GBK_ENCODING];
    pUser.m_nRoomLevel = pItem->roomlevel();
    pUser.m_nUserType = pItem->usertype();
    pUser.nLevel = [_rInfo getUserLevel:pUser];
    if ([pUser isOnMic])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_MIC_UPDATE_VC object:nil];
    }
    if (pUser)
    {
        [_rInfo addUser:pUser];
        [_rInfo insertRUser:pUser];
    }
    return YES;
}

+ (BOOL)getRibao:(RoomChatMsg *)msg notice:(NSMutableArray *)aryBuffer{
    NSString *strContent = [NSString stringWithCString:msg->content().c_str() encoding:GBK_ENCODING];
    NoticeModel *notice = [[NoticeModel alloc] init];
    if (msg->msgtype()==1)
    {
        notice.strContent = [DecodeJson resoleNotice:strContent index:2];
    }
    else
    {
        notice.strContent = [DecodeJson resoleNotice:strContent index:3];
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    notice.strTime = [fmt stringFromDate:date];
    [aryBuffer addObject:notice];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_NOTICE_VC object:nil];
    return YES;
}

+ (NSString *)getTeachInfo:(RoomNotice *)pInfo
{
    char szTemp[(pInfo->textlen()+1)*2];
    memset(szTemp, 0, (pInfo->textlen()+1)*2);
    memcpy(szTemp, pInfo->content().c_str(), pInfo->textlen());
    szTemp[pInfo->textlen()]='\0';
    NSString *teachTable = [NSString stringWithCString:pInfo->content().c_str() encoding:GBK_ENCODING];
    while ([teachTable rangeOfString:@"\r"].location!=NSNotFound) {
        teachTable = [teachTable stringByReplacingOccurrencesOfString:@"\r" withString:@"<br/>"];
    }
    NSString *strMsg = [NSString stringWithFormat:@"<span style=\"line-height:30px;\">%@</span>",teachTable];
    return strMsg;
}


+ (BOOL)getNoticeInfo:(RoomNotice *)pInfo notice:(NSMutableArray *)aryBuffer{

    char szTemp[4096]={0};
    memcpy(szTemp, pInfo->content().c_str(), pInfo->textlen());
    szTemp[pInfo->textlen()]='\0';
    NSString *strInfo = [NSString stringWithCString:szTemp encoding:GBK_ENCODING];
    NoticeModel *notice = [[NoticeModel alloc] init];
    notice.strContent = [DecodeJson resoleNotice:strInfo index:1];
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    notice.strTime = [fmt stringFromDate:date];
    [aryBuffer addObject:notice];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_NOTICE_VC object:nil];
    
    return YES;
}

+ (BOOL)sendLocalInfo:(NSString *)strMsg toid:(int)toId roomInfo:(RoomInfo *)rInfo aryChat:(NSMutableArray *)aryChat{
    
    return YES;
}

@end
