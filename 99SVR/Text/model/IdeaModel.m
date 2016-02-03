//
//  IdeaModel.m
//  99SVR
//
//  Created by xia zhonglin  on 1/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "IdeaModel.h"

@implementation IdeaModel

- (id)initWithIdea:(CMDTextRoomViewGroupRes_t *)resp
{
    if (self = [super init])
    {
        [self decodeIdea:resp];
        return self;
    }
    return nil;
}

- (void)decodeIdea:(CMDTextRoomViewGroupRes_t *)resp
{
    _vcbid = resp->vcbid;
    _userid = resp->userid;
    _viewtypeid = resp->viewtypeid;
    _viewtypelen = resp->viewtypelen;
    _strContent = [NSString stringWithCString:resp->viewtypename encoding:GBK_ENCODING];
}


@end
