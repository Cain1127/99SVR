/**
 * 1. SendMsg_ReportMediaGate 需要加入房间网关Ip:port
 */

#include "stdafx.h"
#include "crc32.h"
#include "platform.h"
#include "Http.h"
#include "VideoRoomConnection.h"
#include "Thread.h"
#include "videoroom_cmd_vchat.h"
#include "Util.h"

#include <vector>




VideoRoomConnection::VideoRoomConnection(void) :
room_join_listener(NULL), room_listener(NULL)
{
	main_cmd = protocol::MDM_Vchat_Room;
	room_info.set_vcbid(0);
	joinRoomSucFlag=0;
}


void VideoRoomConnection::RegisterRoomListener(VideoRoomListener* room_listener)
{
	this->room_listener = room_listener;
}

void VideoRoomConnection::RegisterRoomJoinListener(VideoRoomJoinListener* room_join_listener)
{
	this->room_join_listener = room_join_listener;
}

void VideoRoomConnection::SendMsg_Ping()
{
	protocol::CMDClientPing_t ping;
	ping.userid = join_req.userid();
	ping.roomid = join_req.vcbid();

	SEND_MESSAGE2(protocol::Sub_Vchat_ClientPing, protocol::CMDClientPing_t, &ping);
}

void VideoRoomConnection::on_do_connected()
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

	LOG("SEND JOIN ROOM");
	SEND_MESSAGE(protocol::Sub_Vchat_JoinRoomReq, join_req);

}

void VideoRoomConnection::SendMsg_RreJoinRoomReq(PreJoinRoomReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_PreJoinRoomReq, req);
}

/*
void VideoRoomConnection::SendMsg_JoinRoomReq(JoinRoomReq& req)
{
	joinRoomSucFlag=0;
	main_room_id = 0;
	join_req = req;
	on_do_connected();
}*/

void VideoRoomConnection::SendMsg_AfterJoinRoomReq()
{
	AfterJoinRoomReq req;
	req.set_userid(join_req.userid());
	req.set_vcbid(join_req.vcbid());

	SEND_MESSAGE(protocol::Sub_Vchat_AfterJoinRoomReq, req);
	joinRoomSucFlag=1;

	SendMsg_TeamTopNReq();
}

void VideoRoomConnection::SendMsg_ExitRoomReq(uint32 roomid)
{
	room_info.set_vcbid(0);
	in_room = false;
	need_join_room = false;
	joinRoomSucFlag=0;

	UserExitRoomInfo req;
	req.set_userid(join_req.userid());
	req.set_vcbid(roomid);

	SEND_MESSAGE(protocol::Sub_Vchat_RoomUserExitReq, req);
}

void VideoRoomConnection::SendMsg_ModifyAdKeywordsReq(AdKeywordsReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_AdKeyWordOperateReq, req);
}

void VideoRoomConnection::SendMsg_KickoutUserReq(UserKickoutRoomInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_RoomKickoutUserReq, req);
}

void VideoRoomConnection::SendMsg_SetMicStateReq(UserMicState& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetMicStateReq, req);
}

void VideoRoomConnection::SendMsg_TradeGiftReq(TradeGiftRecord& req)
{
	req.set_srcid(loginuser.userid());
	req.set_srcalias(loginuser.cuseralias());
	req.set_vcbid(join_req.vcbid());
	req.set_srcvcbname(room_info.cname());
	req.set_tovcbid(join_req.vcbid());
	req.set_tovcbname(room_info.cname());
	req.set_action(2);

	SEND_MESSAGE(protocol::Sub_Vchat_TradeGiftReq, req);
}

