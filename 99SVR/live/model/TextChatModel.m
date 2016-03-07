//
//  TextChatModel.m
//  99SVR
//
//  Created by xia zhonglin  on 3/2/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextChatModel.h"
#import "DecodeJson.h"
@implementation TextChatModel

- (id)initWithtextChat:(CMDTextRoomLiveChatRes_t *)resp
{
    self = [super init];
    _vcbid = resp->vcbid;
    _srcid = resp->srcid;
    _fromNick = [NSString stringWithCString:resp->srcalias encoding:GBK_ENCODING];
    _toNick = [NSString stringWithCString:resp->toalias encoding:GBK_ENCODING];
    _srcheadid = resp->srcheadid;
    _toid = resp->toid;
    _toheadid = resp->toheadid;
    _msgtype = resp->msgtype;
    _messagetime = resp->messagetime;
    _textlen = resp->textlen;
    _commentstype = resp->commentstype;
    _content = [NSString stringWithCString:resp->content encoding:GBK_ENCODING];
    
    _content = [DecodeJson replaceEmojiString:_content];
    _content = [NSString stringWithFormat:@"%@对%@:%@",_fromNick,_toNick,_content];
    
    
    return self;
}

@end
