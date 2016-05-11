#include "stdafx.h"
#include "crc32.h"
#include "platform.h"
#include "Http.h"
#include "LoginConnection.h"
#include "Thread.h"
#include "login_cmd_vchat.h"

UserLogonSuccess2 loginuser;
UserLogonReq4 login_req4;
UserLogonReq5 login_req5;

uint32 login_reqv;
uint32 login_nmobile;
uint32 login_version;
uint32 login_userid;
string login_password;
SessionTokenResp login_token;

JoinRoomReq join_req;
JoinRoomResp room_info;
bool in_room;
bool need_join_room;


static time_t last_req_teamtopn_time;

LoginConnection::LoginConnection() :
login_listener(NULL), hall_listener(NULL), push_listener(NULL)
{
	loginuser.set_userid(0);
	need_join_room = false;
	last_req_teamtopn_time = 0;
	main_cmd = protocol::MDM_Vchat_Login;
}

void LoginConnection::RegisterLoginListener(LoginListener* message_listener)
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

	if (!socket_closed)
	{
		SEND_MESSAGE2(protocol::Sub_Vchat_ClientPing, protocol::CMDClientPing_t, &ping);
	}
}

void LoginConnection::join_room()
{
	if ( in_room || need_join_room )
	{
		protocol::CMDJoinRoomReq_t temreq = { 0 };
		string ip = join_req.cipaddr();
		join_req.set_cipaddr("");
		join_req.set_userid(loginuser.userid());
		join_req.set_cuserpwd(login_password);
		join_req.set_devtype(login_nmobile);
		join_req.set_bloginsource(login_reqv == 4 ? 0 : 1);
		join_req.set_time((uint32)time(0));
		join_req.set_coremessagever(10690001);
		join_req.set_reserve1(0);
		join_req.set_reserve2(0);

		join_req.set_crc32(15);
		join_req.SerializeToArray(&temreq, sizeof(protocol::CMDJoinRoomReq_t));

		uint32 crcval = crc32((void*)&temreq, sizeof(protocol::CMDJoinRoomReq_t), CRC_MAGIC);
		join_req.set_crc32(crcval);
		join_req.set_cipaddr(ip);
		join_req.Log();
		LOG("RE JOIN ROOM");
		SEND_MESSAGE_F(protocol::MDM_Vchat_Room, protocol::Sub_Vchat_JoinRoomReq, join_req);
	}

	if ( in_room )
	{
		AfterJoinRoomReq req;
		req.set_userid(join_req.userid());
		req.set_vcbid(join_req.vcbid());

		SEND_MESSAGE_F(protocol::MDM_Vchat_Room, protocol::Sub_Vchat_AfterJoinRoomReq, req);
	}

	need_join_room = false;

}

void LoginConnection::SendMsg_JoinRoomReq(JoinRoomReq& req)
{

	join_req = req;
	protocol::CMDJoinRoomReq_t temreq = { 0 };
	string ip = join_req.cipaddr();
	join_req.set_cipaddr("");
	join_req.set_userid(loginuser.userid());
	join_req.set_cuserpwd(login_password);
	join_req.set_devtype(login_nmobile);
	join_req.set_bloginsource(login_reqv == 4 ? 0 : 1);
	join_req.set_time((uint32)time(0));
	join_req.set_coremessagever(10690001);
	join_req.set_reserve1(0);
	join_req.set_reserve2(0);

	join_req.set_crc32(15);
	join_req.SerializeToArray(&temreq, sizeof(protocol::CMDJoinRoomReq_t));

	uint32 crcval = crc32((void*)&temreq, sizeof(protocol::CMDJoinRoomReq_t), CRC_MAGIC);
	join_req.set_crc32(crcval);
	join_req.set_cipaddr(ip);

	if (socket_connecting)
	{
		need_join_room = true;
	}
	else if ( !socket_closed )
	{
		LOG("SEND JOIN ROOM。。。");
		join_req.Log();
		SEND_MESSAGE_F(protocol::MDM_Vchat_Room, protocol::Sub_Vchat_JoinRoomReq, join_req);
		need_join_room = false;
	}
	else
	{
		connect_from_lbs_asyn();
		need_join_room = true;
	}
}


