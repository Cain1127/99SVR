//
//  TQMeCustomizedModel.m
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/*
 //团队ID
 string	_teamid;
 //团队名称
 string	_teamname;
 //团队头像
 string	_teamicon;
 //等级ID
 uint32	_levelid;
 //VIP等级名称
 string	_levelname;
 //到期时间
 string	_expirationdate;
 */

#import "TQMeCustomizedModel.h"
#import "DecodeJson.h"
#import "NSDate+convenience.h"

@implementation TQMeCustomizedModel

- (void)settingTime:(NSString *)_publishtime
{
    UserInfo *userinfo = [UserInfo sharedUserInfo];
    NSDate *date = [userinfo.fmt dateFromString:_publishtime];
    int result = [DecodeJson compareDate:date];
    if (result == 1)
    {
        _publishtime = [NSString stringWithFormat:@"今天 %02d:%02d",date.hour,date.minute];
    }
    else if(result == 0)
    {
        _publishtime = [NSString stringWithFormat:@"昨天 %02d:%02d",date.hour,date.minute];
    }
    else
    {
        _publishtime = [NSString stringWithFormat:@"%04d年%02d月%02d日 %02d:%02d",date.year,date.month,date.day,date.hour,date.minute];
    }
    
}


@end
