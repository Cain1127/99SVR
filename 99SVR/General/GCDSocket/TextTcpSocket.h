//
//  TextTcpSocket.h
//  99SVR
//
//  Created by xia zhonglin  on 1/11/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextTcpSocket : NSObject

- (void)connectTextServer:(NSString *)strIp port:(NSInteger)nPort;

- (void)joinRoomInfo;

- (void)connectRoom:(NSString *)strRoomId;

- (void)reqTextRoomList:(int)nIndex count:(int)nCount type:(int)nType;

- (void)reqInterest:(int)teacherid;

- (void)reqLiveChat:(NSString *)strContent to:(int)toId toalias:(NSString *)toName;

- (void)reqChatReply:(NSString *)strContent to:(int)toId toalias:(NSString *)toName source:(NSString *)strSrc;

- (void)reqLiveView:(UInt64)messageid;

- (void)reqViewType:(int)viewTypeId name:(NSString *)strContent;

- (void)reqDeleteTeacherView:(int64_t)messageid;

- (void)replyCommentReq:(NSString *)strComment msgid:(int64_t)msgId toid:(int)toId;

- (void)reqCommentZan:(int64_t)msgid;

- (void)reqSendFlower:(int64_t)msgId count:(int32_t)nCount;

- (void)reqHistoryList:(int)nIndex count:(int)nCount;

- (void)reqDayHistoryList:(int)nIndex count:(int)nCount time:(NSTimeInterval)time;

@end
