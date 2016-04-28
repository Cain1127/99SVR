
#ifndef Login_Listener_H
#define Login_Listener_H

#include <vector>
#include "LoginMessage.pb.h"

class LoginListener
{

public:


	//��½�ɹ�
	virtual void OnLogonSuccess(UserLogonSuccess2& info) = 0;

	//��½ʧ��
	virtual void OnLogonErr(UserLogonErr2& info) = 0;

	//�������б�
	virtual void OnRoomGroupList(RoomGroupItem items[], int count) = 0;

	//Ȩ��id����
	virtual void OnQuanxianId2List(QuanxianId2Item items[], int count) = 0;

	//Ȩ�޲������ݿ�ʼ
	virtual void OnQuanxianAction2List(QuanxianAction2Item items[], int count) = 0;

	//token֪ͨ
	virtual void OnLogonTokenNotify(SessionTokenResp& info) = 0;

	//��¼���
	virtual void OnLogonFinished() = 0;

};

#endif
