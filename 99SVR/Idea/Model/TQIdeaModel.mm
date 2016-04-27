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

@implementation TQIdeaModel

//- (id)initWithViewpointSummary:(ViewpointSummary *)viewPoint
//{
//    self = [super init];
//    
//    _authorid = [NSString stringWithUTF8String:viewPoint->authorid().c_str()];
//    
//    _authoricon = [NSString stringWithUTF8String:viewPoint->authoricon().c_str()];
//    
//    _authorname = [NSString stringWithUTF8String:viewPoint->authorname().c_str()];
//    
//    _publishtime = [NSString stringWithUTF8String:viewPoint->publishtime().c_str()];
//    
//    _content = [NSString stringWithUTF8String:viewPoint->content().c_str()];
//    
//    _replycount = viewPoint->replycount();
//    
//    _giftcount = viewPoint->giftcount();
//    
//    _viewpointid = viewPoint->viewpointid();
//    
//    [self settingTime];
//    
//    return self;
//}

//- (void)settingTime
//{
//    UserInfo *userinfo = [UserInfo sharedUserInfo];
//    NSDate *date = [userinfo.fmt dateFromString:_publishtime];
//    int result = [DecodeJson compareDate:date];
//    if (result == 1)
//    {
//        _publishtime = [NSString stringWithFormat:@"今天 %02d:%02d",date.hour,date.minute];
//    }
//    else if(result == 0)
//    {
//        _publishtime = [NSString stringWithFormat:@"昨天 %02d:%02d",date.hour,date.minute];
//    }
//    else
//    {
//        _publishtime = [NSString stringWithFormat:@"%04d年%02d月%02d日 %02d:%02d",date.year,date.month,date.day,date.hour,date.minute];
//    }
//}

@end
