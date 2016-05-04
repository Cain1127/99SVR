
#ifndef __PROTO_MESSAGE_VCHAT_H__
#define __PROTO_MESSAGE_VCHAT_H__

#include "proto_message_comm.h"

namespace protocol
{

	enum {
		MDM_Vchat_Login = 103,  //登陆
		MDM_Vchat_Hall = 104,  //大厅
		MDM_Vchat_Room = 105,  //房间
		MDM_Vchat_Gate = 106,  //网关
		MDM_Vchat_WEB = 107,  //来自web的通知
		MDM_Vchat_Text = 108,   //文字直播服务器
		MDM_Vchat_Usermgr = 109,   //来自用户管理服务器
		MDM_Vchat_Frtiy = 110,  //外部 111
		MDM_Vchat_Trust = 112,
		MDM_Vchat_Notify = 113,   //房间通知服务器
		MDM_Vchat_Subscrib = 114,  //订阅服务器
		MDM_Vchat_Redis_Sync = 115,  //redis同步
		MDM_Vchat_Stastics = 198,  //统计服务器
		MDM_Vchat_Alarm = 199,  //告警服务器

		MDM_Version_Value = 10  //协议版本
	};

	enum {
		ERR_USER_IN_BLACK_LIST = 101,	//用户在黑名单
		ERR_JOINROOM_PWD_WRONG = 201,	//房间密码不对
		ERR_FAIL_CREATE_USER = 203,		//创建用户失败(用户名/密码失败)
		ERR_KICKOUT_SAMEACCOUNT = 107,	//同号加入房间踢出
		ERR_EXCEPTION_QUIT_ROOM = 108,
		ERR_ROOM_NOT_EXIST = 404,		//房间不存在
		ERR_ROOM_IS_CLOSED = 405,		//房间已经关闭
		ERR_ROOM_USER_IS_FULL = 502,	//房间人数已满
		ERR_KICKOUT_TIMEOUT = 522,		//超时踢出
		ERR_KICKOUT_AD = 600			//打广告踢出
	};
	
	enum {
		ERR_CODE_SUCCESS = 0,	//成功

		ERR_CODE_FAILED =                   1000, //失败 1000~1999
		ERR_CODE_FAILED_PACKAGEERROR =      1001,  //请求包长度错误
		ERR_CODE_FAILED_DBERROR =           1002, //数据库类型错误 

		ERR_CODE_FAILED_INVALIDCHAR =       1003,//输入了非法字符
		ERR_CODE_FAILED_USERNOTFOUND =      1004, //找不到该用户
		ERR_CODE_FAILED_USERFROSEN =        1005, //用户被冻结

		ERR_CODE_FAILED_UNKNONMESSAGETYPE = 1006, //未知消息类型

		ERR_CODE_FAILED_REQUEST_OUTOFRANGE = 1007, //请求数据过多或者内容过长
		
		ERR_CODE_FAILED_SAMEUSERLOGIN =     1008,   //完全相同的用户加入房间
		ERR_CODE_FAILED_AREAIDNOTFOUND =    1009,   //没有找到区域ID
		ERR_CODE_FAILED_ROOMIDNOTFOUND =    1010,   //没有找到房间ID
		ERR_CODE_FAILED_CRC =               1011,   //CRC校验错误
		ERR_CODE_FAILED_CREATEUSER =        1012,   //没有找到创建用户失败
		ERR_CODE_FAILED_KEYWORDFOUND =      1013,   //发现关键词
		ERR_CODE_FAILED_NOT_ENOUGH_GOLD =   1014,   //金币不足
		ERR_CODE_FAILED_ALREADY_BUY =       1015,   //已经购买
		ERR_CODE_FAILED_PRIVATENOTFOUND =   1016,    //没有该私人订制
		ERR_CODE_FAILED_TEAMNOTFOUND =      1017,   //没有找到战队ID
		ERR_CODE_FAILED_GIFTNOTFOUND =      1018   //没有找到礼物ID

	};
	
