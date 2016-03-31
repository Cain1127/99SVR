//
//  IdeaDetails.m
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "IdeaDetails.h"
#import "UserInfo.h"
#import "NSDate+convenience.h"
#import "DecodeJson.h"

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
    [self settingTime];
    
    char cTitle[_viewTitleLen*2];
    memset(cTitle, 0, _viewTitleLen*2);
    memcpy(cTitle,resp->content,_viewTitleLen);
    DLog(@"cTitle:%s",cTitle);
    
    _strTitle = [NSString stringWithCString:cTitle encoding:GBK_ENCODING];
    DLog(@"title:%@",_strTitle);
    
    char cContent[_viewTextLen*2];
    memset(cContent,0, _viewTextLen*2);
    memcpy(cContent,resp->content+_viewTitleLen,_viewTextLen);
    _strContent = [NSString stringWithCString:cContent encoding:GBK_ENCODING];
    
    NSString *strInfo = [NSString stringWithCString:resp->content encoding:GBK_ENCODING];
    DLog(@"整条观点:%@",strInfo);
}
- (void)settingTime
{
    UserInfo *userinfo = [UserInfo sharedUserInfo];
    NSDate *date = [userinfo.fmt dateFromString:NSStringFromInt64(_messageTime)];
    int result = [DecodeJson compareDate:date];
    if (result == 1)
    {
        _strTime = [NSString stringWithFormat:@"今天 %zi:%zi:%zi",date.hour,date.minute,date.second];
    }
    else if(result == 0)
    {
        _strTime = [NSString stringWithFormat:@"昨天 %zi:%zi:%zi",date.hour,date.minute,date.second];
    }
    else
    {
        _strTime = [NSString stringWithFormat:@"%d年%d月%d日 %d:%d:%d",date.year,date.month,date.day,date.hour,date.minute,date.second];
    }
}
@end
