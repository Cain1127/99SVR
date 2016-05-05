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

	//ping请求
	void SendMsg_Ping();

	//登录版本四请求
	void SendMsg_LoginReq4(UserLogonReq4& req);

	//登录版本五请求
	void SendMsg_LoginReq5(UserLogonReq5& req);

	//token请求
	void SendMsg_SessionTokenReq(uint32 userid);

	//设置用户资料请求
	void SendMsg_SetUserInfoReq(SetUserProfileReq& req);

	//设置用户密码请求
	void SendMsg_SetUserPwdReq(uint32 vcbid, uint32 pwdtype, const char* oldpwd, const char* newpwd);

	//获取房间网关地址
	void SendMsg_QueryRoomGateAddrReq(uint32 userid, uint32 roomid, uint32 flags);

	//房间组列表请求
	void SendMsg_GetRoomGroupListReq();

	//获取用户更多信息请求（手机，个性签名等）
	void SendMsg_GetUserMoreInfReq(uint32 userid);

	//用户退出软件的请求
	void SendMsg_ExitAlertReq();

	//信箱未读记录数提醒请求
	void SendMsg_MessageUnreadReq();

	//查看邮箱请求（不同分类请求用同一个消息类型及结构）
	void SendMsg_HallMessageReq(HallMessageReq& req);
	//查看邮箱请求（组包）
	void SendMsg_HallMessageReq2(TextRoomList_mobile& head,HallMessageReq& req);

	//讲师回复（包含观点回复和回答提问）请求
	void SendMsg_ViewAnswerReq(ViewAnswerReq& req);

	//关注（无关注讲师时返回所有讲师列表，点击关注）请求
	void SendMsg_InterestForReq(InterestForReq& req);

	//获取讲师的粉丝总数请求
	void SendMsg_FansCountReq(uint32 teacherid);

	//私人订制购买响应
	void SendMsg_BuyPrivateVipReq(uint32 teacherid,uint32 viptype);
	
	//观点赠送礼物请求
	void SendMsg_ViewpointTradeGiftReq(ViewpointTradeGiftReq& req);

	//获取房间的转播机器人ID请求
	void SendMsg_OnMicRobertReq(OnMicRobertReq& req);

	void close();

	LoginConnection();

	~LoginConnection(void);

};

#endif
