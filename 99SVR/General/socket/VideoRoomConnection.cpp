/**
 * 1. SendMsg_ReportMediaGate 需要加入房间网关Ip:port
 */


#include "crc32.h"
#include "platform.h"
#include "Http.h"
#include "VideoRoomConnection.h"
#include "Thread.h"
#include "videoroom_cmd_vchat.h"

#include <vector>

RoomConnection::RoomConnection(void) :
room_listener(NULL)
{
	main_cmd = protocol::MDM_Vchat_Room;
	strcpy(lbs_type, "/tygetgate");
}

void RoomConnection::RegisterMessageListener(RoomListener* message_listener)
{
	room_listener = message_listener;
}

void RoomConnection::SendMsg_Ping()
{
	protocol::CMDClientPing_t ping;
	ping.userid = join_req.userid();
	ping.roomid = join_req.vcbid();

	SEND_MESSAGE2(protocol::Sub_Vchat_ClientPing, protocol::CMDClientPing_t, &ping);
}

void RoomConnection::on_do_connected()
{
	SendMsg_Hello();

	
	protocol::CMDJoinRoomReq2_t temreq = { 0 };
	string ip = join_req.cipaddr();
	join_req.set_cipaddr("");
	join_req.set_userid(loginuser.userid()); 
	join_req.set_cuserpwd(login_password);
	join_req.set_devtype(login_nmobile);
	join_req.set_bloginsource(login_reqv == 4 ? 0 : 1);
	join_req.set_time(0);
	join_req.set_coremessagever(10690001);
	join_req.set_reserve1(0);
	join_req.set_reserve2(0);

	join_req.set_crc32(15);
	join_req.SerializeToArray(&temreq, sizeof(protocol::CMDJoinRoomReq2_t));

	uint32 crcval = crc32((void*)&temreq, sizeof(protocol::CMDJoinRoomReq2_t), CRC_MAGIC);
	join_req.set_crc32(crcval);
	join_req.set_cipaddr(ip);
	

	SEND_MESSAGE(protocol::Sub_Vchat_JoinRoomReq, join_req);

	start_read_thread();
}

void RoomConnection::SendMsg_JoinRoomReq2(JoinRoomReq2& req)
{
	join_req = req;
	connect_from_lbs_asyn();

	/*
	int ret;
	
	ret = connect("121.14.211.61", 22764);

	if (ret != 0)
		return;

	join_req = req;

	SendMsg_Hello();

	SEND_MESSAGE(protocol::Sub_Vchat_JoinRoomReq, req);

	//close();

	//Sleep(3000);

	start_read_thread();
	*/
	
}

void RoomConnection::SendMsg_ExitRoomReq()
{
	UserExitRoomInfo req;
    
	req.set_userid(join_req.userid());
	req.set_vcbid(join_req.vcbid());

	SEND_MESSAGE(protocol::Sub_Vchat_RoomUserExitReq, req);
}

void RoomConnection::SendMsg_ModifyAdKeywordsReq(AdKeywordsReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_AdKeyWordOperateReq, req);
}

void RoomConnection::SendMsg_KickoutUserReq(UserKickoutRoomInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_RoomKickoutUserReq, req);
}

void RoomConnection::SendMsg_SetMicStateReq(UserMicState& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetMicStateReq, req);
}

void RoomConnection::SendMsg_TradeGiftReq(TradeGiftRecord& req)
{
	req.set_srcid(loginuser.userid());
	req.set_srcalias(loginuser.cuseralias());
	req.set_vcbid(join_req.vcbid());
	req.set_srcvcbname(room_info.cname());
	req.set_tovcbid(join_req.vcbid());
	req.set_tovcbname(room_info.cname());

	SEND_MESSAGE(protocol::Sub_Vchat_TradeGiftReq, req);
}

void RoomConnection::SendMsg_RoomChatReq(RoomChatMsg& req)
{
	req.set_msgtype(0);
	req.set_srcid(loginuser.userid());
	req.set_srcalias(loginuser.cuseralias());
	req.set_srcviplevel(loginuser.viplevel());
	req.set_vcbid(join_req.vcbid());
	req.set_tocbid(join_req.vcbid());
	req.set_vcbname(room_info.cname());
	req.set_tocbname(room_info.cname());
	SEND_MESSAGE_EX(protocol::Sub_Vchat_ChatReq, req, req.textlen());
}

