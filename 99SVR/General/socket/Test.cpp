#if 0
#include "platform.h"
#include "Http.h"
#include "LoginConnection.h"
#include "VideoRoomConnection.h"
#include "TextRoomConnection.h"
#include "crc32.h"
#include "StatisticReport.h"

#include <exception>
#include <vector>

/*
#include "rapidjson/document.h"
#include "rapidjson/prettywriter.h"
#include "rapidjson/stringbuffer.h"
*/

#include <fstream>
#include <cassert>
#include "json/json.h"

using namespace::std;

LoginConnection conn;
RoomConnection vedio_room_conn;
TextConnection text_room_conn;


class TestLoginListener : public LoginListener
{

public:

	void OnMessageComming(void* msg)
	{
		conn.DispatchSocketMessage(msg);
	}

	void OnLogonSuccess(UserLogonSuccess2& info) 
	{
		info.Log();
	}

	void OnLogonErr(UserLogonErr2& info) 
	{
		info.Log();
	}

	void OnRoomGroupList(RoomGroupItem items[], int count) 
	{
		for (int i = 0; i < count; i++)
		{
			items[i].Log();
		}
	}

	void OnQuanxianId2List(QuanxianId2Item items[], int count) 
	{
		for (int i = 0; i < count; i++)
		{
			items[i].Log();
		}
	}

	void OnQuanxianAction2List(QuanxianAction2Item items[], int count) 
	{
		for (int i = 0; i < count; i++)
		{
			//items[i].Log();
		}
	}

	void OnLogonTokenNotify(SessionTokenResp& info) 
	{
		info.Log();
	}

	void OnLogonFinished() 
	{
		LOG("OnlogonFinished\n");
	}

};

class TestHallListener: public HallListener
{

