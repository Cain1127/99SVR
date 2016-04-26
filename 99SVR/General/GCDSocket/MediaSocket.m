//
//  TestMedia.m
//  99SVR
//
//  Created by xia zhonglin  on 1/25/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//
#include <stdio.h>
#include <sys/time.h>
#import "BaseService.h"
#import "UserInfo.h"
#import "MediaSocket.h"
#import "GCDAsyncSocket.h"
#import "DecodeJson.h"
#import "MediaBuffer.h"
#import "cmd_vchat.h"
#import "message_vchat.h"

#define MAX_TCPPAYLOAD_LENGTH 4000
#define MDM_GR_TCPVIDEO  301
#define kConnectTimeOut    10
#define kREAD_TIMEOUT   10

typedef struct video_frame_data{
    unsigned int ssrc;
    unsigned int ts;
    unsigned int pt;
    unsigned int roomid;
    unsigned int framelen;
    unsigned int framepktcount;
    unsigned int pktidx;
    unsigned int pktlen;
    char content[0];
}cmd_video_frame_data_t;

typedef struct video_hello
{
    unsigned char param1;
    unsigned char param2;
    unsigned char param3;
    unsigned char param4;
}cmd_video_hello_t;

typedef struct tcp_video_register
{
    unsigned int userid;
    unsigned int roomid;
    unsigned int pt;
}
cmd_tcp_video_register_t;

typedef struct _tag_MediaFrameBuffer
{
    unsigned int ts;
    unsigned int expiredtime;
    unsigned int recvlen;
    unsigned int framelen;
    unsigned int packetcount;
    int iscomplete;
    int lossflag;
    int* pktstates;
    char* buff;
}MediaFrameBuffer_t;

@interface MediaSocket()<GCDAsyncSocketDelegate>
{
    char cBuf[16384];
    unsigned int m_nLastRecvTS;
    unsigned int m_ssrc;
    unsigned int m_roomid;
    int          m_pt;
    int          m_jittertime;
    int          m_bautoSubscribe;
    int          m_btemppause;
    unsigned int m_nLastUpperTS;
    BOOL bFlag;
    BOOL bVideo;
    BOOL bAudio;
    BOOL bBack;
    long  nReadTime;
}

@property (nonatomic,strong) NSMutableArray *aryVideo;
@property (nonatomic,strong) GCDAsyncSocket *gcdSocket;
@property (nonatomic) int roomid;
@property (nonatomic) int userid;
@property (nonatomic,copy) NSString *strAddress;
@end

@implementation MediaSocket

- (id)init
{
   if(self = [super init])
   {
       bAudio = YES;
       bVideo = YES;
       _videoBuf = [[NSMutableArray alloc] init];
       _audioBuf = [[NSMutableArray alloc] init];
       return self;
   }
   return nil;
}

- (void)setEnableVideo:(BOOL)enable
{
    bVideo = enable;
}

- (void)settingBackVideo:(BOOL)enable
{
    bBack = enable;
    if (bBack)
    {
        [self send_unregister_tcp:_userid room:_roomid pt:99];
    }
}

- (void)setEnableAudio:(BOOL)enable
{
    bAudio = enable;
}

- (void)connectRoomId:(int)roomid mic:(int)userid
{
    _nFall = 0;
    if(_gcdSocket)
    {
        [self closeSocket];
    }
    _roomid = roomid;
    _userid = userid;
    @synchronized(_audioBuf)
    {
        [_audioBuf removeAllObjects];
    }
    @synchronized(_videoBuf)
    {
        [_videoBuf removeAllObjects];
    }
    bFlag = YES;
    [self getMediaHost];
}

