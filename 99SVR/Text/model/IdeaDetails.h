//
//  IdeaDetails.h
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmd_vchat.h"

@interface IdeaDetails : NSObject

@property (nonatomic) uint32 vcbid;
@property (nonatomic) uint32 userid;
@property (nonatomic) int64 messageid;
@property (nonatomic) short liveType;
@property (nonatomic) short viewTitleLen;
@property (nonatomic) short viewTextLen;
@property (nonatomic) int64 messageTime;
@property (nonatomic) int64 looks;
@property (nonatomic) int64 zans;
@property (nonatomic) int64 flowers;
@property (nonatomic) int64 comments;
@property (nonatomic,copy) NSString *strContent;
@property (nonatomic,copy) NSString *strTime;
@property (nonatomic,copy) NSString *strTitle;

- (id)initWithIdeaDetails:(CMDTextRoomLiveViewRes_t *)resp;

@end
