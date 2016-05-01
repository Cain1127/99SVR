//
//  TQAnswerModel.m
//  99SVR
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/*
uint32	_id;
string	_answerauthorid;
string	_answerauthorname;
string	_answerauthoricon;
string	_answertime;
string	_answercontent;
string	_askauthorname;
uint32	_askauthorheadid;
string	_askstock;
string	_askcontent;
string	_asktime;
uint32	_fromclient;
*/
/*
 uint32	_id;
 uint32	_viewpointid;
 string	_title;
 //提问姓名
 string	_askauthorname;
 //提问内容
 uint32	_askauthorheadid;
 //提问内容
 string	_askcontent;
 //提问者时间
 string	_asktime;
 //    回答者ID
 string	_answerauthorid;
 //    回答者姓名
 string	_answerauthorname;
 //    回答者头像
 string	_answerauthoricon;
 //回答者时间
 string	_answertime;
 //回答内容
 string	_answercontent;
 uint32	_fromclient;
 */

#import "TQAnswerModel.h"
#import "DecodeJson.h"
#import "NSDate+convenience.h"


@implementation TQAnswerModel

- (id)initWithAnswer:(QuestionAnswer *)QuestionAnswer {
    
    self = [super init];
    
    _answercontent = [NSString stringWithUTF8String:QuestionAnswer->answercontent().c_str()];
//    _answerauthoricon = [NSString stringWithUTF8String:QuestionAnswer->answerauthorid().c_str()];
    _answerauthorname = [NSString stringWithUTF8String:QuestionAnswer->answerauthorname().c_str()];
    _answertime = [NSString stringWithUTF8String:QuestionAnswer->answertime().c_str()];
    _askauthorname = [NSString stringWithUTF8String:QuestionAnswer->askauthorname().c_str()];
    _askstock = [NSString stringWithUTF8String:QuestionAnswer->askstock().c_str()];
    _askcontent = [NSString stringWithUTF8String:QuestionAnswer->askcontent().c_str()];
    _asktime = [NSString stringWithUTF8String:QuestionAnswer->asktime().c_str()];
    _answerauthorhead = [NSString stringWithUTF8String:QuestionAnswer->answerauthorhead().c_str()];

    
    _userID = QuestionAnswer->id();

//    _askauthorheadid = QuestionAnswer->askauthorheadid();
    _fromclient = QuestionAnswer->fromclient();
    
    [self settingTime:_answertime];
    [self settingTime:_asktime];

    return self;
}

- (id)initWithRplay:(MailReply *)MailReply;
{
    self = [super init];
    
    _answercontent = [NSString stringWithUTF8String:MailReply->answercontent().c_str()];
    
    _answerauthorid = [NSString stringWithUTF8String:MailReply->answerauthorid().c_str()];
    
    _answerauthorname = [NSString stringWithUTF8String:MailReply->answerauthorname().c_str()];
    _answertime = [NSString stringWithUTF8String:MailReply->answertime().c_str()];
    _askauthorname = [NSString stringWithUTF8String:MailReply->askauthorname().c_str()];
    //    _askstock = [NSString stringWithUTF8String:MailReply->askstock().c_str()];
    _askcontent = [NSString stringWithUTF8String:MailReply->askcontent().c_str()];
    _asktime = [NSString stringWithUTF8String:MailReply->asktime().c_str()];
    _answerauthorhead = [NSString stringWithUTF8String:MailReply->answerauthorhead().c_str()];

    
    _userID = MailReply->id();
    _fromclient = MailReply->fromclient();
    
    [self settingTime:_answertime];
    [self settingTime:_asktime];
    
    return self;
}

- (void)settingTime:(NSString *)_publishtime
{
    UserInfo *userinfo = [UserInfo sharedUserInfo];
    NSDate *date = [userinfo.fmt dateFromString:_publishtime];
    int result = [DecodeJson compareDate:date];
    if (result == 1)
    {
        _answertime = [NSString stringWithFormat:@"今天 %02d:%02d",date.hour,date.minute];
    }
    else if(result == 0)
    {
        _answertime = [NSString stringWithFormat:@"昨天 %02d:%02d",date.hour,date.minute];
    }
    else
    {
        _answertime = [NSString stringWithFormat:@"%04d年%02d月%02d日 %02d:%02d",date.year,date.month,date.day,date.hour,date.minute];
    }
    
}





@end
