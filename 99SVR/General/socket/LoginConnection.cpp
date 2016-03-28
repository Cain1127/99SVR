#include "platform.h"

#include "LoginConnection.h"
#include "Thread.h"
#include "proto_cmd_vchat.h"

/*
char lbss[3][10][20];
int lbs_counter[3];
bool islogining = false;

void parse_ip_port(char* s, char* ip, short& port)
{
	char* e = strchr(s, ':');
	int len = e - s;
	memcpy(ip, s, len);
	ip[len] = 0;

	port = atoi(e + 1);
}

void testlbs()
{
	//http://hall.99ducaijing.cn:8081/roomdata/room.php?act=roomdata
	char recvbuf[HTTP_RECV_BUF_SIZE];
	Http http;

	memset(lbss, 0, sizeof(lbss));
	memset(lbs_counter, 0, sizeof(lbs_counter));

	int ret = http.GetString("lbs1.99ducaijing.cn", 2222, "/tygetweb", recvbuf);
	//int ret = http.GetString("lbs1.99ducaijing.cn", 2222, "/tygetgate", recvbuf);
	//int ret = http.GetString("hall.99ducaijing.cn", 8081, "/roomdata/room.php?act=roomdata", recvbuf);
	char* content = strstr(recvbuf, "\r\n\r\n");
	if (content != NULL)
	{
		LOG("%s", recvbuf);
		content += 4;
		//char s[] = "Golden Global   View,disk * desk";
		char* end = strchr(content, '|');
		if (end != NULL)
		{
			*end = '\0';
		}

		const char *d = ",";
		char *p;
		p = strtok(content, d);
		int stype = -1;
		while (p)
		{
			//printf("%s\n", p);

			if (strlen(p) == 1)
			{
				stype = p[0] - '0';
				LOG("stype:%d", stype);
			}
			else
			{
				if (stype >= 0 && stype <= 2)
				{
					int n = lbs_counter[stype];
					strcpy(lbss[stype][n], p);
					LOG("lbs:%d:%s", n, lbss[stype][n]);

					char ip[20];
					short port;
					parse_ip_port(lbss[stype][n], ip, port);
					LOG("ip:%s port:%d", ip, port);

					if (islogining == false)
					{
						islogining = true;

					}

					lbs_counter[stype]++;
				}
			}

			p = strtok(NULL, d);
		}
	}

}
*/

LoginConnection::LoginConnection() :
login_listener(NULL), hall_listener(NULL), push_listener(NULL)
{
	main_cmd = MDM_Vchat_Login;
}

void LoginConnection::RegisterMessageListener(LoginListener* message_listener)
{
	login_listener = message_listener;
}

void LoginConnection::RegisterHallListener(HallListener* message_listener)
{
	hall_listener = message_listener;
}

void LoginConnection::RegisterPushListener(PushListener* message_listener)
{
	push_listener = message_listener;
}

void LoginConnection::SendMsg_Ping()
{
	CMDClientPing_t ping;
	ping.userid = logonuser.userid();
	ping.roomid = 0;

	SEND_MESSAGE2(Sub_Vchat_ClientPing, CMDClientPing_t, &ping);
}

void LoginConnection::SendMsg_LoginReq4(UserLogonReq4& req)
{
	//121.12.118.32:7301
	//120.197.248.11:7401  �ƶ�
	// "login1.99ducaijing.cn", 7401
//	connect("121.12.118.32", 7301);
	int ret = connect("121.12.118.32", 7301);
//	int ret = connect("login1.99ducaijing.cn", 7401);
	if (ret != 0)
		return;

	SendMsg_Hello();
	SEND_MESSAGE(Sub_Vchat_logonReq4, req);

	nmobile = req.nmobile();
	version = req.nversion();

	start_read_thread();
}

