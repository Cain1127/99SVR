//
//  TQMessageModel.m
//  99SVR
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/*
 uint32	_id;
 string	_title;
 string	_content;
 string	_publishtime;
 */

#import "TQMessageModel.h"
#import "DecodeJson.h"
#import "NSDate+convenience.h"

@implementation TQMessageModel

- (id)initWithSystemMessage:(SystemMessage *)SystemMessage
{
    self = [super init];
    self.Id = SystemMessage->id();
    self.content = [NSString stringWithUTF8String:SystemMessage->content().c_str()];
    self.title = [NSString stringWithUTF8String:SystemMessage->title().c_str()];
    self.publishtime = [NSString stringWithUTF8String:SystemMessage->publishtime().c_str()];
    self.userID = SystemMessage->id();
    return self;
}

- (void)setPublishtime:(NSString *)publishtime
{
    _publishtime = [publishtime DataFormatter];
}

@end
