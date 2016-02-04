//
//  LSTcpSocket.m
//  FreeCar
//
//  Created by xiongchi on 15/7/8.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "LSTcpSocket.h"
#import "cmd_vchat.h"
#import "NoticeModel.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "BaseService.h"
#import "RoomHttp.h"
#import "RoomGroup.h"
#import "UserInfo.h"
#import "message_comm.h"
#import "message_vchat.h"
#import "DecodeJson.h"
#import "GCDAsyncSocket.h"
#import "crc32.h"
#import "RoomInfo.h"
#import "RoomUser.h"
#import "moonDefines.h"
///c/c++
#import <netdb.h>
#import <fcntl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <string.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import <unistd.h>
#import <stdlib.h>
#import <stdio.h>
#import <sys/wait.h>
#import <sys/types.h>
#import <sys/times.h>
#import <sys/time.h>
#include <sys/select.h>
#include <time.h>
#include <errno.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//

#define _PRODUCT_CORE_MESSAGE_VER_   10690001

#define SOCKET_READ_LENGTH     1
#define SOCKET_READ_DATA       2

@interface LSTcpSocket()<GCDAsyncSocketDelegate>
{
    char cBuf[16384];
    int nSocketType;
    BOOL bCache;
    dispatch_queue_t tcpThread;
    dispatch_queue_t downGCD;
}
@property (nonatomic) int nFall;
@property (nonatomic,copy) NSString *strUser;
@property (nonatomic,copy) NSString *strPwd;
@property (nonatomic,copy) NSString *strRoomPwd;
@property (nonatomic,copy) NSString *strRoomAddress;
@property (nonatomic,assign) int nRoomPort;
@property (nonatomic,copy) NSString *strRoomId;
@property (nonatomic,strong) RoomInfo *rInfo;
@property (nonatomic,strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic,strong) NSMutableArray *aryBuffer;
@property (nonatomic,strong) NSMutableDictionary *dictDownLoad;

@end

@implementation LSTcpSocket

DEFINE_SINGLETON_FOR_CLASS(LSTcpSocket);

- (RoomInfo *)getRoomInfo
{
    if(_strRoomId)
    {
        return _rInfo;
    }
    return nil;
}

- (void)enterBackGroud
{
    [self exit_Room];
    if(_asyncSocket)
    {
        [_asyncSocket disconnectAfterReading];
        [_aryChat removeAllObjects];
        [_aryNotice removeAllObjects];
        [_rInfo.dictUser removeAllObjects];
        _rInfo = nil;
    }
}

-(void)closeSocket
{
    if(_asyncSocket)
    {
        [_asyncSocket disconnectAfterReading];
        _asyncSocket = nil;
        [_aryChat removeAllObjects];
        [_aryNotice removeAllObjects];
        [_rInfo.dictUser removeAllObjects];
        [_rInfo.aryUser removeAllObjects];
        _rInfo = nil;
    }
}

- (NSString *)getRoomName
{
    return _rInfo.strRoomName;
}

- (NSString *)getRoomId
{
    return _strRoomId;
}

- (void)setUserInfo
{
    _strUser = [NSString stringWithFormat:@"%d",[UserInfo sharedUserInfo].nUserId];
    _strPwd = [UserInfo sharedUserInfo].strPwd;
}

-(BOOL)isConnected
{
    return _asyncSocket.isConnected;
}

#pragma mark 往服务器发送消息
- (void)sendMessage:(char *)pReq size:(int)nSize version:(int)nVersion maincmd:(int)nMainCmd subcmd:(int)nSubCmd
{
    char szBuf[1024]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER*)szBuf;
    pHead->length = sizeof(COM_MSG_HEADER) + nSize;
    pHead->checkcode =0;
    pHead->version = nVersion;
    pHead->maincmd = nMainCmd;
    pHead->subcmd = nSubCmd;
    memcpy(pHead->content,pReq,nSize);
    NSData *data = [NSData dataWithBytes:szBuf length:pHead->length];
    [_asyncSocket writeData:data withTimeout:-1 tag:1];
}

#pragma mark 连接登录服务器
-(BOOL)connectServerHost
{
    BOOL bReturn = NO;
    nSocketType = 1;
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:tcpThread];
    NSError *error = nil;
    if(![_asyncSocket connectToHost:SVR_LOGIN_IP onPort:SVR_LOGIN_PORT error:&error])
    {
        DLog(@"error:%@",error);
        _asyncSocket.delegate = nil;
        return bReturn;
    }
    DLog(@"连接成功:%d",bReturn);
    return bReturn;
}

-(BOOL)connectLogInServer:(NSString *)strAddr port:(int)nPort
{
    BOOL bReturn = NO;
    if (tcpThread==nil)
    {
        tcpThread = dispatch_queue_create("socket",0);
    }
    nSocketType = 1;
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:tcpThread];
    NSError *error = nil;
    if(![_asyncSocket connectToHost:strAddr onPort:nPort error:&error])
    {
        DLog(@"error:%@",error);
        _asyncSocket.delegate = nil;
        return bReturn;
    }
    DLog(@"连接成功:%d",bReturn);
    return bReturn;
}

- (NSArray *)aryUser
{
    if (_rInfo)
    {
        return _rInfo.aryUser;
    }
    return nil;
}

-(int)getSocketHead:(char *)pBuf len:(int)nLen
{
    COM_MSG_HEADER* in_msg = (COM_MSG_HEADER *)pBuf;
    if(in_msg->maincmd == MDM_Vchat_Login)
    {
        [self loginAuthInfo:in_msg];
    }
    else if(in_msg->maincmd == MDM_Vchat_Room)
    {
        [self authRoomInfo:in_msg];
    }
    else
    {
        DLog(@"%d-%d",in_msg->maincmd,in_msg->subcmd);
    }
    return 0;
}

- (void)sendHello:(int)nMDM_Vchat
{
    char szTemp[32]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER *)szTemp;
    pHead->length = sizeof(COM_MSG_HEADER) + sizeof(CMDClientHello_t);
    pHead->checkcode = 0;
    pHead->version = MDM_Version_Value;
    pHead->maincmd = nMDM_Vchat;
    pHead->subcmd = Sub_Vchat_ClientHello;
    CMDClientHello_t* pHollo = (CMDClientHello_t *)pHead->content;
    pHollo->param1 = 12;
    pHollo->param2 = 8;
    pHollo->param3 = 7;
    pHollo->param4 = 1;
    
    NSData *data = [NSData dataWithBytes:szTemp length:pHead->length];
    [_asyncSocket writeData:data withTimeout:20 tag:1];
}

