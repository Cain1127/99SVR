
#ifndef __MESSAGE_VCHAT_HH_20130715__
#define __MESSAGE_VCHAT_HH_20130715__

#include "message_comm.h"

#define MDM_Vchat_Login  103  //登陆
#define MDM_Vchat_Hall   104  //大厅
#define MDM_Vchat_Room   105  //房间

#define MDM_Version_Value 10  //协议版本

enum {
    Sub_Vchat_ClientHello = 1,         //握手,每个MDM mainCmd不一样
    Sub_Vchat_ClientPing = 2,             //ping,每个MDM mainCmd不一样
    Sub_Vchat_ClientPingResp = 3,         //ping回应

	//logon消息
    Sub_Vchat_logonReq = 4,               //登录
    Sub_Vchat_logonErr = 5,               //登陆失败
    Sub_Vchat_logonSuccess = 6,           //登陆成功
    Sub_Vchat_UserQuanxianBegin = 7,       //用户权限数据
    Sub_Vchat_UserQuanxianLst = 8,         //
    Sub_Vchat_UserQuanxianEnd = 9,         //
    Sub_Vchat_logonFinished = 10,          //登录完成,无数据

	//暂不使用----- 使用web注册
    Sub_Vchat_RegisteReq = 11,             //注册,目前简单的注册还是走web(同样跨平台).降低开发成本,跳转或嵌入页面注册.
    Sub_Vchat_RegisteErr = 12,
    Sub_Vchat_RegisteSuccess = 13,
	//-------------

    Sub_Vchat_SetUserIMStatusReq = 14,     //设置用户状态(除dev,mic之外的online状态: hide,busing,online,leave)
    Sub_Vchat_setUserIMStatusResp = 15,
    Sub_Vchat_setUserIMStatusErr = 16,

	//lobby消息,暂时使用常连接,与logonsvr使用一个服务器
    Sub_Vchat_RoomGroupListReq = 17,        //房间组列表请求
    Sub_Vchat_RoomGroupListBegin = 18,
    Sub_Vchat_RoomGroupListResp = 19,
    Sub_Vchat_RoomGroupListFinished = 20,

    Sub_Vchat_RoomGroupStatusReq = 21,          //房间组状态(人数)请求
    Sub_Vchat_RoomGroupStatusResp = 22,         //
    Sub_Vchat_RoomGroupStatusFinished = 23,     //房间组状态(人数)列表结束

    Sub_Vchat_RoomListReq = 24,             //房间列表请求
    Sub_Vchat_RoomListBegin = 25,
    Sub_Vchat_RoomListResp = 26,
    Sub_Vchat_RoomListFinished = 27,        //获取房间列表结束

	//room消息
    Sub_Vchat_JoinRoomReq = 28,             //加入房间请求
    Sub_Vchat_JoinRoomErr = 29,                   //错误
    Sub_Vchat_JoinRoomResp = 30,                  //成功,含管理列表
    Sub_Vchat_JoinOtherRoomNoty = 31,       //进入 其他房间通知 (服务器之间用)

    Sub_Vchat_RoomUserListReq = 32,         //房间用户列表请求
    Sub_Vchat_RoomUserListBegin = 33,  //ad by guchengzhi 20150202
    Sub_Vchat_RoomUserListResp = 34,              //回应(推播)
    Sub_Vchat_RoomUserListFinished = 35,          //请求加入房间阶段完成,界面更新数据
    Sub_Vchat_RoomUserNoty = 36,            //列表更新通知

    Sub_Vchat_RoomPubMicState = 37,         //房间公麦状态

    Sub_Vchat_RoomUserExitReq = 38,         //用户自己退出房间
    Sub_Vchat_RoomUserExitResp = 39,              //
    Sub_Vchat_RoomUserExitNoty = 40,              //通知

    Sub_Vchat_RoomKickoutUserReq = 41,      //踢出用户请求
    Sub_Vchat_RoomKickoutUserResp = 42,           //
    Sub_Vchat_RoomKickoutUserNoty = 43,           //通知

    Sub_Vchat_GetFlyGiftListReq = 44,       //请求大礼物列表(跑道信息)
    Sub_Vchat_FlyGiftListInfo = 45,         //大礼物列表(跑道信息)

    Sub_Vchat_WaitiMicListInfo = 46,          //排麦用户列表

    Sub_Vchat_ChatReq = 47,                 //聊天发出消息
    Sub_Vchat_ChatErr = 48,                       //
    Sub_Vchat_ChatNotify = 49,                    //转发消息

    Sub_Vchat_TradeGiftReq = 50,             //赠送礼物(跨房间,跨平台)请求
    Sub_Vchat_TradeGiftResp = 51,                 //
    Sub_Vchat_TradeGiftErr = 52,                  //
    Sub_Vchat_TradeGiftNotify = 53,               //

