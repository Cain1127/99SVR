//
//  HistoryTextModel.m
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HistoryTextModel.h"
#import "DecodeJson.h"

@implementation HistoryTextModel

- (id)initWithHistoryText:(CMDTextRoomLiveListNoty_t *)resp
{
    if (self = [super init])
    {
        [self decodeHistory:resp];
        return self;
    }
    return nil;
}

- (void)decodeHistory:(CMDTextRoomLiveListNoty_t *)resp
{
    _vcbid = resp->vcbid;
    _teacherid = resp->teacherid;
    _textlen = resp->textlen;
    _destextlen = resp->destextlen;
    _srcuserid = resp->srcuserid;
    _srcName = [NSString stringWithCString:resp->srcuseralias encoding:GBK_ENCODING];
    _zans = resp->zans;
    _msgid = resp->messageid;
    _strContent = [NSString stringWithCString:resp->content encoding:GBK_ENCODING];
    _strContent = [DecodeJson replaceEmojiString:_strContent];
}

@end
