//
//  TQPersonalModel.m
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/*uint32	_id;
string	_title;
string	_summary;
string	_publishtime;
string	_teamname;
*/

#import "TQPersonalModel.h"
#import "DecodeJson.h"
#import "NSDate+convenience.h"

@implementation TQPersonalModel

- (id)initWithMyPrivateService:(PrivateServiceSummary *)PrivateServiceSummary {

    self = [super init];
    
    _summary = [NSString stringWithUTF8String:PrivateServiceSummary->summary().c_str()];
    _title = [NSString stringWithUTF8String:PrivateServiceSummary->title().c_str()];
    _publishtime = [NSString stringWithUTF8String:PrivateServiceSummary->publishtime().c_str()];
    _teamname = [NSString stringWithUTF8String:PrivateServiceSummary->teamname().c_str()];

    _ID = PrivateServiceSummary->id();
    
    
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