	enum {
		Sub_Vchat_ClientHello                               =1    ,       //握手每个MDMmainCmd不一样
		Sub_Vchat_ClientPing                                =2    ,       //ping每个MDMmainCmd不一样
		Sub_Vchat_ClientPingResp                            =3    ,       //ping回应
		Sub_Vchat_GetAllUserReq                             =4    ,       //  获取所有的在线用户
		Sub_Vchat_Resp_ErrCode                              =5    ,       //  返回错误应答
		Sub_Vchat_DoNotReachRoomServer                      =6    ,       //                                                                               
		Sub_Vchat_MgrRefreshListReq                         =7    ,       //  刷新请求
		Sub_Vchat_MgrRefreshListNotify                      =8    ,       //                                                                               
		Sub_Vchat_MgrRelieveBlackDBReq                      =9    ,       //           解除黑名单请求
		Sub_Vchat_MgrRelieveBlackDBNoty                     =10   ,       // 
		                                                                                                                          
		Sub_Vchat_LogonNot                                  =361  ,       //  用户上线通知
		Sub_Vchat_LogoutNot                                 =362  ,       //  用户下线通知--踢人服务器过来
		Sub_Vchat_ClientExistNot                            =363  ,       //  用户下线通知--给客户端
		Sub_Vchat_HitGoldEgg_ToClient_Noty                  =1001 ,       //   砸金蛋通知客户端
		Sub_Vchat_ClientNotify                              =10194,       //    推送命令
		Sub_Vchat_notifyReq                                 =10197,       //通告请求
		                                                  