void RoomConnection::SendMsg_RoomConnMediaReq(TransMediaInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TransMediaReq, req);
}

void RoomConnection::SendMsg_RoomConnMediaResp(TransMediaInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TransMediaResp, req);
}

void RoomConnection::SendMsg_RoomConnMediaErr(TransMediaInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TransMediaErr, req);
}

void RoomConnection::SendMsg_SetRoomOPStatusReq(SetRoomOPStatusReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetRoomOPStatusReq, req);
}

void RoomConnection::SendMsg_SetRoomBaseInfoReq(SetRoomInfoReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetRoomInfoReq, req);
}

void RoomConnection::SendMsg_SetRoomBaseInfoReq_v2(SetRoomInfoReq_v2& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetRoomInfoReq_v2, req);
}

void RoomConnection::SendMsg_SetRoomNoticeReq(SetRoomNoticeReq& req)
{
	SEND_MESSAGE_EX(protocol::Sub_Vchat_SetRoomNoticeReq, req, req.textlen());
}

void RoomConnection::SendMsg_ChangePubMicStateReq(ChangePubMicStateReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_ChangePubMicStateReq, req);
}

void RoomConnection::SendMsg_UpWaitMicReq(uint32 vcbid, uint32 srcuserid, uint32 touserid, int32 insertindex)
{
	UpWaitMic req;
	req.set_vcbid(vcbid);
	req.set_ruunerid(srcuserid);
	req.set_touser(touserid);
	req.set_nmicindex(insertindex);
	SEND_MESSAGE(protocol::Sub_Vchat_UpWaitMicReq, req);
}

void RoomConnection::SendMsg_OperateWaitMicIndxReq(OperateWaitMic& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_ChangeWaitMicIndexReq, req);
}

void RoomConnection::SendMsg_AddUserToBlackListReq(ThrowUserInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_ThrowUserReq, req);
}

void RoomConnection::SendMsg_SetUserPriorityReq(UserPriority& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetUserPriorityReq, req);
}

void RoomConnection::SendMsg_CollectRoomReq(int acitonid)
{
	FavoriteRoomReq req;
	req.set_userid(join_req.userid());
	req.set_vcbid(join_req.vcbid());
	req.set_actionid(acitonid);
	SEND_MESSAGE(protocol::Sub_Vchat_FavoriteVcbReq, req);
}

void RoomConnection::SendMsg_ChangeUserAliasStateReq(UserAliasState& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetUserAliasReq, req);
}

void RoomConnection::SendMsg_QueryUserAccountInfo(int userid, int vcbid)
{
	QueryUserAccountReq req;
	req.set_userid(userid);
	req.set_vcbid(vcbid);
	SEND_MESSAGE(protocol::Sub_Vchat_QueryUserAccountReq, req);
}

void RoomConnection::SendMsg_MoneyAndPointOpReq(MoneyAndPointOp& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_MoneyAndPointOpReq, req);
}

void RoomConnection::SendMsg_SetRoomMediaReq(RoomMediaInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetRoomMediaReq, req);
}

void RoomConnection::SendMsg_SetRoomWaitMicMaxNumLimit(SetRoomWaitMicMaxNumLimit req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetWatMicMaxNumLimitReq, req);
}

void RoomConnection::SendMsg_SendSealReq(SendUserSeal& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SendUserSealReq, req);
}

void RoomConnection::SendMsg_SeeUserIpReq(SeeUserIpReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SeeUserIpReq, req);
}

void RoomConnection::SendMsg_SetForbidInviteUpMicReq(SetForbidInviteUpMic& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetForbidInviteUpMicReq, req);
}

void RoomConnection::SendMsg_OpenChestReq(OpenChestReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_OpenChestReq, req);
}

void RoomConnection::SendMsg_MgrRelieveBlackDB(RelieveUserInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_MgrRelieveBlackDBReq, req);
}

void RoomConnection::SendMsg_MgrRefreshList(MgrRefreshList& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_MgrRefreshListReq, req);
}

void RoomConnection::SendMsg_ForbidUserChat(ForbidUserChat& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_ForbidUserChatReq, req);
}

void RoomConnection::SendMsg_SetDevStateReq(UserDevState& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetDevStateReq, req);
}

