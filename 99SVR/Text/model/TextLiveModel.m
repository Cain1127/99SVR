//
//  TextLiveModel.m
//  99SVR
//
//  Created by xia zhonglin  on 1/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextLiveModel.h"
#import "DecodeJson.h"
#import "NSDate+convenience.h"
#import "UserInfo.h"

@implementation TextLiveModel

- (id)initWithMessageNotify:(CMDTextRoomLiveMessageRes_t *)notify
{
    if (self=[super init])
    {
        [self decodeMessageList:notify];
        return self;
    }
    return self;
}

- (void)decodeMessageList:(CMDTextRoomLiveMessageRes_t *)notify
{
    if (notify->pointflag)
    {
        _type = 2;
    }
    else if(notify->forecastflag)
    {
        _type = 3;
    }
    else
    {
        _type = 1;
    }
    _teacherid = notify->teacherid;
    _vcbid = notify->vcbid;
    _messageid = notify->messageid;
    _textlen = notify->textlen;
    _time = notify->messagetime;
    _strContent = [NSString stringWithCString:notify->content encoding:GBK_ENCODING];
}

- (id)initWithPointNotify:(CMDTextRoomLivePointNoty_t *)notify
{
    if (self = [super init])
    {
        [self decodePointList:notify];
        return self;
    }
    return self;
}

#pragma mark 今日重点
- (void)decodePointList:(CMDTextRoomLivePointNoty_t *)notify
{
    _vcbid = notify->vcbid;
    _userid = notify->userid;
    _time = notify->messagetime;
    _teacherid = notify->teacherid;
    _messageid = notify->messageid;
    _textlen = notify->textlen;
    _zans = notify->zans;
    _time = notify->messagetime;
    _messagetime = notify->messagetime;
    [self settingTime];
    _livetype = notify->livetype;
    char cBuf[_textlen];
    memset(cBuf, 0, _textlen);
    memcpy(cBuf,notify->content,_textlen);
    _strContent = [NSString stringWithCString:cBuf encoding:GBK_ENCODING];
    _strContent = [DecodeJson replaceEmojiString:_strContent];
    DLog(@"_messageid:%zi--strContent:%@--textlen:%d",_messageid,_strContent,_textlen);
}

- (id)initWithNotify:(CMDTextRoomLiveListNoty_t *)notify
{
    if(self = [super init])
    {
        [self decodeStruct:notify];
        return self;
    }
    return nil;
}

- (void)decodeStruct:(CMDTextRoomLiveListNoty_t *)notify
{
    //类型：1-文字直播；2-直播重点；3-明日预测（已关注的用户可查看）；4-观点；
    DLog(@"livetype:%d",notify->livetype);
    _livetype = notify->livetype;
    _strTeacherName = [NSString stringWithCString:notify->srcuseralias encoding:GBK_ENCODING];
    _teacherid = notify->teacherid;
    _vcbid = notify->vcbid;
    _userid = notify->userid;
    _messageid = notify->messageid;
    _textlen = notify->textlen;
    _destextlen = notify->destextlen;
    _zans = notify->zans;
    _messagetime = notify->messagetime;
    _viewid = notify->viewid;
    [self settingTime];
    
    char cBuf[_textlen];
    memset(cBuf, 0, _textlen);
    memcpy(cBuf,notify->content,_textlen);
    if (_livetype==4)
    {
        char cTitle[_textlen];
        memset(cTitle, 0, _textlen);
        memcpy(cTitle, notify->content, _textlen);
        
        if (_destextlen>0)
        {
            char cDest[_destextlen];
            memset(cDest, 0, _destextlen);
            memcpy(cDest, notify->content+_textlen,_destextlen);
            
            NSString *strTitle = [NSString stringWithCString:cTitle encoding:GBK_ENCODING];
            NSString *strDest = [NSString stringWithCString:cDest encoding:GBK_ENCODING];
            
            _strContent = [NSString stringWithFormat:@"<img src=\"text_live_ask_icon\" width=\"15\" height=\"15\">:%@<br><img src=\"text_live_answer_icon\" width=\"15\" height=\"15\">:%@",
                           strTitle,strDest];
            _strContent = [DecodeJson replaceEmojiString:_strContent];
        }
    }
    else if(_livetype==5)
    {
        char cTitle[_textlen];
        memset(cTitle, 0, _textlen);
        memcpy(cTitle, notify->content, _textlen);
        NSStringEncoding GBK = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        _strContent = [NSString stringWithCString:cTitle encoding:GBK];
        _strContent = [DecodeJson replaceEmojiString:_strContent];
        DLog(@"消息回复长度:%d",_textlen);
    }
    else
    {
        _strContent = [NSString stringWithCString:cBuf encoding:GBK_ENCODING];
        _strContent = [DecodeJson replaceEmojiString:_strContent];
    }
    DLog(@"_messageid:%zi--strContent:%@--textlen:%d",_messageid,_strContent,_textlen);
}

- (void)settingTime
{
    UserInfo *userinfo = [UserInfo sharedUserInfo];
    DLog(@"time:%@",NSStringFromInt64(_messagetime));
    NSDate *date = [userinfo.fmt dateFromString:NSStringFromInt64(_messagetime)];
    _strTime = [NSString stringWithFormat:@"%d:%d",date.hour,date.minute];
    
}

@end