		Sub_Vchat_JoinRoomReq                               =2000 ,       // 加入房间请求
		Sub_Vchat_JoinRoomErr                               =2001 ,       // 错误
		Sub_Vchat_JoinRoomResp                              =2002 ,       // 成功含管理列表
		Sub_Vchat_JoinOtherRoomNoty                         =2003 ,       // 进入其他房间通知(服务器之间用)
		Sub_Vchat_RoomUserListReq                           =2004 ,       // 房间用户列表请求
		Sub_Vchat_RoomUserListBegin                         =2005 ,       // adbyguchengzhi20150202                                                        
		Sub_Vchat_RoomUserListResp                          =2006 ,       // 回应(推播)
		Sub_Vchat_RoomUserListFinished                      =2007 ,       // 请求加入房间阶段完成界面更新数据
		Sub_Vchat_RoomUserNoty                              =2008 ,       // 列表更新通知
		Sub_Vchat_RoomPubMicState                           =2009 ,       // 房间公麦状态
		Sub_Vchat_RoomUserExitReq                           =2010 ,       // 用户自己退出房间
		Sub_Vchat_RoomUserExitResp                          =2011 ,       //                                                                               
		Sub_Vchat_RoomUserExitNoty                          =2012 ,       // 通知
		Sub_Vchat_RoomKickoutUserReq                        =2013 ,       // 踢出用户请求
		Sub_Vchat_RoomKickoutUserResp                       =2014 ,       //                                                                               
		Sub_Vchat_RoomKickoutUserNoty                       =2015 ,       // 通知
		Sub_Vchat_ChatReq                                   =2016 ,       // 聊天发出消息
		Sub_Vchat_ChatErr                                   =2017 ,       //                                                                               
		Sub_Vchat_ChatNotify                                =2018 ,       // 转发消息
		Sub_Vchat_TradeGiftReq                              =2019 ,       // 赠送礼物(跨房间跨平台)请求
		Sub_Vchat_TradeGiftResp                             =2020 ,       //                                                                               
		Sub_Vchat_TradeGiftErr                              =2021 ,       //                                                                               
		Sub_Vchat_TradeGiftNotify                           =2022 ,       //                                                                               
		Sub_Vchat_SysNoticeInfo                             =2023 ,       // 系统广播(专门)消息
		Sub_Vchat_UserAccountInfo                           =2024 ,       // 用户账户(余额)信息
		Sub_Vchat_RoomInfoNotify                            =2025 ,       // 房间信息资料
		Sub_Vchat_RoomManagerNotify                         =2026 ,       // 房间管理员
		Sub_Vchat_RoomMediaNotify                           =2027 ,       // 房间媒体
		Sub_Vchat_RoomNoticeNotify                          =2028 ,       // 房间公告
		Sub_Vchat_RoomOPStatusNotify                        =2029 ,       // 房间状态
		Sub_Vchat_SetMicStateReq                            =2030 ,       // 设置上/下麦状态
		Sub_Vchat_SetMicStateResp                           =2031 ,       //                                                                               
		Sub_Vchat_SetMicStateErr                            =2032 ,       //                                                                               
		Sub_Vchat_SetMicStateNotify                         =2033 ,       //                                                                               
		Sub_Vchat_SetDevStateReq                            =2034 ,       // 设置设备状态
		Sub_Vchat_SetDevStateResp                           =2035 ,       //                                                                               
		Sub_Vchat_SetDevStateErr                            =2036 ,       //                                                                               
		Sub_Vchat_SetDevStateNotify                         =2037 ,       //                                                                               
		Sub_Vchat_SetUserAliasReq                           =2038 ,       // 设置用户呢称
		Sub_Vchat_SetUserAliasResp                          =2039 ,       //                                                                               
		Sub_Vchat_SetUserAliasErr                           =2040 ,       //                                                                               
		Sub_Vchat_SetUserAliasNotify                        =2041 ,       //                                                                               
		Sub_Vchat_SetUserPriorityReq                        =2042 ,       // 设置用户权限
		Sub_Vchat_SetUserPriorityResp                       =2043 ,       //                                                                               
		Sub_Vchat_SetUserPriorityNotify                     =2044 ,       //                                                                               
		Sub_Vchat_SeeUserIpReq                              =2045 ,       // 查看用户IP请求
		Sub_Vchat_SeeUserIpResp                             =2046 ,       //                                                                               
		Sub_Vchat_SeeUserIpErr                              =2047 ,       //                                                                               
		Sub_Vchat_ThrowUserReq                              =2048 ,       // 封杀用户
		Sub_Vchat_ThrowUserResp                             =2049 ,       //                                                                               
		Sub_Vchat_ThrowUserNotify                           =2050 ,       //                                                                               
		Sub_Vchat_ForbidUserChatReq                         =2051 ,       // 禁言用户请求
		Sub_Vchat_ForbidUserChatNotify                      =2052 ,       //                                                                               
		Sub_Vchat_FavoriteVcbReq                            =2053 ,       //  收藏房间请求
		Sub_Vchat_FavoriteVcbResp                           =2054 ,       //                                                                               
		Sub_Vchat_SetRoomInfoReq                            =2055 ,       //  设置房间信息请求
		Sub_Vchat_SetRoomInfoResp                           =2056 ,       //                                                                               
		Sub_Vchat_SetRoomOPStatusReq                        =2057 ,       //  设置房间运行属性(状态)
		Sub_Vchat_SetRoomOPStatusResp                       =2058 ,       //                                                                               
		Sub_Vchat_SetRoomNoticeReq                          =2059 ,       //  设置房间公告信息请求
		Sub_Vchat_SetRoomNoticeResp                         =2060 ,       //                                                                               
		Sub_Vchat_SetRoomMediaReq                           =2061 ,       //  设置房间媒体服务器请求addbyguchengzhi20150202                                                                           
		Sub_Vchat_QueryUserAccountReq                       =2064 ,       //  用户账户查询(银行查询)
		Sub_Vchat_QueryUserAccountResp                      =2065 ,       //                                                                               
		Sub_Vchat_QueryVcbExistReq                          =2066 ,       //  查询某房间是否存在
		Sub_Vchat_QueryVcbExistResp                         =2067 ,       //  该消息没有err
		Sub_Vchat_QueryUserExistReq                         =2068 ,       //  查询某用户是否存在
		Sub_Vchat_QueryUserExistResp                        =2069 ,       //  该消息没有err
		Sub_Vchat_GateCloseObjectReq                        =2070 ,       //  关闭网关上面的对象
		Sub_Vchat_CloseRoomNotify                           =2071 ,       //  关闭房间通知
		Sub_Vchat_RoomGatePing                              =2072 ,       //                                                                               
		Sub_Vchat_SetRoomInfoReq_v2                         =2073 ,       //  设置房间信息请求飞叉版
		Sub_Vchat_SetRoomInfoResp_v2                        =2074 ,       //                                                                               
		Sub_Vchat_SetRoomInfoNoty_v2                        =2075 ,       //                                                                               
		Sub_Vchat_QueryRoomGateAddrReq                      =2076 ,       //  获取房间网关地址
		Sub_Vchat_QueryRoomGateAddrResp                     =2077 ,       //                                                                               
		Sub_Vchat_AdKeyWordOperateReq                       =2078 ,       //   关键字操作请求
		Sub_Vchat_AdKeyWordOperateResp                      =2079 ,       //  关键字操作回应
		Sub_Vchat_AdKeyWordOperateNoty                      =2080 ,       //   关键字广播通知
		Sub_Vchat_TeacherScoreReq                           =2081 ,       //  讲师发送评分处理请求
		Sub_Vchat_TeacherScoreResp                          =2082 ,       //  讲师发送评分处理响应
		Sub_Vchat_TeacherScoreRecordReq                     =2083 ,       //  用户评分请求
		Sub_Vchat_TeacherScoreRecordResp                    =2084 ,       //  用户评分响应
		Sub_Vchat_RoborTeacherIdNoty                        =2085 ,       //  机器人对应讲师ID通知
		Sub_Vchat_TeacherGiftListReq                        =2086 ,       //  讲师忠实度周版请求
		Sub_Vchat_TeacherGiftListResp                       =2087 ,       //  讲师忠实度周版响应
		Sub_Vchat_ReportMediaGateReq                        =2088 ,       //  客户端报告媒体服务器和网关服务器
		Sub_Vchat_ReportMediaGateResp                       =2089 ,       //  客户端报告媒体服务器和网关服务器的回应
		Sub_Vchat_RoomUserExceptExitReq                     =2090 ,       //  用户异常推出通知roomsvr
		Sub_Vchat_UserScoreNotify                           =2091 ,       //  用户对讲师的评分
		Sub_Vchat_UserScoreListNotify                       =2092 ,       //  用户对讲师的评分广播
		Sub_Vchat_RoomAndSubRoomId_Noty                     =2093 ,       //  IOS和Android方面，需要在进入房间和讲师上麦的时候得到主房间和子房间的ID
		Sub_Vchat_TeacherAvarageScore_Noty                  =2094 ,       //  某个讲师的平均分
		Sub_Vchat_SysCast_Resp                              =2095 ,       //  房间发送系统公告
		Sub_Vchat_RoomUserExceptExitNoty                    =2096 ,       //  用户异常退出通知
		Sub_Vchat_GateJoinRoom                              =2097 ,       //  gate切换用户到roomsvr
		Sub_Vchat_RoomAmong_Notify                          =2098 ,       //  roomsvr之间的消息通知
		Sub_Vchat_RoomTeacherSubscriptionReq                =2099 ,       //  订阅请求
		Sub_Vchat_RoomTeacherSubscriptionResp               =2100 ,       //  订阅响应
		Sub_Vchat_RoomTeacherSubscriptionStateQueryReq      =2101 ,       //  查询订阅状态请求
		Sub_Vchat_RoomTeacherSubscriptionStateQueryResp     =2102 ,       //  查询订阅状态响应
		Sub_Vchat_RoomDataSyncReq                           =2103 ,       //                                                                               
		Sub_Vchat_RoomDataSyncResp                          =2104 ,       //                                                                               
		Sub_Vchat_RoomDataSyncComplete                      =2105 ,       //                                                                               
		Sub_Vchat_RoomDataSync_JoinRoom                     =2106 ,       //                                                                               
		Sub_Vchat_RoomDataSync_LeftRoom                     =2107 ,       //                                                                               
		Sub_Vchat_RoomDataSync_MicChanged                   =2108 ,       //                                                                               
		Sub_Vchat_RoomDataSync_UserUpdated                  =2109 ,       //                                                                               
		Sub_Vchat_RedisRoomInfo_Req                         =2110 ,       //                                                                               
		Sub_Vchat_RedisRoomInfo_Resp                        =2111 ,       //                                                                               
		Sub_Vchat_RedisUserInfo_Req                         =2112 ,       //                                                                               
		Sub_Vchat_RedisUserInfo_Last_Req                    =2113 ,       //                                                                               
		Sub_Vchat_RedisUserInfo_Resp                        =2114 ,       //                                                                               
		Sub_Vchat_RedisUserInfo_Complete                    =2115 ,       //                                                                               
		Sub_Vchat_RedisSync_Err_Resp                        =2116 ,       //                                                                               
		Sub_Vchat_RedisSync_log_index_Req                   =2117 ,       //                                                                               
		Sub_Vchat_RedisSync_log_index_Resp                  =2118 ,       //                                                                               
		Sub_Vchat_RedisSync_data_Req                        =2119 ,       //                                                                               
		Sub_Vchat_RedisSync_data_Resp                       =2120 ,       //                                                                               
		Sub_Vchat_RedisSync_data_Complete                   =2121 ,       //                                                                               
		Sub_Vchat_RedisSync_Report_Status                   =2122 ,       //                                                                               
		Sub_Vchat_ChatResp                                  =2123 ,       //   聊天发出消息应答
		Sub_Vchat_PreJoinRoomReq                            =2124,        //加入房间预处理请求
		Sub_Vchat_PreJoinRoomResp                           =2125,        //加入房间预处理响应
		Sub_Vchat_WaitiMicListInfo                          =2126 ,       // 排麦用户列表
		Sub_Vchat_GetUserInfoReq                            =2127,        //查询用户个人资料请求
		Sub_Vchat_GetUserInfoResp                           =2128,        //查询用户个人资料响应
		Sub_Vchat_GetTeacherInfoResp                        =2129,        //查询文字直播讲师个人资料响应
		Sub_Vchat_GetUserInfoErr                            =2130,        //查询用户个人资料请求
	    Sub_Vchat_UpWaitMicReq                              =2131,        //
        Sub_Vchat_UpWaitMicResp                             =2132,
        Sub_Vchat_UpWaitMicErr                              =2133,
		Sub_Vchat_TeamTopNReq                               =2134,	      //最强战队周榜请求
		Sub_Vchat_TeamTopNResp                              =2135,	      //最强战队周榜回应
		Sub_Vchat_AfterJoinRoomReq                          =2136,	      //加入房间成功后请求推送信息	
		Sub_Vchat_ViewpointTradeGiftReq                     =2137,        //观点送礼请求
		Sub_Vchat_ViewpointTradeGiftNoty                    =2138,        //观点送礼响应
		Sub_Vchat_ViewpointTradeGiftResp                    =2139,        //观点送礼响应
		