void RoomConnection::SendMsg_SetUserHideStateReq(SetUserHideStateReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetUserHideStateReq, req);
}

void RoomConnection::SendMsg_ReportMediaGate(int RoomId, int UserId, char* mediasvr, uint16 mediaport)
{
	ReportMediaGateReq req;
	req.set_vcbid(RoomId);
	req.set_userid(UserId);

	char content[128];
	sprintf(content, "%s:%d|%s:%hu", connect_ip, connect_port, mediasvr, mediaport);
	req.set_content(content);
	req.set_textlen(strlen(content));

	SEND_MESSAGE(protocol::Sub_Vchat_ReportMediaGateReq, req);
}

void RoomConnection::SendMsg_TeacherScoreReq(TeacherScoreReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TeacherScoreReq, req);
}

void RoomConnection::SendMsg_UserScoreReq(TeacherScoreRecordReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TeacherScoreRecordReq, req);
}

void RoomConnection::SendMsg_TeacherGiftReq(TeacherGiftListReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TeacherGiftListReq, req);
}

void RoomConnection::SendMsg_TeacherSubscriptionStateQueryReq(TeacherSubscriptionStateQueryReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_RoomTeacherSubscriptionStateQueryReq, req);
}

void RoomConnection::SendMsg_TeacherSubscriptionReq(TeacherSubscriptionReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_RoomTeacherSubscriptionReq, req);
}

void RoomConnection::SendMsg_GetUserInfoReq(TextRoomList_mobile& head,GetUserInfoReq& req)
{
	SEND_MESSAGELIST(protocol::Sub_Vchat_GetUserInfoReq, head, req);
}

void RoomConnection::close(void)
{
	SendMsg_ExitRoomReq();
	Connection::close();
}

void RoomConnection::on_dispatch_message(void* msg)
{
	if ( room_listener != NULL )
	{
		room_listener->OnMessageComming(msg);
	}
}

