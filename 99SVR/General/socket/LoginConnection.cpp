
#include "platform.h"
#include "Http.h"
#include "LoginConnection.h"
#include "Thread.h"
#include "login_cmd_vchat.h"

 UserLogonSuccess2 loginuser;
  UserLogonReq4 login_req4;
  UserLogonReq5  login_req5;

  uint32 login_reqv;
  uint32 login_nmobile;
  uint32 login_version;
  uint32 login_userid;
  string login_password;

LoginConnection::LoginConnection() :
login_listener(NULL), hall_listener(NULL), push_listener(NULL)
{
	main_cmd = protocol::MDM_Vchat_Login;
	strcpy(lbs_type, "/tygetlogon");
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
	protocol::CMDClientPing_t ping;
	ping.userid = loginuser.userid();
	ping.roomid = 0;

	SEND_MESSAGE2(protocol::Sub_Vchat_ClientPing, protocol::CMDClientPing_t, &ping);
}

void LoginConnection::on_do_connected()
{
	SendMsg_Hello();

	if (login_reqv == 4)
	{
		login_req4.set_nmobile(CLIENT_TYPE);
		SEND_MESSAGE(protocol::Sub_Vchat_logonReq4, login_req4);
		login_nmobile = login_req4.nmobile();
		login_version = login_req4.nversion();
		login_password = login_req4.cuserpwd();
	}
	else
	{
		login_req5.set_nmobile(CLIENT_TYPE);
		SEND_MESSAGE(protocol::Sub_Vchat_logonReq5, login_req5);
		login_nmobile = login_req5.nmobile();
		login_version = login_req5.nversion();
		login_password = "";
	}

	start_read_thread();
}

void LoginConnection::SendMsg_LoginReq4(UserLogonReq4& req)
{
	//121.12.118.32:7301
	//120.197.248.11:7401  移动
	// "login1.99ducaijing.cn", 7401
	//connect("121.12.118.32", 7301);
	
	/*
	int ret = connect("121.14.211.60",7402);

	if (ret != 0)
		return;
	*/
	login_req4 = req;
	login_reqv = 4;
	
	connect_from_lbs_asyn();

	/*
	SendMsg_Hello();
	SEND_MESSAGE(protocol::Sub_Vchat_logonReq4, req);

	nmobile = req.nmobile();
	version = req.nversion();

	start_read_thread();
	*/
}

void LoginConnection::SendMsg_LoginReq5(UserLogonReq5& req)
{
	login_req5 = req;
	login_reqv = 5;

	connect_from_lbs_asyn();
}

void LoginConnection::SendMsg_SessionTokenReq(uint32 userid)
{
	SessionTokenReq req;
	req.set_userid(userid);

	SEND_MESSAGE(protocol::Sub_Vchat_logonTokenReq, req);
}

void LoginConnection::SendMsg_SetUserInfoReq(SetUserProfileReq& req)
{
	req.set_userid(loginuser.userid());
	req.set_introducelen(strlen(req.introduce().c_str()));
	SEND_MESSAGE_EX(protocol::Sub_Vchat_SetUserProfileReq, req, req.introducelen());
}

void LoginConnection::SendMsg_SetUserPwdReq(uint32 vcbid, uint32 pwdtype, const char* oldpwd, const char* newpwd)
{
	SetUserPwdReq req;
	req.set_userid(loginuser.userid());
	req.set_vcbid(vcbid);
	req.set_pwdtype(pwdtype);
	req.set_oldpwd(oldpwd);
	req.set_newpwd(newpwd);

	SEND_MESSAGE(protocol::Sub_Vchat_SetUserPwdReq, req);
}

void LoginConnection::SendMsg_QueryRoomGateAddrReq(uint32 userid, uint32 roomid, uint32 flags)
{
	QueryRoomGateAddrReq req;
	req.set_userid(userid);
	req.set_roomid(roomid);
	req.set_flags(flags);

	SEND_MESSAGE(protocol::Sub_Vchat_QueryRoomGateAddrReq, req);
}

void LoginConnection::SendMsg_GetRoomGroupListReq()
{
	RoomGroupListReq req;
	req.set_userid(loginuser.userid());

	SEND_MESSAGE(protocol::Sub_Vchat_RoomGroupListReq, req);
}

void LoginConnection::SendMsg_GetUserMoreInfReq(uint32 userid)
{
	GetUserMoreInfReq req;
	req.set_userid(userid);

	SEND_MESSAGE(protocol::Sub_Vchat_GetUserMoreInfReq, req);
}

