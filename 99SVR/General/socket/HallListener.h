
#ifndef Hall_Listener_H
#define Hall_Listener_H

#include <vector>
#include "LoginMessage.pb.h"

class HallListener
{

public:

	virtual void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req) = 0;
	virtual void OnSetUserPwdResp(SetUserPwdResp& info) = 0;
	virtual void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info) = 0;
	virtual void OnGetUserMoreInfResp(GetUserMoreInfResp& info) = 0;
	virtual void OnUserExitMessageResp(ExitAlertResp& info) = 0;

	/*
	virtual void OnHallMessageNotify(MessageNoty& info) = 0;
	virtual void OnMessageUnreadResp(MessageUnreadResp& info) = 0;

	//7¸öÁÐ±í
	virtual void OnInteractResp(std::vector<InteractResp>& infos) = 0;
	virtual void OnHallAnswerResp(std::vector<AnswerResp>& infos) = 0;
	virtual void OnViewShowResp(std::vector<ViewShowResp>& infos) = 0;
	virtual void OnTeacherFansResp(std::vector<TeacherFansResp>& infos) = 0;
	virtual void OnInterestResp(std::vector<InterestResp>& infos) = 0;
	virtual void OnUnInterestResp(std::vector<UnInterestResp>& infos) = 0;
	virtual void OnTextLivePointListResp(std::vector<TextLivePointListResp>& infos) = 0;
	/////////

	virtual void OnSecretsListResp(HallSecretsListResp& infos) = 0;
	virtual void OnSystemInfoResp(HallSystemInfoListResp& infos) = 0;

	virtual void OnViewAnswerResp(ViewAnswerResp& info) = 0;
	virtual void OnInterestForResp(InterestForResp& info) = 0;
	virtual void OnFansCountResp(FansCountResp& info) = 0;
	*/
};

#endif