void VideoRoomConnection::SendMsg_RoomChatReq(RoomChatMsg& req)
{
#ifndef WIN
	req.set_msgtype(0);
#endif
	req.set_srcid(loginuser.userid());
	req.set_srcalias(loginuser.cuseralias());
	req.set_srcviplevel(loginuser.viplevel());
	req.set_vcbid(join_req.vcbid());
	req.set_tocbid(join_req.vcbid());
	req.set_vcbname(room_info.cname());
	req.set_tocbname(room_info.cname());
	req.set_textlen(req.content().size());
	SEND_MESSAGE_EX(protocol::Sub_Vchat_ChatReq, req, req.textlen());
}

void VideoRoomConnection::SendMsg_SetRoomOPStatusReq(SetRoomOPStatusReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetRoomOPStatusReq, req);
}

void VideoRoomConnection::SendMsg_SetRoomBaseInfoReq(SetRoomInfoReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetRoomInfoReq, req);
}

void VideoRoomConnection::SendMsg_SetRoomBaseInfoReq_v2(SetRoomInfoReq_v2& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetRoomInfoReq_v2, req);
}

void VideoRoomConnection::SendMsg_SetRoomNoticeReq(SetRoomNoticeReq& req)
{
	req.set_textlen(req.content().size());
	SEND_MESSAGE_EX(protocol::Sub_Vchat_SetRoomNoticeReq, req, req.textlen());
}

void VideoRoomConnection::SendMsg_UpWaitMicReq(uint32 vcbid, uint32 srcuserid, uint32 touserid, int32 insertindex)
{
	UpWaitMic req;
	req.set_vcbid(vcbid);
	req.set_ruunerid(srcuserid);
	req.set_touser(touserid);
	req.set_nmicindex(insertindex);
	SEND_MESSAGE(protocol::Sub_Vchat_UpWaitMicReq, req);
}

void VideoRoomConnection::SendMsg_AddUserToBlackListReq(ThrowUserInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_ThrowUserReq, req);
}

void VideoRoomConnection::SendMsg_SetUserPriorityReq(UserPriority& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetUserPriorityReq, req);
}

void VideoRoomConnection::SendMsg_CollectRoomReq(int acitonid)
{
	FavoriteRoomReq req;
	req.set_userid(join_req.userid());
	req.set_vcbid(join_req.vcbid());
	req.set_actionid(acitonid);
	SEND_MESSAGE(protocol::Sub_Vchat_FavoriteVcbReq, req);
}

void VideoRoomConnection::SendMsg_QueryUserAccountInfo(int userid, int vcbid)
{
	QueryUserAccountReq req;
	req.set_userid(userid);
	req.set_vcbid(vcbid);
	SEND_MESSAGE(protocol::Sub_Vchat_QueryUserAccountReq, req);
}

void VideoRoomConnection::SendMsg_SetRoomMediaReq(RoomMediaInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetRoomMediaReq, req);
}

void VideoRoomConnection::SendMsg_SeeUserIpReq(SeeUserIpReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SeeUserIpReq, req);
}

void VideoRoomConnection::SendMsg_ForbidUserChat(ForbidUserChat& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_ForbidUserChatReq, req);
}

void VideoRoomConnection::SendMsg_SetDevStateReq(UserDevState& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetDevStateReq, req);
}

void VideoRoomConnection::SendMsg_ReportMediaGate(int RoomId, int UserId, char* mediasvr, uint16 mediaport)
{
	ReportMediaGateReq req;
	req.set_vcbid(RoomId);
	req.set_userid(UserId);

	char content[128];
	sprintf(content, "%s:%d|%s:%hu", connect_ip, connect_port, mediasvr, mediaport);
	req.set_content(content);
	req.set_textlen(strlen(content));

	SEND_MESSAGE_EX(protocol::Sub_Vchat_ReportMediaGateReq, req, req.textlen());
}

void VideoRoomConnection::SendMsg_TeacherScoreReq(TeacherScoreReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TeacherScoreReq, req);
}

void VideoRoomConnection::SendMsg_UserScoreReq(TeacherScoreRecordReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TeacherScoreRecordReq, req);
}

void VideoRoomConnection::SendMsg_TeacherGiftReq(TeacherGiftListReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TeacherGiftListReq, req);
}