- (void)sendMsg_login
{
    CMDUserLogonReq3_t req;
    memset(&req, 0, sizeof(CMDUserLogonReq3_t));
    req.userid = _strUser ? [_strUser intValue] : 0;//如果为0  则是游客登录
    req.nversion = 4000000;
    [UserInfo sharedUserInfo].nUserId = (int)req.userid;
    req.nmask = (int)time(0);
    if(req.userid != 0)
    {
        NSString *strMd5 = [DecodeJson XCmdMd5String:_strPwd];
        [UserInfo sharedUserInfo].strPwd = _strPwd;
        [UserInfo sharedUserInfo].strMd5Pwd = strMd5;
        strcpy(req.cuserpwd,[strMd5 UTF8String]);
    }
    
    strcpy(req.cMacAddr,[[DecodeJson macaddress] UTF8String]);
    strcpy(req.cIpAddr, [[DecodeJson getIPAddress] UTF8String]);
    req.nimstate = 0;
    req.nmobile = 1;
    [self sendMessage:(char*)&req size:sizeof(CMDUserLogonReq3_t) version:MDM_Version_Value
              maincmd:MDM_Vchat_Login subcmd:Sub_Vchat_logonReq3];
}

- (void)loginServer:(NSString *)strUser pwd:(NSString *)strPwd
{
    NSString *strTempAddr = [UserInfo sharedUserInfo].strWebAddr;
    NSString *strAddr = SVR_LOGIN_IP;
    int nPort = SVR_LOGIN_PORT;
    [self connectLogInServer:strAddr port:nPort];
    if ([strUser isEqualToString:@"0"])
    {
        [UserInfo sharedUserInfo].nType = 2;
    }
    else
    {
        [UserInfo sharedUserInfo].nType = 1;
    }
    _strUser = strUser;
    _strPwd = strPwd;
}

- (void)loginAuthInfo:(COM_MSG_HEADER *)in_msg
{
    int nMsgLen=in_msg->length-sizeof(COM_MSG_HEADER);
    char* pNewMsg=0;
    if(nMsgLen>0)
    {
        pNewMsg= (char*) malloc(nMsgLen);
        memcpy(pNewMsg,in_msg->content,nMsgLen);
    }
    switch(in_msg->subcmd)
    {
        case Sub_Vchat_logonSuccess:
        {
            DLog(@"登录成功");
            [self loginSucess:pNewMsg];
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_SUCESS_VC object:@"登录成功"];
        }
            break;
        case Sub_Vchat_logonErr:
        {
            [self loginError:pNewMsg];
        }
        break;
        case Sub_Vchat_logonFinished:
        {
            DLog(@"登录过程结束!");
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_SUCESS_VC object:@"登录成功"];
            [self closeSocket];
            return;
        }
        break;
        case Sub_Vchat_RoomGroupListBegin:
        {
            DLog(@"房间组数据开始!");
        }
        break;
        default:
        {
            DLog(@"other");
        }
        break;
    }
    free(pNewMsg);
    [_asyncSocket readDataToLength:sizeof(int) withTimeout:-1 tag:SOCKET_READ_LENGTH];
}

- (void)loginSucess:(char *)pData
{
    CMDUserLogonSuccess_t* pLogonResp=(CMDUserLogonSuccess_t*)pData;
    UserInfo *user = [UserInfo sharedUserInfo];
    //    _GlobalSetting.m_pKernelData->m_nServerVersion=pLogonResp->version;
    //    _GlobalSetting.m_pKernelData->m_nServerTime=pLogonResp->servertime;
    //    _GlobalSetting.m_pKernelData->m_nNowClientTime=time(0);
    //    pLocalUser->m_nk= pLogonResp->nk;
    //    pLocalUser->m_nb= pLogonResp->nb;
    //    pLocalUser->m_nd= pLogonResp->nd;
    //    pLocalUser->m_nkdeposit = 0;
    //    pLocalUser->m_nUserId =pLogonResp->userid;
    //    pLocalUser->m_nUserType=USERTYPE_NORMALUSER;
    //    pLocalUser->m_nLangId= pLogonResp->langid;
    //    pLocalUser->m_nLangIdExpTime=pLogonResp->langidexptime;
    //    pLocalUser->m_nHeadId=pLogonResp->headid;
    user.m_nVipLevel=pLogonResp->viplevel;
    user.goldCoin = pLogonResp->nk;
    user.score = pLogonResp->nb;
    user.sex = pLogonResp->ngender;
    //    pLocalUser->m_nYiyuanLevel=pLogonResp->yiyuanlevel;
    //    pLocalUser->m_nShoufuLevel=pLogonResp->shoufulevel;
    //    pLocalUser->m_nZhongshenLevel=pLogonResp->zhonglevel;
    //    pLocalUser->m_nCaifuLevel =pLogonResp->caifulevel;
    //    pLocalUser->m_nlastmonthcostlevel=pLogonResp->lastmonthcostlevel;
    //    pLocalUser->m_nthismonthcostlevel=pLogonResp->thismonthcostlevel;
    //    pLocalUser->m_thismonthcostgrade=pLogonResp->thismonthcostgrade;
    //    pLocalUser->m_nGender=pLogonResp->ngender;
    //    pLocalUser->m_bLangIdExp=pLogonResp->blangidexp;
    //    pLocalUser->m_nXiaoShou=pLogonResp->bxiaoshou;
    //    pLocalUser->m_strUserAlias=pLogonResp->cuseralias;
    user.nUserId = pLogonResp->userid;
    
    user.strName = [NSString stringWithCString:pLogonResp->cuseralias encoding:GBK_ENCODING];
    if (_strUser || [_strUser isEqualToString:@"0"])
    {
        [UserInfo sharedUserInfo].bIsLogin = YES;
    }
    else
    {
        user.nUserId = [_strUser intValue];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
}

- (void)loginError:(char *)pError
{
    CMDUserLogonErr_t* pErr = (CMDUserLogonErr_t *)pError;
    DLog(@"登录失败--pErr:%u",pErr->errid);
    NSString *strMsg = nil;
    if (pErr->errid == 103)
    {
        strMsg = @"没有此用户";
    }
    else if(pErr->errid == 101)
    {
        strMsg = @"你被限制进入,登录失败!请联系在线客服.";
    }
    else
    {
        strMsg = @"密码错误";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_ERROR_VC object:strMsg];
}

#pragma mark 加入房间

- (void)thread_room
{
    int nTimes = 0;
    while (_asyncSocket)
    {
        if (nTimes%29==28)
        {
            [self sendRoomPing];
            nTimes = 0;
        }
        nTimes++;
        [NSThread sleepForTimeInterval:1.0];
    }
}

- (void)sendRoomPing
{
    CMDClientPing_t req;
    memset(&req,0,sizeof(CMDClientPing_t));
    req.userid = [_strUser intValue];
    req.roomid = [_strRoomId intValue];
    char szBuf[128]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER*)szBuf;
    pHead->length = sizeof(COM_MSG_HEADER) + sizeof(CMDClientPing_t);
    pHead->checkcode =0;
    pHead->version = MDM_Version_Value;
    pHead->maincmd = MDM_Vchat_Room;
    pHead->subcmd = Sub_Vchat_ClientPing;
    memcpy(pHead->content,&req,sizeof(CMDClientPing_t));
    NSData *data = [NSData dataWithBytes:szBuf length:pHead->length];
    [_asyncSocket writeData:data withTimeout:20 tag:2];
}

