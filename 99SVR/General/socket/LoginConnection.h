#ifndef __LOGIN_CONNECTION_H__
#define __LOGIN_CONNECTION_H__

#include <vector>
#include "Connection.h"
#include "LoginListener.h"
#include "HallListener.h"
#include "PushListener.h"
#include "LoginMessage.pb.h"

extern UserLogonSuccess2 loginuser;
extern UserLogonReq4 login_req4;
extern UserLogonReq5 login_req5;

extern uint32 login_reqv;
extern uint32 login_nmobile;
extern uint32 login_version;
extern uint32 login_userid;
extern string login_password;
extern SessionTokenResp login_token;

extern JoinRoomReq join_req;
extern JoinRoomResp room_info;

extern uint32 main_room_id;

class LoginConnection : public Connection
{

private:

	LoginListener* login_listener;
	HallListener* hall_listener;
	PushListener* push_listener;


	void dispatch_push_message(void* body);
	void dispatch_error_message(void* body);

	void rejoin_room();


protected:

	void on_do_connected();
	void on_dispatch_message(void* msg);


public:

	void RegisterLoginListener(LoginListener* message_listener);
	void RegisterHallListener(HallListener* message_listener);
	void RegisterPushListener(PushListener* message_listener);

	void DispatchSocketMessage(void* msg);

	//ping����
	void SendMsg_Ping();

	//��¼�汾������
	void SendMsg_LoginReq4(UserLogonReq4& req);

	//��¼�汾������
	void SendMsg_LoginReq5(UserLogonReq5& req);

	//token����
	void SendMsg_SessionTokenReq(uint32 userid);

	//�����û���������
	void SendMsg_SetUserInfoReq(SetUserProfileReq& req);

	//�����û���������
	void SendMsg_SetUserPwdReq(uint32 vcbid, uint32 pwdtype, const char* oldpwd, const char* newpwd);

	//��ȡ�������ص�ַ
	void SendMsg_QueryRoomGateAddrReq(uint32 userid, uint32 roomid, uint32 flags);

	//�������б�����
	void SendMsg_GetRoomGroupListReq();

	//��ȡ�û�������Ϣ�����ֻ�������ǩ���ȣ�
	void SendMsg_GetUserMoreInfReq(uint32 userid);

	//�û��˳����������
	void SendMsg_ExitAlertReq();

	//����δ����¼����������
	void SendMsg_MessageUnreadReq();

	//�鿴�������󣨲�ͬ����������ͬһ����Ϣ���ͼ��ṹ��
	void SendMsg_HallMessageReq(HallMessageReq& req);
	//�鿴�������������
	void SendMsg_HallMessageReq2(TextRoomList_mobile& head,HallMessageReq& req);

	//��ʦ�ظ��������۵�ظ��ͻش����ʣ�����
	void SendMsg_ViewAnswerReq(ViewAnswerReq& req);

	//��ע���޹�ע��ʦʱ�������н�ʦ�б������ע������
	void SendMsg_InterestForReq(InterestForReq& req);

	//��ȡ��ʦ�ķ�˿��������
	void SendMsg_FansCountReq(uint32 teacherid);

	//˽�˶��ƹ�����Ӧ
	void SendMsg_BuyPrivateVipReq(uint32 teacherid,uint32 viptype);
	
	//�۵�������������
	void SendMsg_ViewpointTradeGiftReq(ViewpointTradeGiftReq& req);

	//��ȡ�����ת��������ID����
	void SendMsg_OnMicRobertReq(OnMicRobertReq& req);

	void close();

	LoginConnection();

	~LoginConnection(void);

};

#endif
