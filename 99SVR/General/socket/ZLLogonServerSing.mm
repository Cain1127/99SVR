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
#if 0
    if(protocol==NULL)
    {
        protocol = new ZLLogonProtocol();
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
        if (![username isEqualToString:@"0"]) {
            [UserDefaults setObject:username forKey:kUserId];
            [UserDefaults setObject:password forKey:kUserPwd];
        }
        protocol->startLogin([username UTF8String], [strMd5 UTF8String]);
    }
#endif
}

@end