void LoginConnection::SendMsg_LoginReq5(UserLogonReq5& req)
{
//	int ret = connect("login1.99ducaijing.cn", 7401);
	int ret = connect("121.12.118.32", 7301);
	if (ret != 0)
		return;

	SendMsg_Hello();
	SEND_MESSAGE(Sub_Vchat_logonReq5, req);

	nmobile = req.nmobile();
	version = req.nversion();

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

void LoginConnection::SendMsg_GetUserMoreInfReq(uint32 userid)
{
	GetUserMoreInfReq req;
	req.set_userid(userid);

	SEND_MESSAGE(Sub_Vchat_GetUserMoreInfReq, req);
}

void LoginConnection::SendMsg_ExitAlertReq()
{
	ExitAlertReq req;
	req.set_userid(logonuser.userid());

	SEND_MESSAGE(Sub_Vchat_UserExitMessage_Req, req);
}

/*
void LoginConnection::SendMsg_MessageUnreadReq()
{
	MessageNoty noty;
	noty.set_userid(logonuser.userid());

	SEND_MESSAGE(Sub_Vchat_HallMessageUnreadReq, noty);
}

void LoginConnection::SendMsg_HallMessageReq(HallMessageReq& req)
{
	SEND_MESSAGE(Sub_Vchat_HallMessageReq, req);
}

void LoginConnection::SendMsg_ViewAnswerReq(ViewAnswerReq& req)
{
	SEND_MESSAGE(Sub_Vchat_HallViewAnswerReq, req);
}

void LoginConnection::SendMsg_InterestForReq(InterestForReq& req)
{
	SEND_MESSAGE(Sub_Vchat_HallInterestForReq, req);
}

void LoginConnection::SendMsg_FansCountReq(uint32 teacherid)
{
	FansCountReq req;
	req.set_teacherid(teacherid);

	SEND_MESSAGE(Sub_Vchat_HallGetFansCountReq, req);
}
*/

void LoginConnection::on_dispatch_message(void* msg)
{
	if (login_listener != NULL)
	{
		login_listener->OnMessageComming(msg);
	}
}

void LoginConnection::close(void)
{
	SendMsg_ExitAlertReq();
	Connection::close();
}

void LoginConnection::DispatchSocketMessage(void* msg)
{

	static RoomGroupItem* room_groups;
	static QuanxianId2Item* qx_ids;
	static QuanxianAction2Item* qx_actions;

	static int room_groups_count = 0;
	static int qx_ids_count = 0;
	static int qx_actions_count = 0;

	//�б�vector
	static std::vector<InteractResp> g_vec_InteractResp;
	static std::vector<AnswerResp> g_vec_AnswerResp;
	static std::vector<ViewShowResp> g_vec_ViewShowResp;
	static std::vector<TeacherFansResp> g_vec_TeacherFansResp;
	static std::vector<InterestResp> g_vec_InterestResp;
	static std::vector<UnInterestResp> g_vec_UnInterestResp;
	static std::vector<TextLivePointListResp> g_vec_TextLivePointListResp;

	COM_MSG_HEADER*head = (COM_MSG_HEADER*) msg;
	uint8* body = (uint8*) (head->content);

	int sub_cmd = head->subcmd;
	int body_len = head->length - sizeof(COM_MSG_HEADER);

	switch (sub_cmd)
	{

	case Sub_Vchat_logonErr2:
		ON_MESSAGE(login_listener, UserLogonErr2, OnLogonErr)
		close();
		break;

	case Sub_Vchat_logonSuccess2:
		logonuser.ParseFromArray(body, logonuser.ByteSize());
		login_listener->OnLogonSuccess(logonuser);
		break;

	case Sub_Vchat_RoomGroupListBegin:
		room_groups_count = 0;
		room_groups = new RoomGroupItem[20];
		break;

	case Sub_Vchat_RoomGroupListResp:
		body += sizeof(uint32);
		room_groups[room_groups_count].ParseFromArray(body,
				room_groups[room_groups_count].ByteSize());
		room_groups_count++;
		break;

	case Sub_Vchat_RoomGroupListFinished:
		login_listener->OnRoomGroupList(room_groups, room_groups_count);
		delete[] room_groups;
		break;

	case Sub_VChat_QuanxianId2ListResp:
		qx_ids_count = body_len / sizeof(protocol::CMDQuanxianId2Item_t);
		qx_ids = new QuanxianId2Item[qx_ids_count];
		for (int i = 0; i < qx_ids_count; i++)
		{
			qx_ids[i].ParseFromArray(body, qx_ids[i].ByteSize());
			body += qx_ids[i].ByteSize();
		}
		login_listener->OnQuanxianId2List(qx_ids, qx_ids_count);
		delete[] qx_ids;
		break;

	case Sub_VChat_QuanxianAction2ListBegin:
		qx_actions_count = 0;
		qx_actions = new QuanxianAction2Item[4000];
		break;

	case Sub_VChat_QuanxianAction2ListResp:
		int action_num;
		action_num = body_len / sizeof(protocol::CMDQuanxianAction2Item_t);
		LOG("action:%d:%d:%d", body_len,
				sizeof(protocol::CMDQuanxianAction2Item_t), action_num);

		for (int i = 0; i < action_num; i++)
		{
			qx_actions[qx_actions_count].ParseFromArray(body,
					qx_actions[qx_actions_count].ByteSize());
			body += qx_actions[qx_actions_count].ByteSize();
			qx_actions_count++;
		}
		break;

	case Sub_VChat_QuanxianAction2ListFinished:
		login_listener->OnQuanxianAction2List(qx_actions, qx_actions_count);
		delete[] qx_actions;
		break;

	case Sub_Vchat_logonTokenNotify:
		ON_MESSAGE(login_listener, SessionTokenResp, OnLogonTokenNotify)
		break;

	case Sub_Vchat_logonFinished:
		login_listener->OnLogonFinished();
		break;

	case Sub_Vchat_SetUserProfileResp:
		ON_MESSAGE(hall_listener, SetUserProfileResp, OnSetUserProfileResp)
		break;

	case Sub_Vchat_SetUserPwdResp:
		ON_MESSAGE(hall_listener, SetUserPwdResp, OnSetUserPwdResp)
		break;

	case Sub_Vchat_QueryRoomGateAddrResp:
		ON_MESSAGE(hall_listener, QueryRoomGateAddrResp, OnQueryRoomGateAddrResp)
		break;

	case Sub_Vchat_GetUserMoreInfResp:
		ON_MESSAGE(hall_listener, GetUserMoreInfResp, OnGetUserMoreInfResp)
		break;

	case Sub_Vchat_UserExitMessage_Resp:
		ON_MESSAGE(hall_listener, ExitAlertResp, OnUserExitMessageResp)
		break;

		/*
	case Sub_Vchat_HallMessageNotify:
		ON_MESSAGE(hall_listener, MessageNoty, OnHallMessageNotify)
		break;
	case Sub_Vchat_HallMessageUnreadResp:
		ON_MESSAGE(hall_listener, MessageUnreadResp, OnMessageUnreadResp)
		break;

		//���������߸���Ӧȫ���б�
	case Sub_Vchat_HallInteractBegin:
		g_vec_InteractResp.clear();
		break;
	case Sub_Vchat_HallInteractResp:
	{
		InteractResp objInteractResp;
		objInteractResp.ParseFromArray(body, objInteractResp.ByteSize());
		g_vec_InteractResp.push_back(objInteractResp);
	}
		break;
	case Sub_Vchat_HallInteractEnd:
		hall_listener->OnInteractResp(g_vec_InteractResp);
		break;

	case Sub_Vchat_HallAnswerBegin:
		g_vec_AnswerResp.clear();
		break;
	case Sub_Vchat_HallAnswerResp:
	{
		AnswerResp objAnswerResp;
		objAnswerResp.ParseFromArray(body, objAnswerResp.ByteSize());
		g_vec_AnswerResp.push_back(objAnswerResp);
	}
		break;
	case Sub_Vchat_HallAnswerEnd:
		hall_listener->OnHallAnswerResp(g_vec_AnswerResp);
		break;

	case Sub_Vchat_HallViewShowBegin:
		g_vec_ViewShowResp.clear();
		break;
	case Sub_Vchat_HallViewShowResp:
	{
		ViewShowResp objViewShowResp;
		objViewShowResp.ParseFromArray(body, objViewShowResp.ByteSize());
		g_vec_ViewShowResp.push_back(objViewShowResp);
	}
		break;
	case Sub_Vchat_HallViewShowEnd:
		hall_listener->OnViewShowResp(g_vec_ViewShowResp);
		break;

	case Sub_Vchat_HallTeacherFansBegin:
		g_vec_TeacherFansResp.clear();
		break;
	case Sub_Vchat_HallTeacherFansResp:
	{
		TeacherFansResp objTeacherFansResp;
		objTeacherFansResp.ParseFromArray(body, objTeacherFansResp.ByteSize());
		g_vec_TeacherFansResp.push_back(objTeacherFansResp);
	}
		break;
	case Sub_Vchat_HallTeacherFansEnd:
		hall_listener->OnTeacherFansResp(g_vec_TeacherFansResp);
		break;

	case Sub_Vchat_HallInterestBegin:
		g_vec_InterestResp.clear();
		break;
	case Sub_Vchat_HallInterestResp:
	{
		InterestResp objInterestResp;
		objInterestResp.ParseFromArray(body, objInterestResp.ByteSize());
		g_vec_InterestResp.push_back(objInterestResp);
	}
		break;
	case Sub_Vchat_HallInterestEnd:
		hall_listener->OnInterestResp(g_vec_InterestResp);
		break;

	case Sub_Vchat_HallUnInterestBegin:
		g_vec_UnInterestResp.clear();
		break;
	case Sub_Vchat_HallUnInterestResp:
	{
		UnInterestResp objUnInterestResp;
		objUnInterestResp.ParseFromArray(body, objUnInterestResp.ByteSize());
		g_vec_UnInterestResp.push_back(objUnInterestResp);
	}
		break;
	case Sub_Vchat_HallUnInterestEnd:
		hall_listener->OnUnInterestResp(g_vec_UnInterestResp);
		break;

	case Sub_Vchat_TextLivePointListBegin:
		g_vec_TextLivePointListResp.clear();
		break;
	case Sub_Vchat_TextLivePointListResp:
	{
		TextLivePointListResp objTextLivePointListResp;
		objTextLivePointListResp.ParseFromArray(body, objTextLivePointListResp.ByteSize());
		g_vec_TextLivePointListResp.push_back(objTextLivePointListResp);
	}
		break;
	case Sub_Vchat_TextLivePointListEnd:
		hall_listener->OnTextLivePointListResp(g_vec_TextLivePointListResp);
		break;

	case Sub_Vchat_HallPERSECResp:
		ON_MESSAGE(hall_listener, HallSecretsListResp, OnSecretsListResp)
		break;
	case Sub_Vchat_HallSystemInfoResp:
		ON_MESSAGE(hall_listener, HallSystemInfoListResp, OnSystemInfoResp)
		break;
		//end of ���������߸���Ӧȫ���б�

	case Sub_Vchat_HallViewAnswerResp:
		ON_MESSAGE(hall_listener, ViewAnswerResp, OnViewAnswerResp)
		break;
	case Sub_Vchat_HallInterestForResp:
		ON_MESSAGE(hall_listener, InterestForResp, OnInterestForResp)
		break;
	case Sub_Vchat_HallGetFansCountResp:
		ON_MESSAGE(hall_listener, FansCountResp, OnFansCountResp)
		break;
		*/

	case Sub_Vchat_ClientNotify:
		LOG("Sub_Vchat_ClientNotify");
		dispatch_push_message(body);
		break;
	default:
		LOG("+++++++unimplenment message+++++++:%d", sub_cmd);
		break;

	}

#ifndef ANDROID
	delete[] (uint8*)msg;
#endif

}

void LoginConnection::dispatch_push_message(void* body)
{
	protocol::tag_CMDPushGateMask* push = (protocol::tag_CMDPushGateMask*) body;

	if (push->userid != 0)
	{
		if (push->userid != logonuser.userid())
		{
			return;
		}
	}

	if (push->termtype != 4)
	{
		if (push->termtype != nmobile)
		{
			return;
		}
	}

	if (push->versionflag != 0)
	{
		if (push->versionflag == 1)
		{
			if (!(push->version == version))
			{
				return;
			}
		}
		else if (push->versionflag == 2)
		{
			if (!(push->version >= version))
			{
				return;
			}
		}
		else if (push->versionflag == 3)
		{
			if (!(push->version <= version))
			{
				return;
			}
		}
	}

	switch (push->type)
	{
	case 1:
	{
		protocol::tag_CMDConfigSvrNoty* conf_change_info = (protocol::tag_CMDConfigSvrNoty*) push->content;
		if (conf_change_info->type == 1)
		{
			push_listener->OnConfChanged(conf_change_info->data_ver);
		}
		else if (conf_change_info->type == 2)
		{
			push_listener->OnGiftListChanged(conf_change_info->data_ver);
		}
		else if (conf_change_info->type == 3)
		{
			push_listener->OnShowFunctionChanged(conf_change_info->data_ver);
		}
	}
		break;

	case 2:
		push_listener->OnPrintLog();
		break;

	case 3:
		push_listener->OnUpdateApp();
		break;

	case 4:
	{
		protocol::tag_CMDHitGoldEggClientNoty* money_change_info = (protocol::tag_CMDHitGoldEggClientNoty*) push->content;
		push_listener->OnMoneyChanged(money_change_info->money);
	}
		break;
	case 5:
		body = push->content;
		ON_MESSAGE(push_listener, BayWindow, OnBayWindow)
		break;

	case 6:
		push_listener->OnRoomGroupChanged();
		break;

	case 7:
		body = push->content;
		ON_MESSAGE(push_listener, RoomTeacherOnMicResp, OnRoomTeacherOnMicResp)

	}
}

LoginConnection::~LoginConnection(void)
{
}
