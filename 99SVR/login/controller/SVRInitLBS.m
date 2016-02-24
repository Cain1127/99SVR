//
//  SVRInitLBS.m
//  99SVR
//
//  Created by xia zhonglin  on 1/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "SVRInitLBS.h"
#import "BaseService.h"
#import "LSTcpSocket.h"
#import "DecodeJson.h"
#import "UserInfo.h"

@implementation SVRInitLBS

+ (void)load
{
    //获取登录服务器地址
    __weak UserInfo *__userInfo = [UserInfo sharedUserInfo];
    __weak LSTcpSocket *__lsTcp = [LSTcpSocket sharedLSTcpSocket];
    [BaseService getJSONWithUrl:@"http://lbs1.99ducaijing.cn:2222/tygetweb" parameters:nil success:^(id responseObject) {
        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([strInfo rangeOfString:@"|"].location != NSNotFound)
        {
            NSString *strResult = [strInfo componentsSeparatedByString:@"|"][0];
            if (strResult.length>=2)
            {
                NSString *strWeb = [strResult substringWithRange:NSMakeRange(2,[strResult length]-3)];
                __userInfo.strWebAddr  = strWeb;
                BOOL isLogin = [UserDefaults boolForKey:kIsLogin];
                if (isLogin)
                {
                    __userInfo.nUserId = [[UserDefaults objectForKey:kUserId] intValue];
                    NSString *userPwd = [UserDefaults objectForKey:kUserPwd];
                    if(userPwd)
                    {
                        __userInfo.strMd5Pwd = [DecodeJson XCmdMd5String:userPwd];
                        __userInfo.strPwd = userPwd;
                    }
                    [__lsTcp setUserInfo];
                    [__lsTcp loginServer:[UserDefaults objectForKey:kUserId] pwd:[UserDefaults objectForKey:kUserPwd]];
                }
                else
                {
                    [[LSTcpSocket sharedLSTcpSocket] loginServer:@"0" pwd:@""];
                }
            }
        }
    }fail:nil];
    //获取房间地址
    [BaseService getJSONWithUrl:@"http://lbs1.99ducaijing.cn:2222/tygetgate" parameters:nil success:^(id responseObject)
    {
        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        __userInfo.strRoomAddr = strInfo;
    }
    fail:nil];
}

@end
