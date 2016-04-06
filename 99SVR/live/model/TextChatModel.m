//
//  TextChatModel.m
//  99SVR
//
//  Created by xia zhonglin  on 3/2/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextChatModel.h"
#import "DecodeJson.h"
#import "UserInfo.h"
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
    _content = [DecodeJson replaceEmojiNewString:_content];
    NSString *strFrom;
    NSString *strTo;
    if (_toid!=0) {
        strFrom = [self getUserInfo:_fromNick user:_srcid name:_fromNick];
        strTo = [self getUserInfo:_toNick user:_toid name:_toNick];
        
        _content = [NSString stringWithFormat:@"<span style=\"line-height:5px\">%@ 回复 %@ <br>%@</span>",strFrom,strTo,_content];
    }
    else{
        strFrom = [self getUserInfo:_fromNick user:_srcid name:_fromNick];
        _content = [NSString stringWithFormat:@"<span style=\"ine-height:5px\">%@</span><br><span style=\"color:#4c4c4c\">%@</span>",strFrom,_content];
    }
    return self;
}

- (NSString *)getUserInfo:(NSString *)strMsg user:(int)userid name:(NSString *)strName
{
    if (userid == [UserInfo sharedUserInfo].nUserId) {
        NSString *strFrom = [NSString stringWithFormat:@"<a style=\"color:#919191\" href=\"sqchatid://%d\">%@</a>",_srcid,strName];
        return strFrom;
    }
    else
    {
        return [NSString stringWithFormat:@"<a style=\"color:#919191\" href=\"sqchatid://%d,%@\">%@</a>",userid,strName,strName];
    }
}

@end