		Sub_Vchat_TeacherOnMicReq                           =20000,       //    讲师上麦通知订阅用户请求
		Sub_Vchat_PrivateVipNoty                            =20001,       //    私人订制通知订阅用户请求
		                                                                                                                    
		Sub_Vchat_UserQuanxianBegin                         =21001,       //用户权限数据
		Sub_Vchat_UserQuanxianLst                           =21002,       //                                                                               
		Sub_Vchat_UserQuanxianEnd                           =21003,       //                                                                               
		Sub_Vchat_logonFinished                             =21004,       // 登录完成无数据
		Sub_VChat_QuanxianId2ListResp                       =21005,       //  权限id数据
		Sub_VChat_QuanxianAction2ListBegin                  =21006,       //  权限操作数据
		Sub_VChat_QuanxianAction2ListResp                   =21007,       //                                                                               
		Sub_VChat_QuanxianAction2ListFinished               =21008,       //                                                                               
		Sub_Vchat_UserExitMessage_Req                       =21009,       //  用户退出软件的请求
		Sub_Vchat_UserExitMessage_Resp                      =21010,       //  用户退出软件的响应
		Sub_Vchat_GetSecureInfoReq                          =21011,       //  客户端请求用户emailqq手机号码已提醒次数
		Sub_Vchat_GetSecureInfoResp                         =21012,       //  客户端请求用户emailqq手机号码已提醒次数的回应
		Sub_Vchat_ClientCloseSocket_Req                     =21013,       //  clientclosesocket(thegatetellthelobbysvr)                                    
		Sub_Vchat_logonReq4                                 =21014,       //   logonnewreq                                                                 
		Sub_Vchat_logonReq5                                 =21015,       //   logonthroughotherplatform                                                   
		Sub_Vchat_logonErr2                                 =21016,       //   登陆失败
		Sub_Vchat_logonSuccess2                             =21017,       //   登陆成功
		Sub_Vchat_logonTokenReq                             =21018,       //   usertokennotify
		Sub_Vchat_logonTokenNotify                          =21019,       //user token notify
		Sub_Vchat_GetUserMoreInfReq                         =21020,       //    获取用户更多信息请求（手机，个性签名等）
		Sub_Vchat_GetUserMoreInfResp                        =21021,       //    获取用户更多信息应答（手机，个性签名等）
		Sub_Vchat_SetUserProfileReq                         =21022,       //设置用户资料
		Sub_Vchat_SetUserProfileResp                        =21023,       //
		Sub_Vchat_SetUserMoreInfoReq                        =21024,       //设置用户更多信息
        Sub_Vchat_SetUserMoreInfoResp                       =21025,
		Sub_Vchat_SetUserPwdReq                             =21026,       //  设置用户密码
		Sub_Vchat_SetUserPwdResp                            =21027,       //    

