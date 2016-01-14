//
//  RoomUser.h
//  99SVR
//
//  Created by xia zhonglin  on 12/12/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "yc_datatypes.h"

@class RoomInfo;

@interface RoomUser : NSObject
{
    char cToUser[NAMELEN];
}

@property (nonatomic,assign) int m_nk;     //金币余额
@property (nonatomic,assign) int m_nb;     //积分余额
@property (nonatomic,assign) int m_nd;     //欢乐豆余额
@property (nonatomic,assign) int m_nkdeposit;   //银行存款
@property (nonatomic,assign) int m_nUserId;     //用户id
@property (nonatomic,assign) int m_nUserType;   //用户类型 普通/机器人
@property (nonatomic,assign) int m_nHeadId;     //头像id
@property (nonatomic,assign) int m_nLangId;     //靓号id
@property (nonatomic,assign) int m_bLangIdExp;  //靓号是否过期
@property (nonatomic,assign) unsigned int m_nLangIdExpTime;  //靓号过期时间
@property (nonatomic,assign) unsigned int m_nComeTime;  //进房间时间
@property (nonatomic,assign) int m_nPubMicIndex;  //公麦位置
@property (nonatomic,assign) int m_nXiaoShou;   //是不是销售
@property (nonatomic,assign) int m_nVipLevel;  //等级
@property (nonatomic,assign) int m_nYiyuanLevel;
@property (nonatomic,assign) int m_nShoufuLevel;
@property (nonatomic,assign) int m_nZhongshenLevel;   //终生等级,主要是消费有优惠,有独特的标志
@property (nonatomic,assign) int m_nCaifuLevel;       //财富等级
@property (nonatomic,assign) int m_nlastmonthcostlevel;     //上月消费排行
@property (nonatomic,assign) int m_nthismonthcostlevel;     //本月消费排行
@property (nonatomic,assign) int m_thismonthcostgrade;    //本月累计消费等级
@property (nonatomic,assign) int m_nRoomLevel;        //房间内等级
@property (nonatomic,assign) int m_nInRoomState;      //用户房间状态 (城主)
@property (nonatomic,assign) int m_nFlowerNum;       //鲜花数目
@property (nonatomic,assign) int m_nYuanpiaoNum;     //月票数目
@property (nonatomic,assign) int m_nSealId;       //印章id
@property (nonatomic,assign) unsigned int m_nSealExpTime;  //印章过期时间
@property (nonatomic,assign) bool m_bForbidChat;
@property (nonatomic,assign) bool m_bForbidInviteUpMic;
@property (nonatomic,assign) unsigned int m_nStarFlag;			//周星/风云星标志
@property (nonatomic,assign) unsigned int m_nActivityStarFlag;	//活动星标志
@property (nonatomic,assign) int  m_ncarid;       //座驾id.0-没有
@property (nonatomic,assign) int m_nMICgiftId;
@property (nonatomic,assign) int m_nMICgiftNum;
@property (nonatomic,assign) int  m_nGender;       //性别
@property (nonatomic,assign) int  m_onlinetime;    //在线时长
@property (nonatomic,assign) int  m_birthday_day;  //生日
@property (nonatomic,assign) int  m_birthday_month;
@property (nonatomic,assign) int  m_birthday_year;
@property (nonatomic,assign) int  m_bloodgroup;  //血型
@property (nonatomic,copy) NSString * m_strCarname;
@property (nonatomic,copy) NSString * m_strCountry;
@property (nonatomic,copy) NSString * m_strProvince;
@property (nonatomic,copy) NSString * m_strCity;
@property (nonatomic,copy) NSString *m_strMood;     //心情签名 60 字
@property (nonatomic,copy) NSString *m_strExplain;   //个人说明200字
@property (nonatomic,copy) NSString *m_strUserName;
@property (nonatomic,copy) NSString *m_strUserAlias;
@property (nonatomic,copy) NSString *m_strUserPwd;    //本机用户保存用户密码

//std::map<int ,int > m_mapGifts;  //礼物数目列表,保存本次进房间收到的礼物统计
//CRoomObj* m_pInRoom;   //当前房间对象
@property (nonatomic,strong) RoomInfo *m_pInRoom;

#ifdef __SWITCH_SERVER2__
@property (nonatomic,copy) NSString *cemail;            //邮箱
@property (nonatomic,copy) NSString *cqq;               //QQ
@property (nonatomic,copy) NSString *ctel;              //手机
#endif
- (BOOL)isHide;

- (BOOL)isOnMic;

- (int)GetRoomMgrLevel;

- (int)isManager;

@end
