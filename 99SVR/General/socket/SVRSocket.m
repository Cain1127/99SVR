//
//  SVRSocket.m
//  99SVR
//
//  Created by xia zhonglin  on 12/7/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "SVRSocket.h"
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

#import "cmd_vchat.h"
#import "message_comm.h"
#import "message_vchat.h"
#import "DecodeJson.h"

#define MSG_BUFFER_SIZE   16384
#define MSG_MAX_SIZE    8192

int BuildHelloPack(int mainCmd, int subCmd, char* pBuff, int bufLen)
{
    //char szBuf[128];
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER *)pBuff;
    pHead->length = sizeof(COM_MSG_HEADER) + sizeof(CMDClientHello_t);
    pHead->checkcode = 0;
    pHead->version = MDM_Version_Value;
    pHead->maincmd = mainCmd;
    pHead->subcmd = subCmd;
    
    CMDClientHello_t* pHollo = (CMDClientHello_t *)pHead->content;
    pHollo->param1 = 12;
    pHollo->param2 = 8;
    pHollo->param3 = 7;
    pHollo->param4 = 1;
    
    return pHead->length;
}

@interface SVRSocket()
{
    int nSockfd;
    int en_msgbuffersize;
    int en_msgmaxsize;
    char m_szRecvBuf[MSG_BUFFER_SIZE];
    int m_iRemainBufLen;
}
@end

@implementation SVRSocket

- (id)init
{
    self = [super init];
    
    en_msgbuffersize = MSG_BUFFER_SIZE;
    en_msgmaxsize = MSG_MAX_SIZE;
    memset(m_szRecvBuf, 0, MSG_BUFFER_SIZE);
    
    return self;
}

-(int)connect:(const char *)ip port:(int)nPort
{
    CFSocketRef socket;
    int sockfd=0;
    socket = CFSocketCreate(kCFAllocatorDefault,PF_INET ,SOCK_STREAM,IPPROTO_TCP , 0, NULL, NULL);
    struct sockaddr_in addr;
    memset(&addr,0,sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(nPort);
    addr.sin_addr.s_addr = inet_addr(ip);
    CFDataRef xteAddress = CFDataCreate(NULL,(unsigned char*)&addr,sizeof(addr));
    CFTimeInterval timeout = 5;
    CFSocketError e = CFSocketConnectToAddress(socket, xteAddress, timeout);
    if (e!=kCFSocketSuccess)
    {
        CFRelease(socket);
        return 0;
    }else
    {
        sockfd = CFSocketGetNative(socket);
        CFRelease(socket);
        nSockfd = sockfd;
        DLog(@"cg");
        return 1;
    }
    return 0;
}

-(int)XzlConnect
{
    BOOL bFlag = [self getIPWithHostName:SVR_LOGIN_IP];
    if (bFlag)
    {
        int nStatus = [self connect:[_strAddress UTF8String] port:SVR_LOGIN_PORT];
        if (nStatus)
        {
            //如果连接成功，开启接收
            __weak SVRSocket *__self = self;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [__self socket_read];
            });
        }
        return nStatus;
    }
    return 0;
}

-(BOOL)getIPWithHostName:(const NSString *)hostName
{
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    @try
    {
        phot = gethostbyname(hostN);
    }
    @catch (NSException *exception)
    {
        return NO;
    }
    struct in_addr ip_addr;
    if(phot)
    {
        memcpy(&ip_addr, phot->h_addr_list[0], 4);
        char ip[20] = {0};
        inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
        
        _strAddress = [NSString stringWithUTF8String:ip];
        
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)sendHello
{
    char szTemp[32]={0};
    
    
    int nBuildLen = BuildHelloPack(MDM_Vchat_Login, Sub_Vchat_ClientHello, szTemp, 32);
    send(nSockfd, szTemp, nBuildLen, 0);
}

- (int)sendMsg_Login:(CMDUserLogonReq2_t*)login
{
    [self sendHello];
    char szBuf[1024]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER *)szBuf;
    pHead->length  = sizeof(COM_MSG_HEADER) + sizeof(CMDUserLogonReq2_t);
    pHead->checkcode = 0;
    pHead->version = MDM_Version_Value;
    pHead->maincmd = MDM_Vchat_Login;
    pHead->subcmd = Sub_Vchat_logonReq2;
    memcpy(pHead->content,login, sizeof(CMDUserLogonReq2_t));
    send(nSockfd,szBuf,pHead->length,0);
    
    char cBuffer[1024];
    memset(cBuffer, 0, 1024);

    return 1;
}

