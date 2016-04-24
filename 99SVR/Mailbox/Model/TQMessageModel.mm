//
//  TQMessageModel.m
//  99SVR
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/*
 uint32	_id;
 string	_title;
 string	_content;
 string	_publishtime;
 */

#import "TQMessageModel.h"
#import "DecodeJson.h"
#import "NSDate+convenience.h"

@implementation TQMessageModel
- (id)initWithSystemMessage:(SystemMessage *)SystemMessage
{
    self = [super init];
    
    _content = [NSString stringWithUTF8String:SystemMessage->content().c_str()];
    
    _titile = [NSString stringWithUTF8String:SystemMessage->title().c_str()];
    
    _publishtime = [NSString stringWithUTF8String:SystemMessage->publishtime().c_str()];
    
    
    _userID = SystemMessage->id();
    
    
    [self settingTime];

    
    return self;
}

- (void)settingTime
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
