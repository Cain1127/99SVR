//
//  TQAnswerModel.h
//  99SVR
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HttpMessage.pb.h"

@interface TQAnswerModel : NSObject
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



- (id)initWithAnswer:(QuestionAnswer *)QuestionAnswer;

//- (id)initWithAnswer:(QuestionAnswer *)QuestionAnswer;

@end
