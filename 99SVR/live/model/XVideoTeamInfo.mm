//
//  XVideoTeamInfo.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XVideoTeamInfo.h"
#include "HttpMessage.pb.h"

@implementation XVideoModel

- (id)initWithInfo:(void*)pData
{
    self = [super init];
    VideoInfo *info = (VideoInfo *)pData;
    
    _picurl = [NSString stringWithUTF8String:info->picurl().c_str()];
    _name = [NSString stringWithUTF8String:info->name().c_str()];
    _videourl = [NSString stringWithUTF8String:info->videourl().c_str()];
    
    _nId = info->id();
    
    return self;
}
@end


@implementation XVideoTeamInfo

@end
