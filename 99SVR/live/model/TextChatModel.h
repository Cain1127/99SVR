//
//  TextChatModel.h
//  99SVR
//
//  Created by xia zhonglin  on 3/2/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmd_vchat.h"

@interface TextChatModel : NSObject

- (id)initWithtextChat:(CMDTextRoomLiveChatRes_t *)resp;

@property (nonatomic) uint32 vcbid;                  //房间ID
@property (nonatomic) uint32 srcid;                  //讲话人ID
@property (nonatomic,copy) NSString *fromNick;      //讲话人昵称
@property (nonatomic) uint32 srcheadid;              //讲话人头像
@property (nonatomic) uint32 toid;                   //用户ID
@property (nonatomic,copy) NSString *toNick;       //用户昵称
@property (nonatomic) uint32 toheadid;               //用户头像
@property (nonatomic) byte  msgtype;                //私聊类型也在放这里
@property (nonatomic) uint64 messagetime;            //发送时间(yyyymmddhhmmss)
@property (nonatomic) uint16 textlen;                //聊天内容长度
@property (nonatomic) int8 commentstype;		   //客户端类型 0:PC端 1:安卓 2:IOS 3:WEB
@property (nonatomic,copy) NSString *content;

@end
