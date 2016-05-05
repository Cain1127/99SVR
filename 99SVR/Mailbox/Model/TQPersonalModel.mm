//
//  TQPersonalModel.m
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/*uint32	_id;
string	_title;
string	_summary;
string	_publishtime;
string	_teamname;
*/

#import "TQPersonalModel.h"
#import "DecodeJson.h"
#import "NSDate+convenience.h"

@implementation TQPersonalModel

- (id)initWithMyPrivateService:(PrivateServiceSummary *)PrivateServiceSummary {

    self = [super init];
    
    self.summary = [NSString stringWithUTF8String:PrivateServiceSummary->summary().c_str()];
    self.title = [NSString stringWithUTF8String:PrivateServiceSummary->title().c_str()];
    self.publishtime = [NSString stringWithUTF8String:PrivateServiceSummary->publishtime().c_str()];
    self.teamname = [NSString stringWithUTF8String:PrivateServiceSummary->teamname().c_str()];
    self.ID = PrivateServiceSummary->id();

    return self;
}

-(void)setPublishtime:(NSString *)publishtime
{
    _publishtime = [publishtime DataFormatter];
}

@end
