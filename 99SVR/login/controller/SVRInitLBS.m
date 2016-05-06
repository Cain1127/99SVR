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
#import "DecodeJson.h"
#import "UserInfo.h"

@implementation SVRInitLBS

+ (void)loadAllInfo
{
    //获取登录服务器地址
    [SVRInitLBS loginLocal];
    //获取房间地址
    [SVRInitLBS requestLbs];
    
    [SVRInitLBS requestGift];
    
    [SVRInitLBS authVersion];
    
    [SVRInitLBS httpTest];
}

+ (void)httpTest
{
    [kHTTPSingle RequestViewpointSummary:0 start:0 count:20];
}

/**
 *  请求lbs服务器信息
 */
+ (void)requestLbs{
    //存放lbs地址
    KUserSingleton.dictRoomGate = [NSMutableDictionary dictionary];
    KUserSingleton.dictRoomText = [NSMutableDictionary dictionary];
    KUserSingleton.dictRoomMedia = [NSMutableDictionary dictionary];
    //获取视频服务器地址
//    [BaseService get:LBS_ROOM_GATE dictionay:nil timeout:10 success:^(id responseObject)
//     {
//         NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//         NSString *strAddr = [DecodeJson getArrayAddr:strInfo];
//         [KUserSingleton.dictRoomGate setObject:strAddr forKey:@(0)];
//     }fail:nil];
    
//    [BaseService get:LBS_ROOM_MEDIA dictionay:nil timeout:10 success:^(id responseObject) {
//        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSString *strAddr = [DecodeJson getArrayAddr:strInfo];
//        [KUserSingleton.dictRoomMedia setObject:strAddr forKey:@(0)];
//    } fail:nil];
    
    //获取文字直播服务器
//    [BaseService get:LBS_ROOM_TEXT dictionay:nil timeout:10 success:^(id responseObject) {
//        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSString *strAddr = [DecodeJson getArrayAddr:strInfo];
//        [KUserSingleton.dictRoomText setObject:strAddr forKey:@(0)];
//    } fail:nil];
}

/**
 *  请求礼物的信息
 */
+ (void)requestGift{
    [BaseService post:kGift_URL dictionay:nil timeout:5 success:^(id responseObject) {
        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        [UserDefaults setObject:parameters forKey:kGiftInfo];
        [DecodeJson setGiftInfo:parameters];
    } fail:^(NSError *error) {
        
    }];
}

/**
 *  请求版本内容操作
 */
+ (void)authVersion
{
    NSString *strVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([UserDefaults objectForKey:strVersion]!=nil) {
        BOOL bStatus = [[UserDefaults objectForKey:strVersion] boolValue];
        if (bStatus) {
            KUserSingleton.nStatus = bStatus;
            return ;
        }
    }else{
        [UserDefaults setBool:0 forKey:strVersion];
    }
    __block NSString *__strVersion = strVersion;
    NSString *strLbs = [NSString stringWithFormat:@"%@%@",lbs_status,strVersion];
    [BaseService get:strLbs dictionay:nil timeout:10 success:^(id responseObject) {
         NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        if([parameters objectForKey:@"errcode"])
        {}
        else
        {
            KUserSingleton.nStatus = [[parameters objectForKey:__strVersion] intValue];
            [UserDefaults setBool:KUserSingleton.nStatus forKey:__strVersion];
            [UserDefaults synchronize];
        }
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
