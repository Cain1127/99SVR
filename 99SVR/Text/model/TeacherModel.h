//
//  TeacherModel.h
//  99SVR
//
//  Created by xia zhonglin  on 1/8/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmd_vchat.h"

@interface TeacherModel : NSObject

@property (nonatomic,copy) NSString *strContent;//内容
@property (nonatomic,copy) NSString *strImg;
@property (nonatomic,copy) NSString *strName;//讲师昵称
@property (nonatomic,copy) NSString *strLevel;
@property (nonatomic,copy) NSString *strLabel;
@property (nonatomic,copy) NSString *strGoodat;

@property (nonatomic) int vcbid;
@property (nonatomic) int userid;
@property (nonatomic) int  teacherid; //讲师ID
@property (nonatomic) short headid;  //headid
@property (nonatomic) short levellen;//讲师等级长度
@property (nonatomic) short labellen;//讲师标签长度
@property (nonatomic) short goodatlen;//讲师擅长长度
@property (nonatomic) short introducelen;//讲师简介长度
@property (nonatomic) int64_t historymoods;//直播人气
@property (nonatomic) int64_t fans;//粉丝数
@property (nonatomic) int64_t zans;//赞
@property (nonatomic) int64_t todaymoods;//今日人气
@property (nonatomic) int64_t historyLives;//直播历史数
@property (nonatomic) short fansflag;//是否直播中
@property (nonatomic) short liveflag;//是否直播中

- (id)initWithTeacher:(CMDTextRoomTeacherNoty_t *)teacher;

@end
