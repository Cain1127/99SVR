//
//  ChatReplyModel.h
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmd_vchat.h"
@interface ChatReplyModel : NSObject


@property (nonatomic) UInt32 vcbid;
@property (nonatomic) UInt32 fromid;
@property (nonatomic) short fromheadid;
@property (nonatomic) UInt32 toid;
@property (nonatomic,copy) NSString *strFromName;
@property (nonatomic,copy) NSString *strToName;
@property (nonatomic) short toHeadId;
@property (nonatomic) UInt64 messageTime;
@property (nonatomic) short reqTextlen;
@property (nonatomic) short resTextLen;
@property (nonatomic) int8_t liveflag;

@property (nonatomic,copy) NSString *strContent;

@property (nonatomic) byte type;

- (id)initWithChatResp:(CMDTextLiveChatReplyRes_t *)resp;

- (id)initWIthChatReplyResp:(CMDTextRoomLiveChatRes_t*)resp;
@end
