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
#import <Bugly/CrashReporter.h>

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

-(void)closeSocket
{
    if(_asyncSocket)
    {
        [_asyncSocket disconnectAfterReading];
        _asyncSocket = nil;
        [_rInfo.dictUser removeAllObjects];
        [_rInfo.aryUser removeAllObjects];
        _rInfo = nil;
    }
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
    @autoreleasepool
    {
        NSData *data = [NSData dataWithBytes:szBuf length:pHead->length];
        [_asyncSocket writeData:data withTimeout:-1 tag:1];
    }
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
    @autoreleasepool {
        NSData *data = [NSData dataWithBytes:szTemp length:pHead->length];
        [_asyncSocket writeData:data withTimeout:20 tag:1];
    }
}

#pragma mark 第三方登录

- (void)sendMsg_otherLogin
{
    CMDUserLogonReq5_t req;
    memset(&req, 0, sizeof(CMDUserLogonReq5_t));
    req.userid = [UserInfo sharedUserInfo].nUserId;
    strcpy(req.openid, [[UserInfo sharedUserInfo].strOpenId UTF8String]);
    strcpy(req.opentoken, [[UserInfo sharedUserInfo].strToken UTF8String]);
    req.platformType = [UserInfo sharedUserInfo].otherLogin;
    req.nversion = 4000000;
    req.nmask = (int)time(0);
    [UserInfo sharedUserInfo].strUser = _strUser;
    req.nimstate = 0;
    req.nmobile = 2;
    [self sendMessage:(char*)&req size:sizeof(CMDUserLogonReq5_t) version:MDM_Version_Value
              maincmd:MDM_Vchat_Login subcmd:Sub_Vchat_logonReq5];
}

#pragma mark 新接口
- (void)sendMsg_newLogin
{
    CMDUserLogonReq4_t req;
    memset(&req, 0, sizeof(CMDUserLogonReq4_t));
    strcpy(req.cloginid, [_strUser UTF8String]);
    req.nversion = 4000000;
    req.nmask = (int)time(0);
    [UserInfo sharedUserInfo].strUser = _strUser;
    if (![_strUser isEqualToString:@"0"])
    {
        if(_strPwd)
        {
            NSString *strMd5 = [DecodeJson XCmdMd5String:_strPwd];
            [UserInfo sharedUserInfo].strMd5Pwd = strMd5;
            strcpy(req.cuserpwd,[strMd5 UTF8String]);
        }
        [UserInfo sharedUserInfo].strPwd = _strPwd;
    }
    req.nimstate = 0;
    req.nmobile = 2;
    [self sendMessage:(char*)&req size:sizeof(CMDUserLogonReq4_t) version:MDM_Version_Value
              maincmd:MDM_Vchat_Login subcmd:Sub_Vchat_logonReq4];
}

#pragma mark 准备弃用
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
        if(_strPwd)
        {
            NSString *strMd5 = [DecodeJson XCmdMd5String:_strPwd];
            [UserInfo sharedUserInfo].strMd5Pwd = strMd5;
            strcpy(req.cuserpwd,[strMd5 UTF8String]);
        }
        [UserInfo sharedUserInfo].strPwd = _strPwd;
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
    NSString *strAddr = nil;// SVR_LOGIN_IP;
    int nPort = 0;//SVR_LOGIN_PORT;
    if (strTempAddr && strTempAddr.length>0)
    {
        NSArray *aryTemp = [strTempAddr componentsSeparatedByString:@","];
        if (aryTemp.count>0)
        {
            NSArray *aryAddr = [aryTemp[0] componentsSeparatedByString:@":"];
            if (aryAddr.count==2)
            {
                strAddr = aryAddr[0];
                nPort = [aryAddr[1] intValue];
            }
        }
    }
    if (nPort==0)
    {
        strAddr = SVR_LOGIN_IP;
        nPort = SVR_LOGIN_PORT;
    }
