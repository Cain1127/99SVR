//
//  IdeaDetailRePly.h
//  99SVR
//
//  Created by xia zhonglin  on 1/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmd_vchat.h"
//观点
@interface IdeaDetailRePly : NSObject

@property (nonatomic) uint32 vcbid;
@property (nonatomic) int64 viewId;
@property (nonatomic) int64_t commentid;
@property (nonatomic) uint32 viewuserid;
@property (nonatomic) uint32 userid;
@property (nonatomic) int16 textLen;
@property (nonatomic,copy) NSString *strSrcName;
@property (nonatomic) int64 messageTime;
@property (nonatomic,copy) NSString *strContent;
@property (nonatomic) uint32 reqcommentstype;		//评论客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
@property (nonatomic) int64 srcinteractid;		//源评论ID（回复评论内容时需要填写），0则代表没有
@property (nonatomic,copy) NSString *strName;
@property (nonatomic,copy) NSString *time;

- (id)initWithIdeaRePly:(CMDTextRoomViewInfoRes_t*)resp teachId:(int)teacherId;

- (void)setTimeInfo;

@end