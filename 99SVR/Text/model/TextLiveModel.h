//
//  TextLiveModel.h
//  99SVR
//
//  Created by xia zhonglin  on 1/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmd_vchat.h"

@interface TextLiveModel : NSObject

@property (nonatomic) UInt32 vcbid;
@property (nonatomic) UInt32 userid;
@property (nonatomic) UInt32 teacherid;
@property (nonatomic,copy) NSString *strUserName;
@property (nonatomic,copy) NSString *strTeacherName;
@property (nonatomic) short type;
@property (nonatomic) short textlen;
@property (nonatomic) short destextlen;
@property (nonatomic) uint64_t time;
@property (nonatomic) int64_t zans;
@property (nonatomic,copy) NSString *strContent;
@property (nonatomic) int64_t messageid;
@property (nonatomic) int64 totalzans;
@property (nonatomic) int64  flowers;
@property (nonatomic) BOOL bZan;

- (id)initWithNotify:(CMDTextRoomLiveListNoty_t *)notify;
- (id)initWithPointNotify:(CMDTextRoomLivePointNoty_t *)notify;
- (id)initWithMessageNotify:(CMDTextRoomLiveMessageRes_t *)notify;



@end
