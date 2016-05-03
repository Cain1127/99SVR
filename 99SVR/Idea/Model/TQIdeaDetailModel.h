//
//  TQIdeaDetailModel.h
//  99SVR
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpMessage.pb.h"

@interface TQIdeaDetailModel : NSObject

@property (nonatomic,copy) NSString *roomid;
@property (nonatomic,copy) NSString *authorId;
@property (nonatomic,copy) NSString *authorname;
@property (nonatomic,copy) NSString *authoricon;
@property (nonatomic,copy) NSString *publishtime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic) int replycount;
@property (nonatomic) int giftcount;
@property (nonatomic) int viewpointid;

- (id)initWithViewpointDetail:(ViewpointDetail *)details;
//OnExpertNewViewNoty
- (id)initWithNewViewNoty:(void *)details;

@end
