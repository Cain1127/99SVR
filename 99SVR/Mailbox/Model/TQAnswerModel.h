//
//  TQAnswerModel.h
//  99SVR
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HttpMessage.pb.h"

/*        char answerAuthorId[16];  // 回答者
 char answerAuthorName[32];  // 回答者名称
 char answerAuthorHead[64];  // 回答者ICON
 uint32 answerAuthorRole; // 0：普通用户 1：讲师
 char answerTime[32];  // 回答时间
 char answerContent[256];  // 回答内容
 char askAuthorName[32];  // 提问者
 char askAuthorHead[64];  // 提问者头像
 uint32 askAuthorRole; // 0：普通用户 1：讲师
 char askStock[32];  // 提问的股票
 char askContent[256];  // 提问内容
 char askTime[32];  // 提问时间
 uint32 fromClient;
*/

@interface TQAnswerModel : NSObject
/** 头像 */
@property (nonatomic ,weak)NSString *answerauthorhead;
/** 回答ID */
@property(nonatomic,copy) NSString *answerauthorid;
/** 回答名称 */
@property(nonatomic,copy) NSString *answerauthorname;
/** 回答头像 */
@property(nonatomic,copy) NSString *answerauthoricon;
/** 回答内容 */
@property(nonatomic,copy) NSString *answercontent;
/** 回答时间 */
@property(nonatomic,copy) NSString *answertime;
/** 提问哪只股票 */
@property(nonatomic,copy) NSString *askstock;
/** 提问者姓名 */
@property (nonatomic ,weak)NSString *askauthorname;
/** 提问内容 */
@property(nonatomic,copy) NSString *askcontent;
/** 提问ID */
@property(nonatomic,assign)int askauthorheadid;
/** 提问时间 */
@property(nonatomic,copy) NSString *asktime;
/** 用户ID */
@property(nonatomic,assign)int userID;
/** 客户端 */
@property(nonatomic,assign)int fromclient;

/** 是否展开 */
@property (nonatomic, assign) BOOL isAllText;
@property(nonatomic,assign) NSUInteger autoId;


- (id)initWithAnswer:(QuestionAnswer *)QuestionAnswer;

- (id)initWithRplay:(MailReply *)MailReply;

@end