//    [self connectLogInServer:@"58.210.107.53" port:7405];
//    [self connectLogInServer:@"172.16.41.96" port:7403];
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
            if(nMsgLen == sizeof(CMDUserLogonSuccess_t))
            {
                [self loginSucess:pNewMsg];
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_SUCESS_VC object:@"登录成功"];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_ERROR_VC object:@"登录异常"];
            }
        }
        break;
        case Sub_Vchat_logonSuccess2:
        {
            if (nMsgLen == sizeof(CMDUserLogonSuccess2_t)) {
                [self loginSucess2:pNewMsg];
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_SUCESS_VC object:@"登录成功"];
            }
        }
        break;
        case Sub_Vchat_logonErr2:
        {
            DLog(@"登录失败");
            [self loginError2:pNewMsg];
        }
        break;
        case Sub_Vchat_logonErr:
        {
            if(nMsgLen == sizeof(CMDUserLogonErr_t))
            {
                [self loginError:pNewMsg];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_ERROR_VC object:@"登录异常"];
            }
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

#pragma makr 新响应
- (void)loginSucess2:(char *)pData
{
    CMDUserLogonSuccess2_t *pLogonResp = (CMDUserLogonSuccess2_t *)pData;
    UserInfo *user = [UserInfo sharedUserInfo];
    user.m_nVipLevel=pLogonResp->viplevel;
    user.goldCoin = pLogonResp->nk;
    user.score = pLogonResp->nb;
    user.sex = pLogonResp->ngender;
    user.nUserId = pLogonResp->userid;
    user.strName = [NSString stringWithCString:pLogonResp->cuseralias encoding:GBK_ENCODING];
    if ((user.nUserId>900000000 && user.nUserId < 1000000000) || user.nUserId == 0)
    {
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 2;
    }
    else
    {
        user.nUserId = pLogonResp->userid;
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 1;
    }
    if([UserInfo sharedUserInfo].nType==1)
    {
        [UserDefaults setBool:YES forKey:kIsLogin];
        [UserDefaults setObject:_strUser forKey:kUserId];
        [UserDefaults setObject:_strPwd forKey:kUserPwd];
        [UserDefaults synchronize];
        
        if ([UserInfo sharedUserInfo].otherLogin ==0)
        {
            [UserDefaults setInteger:0 forKey:kOtherLogin];
        }
        else
        {
            [UserDefaults setObject:[UserInfo sharedUserInfo].strOpenId forKey:kOpenId];
            [UserDefaults setObject:[UserInfo sharedUserInfo].strToken forKey:kToken];
            [UserDefaults setInteger:[UserInfo sharedUserInfo].otherLogin forKey:kOtherLogin];
        }
    }
    [[CrashReporter sharedInstance] setUserId:[NSString stringWithFormat:@"用户:%@",NSStringFromInt(user.nUserId)]];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
}

#pragma mark 准备弃用
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
    if ((user.nUserId>900000000 && user.nUserId < 1000000000) || user.nUserId == 0)
    {
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 2;
    }
    else
    {
        user.nUserId = pLogonResp->userid;
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 1;
    }
    if([UserInfo sharedUserInfo].nType==1)
    {
        [UserDefaults setBool:YES forKey:kIsLogin];
        [UserDefaults setObject:NSStringFromInt(user.nUserId) forKey:kUserId];
        [UserDefaults setObject:_strPwd forKey:kUserPwd];
        [UserDefaults synchronize];
    }
    [[CrashReporter sharedInstance] setUserId:[NSString stringWithFormat:@"用户:%@",NSStringFromInt(user.nUserId)]];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
}

- (void)loginError2:(char *)pError
{
    CMDUserLogonErr2_t* pErr = (CMDUserLogonErr2_t *)pError;
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
    else if(pErr->errid == 106)
    {
        strMsg = @"账号错误";
    }
    else if(pErr->errid == 104)
    {
        strMsg = @"密码错误";
    }
    else if(pErr->errid == 105)
    {
        strMsg = @"请升级";
    }
    else if(pErr->errid == 107)
    {
        strMsg = @"账号已冻结";
    }
    else
    {
        strMsg = @"密码错误";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_ERROR_VC object:strMsg];
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
        if ([UserInfo sharedUserInfo].otherLogin != 0)
        {
            [self sendMsg_otherLogin];
        }
        else
        {
            [self sendMsg_newLogin];
        }
        [_asyncSocket readDataToLength:sizeof(int) withTimeout:-1 tag:SOCKET_READ_LENGTH];
    }
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

@end
