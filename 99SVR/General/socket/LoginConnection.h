#include "Connection.h"
#include "LoginListener.h"
#include "LoginMessage.pb.h"

class LoginConnection : public Connection
{

private:

	LoginListener* listener;

	UserLogonSuccess2 logonuser;


protected:

	void on_dispatch_message(void* msg);


public:

	void RegisterMessageListener(LoginListener* message_listener);

	void DispatchSocketMessage(void* msg);

	void SendMsg_LoginReq4(UserLogonReq4& req);

	void SendMsg_LoginReq5(UserLogonReq5& req);

	void SendMsg_SessionTokenReq(uint32 userid);

	void SendMsg_SetUserInfoReq(SetUserProfileReq& req);

	void SendMsg_SetUserPwdReq(uint32 vcbid, uint32 pwdtype, const char* oldpwd, const char* newpwd);

	void SendMsg_QueryRoomGateAddrReq(uint32 userid, uint32 roomid, uint32 flags);

	void SendMsg_GetRoomGroupListReq();

	LoginConnection();

	virtual ~LoginConnection(void);
};
