//
//  IdeaDetailRePly.m
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//
#import "IdeaDetailRePly.h"

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
//    _reqcommentstype = resp->reqcommentstype;
    _srcinteractid = resp->srcinteractid;
    char cBuf[_textLen];
    memcpy(cBuf,resp->content,_textLen);
    _strContent = [NSString stringWithCString:cBuf encoding:GBK_ENCODING];
    
}

@end
