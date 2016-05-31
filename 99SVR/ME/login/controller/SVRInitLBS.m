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
#import "SVRMediaClient.h"

@implementation SVRInitLBS

+ (void)loadAllInfo
{
    [SVRInitLBS authVersion];
    //获取登录服务器地址
    [SVRInitLBS loginLocal];
    
    [SVRInitLBS requestGift];
}

+ (void)initMediaSDK
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [[SVRMediaClient sharedSVRMediaClient] clientCoreInit:1];
        [[SVRMediaClient sharedSVRMediaClient] clientCoreInit:0];
    });
}

/**
 *  请求lbs服务器信息
 */
+ (void)requestLbs
{

}

/**
 *  请求礼物的信息
 */
+ (void)requestGift
{
    [BaseService post:kGift_URL dictionay:nil timeout:5 success:^(id responseObject) {
        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        [UserDefaults setObject:parameters forKey:kGiftInfo];
        [DecodeJson setGiftInfo:parameters];
    } fail:^(NSError *error)
    {}];
}

/**
 *  请求版本内容操作
 */
+ (void)authVersion
{
    NSString *strVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([UserDefaults objectForKey:strVersion]!=nil)
    {
        BOOL bStatus = [[UserDefaults objectForKey:strVersion] boolValue];
        if (bStatus) {
            KUserSingleton.nStatus = bStatus;
            return ;
        }
    }else
    {
        [UserDefaults setBool:0 forKey:strVersion];
    }
    __block NSString *__strVersion = strVersion;
    
    NSString *strLbs = [NSString stringWithFormat:@"%@%@",lbs_status,strVersion];
    [BaseService get:strLbs dictionay:nil timeout:5 success:^(id responseObject) {
         NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        if([parameters objectForKey:@"errcode"])
        {}
        else
        {
            KUserSingleton.nStatus = [[parameters objectForKey:__strVersion] intValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_VERSION_UPDATE_VC object:nil];
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
