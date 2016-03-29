#include <vector>
#include "Connection.h"
#include "LoginListener.h"
#include "HallListener.h"
#include "PushListener.h"
#include "LoginMessage.pb.h"

class LoginConnection : public Connection
{

private:

	LoginListener* login_listener;
	HallListener* hall_listener;
	PushListener* push_listener;

	UserLogonSuccess2 logonuser;
	UserLogonReq4 req4;
	UserLogonReq5  req5;
	uint32 reqv;
	uint32 nmobile;
	uint32 version;


	void dispatch_push_message(void* body);


protected:

	void on_do_connected();
	void on_dispatch_message(void* msg);


public:

	void RegisterMessageListener(LoginListener* message_listener);
	void RegisterHallListener(HallListener* message_listener);
	void RegisterPushListener(PushListener* message_listener);

	void DispatchSocketMessage(void* msg);

	void SendMsg_Ping();

	void SendMsg_LoginReq4(UserLogonReq4& req);

	void SendMsg_LoginReq5(UserLogonReq5& req);

	void SendMsg_SessionTokenReq(uint32 userid);

	void SendMsg_SetUserInfoReq(SetUserProfileReq& req);

	void SendMsg_SetUserPwdReq(uint32 vcbid, uint32 pwdtype, const char* oldpwd, const char* newpwd);

	void SendMsg_QueryRoomGateAddrReq(uint32 userid, uint32 roomid, uint32 flags);

	void SendMsg_GetRoomGroupListReq();

	void SendMsg_GetUserMoreInfReq(uint32 userid);

	void SendMsg_ExitAlertReq();

	//--------------------------------------//
	/*
	void SendMsg_MessageUnreadReq();

	void SendMsg_HallMessageReq(HallMessageReq& req);

	void SendMsg_ViewAnswerReq(ViewAnswerReq& req);

	void SendMsg_InterestForReq(InterestForReq& req);

	void SendMsg_FansCountReq(uint32 teacherid);
	*/
	//-------------------------------------//

	void close();

	LoginConnection();

	~LoginConnection(void);

};
