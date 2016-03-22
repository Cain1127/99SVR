#include "StdAfx.h"
#include "LoginConnection.h"
#include "Thread.h"


LoginConnection::LoginConnection() : listener(NULL)
{
	main_cmd = MDM_Vchat_Login;
}

void LoginConnection::RegisterMessageListener(LoginListener* message_listener)
{
	listener = message_listener;
}

void LoginConnection::SendMsg_LoginReq4(UserLogonReq4& req)
{
	connect("120.197.248.11", 7401);

	SendMsg_Hello();
	SEND_MESSAGE(Sub_Vchat_logonReq4, req);

	start_read_thread();
}

void LoginConnection::SendMsg_LoginReq5(UserLogonReq5& req)
{
	connect("112.25.230.248", 7401);

	SendMsg_Hello();
	SEND_MESSAGE(Sub_Vchat_logonReq5, req);

	start_read_thread();
}

void LoginConnection::SendMsg_SessionTokenReq(uint32 userid)
{
	SessionTokenReq req;
	req.set_userid(userid);

	SEND_MESSAGE(Sub_Vchat_logonTokenReq, req);
}

void LoginConnection::SendMsg_SetUserInfoReq(SetUserProfileReq& req)
{
	SEND_MESSAGE(Sub_Vchat_SetUserProfileReq, req);
}

void LoginConnection::SendMsg_SetUserPwdReq(uint32 vcbid, uint32 pwdtype, const char* oldpwd, const char* newpwd)
{
	SetUserPwdReq req;
	req.set_userid(logonuser.userid());
	req.set_vcbid(vcbid);
	req.set_pwdtype(pwdtype);
	req.set_oldpwd(oldpwd);
	req.set_newpwd(newpwd);

	SEND_MESSAGE(Sub_Vchat_SetUserPwdReq, req);
}

void LoginConnection::SendMsg_QueryRoomGateAddrReq(uint32 userid, uint32 roomid, uint32 flags)
{
	QueryRoomGateAddrReq req;
	req.set_userid(userid);
	req.set_roomid(roomid);
	req.set_flags(flags);

	SEND_MESSAGE(Sub_Vchat_QueryRoomGateAddrReq, req);
}

void LoginConnection::SendMsg_GetRoomGroupListReq()
{
	RoomGroupListReq req;
	req.set_userid(logonuser.userid());

	SEND_MESSAGE(Sub_Vchat_RoomGroupListReq, req);
}

void LoginConnection::on_dispatch_message(void* msg)
{
	if ( listener != NULL )
	{
		listener->OnMessageComming(msg);
	}
}

void LoginConnection::DispatchSocketMessage(void* msg)
{

	static RoomGroupItem* room_groups;
	static QuanxianId2Item* qx_ids;
	static QuanxianAction2Item* qx_actions;

	static int room_groups_count = 0;
	static int qx_ids_count = 0;
	static int qx_actions_count = 0;


	COM_MSG_HEADER*head = (COM_MSG_HEADER*)msg;
	uint8* body = (uint8*)(head->content);

	int sub_cmd = head->subcmd;
	int body_len = head->length - sizeof(COM_MSG_HEADER);
	
	switch ( sub_cmd ) {

		case Sub_Vchat_logonErr2:
//			ON_MESSAGE(UserLogonErr2, OnLogonErr);
        {
            UserLogonErr2 info;
            info.ParseFromArray(body, info.ByteSize());
            listener->OnLogonErr(info);
        }
			break;

		case Sub_Vchat_logonSuccess2:
			logonuser.ParseFromArray(body, logonuser.ByteSize());
			listener->OnLogonSuccess(logonuser);
			break;

		case Sub_Vchat_RoomGroupListBegin:
			room_groups_count = 0;
			room_groups = new RoomGroupItem[20];
			break;

		case Sub_Vchat_RoomGroupListResp:
			body += sizeof(uint32);
			room_groups[room_groups_count].ParseFromArray(body, room_groups[room_groups_count].ByteSize());
			room_groups_count++;
			break;
	
		case Sub_Vchat_RoomGroupListFinished:
			listener->OnRoomGroupList(room_groups, room_groups_count);
			delete[] room_groups;
			break;
	
		case Sub_Vchat_QuanxianId2ListResp:
			qx_ids_count = body_len / sizeof(CMDQuanxianId2Item_t);
			qx_ids = new QuanxianId2Item[qx_ids_count];
			for (int i = 0; i < qx_ids_count; i++)
			{
				qx_ids[i].ParseFromArray(body, qx_ids[i].ByteSize());
				body += qx_ids[i].ByteSize();
			}
			listener->OnQuanxianId2List(qx_ids, qx_ids_count);
			delete[] qx_ids;
			break;

		case Sub_Vchat_QuanxianAction2ListBegin:
			qx_actions_count = 0;
			qx_actions = new QuanxianAction2Item[4000];
			break;
	
		case Sub_Vchat_QuanxianAction2ListResp:
			int action_num;
			action_num = body_len / sizeof(CMDQuanxianAction2Item_t);
			LOG("action:%d:%d:%d", body_len, sizeof(CMDQuanxianAction2Item_t), action_num);
		
			for (int i = 0; i < action_num; i++)
			{
				qx_actions[qx_actions_count].ParseFromArray(body, qx_actions[qx_actions_count].ByteSize());
				body += qx_actions[qx_actions_count].ByteSize();
				qx_actions_count++;
			}
			break;

		case Sub_Vchat_QuanxianAction2ListFinished:
			listener->OnQuanxianAction2List(qx_actions, qx_actions_count);
			delete[] qx_actions;
			break;

		case Sub_Vchat_logonTokenNotify:
			ON_MESSAGE(SessionTokenResp, OnLogonTokenNotify);
			break;

		case Sub_Vchat_logonFinished:
			listener->OnLogonFinished();
			break;

		case Sub_Vchat_SetUserProfileResp:
			ON_MESSAGE(SetUserProfileResp, OnSetUserProfileResp);
			break;

		case Sub_Vchat_SetUserPwdResp:
			ON_MESSAGE(SetUserPwdResp, OnSetUserPwdResp);
			break;

		case Sub_Vchat_QueryRoomGateAddrResp:
			ON_MESSAGE(QueryRoomGateAddrResp, OnQueryRoomGateAddrResp);
			break;

		default:
			LOG("+++++++unimplenment message+++++++:%d", sub_cmd );
			break;

		}

		delete[] msg;

}



LoginConnection::~LoginConnection(void)
{
}

