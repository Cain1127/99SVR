
#ifndef __MESSAGE_VCHAT_HH_20130715__
#define __MESSAGE_VCHAT_HH_20130715__

#include "message_comm.h"

#define MDM_Vchat_Login  103  //登陆
#define MDM_Vchat_Hall   104  //大厅
#define MDM_Vchat_Room   105  //房间
#define MDM_Vchat_Text   108  //文字直播间

#define MDM_Version_Value 10  //协议版本


enum {
    ERR_USER_IN_BLACK_LIST = 101,	//用户在黑名单
    ERR_JOINROOM_PWD_WRONG = 201,	//房间密码不对
    ERR_FAIL_CREATE_USER = 203,		//创建用户失败(用户名/密码失败)
    ERR_KICKOUT_SAMEACCOUNT = 107,	//同号加入房间踢出
    //add new
    ERR_EXCEPTION_QUIT_ROOM = 108,
    //end
    ERR_ROOM_NOT_EXIST = 404,		//房间不存在
    ERR_ROOM_IS_CLOSED = 405,		//房间已经关闭
    ERR_ROOM_USER_IS_FULL = 502,	//房间人数已满
    ERR_KICKOUT_TIMEOUT = 522,		//超时踢出
    ERR_KICKOUT_AD = 600			//打广告踢出
};


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
    Sub_Vchat_RoomUserExceptExitNoty = 323, //用户异常退出通知
    
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
    
    Sub_Vchat_UserScoreNotify = 214,  //用户对讲师的评分
    Sub_Vchat_UserScoreListNotify = 215,  //用户对讲师的评分广播
    
    Sub_Vchat_UserExitMessage_Req = 218,//用户退出软件的请求
    Sub_Vchat_TeacherAvarageScore_Noty = 217, //某个讲师的平均分
    Sub_Vchat_UserExitMessage_Resp = 219,//用户退出软件的响应
    
    Sub_Vchat_SysCast_Resp = 220,//房间发送系统公告
    
    Sub_Vchat_GetSecureInfoReq = 311,//客户端请求后去用户email,qq,手机号码,已提醒次数
    Sub_Vchat_GetSecureInfoResp = 312,//客户端请求后去用户email,qq,手机号码,已提醒次数的回应
    
    Sub_Vchat_HitGoldEgg_ToClient_Noty = 1001, //砸金蛋
    
    Sub_Vchat_logonReq3 = 1002, //新版登录
    
    Sub_Vchat_HallMessageNotify =           10000,//信箱小红点提醒（服务器主动推送）
    
    Sub_Vchat_HallMessageUnreadReq =        10001,//信箱未读记录数提醒请求
    Sub_Vchat_HallMessageUnreadRes =        10002,//信箱未读记录数提醒响应
    
    Sub_Vchat_HallMessageReq =              10003,//查看邮箱请求（不同分类请求用同一个消息类型及结构）
    
    Sub_Vchat_HallInteractBegin =           10004,//查看互动回复，列表开始
    Sub_Vchat_HallInteractRes =             10005,//查看互动回复，响应
    Sub_Vchat_HallInteractEnd =             10006,//查看互动回复，列表结束
    
    Sub_Vchat_HallAnswerBegin =             10007,//查看问答提醒，列表开始
    Sub_Vchat_HallAnswerRes =               10008,//查看问答提醒，响应
    Sub_Vchat_HallAnswerEnd =               10009,//查看问答提醒，列表结束
    
    Sub_Vchat_HallViewShowBegin =           10010,//查看观点回复，列表开始
    Sub_Vchat_HallViewShowRes =             10011,//查看观点回复，响应
    Sub_Vchat_HallViewShowEnd =             10012,//查看观点回复，列表结束
    
    Sub_Vchat_HallTeacherFansBegin =        10013,//查看我的粉丝，列表开始
    Sub_Vchat_HallTeacherFansRes =          10014,//查看我的粉丝，响应
    Sub_Vchat_HallTeacherFansEnd =          10015,//查看我的粉丝，列表结束
    
    Sub_Vchat_HallInterestBegin =           10016,//查看我的关注（已关注讲师），列表开始
    Sub_Vchat_HallInterestRes =             10017,//查看我的关注（已关注讲师），响应
    Sub_Vchat_HallInterestEnd =             10018,//查看我的关注（已关注讲师），列表结束
    
    Sub_Vchat_HallUnInterestBegin =         10019,//查看我的关注（无关注讲师），列表开始
    Sub_Vchat_HallUnInterestRes =           10020,//查看我的关注（无关注讲师），响应
    Sub_Vchat_HallUnInterestEnd =           10021,//查看我的关注（无关注讲师），列表结束
    
    Sub_Vchat_TextLivePointListBegin =      10022,//查看明日预测（已关注的讲师），列表开始
    Sub_Vchat_TextLivePointListRes =        10023,//查看明日预测（已关注的讲师），响应
    Sub_Vchat_TextLivePointListEnd =        10024,//查看明日预测（已关注的讲师），列表结束
    
    Sub_Vchat_HallViewAnswerReq =           10025,//讲师回复（包含观点回复和回答提问）请求
    Sub_Vchat_HallViewAnswerRes =           10026,//讲师回复（包含观点回复和回答提问）响应
    
    Sub_Vchat_HallInterestForReq =          10027,//关注（无关注讲师时返回所有讲师列表，点击关注）请求
    Sub_Vchat_HallInterestForRes =          10028,//关注（无关注讲师时返回所有讲师列表，点击关注）响应
    
    Sub_Vchat_HallMessageReq_Mobile =       10029,//查看邮箱请求（不同分类请求用同一个消息类型及结构）(暂时只给手机查询列表)
    
    Sub_Vchat_HallInteractRes_Mobile =      10030,//查看互动回复，响应(暂时只给手机查询列表)
    Sub_Vchat_HallAnswerRes_Mobile =        10031,//查看问答提醒，响应(暂时只给手机查询列表)
    Sub_Vchat_HallViewShowRes_Mobile =      10032,//查看观点回复，响应(暂时只给手机查询列表)
    Sub_Vchat_HallTeacherFansRes_Mobile =   10033,//查看我的粉丝，响应(暂时只给手机查询列表)
    Sub_Vchat_HallInterestRes_Mobile =      10034,//查看我的关注（已关注讲师），响应(暂时只给手机查询列表)
    Sub_Vchat_HallUnInterestRes_Mobile =    10035,//查看我的关注（无关注讲师），响应(暂时只给手机查询列表)
    Sub_Vchat_TextLivePointListRes_Mobile = 10036,//查看明日预测（已关注的讲师），响应(暂时只给手机查询列表)
    
    
    Sub_Vchat_TextRoomJoinReq =             10100,//加入房间请求
    Sub_Vchat_TextRoomJoinErr =             10101,//加入房间出错响应
    Sub_Vchat_TextRoomJoinRes =             10102,//加入房间成功响应
    
    Sub_Vchat_TextTeacherRoomJoinNoty =     10103,//讲师加入房间成功通知
    Sub_Vchat_TextUserRoomJoinNoty =        10104,//用户加入房间成功通知
    
    Sub_Vchat_TextRoomTeacherReq =          10105,//加入房间成功后推送讲师信息请求
    Sub_Vchat_TextRoomTeacherNotify =       10106,//加入房间成功后推送讲师信息响应
    
    Sub_Vchat_TextRoomLiveListReq =         10107,//加载直播记录请求
    
    Sub_Vchat_TextRoomLiveListBegin =       10108,//加载直播记录，列表开始
    Sub_Vchat_TextRoomLiveListNotify  =     10109,//加载直播记录，响应
    Sub_Vchat_TextRoomLiveListEnd =         10110,//加载直播记录请求，列表结束
    
    Sub_Vchat_TextRoomLivePointBegin =      10111,//加载直播重点记录，列表开始
    Sub_Vchat_TextRoomLivePointNotify  =    10112,//加载直播重点记录，响应
    Sub_Vchat_TextRoomLivePointEnd =        10113,//加载直播重点记录，列表结束
    
    Sub_Vchat_TextRoomForecastBegin =       10114,//加载明日预测记录，列表开始
    Sub_Vchat_TextRoomForecastNotify  =     10115,//加载明日预测记录，响应
    Sub_Vchat_TextRoomForecastEnd =         10116,//加载明日预测记录，列表结束
    
    Sub_Vchat_TextRoomLiveMessageReq =      10117,//讲师发送文字直播请求
    Sub_Vchat_TextRoomLiveMessageRes =      10118,//讲师发送文字直播响应
    
    Sub_Vchat_TextRoomInterestForReq =      10119,//用户点击关注请求
    Sub_Vchat_TextRoomInterestForRes =      10120,//用户点击关注响应
    
    Sub_Vchat_TextRoomQuestionReq =         10121,//用户点击提问请求
    Sub_Vchat_TextRoomQuestionRes =         10122,//用户点击提问响应
    
    Sub_Vchat_TextRoomZanForReq =           10123,//用户对直播内容点赞请求
    Sub_Vchat_TextRoomZanForRes =           10124,//用户对直播内容点赞响应
    
    Sub_Vchat_TextRoomLiveChatReq =         10125,//聊天请求
    Sub_Vchat_TextRoomLiveChatRes =         10126,//聊天响应
    
    Sub_Vchat_TextLiveChatReplyReq =        10127,//聊天回复(互动)请求
    Sub_Vchat_TextLiveChatReplyRes =        10128,//聊天回复(互动)响应
    
    Sub_Vchat_TextRoomLiveViewReq =         10129,//点击查看观点请求
    
    Sub_Vchat_TextRoomViewGroupBegin =      10130,//观点类型分类，列表开始
    Sub_Vchat_TextRoomViewGroupRes =        10131,//观点类型分类，响应
    Sub_Vchat_TextRoomViewGroupEnd =        10132,//观点类型分类，列表结束
    
    Sub_Vchat_TextRoomViewListShowReq =     10133,//点击观点类型分类请求
    
    Sub_Vchat_TextRoomLiveViewBegin =       10134,//观点列表，开始
    Sub_Vchat_TextRoomLiveViewRes =         10135,//观点列表，响应
    Sub_Vchat_TextRoomLiveViewEnd =         10136,//观点列表，结束
    
    Sub_Vchat_TextRoomLiveViewDetailReq =   10137,//点击查看观点详情请求
    
    Sub_Vchat_TextRoomViewInfoBegin =       10138,//观点详细信息，列表开始
    Sub_Vchat_TextRoomLiveViewDetailRes =   10139,//观点详细信息（观点），响应
    Sub_Vchat_TextRoomViewInfoRes =         10140,//观点详细信息（评论），响应
    Sub_Vchat_TextRoomViewInfoEnd =         10141,//观点详细信息，列表结束
    
    Sub_Vchat_TextRoomViewTypeReq =         10142,//讲师新增/修改/删除观点类型分类请求
    Sub_Vchat_TextRoomViewTypeRes =         10143,//讲师新增/修改/删除观点类型分类响应
    
    Sub_Vchat_TextRoomViewMessageReq =      10144,//讲师发布观点或修改观点请求
    Sub_Vchat_TextRoomViewMessageRes =      10145,//讲师发布观点或修改观点响应
    
    Sub_Vchat_TextRoomViewDeleteReq =       10146,//讲师删除观点请求
    Sub_Vchat_TextRoomViewDeleteRes =       10147,//讲师删除观点响应
    
    Sub_Vchat_TextRoomViewCommentReq =      10148,//观点进行评论请求
    Sub_Vchat_TextRoomViewCommentRes =      10149,//观点进行评论响应
    
    Sub_Vchat_TextLiveViewZanForReq =       10150,//观点评论查看页面点赞请求
    Sub_Vchat_TextLiveViewZanForRes =       10151,//观点评论查看页面点赞响应
    
    Sub_Vchat_TextLiveViewFlowerReq =       10152,//观点评论详细页送花请求
    Sub_Vchat_TextLiveViewFlowerRes =       10153,//观点评论详细页送花响应
    
    Sub_Vchat_TextLiveHistoryListReq =      10154,//直播历史（可分页请求展示）请求
    
    Sub_Vchat_TextLiveHistoryListBegin =    10155,//直播历史，列表开始
    Sub_Vchat_TextLiveHistoryListRes =      10156,//直播历史，响应
    Sub_Vchat_TextLiveHistoryListEnd =      10157,//直播历史，列表结束
    
    Sub_Vchat_TextLiveHistoryDaylyReq =     10158,//某一天的直播记录列表请求（可分页请求展示）请求
    
    Sub_Vchat_TextLiveHistoryDaylyBegin =   10159,//某一天的直播记录列表，列表开始
    Sub_Vchat_TextLiveHistoryDaylyRes =     10160,//某一天的直播记录列表，响应
    Sub_Vchat_TextLiveHistoryDaylyEnd =     10161,//某一天的直播记录列表，列表结束
    
    Sub_Vchat_TextLiveUserExitReq =         10162,//退出房间请求
    Sub_Vchat_TextLiveUserExitRes =         10163,//退出房间响应
    
    Sub_Vchat_TextRoomViewListReq_Mobile =  10164,//点击观点类型分类请求(暂时只给手机查询列表)
    Sub_Vchat_TextRoomViewRes_Mobile     =  10165, //观点列表，响应(暂时只给手机查询列表)
    
    Sub_Vchat_TextRoomLiveListReq_Mobile =  10166,//加载直播记录请求(暂时只给手机查询列表)
    Sub_Vchat_TextRoomLiveListRes_Mobile =  10167,//加载直播记录，响应(暂时只给手机查询列表)
    Sub_Vchat_TextRoomLivePointRes_Mobile  =10168,//加载直播重点记录，响应(暂时只给手机查询列表)
    Sub_Vchat_TextRoomForecastRes_Mobile  = 10169,//加载明日预测记录，响应(暂时只给手机查询列表)
    
    Sub_Vchat_TextRoomLiveViewReq_Mobile=   10170,//点击查看观点请求(暂时只给手机查询列表)
    Sub_Vchat_TextRoomViewGroupRes_Mobile = 10171,///观点类型分类，响应(暂时只给手机查询列表)
    
    Sub_Vchat_TextRoomLiveViewDetailReq_Mobile=10172,//点击查看观点详情请求(暂时只给手机查询列表)
    Sub_Vchat_TextRoomViewInfoRes_Mobile =     10173,//观点详细信息（评论），响应(暂时只给手机查询列表)
    
    Sub_Vchat_TextLiveHistoryListReq_Mobile=10174,//直播历史（可分页请求展示）请求(暂时只给手机查询列表)
    Sub_Vchat_TextLiveHistoryListRes_Mobile=10175,//直播历史，响应(暂时只给手机查询列表)
    
    Sub_Vchat_TextLiveHistoryDaylyReq_Mobile=10176,//某一天的直播记录列表请求（可分页请求展示）请求(暂时只给手机查询列表)
    Sub_Vchat_TextLiveHistoryDaylyRes_Mobile=10177,//某一天的直播记录列表，响应(暂时只给手机查询列表)
    
    Sub_Vchat_TextRoomViewPHPReq =      10178,//讲师通过PHP页面发布观点或修改观点或删除观点请求
    Sub_Vchat_TextRoomViewPHPRes =      10179,//讲师通过PHP页面发布观点或修改观点或删除观点响应
    
    Sub_Vchat_HallGetFansCountReq =     10180,
    Sub_Vchat_HallGetFansCountRes =     10181,
    
    Sub_Vchat_logonReq4 = 1004,        //自定义登录
    Sub_Vchat_logonReq5 = 1005,        //第三方登录
    Sub_Vchat_logonErr2 = 1006,        //登陆失败
    Sub_Vchat_logonSuccess2 = 1007,    //登陆成功
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

#pragma pack()



#endif  //__MESSAGE_VCHAT_HH_20130715__

