//
//  SVRInitLBS.m
//  99SVR
//
//  Created by xia zhonglin  on 1/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "SVRInitLBS.h"
#import "BaseService.h"
#import "ZLLogonServerSing.h"
#import "LSTcpSocket.h"
#import "DecodeJson.h"
#import "UserInfo.h"

@implementation SVRInitLBS

+ (void)load
{
    //获取登录服务器地址
    __weak UserInfo *__userInfo = [UserInfo sharedUserInfo];
//    NSString *strtemp = @"t";
    [BaseService getJSONWithUrl:LBS_ROOM_WEB parameters:nil success:^(id responseObject)
    {
        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([strInfo rangeOfString:@"|"].location != NSNotFound)
        {
            NSString *strResult = [strInfo componentsSeparatedByString:@"|"][0];
            if (strResult.length>=2)
            {
                NSString *strWeb = [strResult substringWithRange:NSMakeRange(2,[strResult length]-3)];
                __userInfo.strWebAddr  = strWeb;
                [SVRInitLBS loginLocal];
            }
        }
     }
    fail:^(NSError *error)
     {
          DLog(@"固定IP登录");
          [SVRInitLBS loginLocal];
     }];
    //获取房间地址
    [BaseService getJSONWithUrl:LBS_ROOM_GATE parameters:nil success:^(id responseObject)
    {
        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        __userInfo.strRoomAddr = strInfo;
    }
    fail:nil];
}

+ (void)loginLocal
{
    UserInfo *__userInfo = [UserInfo sharedUserInfo];
    BOOL isLogin = [UserDefaults boolForKey:kIsLogin];
    if (isLogin)
    {
        int otherLogin = (int)[UserDefaults integerForKey:kOtherLogin];
        __userInfo.otherLogin = otherLogin;
        __userInfo.nUserId = [[UserDefaults objectForKey:kUserId] intValue];
        if (otherLogin)
        {
            __userInfo.strOpenId = [UserDefaults objectForKey:kOpenId];
            __userInfo.strToken = [UserDefaults objectForKey:kToken];
            [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:[UserDefaults objectForKey:kUserId] pwd:@""];
        }
        else
        {
            NSString *userPwd = [UserDefaults objectForKey:kUserPwd];
            if(userPwd)
            {
                __userInfo.strMd5Pwd = [DecodeJson XCmdMd5String:userPwd];
                __userInfo.strPwd = userPwd;
            }
            [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:[UserDefaults objectForKey:kUserId] pwd:__userInfo.strPwd];
        }
    }
    else
    {
        [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:@"0" pwd:@""];
    }
}

@end
