//
//  ZLLoginServer.m
//  99SVR
//
//  Created by xia zhonglin  on 3/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLLogonServerSing.h"
#import "ZLLogonProtocol.h"
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
    }
    [UserInfo sharedUserInfo].strPwd = password;
    protocol->startLogin([username UTF8String], [password UTF8String]);
}

@end
