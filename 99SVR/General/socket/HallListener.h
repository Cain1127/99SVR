
#ifndef __HALL_LISTENER_H__
#define __HALL_LISTENER_H__

#include <vector>
#include "LoginMessage.pb.h"
#include "VideoRoomMessage.pb.h"

class HallListener
{

public:

	virtual void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req) = 0;
	virtual void OnSetUserPwdResp(SetUserPwdResp& info) = 0;
	virtual void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info) = 0;
	virtual void OnGetUserMoreInfResp(GetUserMoreInfResp& info) = 0;
	virtual void OnUserExitMessageResp(ExitAlertResp& info) = 0;
	virtual void OnHallMessageNotify(MessageNoty& info) = 0;
	virtual void OnMessageUnreadResp(MessageUnreadResp& info) = 0;
	virtual void OnInteractResp(std::vector<InteractResp>& infos) = 0;
	virtual void OnHallAnswerResp(std::vector<AnswerResp>& infos) = 0;
	virtual void OnSystemInfoResp(std::vector<HallSystemInfoListResp>& infos) = 0;
	virtual void OnInterestForResp(InterestForResp& info) = 0;
	virtual void OnBuyPrivateVipResp(BuyPrivateVipResp& info) = 0;
	
};

#endif
