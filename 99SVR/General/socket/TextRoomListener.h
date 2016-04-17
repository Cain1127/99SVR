#ifndef __TEXTROOM_LISTENER_H__
#define __TEXTROOM_LISTENER_H__

#include <vector>
#include "TextRoomMessage.pb.h"
#include "CommonMessage.pb.h"

class TextListener
{
public:	
	virtual void OnMessageComming(void* msg) = 0;

	//收到服务器ping消息的返回,表示房间活着
	virtual void OnClientPingResp(ClientPingResp& info) = 0;

	//加入房间失败
	virtual void OnJoinRoomErr(JoinRoomErr& info) = 0;

	//加入房间成功
	virtual void OnJoinRoomResp(JoinRoomResp& info) = 0;

	//用户加入房间通知
	virtual void OnRoomUserNoty(RoomUserInfo& info) = 0;

	//房间用户列表
	virtual void OnRoomUserList(std::vector<RoomUserInfo>& infos) = 0;

	//收到禁言关键词刷新通知
	virtual void OnAdKeyWordOperateNoty(AdKeywordsNotify& info) = 0;

	//收到禁言关键词更新通知
	virtual void OnAdKeyWordOperateResp(AdKeywordsResp& info) = 0;

	//设置房间信息响应
	virtual void OnSetRoomInfoResp(SetRoomInfoResp& info) = 0;

	//房间信息数据通知
	virtual void OnRoomInfoNotify(RoomBaseInfo& info) = 0;

	//房间状态数据通知
	virtual void OnRoomOpState(RoomOpState& info) = 0;

	//禁言通知
	virtual void OnForbidUserChatNotify(ForbidUserChat& info) = 0;

	//封杀房间用户响应
	virtual void OnThrowUserResp(ThrowUserInfoResp& info) = 0;

	//房间封杀用户通知
	virtual void OnThrowUserNotify(ThrowUserInfo& info) = 0;

	//设置用户权限(管理)响应
	virtual void OnSetUserPriorityResp(SetUserPriorityResp& info) = 0;

	//设置用户权限(管理)响应
	virtual void OnSetUserPriorityNotify(SetUserPriorityResp& info) = 0;

	//察看用户IP响应
	virtual void OnSeeUserIpResp(SeeUserIpResp& info) = 0;

	//察看用户IP错误
	virtual void OnSeeUserIpErr(SeeUserIpResp& info) = 0;

	//赠送礼物返回响应消息
	virtual void OnTradeGiftRecordResp(TradeGiftRecord& info) = 0;

	//赠送礼物返回错误消息
	virtual void OnTradeGiftErr(TradeGiftErr& info) = 0;

	//赠送礼物通知数据
	virtual void OnTradeGiftNotify(TradeGiftRecord& info) = 0;