    Sub_Vchat_TradeFlowerReq = 54,            //赠送鲜花请求,因为只是限制于当前房间的应用,因此参数将会少很多
    Sub_Vchat_TradeFlowerResp = 55,                  //
    Sub_Vchat_TradeFlowerErr = 56,                   //
    Sub_Vchat_TradeFlowerNotify = 57,                //

    Sub_Vchat_TradeFireworksReq = 58,              //赠送烟花(结果)请求, 请求者送烟花时还是当时普通礼物发出去,通过giftid判断是不是烟花类礼物
    Sub_Vchat_TradeFireworksResp = 59,
    Sub_Vchat_TradeFireworksErr = 60,
    Sub_Vchat_TradeFireworksNotify = 61,           //赠送烟花(结果)通知?
	
    Sub_Vchat_LotteryPoolNotify = 62,          //幸运奖池广播消息
    Sub_Vchat_LotteryGiftNotify = 63,          //中奖幸运礼物广播消息
    Sub_Vchat_BoomGiftNotify = 64,             //中奖爆炸礼物广播消息
    Sub_Vchat_SysNoticeInfo = 65,              //系统广播(专门)消息

    Sub_Vchat_UserAccountInfo = 66,            //用户账户(余额)信息

    Sub_Vchat_RoomInfoNotify = 67,             //房间信息资料
    Sub_Vchat_RoomManagerNotify = 68,          //房间管理员
    Sub_Vchat_RoomMediaNotify = 69,            //房间媒体
    Sub_Vchat_RoomNoticeNotify = 70,           //房间公告
    Sub_Vchat_RoomOPStatusNotify = 71,         //房间状态

    Sub_Vchat_TransMediaReq = 72,              //音视频媒体请求
    Sub_Vchat_TransMediaResp = 73,                 //
    Sub_Vchat_TransMediaErr = 74,                  //

    Sub_Vchat_SetMicStateReq = 75,             //设置上/下麦状态
    Sub_Vchat_SetMicStateResp = 76,                //
    Sub_Vchat_SetMicStateErr = 77,                 //
    Sub_Vchat_SetMicStateNotify = 78,              //

    Sub_Vchat_SetDevStateReq = 79,             //设置设备状态
    Sub_Vchat_SetDevStateResp = 80,                 //
    Sub_Vchat_SetDevStateErr = 81,                  //
    Sub_Vchat_SetDevStateNotify = 82,               //

    Sub_Vchat_SetUserAliasReq = 83,            //设置用户呢称
    Sub_Vchat_SetUserAliasResp = 84,                //
    Sub_Vchat_SetUserAliasErr = 85,                 //
    Sub_Vchat_SetUserAliasNotify = 86,              //

    Sub_Vchat_SetUserPriorityReq = 87,         //设置用户权限
    Sub_Vchat_SetUserPriorityResp = 88,             //
    Sub_Vchat_SetUserPriorityNotify = 89,           //

    Sub_Vchat_SeeUserIpReq = 90,                 //查看用户IP请求
    Sub_Vchat_SeeUserIpResp = 91,                   //
    Sub_Vchat_SeeUserIpErr = 92,                    //

    Sub_Vchat_ThrowUserReq = 93,                 //封杀用户
    Sub_Vchat_ThrowUserResp = 94,                   //
    Sub_Vchat_ThrowUserNotify = 95,                 //

    Sub_Vchat_SendUserSealReq = 96,              //盖章请求
    Sub_Vchat_SendUserSealErr = 97,
    Sub_Vchat_SendUserSealNotify = 98,              //

    Sub_Vchat_ForbidUserChatReq = 99,            //禁言用户请求
    Sub_Vchat_ForbidUserChatNotify = 100,            //

    Sub_Vchat_FavoriteVcbReq = 101,                //收藏房间请求
    Sub_Vchat_FavoriteVcbResp = 102,                  //

    Sub_Vchat_ChangePubMicStateReq = 103,          //设置公麦状态
    Sub_Vchat_ChangePubMicStateResp = 104,              //
    Sub_Vchat_ChangePubMicStateNotify = 105,            //

    Sub_Vchat_UpWaitMicReq = 106,                 //
    Sub_Vchat_UpWaitMicResp = 107,
    Sub_Vchat_UpWaitMicErr = 108,
    Sub_Vchat_ChangeWaitMicIndexReq = 109,        //设置排麦麦序
    Sub_Vchat_ChangeWaitMicIndexResp = 110,          //
    Sub_Vchat_ChangeWaitMicIndexNotify = 111,

    Sub_Vchat_LootUserMicReq = 112,                 //夺用户(公)麦请求
    Sub_Vcaht_lootUserMicResp = 113,                   //
    Sub_Vchat_LootUserMicNotify = 114,                 //

