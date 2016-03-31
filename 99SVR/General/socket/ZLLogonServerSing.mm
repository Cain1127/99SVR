//
//  ZLLoginServer.m
//  99SVR
//
//  Created by xia zhonglin  on 3/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLLogonServerSing.h"
#import "ZLLogonProtocol.h"
#import "DecodeJson.h"
#import "UserInfo.h"

@interface ZLLogonServerSing()
{
    ZLLogonProtocol *protocol;
}
@end

@implementation ZLLogonServerSing

DEFINE_SINGLETON_FOR_CLASS(ZLLogonServerSing)

- (void)loginSuccess:(NSString *)username pwd:(NSString *)password
{
    if(protocol==NULL)
    {
        protocol = new ZLLogonProtocol();
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeProtocol)
                name:MESSAGE_LOGIN_PROTOCOL_DISCONNECT_VC object:nil];
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
        protocol->updatePwd([old UTF8String], [password UTF8String]);
    }
}

- (void)updateNick:(NSString *)strNick intro:(NSString *)intro
{
    if (protocol) {
        protocol->updateNick([strNick UTF8String],[intro UTF8String]);
    }
}

- (void)closeProtocol
{
    if(protocol)
    {
        protocol->~ZLLogonProtocol();
        delete protocol;
        protocol = NULL;
    }
}

@end