- (void)reConnectRoomInfo
{
    [self connectRoomInfo:_strRoomId address:_strRoomAddress port:_nRoomPort];
}

- (BOOL)connectRoomAndPwd:(NSString *)strPwd
{
    _strRoomPwd = strPwd;
    [_asyncSocket readDataToLength:sizeof(int) withTimeout:-1 tag:SOCKET_READ_LENGTH];
    [self joinRoomInfo];
    return YES;
}

- (BOOL)reConnectRoomTime:(NSString *)strId address:(NSString *)strIp port:(int)nPort
{
    nSocketType = 2;
    if (tcpThread==nil)
    {
        tcpThread = dispatch_queue_create("socket",0);
    }
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:tcpThread];
    if(![_asyncSocket connectToHost:strIp onPort:nPort error:nil])
    {
        DLog(@"连接失败");
    }
    _strRoomAddress = strIp;
    _strRoomId = strId;
    _nRoomPort = nPort;
    return YES;
}

- (BOOL)connectRoomInfo:(NSString *)strId address:(NSString *)strIp port:(int)nPort
{
    _nFall = 0;
    [self reConnectRoomTime:strId address:strIp port:nPort];
    return YES;
}

- (BOOL)joinRoomInfo
{
    if (_aryNotice==nil)
    {
        _aryNotice = [NSMutableArray array];
    }
    if (_aryBuffer == nil)
    {
        _aryBuffer = [NSMutableArray array];
    }
    [_aryNotice removeAllObjects];
    [_aryBuffer removeAllObjects];
    if (_aryChat == nil)
    {
        _aryChat = [NSMutableArray array];
    }
    [_aryChat removeAllObjects];
    CMDJoinRoomReq_t req;
    memset(&req,0,sizeof(CMDJoinRoomReq_t));
    req.userid = [UserInfo sharedUserInfo].nUserId;
    req.vcbid = (uint32)[_strRoomId intValue];
    req.coremessagever = _PRODUCT_CORE_MESSAGE_VER_;
    req.devtype = 2;
    if (_strRoomPwd)
    {
        sprintf(req.croompwd,"%s",[_strRoomPwd UTF8String]);
    }
    if(req.userid!=0 && [UserInfo sharedUserInfo].nType == 1)
    {
        strcpy(req.cuserpwd, [[UserInfo sharedUserInfo].strMd5Pwd UTF8String]);
    }
    strcpy(req.cMacAddr,[[DecodeJson macaddress] UTF8String]);
    req.time = (uint32)time(0);
    req.crc32 = 15;
    uint32 crcval = crc32((void*)&req,sizeof(CMDJoinRoomReq_t),CRC_MAGIC);
    req.crc32 = crcval;
    [self sendMessage:(char *)&req size:sizeof(CMDJoinRoomReq_t) version:MDM_Version_Value maincmd:MDM_Vchat_Room
               subcmd:Sub_Vchat_JoinRoomReq];
    return YES;
}

