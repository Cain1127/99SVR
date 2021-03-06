//
//  TQIdeaModel.m
//  99SVR
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQIdeaModel.h"
#import "NSDate+convenience.h"
#import "DecodeJson.h"
#include "HttpMessage.pb.h"
#include "VideoRoomMessage.pb.h"
@implementation TQIdeaModel


- (id)initWIthNewPointNotify:(void *)pData
{
    self = [super init];
    ExpertNewViewNoty *notify = (ExpertNewViewNoty *)pData;
    
    _roomid = NSStringFromInt(notify->nvcbid());
    
    _authoricon = [NSString stringWithUTF8String:notify->sicon().c_str()];
    //字符 gbkEncoding 进行解码
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [NSString stringWithCString:notify->sname().c_str() encoding:gbkEncoding];
    _authorname = string;
    
    _publishtime = [NSString stringWithUTF8String:notify->spublictime().c_str()];
    
    _content = [NSString stringWithUTF8String:notify->content().c_str()];
    
    _replycount = notify->ncommentcnt();
    
    _giftcount = notify->nflowercnt();
    
    _viewpointid = notify->nmessageid();
    
    return self;
}

- (id)initWithViewpointSummary:(void *)pData
{
    self = [super init];
    
    ViewpointSummary *viewPoint = (ViewpointSummary *)pData;
    
    _authorid = NSStringFromInt(viewPoint->authorid());
    
    _roomid = NSStringFromInt(viewPoint->roomid());
    
    _title = [NSString stringWithUTF8String:viewPoint->title().c_str()];
    
    _authoricon = [NSString stringWithUTF8String:viewPoint->authoricon().c_str()];
    
    _authorname = [NSString stringWithUTF8String:viewPoint->authorname().c_str()];
    
    _publishtime = [NSString stringWithUTF8String:viewPoint->publishtime().c_str()];
    
    _content = [NSString stringWithUTF8String:viewPoint->content().c_str()];
    
    _replycount = viewPoint->replycount();
    
    _giftcount = viewPoint->giftcount();
    
    _viewpointid = viewPoint->viewpointid();
    
//    [self settingTime];
    
    return self;
}

- (void)settingTime
{
    UserInfo *userinfo = [UserInfo sharedUserInfo];
    NSDate *date = [userinfo.fmt dateFromString:_publishtime];
    int result = [DecodeJson compareDate:date];
    if (result == 1)
    {
        _publishtime = [NSString stringWithFormat:@"今天 %02d:%02d",date.hour,date.minute];
    }
    else if(result == 0)
    {
        _publishtime = [NSString stringWithFormat:@"昨天 %02d:%02d",date.hour,date.minute];
    }
    else
    {
        _publishtime = [NSString stringWithFormat:@"%04d年%02d月%02d日 %02d:%02d",date.year,date.month,date.day,date.hour,date.minute];
    }
}

@end