void VideoRoomConnection::SendMsg_TeacherSubscriptionStateQueryReq(TeacherSubscriptionStateQueryReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_RoomTeacherSubscriptionStateQueryReq, req);
}

void VideoRoomConnection::SendMsg_TeacherSubscriptionReq(TeacherSubscriptionReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_RoomTeacherSubscriptionReq, req);
}

void VideoRoomConnection::SendMsg_GetUserInfoReq(TextRoomList_mobile& head,GetUserInfoReq& req)
{
	SEND_MESSAGELIST(protocol::Sub_Vchat_GetUserInfoReq, head, req);
}

void VideoRoomConnection::SendMsg_TeamTopNReq()
{
	TeamTopNReq req;
	req.set_userid(login_userid);
	req.set_vcbid(room_info.vcbid());
	SEND_MESSAGE_F(protocol::MDM_Vchat_Room, protocol::Sub_Vchat_TeamTopNReq, req);
}

void VideoRoomConnection::SendMsg_AskQuestionReq(AskQuestionReq& req)
{
	req.set_userid(join_req.userid());
	req.set_roomid(join_req.vcbid());
	req.set_questionlen(req.question().size());
	SEND_MESSAGE_EX(protocol::Sub_Vchat_AskQuestionReq, req, req.questionlen());
}

void VideoRoomConnection::close(void)
{
	SendMsg_ExitRoomReq(join_req.vcbid());
}

