/**
 * 1. SendMsg_ReportMediaGate ��Ҫ���뷿������Ip:port
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
		//���뷿��Ԥ������Ӧ
		case protocol::Sub_Vchat_PreJoinRoomResp:
			if ( room_join_listener != NULL )
			{
				ON_MESSAGE(room_join_listener,PreJoinRoomResp, OnPreJoinRoomResp);
			}
			break;		
		//���뷿��ɹ�
		case protocol::Sub_Vchat_JoinRoomResp:
			if ( room_join_listener != NULL )
			{
				room_info.ParseFromArray(body, room_info.ByteSize());
				room_join_listener->OnJoinRoomResp(room_info);
			}
			in_room = true;
			break;
		//���뷿��ʧ��
		case protocol::Sub_Vchat_JoinRoomErr:
			ON_MESSAGE(room_join_listener,JoinRoomErr, OnJoinRoomErr);
			break;

		//�����û��б����ݿ�ʼ
		case protocol::Sub_Vchat_RoomUserListBegin:
			g_vec_RoomUserInfo.clear();
			break;
		//�����û��б�����
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
		//�����û��б����ݽ���
		case protocol::Sub_Vchat_RoomUserListFinished:
			if ( room_listener != NULL )
				room_listener->OnRoomUserList(g_vec_RoomUserInfo);
			break;

		//�����û�֪ͨ
		case protocol::Sub_Vchat_RoomUserNoty:
			ON_MESSAGE(room_listener,RoomUserInfo, OnRoomUserNoty);
			break;

		//����״̬����
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

		//�����û��˳���Ӧ
		case protocol::Sub_Vchat_RoomUserExitResp:
			//�޲���
			break;
		//�����û��˳�֪ͨ
		case protocol::Sub_Vchat_RoomUserExitNoty:
			ON_MESSAGE(room_listener,UserExceptExitRoomInfo_ext, OnRoomUserExceptExitNoty);
			break;
		//�����û��쳣�˳�֪ͨ
		case protocol::Sub_Vchat_RoomUserExceptExitNoty:
			ON_MESSAGE(room_listener,UserExceptExitRoomInfo_ext, OnRoomUserExceptExitNoty);
			break;

		//�����û��߳���Ӧ
		case protocol::Sub_Vchat_RoomKickoutUserResp:
			//�޲���
			break;
		//�����û��߳�֪ͨ
		case protocol::Sub_Vchat_RoomKickoutUserNoty:
			ON_MESSAGE(room_listener,UserKickoutRoomInfo_ext, OnRoomKickoutUserNoty);
			break;

		//�����б����ã�
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

		//���췢��ʧ����Ӧ
		case protocol::Sub_Vchat_ChatErr:
			//���޲���
			break;
		//����֪ͨ����
		case protocol::Sub_Vchat_ChatNotify:
			ON_MESSAGE(room_listener, RoomChatMsg, OnChatNotify);
			break;

		//��������ɹ���Ӧ
		case protocol::Sub_Vchat_TradeGiftResp:
			ON_MESSAGE(room_listener, TradeGiftRecord, OnTradeGiftRecordResp);
			break;
		//��������ʧ����Ӧ
		case protocol::Sub_Vchat_TradeGiftErr:
			ON_MESSAGE(room_listener, TradeGiftErr, OnTradeGiftErr);
			break;
		//��������֪ͨ
		case protocol::Sub_Vchat_TradeGiftNotify:
			ON_MESSAGE(room_listener, TradeGiftRecord, OnTradeGiftNotify);
			break;

		//ϵͳ��Ϣ֪ͨ����
		case protocol::Sub_Vchat_SysNoticeInfo:
			ON_MESSAGE(room_listener, SysCastNotice, OnSysNoticeInfo);
			break;

		//�û��ʻ�����
		case protocol::Sub_Vchat_UserAccountInfo:
			ON_MESSAGE(room_listener, UserAccountInfo, OnUserAccountInfo);
			break;

		//�������֪ͨ����
		case protocol::Sub_Vchat_RoomManagerNotify:
			//���޲���
			break;

		//����ý������֪ͨ
		case protocol::Sub_Vchat_RoomMediaNotify:
			ON_MESSAGE(room_listener, RoomMediaInfo, OnRoomMediaInfo);
			break;

		//���乫������֪ͨ
		case protocol::Sub_Vchat_RoomNoticeNotify:
			ON_MESSAGE(room_listener, RoomNotice, OnRoomNoticeNotify);
			break;

		//����״̬����֪ͨ
		case protocol::Sub_Vchat_RoomOPStatusNotify:
			ON_MESSAGE(room_listener, RoomOpState, OnRoomOpState);
			break;

		//������Ϣ����֪ͨ
		case protocol::Sub_Vchat_RoomInfoNotify:
			ON_MESSAGE(room_listener, RoomBaseInfo, OnRoomInfoNotify);
			break;

		//�����ɱ�û�֪ͨ
		case protocol::Sub_Vchat_ThrowUserNotify:
			ON_MESSAGE(room_listener, ThrowUserInfo, OnThrowUserNotify);
			break;

		//��������Ӧ
		case protocol::Sub_Vchat_UpWaitMicResp:
			ON_MESSAGE(room_listener, UpWaitMic, OnUpWaitMicResp);
			break;
		//���������
		case protocol::Sub_Vchat_UpWaitMicErr:
			ON_MESSAGE(room_listener, UpWaitMic, OnUpWaitMicErr);
			break;

		//������״̬��Ӧ
		case protocol::Sub_Vchat_SetMicStateResp:
			//���޲���
			break;
		//������״̬����
		case protocol::Sub_Vchat_SetMicStateErr:
			ON_MESSAGE(room_listener, UserMicState, OnSetMicStateErr);
			break;
		//������״̬֪ͨ
		case protocol::Sub_Vchat_SetMicStateNotify:
			ON_MESSAGE(room_listener, UserMicState, OnSetMicStateNotify);
			break;

		//�����豸״̬��Ӧ
		case protocol::Sub_Vchat_SetDevStateResp:
			ON_MESSAGE(room_listener, UserDevState, OnSetDevStateResp);
			break;
		//�����豸״̬����
		case protocol::Sub_Vchat_SetDevStateErr:
			ON_MESSAGE(room_listener, UserDevState, OnSetDevStateErr);
			break;
		//�����豸״̬֪ͨ
		case protocol::Sub_Vchat_SetDevStateNotify:
			ON_MESSAGE(room_listener, UserDevState, OnSetDevStateNotify);
			break;

		//�����û�Ȩ��(����)��Ӧ
		case protocol::Sub_Vchat_SetUserPriorityResp:
			ON_MESSAGE(room_listener, SetUserPriorityResp, OnSetUserPriorityResp);
			break;
		//�����û�Ȩ��(����)֪ͨ
		case protocol::Sub_Vchat_SetUserPriorityNotify:
			ON_MESSAGE(room_listener, UserPriority, OnSetUserPriorityNotify);
			break;

		//�鿴�û�IP��Ӧ
		case protocol::Sub_Vchat_SeeUserIpResp:
			ON_MESSAGE(room_listener, SeeUserIpResp, OnSeeUserIpResp);
			break;
		//�鿴�û�IP����
		case protocol::Sub_Vchat_SeeUserIpErr:
			ON_MESSAGE(room_listener, SeeUserIpResp, OnSeeUserIpErr);
			break;

		//��ɱ�����û���Ӧ
		case protocol::Sub_Vchat_ThrowUserResp:
			ON_MESSAGE(room_listener, ThrowUserInfoResp, OnThrowUserResp);
			break;

		//����֪ͨ
		case protocol::Sub_Vchat_ForbidUserChatNotify:
			ON_MESSAGE(room_listener, ForbidUserChat, OnForbidUserChatNotify);
			break;

		//�ղط�����Ӧ
		case protocol::Sub_Vchat_FavoriteVcbResp:
			ON_MESSAGE(room_listener, FavoriteRoomResp, OnFavoriteVcbResp);
			break;

		//���÷��乫����Ӧ
		case protocol::Sub_Vchat_SetRoomNoticeResp:
			ON_MESSAGE(room_listener, SetRoomNoticeResp, OnSetRoomNoticeResp);
			break;

		//���÷�����Ϣ��Ӧ
		case protocol::Sub_Vchat_SetRoomInfoResp:
			ON_MESSAGE(room_listener, SetRoomInfoResp, OnSetRoomInfoResp);
			break;

		//���÷���״̬��Ϣ��Ӧ
		case protocol::Sub_Vchat_SetRoomOPStatusResp:
			ON_MESSAGE(room_listener, SetRoomOPStatusResp, OnSetRoomOPStatusResp);
			break;

		//��ѯ�û��ʻ���Ӧ
		case protocol::Sub_Vchat_QueryUserAccountResp:
			ON_MESSAGE(room_listener, QueryUserAccountResp, OnQueryUserAccountResp);
			break;

		//�յ�������ping��Ϣ�ķ���,��ʾ�������
		case protocol::Sub_Vchat_ClientPingResp:
			ON_MESSAGE(room_listener, ClientPingResp, OnClientPingResp);
			break;

		//���䱻�ر���Ϣ,ֱ���˳���ǰ����
		case protocol::Sub_Vchat_CloseRoomNotify:
			ON_MESSAGE(room_listener, CloseRoomNoty, OnCloseRoomNotify);
			break;

		//�յ����䲻�ɵ�����Ϣ
		case protocol::Sub_Vchat_DoNotReachRoomServer:
			//���޲���
			break;

		//���÷�����Ϣ�ɲ����Ӧ
		case protocol::Sub_Vchat_SetRoomInfoResp_v2:
			ON_MESSAGE(room_listener, SetRoomInfoResp, OnSetRoomInfoResp);
			break;
		//���÷�����Ϣ�ɲ��֪ͨ
		case protocol::Sub_Vchat_SetRoomInfoNoty_v2:
			ON_MESSAGE(room_listener, SetRoomInfoReq_v2, OnSetRoomInfoReq_v2);
			break;

		//�յ����Թؼ���ˢ��֪ͨ
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
		//�յ����Թؼ��ʸ���֪ͨ
		case protocol::Sub_Vchat_AdKeyWordOperateResp:
			ON_MESSAGE(room_listener, AdKeywordsResp, OnAdKeyWordOperateResp);
			break;

		//�յ���ʦ������Ӧ
		case protocol::Sub_Vchat_TeacherScoreResp:
			ON_MESSAGE(room_listener, TeacherScoreResp, OnTeacherScoreResp);
			break;
		//�յ��û�������Ӧ
		case protocol::Sub_Vchat_TeacherScoreRecordResp:
			ON_MESSAGE(room_listener, TeacherScoreRecordResp, OnTeacherScoreRecordResp);
			break;

		//��������˶�Ӧ��ʦID֪ͨ
		case protocol::Sub_Vchat_RoborTeacherIdNoty:
			ON_MESSAGE(room_listener, RobotTeacherIdNoty, OnRobotTeacherIdNoty);
			break;

		//��ʦ��ʵ���ܰ���Ӧ
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

		//�û��Խ�ʦ������
		case protocol::Sub_Vchat_UserScoreNotify:
			ON_MESSAGE(room_listener, UserScoreNoty, OnUserScoreNotify);
			break;
		//�û��Խ�ʦ�������б�
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
		//�û��Խ�ʦ��ƽ����
		case protocol::Sub_Vchat_TeacherAvarageScore_Noty:
			ON_MESSAGE(room_listener, TeacherAvarageScoreNoty, OnTeacherAvarageScoreNoty);
			break;

		//��������ӷ���id��Ŀǰֻ���ƶ����У�PC��û��
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

		//���䷢��ϵͳ����
		case protocol::Sub_Vchat_SysCast_Resp:
			ON_MESSAGE(room_listener, Syscast, OnSysCastResp);
			break;

		//��ͨ�û���������
		case protocol::Sub_Vchat_GetUserInfoResp:
			{
				TextRoomList_mobile headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();

				ON_MESSAGE(room_listener,RoomUserInfoResp, OnRoomUserInfoResp);
			}
			break;
		//���ֽ�ʦ��������
		case protocol::Sub_Vchat_GetTeacherInfoResp:
			{
				TextRoomList_mobile headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();

				ON_MESSAGE(room_listener,TeacherInfoResp, OnTeacherInfoResp);
			}
			break;
		//��ȡ�û���������ʧ��
		case protocol::Sub_Vchat_GetUserInfoErr:
			{
				TextRoomList_mobile headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();

				ON_MESSAGE(room_listener,UserInfoErr, OnUserInfoErr);
			}
			break;	

		//�γ̶��ķ���
		case protocol::Sub_Vchat_RoomTeacherSubscriptionResp:
			ON_MESSAGE(room_listener,TeacherSubscriptionResp, OnTeacherSubscriptionResp);
			break;
		case protocol::Sub_Vchat_RoomTeacherSubscriptionStateQueryResp:
			ON_MESSAGE(room_listener,TeacherSubscriptionStateQueryResp, OnTeacherSubscriptionStateQueryResp);
			break;
	
		//�ҽ𵰸���99������ֵ
		case protocol::Sub_Vchat_ClientNotify:
		case protocol::Sub_Vchat_HitGoldEgg_ToClient_Noty:
			LOG("protocol::Sub_Vchat_ClientNotify");
			dispatch_push_message(body);
			break;

		//��ǿս���ܰ��Ӧ
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

		//�۵���������֪ͨ
		case protocol::Sub_Vchat_ViewpointTradeGiftNoty:
			ON_MESSAGE(room_listener,ViewpointTradeGiftNoty, OnViewpointTradeGiftNoty);
			break;

		//������Ӧ
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

