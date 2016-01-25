//
//  ChatReplyModel.m
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ChatReplyModel.h"

@implementation ChatReplyModel

- (id)initWithChatResp:(CMDTextLiveChatReplyRes_t *)resp
{
    if (self = [super init])
    {
        [self decodeChatResp:resp];
        return self;
    }
    return nil;
}

- (id)initWIthChatReplyResp:(CMDTextRoomLiveChatRes_t*)resp
{
    if (self = [super init])
    {
        [self decodeChat:resp];
        return self;
    }
    return nil;
}

- (void)decodeChat:(CMDTextRoomLiveChatRes_t *)resp
{
    _type = 1;
    _vcbid = resp->vcbid;
    _fromid = resp->srcid;
    _strFromName = [[NSString alloc] initWithCString:resp->srcalias encoding:GBK_ENCODING];
    _toid = resp->toid;
    _strToName = [[NSString alloc] initWithCString:resp->toalias encoding:GBK_ENCODING];
    _toHeadId = resp->toheadid;
    _messageTime = resp->messagetime;
    _reqTextlen = resp->textlen;
    _strContent = [[NSString alloc] initWithCString:resp->content encoding:GBK_ENCODING];
}

- (void)decodeChatResp:(CMDTextLiveChatReplyRes_t *)resp
{
    _type = 2;
    _vcbid = resp->vcbid;
    _fromid = resp->fromid;
    _fromheadid = resp->fromheadid;
    _strFromName = [[NSString alloc] initWithCString:resp->fromalias encoding:GBK_ENCODING];
    _toid = resp->toid;
    _strToName = [[NSString alloc] initWithCString:resp->toalias encoding:GBK_ENCODING];
    _toHeadId = resp->toheadid;
    _messageTime = resp->messagetime;
    _reqTextlen = resp->reqtextlen;
    _resTextLen = resp->restextlen;
    _strContent = [[NSString alloc] initWithCString:resp->content encoding:GBK_ENCODING];
}

@end