- (void)getMediaHost
{
    //重连操作
    if (_nFall>=12) {
        return ;
    }
    int nLbs = _nFall/3;
    NSString *addrTemp = [KUserSingleton.dictRoomMedia objectForKey:@(nLbs)];
    if (addrTemp == nil)
    {
        NSString *strInfo = [kLbs_all_path componentsSeparatedByString:@";"][nLbs];
        NSString *strPath = [[NSString alloc] initWithFormat:@"http://%@/tygetmedia?id=%d",strInfo,_roomid];
        @WeakObj(self)
        __block int __nLbs = nLbs;
        [BaseService get:strPath dictionay:nil timeout:5 success:^(id responseObject) {
            if (responseObject) {
                NSString *addrInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                addrInfo = [DecodeJson getArrayAddr:addrInfo];
                [KUserSingleton.dictRoomMedia setObject:addrInfo forKey:@(__nLbs)];
                int nIndex = selfWeak.nFall%2;
                if ([addrInfo rangeOfString:@";"].location!=NSNotFound) {
                    NSArray *arrayIndex = [addrInfo componentsSeparatedByString:@";"];
                    NSString *strAddrInfo = arrayIndex.count > nIndex ? arrayIndex[nIndex] : @"nil";
                    if (strAddrInfo && [strAddrInfo rangeOfString:@":"].location != NSNotFound &&
                                            [strAddrInfo rangeOfString:@"."].location != NSNotFound)
                    {
                        NSString *strAddr = [strAddrInfo componentsSeparatedByString:@":"][0];
                        int nPort = [[strAddrInfo componentsSeparatedByString:@":"][1] intValue];
                        [selfWeak connectIpAndPort:strAddr port:nPort];
                    }
                }else{
                    selfWeak.nFall=(__nLbs+1)*3;
                    [selfWeak getMediaHost];
                }
            }
        }
        fail:^(NSError *error)
        {
             if(selfWeak.nFall<12)
             {
                 selfWeak.nFall=(__nLbs+1)*3;
                 [selfWeak getMediaHost];
             }
         }];
    }
    else
    {
        int nIndex = _nFall%3;
        NSArray *arrayIndex = [addrTemp componentsSeparatedByString:@";"];
        NSString *strAddrInfo = arrayIndex.count > nIndex ? arrayIndex[nIndex] : @"nil";
        if ([strAddrInfo isEqualToString:@"nil"]) {
            _nFall=(nLbs+1)*3;
            [self getMediaHost];
        }else{
            NSString *strAddr = [strAddrInfo componentsSeparatedByString:@":"][0];
            int nPort = [[strAddrInfo componentsSeparatedByString:@":"][1] intValue];
            [self connectIpAndPort:strAddr port:nPort];
        }
    }
    
}
/**
 *  连接流媒体服务器ip,port
 */
- (void)connectIpAndPort:(NSString *)strIp port:(int)nPort
{
    if (_aryVideo==nil)
    {
        _aryVideo = [NSMutableArray array];
    }
    [_aryVideo removeAllObjects];
    
    _gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    if (![_gcdSocket connectToHost:strIp onPort:nPort error:nil])
    {
        DLog(@"连接失败");
    }
}
/**
 *  发送helloe消息
*/
- (void)sendHello
{
    char szTemp[32]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER *)szTemp;
    pHead->length = sizeof(COM_MSG_HEADER) + sizeof(CMDClientHello_t);
    pHead->checkcode = 0;
    pHead->version = 10;
    pHead->maincmd = MDM_GR_TCPVIDEO;
    pHead->subcmd = 200;
    cmd_video_hello_t *pReq = (cmd_video_hello_t *)pHead->content;
    pReq->param1 = 12;
    pReq->param2 = 8;
    pReq->param3 = 7;
    pReq->param4 = 1;
    NSData *data = [NSData dataWithBytes:szTemp length:pHead->length];
    [_gcdSocket writeData:data withTimeout:10 tag:1];
}
/**
 *  socket 建立成功
 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    DLog(@"建立socket成功:ip:%@--port:%d",host,port);
    NSString *strInfo = [NSString stringWithFormat:@"%@:%d",host,port];
    [UserInfo sharedUserInfo].strMediaAddr = host;
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TCP_SOCKET_SEND_MEDIA object:strInfo];
    m_jittertime = 2;
    
    [_gcdSocket readDataToLength:4 withTimeout:kREAD_TIMEOUT tag:1];
    [self sendHello];
    struct timeval result;
    gettimeofday(&result,NULL);
    nReadTime = result.tv_sec;
    __weak MediaSocket *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [__self sendAllInfo];
    });
}
/**
 *  持续发送所有信息
 */
- (void)sendAllInfo
{
    int iTime = 0;
    while (bFlag)
    {
        if (iTime%8==0)
        {
            [self send_keep_live_tcp];
            if (bVideo && !bBack)
            {
                [self send_register_tcp:_userid room:_roomid pt:99];
            }
            if (bAudio)
            {
                [self send_register_tcp:_userid room:_roomid pt:97];
            }
            iTime = 0;
        }
        [NSThread sleepForTimeInterval:0.5f];
        iTime++;
    }
}
/**
 *  心跳
 */
- (void)send_keep_live_tcp
{
    char szBuf[256]={0};
    COM_MSG_HEADER *header = (COM_MSG_HEADER*)szBuf;
    header->version = 10;
    header->checkcode = 0;
    header->maincmd = MDM_GR_TCPVIDEO;
    header->subcmd = 201;
    header->length = sizeof(COM_MSG_HEADER);
    @autoreleasepool {
        NSData *data = [NSData dataWithBytes:szBuf length:header->length];
        [_gcdSocket writeData:data withTimeout:20 tag:1];
    }
    
}

