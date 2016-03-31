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
    [SVRInitLBS loginLocal];
    //获取房间地址
    UserInfo *__userInfo = [UserInfo sharedUserInfo];
    [BaseService getJSONWithUrl:LBS_ROOM_GATE parameters:nil success:^(id responseObject)
    {
        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        __userInfo.strRoomAddr = strInfo;
    }
    fail:nil];
    //获取礼物
    [BaseService post:kGift_URL dictionay:nil timeout:5 success:^(id responseObject) {
        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        [UserDefaults setObject:parameters forKey:kGiftInfo];
        [DecodeJson setGiftInfo:parameters];
    } fail:^(NSError *error) {
        
    }];
    NSString *strUrl = [NSString stringWithFormat:@"%@tygettext",LBS_HTTP_HOST];
    [BaseService get:strUrl dictionay:nil timeout:10 success:^(id responseObject) {
        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        __userInfo.strTextRoom = strInfo;
    } fail:nil];
    
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
