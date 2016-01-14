//
//  TextTcpSocket.m
//  99SVR
//
//  Created by xia zhonglin  on 1/11/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextTcpSocket.h"
#import "GCDAsyncSocket.h"
#import "cmd_vchat.h"
#import "moonDefines.h"
#import "DecodeJson.h"
#import "message_comm.h"
#import "message_vchat.h"


#define SOCKET_READ_LENGTH     1
#define SOCKET_READ_DATA       2

@interface TextTcpSocket()<GCDAsyncSocketDelegate>
{
    char cBuf[16384];
}
@property (nonatomic,strong) GCDAsyncSocket *asyncSocket;

@end

@implementation TextTcpSocket

- (void)connectTextServer:(NSString *)strIp port:(NSInteger)nPort
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
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

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    
}

-(int)getSocketHead:(char *)pBuf len:(int)nLen
{
    COM_MSG_HEADER* in_msg = (COM_MSG_HEADER *)pBuf;
    if(in_msg->maincmd == MDM_Vchat_Login)
    {
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

@end