void LoginConnection::on_do_connected()
{
	SendMsg_Hello();

	if (login_reqv == 4)
	{
		login_req4.set_nmobile(CLIENT_TYPE);
		login_nmobile = login_req4.nmobile();
		login_version = login_req4.nversion();
		login_password = login_req4.cuserpwd();
		SEND_MESSAGE(protocol::Sub_Vchat_logonReq4, login_req4);
	}
	else
	{
		login_req5.set_nmobile(CLIENT_TYPE);
		login_nmobile = login_req5.nmobile();
		login_version = login_req5.nversion();
		login_password = "";
		SEND_MESSAGE(protocol::Sub_Vchat_logonReq5, login_req5);
	}

	start_read_thread();
}

void LoginConnection::RequestReconnect()
{
	close();
	connect_from_lbs_asyn();
	//connect("121.12.118.32", 7301);
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
	if ( !socket_connecting )
	{
		login_req4 = req;
		login_reqv = 4;
		connect_from_lbs_asyn();
		//connect("172.16.41.137 ", 7301);
	}
	else
	{
		LOG("socket_connecting when login request.");
	}
	//connect("121.12.118.32", 7301);
	//connect("122.13.81.62", 7301);
	//connect("172.16.41.137", 7301);
	//connect("172.16.41.215", 7301);
	//connect("172.16.41.114", 7301);
	//connect("172.16.41.45", 7301);

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
	req.set_introducelen(req.introduce().size());
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

void LoginConnection::SendMsg_InterestForReq(InterestForReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_HallInterestForReq, req);
}


void LoginConnection::SendMsg_BuyPrivateVipReq(uint32 teacherid,uint32 viptype)
{
	BuyPrivateVipReq req;
	req.set_userid(login_userid);
	req.set_teacherid(teacherid);
	req.set_viptype(viptype);

	SEND_MESSAGE(protocol::Sub_Vchat_BuyPrivateVipReq, req);
}

void LoginConnection::SendMsg_ViewpointTradeGiftReq(ViewpointTradeGiftReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_ViewpointTradeGiftReq, req);
}

void LoginConnection::SendMsg_OnMicRobertReq(OnMicRobertReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_GetOnMicRobertReq, req);
}

void LoginConnection::SendMsg_TeamTopNReq()
{
	TeamTopNReq req;
	req.set_userid(login_userid);
	req.set_vcbid(room_info.vcbid());
	SEND_MESSAGE_F(protocol::MDM_Vchat_Room, protocol::Sub_Vchat_TeamTopNReq, req);
}

void LoginConnection::close(void)
{
	//SendMsg_ExitAlertReq();
	loginuser.set_userid(0);
	Connection::close();
}

