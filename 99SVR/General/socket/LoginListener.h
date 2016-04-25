
#ifndef Login_Listener_H
#define Login_Listener_H

#include <vector>
#include "LoginMessage.pb.h"

class LoginListener
{

public:

	virtual void OnMessageComming(void* msg) = 0;

	virtual void OnLogonSuccess(UserLogonSuccess2& info) = 0;
	virtual void OnLogonErr(UserLogonErr2& info) = 0;
	virtual void OnRoomGroupList(RoomGroupItem items[], int count) = 0;
	virtual void OnQuanxianId2List(QuanxianId2Item items[], int count) = 0;
	virtual void OnQuanxianAction2List(QuanxianAction2Item items[], int count) = 0;
	virtual void OnLogonTokenNotify(SessionTokenResp& info) = 0;
	virtual void OnLogonFinished() = 0;

};

#endif