#pragma mark 验证所有ROOM消息
- (void)authRoomInfo:(COM_MSG_HEADER *)in_msg
{
    int nMsgLen=in_msg->length-sizeof(COM_MSG_HEADER);
    char* pNewMsg=0;
    if(nMsgLen>0)
    {
        pNewMsg= (char*) malloc(nMsgLen);
        memcpy(pNewMsg,in_msg->content,nMsgLen);
    }
    else
    {
        if (in_msg->subcmd == Sub_Vchat_RoomUserListFinished)
        {
            DLog(@"房间用户数据结束");
//            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
            [_asyncSocket readDataToLength:sizeof(int32) withTimeout:-1 tag:SOCKET_READ_LENGTH];
            return ;
        }
        DLog(@"错误消息:%d",in_msg->subcmd);
        [_asyncSocket readDataToLength:sizeof(int32) withTimeout:-1 tag:SOCKET_READ_LENGTH];
        return ;
    }
    switch (in_msg->subcmd)
    {
        case Sub_Vchat_JoinRoomErr:
        {
            [self joinRoomError:pNewMsg];
            return ;
        }
            break;
        case Sub_Vchat_JoinRoomResp:
        {
            DLog(@"加入房间成功");
            [self joinRoomSuccess:pNewMsg];
        }
        break;
        case Sub_Vchat_RoomUserListBegin:
        {
            DLog(@"房间用户列表开始!");
        }
        break;
        case Sub_Vchat_RoomUserListResp:
        {
            DLog(@"房间用户列表数据!");
            [self addRoomUser:pNewMsg];
        }
            break;
        case Sub_Vchat_RoomUserNoty:
        {
            DLog(@"新增用户通知!");
            CMDRoomUserInfo_t *pItem = (CMDRoomUserInfo_t *)pNewMsg;
            [self addUserStruct:pItem];
            NSString *strInfo = [NSString stringWithFormat:@"<span style=\"TEXT-DECORATION: none;FONT-FAMILY:黑体;font-size=14px;\">系统消息: <a style=\"TEXT-DECORATION:font-size:14px; none;color:#629bff \" href=\"sqchatid://%d\">%@</a> 进入了房间</span>",
                                 pItem->userid,[NSString stringWithCString:pItem->useralias encoding:GBK_ENCODING]];
            if ([UserInfo sharedUserInfo].m_nVipLevel >=21 && [UserInfo sharedUserInfo].m_nVipLevel <=36)
            {
                [_aryChat addObject:strInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
        }
            break;
        case Sub_Vchat_RoomPubMicState:
        {
            DLog(@"公麦状态数据!");
            
        }
            break;
        case Sub_Vchat_RoomUserExitResp:
        {
            // not do anything...
        }
            break;
        case Sub_Vchat_RoomUserExitNoty:
        {
            DLog(@"房间用户退出通知!");
            CMDUserExitRoomInfo_t* pInfo = (CMDUserExitRoomInfo_t *)pNewMsg;
            NSString *strName = nil;
            if (_rInfo)
            {
                RoomUser *user = [_rInfo findUser:pInfo->userid];
                strName = user.m_strUserAlias;
                [_rInfo.aryUser removeObject:user];
                [_rInfo removeUser:pInfo->userid];
            }
            DLog(@"userid:%d",pInfo->userid);
            NSString *strInfo = [NSString stringWithFormat:@"<span style=\"TEXT-DECORATION: none;font-size=14px;\">\
                                 系统消息:<span style=\"TEXT-DECORATION:font-size:14px; none;color:#629bff \">%@</span>退出了房间</span>",strName];
            if ([UserInfo sharedUserInfo].m_nVipLevel >=21 && [UserInfo sharedUserInfo].m_nVipLevel <=36)
            {
                [_aryChat addObject:strInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
            
            strInfo = nil;
        }
            break;
        case Sub_Vchat_RoomKickoutUserResp:
        {
            // not do anything
        }
            break;
        case Sub_Vchat_RoomKickoutUserNoty:
        {
            DLog(@"房间用户踢出通知!");
            CMDUserKickoutRoomInfo_t* pInfo = (CMDUserKickoutRoomInfo_t *)pNewMsg;
            if (_rInfo)
            {
                RoomUser *user = [_rInfo findUser:pInfo->toid];
                
                [_rInfo.aryUser removeObject:user];
                
                [_rInfo removeUser:pInfo->toid];
            }
            //522:超时   107:同号登录
            DLog(@"被人踢出:%d--:resonid:%d",pInfo->toid,pInfo->resonid);
            if(pInfo->toid == [_strUser intValue])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_KICKOUT_VC object:nil];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
            }
        }
            break;
        case Sub_Vchat_FlyGiftListInfo:
        {
            DLog(@"大礼物信息!");
            
        }
            break;
        case Sub_Vchat_WaitiMicListInfo:
        {
            DLog(@"排麦列表!");
        }
            break;
        case Sub_Vchat_ChatErr:
        {
            DLog(@"not do anything...");
        }
            break;
        case Sub_Vchat_ChatNotify:
        {
            DLog(@"聊天通知数据!");
            [self chatMessageOper:pNewMsg];
        }
            break;
        case Sub_Vchat_TradeGiftResp:
        {
            DLog(@"赠送礼物返回响应消息!");
        }
            break;
        case Sub_Vchat_TradeGiftErr:
        {
            DLog(@"赠送礼物返回错误消息!");
        }
            break;
        case Sub_Vchat_TradeGiftNotify:
        {
            DLog(@"赠送礼物通知数据!");
        }
            break;
        case Sub_Vchat_TradeFlowerResp:
        {
            DLog(@"赠送鲜花返回响应消息!");
        }
            break;
        case Sub_Vchat_TradeFlowerErr:
        {
            DLog(@"赠送鲜花返回错误消息!");
        }
            break;
        case Sub_Vchat_TradeFlowerNotify:
        {
            DLog(@"赠送鲜花通知数据!");
        }
            break;
        case Sub_Vchat_TradeFireworksResp:
        {
            DLog(@"赠送烟花返回响应消息!");
        }
            break;
        case Sub_Vchat_TradeFireworksNotify:
        {
            DLog(@"赠送烟花通知数据!");
        }
            break;
        case Sub_Vchat_TradeFireworksErr:
        {
            DLog(@"赠送烟花返回错误消息!");
            
        }
            break;
        case Sub_Vchat_LotteryGiftNotify:
        {
            DLog(@"礼物中奖通知数据!");
            
        }
            break;
        case Sub_Vchat_BoomGiftNotify:
        {
            DLog(@"爆炸中奖通知数据!");
        }
            break;
        case Sub_Vchat_SysNoticeInfo:
        {
            DLog(@"系统消息通知数据!");
            
        }
            break;
        case Sub_Vchat_UserAccountInfo:
        {
            DLog(@"用户帐户数据!");
        }
            break;
        case Sub_Vchat_RoomManagerNotify:
        {
            DLog(@"房间管理通知数据!");
        }
            break;
        case Sub_Vchat_RoomMediaNotify:
        {
            DLog(@"房间媒体数据通知!");
        }
            break;
        case Sub_Vchat_RoomNoticeNotify:
        {
            DLog(@"房间公告数据通知!");
            CMDRoomNotice_t* pInfo = (CMDRoomNotice_t *)pNewMsg;
            if (pInfo->index==2)
            {
                char szTemp[4096]={0};
                memcpy(szTemp, pInfo->content, pInfo->textlen);
                szTemp[pInfo->textlen]='\0';
                NSString *strInfo = [NSString stringWithCString:szTemp encoding:GBK_ENCODING];
                NoticeModel *notice = [[NoticeModel alloc] init];
                notice.strContent = strInfo;
                notice.strType = @"<span coloc=\"red\">[房间公告]";
                NSDate *date = [NSDate date];
                NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                notice.strTime = [fmt stringFromDate:date];
                [_aryBuffer addObject:notice];
                __weak LSTcpSocket *__self = self;
                dispatch_async(downGCD,
                ^{
                    [__self downloadCache];
                });
            }
        }
        break;
        case Sub_Vchat_RoomOPStatusNotify:
        {
            DLog(@"房间状态数据通知!");
        }
            break;
        case Sub_Vchat_RoomInfoNotify:
        {
            DLog(@"房间信息数据通知!");
        }
            break;
        case Sub_Vchat_ThrowUserNotify:
        {
            DLog(@"房间封杀用户通知!");
            
        }
            break;
        case Sub_Vchat_UpWaitMicResp:
        {
            DLog(@"上排麦响应!");
            
        }
            break;
        case Sub_Vchat_UpWaitMicErr:
        {
            DLog(@"上排麦错误!\n");
            
        }
            break;
        case Sub_Vchat_ChangePubMicStateNotify:
        {
            DLog(@"公麦状态通知!\n");
        }
            break;
        case Sub_Vchat_TransMediaReq:
        {
            //            DLog(@"传输媒体请求!\n");
        }
            break;
        case Sub_Vchat_TransMediaResp:
        {
            DLog(@"传输媒体响应!\n");
            
        }
            break;
        case Sub_Vchat_TransMediaErr:
        {
            DLog(@"传输媒体错误!\n");
        }
            break;
        case Sub_Vchat_SetMicStateResp:
        {
            DLog(@"设置麦状态响应!\n");
        }
            break;
        case Sub_Vchat_SetMicStateErr:
        {
            DLog(@"设置麦状态错误!\n");
        }
            break;
        case Sub_Vchat_SetMicStateNotify:
        {
            DLog(@"设置麦状态通知!\n");
            CMDUserMicState_t *pInfo = (CMDUserMicState_t*)pNewMsg;
            RoomUser *roomUser = [_rInfo.dictUser objectForKey:NSStringFromInt(pInfo->toid)];
            roomUser.m_nInRoomState = pInfo->micstate;
            for (int i=0; i<_rInfo.aryUser.count;i++)
            {
                RoomUser *rUser = [_rInfo.aryUser objectAtIndex:i];
                if (![rUser isManager])
                {
                    break;
                }
                if (rUser.m_nUserId == pInfo->toid)
                {
                    rUser.m_nInRoomState = pInfo->micstate;
                    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
                    break;
                }
            }
            if (pInfo->micstate == 0)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_MIC_CLOSE_VC object:nil];
            }
            else
            {
                DLog(@"有人上M了,pInfo->toid:%d",pInfo->toid);
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_MIC_UPDATE_VC object:nil];
            }
        }
        break;
        case Sub_Vchat_SetUserAliasNotify:
        {
            CMDUserAliasState_t *pInfo = (CMDUserAliasState_t *)pNewMsg;
            RoomUser *roomUser = [_rInfo.dictUser objectForKey:NSStringFromInt(pInfo->userid)];
            roomUser.m_strUserAlias = [[NSString alloc]  initWithCString:pInfo->alias encoding:GBK_ENCODING];
            for (int i=0; i<_rInfo.aryUser.count;i++)
            {
                RoomUser *rUser = [_rInfo.aryUser objectAtIndex:i];
                if (![rUser isManager])
                {
                    break;
                }
                if (rUser.m_nUserId == pInfo->userid)
                {
                    rUser.m_strUserAlias = [[NSString alloc]  initWithCString:pInfo->alias encoding:GBK_ENCODING];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
                    break;
                }
            }
        }
        break;
        case Sub_Vchat_CloseRoomNotify:
        {
            DLog(@"房间被关闭消息,直接退出当前房间!\n");
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_BE_CLOSE_VC object:nil];
        }
        break;
        default:
        {
            DLog(@"消息类型:%d",in_msg->subcmd);
        }
            break;
    }
    free(pNewMsg);
    [_asyncSocket readDataToLength:4 withTimeout:-1 tag:SOCKET_READ_LENGTH];
}

