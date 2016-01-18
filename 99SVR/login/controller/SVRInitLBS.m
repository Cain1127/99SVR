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
    [BaseService getJSONWithUrl:@"http://lbs1.99ducaijing.cn:2222/tygetweb" parameters:nil success:^(id responseObject) {
        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *strResult = [strInfo componentsSeparatedByString:@"|"][0];
        NSString *strWeb = [strResult substringWithRange:NSMakeRange(2,[strResult length]-3)];
        [UserInfo sharedUserInfo].strWebAddr = strWeb;
        BOOL isLogin = [UserDefaults boolForKey:kIsLogin];
        if (isLogin)
        {
            [UserInfo sharedUserInfo].nUserId = [[UserDefaults objectForKey:kUserId] intValue];
            NSString *userPwd = [UserDefaults objectForKey:kUserPwd];
            [UserInfo sharedUserInfo].strPwd = userPwd;
            [UserInfo sharedUserInfo].strMd5Pwd = [DecodeJson XCmdMd5String:userPwd];
            [[LSTcpSocket sharedLSTcpSocket] setUserInfo];
            [[LSTcpSocket sharedLSTcpSocket] loginServer:[UserDefaults objectForKey:kUserId]
                                                     pwd:[UserDefaults objectForKey:kUserPwd]];
        }
        else
        {
            [[LSTcpSocket sharedLSTcpSocket] loginServer:@"0" pwd:@""];
        }
    }fail:nil];
    
    //获取房间地址
    [BaseService getJSONWithUrl:@"http://lbs1.99ducaijing.cn:2222/tygetgate" parameters:nil success:^(id responseObject)
    {
        NSString *strInfo = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [UserInfo sharedUserInfo].strRoomAddr = strInfo;
        DLog(@"strInfo:%@",strInfo);
    } fail:nil];
    DLog(@"加载lbs数据");
}

@end