void RoomConnection::DispatchSocketMessage(void* msg)
{

	static std::vector<RoomUserInfo> g_vec_RoomUserInfo;
	static std::vector<int> g_vec_WaitiMicListInfo;
	static std::vector<TeacherGiftListResp> g_vec_TeacherGiftListResp;
	static std::vector<UserScoreNoty> g_vec_UserScoreNoty;

	std::vector<RoomPubMicState> g_vec_RoomPubMicStateNoty;

	protocol::COM_MSG_HEADER* head = (protocol::COM_MSG_HEADER*)msg;
	uint8* body = (uint8*)(head->content);

	int sub_cmd = head->subcmd;
	int body_len = head->length - sizeof(protocol::COM_MSG_HEADER);

	LOG("on message:%d", sub_cmd);

	switch ( sub_cmd ) {
		case protocol::Sub_Vchat_JoinRoomResp:
			if ( room_listener != NULL )
			{
				room_info.ParseFromArray(body, room_info.ByteSize());
				room_listener->OnJoinRoomResp(room_info);
			}
			break;
		case protocol::Sub_Vchat_JoinRoomErr:
			ON_MESSAGE(room_listener,JoinRoomErr, OnJoinRoomErr);
			break;

		case protocol::Sub_Vchat_RoomUserListBegin:
			g_vec_RoomUserInfo.clear();
			break;
		case protocol::Sub_Vchat_RoomUserListResp:
			{
				int ncount = *(int *)body;
				body += sizeof(int);
				for (int i = 0; i < ncount; i++)
				{
					RoomUserInfo objRoomUserInfo;
					objRoomUserInfo.ParseFromArray(body, objRoomUserInfo.ByteSize());
					g_vec_RoomUserInfo.push_back(objRoomUserInfo);
					body += objRoomUserInfo.ByteSize();
				}
			}
			break;
		case protocol::Sub_Vchat_RoomUserListFinished:
			room_listener->OnRoomUserList(g_vec_RoomUserInfo);
			break;

		case protocol::Sub_Vchat_RoomUserNoty:
			ON_MESSAGE(room_listener,RoomUserInfo, OnRoomUserNoty);
			break;

		case protocol::Sub_Vchat_RoomPubMicState:
			{
				int ncount = *(int *)body;
				body += sizeof(int);
				for (int i = 0; i < ncount; i++)
				{
					RoomPubMicState objRoomPubMicState;
					objRoomPubMicState.ParseFromArray(body, objRoomPubMicState.ByteSize());
					g_vec_RoomPubMicStateNoty.push_back(objRoomPubMicState);
					body += objRoomPubMicState.ByteSize();
				}
			}

			room_listener->OnRoomPubMicStateNoty(g_vec_RoomPubMicStateNoty);
			//ON_MESSAGE(room_listener,RoomPubMicState, OnRoomPubMicStateNoty);
			break;

		case protocol::Sub_Vchat_RoomUserExitResp:
			//ON_MESSAGE();
			break;
		case protocol::Sub_Vchat_RoomUserExitNoty:
			ON_MESSAGE(room_listener,UserExceptExitRoomInfo_ext, OnRoomUserExceptExitNoty);
			break;
		case protocol::Sub_Vchat_RoomUserExceptExitNoty://异常退出
			ON_MESSAGE(room_listener,UserExceptExitRoomInfo_ext, OnRoomUserExceptExitNoty);
			break;

		case protocol::Sub_Vchat_RoomKickoutUserResp:
			//ON_MESSAGE();
			break;
		case protocol::Sub_Vchat_RoomKickoutUserNoty:
			ON_MESSAGE(room_listener,UserKickoutRoomInfo_ext, OnRoomKickoutUserNoty);
			break;
		case protocol::Sub_Vchat_FlyGiftListInfo:
			//无操作

		case protocol::Sub_Vchat_WaitiMicListInfo:
			{
				int action_num;
				action_num = body_len / sizeof(uint32);

				g_vec_WaitiMicListInfo.clear();
				for (int i = 0; i < action_num; i++)
				{
					uint32* pInfo = (uint32*)body;
					g_vec_WaitiMicListInfo.push_back( (*pInfo) );
					body += sizeof(uint32);
				}
				room_listener->OnWaitiMicListInfo(g_vec_WaitiMicListInfo);
			}
			break;

		case protocol::Sub_Vchat_ChatErr:
			//暂无操作
			break;
		case protocol::Sub_Vchat_ChatNotify:
			ON_MESSAGE(room_listener, RoomChatMsg, OnChatNotify);
			break;

		case protocol::Sub_Vchat_TradeGiftResp:
			ON_MESSAGE(room_listener, TradeGiftRecord, OnTradeGiftRecordResp);
			break;
		case protocol::Sub_Vchat_TradeGiftErr:
			ON_MESSAGE(room_listener, TradeGiftErr, OnTradeGiftErr);
			break;
		case protocol::Sub_Vchat_TradeGiftNotify:
			ON_MESSAGE(room_listener, TradeGiftRecord, OnTradeGiftNotify);
			break;

		case protocol::Sub_Vchat_TradeFlowerResp:
			ON_MESSAGE(room_listener, TradeFlowerRecord, OnTradeFlowerResp);
			break;
		case protocol::Sub_Vchat_TradeFlowerErr:
			ON_MESSAGE(room_listener, TradeFlowerRecord, OnTradeFlowerErr);
			break;
		case protocol::Sub_Vchat_TradeFlowerNotify:
			ON_MESSAGE(room_listener, TradeFlowerRecord, OnTradeFlowerNotify);
			break;

		case protocol::Sub_Vchat_TradeFireworksResp:
			ON_MESSAGE(room_listener, TradeFlowerRecord, OnTradeFlowerNotify);
			break;
		case protocol::Sub_Vchat_TradeFireworksNotify:
			ON_MESSAGE(room_listener, TradeFireworksNotify, OnTradeFireworksNotify);
			break;
		case protocol::Sub_Vchat_TradeFireworksErr:
			ON_MESSAGE(room_listener, TradeFireworksErr, OnTradeFireworksErr);
			break;

		case protocol::Sub_Vchat_LotteryGiftNotify:
			ON_MESSAGE(room_listener, LotteryGiftNotice, OnLotteryGiftNotify);
			break;

		case protocol::Sub_Vchat_BoomGiftNotify:
			ON_MESSAGE(room_listener, BoomGiftNotice, OnBoomGiftNotify);
			break;

		case protocol::Sub_Vchat_SysNoticeInfo:
			ON_MESSAGE(room_listener, SysCastNotice, OnSysNoticeInfo);
			break;

		case protocol::Sub_Vchat_UserAccountInfo:
			ON_MESSAGE(room_listener, UserAccountInfo, OnUserAccountInfo);
			break;

		case protocol::Sub_Vchat_RoomManagerNotify:
			//暂无操作
			break;
		case protocol::Sub_Vchat_RoomMediaNotify:
			ON_MESSAGE(room_listener, RoomMediaInfo, OnRoomMediaInfo);
			break;
		case protocol::Sub_Vchat_RoomNoticeNotify:
			ON_MESSAGE(room_listener, RoomNotice, OnRoomNoticeNotify);
			break;

		case protocol::Sub_Vchat_RoomOPStatusNotify:
			ON_MESSAGE(room_listener, RoomOpState, OnRoomOpState);
			break;

		case protocol::Sub_Vchat_RoomInfoNotify:
			ON_MESSAGE(room_listener, RoomBaseInfo, OnRoomInfoNotify);
			break;

		case protocol::Sub_Vchat_ThrowUserNotify:
			ON_MESSAGE(room_listener, ThrowUserInfo, OnThrowUserNotify);
			break;

		case protocol::Sub_Vchat_UpWaitMicResp:
			ON_MESSAGE(room_listener, UpWaitMic, OnUpWaitMicResp);
			break;
		case protocol::Sub_Vchat_UpWaitMicErr:
			ON_MESSAGE(room_listener, UpWaitMic, OnUpWaitMicErr);
			break;

		case protocol::Sub_Vchat_ChangePubMicStateNotify:
			ON_MESSAGE(room_listener, ChangePubMicStateNoty, OnChangePubMicStateNotify);
			break;

		case protocol::Sub_Vchat_TransMediaReq:
			//暂无操作
			break;
		case protocol::Sub_Vchat_TransMediaResp:
			//暂无操作
			break;
		case protocol::Sub_Vchat_TransMediaErr:
			//暂无操作
			break;

		case protocol::Sub_Vchat_SetMicStateResp:
			//暂无操作
			break;
		case protocol::Sub_Vchat_SetMicStateErr:
			ON_MESSAGE(room_listener, UserMicState, OnSetMicStateErr);
			break;
		case protocol::Sub_Vchat_SetMicStateNotify:
			ON_MESSAGE(room_listener, UserMicState, OnSetMicStateNotify);
			break;

		case protocol::Sub_Vchat_SetDevStateResp:
			ON_MESSAGE(room_listener, UserDevState, OnSetDevStateResp);
			break;
		case protocol::Sub_Vchat_SetDevStateErr:
			ON_MESSAGE(room_listener, UserDevState, OnSetDevStateErr);
			break;
		case protocol::Sub_Vchat_SetDevStateNotify:
			ON_MESSAGE(room_listener, UserDevState, OnSetDevStateNotify);
			break;

		case protocol::Sub_Vchat_SetUserAliasResp:
			ON_MESSAGE(room_listener, UserAliasState, OnSetUserAliasResp);
			break;
		case protocol::Sub_Vchat_SetUserAliasErr:
			ON_MESSAGE(room_listener, UserAliasState, OnSetUserAliasErr);
			break;
		case protocol::Sub_Vchat_SetUserAliasNotify:
			ON_MESSAGE(room_listener, UserAliasState, OnSetUserAliasNotify);
			break;

		case protocol::Sub_Vchat_SetUserPriorityResp:
			ON_MESSAGE(room_listener, SetUserPriorityResp, OnSetUserPriorityResp);
			break;
		case protocol::Sub_Vchat_SetUserPriorityNotify:
			ON_MESSAGE(room_listener, SetUserPriorityResp, OnSetUserPriorityNotify);
			break;

		case protocol::Sub_Vchat_SeeUserIpResp:
			ON_MESSAGE(room_listener, SeeUserIpResp, OnSeeUserIpResp);
			break;
		case protocol::Sub_Vchat_SeeUserIpErr:
			ON_MESSAGE(room_listener, SeeUserIpResp, OnSeeUserIpErr);
			break;

		case protocol::Sub_Vchat_ThrowUserResp:
			ON_MESSAGE(room_listener, ThrowUserInfoResp, OnThrowUserResp);
			break;

		//暂时废置
		case protocol::Sub_Vchat_SendUserSealNotify:
			break;
		case protocol::Sub_Vchat_SendUserSealErr:
			break;

		case protocol::Sub_Vchat_ForbidUserChatNotify:
			ON_MESSAGE(room_listener, ForbidUserChat, OnForbidUserChatNotify);
			break;

		case protocol::Sub_Vchat_FavoriteVcbResp:
			//暂无操作
			break;

		case protocol::Sub_Vchat_SetRoomNoticeResp:
			ON_MESSAGE(room_listener, SetRoomNoticeResp, OnSetRoomNoticeResp);
			break;

		case protocol::Sub_Vchat_SetRoomInfoResp:
			ON_MESSAGE(room_listener, SetRoomInfoResp, OnSetRoomInfoResp);
			break;

		case protocol::Sub_Vchat_SetRoomOPStatusResp:
			ON_MESSAGE(room_listener, SetRoomOPStatusResp, OnSetRoomOPStatusResp);
			break;

		case protocol::Sub_Vchat_QueryUserAccountResp:
			ON_MESSAGE(room_listener, QueryUserAccountResp, OnQueryUserAccountResp);
			break;

		//暂时废置
		case protocol::Sub_Vchat_MoneyAndPointOpResp:
			break;
		case protocol::Sub_Vchat_MoneyAndPointOpErr:
			break;

		case protocol::Sub_Vchat_SetWatMicMaxNumLimitNotify:
			ON_MESSAGE(room_listener, SetRoomWaitMicMaxNumLimit, OnSetWatMicMaxNumLimitNotify);
			break;


		case protocol::Sub_Vchat_ChangeWaitMicIndexResp:
			ON_MESSAGE(room_listener, ChangeWaitMicIndexResp, OnChangeWaitMicIndexResp);
			break;
		case protocol::Sub_Vchat_ChangeWaitMicIndexNotify:
			//暂无操作
			break;

		case protocol::Sub_Vchat_SetForbidInviteUpMicNotify:
			ON_MESSAGE(room_listener, SetForbidInviteUpMic, OnSetForbidInviteUpMicNotify);
			break;

		case protocol::Sub_Vchat_SiegeInfoNotify:
			ON_MESSAGE(room_listener, SiegeInfo, OnSiegeInfoNotify);
			break;

		case protocol::Sub_Vchat_OpenChestResp:
			ON_MESSAGE(room_listener, OpenChestResp, OnOpenChestResp);
			break;

		case protocol::Sub_Vchat_UserCaifuCostLevelNotify:
			//暂无操作
			break;

		case protocol::Sub_Vchat_ClientPingResp:
			ON_MESSAGE(room_listener, ClientPingResp, OnClientPingResp);
			break;
		case protocol::Sub_Vchat_CloseRoomNotify:
			ON_MESSAGE(room_listener, CloseRoomNoty, OnCloseRoomNotify);
			break;

		case protocol::Sub_Vchat_DoNotReachRoomServer:
			//暂无操作
			break;

		case protocol::Sub_Vchat_LotteryPoolNotify:
			ON_MESSAGE(room_listener, LotteryPoolInfo, OnLotteryPoolNotify);
			break;

		//暂时没有用
		case protocol::Sub_Vchat_SetRoomInfoResp_v2:
			break;
		case protocol::Sub_Vchat_SetRoomInfoNoty_v2:
			break;

		case protocol::Sub_Vchat_SetUserHideStateResp:
			ON_MESSAGE(room_listener, SetUserHideStateResp, OnSetUserHideStateResp);
			break;
		case protocol::Sub_Vchat_SetUserHideStateNoty:
			ON_MESSAGE(room_listener, SetUserHideStateNoty, OnSetUserHideStateNoty);
			break;

		case protocol::Sub_Vchat_UserAddChestNumNoty:
			ON_MESSAGE(room_listener, UserAddChestNumNoty, OnUserAddChestNumNoty);
			break;

		case protocol::Sub_Vchat_AddClosedFriendNoty:
			ON_MESSAGE(room_listener, AddClosedFriendNotify, OnAddClosedFriendNoty);
			break;

		case protocol::Sub_Vchat_AdKeyWordOperateNoty:
			ON_MESSAGE(room_listener, AdKeywordsNotify, OnAdKeyWordOperateNoty);
			break;

		case protocol::Sub_Vchat_AdKeyWordOperateResp:
			ON_MESSAGE(room_listener, AdKeywordsResp, OnAdKeyWordOperateResp);
			break;

		case protocol::Sub_Vchat_TeacherScoreResp:
			ON_MESSAGE(room_listener, TeacherScoreResp, OnTeacherScoreResp);
			break;
		case protocol::Sub_Vchat_TeacherScoreRecordResp:
			ON_MESSAGE(room_listener, TeacherScoreRecordResp, OnTeacherScoreRecordResp);
			break;

		case protocol::Sub_Vchat_RobotTeacherIdNoty:
			ON_MESSAGE(room_listener, RobotTeacherIdNoty, OnRobotTeacherIdNoty);
			break;

		case protocol::Sub_Vchat_TeacherGiftListResp:
			{
				int action_num;
				action_num = *(int*)body;

				g_vec_TeacherGiftListResp.clear();

				body += sizeof(int);
				for (int i = 0; i < action_num; i++)
				{
					TeacherGiftListResp objTeacherGiftListResp;

					objTeacherGiftListResp.ParseFromArray(body, objTeacherGiftListResp.ByteSize());
					g_vec_TeacherGiftListResp.push_back( objTeacherGiftListResp );
					body += objTeacherGiftListResp.ByteSize();
				}

				room_listener->OnTeacherGiftListResp(g_vec_TeacherGiftListResp);
			}
			break;

		//case protocol::Sub_Vchat_HitGoldEgg_ToClient_Noty:
		//	ON_MESSAGE(room_listener, HitGoldEggClientNoty, OnHitGoldEggToClientNoty);
		//	break;
		case protocol::Sub_Vchat_UserScoreNotify:
			ON_MESSAGE(room_listener, UserScoreNoty, OnUserScoreNotify);
			break;
		case protocol::Sub_Vchat_UserScoreListNotify:
			{
				int action_num;
				action_num = *(int*)body;

				g_vec_TeacherGiftListResp.clear();

				body += sizeof(int);
				for (int i = 0; i < action_num; i++)
				{
					UserScoreNoty objUserScoreNoty;

					objUserScoreNoty.ParseFromArray(body, objUserScoreNoty.ByteSize());
					g_vec_UserScoreNoty.push_back( objUserScoreNoty );
					body += objUserScoreNoty.ByteSize();
				}

				room_listener->OnUserScoreListNotify(g_vec_UserScoreNoty);
			}
			break;
		case protocol::Sub_Vchat_TeacherAvarageScore_Noty:
			ON_MESSAGE(room_listener, TeacherAvarageScoreNoty, OnTeacherAvarageScoreNoty);
			break;
		case protocol::Sub_Vchat_RoomAndSubRoomId_Noty:
			ON_MESSAGE(room_listener, RoomAndSubRoomIdNoty, OnRoomAndSubRoomId_Noty);
			break;
		case protocol::Sub_Vchat_SysCast_Resp:
			ON_MESSAGE(room_listener, Syscast, OnSysCastResp);
			break;

		//普通用户个人资料	
		case protocol::Sub_Vchat_GetUserInfoResp:
			ON_MESSAGE(room_listener,RoomUserInfoResp, OnRoomUserInfoResp);
			break;
		//文字讲师个人资料
		case protocol::Sub_Vchat_GetTeacherInfoResp:
			ON_MESSAGE(room_listener,TeacherInfoResp, OnTeacherInfoResp);
			break;
		//获取用户个人资料失败
		case protocol::Sub_Vchat_GetUserInfoErr:
			ON_MESSAGE(room_listener,UserInfoErr, OnUserInfoErr);
			break;	

		//课程订阅返回
		case protocol::Sub_Vchat_RoomTeacherSubscriptionResp:
			ON_MESSAGE(room_listener,TeacherSubscriptionResp, OnTeacherSubscriptionResp);
			break;
		case protocol::Sub_Vchat_RoomTeacherSubscriptionStateQueryResp:
			ON_MESSAGE(room_listener,TeacherSubscriptionStateQueryResp, OnTeacherSubscriptionStateQueryResp);
			break;

			//ON_MESSAGE();
		
		default:
			LOG("+++++++unimplenment message+++++++:%d", sub_cmd );
			break;
	}
}

RoomConnection::~RoomConnection(void)
{
}