- (NSString *)getToUser:(int)userId user:(RoomUser*)pUser name:(NSString *)strName
{
    if(userId == 0)
    {
        return @"";
    }
    if(userId == [_strUser intValue])
    {
        return [NSString stringWithFormat:@"<span value=\"forme--%d\">你</span>",userId];
    }
    else
    {
        if (strName)
        {
            return [NSString stringWithFormat:@"<a style=\"TEXT-DECORATION: none;font-size:13px;COLOR: #629bff \" \
                    href=\"sqchatid://%d\" value=\"%@\">%@</a>",
                    userId,strName,strName];
        }
        else
        {
            return [NSString stringWithFormat:@"<a style=\"TEXT-DECORATION: none;font-size:13px;COLOR: #629bff \" href=\"sqchatid://%d\">%d</a>(%d)",
                    userId, userId, userId];
        }
    }
}

#pragma mark 聊天信息处理
- (void)chatMessageOper:(char *)pNewMsg
{
    CMDRoomChatMsg_t *msg = (CMDRoomChatMsg_t*)pNewMsg;
    NSString *strContent = [NSString stringWithCString:msg->content encoding:GBK_ENCODING];
    NSString *strSrcName = [NSString stringWithCString:msg->srcalias encoding:GBK_ENCODING];
    NSString *strFrom = [self getToUser:msg->srcid user:[_rInfo findUser:msg->srcid] name:strSrcName];
    if (msg->msgtype==1 || msg->msgtype==15)
    {
        NSString *strInfo=nil;
        NoticeModel *notice = [[NoticeModel alloc] init];
        if (msg->msgtype==1)
        {
            strInfo = [DecodeJson replaceEmojiString:strContent];
            notice.strContent = strInfo;
            notice.strType = [[NSString alloc] initWithFormat:@"房间广播-%@",strFrom];
        }
        else
        {
            strInfo = [NSString stringWithFormat:@"%@ &nbsp;&nbsp;%@",strFrom,strContent];
            notice.strContent = strInfo;
            notice.strType = @"悄悄话";
        }
        NSDate *date = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        notice.strTime = [fmt stringFromDate:date];
        
        [_aryBuffer addObject:notice];
        __weak LSTcpSocket *__self = self;
        dispatch_async(downGCD,
        ^{
            [__self downloadCache];
        });
    }
    else
    {
        NSString *strToName = [NSString stringWithCString:msg->toalias encoding:GBK_ENCODING];
        NSString *strTo = [self getToUser:msg->toid user:[_rInfo findUser:msg->toid] name:strToName];
        NSString *strInfo = [NSString stringWithFormat:@"  %@<span style=\"color:#919191\">对 %@ 说 :</span>&nbsp;&nbsp;%@",strFrom,strTo,strContent];
        strInfo = [DecodeJson replaceEmojiString:strInfo];
        [_aryChat addObject:strInfo];
        if (_aryChat.count>=100)
        {
            @synchronized(_aryChat)
            {
                for (int i=0; i<50; i++)
                {
                    [_aryChat removeObjectAtIndex:i];
                }
            }
        }
        strTo = nil;
        strFrom = nil;
        NSString *query = [NSString stringWithFormat:@"value=\"forme--%d\"",[_strUser intValue]];
        //查询是否有对我说的记录
        if ([strTo rangeOfString:query].location != NSNotFound || [strFrom rangeOfString:query].location != NSNotFound )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_TO_ME_VC object:nil];
        }
        query = nil;
        strInfo = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
    }
}

