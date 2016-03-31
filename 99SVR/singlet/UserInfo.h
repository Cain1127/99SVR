//
//  UserInfo.h
//  99SVR
//
//  Created by xia zhonglin  on 12/9/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoomKey;
@class RoomUser;

@interface UserInfo : NSObject

DEFINE_SINGLETON_FOR_HEADER(UserInfo)

@property (nonatomic,copy) NSString *strEmail;

@property (nonatomic,copy) NSString *strMobile;

@property (nonatomic,copy) NSString *strOpenId;

@property (nonatomic,copy) NSString *strBirth;

@property (nonatomic,copy) NSString *strToken;

@property (nonatomic,assign) int otherLogin;

@property (nonatomic,copy) NSString *strWebAddr;

@property (nonatomic,copy) NSString *strRoomAddr;

@property (nonatomic,assign) BOOL bIsLogin;

@property (nonatomic,copy) NSArray *aryRoom;

@property (nonatomic,assign) int nUserId;

@property (nonatomic,copy) NSString *strUser;

@property (nonatomic,copy) NSString *strPwd;

@property (nonatomic,copy) NSString *strMd5Pwd;

@property (nonatomic,copy) NSString *strName;

@property (nonatomic,copy) NSString *strIntro;

@property (nonatomic,assign) int nType;

@property (nonatomic,assign) unsigned char m_nVipLevel;

@property(nonatomic, assign) CGFloat goldCoin; // 金币

@property(nonatomic, assign) long long score; // 积分

@property(nonatomic, assign) Byte sex; // 性别

@property (nonatomic,strong) NSMutableArray *aryCollet;

@property (nonatomic,assign) int banding;

@property (nonatomic,copy) NSArray *aryHelp;

@property (nonatomic,strong) NSDateFormatter *fmt;

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
