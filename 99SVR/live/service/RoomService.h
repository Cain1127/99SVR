//
//  RoomService.h
//  99SVR
//
//  Created by xia zhonglin  on 4/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomInfo.h"
#import "VideoRoomMessage.pb.h"

@interface RoomService : NSObject
/**
 *  封装聊天消息
 */
+ (BOOL )getChatInfo:(RoomChatMsg *)msg array:(NSMutableArray *)aryChat prichat:(NSMutableArray *)aryPriChat;
/**
 *  添加用户到房间里面
 */
+ (BOOL)addRoomUser:(RoomInfo *)_rInfo user:(RoomUserInfo *)item;
/**
 *  公告消息封装
 */
+ (BOOL)getNoticeInfo:(RoomNotice *)pInfo notice:(NSMutableArray *)aryBuffer;
/**
 *  广播消息封装
 */
+ (BOOL)getRibao:(RoomChatMsg *)msg notice:(NSMutableArray *)aryBuffer;
/**
 *  组合本地消息
 */
+ (BOOL)sendLocalInfo:(NSString *)strMsg toid:(int)toId roomInfo:(RoomInfo *)rInfo aryChat:(NSMutableArray *)aryChat;

/**
 *  课程表信息
 */
+ (NSString *)getTeachInfo:(RoomNotice *)pInfo;

@end
