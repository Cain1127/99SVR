//
//  ZLLoginServer.h
//  99SVR
//
//  Created by xia zhonglin  on 3/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  新登录登录器类，里面保存C++类
 */
@interface ZLLogonServerSing : NSObject

DEFINE_SINGLETON_FOR_HEADER(ZLLogonServerSing)
- (void)serverInit;
/**
 *  账号登录
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 */
- (void)loginSuccess:(NSString *)username pwd:(NSString *)password;
/**
 *  修改密码
 *
 *  @param old      <#old description#>
 *  @param password <#password description#>
 */
- (void)updatePwd:(NSString *)old cmd:(NSString *)password;
/**
 *  修改昵称
 *
 *  @param strNick <#strNick description#>
 */
- (void)updateNick:(NSString *)strNick intro:(NSString *)strintro sex:(int)nSex;
/**
 *  关闭protocol
 */
- (void)closeProtocol;
/**
 *  加入房间
 */
- (void)connectVideoRoom:(int)nRoomId roomPwd:(NSString *)roomPwd;
/**
 *  送花
 */
- (void)sendRose;
/**
 *  发送消息
 */
- (void)sendMessage:(NSString *)strMsg toId:(int)toId;
/**
 *  赠送礼物
 */
- (void)sendGiftInfo:(int)nGiftId number:(int)num;
/**
 *  赠送礼物,接收者id可以得到，但是昵称怎么来
 */
- (void)sendGiftInfo:(int)nGiftId number:(int)num toUser:(int)userId toViewId:(int )viewId roomId:(int)roomId;
/**
 *  退出房间
 */
- (void)exitRoom;
/**
 *  购买私人定制
 */
- (void)requestBuyPrivateVip:(int)teacherId vipType:(int)vip;

- (void)requestRoomInfo;

- (void)colletRoomInfo:(int)action;

- (void)requestQuestion:(int)roomId team:(int)teamId stock:(NSString *)stock question:(NSString *)question;

- (NSString *)getVideoUrl;

@end