	//房间用户踢出通知
	virtual void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info) = 0;

	//房间用户退出通知
	virtual void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info) = 0;

	//讲师加入房间通知
	virtual void OnTeacherComeNotify(TeacherComeNotify& info) = 0;

	//讲师信息
	virtual void OnTextRoomTeacherNoty(TextRoomTeacherNoty& info) = 0;

	//加载直播记录列表
	virtual void OnTextRoomLiveListNoty(std::vector<TextRoomLiveListNoty>& infos) = 0;

	//加载直播重点记录列表
	virtual void OnTextRoomLivePointNoty(std::vector<TextRoomLivePointNoty>& infos) = 0;

	//加载明日预测记录列表
	virtual void OnTextRoomLiveForecastNoty(std::vector<TextRoomLivePointNoty>& infos) = 0;

	//直播历史列表(概况)列表
	virtual void OnTextLiveHistoryListResp(std::vector<TextLiveHistoryListResp>& infos) = 0;

	//加载历史直播记录列表
	virtual void OnTextLiveHistoryDaylyResp(std::vector<TextRoomLiveListNoty>& infos) = 0;

	//观点类型分类列表
	virtual void OnTextRoomViewGroupResp(std::vector<TextRoomViewGroupResp>& infos) = 0;

	//观点列表
	virtual void OnTextRoomLiveViewResp(std::vector<TextRoomLiveViewResp>& infos) = 0;

	//评论列表
	virtual void OnTextRoomViewInfoResp(std::vector<TextRoomViewInfoResp>& infos) = 0;

	//观点详情
	virtual void OnTextRoomLiveViewDetailResp(TextRoomLiveViewResp& info) = 0;

	//拜师信息(普通用户)头
	virtual void OnNormalUserGetBeTeacherInfoRespHead(NormalUserGetBeTeacherInfoRespHead& info) = 0;

	//拜师信息(普通用户)列表
	virtual void OnNormalUserGetBeTeacherInfoRespItem(std::vector<NormalUserGetBeTeacherInfoRespItem>& infos) = 0;

	//拜师信息(讲师)头
	virtual void OnTeacherGetBeTeacherInfoRespHead(TeacherGetBeTeacherInfoRespHead& info) = 0;

	//拜师信息(讲师)列表
	virtual void OnTeacherGetBeTeacherInfoRespItem(std::vector<TeacherGetBeTeacherInfoRespItem>& infos) = 0;

	//特权信息列表
	virtual void OnGetPackagePrivilegeResp(std::vector<GetPackagePrivilegeResp>& infos) = 0;

	//专属表情列表
	virtual void OnTextRoomEmoticonListResp(std::vector<TextRoomEmoticonListResp>& infos) = 0;

	//加载个人秘籍记录列表
	virtual void OnTextRoomSecretsListResp(std::vector<TextRoomSecretsListResp>& infos) = 0;

	//加载个人秘籍已购买记录列表
	virtual void OnTextRoomSecBuyListResp(std::vector<TextRoomSecretsListResp>& infos) = 0;

	//加载个人秘籍总体信息响应
	virtual void OnTextRoomSecretsTotalResp(TextRoomSecretsTotalResp& info) = 0;

	//个人秘籍单次订阅响应
	virtual void OnTextRoomBuySecretsResp(TextRoomBuySecretsResp& info) = 0;

	//讲师发表个人秘籍通知
	virtual void OnTextRoomSecretsPHPResp(TextRoomSecretsPHPResp& info) = 0;

	//讲师发送文字直播响应
	virtual void OnTextRoomLiveMessageResp(TextRoomLiveMessageResp& info) = 0;

	//用户对直播内容点赞响应
	virtual void OnTextRoomZanForResp(TextRoomZanForResp& info) = 0;

	//发送聊天响应
	virtual void OnTextRoomLiveChatResp(TextRoomLiveChatResp& info) = 0;

	//聊天回复响应
	virtual void OnTextLiveChatReplyResp(TextLiveChatReplyResp& info) = 0;

	//讲师修改和新增观点类型分类响应
	virtual void OnTextRoomViewTypeResp(TextRoomViewTypeResp& info) = 0;

	//讲师发表观点响应
	virtual void OnTextRoomViewMessageReqResp(TextRoomViewMessageReqResp& info) = 0;

	//讲师发表观点响应PHP
	virtual void OnTextRoomViewPHPResp(TextRoomViewPHPResp& info) = 0;

	//观点评论响应
	virtual void OnTextRoomLiveActionResp(TextRoomLiveActionResp& info) = 0;

	//观点点赞响应
	virtual void OnTextLiveViewZanForResp(TextRoomZanForResp& info) = 0;

	//观点点赞响应
	virtual void OnTextLiveViewFlowerResp(TextLiveViewFlowerResp& info) = 0;

	//观点删除响应
	virtual void OnTextRoomViewDeleteResp(TextRoomViewDeleteResp& info) = 0;

	//用户提问响应
	virtual void OnTextRoomQuestionResp(TextRoomQuestionResp& info) = 0;

	//用户点击关注响应
	virtual void OnTextRoomInterestForResp(TextRoomInterestForResp& info) = 0;

	//商品状态
	virtual void OnTextRoomGetUserGoodStatusResp(TextRoomGetUserGoodStatusResp& info) = 0;

	//用户付费
	virtual void OnUserPayResp(UserPayResp& info) = 0;

	//查寻账户余额
	virtual void OnGetUserAccountBalanceResp(GetUserAccountBalanceResp& info) = 0;

	//普通用户个人资料
	virtual void OnRoomUserInfoResp(RoomUserInfoResp& info) = 0;

	//文字讲师个人资料
	virtual void OnTeacherInfoResp(TeacherInfoResp& info) = 0;

	//获取用户个人资料失败
	virtual void OnUserInfoErr(UserInfoErr& info) = 0;

	//拜师请求返回
	virtual void OnBeTeacherResp(BeTeacherResp& info) = 0;

	//请求拜师信息失败
	virtual void OnGetBeTeacherInfoReqFailed() = 0;

	//视频房间上麦通知
	virtual void OnVideoRoomOnMicClientResp(VideoRoomOnMicClientResp& info) = 0;

	//课程订阅返回
	virtual void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info) = 0;

};


#endif
