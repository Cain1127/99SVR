//
//  UserInfo.h
//  99SVR
//
//  Created by xia zhonglin  on 12/9/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@class RoomKey;
@class RoomUser;

@interface UserInfo : NSObject

DEFINE_SINGLETON_FOR_HEADER(UserInfo)
/**
 *  服务器配置参数
 */
@property (nonatomic) int nStatus;
@property (nonatomic) int nUnRead;
@property (nonatomic) BOOL bAuthServer;
/**
 *  头像id
 */
@property (nonatomic) int headid;

@property (nonatomic) int sex;

@property (nonatomic,copy) NSString *strEmail;
@property (nonatomic) int nowNetwork;
@property (nonatomic) int checkNetWork;

@property (nonatomic,copy) NSString *strMobile;
/**
 *  第三方登录请求下的openid
 */
@property (nonatomic,copy) NSString *strOpenId;

@property (nonatomic,copy) NSString *strBirth;

@property (nonatomic,copy) NSString *strToken;
/**
 *  第三方登录标识，1:qq 2:weibo 3.wechat
 */
@property (nonatomic,assign) int otherLogin;

@property (nonatomic,copy) NSString *strWebAddr;

@property (nonatomic,copy) NSString *strRoomAddr;

@property (nonatomic,strong) NSMutableDictionary *dictRoomMedia;

@property (nonatomic,strong) NSMutableDictionary *dictRoomGate;

@property (nonatomic,strong) NSMutableDictionary *dictRoomText;

@property (nonatomic,copy) NSString *strTextRoom;
/**
 *  是否登录
 */
@property (nonatomic,assign) BOOL bIsLogin;

@property (nonatomic,copy) NSArray *aryRoom;
/**
 *  用户id
 */
@property (nonatomic,assign) int nUserId;
/**
 *  用户名
 */
@property (nonatomic,copy) NSString *strUser;
/**
 *  密码
 */
@property (nonatomic,copy) NSString *strPwd;
/**
 *  md5密码
 */
@property (nonatomic,copy) NSString *strMd5Pwd;

@property (nonatomic,copy) NSString *strName;

@property (nonatomic,copy) NSString *strIntro;
/**
 *  登录类型  1:账号    2:游客
 */
@property (nonatomic,assign) int nType;
/**
 *  vikkkp
 */
@property (nonatomic,assign) unsigned char m_nVipLevel;

@property(nonatomic, assign) CGFloat goldCoin; // 金币

@property(nonatomic, assign) long long score; // 积分

@property (nonatomic,strong) NSMutableArray *aryCollet;
/**
 *  手机号是否绑定
 */
@property (nonatomic,assign) int banding;

@property (nonatomic,copy) NSArray *aryHelp;
/**
 *  日期格式化格式  :yyyyMMddHHmmss
 */
@property (nonatomic,strong) NSDateFormatter *fmt;
/**
 *  礼物图标
 */
@property (nonatomic,copy) NSArray *aryGift;

@property (nonatomic) int giftVer;

@property (nonatomic,copy) NSString *strMediaAddr;

- (NSString *)getVipDescript;

- (void)setUserDefault:(int)nUserid;

@end

@interface RoomKey : NSObject

@property (nonatomic,assign) int nRoomId;
@property (nonatomic,copy) NSString *strName;

@end
