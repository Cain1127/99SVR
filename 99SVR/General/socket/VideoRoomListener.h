#ifndef __ROOM_LISTENER_H__
#define __ROOM_LISTENER_H__

#include <vector>
#include "VideoRoomMessage.pb.h"
#include "CommonroomMessage.pb.h"

class VideoRoomListener
{
public:

	//房间用户列表数据
	virtual void OnRoomUserList(std::vector<RoomUserInfo>& infos) = 0;

	//新增用户通知
	virtual void OnRoomUserNoty(RoomUserInfo& info) = 0;

	//公麦状态数据
	virtual void OnRoomPubMicStateNoty(std::vector<RoomPubMicState>& infos) = 0;

	//房间用户退出响应
	virtual void OnRoomUserExitResp() = 0;

	//房间用户退出通知
	virtual void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info) = 0;

	//房间用户踢出响应
	virtual void OnRoomKickoutUserResp() = 0;

	//房间用户踢出通知
	virtual void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info) = 0;
	
	//排麦列表
	virtual void OnWaitiMicListInfo(std::vector<int > &infos) = 0;
	
	//聊天发送失败响应
	virtual void OnChatErr() = 0;

	//聊天通知数据
	virtual void OnChatNotify(RoomChatMsg& info) = 0;

	//赠送礼物成功响应
	virtual void OnTradeGiftRecordResp(TradeGiftRecord& info) = 0;

	//赠送礼物失败响应
	virtual void OnTradeGiftErr(TradeGiftErr& info) = 0;

	//赠送礼物通知
	virtual void OnTradeGiftNotify(TradeGiftRecord& info) = 0;

	//系统消息通知数据
	virtual void OnSysNoticeInfo(SysCastNotice& info) = 0;

	//用户帐户数据
	virtual void OnUserAccountInfo(UserAccountInfo& info) = 0;

	//房间管理通知数据
	virtual void OnRoomManagerNotify() = 0;

	//房间媒体数据通知
	virtual void OnRoomMediaInfo(RoomMediaInfo& info) = 0;

	//房间公告数据通知
	virtual void OnRoomNoticeNotify(RoomNotice& info) = 0;

	//房间状态数据通知
	virtual void OnRoomOpState(RoomOpState& info) = 0;

	//房间信息数据通知
	virtual void OnRoomInfoNotify(RoomBaseInfo& info) = 0;

	//房间封杀用户通知
	virtual void OnThrowUserNotify(ThrowUserInfo& info) = 0;

	//上排麦响应
	virtual void OnUpWaitMicResp(UpWaitMic& info) = 0;

	//上排麦错误
	virtual void OnUpWaitMicErr(UpWaitMic& info) = 0;

	//公麦状态通知
	virtual void OnChangePubMicStateNotify(ChangePubMicStateNoty& info) = 0;

	//设置麦状态响应
	virtual void OnSetMicStateResp() = 0;

	//设置麦状态错误
	virtual void OnSetMicStateErr(UserMicState& info) = 0;

	//设置麦状态通知
	virtual void OnSetMicStateNotify(UserMicState& info) = 0;

	//设置设备状态响应
	virtual void OnSetDevStateResp(UserDevState& info) = 0;

	//设置设备状态错误
	virtual void OnSetDevStateErr(UserDevState& info) = 0;

	//设置设备状态通知
	virtual void OnSetDevStateNotify(UserDevState& info) = 0;

	//设置用户权限(管理)响应
	virtual void OnSetUserPriorityResp(SetUserPriorityResp& info) = 0;

	//设置用户权限(管理)通知
	virtual void OnSetUserPriorityNotify(UserPriority& info) = 0;

	//查看用户IP响应
	virtual void OnSeeUserIpResp(SeeUserIpResp& info) = 0;

	//查看用户IP错误
	virtual void OnSeeUserIpErr(SeeUserIpResp& info) = 0;

	//封杀房间用户响应
	virtual void OnThrowUserResp(ThrowUserInfoResp& info) = 0;

	//禁言通知
	virtual void OnForbidUserChatNotify(ForbidUserChat& info) = 0;

	//收藏房间响应
	virtual void OnFavoriteVcbResp(FavoriteRoomResp& info) = 0;

	//设置房间公告响应
	virtual void OnSetRoomNoticeResp(SetRoomNoticeResp& info) = 0;

	//设置房间状态信息响应
	virtual void OnSetRoomOPStatusResp(SetRoomOPStatusResp& info) = 0;

	//查询用户帐户响应
	virtual void OnQueryUserAccountResp(QueryUserAccountResp& info) = 0;

	//收到服务器ping消息的返回,表示房间活着
	virtual void OnClientPingResp(ClientPingResp& info) = 0;

	//房间被关闭消息,直接退出当前房间
	virtual void OnCloseRoomNotify(CloseRoomNoty& info) = 0;
	
	//收到房间不可到达消息
	virtual void OnDoNotReachRoomServer() = 0;

	//设置房间信息飞叉版响应
	virtual void OnSetRoomInfoResp(SetRoomInfoResp& info) = 0;

	//设置房间信息飞叉版通知
	virtual void OnSetRoomInfoReq_v2(SetRoomInfoReq_v2& info) = 0;

	//收到禁言关键词刷新通知
	virtual void OnAdKeyWordOperateNoty(std::vector<AdKeywordInfo>& info) = 0;

	//收到禁言关键词更新通知
	virtual void OnAdKeyWordOperateResp(AdKeywordsResp& info) = 0;

	//收到讲师评分响应
	virtual void OnTeacherScoreResp(TeacherScoreResp& info) = 0;

	//收到用户评分响应
	virtual void OnTeacherScoreRecordResp(TeacherScoreRecordResp& info) = 0;

	//上麦机器人对应讲师ID通知
	virtual void OnRobotTeacherIdNoty(RobotTeacherIdNoty& info) = 0;

	//讲师忠实度周版响应
	virtual void OnTeacherGiftListResp(std::vector<TeacherGiftListResp>& infos) = 0;

	//用户对讲师的评分
	virtual void OnUserScoreNotify(UserScoreNoty& info) = 0;

	//用户对讲师的评分列表
	virtual void OnUserScoreListNotify(std::vector<UserScoreNoty>& infos) = 0;

	//用户对讲师的平均分
	virtual void OnTeacherAvarageScoreNoty(TeacherAvarageScoreNoty& info) = 0;

	//主房间和子房间id，目前只有移动端有，PC端没有
	virtual void OnRoomAndSubRoomId_Noty(RoomAndSubRoomIdNoty& info) = 0;

	//房间发送系统公告
	virtual void OnSysCastResp(Syscast& info) = 0;

	//普通用户个人资料
	virtual void OnRoomUserInfoResp(RoomUserInfoResp& info) = 0;

	//文字讲师个人资料
	virtual void OnTeacherInfoResp(TeacherInfoResp& info) = 0;

	//获取用户个人资料失败
	virtual void OnUserInfoErr(UserInfoErr& info) = 0;

	//课程订阅返回
	virtual void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info) = 0;

	//查询订阅状态响应
	virtual void OnTeacherSubscriptionStateQueryResp(TeacherSubscriptionStateQueryResp& info) = 0;

	//专家观点消息推送（房间内部广播）
	virtual void OnExpertNewViewNoty(ExpertNewViewNoty& info) = 0;

	//最强战队周榜回应
	virtual void OnTeamTopNResp(std::vector<TeamTopNResp>& infos) = 0;

	//观点赠送礼物通知
	virtual void OnViewpointTradeGiftNoty(ViewpointTradeGiftNoty& info) = 0;

};


#endif