- (void)send_register_source_tcp:(int)ssrc room:(int)roomid pt:(int)ptId
{
    char szBuf[256]={0};
    COM_MSG_HEADER *header = (COM_MSG_HEADER*)szBuf;
    header->version = 10;
    header->checkcode = 0;
    header->maincmd = MDM_GR_TCPVIDEO;
    header->subcmd = 1;
    cmd_tcp_video_register_t *pReq = (cmd_tcp_video_register_t *)header->content;
    pReq->userid = ssrc;
    pReq->roomid = roomid;
    pReq->pt = ptId;
    header->length = sizeof(COM_MSG_HEADER) + sizeof(cmd_tcp_video_register_t);
    @autoreleasepool
    {
        NSData *data = [NSData dataWithBytes:szBuf length:header->length];
        [_gcdSocket writeData:data withTimeout:20 tag:1];
        data = nil;
    }
}
/**
 *  注销音视频
 */
- (void)send_unregister_tcp:(int )ssrc room:(int)roomid pt:(int)ptId
{
    char szBuf[256]={0};
    COM_MSG_HEADER *header = (COM_MSG_HEADER*)szBuf;
    header->version = 10;
    header->checkcode = 0;
    header->maincmd = MDM_GR_TCPVIDEO;
    header->subcmd = 4;
    cmd_tcp_video_register_t *pReq = (cmd_tcp_video_register_t *)header->content;
    pReq->userid = ssrc;
    pReq->roomid = roomid;
    pReq->pt = ptId;
    header->length = sizeof(COM_MSG_HEADER) + sizeof(cmd_tcp_video_register_t);
    @autoreleasepool {
        NSData *data = [NSData dataWithBytes:szBuf length:header->length];
        [_gcdSocket writeData:data withTimeout:20 tag:1];
        data = nil;
    }
}
/**
 *  请求音视频
 */
