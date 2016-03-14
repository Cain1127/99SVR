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

@property (nonatomic,copy) NSString *strOpenId;

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

@property (nonatomic,assign) int nType;

@property (nonatomic,assign) unsigned char m_nVipLevel;

@property(nonatomic, assign) long long goldCoin; // 金币

@property(nonatomic, assign) long long score; // 积分

@property(nonatomic, assign) Byte sex; // 性别

@property (nonatomic,strong) NSMutableArray *aryCollet;

- (NSString *)getVipDescript;

@property (nonatomic,copy) NSArray *aryHelp;

@property (nonatomic,strong) NSDateFormatter *fmt;

@end

@interface RoomKey : NSObject

@property (nonatomic,assign) int nRoomId;
@property (nonatomic,copy) NSString *strName;

@end
