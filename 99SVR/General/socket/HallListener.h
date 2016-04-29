
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

	virtual void OnSystemInfoResp(std::vector<HallSystemInfoListResp>& infos) = 0;

	virtual void OnInterestForResp(InterestForResp& info) = 0;

	virtual void OnBuyPrivateVipResp(BuyPrivateVipResp& info) = 0;

	virtual void OnBuyPrivateVipErr(ErrCodeResp& info) = 0;
};

#endif
