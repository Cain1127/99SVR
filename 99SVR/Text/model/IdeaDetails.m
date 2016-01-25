//
//  IdeaDetails.m
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "IdeaDetails.h"

@implementation IdeaDetails

- (id)initWithIdeaDetails:(CMDTextRoomLiveViewRes_t *)resp
{
    if (self = [super init])
    {
        [self decodeDetails:resp];
        return self;
    }
    return nil;
}

- (void)decodeDetails:(CMDTextRoomLiveViewRes_t *)resp
{
    _vcbid = resp->vcbid;
    _userid = resp->userid;
    _messageid = resp->viewid;
    _liveType = resp->livetype;
    _viewTitleLen = resp->viewTitlelen;
    _viewTextLen = resp->viewtextlen;
    _messageTime = resp->messagetime;
    _looks = resp->looks;
    _zans = resp->zans;
    _flowers = resp->flowers;
    _comments = resp->comments;
    _strContent = [NSString stringWithCString:resp->content encoding:GBK_ENCODING];
    
}

@end