    Sub_Vchat_SetRoomInfoReq = 115,               //设置房间信息请求
    Sub_Vchat_SetRoomInfoResp = 116,                 //
    Sub_Vchat_SetRoomOPStatusReq = 117,           //设置房间运行属性(状态)
    Sub_Vchat_SetRoomOPStatusResp = 118,              //
    Sub_Vchat_SetRoomNoticeReq = 119,             //设置房间公告信息请求
    Sub_Vchat_SetRoomNoticeResp = 120,                   //
    Sub_Vchat_SetRoomMediaReq = 121,              //设置房间媒体服务器请求 add by guchengzhi 20150202

    Sub_Vchat_SetUserProfileReq = 122,            //设置用户资料
    Sub_Vchat_SetUserProfileResp = 123,              //
    Sub_Vchat_SetUserPwdReq = 124,                //设置用户密码
    Sub_Vchat_SetUserPwdResp = 125,                  //

    Sub_Vchat_SetExecQueryReq = 126,
    Sub_Vchat_SetExecQueryResp = 127,
    Sub_Vchat_GetDBInfoReq = 128,
    Sub_Vchat_GetDBInfoResp = 129,

    Sub_Vchat_QueryUserAccountReq = 130,          // 用户账户查询(银行查询)
    Sub_Vchat_QueryUserAccountResp = 131,

	//存,取款信令 //所有有关金币积分操作使用同一个信令
    Sub_Vchat_MoneyAndPointOpReq = 132,
    Sub_Vchat_MoneyAndPointOpResp = 133,
    Sub_Vchat_MoneyAndPointOpErr = 134,
    Sub_Vchat_MoneyAndPointOpNotify = 135,

    Sub_Vchat_SetWatMicMaxNumLimitReq = 136,
    Sub_Vchat_SetWatMicMaxNumLimitErr = 137,
    Sub_Vchat_SetWatMicMaxNumLimitNotify = 138,

    Sub_Vchat_SetForbidInviteUpMicReq = 139,
    Sub_Vchat_SetForbidInviteUpMicResp = 140,
    Sub_Vchat_SetForbidInviteUpMicNotify = 141,

	Sub_Vchat_GetSiegeInfoRequest = 142,      //获取城主消息
	Sub_Vchat_SiegeInfoNotify  =143,

    Sub_Vchat_QueryVcbExistReq = 144,      //查询某房间是否存在
    Sub_Vchat_QueryVcbExistResp = 145,     //该消息没有err
    Sub_Vchat_QueryUserExistReq = 146,     //查询某用户是否存在
    Sub_Vchat_QueryUserExistResp = 147,    //该消息没有err

    Sub_Vchat_OpenChestReq = 148,         //用户开宝箱请求
    Sub_Vchat_OpenChestResp = 149,        //错误也在里面

    Sub_Vchat_CurMobZhuboNotify = 150,      //当前主播信息

    Sub_Vchat_UserCaifuCostLevelNotify = 151, //用户财富消费排行等级实时更新消息

    Sub_Vchat_GetUserNetworkTypeReq = 152,  //获取用户网络类型
    Sub_Vchat_GetUserNetworkTypeResp = 153,
    Sub_Vchat_SetUserNetworkTypeReq = 154,  //设置用户的网络类型
    Sub_Vchat_SetUserNetworkTypeResp = 155,

    Sub_Vchat_GetUserVideoSmoothReq = 156,  //获取用户的视频流畅度
    Sub_Vchat_GetUserVideoSmoothResp = 157,
    Sub_Vchat_SetUserVideoSmoothReq = 158, //设置用户的视频流畅度
    Sub_Vchat_SetUserVideoSmoothResp = 159,

    Sub_Vchat_SetUserMoreInfoReq = 160,    //设置用户更多信息
    Sub_Vchat_SetUserMoreInfoResp = 161,
    Sub_Vchat_QueryUserMoreInfoReq = 162,   //查询用户更多信息
    Sub_Vchat_QueryUserMoreInfoResp = 163,

	Sub_Vchat_QuanxianId2ListResp =164, //权限id数据
	Sub_Vchat_QuanxianAction2ListBegin=165, //权限操作数据
	Sub_Vchat_QuanxianAction2ListResp=166,
	Sub_Vchat_QuanxianAction2ListFinished=167,

	//3套保留指令, 先占位,使用的时候,在修改指令名称
    Sub_Vchat_MessageReq_reserve1_req = 168,
    Sub_Vchat_MessageReq_reserve1_resp = 169,
    Sub_Vchat_MessageReq_reserve1_noty = 170,

    Sub_Vchat_MessageReq_reserve2_req = 171,
    Sub_Vchat_MessageReq_reserve2_resp = 172,
    Sub_Vchat_MessageReq_reserve2_noty = 173,

