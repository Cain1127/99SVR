//
//  HistoryTextModel.h
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cmd_vchat.h"


@interface HistoryTextModel : NSObject

@property (nonatomic) int32_t vcbid;
@property (nonatomic) int32_t userid;
@property (nonatomic) int32_t teacherid;
@property (nonatomic) int32_t srcuserid;//互动id
@property (nonatomic,copy) NSString *srcName;//互动昵称
@property (nonatomic) int64_t msgid;
@property (nonatomic) int type;
@property (nonatomic) short textlen;
@property (nonatomic) short destextlen;
@property (nonatomic) int64_t zans;
@property (nonatomic,copy) NSString *strContent;

- (id)initWithHistoryText:(CMDTextRoomLiveListNoty_t *)resp;

@end
