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
#import "MediaSocket.h"
#import "GCDAsyncSocket.h"
#import "MediaBuffer.h"
#import "cmd_vchat.h"
#import "message_vchat.h"

#define MAX_TCPPAYLOAD_LENGTH 4000
#define MDM_GR_TCPVIDEO  301

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
    _roomid = roomid;
    _userid = userid;
    bFlag = YES;
    if (_strAddress == nil)
    {
        NSString *strPath = [[NSString alloc] initWithFormat:@"http://lbs1.99ducaijing.cn:2222/tygetmedia?id=%d",_roomid];
        __weak MediaSocket *__self = self;
        [BaseService getJSONWithUrl:strPath parameters:nil success:^(id responseObject) {
            __self.strAddress= [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *strAddrInfo = [__self.strAddress componentsSeparatedByString:@","][0];
            if (strAddrInfo && [strAddrInfo rangeOfString:@":"].location != NSNotFound)
            {
                NSString *strAddr = [strAddrInfo componentsSeparatedByString:@":"][0];
                int port = [[strAddrInfo componentsSeparatedByString:@":"][1] intValue];
                [__self connectIpAndPort:strAddr port:port];
            }
        }
        fail:nil];
    }
    else
    {
        NSString *strAddrInfo = [_strAddress componentsSeparatedByString:@","][0];
        NSString *strAddr = [strAddrInfo componentsSeparatedByString:@":"][0];
        int port = [[strAddrInfo componentsSeparatedByString:@":"][1] intValue];
        [self connectIpAndPort:strAddr port:port];
    }
    
}

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
    [_gcdSocket writeData:data withTimeout:20 tag:1];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    DLog(@"建立socket成功:ip:%@--port:%d",host,port);
    m_jittertime = 2;
    [_gcdSocket readDataToLength:4 withTimeout:-1 tag:1];
    [self sendHello];
    
    __weak MediaSocket *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
                   ^{
                       [__self sendAllInfo];
                   });
}

- (void)sendAllInfo
{
    int iTime = 1;
    while (bFlag)
    {
        if (iTime%8==7)
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

- (void)send_keep_live_tcp
{
    char szBuf[256]={0};
    COM_MSG_HEADER *header = (COM_MSG_HEADER*)szBuf;
    header->version = 10;
    header->checkcode = 0;
    header->maincmd = MDM_GR_TCPVIDEO;
    header->subcmd = 201;
    header->length = sizeof(COM_MSG_HEADER);
    NSData *data = [NSData dataWithBytes:szBuf length:header->length];
    [_gcdSocket writeData:data withTimeout:20 tag:1];
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
    NSData *data = [NSData dataWithBytes:szBuf length:header->length];
    [_gcdSocket writeData:data withTimeout:20 tag:1];
}

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
    NSData *data = [NSData dataWithBytes:szBuf length:header->length];
    [_gcdSocket writeData:data withTimeout:20 tag:1];
}

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
    NSData *data = [NSData dataWithBytes:szBuf length:header->length];
    [_gcdSocket writeData:data withTimeout:20 tag:1];
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
                [_gcdSocket readDataToLength:sizeof(int32) withTimeout:-1 tag:SOCKET_READ_LENGTH];
            }
            else
            {
                [_gcdSocket readDataToLength:nSize-sizeof(int32) withTimeout:-1 tag:SOCKET_READ_DATA];
            }
        }
            break;
        case SOCKET_READ_DATA:
        {
            char *p = cBuf;
            int32 nSize = *((int32 *)p);
            memcpy(p+sizeof(int32), [data bytes], data.length);
            [self getSocketHead:cBuf len:(int32)(data.length+sizeof(int32))];
        }
            break;
        default:
            break;
    }
}

- (void)videoFrame:(cmd_video_frame_data_t *)frame
{
    
}

- (void)audioFrame:(cmd_video_frame_data_t *)frame
{
    
}

#define MediaBlock(buf,len,pt) \
if(_block) \
{_block(buf,len,pt);}

- (void)bufferOper:(COM_MSG_HEADER *)inmsg
{
    cmd_video_frame_data_t *frame = (cmd_video_frame_data_t *)inmsg->content;
    unsigned char pub[4096]={0};
    //长度超标
    if (inmsg->length>(4096+sizeof(COM_MSG_HEADER)+sizeof(cmd_video_frame_data_t)))
    {
        return ;
    }
    memcpy(pub,frame->content,inmsg->length-sizeof(COM_MSG_HEADER)-sizeof(cmd_video_frame_data_t));
    if(frame->ts <= m_nLastRecvTS && m_nLastRecvTS-frame->ts <400)
    {
        DLog(@"丢弃");
        [_gcdSocket readDataToLength:sizeof(int32) withTimeout:-1 tag:SOCKET_READ_LENGTH];
        return;
    }
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
                MediaBlock((unsigned char *)mBuffer.data.bytes,(int)mBuffer.data.length, frame->pt);
                [_aryVideo removeObject:mBuffer];
            }
            else
            {
                MediaBlock(cBuffer,frame->pktlen,frame->pt);
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
}

- (void)getSocketHead:(char *)cBuffer len:(int)nSize
{
    COM_MSG_HEADER *inmsg = (COM_MSG_HEADER *)cBuffer;
    [self bufferOper:inmsg];
    [_gcdSocket readDataToLength:4 withTimeout:-1 tag:SOCKET_READ_LENGTH];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err)
    {
        DLog(@"出现错误");
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_MEDIA_DISCONNECT_VC object:nil];
    }
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
}

@end
