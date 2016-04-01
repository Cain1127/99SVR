//
//  IdeaDetailRePly.m
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//
#import "IdeaDetailRePly.h"
#import "UserInfo.h"
#import "NSDate+convenience.h"
#import "DecodeJson.h"

@implementation IdeaDetailRePly

- (id)initWithIdeaRePly:(CMDTextRoomViewInfoRes_t*)resp
{
    if (self = [super init])
    {
        [self decodeResp:resp];
        return self;
    }
    return nil;
}

- (void)decodeResp:(CMDTextRoomViewInfoRes_t *)resp
{
    _vcbid = resp->vcbid;
    _userid = resp->userid;
    _strSrcName = [NSString stringWithCString:resp->srcuseralias encoding:GBK_ENCODING];
    _viewId = resp->viewid;
    _commentid = resp->commentid;
    _strName = [NSString stringWithCString:resp->useralias encoding:GBK_ENCODING];
    _srcinteractid = resp->srcinteractid;
    _messageTime = resp->messagetime;
    _viewuserid = resp->viewuserid;
    _viewuserid = resp->viewuserid;
    _textLen = resp->textlen;
    NSDate *date = [[UserInfo sharedUserInfo].fmt dateFromString:NSStringFromInt64(_messageTime)];
    int result = [DecodeJson compareDate:date];
    
    if (result == 1)
    {
        _time = [NSString stringWithFormat:@"今天 %02d:%02d",date.hour,date.minute];
    }
    else if(result == 0)
    {
        _time = [NSString stringWithFormat:@"昨天 %02dd:%02d",date.hour,date.minute];
    }
    else
    {
        _time = [NSString stringWithFormat:@"%02dd%02d日 %02d:%02d",date.month,date.day,date.hour,date.minute];
    }
    
    char cBuf[_textLen];
    memcpy(cBuf,resp->content,_textLen);
    _strContent = [NSString stringWithCString:cBuf encoding:GBK_ENCODING];
    _strContent = [DecodeJson replaceEmojiString:_strContent];
}

- (void)setTimeInfo
{
    NSDate *date = [NSDate date];
    
    int result = [DecodeJson compareDate:date];
    
    if (result == 1)
    {
        _time = [NSString stringWithFormat:@"今天 %02d:%02d",date.hour,date.minute];
    }
    else if(result == 0)
    {
        _time = [NSString stringWithFormat:@"昨天 %02dd:%02d",date.hour,date.minute];
    }
    else
    {
        _time = [NSString stringWithFormat:@"%02dd%02d日 %02d:%02d",date.month,date.day,date.hour,date.minute];
    }
}

@end
