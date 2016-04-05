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
@property (nonatomic,strong) NSMutableArray *aryComment;
@property (nonatomic,strong) NSMutableArray *aryVIP;
@property (nonatomic,strong) NSMutableArray *aryHistory;
@property (nonatomic,strong) NSMutableArray *aryEsoter;
@property (nonatomic) int32_t roomid;

- (void)reconnectTextRoom;

- (void)connectTextServer:(NSString *)strIp port:(NSInteger)nPort;
/**
 *  发送直播聊天信息
 */
- (void)reqLiveChat:(NSString *)strContent to:(int)toId toalias:(NSString *)toName;
/**
 *  发送其他信息
 */
- (void)reqChatReply:(NSString *)strContent to:(int)toId source:(NSString *)strSrc;
/**
 *  加入房间
 */
- (void)joinRoomInfo;
/**
 *  连接文字直播房间
 *
 *  @param roomId 房间ID
 */
- (void)connectRoom:(int32_t)roomId;
/**
 *  请求文字直播直播内容,type类型：1为直播，2为重点，3为明日推测
 *
 *  @param nIndex 索引
 *  @param nCount 个数
 *  @param nType  类型
 */
- (void)reqTextRoomList:(int)nIndex count:(int)nCount type:(int)nType;
/**
 *  关注讲师
 *
 *  @param oper 标识，取消与关注
 */
- (void)reqTeacherCollet:(short)oper;

- (void)reqZans:(int64_t)messageid;

- (void)reqQuestion:(NSString *)strInfo title:(NSString *)strTitle teach:(int)teacherid;
/**
 *  不使用
 *
 *  @param messageid <#messageid description#>
 */
- (void)reqLiveView:(UInt64)messageid;

- (void)reqDeleteTeacherView:(int64_t)messageid;

/**
 *  评论某条观点
 *
 *  @param strComment 评论内容
 *  @param msgId      观点ID
 *  @param srcId      评论id 可以为0
 *  @param toId       评论人
 */
- (void)replyCommentReq:(NSString *)strComment msgid:(int64_t)msgId toid:(int)toId srccom:(int64_t)srcid;

- (void)reqCommentZan:(int64_t)msgid;

- (void)reqSendFlower:(int64_t)msgId count:(int32_t)nCount;

- (void)reqHistoryList:(int)nIndex count:(int)nCount;

/**
 *  请求某一天的直播列表
 *
 *  @param nIndex 索引
 *  @param nCount 个数
 *  @param time   时间 yyyymmdd
 */
- (void)reqDayHistoryList:(int)nIndex count:(int)nCount time:(UInt32)time;

- (void)createTextMessage:(uint32_t)teacherid type:(int)nType msg:(NSString *)strMsg;
/**
 *  退出房间
 */
- (void)exitRoom;

- (void)reqOperViewType:(int)viewTypeId name:(NSString *)strContent type:(int16_t)type;
/**
 *  清除评论
 */
- (void)clearCommentAry;
/**
 *  请求观点
 *
 *  @param nIndex 索引
 *  @param nCount 个数
 */
- (void)reqNewList:(int)nIndex count:(int)nCount;

/**
 *  请求观点详情,默认请求类型为2
 *
 *  @param nIndex 索引
 *  @param nCount 个数
 *  @param ideaId 观点id
 */
- (void)reqIdeaDetails:(int)nIndex count:(int)nCount ideaId:(int64_t)ideaId;
/**
 *  请求个人秘籍信息
 */
- (void)reqEsotericaList:(int)nIndex count:(int)nCount teach:(int64_t)tid;
/**
 *  请求个人秘籍所有信息
 */
- (void)reqSecretALl;
/**
 *  购买个人秘籍
 */
- (void)reqBuySecret:(int)secretsid goodsid:(int )goodsid;
/**
 *  关闭房间
 */
-(void)closeSocket;


@end