void VideoRoomConnection::DispatchSocketMessage(void* msg)
{

	static std::vector<RoomUserInfo> g_vec_RoomUserInfo;
	static std::vector<int> g_vec_WaitiMicListInfo;
	static std::vector<TeacherGiftListResp> g_vec_TeacherGiftListResp;
	static std::vector<UserScoreNoty> g_vec_UserScoreNoty;

	static std::vector<RoomPubMicState> g_vec_RoomPubMicStateNoty;
	static std::vector<TeamTopNResp> g_vec_teamtop;

	protocol::COM_MSG_HEADER* head = (protocol::COM_MSG_HEADER*)msg;
	uint8* body = (uint8*)(head->content);

	int sub_cmd = head->subcmd;
	int body_len = head->length - sizeof(protocol::COM_MSG_HEADER);

	if(joinRoomSucFlag!=1 && sub_cmd!=protocol::Sub_Vchat_PreJoinRoomResp && sub_cmd!=protocol::Sub_Vchat_JoinRoomResp && sub_cmd!=protocol::Sub_Vchat_JoinRoomErr)
		return;
	LOG("on video message:%d", sub_cmd);

	switch ( sub_cmd ) {
		//加入房间预处理响应
		case protocol::Sub_Vchat_PreJoinRoomResp:
			if ( room_join_listener != NULL )
			{
				ON_MESSAGE(room_join_listener,PreJoinRoomResp, OnPreJoinRoomResp);
			}
			break;		
		//加入房间成功
		case protocol::Sub_Vchat_JoinRoomResp:
			if ( room_join_listener != NULL )
			{
				room_info.ParseFromArray(body, room_info.ByteSize());
				room_join_listener->OnJoinRoomResp(room_info);
			}
			in_room = true;
			break;
		//加入房间失败
		case protocol::Sub_Vchat_JoinRoomErr:
			ON_MESSAGE(room_join_listener,JoinRoomErr, OnJoinRoomErr);
			break;

		//房间用户列表数据开始
		case protocol::Sub_Vchat_RoomUserListBegin:
			g_vec_RoomUserInfo.clear();
			break;
		//房间用户列表数据
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
		//房间用户列表数据结束
		case protocol::Sub_Vchat_RoomUserListFinished:
			if ( room_listener != NULL )
				room_listener->OnRoomUserList(g_vec_RoomUserInfo);
			break;

		//新增用户通知
		case protocol::Sub_Vchat_RoomUserNoty:
			ON_MESSAGE(room_listener,RoomUserInfo, OnRoomUserNoty);
			break;

		//公麦状态数据
		case protocol::Sub_Vchat_RoomPubMicState:
			{
				g_vec_RoomPubMicStateNoty.clear();
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

			if ( room_listener != NULL )
			room_listener->OnRoomPubMicStateNoty(g_vec_RoomPubMicStateNoty);
			break;

		//房间用户退出响应
		case protocol::Sub_Vchat_RoomUserExitResp:
			//无操作
			break;
		//房间用户退出通知
		case protocol::Sub_Vchat_RoomUserExitNoty:
			ON_MESSAGE(room_listener,UserExceptExitRoomInfo_ext, OnRoomUserExceptExitNoty);
			break;
		//房间用户异常退出通知
		case protocol::Sub_Vchat_RoomUserExceptExitNoty:
			ON_MESSAGE(room_listener,UserExceptExitRoomInfo_ext, OnRoomUserExceptExitNoty);
			break;

		//房间用户踢出响应
		case protocol::Sub_Vchat_RoomKickoutUserResp:
			//无操作
			break;
		//房间用户踢出通知
		case protocol::Sub_Vchat_RoomKickoutUserNoty:
			ON_MESSAGE(room_listener,UserKickoutRoomInfo_ext, OnRoomKickoutUserNoty);
			break;

		//排麦列表（弃用）
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

				if ( room_listener != NULL )
					room_listener->OnWaitiMicListInfo(g_vec_WaitiMicListInfo);
			}
			break;

		//聊天发送失败响应
		case protocol::Sub_Vchat_ChatErr:
			//暂无操作
			break;
		//聊天通知数据
		case protocol::Sub_Vchat_ChatNotify:
			ON_MESSAGE(room_listener, RoomChatMsg, OnChatNotify);
			break;

		//赠送礼物成功响应
		case protocol::Sub_Vchat_TradeGiftResp:
			ON_MESSAGE(room_listener, TradeGiftRecord, OnTradeGiftRecordResp);
			break;
		//赠送礼物失败响应
		case protocol::Sub_Vchat_TradeGiftErr:
			ON_MESSAGE(room_listener, TradeGiftErr, OnTradeGiftErr);
			break;
		//赠送礼物通知
		case protocol::Sub_Vchat_TradeGiftNotify:
			ON_MESSAGE(room_listener, TradeGiftRecord, OnTradeGiftNotify);
			break;

		//系统消息通知数据
		case protocol::Sub_Vchat_SysNoticeInfo:
			ON_MESSAGE(room_listener, SysCastNotice, OnSysNoticeInfo);
			break;

		//用户帐户数据
		case protocol::Sub_Vchat_UserAccountInfo:
			ON_MESSAGE(room_listener, UserAccountInfo, OnUserAccountInfo);
			break;

		//房间管理通知数据
		case protocol::Sub_Vchat_RoomManagerNotify:
			//暂无操作
			break;

		//房间媒体数据通知
		case protocol::Sub_Vchat_RoomMediaNotify:
			ON_MESSAGE(room_listener, RoomMediaInfo, OnRoomMediaInfo);
			break;

		//房间公告数据通知
		case protocol::Sub_Vchat_RoomNoticeNotify:
			ON_MESSAGE(room_listener, RoomNotice, OnRoomNoticeNotify);
			break;

		//房间状态数据通知
		case protocol::Sub_Vchat_RoomOPStatusNotify:
			ON_MESSAGE(room_listener, RoomOpState, OnRoomOpState);
			break;

		//房间信息数据通知
		case protocol::Sub_Vchat_RoomInfoNotify:
			ON_MESSAGE(room_listener, RoomBaseInfo, OnRoomInfoNotify);
			break;

		//房间封杀用户通知
		case protocol::Sub_Vchat_ThrowUserNotify:
			ON_MESSAGE(room_listener, ThrowUserInfo, OnThrowUserNotify);
			break;

		//上排麦响应
		case protocol::Sub_Vchat_UpWaitMicResp:
			ON_MESSAGE(room_listener, UpWaitMic, OnUpWaitMicResp);
			break;
		//上排麦错误
		case protocol::Sub_Vchat_UpWaitMicErr:
			ON_MESSAGE(room_listener, UpWaitMic, OnUpWaitMicErr);
			break;

		//设置麦状态响应
		case protocol::Sub_Vchat_SetMicStateResp:
			//暂无操作
			break;
		//设置麦状态错误
		case protocol::Sub_Vchat_SetMicStateErr:
			ON_MESSAGE(room_listener, UserMicState, OnSetMicStateErr);
			break;
		//设置麦状态通知
		case protocol::Sub_Vchat_SetMicStateNotify:
			ON_MESSAGE(room_listener, UserMicState, OnSetMicStateNotify);
			break;

		//设置设备状态响应
		case protocol::Sub_Vchat_SetDevStateResp:
			ON_MESSAGE(room_listener, UserDevState, OnSetDevStateResp);
			break;
		//设置设备状态错误
		case protocol::Sub_Vchat_SetDevStateErr:
			ON_MESSAGE(room_listener, UserDevState, OnSetDevStateErr);
			break;
		//设置设备状态通知
		case protocol::Sub_Vchat_SetDevStateNotify:
			ON_MESSAGE(room_listener, UserDevState, OnSetDevStateNotify);
			break;

		//设置用户权限(管理)响应
		case protocol::Sub_Vchat_SetUserPriorityResp:
			ON_MESSAGE(room_listener, SetUserPriorityResp, OnSetUserPriorityResp);
			break;
		//设置用户权限(管理)通知
		case protocol::Sub_Vchat_SetUserPriorityNotify:
			ON_MESSAGE(room_listener, UserPriority, OnSetUserPriorityNotify);
			break;

		//查看用户IP响应
		case protocol::Sub_Vchat_SeeUserIpResp:
			ON_MESSAGE(room_listener, SeeUserIpResp, OnSeeUserIpResp);
			break;
		//查看用户IP错误
		case protocol::Sub_Vchat_SeeUserIpErr:
			ON_MESSAGE(room_listener, SeeUserIpResp, OnSeeUserIpErr);
			break;

		//封杀房间用户响应
		case protocol::Sub_Vchat_ThrowUserResp:
			ON_MESSAGE(room_listener, ThrowUserInfoResp, OnThrowUserResp);
			break;

		//禁言通知
		case protocol::Sub_Vchat_ForbidUserChatNotify:
			ON_MESSAGE(room_listener, ForbidUserChat, OnForbidUserChatNotify);
			break;

		//收藏房间响应
		case protocol::Sub_Vchat_FavoriteVcbResp:
			ON_MESSAGE(room_listener, FavoriteRoomResp, OnFavoriteVcbResp);
			break;

		//设置房间公告响应
		case protocol::Sub_Vchat_SetRoomNoticeResp:
			ON_MESSAGE(room_listener, SetRoomNoticeResp, OnSetRoomNoticeResp);
			break;

		//设置房间信息响应
		case protocol::Sub_Vchat_SetRoomInfoResp:
			ON_MESSAGE(room_listener, SetRoomInfoResp, OnSetRoomInfoResp);
			break;

		//设置房间状态信息响应
		case protocol::Sub_Vchat_SetRoomOPStatusResp:
			ON_MESSAGE(room_listener, SetRoomOPStatusResp, OnSetRoomOPStatusResp);
			break;

		//查询用户帐户响应
		case protocol::Sub_Vchat_QueryUserAccountResp:
			ON_MESSAGE(room_listener, QueryUserAccountResp, OnQueryUserAccountResp);
			break;

		//收到服务器ping消息的返回,表示房间活着
		case protocol::Sub_Vchat_ClientPingResp:
			ON_MESSAGE(room_listener, ClientPingResp, OnClientPingResp);
			break;

		//房间被关闭消息,直接退出当前房间
		case protocol::Sub_Vchat_CloseRoomNotify:
			ON_MESSAGE(room_listener, CloseRoomNoty, OnCloseRoomNotify);
			break;

		//收到房间不可到达消息
		case protocol::Sub_Vchat_DoNotReachRoomServer:
			//暂无操作
			break;

		//设置房间信息飞叉版响应
		case protocol::Sub_Vchat_SetRoomInfoResp_v2:
			ON_MESSAGE(room_listener, SetRoomInfoResp, OnSetRoomInfoResp);
			break;
		//设置房间信息飞叉版通知
		case protocol::Sub_Vchat_SetRoomInfoNoty_v2:
			ON_MESSAGE(room_listener, SetRoomInfoReq_v2, OnSetRoomInfoReq_v2);
			break;

		//收到禁言关键词刷新通知
		case protocol::Sub_Vchat_AdKeyWordOperateNoty:
		{
			vector<AdKeywordInfo> infos;
			int ncount = *(int *)body;
			body += sizeof(int);
			for (int i = 0; i < ncount; i++)
			{
				AdKeywordInfo keywordInfo;
				keywordInfo.ParseFromArray(body, keywordInfo.ByteSize());
				infos.push_back(keywordInfo);
				body += keywordInfo.ByteSize();
			}
			if ( room_listener != NULL )
				room_listener->OnAdKeyWordOperateNoty(infos);
		}
			break;
		//收到禁言关键词更新通知
		case protocol::Sub_Vchat_AdKeyWordOperateResp:
			ON_MESSAGE(room_listener, AdKeywordsResp, OnAdKeyWordOperateResp);
			break;

		//收到讲师评分响应
		case protocol::Sub_Vchat_TeacherScoreResp:
			ON_MESSAGE(room_listener, TeacherScoreResp, OnTeacherScoreResp);
			break;
		//收到用户评分响应
		case protocol::Sub_Vchat_TeacherScoreRecordResp:
			ON_MESSAGE(room_listener, TeacherScoreRecordResp, OnTeacherScoreRecordResp);
			break;

		//上麦机器人对应讲师ID通知
		case protocol::Sub_Vchat_RoborTeacherIdNoty:
			ON_MESSAGE(room_listener, RobotTeacherIdNoty, OnRobotTeacherIdNoty);
			break;

		//讲师忠实度周版响应
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

				if ( room_listener != NULL )
					room_listener->OnTeacherGiftListResp(g_vec_TeacherGiftListResp);
			}
			break;

		//用户对讲师的评分
		case protocol::Sub_Vchat_UserScoreNotify:
			ON_MESSAGE(room_listener, UserScoreNoty, OnUserScoreNotify);
			break;
		//用户对讲师的评分列表
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

				if ( room_listener != NULL )
					room_listener->OnUserScoreListNotify(g_vec_UserScoreNoty);
			}
			break;
		//用户对讲师的平均分
		case protocol::Sub_Vchat_TeacherAvarageScore_Noty:
			ON_MESSAGE(room_listener, TeacherAvarageScoreNoty, OnTeacherAvarageScoreNoty);
			break;

		//主房间和子房间id，目前只有移动端有，PC端没有
		case protocol::Sub_Vchat_RoomAndSubRoomId_Noty:
			//ON_MESSAGE(room_listener, RoomAndSubRoomIdNoty, OnRoomAndSubRoomId_Noty);
			if ( room_listener != NULL )
			{
				RoomAndSubRoomIdNoty info;
				info.ParseFromArray(body, info.ByteSize());
				room_listener->OnRoomAndSubRoomId_Noty(info);
				main_room_id = info.roomid();
			}
			break;

		//房间发送系统公告
		case protocol::Sub_Vchat_SysCast_Resp:
			ON_MESSAGE(room_listener, Syscast, OnSysCastResp);
			break;

		//普通用户个人资料
		case protocol::Sub_Vchat_GetUserInfoResp:
			{
				TextRoomList_mobile headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();

				ON_MESSAGE(room_listener,RoomUserInfoResp, OnRoomUserInfoResp);
			}
			break;
		//文字讲师个人资料
		case protocol::Sub_Vchat_GetTeacherInfoResp:
			{
				TextRoomList_mobile headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();

				ON_MESSAGE(room_listener,TeacherInfoResp, OnTeacherInfoResp);
			}
			break;
		//获取用户个人资料失败
		case protocol::Sub_Vchat_GetUserInfoErr:
			{
				TextRoomList_mobile headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();

				ON_MESSAGE(room_listener,UserInfoErr, OnUserInfoErr);
			}
			break;	

		//课程订阅返回
		case protocol::Sub_Vchat_RoomTeacherSubscriptionResp:
			ON_MESSAGE(room_listener,TeacherSubscriptionResp, OnTeacherSubscriptionResp);
			break;
		case protocol::Sub_Vchat_RoomTeacherSubscriptionStateQueryResp:
			ON_MESSAGE(room_listener,TeacherSubscriptionStateQueryResp, OnTeacherSubscriptionStateQueryResp);
			break;
	
		//砸金蛋更新99币最新值
		case protocol::Sub_Vchat_ClientNotify:
		case protocol::Sub_Vchat_HitGoldEgg_ToClient_Noty:
			LOG("protocol::Sub_Vchat_ClientNotify");
			dispatch_push_message(body);
			break;

		//最强战队周榜回应
		case protocol::Sub_Vchat_TeamTopNResp:
			{
				g_vec_teamtop.clear();
				int ncount = *(int *)body;
				body += sizeof(int);
				for (int i = 0; i < ncount; i++)
				{
					TeamTopNResp info;
					info.ParseFromArray(body, info.ByteSize());
					g_vec_teamtop.push_back(info);
					body += info.ByteSize();
				}
			}
			if ( room_listener != NULL )
				room_listener->OnTeamTopNResp(g_vec_teamtop);
			break;

		//观点赠送礼物通知
		case protocol::Sub_Vchat_ViewpointTradeGiftNoty:
			ON_MESSAGE(room_listener,ViewpointTradeGiftNoty, OnViewpointTradeGiftNoty);
			break;

		//提问响应
		case protocol::Sub_Vchat_AskQuestionResp:
			ON_MESSAGE(room_listener,AskQuestionResp, OnAskQuestionResp);
			break;

		case protocol::Sub_Vchat_Resp_ErrCode:
			LOG("protocol::Sub_Vchat_Resp_ErrCode");
			dispatch_error_message(body);
			break;

		default:
			LOG("+++++++unimplenment message+++++++:%d", sub_cmd );
			break;
	}
}

void VideoRoomConnection::dispatch_error_message(void* body)
{
	protocol::CMDErrCodeResp_t* errorinfo = (protocol::CMDErrCodeResp_t*) body;
	switch (errorinfo->errsubcmd)
	{
	case protocol::Sub_Vchat_AskQuestionReq:
		ON_MESSAGE(room_listener, ErrCodeResp, OnAskQuestionErr)
		break;
	default:
		break;
	}
}

void VideoRoomConnection::dispatch_push_message(void* body)
{
	protocol::tag_CMDPushGateMask* push = (protocol::tag_CMDPushGateMask*) body;
	switch (push->type)
	{
	case 8:
		body = push->content;
		ON_MESSAGE(room_listener, ExpertNewViewNoty, OnExpertNewViewNoty)
		break;
	}
}

string VideoRoomConnection::GetVideoRoomShareUrl()
{
	if ( main_room_id != 0 )
	{
		return string("http://pull.99ducaijing.cn/live/") + int2string(main_room_id) + "/playlist.m3u8";
	}
	else
	{
		return "";
	}
}

VideoRoomConnection::~VideoRoomConnection(void)
{
}