	void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req)
	{
		info.Log();
	}

	void OnSetUserPwdResp(SetUserPwdResp& info)
	{
		info.Log();
	}

	void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info)
	{
		info.Log();
	}

	void OnGetUserMoreInfResp(GetUserMoreInfResp& info)
	{
		info.Log();
	}

	void OnUserExitMessageResp(ExitAlertResp& info)
	{
		info.Log();
	}

	void OnHallMessageNotify(MessageNoty& info)
	{
		info.Log();
	}

	void OnMessageUnreadResp(MessageUnreadResp& info)
	{
		info.Log();
	}

	void OnInteractResp(std::vector<InteractResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnHallAnswerResp(std::vector<AnswerResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnViewShowResp(std::vector<ViewShowResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnTeacherFansResp(std::vector<TeacherFansResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnInterestResp(std::vector<InterestResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnUnInterestResp(std::vector<UnInterestResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnTextLivePointListResp(std::vector<TextLivePointListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnSecretsListResp(std::vector<HallSecretsListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnSystemInfoResp(std::vector<HallSystemInfoListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnViewAnswerResp(ViewAnswerResp& info)
	{
		info.Log();
	}

	void OnInterestForResp(InterestForResp& info)
	{
		info.Log();
	}
	void OnFansCountResp(FansCountResp& info)
	{
		info.Log();
	}
};

class TestRoomListener : public RoomListener
{
	void OnMessageComming(void* msg){vedio_room_conn.DispatchSocketMessage(msg);}
	
	void OnJoinRoomResp(JoinRoomResp& info){info.Log();}//加入房间成功
	void OnJoinRoomErr(JoinRoomErr& info){info.Log();}//加入房间失败
	void OnRoomUserList(std::vector<RoomUserInfo>& infos)//房间用户列表数据
	{
		for(int i = 0; i < infos.size(); i++)
		{
			//infos[i].Log();//OK
		}
	}
	void OnRoomUserNoty(RoomUserInfo& info)//新增用户通知
	{
		info.Log();//OK
	}

	void OnRoomPubMicStateNoty(std::vector<RoomPubMicState>& infos)//公麦状态数据
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();//OK
		}
	}
	void OnRoomUserExitResp()//
	{
	}
	void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info)//房间用户退出通知
	{
		info.Log();//OK
	}

	void OnRoomKickoutUserResp(){}//
	void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info)//房间用户踢出通知
	{
		info.Log();//OK
	}

	// 暂时已荒废
	//void OnFlyGiftListInfoReq(TradeGiftRecord& info){}//大礼物信息
	
	void OnWaitiMicListInfo(std::vector<int > &infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			LOG("%d", infos[i]);//OK
		}
	}//排麦列表
	

	void OnChatErr(){}//
	void OnChatNotify(RoomChatMsg& info)
	{
		info.Log();//OK
	}//聊天通知数据

	//送礼物
	void OnTradeGiftRecordResp(TradeGiftRecord& info)
	{
		info.Log();
	}
	void OnTradeGiftErr(TradeGiftErr& info)
	{
		info.Log();
	}
	void OnTradeGiftNotify(TradeGiftRecord& info)
	{
		info.Log();//OK
	}

	//送花
	void OnTradeFlowerResp(TradeFlowerRecord& info)
	{
		info.Log();
	}
	void OnTradeFlowerErr(TradeFlowerRecord& info)
	{
		info.Log();
	}
	void OnTradeFlowerNotify(TradeFlowerRecord& info)
	{
		info.Log();
	}

	//烟火
	void OnTradeFireworksErr(TradeFireworksErr& info)
	{
		info.Log();
	}
	void OnTradeFireworksNotify(TradeFireworksNotify& info)
	{
		info.Log();
	}

	void OnLotteryGiftNotify(LotteryGiftNotice& info)
	{
		info.Log();
	}//礼物中奖通知数据

	void OnBoomGiftNotify(BoomGiftNotice& info)
	{
		info.Log();
	}//爆炸中奖通知数据

	void OnSysNoticeInfo(SysCastNotice& info)
	{
		info.Log();//OK
	}//系统消息通知数据

	void OnUserAccountInfo(UserAccountInfo& info)
	{
		info.Log();
	}//用户帐户数据

	void OnRoomManagerNotify()
	{
		//info.Log();
	}//房间管理通知数据

	void OnRoomMediaInfo(RoomMediaInfo& info)
	{
		info.Log();
	}//房间媒体数据通知

	void OnRoomNoticeNotify(RoomNotice& info)
	{
		info.Log();//OK
	}//房间公告数据通知

	void OnRoomOpState(RoomOpState& info)
	{
		info.Log();
	}//房间状态数据通知

	void OnRoomInfoNotify(RoomBaseInfo& info)
	{
		info.Log();//OK
	}//房间信息数据通知

	void OnThrowUserNotify(ThrowUserInfo& info)
	{
		info.Log();
	}//房间封杀用户通知

	void OnUpWaitMicResp(UpWaitMic& info)
	{
		info.Log();
		//LOG("OnUpWaitMicResp = %d", ret);
	}//上排麦响应
	void OnUpWaitMicErr(UpWaitMic& info)
	{
		info.Log();
		//LOG("OnUpWaitMicErr = %d", ret);
	}//上排麦错误

	void OnChangePubMicStateNotify(ChangePubMicStateNoty& info)
	{
		info.Log();//OK
	}//公麦状态通知

	//传输媒体
	void OnTransMediaReq(){}//传输媒体请求
	void OnTransMediaResp(){}//传输媒体响应
	void OnTransMediaErr(){}//传输媒体错误

	//设置麦状态
	void OnSetMicStateResp(){}//设置麦状态响应
	void OnSetMicStateErr(UserMicState& info)
	{
		info.Log();
	}//设置麦状态错误
	void OnSetMicStateNotify(UserMicState& info)
	{
		info.Log();//OK
	}//设置麦状态通知

	//设置设备状态
	void OnSetDevStateResp(UserDevState& info)
	{
		info.Log();//OK
	}//设置设备状态响应
	void OnSetDevStateErr(UserDevState& info)
	{
		info.Log();//OK
	}//设置设备状态错误
	void OnSetDevStateNotify(UserDevState& info)
	{
		info.Log();//OK
	}//设置设备状态通知

	//设置用户呢称
	void OnSetUserAliasResp(UserAliasState& info)
	{
		info.Log();//OK
	}//设置用户呢称响应
	void OnSetUserAliasErr(UserAliasState& info)
	{
		info.Log();//OK
	}//设置用户呢称错误
	void OnSetUserAliasNotify(UserAliasState& info)
	{
		info.Log();//OK
	}//设置用户呢称通知

	//设置用户权限(管理)
	void OnSetUserPriorityResp(SetUserPriorityResp& info)
	{
		info.Log();//OK
	}//设置用户权限(管理)响应
	void OnSetUserPriorityNotify(SetUserPriorityResp& info)
	{
		info.Log();//OK
	}//设置用户权限(管理)响应

	//察看用户IP
	void OnSeeUserIpResp(SeeUserIpResp& info)
	{
		info.Log();//OK
	}//察看用户IP响应
	void OnSeeUserIpErr(SeeUserIpResp& info)
	{
		info.Log();//OK
	}//察看用户IP错误

	void OnThrowUserResp(ThrowUserInfoResp& info)
	{
		info.Log();
	}//封杀房间用户响应

	void OnForbidUserChatNotify(ForbidUserChat& info)
	{
		info.Log();//OK
	}//禁言通知

	//void OnFavoriteVcbResp(){}//收藏房间响应，这个服务器其实是没有响应的

	void OnSetRoomNoticeResp(SetRoomNoticeResp& info)
	{
		info.Log();//OK
	}//设置房间公告响应

	void OnSetRoomInfoResp(SetRoomInfoResp& info)
	{
		info.Log();//OK
	}//设置房间信息响应

	void OnSetRoomOPStatusResp(SetRoomOPStatusResp& info)
	{
		info.Log();//OK
	}//设置房间状态信息响应

	void OnQueryUserAccountResp(QueryUserAccountResp& info)
	{
		info.Log();//OK
	}//查询用户帐户响应

	void OnSetWatMicMaxNumLimitNotify(SetRoomWaitMicMaxNumLimit& info)
	{
		info.Log();
	}//设置房间最大排麦数，每人最多排麦次数 通知

	void OnChangeWaitMicIndexResp(ChangeWaitMicIndexResp& info)
	{
		info.Log();
	}//修改排麦麦序响应
	
	void OnSetForbidInviteUpMicNotify(SetForbidInviteUpMic& info)
	{
		info.Log();
	}//设置禁止抱麦通知

	void OnSiegeInfoNotify(SiegeInfo& info)
	{
		info.Log();
	}//城主信息通知

	void OnOpenChestResp(OpenChestResp& info)
	{
		info.Log();
	}//开宝箱响应

	void OnQueryUserMoreInfoResp(UserMoreInfo& info)
	{
		info.Log();
	}//

	void OnSetUserProfileResp(SetUserProfileResp& info)
	{
		info.Log();
	}//设置用户配置信息响应

	void OnClientPingResp(ClientPingResp& info)
	{
		info.Log();//OK
	}//收到服务器ping消息的返回,表示房间活着

	void OnCloseRoomNotify(CloseRoomNoty& info)
	{
		info.Log();
	}//房间被关闭消息,直接退出当前房间
	
	void OnDoNotReachRoomServer()
	{
		//info.Log();
	}//收到房间不可到达消息
	
	void OnLotteryPoolNotify(LotteryPoolInfo& info)
	{
		info.Log();
	}//收到幸运宝箱奖池消息

	//暂时没用
	void OnSetUserHideStateResp(SetUserHideStateResp& info)
	{
		info.Log();
	}//

	void OnSetUserHideStateNoty(SetUserHideStateNoty& info)
	{
		info.Log();
	}//

	//暂时废置
	void OnUserAddChestNumNoty(UserAddChestNumNoty& info)
	{
		info.Log();
	}//收到用户增加新宝箱通知

	void OnAddClosedFriendNoty(AddClosedFriendNotify& info)
	{
		info.Log();
	}//收到赠送礼物增加密友通知

	void OnAdKeyWordOperateNoty(AdKeywordsNotify& info)
	{
		info.Log();//OK
	}//收到禁言关键词刷新通知

	void OnAdKeyWordOperateResp(AdKeywordsResp& info)
	{
		info.Log();//OK
	}//收到禁言关键词更新通知

	void OnTeacherScoreResp(TeacherScoreResp& info)
	{
		info.Log();//OK
	}//收到讲师评分响应

	void OnTeacherScoreRecordResp(TeacherScoreRecordResp& info)
	{
		info.Log();//OK
	}//收到用户评分响应

	void OnRobotTeacherIdNoty(RobotTeacherIdNoty& info)
	{
		info.Log();//OK
	}//上麦机器人对应讲师ID通知

	void OnTeacherGiftListResp(std::vector<TeacherGiftListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();//OK
		}
	}//讲师忠实度周版响应

	void OnHitGoldEggToClientNoty(HitGoldEggClientNoty& info)
	{
		info.Log();
	}//砸金蛋更新99币最新值

	void OnUserScoreNotify(UserScoreNoty& info)
	{
		info.Log();//OK
	}//用户对讲师的评分

	void OnUserScoreListNotify(std::vector<UserScoreNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();//OK
		}
	}//用户对讲师的评分列表

	void OnTeacherAvarageScoreNoty(TeacherAvarageScoreNoty& info)
	{
		info.Log();//OK
	}//用户对讲师的平均分

	void OnRoomAndSubRoomId_Noty(RoomAndSubRoomIdNoty& info)
	{
		info.Log();//OK
	}//

	void OnSysCastResp(Syscast& info)
	{
		info.Log();//OK
	}//系统公告
	
	//普通用户个人资料
	void OnRoomUserInfoResp(RoomUserInfoResp& info)
	{
		info.Log();//OK
	}
	
	//文字讲师个人资料
	void OnTeacherInfoResp(TeacherInfoResp& info)
	{
		info.Log();//OK
	}

	//获取用户个人资料失败
	void OnUserInfoErr(UserInfoErr& info)
	{
		info.Log();//OK
	}

	//课程订阅返回
	void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info)
	{
		info.Log();//OK
	}

	//查询订阅状态响应
	void OnTeacherSubscriptionStateQueryResp(TeacherSubscriptionStateQueryResp& info)
	{
		info.Log();//OK
	}
};