-(int)loginServerInfo:(NSString *)strUser pwd:(NSString *)strPwd
{
    CMDUserLogonReq2_t req;
    memset(&req, 0, sizeof(CMDUserLogonReq2_t));
    req.userid = [strUser intValue];//如果为0  则是游客登录
    req.nversion = 0;
    req.nmask = (int)time(0);
    const char *cPwd = [[DecodeJson XCmdMd5String:strPwd] UTF8String];
    strcpy(req.cuserpwd,cPwd);
    strcpy(req.cMacAddr,[[DecodeJson macaddress] UTF8String]);
    strcpy(req.cIpAddr, [[DecodeJson getIPAddress] UTF8String]);
    req.nimstate = 0;
    req.nmobile = 0;
    int nStatus = [self sendMsg_Login:&req];
    return nStatus;
}

-(int)getSocketHead:(char *)pBuf len:(int)nLen
{
    COM_MSG_HEADER* in_msg = (COM_MSG_HEADER *)pBuf;
    if(in_msg->maincmd == MDM_Vchat_Login)
    {
        switch(in_msg->subcmd)
        {
            case Sub_Vchat_logonSuccess:
            case Sub_Vchat_logonErr:
            {
                DLog(@"登录成功");
                int nMsgLen=in_msg->length-sizeof(COM_MSG_HEADER);
                char* pNewMsg=0;
                if(nMsgLen>0)
                {
                    pNewMsg= (char*) malloc(nMsgLen);
                    memcpy(pNewMsg,in_msg->content,nMsgLen);
                }
                if (nMsgLen == sizeof(CMDUserLogonErr_t))
                {
                    CMDUserLogonErr_t* pErr = (CMDUserLogonErr_t *)pNewMsg;
                    DLog(@"登录失败--pErr:%d",pErr->errid);
                    int nId = pErr->errid;
                    free(pNewMsg);
                    return nId;
                }
                else
                {
                    free(pNewMsg);
                    return 1;
                }
            }
            break;
            default:
            {
                DLog(@"error");
            }
                break;
        }
    }
    else
    {
        DLog(@"why?");
    }
    return 0;
}

//dispatch_async get socket bytes
- (int)socket_read
{
    char* p;
    int msglen, recvlen, errorid, nret;
    char* recv_buffer = m_szRecvBuf + m_iRemainBufLen;
    int recv_buffer_size = en_msgbuffersize - m_iRemainBufLen;
    while(1)
    {
        recvlen = (int)recv(nSockfd, recv_buffer, recv_buffer_size, 0);
        if(recvlen >0)
        {
            m_iRemainBufLen += recvlen;
            p = m_szRecvBuf;
            //尝试取出数据,考虑到取出数据的处理速度,建议使用PostMessage()处理取出的数据
            while( m_iRemainBufLen >4)
            {
                //格式: 消息头 的第一个int 就是长度
                msglen = *((int*)p);
                if(msglen <=0 || msglen > en_msgmaxsize)
                {
                    //消息长度无效
                    m_iRemainBufLen = 0;
                    DLog(@"1111");
                    return -1;
                }
                else if( m_iRemainBufLen < msglen) //长度不够
                {
                    break;
                }
                else
                {
                    DLog(@"msglen:%d",msglen);
                    nret = [self getSocketHead:p len:msglen];
                    if (nret == -1)
                    {
                        DLog(@"1111");
                        return -1;
                    }
                    m_iRemainBufLen -= msglen;
                    p += msglen;
                }
            }
            
            //取出数据后还能剩余一个最大长度消息,肯定有问题
            if(m_iRemainBufLen >= en_msgmaxsize)
            {
                //消息长度无效
                m_iRemainBufLen = 0;
                DLog(@"1111");
                return -1;
            }
            //如果有数据读出,将剩余数据迁移
            if( p != m_szRecvBuf && m_iRemainBufLen > 0)
            {
                memmove(m_szRecvBuf, p, m_iRemainBufLen);
            }
            //如果数据已经收全,推出
            if(recvlen < recv_buffer_size)
            {
                DLog(@"1111");
                return -1;
            }
            else
            {
                //继续接受
                recv_buffer = m_szRecvBuf + m_iRemainBufLen;
                recv_buffer_size = en_msgbuffersize - m_iRemainBufLen;
                continue;
            }
        }
        else
        {
            //出现异常
            if(errorid == EWOULDBLOCK)
            {
                DLog(@"1111");
                return 0;
            }
            else
            {
                DLog(@"1111");
                return -1;
            }
        }
    }
    
    return 0;
}

- (void)dealloc
{
    
}

@end
