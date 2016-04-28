
#ifndef Login_Listener_H
#define Login_Listener_H

#include <vector>
#include "LoginMessage.pb.h"

class LoginListener
{

public:


	//登陆成功
	virtual void OnLogonSuccess(UserLogonSuccess2& info) = 0;

	//登陆失败
	virtual void OnLogonErr(UserLogonErr2& info) = 0;

	//房间组列表
	virtual void OnRoomGroupList(RoomGroupItem items[], int count) = 0;

	//权限id数据
	virtual void OnQuanxianId2List(QuanxianId2Item items[], int count) = 0;

	//权限操作数据开始
	virtual void OnQuanxianAction2List(QuanxianAction2Item items[], int count) = 0;

	//token通知
	virtual void OnLogonTokenNotify(SessionTokenResp& info) = 0;

	//登录完成
	virtual void OnLogonFinished() = 0;

};

#endif
