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

@property (nonatomic,assign) BOOL bIsLogin;
@property (nonatomic,assign) int nUserId;
@property (nonatomic,copy) NSString *strPwd;
@property (nonatomic,copy) NSString *strMd5Pwd;
@property (nonatomic,copy) NSString *strName;
@property (nonatomic,assign) int nType;

@property (nonatomic,copy) NSArray *aryRoom;

@property (nonatomic,strong) NSMutableDictionary *dictRoomInfo;

@property (nonatomic,assign) unsigned char m_nVipLevel;

@property(nonatomic, assign) long long goldCoin; // 金币
@property(nonatomic, assign) long long score; // 积分
@property(nonatomic, assign) Byte sex; // 性别

@property (nonatomic,strong) NSMutableArray *aryUsers;

@property (nonatomic,strong) NSMutableArray *aryCollet;

- (void)initUserAry;

- (void)addRoomUser:(RoomUser *)users;

- (void)removeUsers:(RoomUser *)users;

- (void)addRoomInfo:(NSValue *)value;

- (void)addParentRoom:(NSValue *)value key:(NSString *)strKey;

- (NSString *)getVipDescript;

@end

@interface RoomKey : NSObject

@property (nonatomic,assign) int nRoomId;
@property (nonatomic,copy) NSString *strName;

@end
