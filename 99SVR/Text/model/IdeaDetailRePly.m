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

- (id)initWithIdeaRePly:(CMDTextRoomViewInfoRes_t*)resp teachId:(int)teacherId
{
    if (self = [super init])
    {
        [self decodeResp:resp teachId:teacherId];
        return self;
    }
    return nil;
}

- (void)decodeResp:(CMDTextRoomViewInfoRes_t *)resp teachId:(int)teachId
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
    _textLen = resp->textlen;
    
    NSDate *date = [[UserInfo sharedUserInfo].fmt dateFromString:NSStringFromInt64(_messageTime)];
    int result = [DecodeJson compareDate:date];
    
    DLog(@"user:%d--viewuserid:%d--_srcinteractid:%lld",_userid,_viewuserid,_srcinteractid);
    if (result == 1)
    {
        _time = [NSString stringWithFormat:@"今天 %02d:%02d",date.hour,date.minute];
    }
    else if(result == 0)
    {
        _time = [NSString stringWithFormat:@"昨天 %02d:%02d",date.hour,date.minute];
    }
    else
    {
        _time = [NSString stringWithFormat:@"%02d月%02d日 %02d:%02d",date.month,date.day,date.hour,date.minute];
    }
    char cBuffer[_textLen+_textLen];
    memset(cBuffer, 0, _textLen+_textLen);
    memcpy(cBuffer, resp->content, _textLen);
    _strContent = [NSString stringWithCString:cBuffer encoding:GBK_ENCODING];
    
    //构建from
    char cFrom[200];
    memset(cFrom, 0, 200);
    sprintf(cFrom,"<a href=\"sqchatid://%d,%s,%lld\" style=\"color:#0078DD\">%s</a>",
            _viewuserid,[_strName UTF8String],_commentid,[_strName UTF8String]);
    NSString *strFrom = [NSString stringWithUTF8String:cFrom];
    if (_srcinteractid!=0) {
//        _strContent = [NSString stringWithFormat:@"<p style=\"line-height:10px\">%@ 回复 <a href=\"sqchatid://%lld,%@\" style=\"color:#0078DD\">%@</a><p>%@</p></p>",strFrom,_srcinteractid,_strSrcName,_strSrcName,_strContent];
        _strContent = [NSString stringWithFormat:@"<p style=\"line-height:10px\">%@ 回复 <span style=\"color:#919191\">%@</span><p>%@</p></p>",
                       strFrom,_strSrcName,_strContent];
    }else{
        _strContent = [NSString stringWithFormat:@"<p style=\"line-height:10px\">%@<p>%@</p></p>",strFrom,_strContent];
    }
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
        _time = [NSString stringWithFormat:@"昨天 %02d:%02d",date.hour,date.minute];
    }
    else
    {
        _time = [NSString stringWithFormat:@"%02d月%02d日 %02d:%02d",date.month,date.day,date.hour,date.minute];
    }
}

@end