#pragma mark 房间用户信息添加
- (void)sendGift:(int)userId
{
    
}

- (void)sendColletRoom:(int)nCollet
{
    CMDFavoriteRoomReq_t req;
    req.actionid = nCollet ? 1 : -1;
    req.userid =[_strUser intValue];
    req.vcbid = [_strRoomId intValue];
    
    char szBuf[128]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER*)szBuf;
    pHead->length = sizeof(COM_MSG_HEADER) + sizeof(CMDFavoriteRoomReq_t);
    pHead->checkcode =0;
    pHead->version = MDM_Version_Value;
    pHead->maincmd = MDM_Vchat_Room;
    pHead->subcmd = Sub_Vchat_FavoriteVcbReq;
    memcpy(pHead->content,&req,sizeof(CMDFavoriteRoomReq_t));
    NSData *data = [NSData dataWithBytes:szBuf length:pHead->length];
    [_asyncSocket writeData:data withTimeout:-1 tag:1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
}

- (void)addUserStruct:(CMDRoomUserInfo_t*)pItem
{
    RoomUser *pUser = nil;
    assert(pItem->vcbid == _rInfo.m_nRoomId);
    pUser = [_rInfo findUser:pItem->userid];
    if (pUser==nil)
    {
        pUser = [[RoomUser alloc] init];
    }
    else
    {
        return ;
    }
    pUser.m_nUserId = pItem->userid;
    pUser.m_nHeadId  = pItem->headicon;
    pUser.m_nVipLevel = pItem->viplevel;
//    pUser.m_nYiyuanLevel = pItem->yiyuanlevel;
//    pUser.m_nShoufuLevel = pItem->shoufulevel;
//    pUser.m_nZhongshenLevel = pItem->zhonglevel;
//    pUser.m_nCaifuLevel = pItem->caifulevel;
//    pUser.m_nlastmonthcostlevel = pItem->lastmonthcostlevel;
//    pUser.m_nthismonthcostlevel = pItem->thismonthcostlevel;
//    pUser.m_thismonthcostgrade = pItem->thismonthcostgrade;
    pUser.m_nGender = pItem->gender;
//    pUser.m_nPubMicIndex = pItem->pubmicindex;
//    pUser.m_nSealId = pItem->sealid;
//    pUser.m_nComeTime = pItem->cometime;
//    pUser.m_nSealExpTime = pItem->sealexpiretime;
    pUser.m_nInRoomState = pItem->userstate;
//    pUser.m_nStarFlag = pItem->starflag;
//    pUser.m_nActivityStarFlag = pItem->activityflag;
//    pUser.m_nFlowerNum = pItem->flowernum;
//    pUser.m_nYuanpiaoNum = pItem->ticket1num;
    pUser.m_strUserAlias = [NSString stringWithCString:pItem->useralias encoding:GBK_ENCODING];
//    pUser.m_nXiaoShou = pItem->isxiaoshou;
    pUser.m_nRoomLevel = pItem->roomlevel;
//    pUser.m_bForbidInviteUpMic = (bool)pItem->bforbidinviteupmic;
//    pUser.m_bForbidChat = (bool)pItem->bforbidchat;
    pUser.m_nUserType = pItem->usertype;
//    pUser.m_ncarid = pItem->ncarid;
//    pUser.m_strCarname= [NSString stringWithCString:pItem->carname encoding:GBK_ENCODING];
//    pUser.m_nMICgiftId =pItem->micgiftid;
//    pUser.m_nMICgiftNum =pItem->micgiftnum;
    
#ifdef __SWITCH_SERVER2__
    pUser->m_nb =pItem->nb;
    pUser->cemail =pItem->cemail;
    pUser->cqq =pItem->cqq;
    pUser->ctel =pItem->ctel;
#endif
    
    //判断城主，服务器已经不判断了
    if(pUser.m_nUserId == [_rInfo siegeInfo]->srcid)
        pUser.m_nInRoomState |= FT_ROOMUSER_STATUS_IS_SIEGE1;
    else if(pUser.m_nUserId == [_rInfo siegeInfo]->toid)
        pUser.m_nInRoomState |= FT_ROOMUSER_STATUS_IS_SIEGE2;
    
    pUser.m_pInRoom = _rInfo;
    //    if(pUser.m_nUserId != [_strUser intValue])
    //    {
    
    if (pUser) {
        [_rInfo addUser:pUser];
        [_rInfo insertRUser:pUser];
    }
    //    }
    if([pUser isHide])
    {
        DLog(@"发现隐身用户[%d]进入房间[%@].",[UserInfo sharedUserInfo].nUserId,_strRoomId);
    }
    if(pUser.m_nInRoomState & FT_ROOMUSER_STATUS_IS_SIEGE1)
    {
        DLog(@"发现【城主】用户[%d]进入房间[%d].", pUser.m_nUserId, _rInfo.m_nRoomId);
    }
    if(pUser.m_nInRoomState & FT_ROOMUSER_STATUS_IS_SIEGE2)
    {
        DLog(@"发现【城后】用户[%d]进入房间[%d].", pUser.m_nUserId, _rInfo.m_nRoomId);
    }
    if(pUser.m_nUserId == [UserInfo sharedUserInfo].nUserId)
    {
        DLog(@"发现自己[%d] 进入房间!",pUser.m_nUserId);
    }
}

- (void)addRoomUser:(char *)pData
{
    int ncount = *(int *)pData;
    CMDRoomUserInfo_t* pItem = (CMDRoomUserInfo_t*)(pData+sizeof(int));
    DLog(@"count:%d",ncount);
    for(int i=0; i<ncount; i++)
    {
        [self addUserStruct:pItem];
        pItem++;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
}

- (void)joinRoomSuccess:(char *)pData
{
    if (_dictDownLoad==nil)
    {
        _dictDownLoad = [NSMutableDictionary dictionary];
    }
    CMDJoinRoomResp_t* pResp=(CMDJoinRoomResp_t*)pData;
    DLog(@"房间ID:%d",pResp->vcbid);
    if (_rInfo)
    {
        _rInfo = nil;
    }
    _rInfo = [[RoomInfo alloc] initWithRoom:pResp];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
    [_aryChat addObject:@"[系统消息]正在加载房间数据..."];
    [_aryChat addObject:@"[系统消息]登录房间成功!"];
    __weak LSTcpSocket *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
       [__self thread_room];//发送心跳
    });
}

