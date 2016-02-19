//
//  TextTcpSocket.h
//  99SVR
//
//  Created by xia zhonglin  on 1/11/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@class TeacherModel;

@interface TextTcpSocket : NSObject
@property (nonatomic,strong) TeacherModel *teacher;
@property (nonatomic,strong) NSMutableArray *aryText;
@property (nonatomic,strong) NSMutableArray *aryChat;
@property (nonatomic,strong) NSMutableArray *aryNew;

- (void)reconnectTextRoom;

- (void)connectTextServer:(NSString *)strIp port:(NSInteger)nPort;
//发送聊天信息
- (void)reqLiveChat:(NSString *)strContent to:(int)toId toalias:(NSString *)toName;
- (void)reqChatReply:(NSString *)strContent to:(int)toId source:(NSString *)strSrc;

- (void)joinRoomInfo;

- (void)connectRoom:(int32_t)roomId;

- (void)reqTextRoomList:(int)nIndex count:(int)nCount type:(int)nType;

- (void)reqTeacherCollet:(short)oper;

- (void)reqZans:(int64_t)messageid;

- (void)reqQuestion:(NSString *)strInfo title:(NSString *)strTitle teach:(int)teacherid;

- (void)reqLiveView:(UInt64)messageid;

- (void)reqDeleteTeacherView:(int64_t)messageid;

- (void)replyCommentReq:(NSString *)strComment msgid:(int64_t)msgId toid:(int)toId;

- (void)reqCommentZan:(int64_t)msgid;

- (void)reqSendFlower:(int64_t)msgId count:(int32_t)nCount;

- (void)reqHistoryList:(int)nIndex count:(int)nCount;

- (void)reqDayHistoryList:(int)nIndex count:(int)nCount time:(NSTimeInterval)time;

- (void)createTextMessage:(uint32_t)teacherid type:(int)nType msg:(NSString *)strMsg;

- (void)reqIdeaDetails:(int)nIndex count:(int)nCount ideaId:(int)ideaId;

- (void)exitRoom;

- (void)reqOperViewType:(int)viewTypeId name:(NSString *)strContent type:(int16_t)type;

- (void)reqNewList:(int)teacherid index:(int)nIndex count:(int)nCount;


@end
