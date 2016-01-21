//
//  UserInfo.m
//  99SVR
//
//  Created by xia zhonglin  on 12/9/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "UserInfo.h"
#import "RoomUser.h"

@implementation UserInfo

DEFINE_SINGLETON_FOR_CLASS(UserInfo)

- (NSString *)getVipDescript
{
    NSDictionary *male = @{
                           @3 : @"爵士",
                           @4 : @"男爵",
                           @5 : @"子爵",
                           @6 : @"勋爵",
                           @7 : @"伯爵",
                           @9 : @"侯爵",
                           @10 : @"公爵",
                           @11 : @"国王",
                           @12 : @"至尊"
                           };
    NSDictionary *female = @{
                           @3 : @"婕妤",
                           @4 : @"昭媛",
                           @5 : @"昭仪",
                           @6 : @"郡主",
                           @7 : @"公主",
                           @9 : @"贤妃",
                           @10 : @"德妃",
                           @11 : @"淑妃",
                           @12 : @"贵妃"
                           };
    NSString *str = nil;
    if (_sex == 1) {
        str = male[@(_m_nVipLevel)];
        if (str == nil) {
            str = male[@3];
        }
    } else {
        str = [UserInfo sharedUserInfo].strName;
        if (str == nil) {
            str = female[@3];
        }
    }
    return str;
}

@end

@implementation RoomKey



@end