- (void)joinRoomError:(char *)pData
{
    CMDJoinRoomErr_t *pResp = (CMDJoinRoomErr_t *)pData;
    DLog(@"加入错误:%d",pResp->errid);
    NSString *strMsg = nil;
    switch (pResp->errid)
    {
        case 201:
        {
            strMsg = @"需要输入密码";
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_ERR_VC object:strMsg];
            return ;
        }
            break;
        case 101:
        {
            strMsg = @"房间黑名单";
        }
            break;
        case 203:
        {
            strMsg = @"用户名/密码查询错误，无法加入房间!";
        }
            break;
        case 404:
        {
            strMsg = @"加入房间 不存在";
        }
            break;
        case 405:
        {
            strMsg = @"房间已经被房主关闭，不能进入";
        }
            break;
        case 502:
        {
            strMsg = @"房间人数已满";
        }
            break;
        case 505:
        {
            strMsg = @"通信版本过低，不能使用，请升级";
        }
            break;
        default:
        {
            strMsg = @"未知错误";
        }
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_ERR_VC object:strMsg];
    [self closeSocket];
}

- (void)exit_Room:(BOOL)bClose
{
    [self exit_Room];
    if (bClose)
    {
        _strRoomPwd = nil;
        _strRoomId = nil;
        _nMId = 0;
        [self closeSocket];
    }
}

- (void)exit_Room
{
    CMDUserExitRoomInfo_t req;
    memset(&req,0,sizeof(CMDUserExitRoomInfo_t));
    req.userid = [UserInfo sharedUserInfo].nUserId;
    req.vcbid = [_strRoomId intValue];
    [self sendMessage:(char*)&req size:sizeof(CMDUserExitRoomInfo_t) version:MDM_Version_Value maincmd:MDM_Vchat_Room
               subcmd:Sub_Vchat_RoomUserExitReq];
}

- (void)sendChatInfo:(NSString *)strInfo toid:(int)userId
{
    NSString *strMsg = [NSString stringWithFormat:@"<SPAN style=\"font-famlily:黑体;COLOR:#000000;FONT-SIZE:16px\">%@</SPAN>",
                        strInfo];
    NSData *data = [strMsg dataUsingEncoding:GBK_ENCODING];
    DLog(@"strInfo:%@",strInfo);
    char szBuf[2048]={0};
    CMDRoomChatMsg_t* pReq = (CMDRoomChatMsg_t *)szBuf;
    pReq->vcbid       = [_strRoomId intValue];
    pReq->srcid       = [_strUser intValue];
    pReq->toid = userId;
    pReq->tocbid = [_strRoomId intValue];
    pReq->srcviplevel = [UserInfo sharedUserInfo].m_nVipLevel;
    pReq->msgtype     = 0;
    pReq->textlen     = data.length+1;
    
    strcpy(pReq->vcbname,[_rInfo getRoomName]);
    
    memcpy(pReq->content, [data bytes], [data length]);
    
    RoomUser *fromUser= [_rInfo findUser:[_strUser intValue]];
    
    memcpy(pReq->srcalias,[[fromUser.m_strUserAlias dataUsingEncoding:GBK_ENCODING] bytes],
           [[fromUser.m_strUserAlias dataUsingEncoding:GBK_ENCODING] length]);
    if (userId!=0)
    {
        RoomUser *toUser = [_rInfo findUser:userId];
        memcpy(pReq->toalias,[[toUser.m_strUserAlias dataUsingEncoding:GBK_ENCODING] bytes],
               [[toUser.m_strUserAlias dataUsingEncoding:GBK_ENCODING] length]);
    }
    [self sendLocalChat:strMsg to:pReq->toid];
    
    pReq->content[pReq->textlen -1] = '\0';
    
    [self sendChat:pReq];
}

//推送自己发送的信息到界面
- (void)sendLocalChat:(NSString *)strMsg to:(int)nUser
{
    NSString *strChat = [DecodeJson replaceEmojiString:strMsg];
    strChat = [DecodeJson replaceImageString:strChat];
    NSString *strFrom = [NSString stringWithFormat:@"<span style=\"TEXT-DECORATION: none;font-size:13px;COLOR: #629bff\" value=\"forme--%d\">你</span>",
                         [UserInfo sharedUserInfo].nUserId];
    if (nUser!=0)
    {
        RoomUser *user = [_rInfo findUser:nUser];
        NSString *strTo = [self getToUser:nUser user:user name:user.m_strUserAlias];
        NSString *strInfo = [NSString stringWithFormat:@"%@ <span style=\"color:#919191\">对 %@ 说:</span>%@",strFrom,strTo,strChat];
        [_aryChat addObject:strInfo];
    }
    else
    {
        NSString *strInfo = [NSString stringWithFormat:@"%@ <span style=\"color:#919191\"> 说:</span>%@",strFrom,strChat];
        [_aryChat addObject:strInfo];
    }
    if (_aryChat.count>=50)
    {
        @synchronized(_aryChat)
        {
            for (int i=0; i<25; i++)
            {
                [_aryChat removeObjectAtIndex:0];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_TO_ME_VC object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
}

- (void)sendChat:(CMDRoomChatMsg_t*)pReq
{
    char szBuf[4096]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER *)szBuf;
    pHead->length = sizeof(COM_MSG_HEADER) + sizeof(CMDRoomChatMsg_t) + pReq->textlen;
    pHead->checkcode = 0;
    pHead->version = MDM_Version_Value;
    pHead->maincmd = MDM_Vchat_Room;
    pHead->subcmd = Sub_Vchat_ChatReq;
    memcpy(pHead->content, pReq, sizeof(CMDRoomChatMsg_t) + pReq->textlen);
    NSData *data = [NSData dataWithBytes:szBuf length:pHead->length];
    [_asyncSocket writeData:data withTimeout:20 tag:4];
}

#pragma mark delegate

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    _nFall = 0;
    DLog(@"connect server sucess!");
    if (downGCD==nil)
    {
        downGCD = dispatch_queue_create("downgcd",0);
    }
    
    if (nSocketType == 1)
    {
        //登录服务器信息
        [self sendHello:MDM_Vchat_Login];
        [self sendMsg_login];
    }
    else if(nSocketType == 2)
    {
        //房间连接消息
        [self sendHello:MDM_Vchat_Room];
        [self joinRoomInfo];
    }
    [_asyncSocket readDataToLength:sizeof(int) withTimeout:-1 tag:SOCKET_READ_LENGTH];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    switch(tag)
    {
        case SOCKET_READ_LENGTH:
        {
            memset(cBuf, 0,16384);
            char *p = (char *)[data bytes];
            int32 nSize = *((int32 *)p);
            memcpy(cBuf, [data bytes], sizeof(int32));
            if(nSize == 0)
            {
                [_asyncSocket readDataToLength:sizeof(int32) withTimeout:-1 tag:SOCKET_READ_LENGTH];
            }
            else
            {
                [_asyncSocket readDataToLength:nSize-sizeof(int32) withTimeout:-1 tag:SOCKET_READ_DATA];
            }
        }
            break;
        case SOCKET_READ_DATA:
        {
            char *p = cBuf;
            int32 nSize = *((int32 *)p);
            if(nSize==0)
            {
                DLog(@"nSize=%d!",nSize);
            }
            memcpy(p+sizeof(int32), [data bytes], data.length);
            [self getSocketHead:cBuf len:(int32)(data.length+sizeof(int32))];
        }
            break;
        default:
            break;
    }
}


-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err)
    {
        if ([[err.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"Connection refused"])
        {
            DLog(@"连接失败,换IP");
            [self ReConnectSocket];
        }
    }
    else
    {
        if (_strRoomId)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_KICKOUT_VC object:nil];
        }
    }
}