void LoginConnection::SendMsg_ExitAlertReq()
{
	ExitAlertReq req;
	req.set_userid(loginuser.userid());

	SEND_MESSAGE(protocol::Sub_Vchat_UserExitMessage_Req, req);
}


void LoginConnection::SendMsg_MessageUnreadReq()
{
	MessageNoty noty;
	noty.set_userid(loginuser.userid());

	SEND_MESSAGE(protocol::Sub_Vchat_HallMessageUnreadReq, noty);
}

void LoginConnection::SendMsg_HallMessageReq(HallMessageReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_HallMessageReq, req);
}

void LoginConnection::SendMsg_HallMessageReq2(TextRoomList_mobile& head,HallMessageReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_HallMessageReq_Mobile, req);
}

void LoginConnection::SendMsg_ViewAnswerReq(ViewAnswerReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_HallViewAnswerReq, req);
}

void LoginConnection::SendMsg_InterestForReq(InterestForReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_HallInterestForReq, req);
}

void LoginConnection::SendMsg_FansCountReq(uint32 teacherid)
{
	FansCountReq req;
	req.set_teacherid(teacherid);

	SEND_MESSAGE(protocol::Sub_Vchat_HallGetFansCountReq, req);
}

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

	//列表vector
	static std::vector<InteractResp> g_vec_InteractResp;
	static std::vector<AnswerResp> g_vec_AnswerResp;
	static std::vector<ViewShowResp> g_vec_ViewShowResp;
	static std::vector<TeacherFansResp> g_vec_TeacherFansResp;
	static std::vector<InterestResp> g_vec_InterestResp;
	static std::vector<UnInterestResp> g_vec_UnInterestResp;
	static std::vector<TextLivePointListResp> g_vec_TextLivePointListResp;

	protocol::COM_MSG_HEADER*head = (protocol::COM_MSG_HEADER*)msg;
	uint8* body = (uint8*) (head->content);

	int sub_cmd = head->subcmd;
	int body_len = head->length - sizeof(protocol::COM_MSG_HEADER);

	LOG("message+++++++:%d", sub_cmd);

	switch (sub_cmd)
	{

	case protocol::Sub_Vchat_logonErr2:
		ON_MESSAGE(login_listener, UserLogonErr2, OnLogonErr)
		close();
		break;

	case protocol::Sub_Vchat_logonSuccess2:
		loginuser.ParseFromArray(body, loginuser.ByteSize());
		if (login_listener != NULL)
			login_listener->OnLogonSuccess(loginuser);
		break;

	case protocol::Sub_Vchat_RoomGroupListBegin:
		room_groups_count = 0;
		room_groups = new RoomGroupItem[20];
		break;

	case protocol::Sub_Vchat_RoomGroupListResp:
		body += sizeof(uint32);
		room_groups[room_groups_count].ParseFromArray(body,
				room_groups[room_groups_count].ByteSize());
		room_groups_count++;
		break;

	case protocol::Sub_Vchat_RoomGroupListFinished:
		if (login_listener != NULL)
			login_listener->OnRoomGroupList(room_groups, room_groups_count);
		delete[] room_groups;
		break;

	case protocol::Sub_Vchat_QuanxianId2ListResp:
		qx_ids_count = body_len / sizeof(protocol::CMDQuanxianId2Item_t);
		qx_ids = new QuanxianId2Item[qx_ids_count];
		for (int i = 0; i < qx_ids_count; i++)
		{
			qx_ids[i].ParseFromArray(body, qx_ids[i].ByteSize());
			body += qx_ids[i].ByteSize();
		}
		if (login_listener != NULL)
			login_listener->OnQuanxianId2List(qx_ids, qx_ids_count);
		delete[] qx_ids;
		break;

	case protocol::Sub_Vchat_QuanxianAction2ListBegin:
		qx_actions_count = 0;
		qx_actions = new QuanxianAction2Item[4000];
		break;

	case protocol::Sub_Vchat_QuanxianAction2ListResp:
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

	case protocol::Sub_Vchat_QuanxianAction2ListFinished:
		if (login_listener != NULL)
			login_listener->OnQuanxianAction2List(qx_actions, qx_actions_count);
		delete[] qx_actions;
		break;

	case protocol::Sub_Vchat_logonTokenNotify:
		ON_MESSAGE(login_listener, SessionTokenResp, OnLogonTokenNotify)
		break;

	case protocol::Sub_Vchat_logonFinished:
		if (login_listener != NULL)
			login_listener->OnLogonFinished();
		break;

	case protocol::Sub_Vchat_SetUserProfileResp:
	{
		SetUserProfileResp _SetUserProfileResp;
		_SetUserProfileResp.ParseFromArray(body, _SetUserProfileResp.ByteSize());
		body += _SetUserProfileResp.ByteSize();

		SetUserProfileReq _SetUserProfileReq;
		_SetUserProfileReq.ParseFromArray(body, _SetUserProfileReq.ByteSize());

		hall_listener->OnSetUserProfileResp(_SetUserProfileResp, _SetUserProfileReq);
	}
		break;

	case protocol::Sub_Vchat_SetUserPwdResp:
		ON_MESSAGE(hall_listener, SetUserPwdResp, OnSetUserPwdResp)
		break;

	case protocol::Sub_Vchat_QueryRoomGateAddrResp:
		ON_MESSAGE(hall_listener, QueryRoomGateAddrResp, OnQueryRoomGateAddrResp)
		break;

	case protocol::Sub_Vchat_GetUserMoreInfResp:
		ON_MESSAGE(hall_listener, GetUserMoreInfResp, OnGetUserMoreInfResp)
		break;

	case protocol::Sub_Vchat_UserExitMessage_Resp:
		ON_MESSAGE(hall_listener, ExitAlertResp, OnUserExitMessageResp)
		break;

	case protocol::Sub_Vchat_HallMessageNotify:
		ON_MESSAGE(hall_listener, MessageNoty, OnHallMessageNotify)
		break;
	case protocol::Sub_Vchat_HallMessageUnreadResp:
		ON_MESSAGE(hall_listener, MessageUnreadResp, OnMessageUnreadResp)
		break;

		//这里下面七个回应全是列表
	case protocol::Sub_Vchat_HallInteractBegin:
		g_vec_InteractResp.clear();
		break;
	case protocol::Sub_Vchat_HallInteractResp:
	{
		InteractResp objInteractResp;
		objInteractResp.ParseFromArray(body, objInteractResp.ByteSize());
		g_vec_InteractResp.push_back(objInteractResp);
	}
		break;
	case protocol::Sub_Vchat_HallInteractEnd:
		hall_listener->OnInteractResp(g_vec_InteractResp);
		break;

	case protocol::Sub_Vchat_HallAnswerBegin:
		g_vec_AnswerResp.clear();
		break;
	case protocol::Sub_Vchat_HallAnswerResp:
	{
		AnswerResp objAnswerResp;
		objAnswerResp.ParseFromArray(body, objAnswerResp.ByteSize());
		g_vec_AnswerResp.push_back(objAnswerResp);
	}
		break;
	case protocol::Sub_Vchat_HallAnswerEnd:
		hall_listener->OnHallAnswerResp(g_vec_AnswerResp);
		break;

	case protocol::Sub_Vchat_HallViewShowBegin:
		g_vec_ViewShowResp.clear();
		break;
	case protocol::Sub_Vchat_HallViewShowResp:
	{
		ViewShowResp objViewShowResp;
		objViewShowResp.ParseFromArray(body, objViewShowResp.ByteSize());
		g_vec_ViewShowResp.push_back(objViewShowResp);
	}
		break;
	case protocol::Sub_Vchat_HallViewShowEnd:
		hall_listener->OnViewShowResp(g_vec_ViewShowResp);
		break;

	case protocol::Sub_Vchat_HallTeacherFansBegin:
		g_vec_TeacherFansResp.clear();
		break;
	case protocol::Sub_Vchat_HallTeacherFansResp:
	{
		TeacherFansResp objTeacherFansResp;
		objTeacherFansResp.ParseFromArray(body, objTeacherFansResp.ByteSize());
		g_vec_TeacherFansResp.push_back(objTeacherFansResp);
	}
		break;
	case protocol::Sub_Vchat_HallTeacherFansEnd:
		hall_listener->OnTeacherFansResp(g_vec_TeacherFansResp);
		break;

	case protocol::Sub_Vchat_HallInterestBegin:
		g_vec_InterestResp.clear();
		break;
	case protocol::Sub_Vchat_HallInterestResp:
	{
		InterestResp objInterestResp;
		objInterestResp.ParseFromArray(body, objInterestResp.ByteSize());
		g_vec_InterestResp.push_back(objInterestResp);
	}
		break;
	case protocol::Sub_Vchat_HallInterestEnd:
		hall_listener->OnInterestResp(g_vec_InterestResp);
		break;

	case protocol::Sub_Vchat_HallUnInterestBegin:
		g_vec_UnInterestResp.clear();
		break;
	case protocol::Sub_Vchat_HallUnInterestResp:
	{
		UnInterestResp objUnInterestResp;
		objUnInterestResp.ParseFromArray(body, objUnInterestResp.ByteSize());
		g_vec_UnInterestResp.push_back(objUnInterestResp);
	}
		break;
	case protocol::Sub_Vchat_HallUnInterestEnd:
		hall_listener->OnUnInterestResp(g_vec_UnInterestResp);
		break;

	case protocol::Sub_Vchat_TextLivePointListBegin:
		g_vec_TextLivePointListResp.clear();
		break;
	case protocol::Sub_Vchat_TextLivePointListResp:
	{
		TextLivePointListResp objTextLivePointListResp;
		objTextLivePointListResp.ParseFromArray(body, objTextLivePointListResp.ByteSize());
		g_vec_TextLivePointListResp.push_back(objTextLivePointListResp);
	}
		break;
	case protocol::Sub_Vchat_TextLivePointListEnd:
		hall_listener->OnTextLivePointListResp(g_vec_TextLivePointListResp);
		break;




	case protocol::Sub_Vchat_HallInteractResp_Mobile:
	{
		g_vec_InteractResp.clear();

		int msglen=body_len;
		TextRoomList_mobile headmsg;
		headmsg.ParseFromArray(body, headmsg.ByteSize());
		body += headmsg.ByteSize();
		msglen -= headmsg.ByteSize();
		while(msglen>0)
		{
			InteractResp objInteractResp;
			objInteractResp.ParseFromArray(body, objInteractResp.ByteSize());
			g_vec_InteractResp.push_back(objInteractResp);
			body += objInteractResp.ByteSize() + objInteractResp.sortextlen() + objInteractResp.destextlen();
			msglen -= objInteractResp.ByteSize() + objInteractResp.sortextlen() + objInteractResp.destextlen();
		}

		hall_listener->OnInteractResp(g_vec_InteractResp);
	}
	break;
	case protocol::Sub_Vchat_HallAnswerResp_Mobile:
	{
		g_vec_AnswerResp.clear();

		int msglen=body_len;
		TextRoomList_mobile headmsg;
		headmsg.ParseFromArray(body, headmsg.ByteSize());
		body += headmsg.ByteSize();
		msglen -= headmsg.ByteSize();
		while(msglen>0)
		{
			AnswerResp objAnswerResp;
			objAnswerResp.ParseFromArray(body, objAnswerResp.ByteSize());
			g_vec_AnswerResp.push_back(objAnswerResp);
			body += objAnswerResp.ByteSize() + objAnswerResp.answerlen() + objAnswerResp.stokeidlen() + objAnswerResp.questionlen();
			msglen -= objAnswerResp.ByteSize() + objAnswerResp.answerlen() + objAnswerResp.stokeidlen() + objAnswerResp.questionlen();
		}

		hall_listener->OnHallAnswerResp(g_vec_AnswerResp);
	}
	break;
	case protocol::Sub_Vchat_HallViewShowResp_Mobile:
	{
		g_vec_ViewShowResp.clear();

		int msglen=body_len;
		TextRoomList_mobile headmsg;
		headmsg.ParseFromArray(body, headmsg.ByteSize());
		body += headmsg.ByteSize();
		msglen -= headmsg.ByteSize();
		while(msglen>0)
		{
			ViewShowResp objViewShowResp;
			objViewShowResp.ParseFromArray(body, objViewShowResp.ByteSize());
			g_vec_ViewShowResp.push_back(objViewShowResp);
			body += objViewShowResp.ByteSize() + objViewShowResp.viewtitlelen() + objViewShowResp.viewtextlen() + objViewShowResp.srctextlen() + objViewShowResp.replytextlen();
			msglen -= objViewShowResp.ByteSize() + objViewShowResp.viewtitlelen() + objViewShowResp.viewtextlen() + objViewShowResp.srctextlen() + objViewShowResp.replytextlen();
		}

		hall_listener->OnViewShowResp(g_vec_ViewShowResp);
	}
	break;
	case protocol::Sub_Vchat_HallTeacherFansResp_Mobile:
	{
		g_vec_TeacherFansResp.clear();

		int msglen=body_len;
		TextRoomList_mobile headmsg;
		headmsg.ParseFromArray(body, headmsg.ByteSize());
		body += headmsg.ByteSize();
		msglen -= headmsg.ByteSize();
		while(msglen>0)
		{
			TeacherFansResp objTeacherFansResp;
			objTeacherFansResp.ParseFromArray(body, objTeacherFansResp.ByteSize());
			g_vec_TeacherFansResp.push_back(objTeacherFansResp);
			body += objTeacherFansResp.ByteSize();
			msglen -= objTeacherFansResp.ByteSize();
		}

		hall_listener->OnTeacherFansResp(g_vec_TeacherFansResp);
	}
	break;
	case protocol::Sub_Vchat_HallInterestResp_Mobile:
	{
		g_vec_InterestResp.clear();

		int msglen=body_len;
		TextRoomList_mobile headmsg;
		headmsg.ParseFromArray(body, headmsg.ByteSize());
		body += headmsg.ByteSize();
		msglen -= headmsg.ByteSize();
		while(msglen>0)
		{
			InterestResp objInterestResp;
			objInterestResp.ParseFromArray(body, objInterestResp.ByteSize());
			g_vec_InterestResp.push_back(objInterestResp);
			body += objInterestResp.ByteSize();
			msglen -= objInterestResp.ByteSize();
		}

		hall_listener->OnInterestResp(g_vec_InterestResp);
	}
	break;
	case protocol::Sub_Vchat_HallUnInterestResp_Mobile:
	{
		g_vec_UnInterestResp.clear();

		int msglen=body_len;
		TextRoomList_mobile headmsg;
		headmsg.ParseFromArray(body, headmsg.ByteSize());
		body += headmsg.ByteSize();
		msglen -= headmsg.ByteSize();
		while(msglen>0)
		{
			UnInterestResp objUnInterestResp;
			objUnInterestResp.ParseFromArray(body, objUnInterestResp.ByteSize());
			g_vec_UnInterestResp.push_back(objUnInterestResp);
			body += objUnInterestResp.ByteSize() + objUnInterestResp.levellen() + objUnInterestResp.labellen() + objUnInterestResp.goodatlen();
			msglen -= objUnInterestResp.ByteSize() + objUnInterestResp.levellen() + objUnInterestResp.labellen() + objUnInterestResp.goodatlen();
		}

		hall_listener->OnUnInterestResp(g_vec_UnInterestResp);
	}
	break;
	case protocol::Sub_Vchat_TextLivePointListResp_Mobile:
	{
		g_vec_TextLivePointListResp.clear();

		int msglen=body_len;
		TextRoomList_mobile headmsg;
		headmsg.ParseFromArray(body, headmsg.ByteSize());
		body += headmsg.ByteSize();
		msglen -= headmsg.ByteSize();
		while(msglen>0)
		{
			TextLivePointListResp objTextLivePointListResp;
			objTextLivePointListResp.ParseFromArray(body, objTextLivePointListResp.ByteSize());
			g_vec_TextLivePointListResp.push_back(objTextLivePointListResp);
			body += objTextLivePointListResp.ByteSize() + objTextLivePointListResp.textlen();
			msglen -= objTextLivePointListResp.ByteSize() + objTextLivePointListResp.textlen();
		}

		hall_listener->OnTextLivePointListResp(g_vec_TextLivePointListResp);
	}
	break;



	case protocol::Sub_Vchat_HallPERSECResp:
		//ON_MESSAGE(hall_listener, HallSecretsListResp, OnSecretsListResp)
		break;
	case protocol::Sub_Vchat_HallSystemInfoResp:
		//ON_MESSAGE(hall_listener, HallSystemInfoListResp, OnSystemInfoResp)
		break;
		//end of 这里下面七个回应全是列表

	case protocol::Sub_Vchat_HallViewAnswerResp:
		ON_MESSAGE(hall_listener, ViewAnswerResp, OnViewAnswerResp)
		break;
	case protocol::Sub_Vchat_HallInterestForResp:
		ON_MESSAGE(hall_listener, InterestForResp, OnInterestForResp)
		break;
	case protocol::Sub_Vchat_HallGetFansCountResp:
		ON_MESSAGE(hall_listener, FansCountResp, OnFansCountResp)
		break;

	case protocol::Sub_Vchat_ClientNotify:
	case protocol::Sub_Vchat_HitGoldEgg_ToClient_Noty:
		LOG("protocol::Sub_Vchat_ClientNotify");
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
		if (push->userid != loginuser.userid())
		{
			return;
		}
	}

	if (push->termtype != 4)
	{
		if (push->termtype != login_nmobile)
		{
			return;
		}
	}

	if (push->versionflag != 0)
	{
		if (push->versionflag == 1)
		{
			if (!(push->version == login_version))
			{
				return;
			}
		}
		else if (push->versionflag == 2)
		{
			if (!(login_version >= push->version))
			{
				return;
			}
		}
		else if (push->versionflag == 3)
		{
			if (!(login_version <= push->version))
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

