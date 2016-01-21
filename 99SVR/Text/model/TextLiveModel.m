//
//  TextLiveModel.m
//  99SVR
//
//  Created by xia zhonglin  on 1/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextLiveModel.h"

@implementation TextLiveModel

- (id)initWIthMessageNotify:(CMDTextRoomLiveMessageRes_t *)notify
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
    if (self = [super init]) {
        return self;
    }
    return self;
}

- (void)decodePointList:(CMDTextRoomLivePointNoty_t *)notify
{
    _vcbid = notify->vcbid;
    _userid = notify->userid;
    _type = notify->type;
    _time = notify->messagetime;
    _teacherid = notify->teacherid;
    _messageid = notify->messageid;
    _textlen = notify->textlen;
    _zans = notify->zans;
    _time = notify->messagetime;
    _strContent = [NSString stringWithCString:notify->content encoding:GBK_ENCODING];
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
        
        if(notify->livetype==5)
        {
            _type = 4;
        }
        else
        {
            _type = 1;
        }
    }
    _strTeacherName = [NSString stringWithCString:notify->srcuseralias encoding:GBK_ENCODING];
    _teacherid = notify->teacherid;
    _vcbid = notify->vcbid;
    _userid = notify->userid;
    _messageid = notify->messageid;
    _textlen = notify->textlen;
    _destextlen = notify->destextlen;
    _zans = notify->zans;
    _time = notify->messagetime;
    _strContent = [NSString stringWithCString:notify->content encoding:GBK_ENCODING];
}

@end
