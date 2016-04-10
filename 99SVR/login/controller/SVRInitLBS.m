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

#define kVersionNumber @"132"

@implementation SVRInitLBS

+ (void)load
{
    //获取登录服务器地址
    [SVRInitLBS loginLocal];
    //获取房间地址
    UserInfo *__userInfo = [UserInfo sharedUserInfo];
    [BaseService get:LBS_ROOM_GATE dictionay:nil timeout:10 success:^(id responseObject)
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
    
    NSString *strLbs = [NSString stringWithFormat:@"%@%@",lbs_status,kVersionNumber];
    [BaseService get:strLbs dictionay:nil timeout:10 success:^(id responseObject) {
         NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         __userInfo.nStatus = [[parameters objectForKey:kVersionNumber] intValue];
    } fail:nil];
}

+ (void)loginLocal
{
    BOOL isLogin = [UserDefaults boolForKey:kIsLogin];
    KUserSingleton.nUserId = [[UserDefaults objectForKey:kUserId] intValue];
    if (isLogin && [UserDefaults objectForKey:kUserId]!=nil)
    {
        int otherLogin = (int)[UserDefaults integerForKey:kOtherLogin];
        KUserSingleton.otherLogin = otherLogin;
        KUserSingleton.nUserId = [[UserDefaults objectForKey:kUserId] intValue];
        if (otherLogin)
        {
            KUserSingleton.strOpenId = [UserDefaults objectForKey:kOpenId];
            KUserSingleton.strToken = [UserDefaults objectForKey:kToken];
            [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:[UserDefaults objectForKey:kUserId] pwd:@""];
        }
        else
        {
            NSString *userPwd = [UserDefaults objectForKey:kUserPwd];
            if(userPwd)
            {
                KUserSingleton.strMd5Pwd = [DecodeJson XCmdMd5String:userPwd];
                KUserSingleton.strPwd = userPwd;
            }
            [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:[UserDefaults objectForKey:kUserId] pwd:KUserSingleton.strPwd];
        }
    }
    else
    {
        [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:@"0" pwd:@""];
    }
}

@end
