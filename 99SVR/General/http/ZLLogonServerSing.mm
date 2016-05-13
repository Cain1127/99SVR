//
//  ZLLoginServer.m
//  99SVR
//
//  Created by xia zhonglin  on 3/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLLogonServerSing.h"
#import "ZLLogonProtocol.h"
#include <string.h>
#import "DecodeJson.h"
#import "UserInfo.h"

@interface ZLLogonServerSing()
{
    ZLLogonProtocol *protocol;
}
@end

@implementation ZLLogonServerSing

DEFINE_SINGLETON_FOR_CLASS(ZLLogonServerSing)

- (void)serverInit
{
    if(protocol==NULL)
    {
        protocol = new ZLLogonProtocol();
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeProtocol)
                                                     name:MESSAGE_LOGIN_PROTOCOL_DISCONNECT_VC object:nil];
    }
}

- (void)loginSuccess:(NSString *)username pwd:(NSString *)password
{
    if(protocol==NULL)
    {
        protocol = new ZLLogonProtocol();
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeProtocol)
                name:MESSAGE_LOGIN_PROTOCOL_DISCONNECT_VC object:nil];
    }
    else
    {
        protocol->closeProtocol();
    }
    UserInfo *info = [UserInfo sharedUserInfo];
    if (info.otherLogin){
        const char *openId = [info.strOpenId UTF8String];
        const char *openToken = [info.strToken UTF8String];
        protocol->startOtherLogin([username intValue],openId,openToken);
    }
    else
    {
        info.strPwd = password;
        NSString *strMd5 = @"";
        if ([password length]>0) {
            strMd5 = [DecodeJson XCmdMd5String:password];
            [UserInfo sharedUserInfo].strMd5Pwd = strMd5;
        }
        protocol->startLogin([username UTF8String],[password UTF8String],[strMd5 UTF8String]);
    }
}

- (void)updatePwd:(NSString *)old cmd:(NSString *)password
{
    if (protocol) {
        NSString *strOld = [DecodeJson XCmdMd5String:old];
        NSString *strMD5 = [DecodeJson XCmdMd5String:password];
        protocol->updatePwd([strOld UTF8String], [strMD5 UTF8String]);
    }
}

- (void)updateNick:(NSString *)strNick intro:(NSString *)strintro sex:(int)nSex
{
    if (protocol) {
        NSData *data = [strNick dataUsingEncoding:GBK_ENCODING];
        NSData *intro = [strintro dataUsingEncoding:GBK_ENCODING];
        char cBuffer[100]={0};
        char cIntro[100]={0};
        memcpy(cBuffer, data.bytes, data.length);
        memcpy(cIntro, intro.bytes, intro.length);
        protocol->updateNick((const char *)cBuffer,(const char *)cIntro,nSex);
    }
}

- (void)closeProtocol
{
    if (protocol) {
        protocol->closeProtocol();
    }
}

- (void)connectVideoRoom:(int)nRoomId roomPwd:(NSString *)roomPwd
{
    if (protocol)
    {
        const char *cRoomPwd = nil;
        if ([roomPwd length]>0) {
//            cRoomPwd = [[DecodeJson XCmdMd5String:roomPwd] UTF8String];
            cRoomPwd = [roomPwd UTF8String];
        }
        else
        {
            cRoomPwd = "";
        }
        protocol->connectRoomInfo(nRoomId,KUserSingleton.otherLogin,cRoomPwd);
    }
}

- (void)sendRose{
    if (protocol)
    protocol->sendRose();
}

- (void)sendMessage:(NSString *)strMsg toId:(int)toId{
    
    char cBuffer[2048]={0};
    NSData *data = [strMsg dataUsingEncoding:GBK_ENCODING];
    ::strncpy(cBuffer, (const char *)data.bytes,data.length);
    if (protocol)
    {
        protocol->sendMessage(cBuffer, toId,"");
    }
}

- (void)exitRoom{
    if(protocol){
        protocol->exitRoomInfo();
    }
}

- (void)sendGiftInfo:(int)nGiftId number:(int)num{
    if(protocol){
        protocol->sendGift(nGiftId, num);
    }
}

- (void)requestBuyPrivateVip:(int)teacherId vipType:(int)vip
{
    if (protocol) {
        protocol->buyPrivateVip(teacherId,vip);
    }
}

- (void)requestRoomInfo
{
    if (protocol) {
        protocol->requestRoomMsg();
    }
}

- (void)sendGiftInfo:(int)nGiftId number:(int)num toUser:(int)userId toViewId:(int )viewId roomId:(int)roomId
{
    if(protocol)
    {
        protocol->sendGiftInfo(viewId,nGiftId, num,userId,roomId);
    }
    
}

- (void)colletRoomInfo:(int)action
{
    if (protocol)
    {
        protocol->colletRoomInfo(action);
    }
}

- (void)requestQuestion:(int)roomId team:(int)teamId stock:(NSString *)stock question:(NSString *)question
{
    if (protocol)
    {
        char cStock[64]={0};
        ::strncpy(cStock, (const char *)[stock dataUsingEncoding:GBK_ENCODING].bytes, [stock dataUsingEncoding:GBK_ENCODING].length);
        char cQuestion[1024]={0};
        ::strncpy(cQuestion, (const char *)[question dataUsingEncoding:GBK_ENCODING].bytes,[question dataUsingEncoding:GBK_ENCODING].length);
        protocol->sendQuestion(roomId,teamId,cStock,cQuestion);
    }
}

- (void)onNetWorkChange
{
    if (protocol) {
        protocol->networkfChanged();
    }
}

- (void)reConnect{
    if (protocol) {
        protocol->reConnect();
    }
}

@end