- (void)ReConnectSocket
{
    if(nSocketType==1)
    {
        NSString *strAddr = nil;
        int nPort = 0;
        if ([[UserInfo sharedUserInfo].strWebAddr componentsSeparatedByString:@","].count > _nFall)
        {
            NSString *strInfo = [[UserInfo sharedUserInfo].strWebAddr componentsSeparatedByString:@","][_nFall];
            strAddr = [strInfo componentsSeparatedByString:@":"][0];
            nPort = [[strInfo componentsSeparatedByString:@":"][1] intValue];
        }
        else
        {
            strAddr = SVR_LOGIN_IP;
            nPort = SVR_LOGIN_PORT;
        }
        [self connectLogInServer:strAddr port:nPort];
        _nFall++;
    }
    else
    {
        //重连操作
        NSString *strAddr = nil;
        int nPort = 0;
        if ([[UserInfo sharedUserInfo].strRoomAddr componentsSeparatedByString:@","].count > _nFall)
        {
            NSString *strInfo = [[UserInfo sharedUserInfo].strRoomAddr componentsSeparatedByString:@","][_nFall];
            strAddr = [strInfo componentsSeparatedByString:@":"][0];
            nPort = [[strInfo componentsSeparatedByString:@":"][1] intValue];
        }
        [self reConnectRoomTime:_strRoomId address:strAddr port:nPort];
        _nFall++;
    }
}

#pragma mark 解析IP
- (NSString *)getIPWithHostName:(const NSString *)hostName
{
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    @try
    {
        phot = gethostbyname(hostN);
    }
    @catch (NSException *exception)
    {
        return nil;
    }
    struct in_addr ip_addr;
    if(phot)
    {
        memcpy(&ip_addr, phot->h_addr_list[0], 4);
        char ip[20] = {0};
        inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
        NSString *_strAddress = [NSString stringWithUTF8String:ip];
        return _strAddress;
    }
    else
    {
        return nil;
    }
}

- (void)downloadCache
{
    if (bCache)
    {
        return ;
    }
    if(_aryBuffer.count==0)
    {
        return ;
    }
    bCache = YES;
    dispatch_queue_t queue = dispatch_queue_create("downloadCache", 0);
    while (_aryBuffer.count)
    {
        NSString *strInfo = nil;
        NoticeModel *notice = nil;
        @synchronized(_aryBuffer)
        {
            notice = [_aryBuffer objectAtIndex:0];
            strInfo = notice.strContent;
            [_aryBuffer removeObjectAtIndex:0];
        }
        NSArray *aryPath = [DecodeJson getSrcPath:strInfo];
        if (aryPath.count>0)
        {
            __weak NSArray *__aryPath = aryPath;
            [_dictDownLoad setObject:notice forKey:[aryPath objectAtIndex:0]];
            __weak LSTcpSocket *__self = self;
            dispatch_apply(1,queue, ^(size_t index)
            {
                NSString *strKey = [__aryPath objectAtIndex:0];
                [__self downloadSingle:strKey info:notice];
            });
        }
        else
        {
            [self pushNotice:nil info:notice path:nil];
        }
        strInfo = nil;
    }
    bCache = NO;
}

- (void)downloadSingle:(NSString *)strPath info:(NoticeModel *)_notice
{
    __weak LSTcpSocket *__self = self;
    __weak NoticeModel *__notice = _notice;
    UIImage *imageCache = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:strPath];
    if (imageCache)
    {
        [self pushNotice:imageCache info:_notice path:strPath];
    }
    else
    {
        __weak NSString *__strPath = strPath;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:strPath] options:0 progress:nil
         completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             //下载完成后进入这里执行
             if (finished)
             {
                 [__self pushNotice:image info:__notice path:__strPath];
             }
             else
             {
                 [__self pushNotice:nil info:__notice path:nil];
             }
             [__self.dictDownLoad removeObjectForKey:__strPath];
         }];
    }
    
}

-(void)pushNotice:(UIImage *)image info:(NoticeModel *)_notice path:(NSString *)strPath
{
    if (_aryNotice.count>=20)
    {
        @synchronized(_aryNotice)
        {
            for (int i=0; i<10; i++)
            {
                [_aryNotice removeObjectAtIndex:i];
            }
        }
    }
    if (image==nil)
    {
        if (_notice)
        {
            [_aryNotice addObject:_notice];
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_NOTICE_VC object:nil];
        }
    }
    else
    {
        CGSize imageSize = image.size;
        CGFloat fHeight,fWidth;
        if((kScreenWidth-20)*2>imageSize.width)
        {
            fWidth = imageSize.width/2;
            fHeight = imageSize.height/2;
        }
        else
        {
            fHeight = (CGFloat)((kScreenWidth-20)/imageSize.width*imageSize.height);
            fWidth = kScreenWidth-20;
        }
        NSString *strResult = [DecodeJson replaceImageString:_notice.strContent width:fWidth height:fHeight index:0 strTemp:strPath];
        if(strResult)
        {
            _notice.strContent = strResult;
            [self.aryNotice addObject:_notice];
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_NOTICE_VC object:nil];
        }
    }
}

@end