- (void)send_register_tcp:(int )ssrc room:(int)roomid pt:(int)ptId
{
    char szBuf[256]={0};
    COM_MSG_HEADER *header = (COM_MSG_HEADER*)szBuf;
    header->version = 10;
    header->checkcode = 0;
    header->maincmd = MDM_GR_TCPVIDEO;
    header->subcmd = 3;
    cmd_tcp_video_register_t *pReq = (cmd_tcp_video_register_t *)header->content;
    pReq->userid = ssrc;
    pReq->roomid = roomid;
    pReq->pt = ptId;
    header->length = sizeof(COM_MSG_HEADER) + sizeof(cmd_tcp_video_register_t);
    @autoreleasepool
    {
        NSData *data = [NSData dataWithBytes:szBuf length:header->length];
        [_gcdSocket writeData:data withTimeout:20 tag:1];
        data = nil;
    }
}
/**
 *  socket 读取码流操作
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    _nFall=0;
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
                [_gcdSocket readDataToLength:sizeof(int32) withTimeout:kREAD_TIMEOUT tag:SOCKET_READ_LENGTH];
            }
            else
            {
                [_gcdSocket readDataToLength:nSize-sizeof(int32) withTimeout:kREAD_TIMEOUT tag:SOCKET_READ_DATA];
            }
        }
        break;
        case SOCKET_READ_DATA:
        {
            char *p = cBuf;
            memcpy(p+sizeof(int32), [data bytes], data.length);
            [self getSocketHead:cBuf len:(int32)(data.length+sizeof(int32))];
        }
        break;
        default:
            break;
    }
}

#define MediaBlock(buf,len,pt) \
if(_block) \
{_block(buf,len,pt);}

- (void)bufferOper:(COM_MSG_HEADER *)inmsg
{
    int nMsgLen=inmsg->length-sizeof(COM_MSG_HEADER);
    char* pNewMsg=0;
    if(nMsgLen>0)
    {
        pNewMsg= (char*) malloc(nMsgLen);
        memcpy(pNewMsg,inmsg->content,nMsgLen);
    }
    cmd_video_frame_data_t *frame = (cmd_video_frame_data_t *)pNewMsg;
    unsigned char pub[4096]={0};
    //长度超标
    if (inmsg->length>(4096+sizeof(COM_MSG_HEADER)+sizeof(cmd_video_frame_data_t)))
    {
        free(pNewMsg);
        DLog(@"长度不对");
        return ;
    }
    memcpy(pub,frame->content,inmsg->length-sizeof(COM_MSG_HEADER)-sizeof(cmd_video_frame_data_t));
    bool bfound=false;
    MediaBuffer *mBuffer = nil;
    for (MediaBuffer *oldBuffer in _aryVideo)
    {
        if (oldBuffer.ts == frame->ts)
        {
            bfound = YES;
            mBuffer = oldBuffer;
            break;
        }
    }
    if (!bfound)
    {
        mBuffer = [[MediaBuffer alloc] init];
        mBuffer.recvlen = 0;
        mBuffer.framelen=frame->framelen;
        mBuffer.packetcount=frame->framepktcount;
        mBuffer.iscomplete=0;
        mBuffer.ts=frame->ts;
        struct timeval tv;
        gettimeofday(&tv,NULL);
        mBuffer.pktstatus = [[NSMutableArray alloc] initWithCapacity:mBuffer.packetcount];
        for (int nCount=0; nCount<mBuffer.packetcount; nCount++)
        {
            [mBuffer.pktstatus addObject:[NSNumber numberWithInt:0]];
        }
    }
    if(frame->pktidx<mBuffer.packetcount && [mBuffer.pktstatus[frame->pktidx] intValue]==0)
    {
        unsigned char cBuffer[4096]={0};
        memcpy(cBuffer,frame->content,frame->pktlen);
        mBuffer.recvlen +=frame->pktlen;
        mBuffer.pktstatus[frame->pktidx]=[NSNumber numberWithInt:1];
        if(mBuffer.recvlen == mBuffer.framelen)
        {
            if (mBuffer.data)
            {
                [mBuffer.data appendBytes:cBuffer length:frame->pktlen];
                m_nLastRecvTS = frame->ts;
                [self push_queue:(unsigned char *)mBuffer.data.bytes length:(int)mBuffer.data.length pt:frame->pt ts:frame->ts];
                [_aryVideo removeObject:mBuffer];
            }
            else
            {
                m_nLastRecvTS = frame->ts;
                [self push_queue:cBuffer length:frame->pktlen pt:frame->pt ts:frame->ts];
            }
        }
        else
        {
            if (mBuffer.data==nil)
            {
                mBuffer.data = [NSMutableData data];
            }
            [mBuffer.data appendBytes:cBuffer length:frame->pktlen];
            [_aryVideo addObject:mBuffer];
        }
    }
    free(pNewMsg);
}

- (void)push_queue:(unsigned char *)cBuffer length:(int)length pt:(int)pt ts:(int)ts
{
    if (pt==97 && bAudio)
    {
        //音频
        if(_audioBuf)
        {
            @autoreleasepool
            {
                if(length>0)
                {
                    @synchronized(_audioBuf) {
                        NSData *data = [NSData dataWithBytes:cBuffer length:length];
                        [_audioBuf addObject:data];
                    }
                }
            }
        }
    }
    else if(pt ==99 && bVideo)
    {
        if(_videoBuf)
        {
            @autoreleasepool {
                if(length>0)
                {
                    @synchronized(_videoBuf) {
                        NSData *data = [NSData dataWithBytes:cBuffer length:length];
                        [_videoBuf addObject:data];
                    }
                }
            }
            
        }
    }
}

- (void)getSocketHead:(char *)cBuffer len:(int)nSize
{
    COM_MSG_HEADER *inmsg = (COM_MSG_HEADER *)cBuffer;
    [self bufferOper:inmsg];
    [_gcdSocket readDataToLength:4 withTimeout:kREAD_TIMEOUT tag:SOCKET_READ_LENGTH];
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    DLog(@"超时，重连");
    [self closeSocket];
    _nFall ++;
    [self getMediaHost];
    return 1;
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    DLog(@"socket 中断");
    if(_nFall>=12)
    {
        DLog(@"重新建立连接");
        NSString *strErrlog =[NSString stringWithFormat:@"ReportItem=DirectSeedingQuality&ClientType=3&UserId=%d&ServerIP=%@&Error=kadun",
                              [UserInfo sharedUserInfo].nUserId,[UserInfo sharedUserInfo].strMediaAddr];
        [DecodeJson postPHPServerMsg:strErrlog];
        _nFall = 0;
    }
    if(err)
    {
//    if ([[err.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"Connection refused"]){
//        //直接进行重连
//    }
//    else if([[err.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"Socket closed byremote peer"]){
//        //直接进行重连
//    }
        _nFall ++;
        [self getMediaHost];
    }
    m_nLastRecvTS=0;
    DLog(@"fall:%d",_nFall);
}

- (void)closeSocket
{
    bFlag = NO;
    [self send_unregister_tcp:_userid room:_roomid pt:99];
    [self send_unregister_tcp:_userid room:_roomid pt:97];
    [_gcdSocket disconnectAfterReading];
    _gcdSocket = nil;
    [_aryVideo removeAllObjects];
    _aryVideo = nil;
    [_audioBuf removeAllObjects];
    [_videoBuf removeAllObjects];
}

- (void)dealloc
{
    DLog(@"释放MediaSocket");
    [_audioBuf removeAllObjects];
    _audioBuf = nil;
    [_videoBuf removeAllObjects];
    _videoBuf = nil;
}

@end