		Sub_Vchat_RoomGroupListReq                          =22001,       // 房间组列表请求
		Sub_Vchat_RoomGroupListBegin                        =22002,       //                                                                               
		Sub_Vchat_RoomGroupListResp                         =22003,       //                                                                               
		Sub_Vchat_RoomGroupListFinished                     =22004,       //                                                                               
		Sub_Vchat_RoomGroupStatusReq                        =22005,       // 房间组状态(人数)请求
		Sub_Vchat_RoomGroupStatusResp                       =22006,       //                                                                               
		Sub_Vchat_RoomGroupStatusFinished                   =22007,       // 房间组状态(人数)列表结束
		Sub_Vchat_SendRoomGroupList                         =22008,       //    登录触发hallsvr发送房间分组列表
		Sub_Vchat_GetOnMicRobertReq                         =22009,       //    获取房间的转播机器人ID请求
		Sub_Vchat_GetOnMicRobertResp                        =22010,       //    获取房间的转播机器人ID应答
		Sub_Vchat_BuyPrivateVipReq                          =22011,       //    购买私人订制请求
		Sub_Vchat_BuyPrivateVipResp                         =22012,       //    购买私人订制响应
		Sub_Vchat_HallInterestForReq                        =22013,       //关注请求
		Sub_Vchat_HallInterestForResp                       =22014,        //关注响应


		
	};

