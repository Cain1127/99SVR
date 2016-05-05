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

- (id)initWithAnswer:(QuestionAnswer *)QuestionAnswer
{
    self = [super init];
    
    self.answercontent = [NSString stringWithUTF8String:QuestionAnswer->answercontent().c_str()];
    self.answerauthorname = [NSString stringWithUTF8String:QuestionAnswer->answerauthorname().c_str()];
    self.answertime = [NSString stringWithUTF8String:QuestionAnswer->answertime().c_str()];
    self.askauthorname = [NSString stringWithUTF8String:QuestionAnswer->askauthorname().c_str()];
    self.askstock = [NSString stringWithUTF8String:QuestionAnswer->askstock().c_str()];
    self.askcontent = [NSString stringWithUTF8String:QuestionAnswer->askcontent().c_str()];
    self.asktime = [NSString stringWithUTF8String:QuestionAnswer->asktime().c_str()];
    self.answerauthorhead = [NSString stringWithUTF8String:QuestionAnswer->answerauthorhead().c_str()];
    self.ID = QuestionAnswer->id();
    self.askAuthorHead = [NSString stringWithUTF8String:QuestionAnswer->askauthorhead().c_str()];
    self.fromclient = QuestionAnswer->fromclient();
  
    return self;
}

- (id)initWithRplay:(MailReply *)MailReply;
{
    self = [super init];
    self.answercontent = [NSString stringWithUTF8String:MailReply->answercontent().c_str()];
    self.answerauthorid = [NSString stringWithUTF8String:MailReply->answerauthorid().c_str()];
    self.answerauthorname = [NSString stringWithUTF8String:MailReply->answerauthorname().c_str()];
    self.answertime = [NSString stringWithUTF8String:MailReply->answertime().c_str()];
    self.askauthorname = [NSString stringWithUTF8String:MailReply->askauthorname().c_str()];
    self.askcontent = [NSString stringWithUTF8String:MailReply->askcontent().c_str()];
    self.asktime = [NSString stringWithUTF8String:MailReply->asktime().c_str()];
    self.answerauthorhead = [NSString stringWithUTF8String:MailReply->answerauthorhead().c_str()];
    self.ID = MailReply->id();
    self.fromclient = MailReply->fromclient();
    return self;
}

@end