    Sub_Vchat_MessageReq_reserve3_req = 174,
    Sub_Vchat_MessageReq_reserve3_resp = 175,
    Sub_Vchat_MessageReq_reserve3_noty = 176,
    //~~~~

    Sub_Vchat_GateCloseObjectReq = 177,   //关闭网关上面的对象
    Sub_Vchat_CloseRoomNotify = 178,      //关闭房间通知
    Sub_Vchat_DoNotReachRoomServer = 179,
    Sub_Vchat_RoomGatePing = 180,

	//新增信令
    Sub_Vchat_SetRoomInfoReq_v2 = 181,    //设置房间信息请求飞叉版
    Sub_Vchat_SetRoomInfoResp_v2 = 182,
    Sub_Vchat_SetRoomInfoNoty_v2 = 183,

    Sub_Vchat_QueryRoomGateAddrReq = 184,   //获取房间网关地址
    Sub_Vchat_QueryRoomGateAddrResp = 185,

    Sub_Vchat_SetUserHideStateReq = 186,  //设置用户隐身状态
    Sub_Vchat_SetUserHideStateResp = 187,
    Sub_VChat_SetUserHideStateNoty = 188,

    Sub_Vchat_UserAddChestNumNoty = 189,  //用户新增宝箱消息

    Sub_Vchat_AddClosedFriendReq = 190,   //增加密友功能
    Sub_Vchat_AddClosedFriendResp = 191,
    Sub_Vchat_AddClosedFriendNoty = 192,
	
    Sub_Vchat_logonReq2 = 193, //新的登录结构
	
    Sub_Vchat_AdKeyWordOperateReq = 194,	//关键字操作请求
    Sub_Vchat_AdKeyWordOperateResp = 195,  //关键字操作回应
	Sub_Vchat_AdKeyWordOperateNoty = 196,	//关键字广播通知

	Sub_Vchat_TeacherScoreReq = 197,//讲师发送评分处理请求
	Sub_Vchat_TeacherScoreResp = 198,//讲师发送评分处理响应
	Sub_Vchat_TeacherScoreRecordReq = 199,  //用户评分请求
	Sub_Vchat_TeacherScoreRecordResp = 200,//用户评分响应

	Sub_Vchat_RoborTeacherIdNoty = 201,  //机器人对应讲师ID通知  

	Sub_Vchat_TeacherGiftListReq = 202,  //讲师忠实度周版请求
	Sub_Vchat_TeacherGiftListResp = 203,  //讲师忠实度周版响应

	Sub_Vchat_MgrRefreshListReq = 204,            //刷新用户列表
	Sub_Vchat_MgrRefreshListNotify = 205,            //

	Sub_Vchat_MgrRelieveBlackDBReq = 206,		//解封请求
	Sub_Vchat_MgrRelieveBlackDBNoty = 207,

	Sub_Vchat_ReportMediaGateReq = 208, //客户端报告媒体服务器和网关服务器
	Sub_Vchat_ReportMediaGateResp = 209, //客户端报告媒体服务器和网关服务器的回应
    Sub_Vchar_RoomAndSubRoomId_Noty = 216,
    Sub_Vchat_logonReq3 = 1002,
};

typedef enum MediaConnectActionType
{
	Connect_You = 1,
	Disconnect_You = 3,
}e_MediaConnectActionType;


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

typedef struct tag_CMDRoomAndSubRoomIdNoty
{
    uint32 roomid;                 //主房间ID
    uint32 subroomid;              //子房间ID
}CMDRoomAndSubRoomIdNoty_t;

enum {
    RoomMgrType_Null      = 0,    //没有
    RoomMgrType_Fangzhu   = 1,    //房主
    RoomMgrType_FuFangzhu = 2,    //副房主
    RoomMgrType_Guan      = 3,    //正管
    RoomMgrType_LinGuan   = 4,    //临管
    RoomMgrType_Quzhang   = 5,    //区长
    RoomMgrType_Daili    = 6,    //真代理
    RoomMgrType_Quzhang2  = 7,    //大区长
    RoomMgrType_FuQuzhang = 8,    //副区长
    RoomMgrType_FuQuzhang2  = 9,  //大区副长
    RoomMgrType_ZengsongLinGuan   = 10, //某些等级或者消费大户额外附带的管理标志,跟真正的管理和临管部一样,只是具备房间某些操作权限,
    //具体什么操作权限,根据其消费来决定
    RoomMgrType_Quzhang_zhuli = 11, //区长助理
    RoomMgrType_Quzhang_zhuli2 = 12, //大区长助理
};

#pragma pack()



#endif  //__MESSAGE_VCHAT_HH_20130715__