	typedef enum MediaConnectActionType
	{
		Connect_You = 1,
		Disconnect_You = 3,
	}e_MediaConnectActionType;

	typedef enum NoticeDevType
	{
		e_Notice_PC = 0,
		e_Notice_Android = 1,
		e_Notice_IOS = 2,
		e_Notice_Web = 3,
		e_Notice_AllType = 4
	}e_NoticeDevType;

	typedef enum enum_AlarmLevel
	{
		alarm_level_general = 0,
		alarm_level_major,
		alarm_level_fatal
	}e_AlarmLevel;

//#define BROADCAST_TYPE 9999

	//----------------------------------------------------------
#pragma pack(1)

	//4 bytes
	typedef struct tag_CMDClientHello
	{
		uint8 param1;
		uint8 param2;
		uint8 param3;
		uint8 param4;
	}CMDClientHello_t;

	//4 bytes
	typedef struct tag_CMDGateHello
	{
		uint8 param1;
		uint8 param2;
		uint8 param3;
		uint8 param4;
		uint16 gateid;
	}CMDGateHello_t;

	//4 bytes
	typedef struct tag_CMDClientPing
	{
		uint32 userid;        //用户id
		uint32 roomid;        //房间id
	}CMDClientPing_t;

	typedef struct tag_CMDSetExecQueryReq
	{
		uint32 userid;
		int32  textlen;
		char   content[0];
	}CMDSetExecQueryReq_t;

	typedef struct tag_CMDSetExecQueryResp
	{
		uint32 userid;
		int32  errorid;
	}CMDSetExecQueryResp_t;

	typedef struct tag_CMDGetDBInfoReq
	{
		uint32 userid;
	}CMDGetDBInfoReq_t;

	typedef struct tag_CMDGetDBInfoResp
	{
		uint32 userid;
		int32  dbport;
		char szServer[32];
		char szdbname[32];
		char szdbuser[32];
		char szdbuserpwd[32];
	}CMDGetDBInfoResp_t;

	typedef struct tag_CmdServerAuthInfo
	{
		char sz1[64];
		char sz2[64];
		char sz3[64];
		char sz4[64];
		char sz5[64];
	}CmdServerAuthInfo_t;

	//128 bytes
	typedef struct tag_CMDClientHello_2
	{
		char encrytionContent[16];  //加密后的内容
		char encrytionKey[16];
	}CMDClientHello_t_2;

}

#pragma pack()

#endif  //__MESSAGE_VCHAT_HH_20130715__


