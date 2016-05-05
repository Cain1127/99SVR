
#ifndef __HALL_LISTENER_H__
#define __HALL_LISTENER_H__

#include <vector>
#include "LoginMessage.pb.h"
#include "VideoRoomMessage.pb.h"

class HallListener
{

public:

	//设置用户资料
	virtual void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req) = 0;

	//设置用户密码
	virtual void OnSetUserPwdResp(SetUserPwdResp& info) = 0;

	//获取房间网关地址
	virtual void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info) = 0;

	//获取用户更多信息（手机，个性签名等）
	virtual void OnGetUserMoreInfResp(GetUserMoreInfResp& info) = 0;

	//用户退出软件
	virtual void OnUserExitMessageResp(ExitAlertResp& info) = 0;

	//信箱小红点提醒
	virtual void OnHallMessageNotify(MessageNoty& info) = 0;

	//信箱未读记录数
	virtual void OnMessageUnreadResp(MessageUnreadResp& info) = 0;

	//查看互动回复
	virtual void OnInteractResp(std::vector<InteractResp>& infos) = 0;

	//查看问答提醒
	virtual void OnHallAnswerResp(std::vector<AnswerResp>& infos) = 0;

	//查看观点回复
	//virtual void OnViewShowResp(std::vector<ViewShowResp>& infos) = 0;

	//查看我的粉丝
	//virtual void OnTeacherFansResp(std::vector<TeacherFansResp>& infos) = 0;

	//查看我的关注（已关注讲师）
	//virtual void OnInterestResp(std::vector<InterestResp>& infos) = 0;

	//查看我的关注（无关注讲师）
	//virtual void OnUnInterestResp(std::vector<UnInterestResp>& infos) = 0;

	//查看明日预测（已关注的讲师）
	//virtual void OnTextLivePointListResp(std::vector<TextLivePointListResp>& infos) = 0;

	//查看已购买的个人秘籍
	//virtual void OnSecretsListResp(std::vector<HallSecretsListResp>& infos) = 0;

	//查看系统消息
	virtual void OnSystemInfoResp(std::vector<HallSystemInfoListResp>& infos) = 0;

	//讲师回复（包含观点回复和回答提问）
	//virtual void OnViewAnswerResp(ViewAnswerResp& info) = 0;

	//关注（无关注讲师时返回所有讲师列表，点击关注）
	virtual void OnInterestForResp(InterestForResp& info) = 0;

	//获取讲师的粉丝总数响应
	//virtual void OnFansCountResp(FansCountResp& info) = 0;

	//私人订制购买响应
	virtual void OnBuyPrivateVipResp(BuyPrivateVipResp& info) = 0;

	//私人订制购买失败
	virtual void OnBuyPrivateVipErr(ErrCodeResp& info) = 0;

	//观点赠送礼物响应
	virtual void OnViewpointTradeGiftResp(ViewpointTradeGiftNoty& info) = 0;

	//观点赠送礼物失败
	virtual void OnViewpointTradeGiftErr(ErrCodeResp& info) = 0;
	
};

#endif