void LoginConnection::on_tick()
{
	if (in_room)
	{
		time_t ctime = time(0);
		if ( ctime - last_req_teamtopn_time > 60 * 5 )
		{
			SendMsg_TeamTopNReq();
			last_req_teamtopn_time = ctime;
		}
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

	//列表vector
	static std::vector<InteractResp> g_vec_InteractResp;//互动回复列表
	static std::vector<AnswerResp> g_vec_AnswerResp;//问答回复列表
	static std::vector<ViewShowResp> g_vec_ViewShowResp;//观点回复列表
	static std::vector<TeacherFansResp> g_vec_TeacherFansResp;//我的粉丝列表
	static std::vector<InterestResp> g_vec_InterestResp;//我的关注（已关注讲师）列表
	static std::vector<UnInterestResp> g_vec_UnInterestResp;//我的关注（无关注讲师）列表
	static std::vector<TextLivePointListResp> g_vec_TextLivePointListResp;//明日预测（已关注的讲师）列表

	static std::vector<HallSecretsListResp> g_vec_SecretsListResp;//已购买的个人秘籍列表
	static std::vector<HallSystemInfoListResp> g_vec_SystemInfoResp;//系统消息列表

	protocol::COM_MSG_HEADER*head = (protocol::COM_MSG_HEADER*)msg;
	uint8* body = (uint8*) (head->content);

	int sub_cmd = head->subcmd;
	int body_len = head->length - sizeof(protocol::COM_MSG_HEADER);

	LOG("message+++++++:%d", sub_cmd);

	switch (sub_cmd)
	{

	//登陆失败
	case protocol::Sub_Vchat_logonErr2:
		ON_MESSAGE(login_listener, UserLogonErr2, OnLogonErr)
		close();
		break;

	//登陆成功
	case protocol::Sub_Vchat_logonSuccess2:
		loginuser.ParseFromArray(body, loginuser.ByteSize());
		login_userid = loginuser.userid();
		if (login_listener != NULL)
			login_listener->OnLogonSuccess(loginuser);
		if (need_join_room || in_room)
			join_room();
		break;

	//房间组列表开始
	case protocol::Sub_Vchat_RoomGroupListBegin:
		room_groups_count = 0;
		room_groups = new RoomGroupItem[20];
		break;

	//收到服务器ping消息的返回,表示房间活着
	case protocol::Sub_Vchat_ClientPingResp:
		//ON_MESSAGE(login_listener, ClientPingResp, OnClientPingResp);
		break;

	//房间组列表
	case protocol::Sub_Vchat_RoomGroupListResp:
		body += sizeof(uint32);
		room_groups[room_groups_count].ParseFromArray(body,
				room_groups[room_groups_count].ByteSize());
		room_groups_count++;
		break;

	//房间组结束
	case protocol::Sub_Vchat_RoomGroupListFinished:
		if (login_listener != NULL)
			login_listener->OnRoomGroupList(room_groups, room_groups_count);
		delete[] room_groups;
		break;

	//权限id数据
	case protocol::Sub_VChat_QuanxianId2ListResp:
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

	//权限操作数据开始
	case protocol::Sub_VChat_QuanxianAction2ListBegin:
		qx_actions_count = 0;
		qx_actions = new QuanxianAction2Item[4000];
		break;

	//权限操作数据
	case protocol::Sub_VChat_QuanxianAction2ListResp:
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

	//权限操作数据结束
	case protocol::Sub_VChat_QuanxianAction2ListFinished:
		if (login_listener != NULL)
			login_listener->OnQuanxianAction2List(qx_actions, qx_actions_count);
		delete[] qx_actions;
		break;

	//token通知
	case protocol::Sub_Vchat_logonTokenNotify:
		//ON_MESSAGE(login_listener, SessionTokenResp, OnLogonTokenNotify)
		login_token.ParseFromArray(body, login_token.ByteSize());
		if (login_listener)
			login_listener->OnLogonTokenNotify(login_token);
		break;

	//登录完成
	case protocol::Sub_Vchat_logonFinished:
		if (login_listener != NULL)
			login_listener->OnLogonFinished();
		break;

	//设置用户资料响应
	case protocol::Sub_Vchat_SetUserProfileResp:
	{
		SetUserProfileResp _SetUserProfileResp;
		_SetUserProfileResp.ParseFromArray(body, _SetUserProfileResp.ByteSize());
		body += _SetUserProfileResp.ByteSize();

		SetUserProfileReq _SetUserProfileReq;
		_SetUserProfileReq.ParseFromArray(body, _SetUserProfileReq.ByteSize());

		if (login_listener != NULL)
			hall_listener->OnSetUserProfileResp(_SetUserProfileResp, _SetUserProfileReq);
	}
		break;

	//设置用户密码响应
	case protocol::Sub_Vchat_SetUserPwdResp:
		ON_MESSAGE(hall_listener, SetUserPwdResp, OnSetUserPwdResp)
		break;

	//获取房间网关地址响应
	case protocol::Sub_Vchat_QueryRoomGateAddrResp:
		ON_MESSAGE(hall_listener, QueryRoomGateAddrResp, OnQueryRoomGateAddrResp)
		break;

	//获取用户更多信息应答（手机，个性签名等）
	case protocol::Sub_Vchat_GetUserMoreInfResp:
		ON_MESSAGE(hall_listener, GetUserMoreInfResp, OnGetUserMoreInfResp)
		break;

	//用户退出软件的响应
	case protocol::Sub_Vchat_UserExitMessage_Resp:
		ON_MESSAGE(hall_listener, ExitAlertResp, OnUserExitMessageResp)
		break;

	//关注（无关注讲师时返回所有讲师列表，点击关注）响应
	case protocol::Sub_Vchat_HallInterestForResp:
		ON_MESSAGE(hall_listener, InterestForResp, OnInterestForResp)
		break;

	//推送命令
	case protocol::Sub_Vchat_ClientNotify:
	//砸金蛋通知
	case protocol::Sub_Vchat_HitGoldEgg_ToClient_Noty:
		LOG("protocol::Sub_Vchat_ClientNotify");
		dispatch_push_message(body);
		break;
	//购买私人订制响应
	case protocol::Sub_Vchat_BuyPrivateVipResp:
		ON_MESSAGE(hall_listener, BuyPrivateVipResp, OnBuyPrivateVipResp)
		break;

	case protocol::Sub_Vchat_Resp_ErrCode:
		LOG("protocol::Sub_Vchat_Resp_ErrCode");
		dispatch_error_message(body);
		break;

	//观点赠送礼物响应
	case protocol::Sub_Vchat_ViewpointTradeGiftResp:
		ON_MESSAGE(hall_listener,ViewpointTradeGiftNoty, OnViewpointTradeGiftResp);
		break;

	//获取房间的转播机器人ID应答
	case protocol::Sub_Vchat_GetOnMicRobertResp:
		ON_MESSAGE(hall_listener,OnMicRobertResp, OnOnMicRobertResp);
		break;

	default:
		LOG("+++++++unimplenment message+++++++:%d", sub_cmd);
		break;

	}

#ifndef ANDROID
	delete[] (uint8*)msg;
#endif

}

void LoginConnection::dispatch_error_message(void* body)
{
	protocol::CMDErrCodeResp_t* errorinfo = (protocol::CMDErrCodeResp_t*) body;
	switch (errorinfo->errsubcmd)
	{
	case protocol::Sub_Vchat_BuyPrivateVipReq:
		ON_MESSAGE(hall_listener, ErrCodeResp, OnBuyPrivateVipErr)
		break;
	case protocol::Sub_Vchat_ViewpointTradeGiftReq:
		ON_MESSAGE(hall_listener, ErrCodeResp, OnViewpointTradeGiftErr)
		break;
	default:
	{
		ErrCodeResp info;
		info.ParseFromArray(body, info.ByteSize());
		info.Log();

	}
		break;
	}
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
			if (push_listener != NULL)
				push_listener->OnConfChanged(conf_change_info->data_ver);
		}
		else if (conf_change_info->type == 2)
		{
			if (push_listener != NULL)
				push_listener->OnGiftListChanged(conf_change_info->data_ver);
		}
		else if (conf_change_info->type == 3)
		{
			if (push_listener != NULL)
				push_listener->OnShowFunctionChanged(conf_change_info->data_ver);
		}
	}
		break;

	case 2:
		{
			if (push_listener != NULL)
				push_listener->OnPrintLog();
		}
		break;

	case 3:
		{
			if (push_listener != NULL)
				push_listener->OnUpdateApp();
		}
		break;

	case 4:
	{
		protocol::tag_CMDHitGoldEggClientNoty* money_change_info = (protocol::tag_CMDHitGoldEggClientNoty*) push->content;
		if (push_listener != NULL)
			push_listener->OnMoneyChanged(money_change_info->money);
	}
		break;
	case 5:
		body = push->content;
		ON_MESSAGE(push_listener, BayWindow, OnBayWindow)
		break;

	case 6:
		{
			if (push_listener != NULL)
				push_listener->OnRoomGroupChanged();
		}
		break;

	case 7:
		body = push->content;
		ON_MESSAGE(push_listener, RoomTeacherOnMicResp, OnRoomTeacherOnMicResp)
		break;

	case 9:
		body = push->content;
		ON_MESSAGE(push_listener, EmailNewMsgNoty, OnEmailNewMsgNoty)
		break;
	}
}

LoginConnection::~LoginConnection(void)
{
}