class TestTextListener : public TextListener
{
	void OnMessageComming(void* msg)
	{
		text_room_conn.DispatchSocketMessage(msg);
	}

	//收到服务器ping消息的返回,表示房间活着
	void OnClientPingResp(ClientPingResp& info)
	{
		info.Log();
	}

	//加入房间失败
	void OnJoinRoomErr(JoinRoomErr& info)
	{
		info.Log();
	}

	//加入房间成功
	void OnJoinRoomResp(JoinRoomResp& info)
	{
		info.Log();
	}

	//用户加入房间通知
	void OnRoomUserNoty(RoomUserInfo& info)
	{
		info.Log();//OK
	}

	//房间用户列表数据
	void OnRoomUserList(std::vector<RoomUserInfo>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();//OK
		}
	}

	//收到禁言关键词刷新通知
	void OnAdKeyWordOperateNoty(AdKeywordsNotify& info)
	{
		info.Log();
	}

	//收到禁言关键词更新通知
	void OnAdKeyWordOperateResp(AdKeywordsResp& info)
	{
		info.Log();
	}

	//设置房间信息响应
	void OnSetRoomInfoResp(SetRoomInfoResp& info)
	{
		info.Log();
	}

	//房间信息数据通知
	void OnRoomInfoNotify(RoomBaseInfo& info)
	{
		info.Log();
	}

	//房间状态数据通知
	void OnRoomOpState(RoomOpState& info)
	{
		info.Log();
	}

	//禁言通知
	void OnForbidUserChatNotify(ForbidUserChat& info)
	{
		info.Log();
	}

	//封杀房间用户响应
	void OnThrowUserResp(ThrowUserInfoResp& info)
	{
		info.Log();
	}

	//房间封杀用户通知
	void OnThrowUserNotify(ThrowUserInfo& info)
	{
		info.Log();
	}

	//设置用户权限(管理)响应
	void OnSetUserPriorityResp(SetUserPriorityResp& info)
	{
		info.Log();
	}

	//设置用户权限(管理)响应
	void OnSetUserPriorityNotify(SetUserPriorityResp& info)
	{
		info.Log();
	}

	//察看用户IP响应
	void OnSeeUserIpResp(SeeUserIpResp& info)
	{
		info.Log();
	}

	//察看用户IP错误
	void OnSeeUserIpErr(SeeUserIpResp& info)
	{
		info.Log();
	}

	//赠送礼物返回响应消息
	void OnTradeGiftRecordResp(TradeGiftRecord& info)
	{
		info.Log();
	}

	//赠送礼物返回错误消息
	void OnTradeGiftErr(TradeGiftErr& info)
	{
		info.Log();
	}

	//赠送礼物通知数据
	void OnTradeGiftNotify(TradeGiftRecord& info)
	{
		info.Log();
	}

	//房间用户踢出通知
	void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info)
	{
		info.Log();
	}

	//房间用户退出通知
	void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info)
	{
		info.Log();
	}

	//讲师加入房间通知
	void OnTeacherComeNotify(TeacherComeNotify& info)
	{
		info.Log();
	}

	//讲师信息
	void OnTextRoomTeacherNoty(TextRoomTeacherNoty& info)
	{
		info.Log();
	}

	//加载直播记录列表
	void OnTextRoomLiveListNoty(std::vector<TextRoomLiveListNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//加载直播重点记录列表
	void OnTextRoomLivePointNoty(std::vector<TextRoomLivePointNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//加载明日预测记录列表
	void OnTextRoomLiveForecastNoty(std::vector<TextRoomLivePointNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//直播历史列表(概况)列表
	void OnTextLiveHistoryListResp(std::vector<TextLiveHistoryListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//加载历史直播记录列表
	void OnTextLiveHistoryDaylyResp(std::vector<TextRoomLiveListNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//观点类型分类列表
	void OnTextRoomViewGroupResp(std::vector<TextRoomViewGroupResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//观点列表
	void OnTextRoomLiveViewResp(std::vector<TextRoomLiveViewResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//评论列表
	void OnTextRoomViewInfoResp(std::vector<TextRoomViewInfoResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//观点详情
	void OnTextRoomLiveViewDetailResp(TextRoomLiveViewResp& info)
	{
		info.Log();
	}

	//拜师信息(普通用户)头
	void OnNormalUserGetBeTeacherInfoRespHead(NormalUserGetBeTeacherInfoRespHead& info)
	{
		info.Log();
	}

	//拜师信息(普通用户)列表
	void OnNormalUserGetBeTeacherInfoRespItem(std::vector<NormalUserGetBeTeacherInfoRespItem>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//拜师信息(讲师)头
	void OnTeacherGetBeTeacherInfoRespHead(TeacherGetBeTeacherInfoRespHead& info)
	{
		info.Log();
	}

	//拜师信息(讲师)列表
	void OnTeacherGetBeTeacherInfoRespItem(std::vector<TeacherGetBeTeacherInfoRespItem>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//特权信息列表
	void OnGetPackagePrivilegeResp(std::vector<GetPackagePrivilegeResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//专属表情列表
	void OnTextRoomEmoticonListResp(std::vector<TextRoomEmoticonListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//加载个人秘籍记录列表
	void OnTextRoomSecretsListResp(std::vector<TextRoomSecretsListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//加载个人秘籍已购买记录列表
	void OnTextRoomSecBuyListResp(std::vector<TextRoomSecretsListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//加载个人秘籍总体信息响应
	void OnTextRoomSecretsTotalResp(TextRoomSecretsTotalResp& info)
	{
		info.Log();
	}

	//个人秘籍单次订阅响应
	void OnTextRoomBuySecretsResp(TextRoomBuySecretsResp& info)
	{
		info.Log();
	}

	//讲师发表个人秘籍通知
	void OnTextRoomSecretsPHPResp(TextRoomSecretsPHPResp& info)
	{
		info.Log();
	}

	//讲师发送文字直播响应
	void OnTextRoomLiveMessageResp(TextRoomLiveMessageResp& info)
	{
		info.Log();
	}

	//用户对直播内容点赞响应
	void OnTextRoomZanForResp(TextRoomZanForResp& info)
	{
		info.Log();
	}

	//发送聊天响应
	void OnTextRoomLiveChatResp(TextRoomLiveChatResp& info)
	{
		info.Log();
	}

	//聊天回复响应
	void OnTextLiveChatReplyResp(TextLiveChatReplyResp& info)
	{
		info.Log();
	}

	//讲师修改和新增观点类型分类响应
	void OnTextRoomViewTypeResp(TextRoomViewTypeResp& info)
	{
		info.Log();
	}

	//讲师发表观点响应
	void OnTextRoomViewMessageReqResp(TextRoomViewMessageReqResp& info)
	{
		info.Log();
	}

	//讲师发表观点响应PHP
	void OnTextRoomViewPHPResp(TextRoomViewPHPResp& info)
	{
		info.Log();
	}

	//观点评论响应
	void OnTextRoomLiveActionResp(TextRoomLiveActionResp& info)
	{
		info.Log();
	}

	//观点点赞响应
	void OnTextLiveViewZanForResp(TextRoomZanForResp& info)
	{
		info.Log();
	}

	//观点点赞响应
	void OnTextLiveViewFlowerResp(TextLiveViewFlowerResp& info)
	{
		info.Log();
	}

	//观点删除响应
	void OnTextRoomViewDeleteResp(TextRoomViewDeleteResp& info)
	{
		info.Log();
	}

	//用户提问响应
	void OnTextRoomQuestionResp(TextRoomQuestionResp& info)
	{
		info.Log();
	}

	//用户点击关注响应
	void OnTextRoomInterestForResp(TextRoomInterestForResp& info)
	{
		info.Log();
	}

	//商品状态
	void OnTextRoomGetUserGoodStatusResp(TextRoomGetUserGoodStatusResp& info)
	{
		info.Log();
	}

	//用户付费
	void OnUserPayResp(UserPayResp& info)
	{
		info.Log();
	}

	//查寻账户余额
	void OnGetUserAccountBalanceResp(GetUserAccountBalanceResp& info)
	{
		info.Log();
	}

	//普通用户个人资料
	void OnRoomUserInfoResp(RoomUserInfoResp& info)
	{
		info.Log();
	}

	//文字讲师个人资料
	void OnTeacherInfoResp(TeacherInfoResp& info)
	{
		info.Log();
	}

	//获取用户个人资料失败
	void OnUserInfoErr(UserInfoErr& info)
	{
		info.Log();
	}

	//拜师请求返回
	void OnBeTeacherResp(BeTeacherResp& info)
	{
		info.Log();
	}

	//请求拜师信息失败
	void OnGetBeTeacherInfoReqFailed()
	{
		//OK
	}

	//视频房间上麦通知
	void OnVideoRoomOnMicClientResp(VideoRoomOnMicClientResp& info)
	{
		info.Log();
	}

	//课程订阅返回
	void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info)
	{
		info.Log();
	}

};


class TestPushListener: public PushListener
{

	void OnConfChanged(int version)
	{
		LOG("OnConfChanged:%d", version);
	}
	void OnGiftListChanged(int version)
	{
	}
	void OnShowFunctionChanged(int version)
	{
	}
	void OnPrintLog()
	{
		LOG("OnPrintLog");
	}
	void OnUpdateApp()
	{
		LOG("OnUpdateApp------");
	}
	void OnMoneyChanged(uint64 money)
	{
		LOG("OnMoneyChanged:%d", money);
	}
	void OnBayWindow(BayWindow& info)
	{
		info.Log();
	}
	void OnRoomGroupChanged()
	{
	}
	void OnRoomTeacherOnMicResp(RoomTeacherOnMicResp& info)
	{
	}
};

class TestConnectionListener : public ConnectionListener
{
	void OnConnected()
	{
		LOG("OnConnected");
	}
	
	void OnConnectError(int err_code)
	{
		LOG("OnConnectError");
	}

	void OnIOError(int err_code)
	{
		LOG("OnIOError");
	}
};


TestLoginListener login_listener;
TestHallListener hall_listener;
TestPushListener push_listener;
TestConnectionListener conn_listener;

TestRoomListener room_listener;

TestTextListener text_listener;

void test()
{
	
	
	conn.RegisterMessageListener(&login_listener);
	conn.RegisterConnectionListener(&conn_listener);
	conn.RegisterHallListener(&hall_listener);
	conn.RegisterPushListener(&push_listener);

	UserLogonReq4 req4;

	req4.set_nmessageid(1);
	req4.set_cloginid("1752965");
	req4.set_nversion(3030822 + 5);
	req4.set_nmask((uint32)time(0));
	req4.set_cuserpwd("23b431acfeb41e15d466d75de822307c");
	req4.set_cserial("");
	req4.set_cmacaddr("");
	req4.set_cipaddr("");
	req4.set_nimstate(0);
	req4.set_nmobile(0);

	conn.SendMsg_LoginReq4(req4);
	
	Thread::sleep(2000);


//conn.SendMsg_MessageUnreadReq();


//HallMessageReq req;
//req.set_userid(1680008);
//req.set_teacherflag(0);
//req.set_type(12);
//req.set_messageid(0);
//req.set_startindex(0);
//req.set_count(10);
//conn.SendMsg_HallMessageReq(req);


//HallMessageReq req;
//req.set_userid(1680008);
//req.set_teacherflag(0);
//req.set_type(12);
//req.set_messageid(0);
//req.set_startindex(0);
//req.set_count(10);
//
//TextRoomList_mobile head;
//head.set_uuid("123456789");
//conn.SendMsg_HallMessageReq2(head,req);


	
//HallMessageReq req;
//req.set_userid(1680008);
//req.set_teacherflag(0);
//req.set_type(12);
//req.set_messageid(0);
//req.set_startindex(0);
//req.set_count(60);
//
//TextRoomList_mobile head;
//head.set_uuid("123456789");
//conn.SendMsg_HallMessageReq2(head,req);


//string str="猪子健是猪";
//ViewAnswerReq req;
//req.set_fromid(1680014);
//req.set_toid(1680008);
//req.set_type(3);
//req.set_messageid(111);
//req.set_textlen(strlen(str.c_str()));
//req.set_commentstype(0);
//req.set_content(str);
//conn.SendMsg_ViewAnswerReq(req);

	
	/*
	vedio_room_conn.RegisterMessageListener(&room_listener);
	vedio_room_conn.RegisterConnectionListener(&conn_listener);

	JoinRoomReq req;

	protocol::CMDJoinRoomReq2_t temreq = {0};
	
	req.set_userid(1752965);
	req.set_cuserpwd("23b431acfeb41e15d466d75de822307c");
	req.set_cipaddr("");
	req.set_cmacaddr("");
	req.set_cserial("");
	
	
	req.set_vcbid(80055);
	req.set_croompwd("588");
	req.set_devtype(0);
	req.set_time(0);



	
	text_room_conn.RegisterMessageListener(&text_listener);
	text_room_conn.RegisterConnectionListener(&conn_listener);

	JoinRoomReq2 req2;	
	protocol::CMDJoinRoomReq2_t temreq2 = {0};

	req2.set_userid(1680008);
	req2.set_cuserpwd("dad3a37aa9d50688b5157698acfd7aee");
	req2.set_cipaddr("");
	req2.set_cmacaddr("");
	req2.set_cserial("");
	req2.set_vcbid(88601);
	req2.set_croompwd("");
	req2.set_devtype(0);
	req2.set_time(0);
	req2.set_crc32(15);
	req2.set_coremessagever(10690001);
	req2.set_bloginsource(0);
	req2.set_reserve1(0);
	req2.set_reserve2(0);

	req2.SerializeToArray(&temreq2, sizeof(protocol::CMDJoinRoomReq2_t));
	uint32 crcval2 = crc32((void*)&temreq2,sizeof(protocol::CMDJoinRoomReq2_t),CRC_MAGIC);
	req2.set_crc32( crcval2 );
	text_room_conn.SendMsg_JoinRoomReq(req2, -1, -1);


text_room_conn.SendMsg_TextRoomTeacherReq(88601,1680008);


//TextRoomLiveListReq livereq;
//livereq.set_vcbid(88601);
//livereq.set_userid(1680008);
//livereq.set_teacherid(188601);
//livereq.set_type(1);
//livereq.set_messageid(0);
//livereq.set_count(10);
//text_room_conn.SendMsg_TextRoomLiveListReq(livereq);

//TextRoomList_mobile head;
//head.set_uuid("123456789");
//text_room_conn.SendMsg_TextRoomLiveListReq2(head,livereq);


//TextRoomLiveListReq livereq;
//livereq.set_vcbid(88601);
//livereq.set_userid(1680008);
//livereq.set_teacherid(188601);
//livereq.set_type(2);
//livereq.set_messageid(0);
//livereq.set_count(10);
//text_room_conn.SendMsg_TextRoomLiveListReq(livereq);
//
//TextRoomList_mobile head;
//head.set_uuid("123456789");
//text_room_conn.SendMsg_TextRoomLiveListReq2(head,livereq);


//TextRoomLiveListReq livereq;
//livereq.set_vcbid(88601);
//livereq.set_userid(1680008);
//livereq.set_teacherid(188601);
//livereq.set_type(3);
//livereq.set_messageid(0);
//livereq.set_count(10);
//text_room_conn.SendMsg_TextRoomLiveListReq(livereq);
//
//TextRoomList_mobile head;
//head.set_uuid("123456789");
//text_room_conn.SendMsg_TextRoomLiveListReq2(head,livereq);


//text_room_conn.SendMsg_LikeForTextLiveInTextRoom(88601, 1680008, 527581);

//RoomLiveChatReq livereq;
//char str[]="猪子健是只猪！！！";
//livereq.set_vcbid(88601);
//livereq.set_srcid(1680014);
//livereq.set_toid(1763584);
//livereq.set_msgtype(0);
//livereq.set_textlen(strlen(str));
//livereq.set_commentstype(20160411095236);
//livereq.set_commentstype(0);
//livereq.set_content(str);
//text_room_conn.SendMsg_TextRoomLiveChatReq(livereq);


//AdKeywordsReq KeywordPacket;
//KeywordPacket.set_num(1);
//KeywordPacket.set_ntype(1);
//KeywordPacket.set_nrunerid(1680008);
//KeywordPacket.set_naction(1);
//KeywordPacket.set_keyword("猪子健是只猪");
//KeywordPacket.set_createtime("2016-02-23 16:21");
//text_room_conn.SendMsg_ModifyAdKeywordsReq(KeywordPacket);


//SetRoomInfoReq_v2 req;
//req.set_cname("花千骨");
//req.set_cpwd("");
//req.set_nallowjoinmode(0);
//req.set_nclosecolorbar(0);
//req.set_nclosefreemic(0);
//req.set_ncloseinoutmsg(0);
//req.set_ncloseprvchat(0);
//req.set_nclosepubchat(0);
//req.set_ncloseroom(0);
//req.set_runnerid(1680014);
//req.set_vcbid(88601);
//text_room_conn.SendMsg_SetRoomBaseInfoReq_v2(req);


//SeeUserIpReq req;
//req.set_runid(1680014);
//req.set_toid(1680008);
//req.set_vcbid(88601);
//text_room_conn.SendMsg_SeeUserIpReq(req);


//UserPriority req1;
//req1.set_vcbid(88601);
//req1.set_runnerid(1680014);
//req1.set_userid(1680008);
//req1.set_action(1);
//req1.set_priority(1);
//text_room_conn.SendMsg_SetUserPriorityReq(req1);


//ForbidUserChat req22;
//req22.set_vcbid(88601);
//req22.set_action(1);
//req22.set_srcid(1680014);
//req22.set_toid(1680008);
//text_room_conn.SendMsg_ForbidUserChat(req22);


//UserKickoutRoomInfo req3;
//req3.set_mins(1);
//req3.set_resonid(0);
//req3.set_srcid(1680014);
//req3.set_toid(1763584);
//req3.set_vcbid(88601);
//text_room_conn.SendMsg_KickoutUserReq(req3);


//ThrowUserInfo req4;
//req4.set_vcbid(88601);
//req4.set_runnerid(1680014);
//req4.set_toid(1680008);
//req4.set_nscopeid(1);
//text_room_conn.SendMsg_AddUserToBlackListReq(req4);
	
	vedio_room_conn.SendMsg_JoinRoomReq2(req);
	*/

	/*
	TeacherScoreRecordReq req;

	req.set_score(5);
	req.set_userid(1803191);
	req.set_teacher_userid(198616);
	req.set_vcbid(90003);

	vedio_room_conn.SendMsg_UserScoreReq(req);
	*/

	/*
	vedio_room_conn.RegisterMessageListener(&room_listener);
	vedio_room_conn.RegisterConnectionListener(&conn_listener);

	QueryUserAccountReq req;

	req.set_userid(1803191);
	req.set_vcbid(90003);

	vedio_room_conn.SendMsg_QueryUserAccountInfo(1803191, 90003);
	*/

	/*
	vedio_room_conn.RegisterMessageListener(&room_listener);
	vedio_room_conn.RegisterConnectionListener(&conn_listener);

	SeeUserIpReq req;

	req.set_runid(1803191);
	req.set_toid(1803191);
	req.set_vcbid(90003);
	
	vedio_room_conn.SendMsg_SeeUserIpReq(req);
	*/

	/*
	vedio_room_conn.RegisterMessageListener(&room_listener);
	vedio_room_conn.RegisterConnectionListener(&conn_listener);

	UpWaitMic req;

	req.set_nmicindex(0);
	req.set_ruunerid(1803191);
	req.set_touser(1803191);
	req.set_vcbid(90003);
	
	vedio_room_conn.SendMsg_UpWaitMicReq(90003,1803191,1680040, 1);
	*/
	
	
	//LOG("%s", content);

}


#ifdef ANDROID

#include <jni.h>

extern "C" {
    JNIEXPORT void JNICALL Java_com_example_test_ProtocolLib_testp(JNIEnv* env, jobject obj);
};


JNIEXPORT void JNICALL
Java_com_example_test_ProtocolLib_testp(JNIEnv* env, jobject obj) {
    test();
}

#endif


#ifdef WIN
/*
char* lbs0 = "lbs1.99ducaijing.cn:2222,lbs2.99ducaijing.cn:2222,58.210.107.54:2222,122.193.102.23:2222,112.25.230.249:2222";
char lbs[256];


char lbss[3][10][20];
int lbs_counter[3];
bool islogining = false;

void parse_ip_port(char* s, char* ip, short& port)
{
	char* e = strchr(s, ':');
	int len = e - s;
	memcpy(ip, s, len);
	ip[len] = 0;

	port = atoi(e + 1);
}


ThreadVoid get_host_form_lbs_runnable(void* param)
{
	char recvbuf[HTTP_RECV_BUF_SIZE];
	Http http;

	char* lbs = (char*)param;
	
	char ip[20];
	short port;
	parse_ip_port(lbs, ip, port);

	//LOG("thread:lbs--:%s--%d", ip, port);

	char* content = http.GetString(ip, port, "/tygetweb", recvbuf);
	if (content != NULL)
	{
		char* end = strchr(content, '|');
		if (end != NULL)
		{
			*end = '\0';
		}

		LOG("time:%d lbs:%s host:%s", clock(), ip, content);
		if (!islogining)
		{
			islogining = true;
			LOG("****DO LOGIN***");

			const char *d = ",";
			char *p;
			p = strtok(content, d);
			while (p)
			{
				//printf("%s\n", p);

				if (strlen(p) == 1)
				{
					LOG("stype:%s", p);
				}
				else
				{
					char ip[20];
					short port;
					parse_ip_port(p, ip, port);
					LOG("first login server: %s:%d", ip, port);
					break;
				}

				p = strtok(NULL, d);
			}
		}
	}

	ThreadReturn;
}

void testlbs()
{
	const char *d = ",";
	char *p;
	strcpy(lbs, lbs0);
	p = strtok(lbs, d);
	int stype = -1;
	while (p)
	{
		//printf("%s\n", p);

		Thread::start(get_host_form_lbs_runnable, p);
		p = strtok(NULL, d);
	}
}

void testlbs2()
{
	//http://hall.99ducaijing.cn:8081/roomdata/room.php?act=roomdata
	char recvbuf[HTTP_RECV_BUF_SIZE];
	Http http;

	memset(lbss, 0, sizeof(lbss));
	memset(lbs_counter, 0, sizeof(lbs_counter));

	char* content = http.GetString("lbs1.99ducaijing.cn", 2222, "/tygetweb", recvbuf);
	//int ret = http.GetString("lbs1.99ducaijing.cn", 2222, "/tygetgate", recvbuf);
	//int ret = http.GetString("hall.99ducaijing.cn", 8081, "/roomdata/room.php?act=roomdata", recvbuf);
	if (content != NULL)
	{
		LOG("%s", recvbuf);
		//char s[] = "Golden Global   View,disk * desk";
		char* end = strchr(content, '|');
		if (end != NULL)
		{
			*end = '\0';
		}

		const char *d = ",";
		char *p;
		p = strtok(content, d);
		int stype = -1;
		while (p)
		{
			//printf("%s\n", p);
			
			if (strlen(p) == 1)
			{
				stype = p[0] - '0';
				LOG("stype:%d", stype);
			}
			else
			{
				if (stype >= 0 && stype <= 2)
				{
					int n = lbs_counter[stype];
					strcpy(lbss[stype][n], p);
					LOG("lbs:%d:%s", n, lbss[stype][n]);

					char ip[20];
					short port;
					parse_ip_port(lbss[stype][n], ip, port);
					LOG("ip:%s port:%d", ip, port);

					if (islogining == false)
					{
						islogining = true;

					}

					lbs_counter[stype]++;
				}
			}

			p = strtok(NULL, d);
		}
	}

}
*/

int main(int argc, char* argv[])
{
	
	Socket::startup();

	//get_out_ip();

	//test();
	//testlbs();

	//WaitForSingleObject((HANDLE)thread_handle, 0);

	//ReportLoginFailed(9, "testlogin", "127.0.0.1", "192.168.0.1");

	//void ReportRegisterFailed(int reg_type, rstring server_ip, rstring client_ip);
	//ReportRegisterFailed(1, "127.0.0.1", "192.168.0.1");


	//void ReportGetRoomListFailed(int userid, int room_type, rstring server_ip, rstring client_ip)
	//ReportGetRoomListFailed(1752965, 1, "127.0.0.1", "192.168.0.1");


	//void ReportJoinRoomFailed(int userid, int room_type, int roomid, rstring server_ip, rstring client_ip, rstring err)
	//ReportJoinRoomFailed(1752965, 1, 80060, "127.0.0.1", "192.168.0.1", "");

	//void ReportGetRoomUserListFailed(int userid, int room_type, int roomid, rstring server_ip, rstring client_ip, rstring err)
	//ReportGetRoomUserListFailed(1752965, 1, 80060, "127.0.0.1", "192.168.0.1", "");

	//void ReportVideoWarn(int userid, int roomid, int warn_type, rstring server_ip, rstring client_ip)
	//ReportVideoWarn(100123, 80060, 1, "127.0.0.1", "192.168.0.1");

	//void ReportCrash(rstring os, rstring version_name, rstring client_ip, rstring err)
	//ReportCrash("WIN", "1.0", "127.0.0.1", "192.168.0.1");

	//void ReportOpenHomepageFailed(int userid, rstring server_ip, rstring client_ip)
	//ReportOpenHomepageFailed(1752965, "127.0.0.1", "192.168.0.1");

	//void ReportLocalAppData(rstring os, rstring serial_number, rstring version_name, rstring app_list)
	ReportLocalAppData("WIN", "ffaa", "1.2", "99财经|offce");

	system("pause");
	Socket::cleanup();
	system("pause");

	return 0;
	/*
	Http objHttp;

	std::string request = "";
	std::string response = "";
	objHttp.SetRecvBufSize(32*1024);
	char* c_resp = objHttp.request("hall.99ducaijing.cn", 8081, "/roomdata/room2.php?act=roomList&groupid=14&client=pc");

	response = c_resp;

	
	std::string strValue = c_resp;

	time_t t1 = clock();
	ProtocolJson::Reader reader;
	ProtocolJson::Value value;

	try
	{

		if (reader.parse(strValue, value))
		{
			if(!value["groupId"].isNull())
			{
				int id_s = value["groupId"].asInt();
				//printf("\ngroupId : [%d]\n", id_s);
				
			}

			if(!value["groupList"].isNull())
			{
				ProtocolJson::Value& groupList = value["groupList"];

				int size_ = groupList.size();

				
				for(int i = 0; i < size_; i++)
				{
					//printf("\n\tgroupId :\t [%d]\n", groupList[i]["groupId"].asInt());

					ProtocolJson::Value& roomList = groupList[i]["roomList"];

					int room_size = roomList.size();

					for(int j = 0; j < room_size; j++)
					{
						//printf("\n\t\tvcbId :\t\t [%s]\t", roomList[j]["nvcbid"].asCString());
					}
					//printf("\n");
				}
				
			}
			
		}
	}
	catch ( std::exception& ex)
	{
		printf( "some error..");
	}

	time_t t2 = clock();

	printf( "cost time : %d", t2 - t1);
	
	system("pause");
	Socket::cleanup();
	system("pause");

	return 0;
	*/

}

#endif


#endif

