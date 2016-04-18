
#include "platform.h"
#include "Http.h"
#include "TextRoomConnection.h"
#include "Thread.h"
#include "textroom_cmd_vchat.h"

TextConnection::TextConnection(void):
listener(NULL)
{
	main_cmd = protocol::MDM_Vchat_Text;
}

TextConnection::~TextConnection(void)
{
}

void TextConnection::on_do_connected()
{
	//SendMsg_Hello();

	//SEND_MESSAGE(protocol::Sub_Vchat_TextRoomJoinReq, join_req);

	//start_read_thread();
}

void TextConnection::RegisterMessageListener(TextListener* message_listener)
{
	listener = message_listener;
}

void TextConnection::on_dispatch_message(void* msg)
{
	if ( listener != NULL )
	{
		listener->OnMessageComming(msg);
	}
}

void TextConnection::close(void)
{
	SendMsg_ExitRoomReq();
	Connection::close();
}

void TextConnection::SendMsg_Ping()
{
	protocol::CMDClientPing_t ping;
	ping.userid = join_req.userid();
	ping.roomid = join_req.vcbid();

	SEND_MESSAGE2(protocol::Sub_Vchat_ClientPing, protocol::CMDClientPing_t, &ping);
}

void TextConnection::SendMsg_JoinRoomReq(JoinRoomReq2& req, int useServerIndex/*=-1*/,int outTime/*=-1*/)
{
	//join_req = req;
	//connect_from_lbs();

	int ret;
	//ret = connect("122.13.81.62", 22806);
	ret = connect("172.16.41.96", 22806);

	if (ret != 0)
	{
		LOG("SendMsg_JoinRoomReq error");
		return;
	}
	LOG("SendMsg_JoinRoomReq success");

	join_req = req;

	SendMsg_Hello();

	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomJoinReq, req);

	//close();

	//Sleep(3000);

	start_read_thread();
}

void TextConnection::SendMsg_ExitRoomReq()
{
	UserExitRoomInfo req;
	req.set_userid(join_req.userid());
	req.set_vcbid(join_req.vcbid());

	SEND_MESSAGE(protocol::Sub_Vchat_TextLiveUserExitReq, req);
}

void TextConnection::SendMsg_ModifyAdKeywordsReq(AdKeywordsReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_AdKeyWordOperateReq, req);
}

void TextConnection::SendMsg_SetRoomBaseInfoReq_v2(SetRoomInfoReq_v2& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetRoomInfoReq_v2, req);
}

void TextConnection::SendMsg_KickoutUserReq(UserKickoutRoomInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_RoomKickoutUserReq, req);
}

void TextConnection::SendMsg_TradeGiftReq(TradeGiftRecord& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TradeGiftReq, req);
}

void TextConnection::SendMsg_ForbidUserChat(ForbidUserChat& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_ForbidUserChatReq, req);
}

void TextConnection::SendMsg_AddUserToBlackListReq(ThrowUserInfo& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_ThrowUserReq, req);
}

void TextConnection::SendMsg_SetUserPriorityReq(UserPriority& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SetUserPriorityReq, req);
}

void TextConnection::SendMsg_SeeUserIpReq(SeeUserIpReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_SeeUserIpReq, req);
}

void TextConnection::SendMsg_ReportGate(int RoomId, int UserId, char* gateaddr, uint16 gateport)
{
	ReportMediaGateReq req;
	req.set_vcbid(RoomId);
	req.set_userid(UserId);

	char content[128];
	sprintf(content, "%s:%d", gateaddr, gateport);
	req.set_content(content);
	req.set_textlen(strlen(content));

	SEND_MESSAGE(protocol::Sub_Vchat_ReportMediaGateReq, req);
}

void TextConnection::SendMsg_GetUserInfoReq(TextRoomList_mobile& head,GetUserInfoReq& req)
{
	SEND_MESSAGELIST(protocol::Sub_Vchat_GetUserInfoReq, head, req);
}

void TextConnection::SendMsg_CollectTextRoomReq(uint32 roomId, uint32 userId, int32 actionId)
{
	FavoriteRoomReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_actionid(actionId);

	SEND_MESSAGE(protocol::Sub_Vchat_FavoriteVcbReq, req);
}

void TextConnection::SendMsg_TeacherSubscriptionReq(TeacherSubscriptionReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_RoomTeacherSubscriptionReq, req);
}

void TextConnection::SendMsg_TextRoomPingReq(uint32 userId, uint32 roomId)
{
	protocol::CMDClientPing_t ping;
	ping.userid = userId;
	ping.roomid = roomId;

	SEND_MESSAGE2(protocol::Sub_Vchat_ClientPing, protocol::CMDClientPing_t, &ping);
}

void TextConnection::SendMsg_TextRoomTeacherReq(uint32 roomId, uint32 userId)
{
	TextRoomTeacherReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	
	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomTeacherReq, req);
}

void TextConnection::SendMsg_TextRoomLiveListReq(TextRoomLiveListReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomLiveListReq, req);
}

void TextConnection::SendMsg_TextRoomLiveListReq2(TextRoomList_mobile& head,TextRoomLiveListReq& req)
{
	SEND_MESSAGELIST(protocol::Sub_Vchat_TextRoomLiveListReq_Mobile, head, req);
}

void TextConnection::SendMsg_TextRoomLiveMessageReq(TextRoomLiveMessageReq& req)
{
	SEND_MESSAGE_EX(protocol::Sub_Vchat_TextRoomLiveMessageReq, req, req.textlen());
}

void TextConnection::SendMsg_TextRoomLiveChatReq(RoomLiveChatReq& req)
{
	SEND_MESSAGE_EX(protocol::Sub_Vchat_TextRoomLiveChatReq, req, req.textlen());
}

void TextConnection::SendMsg_TextRoomViewTypeReq(TextRoomViewTypeReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomViewTypeReq, req);
}

void TextConnection::SendMsg_TextRoomViewMessageReq(TextRoomViewMessageReq& req)
{
	SEND_MESSAGE_EX(protocol::Sub_Vchat_TextRoomViewMessageReq, req, req.titlelen()+req.textlen());
}

void TextConnection::SendMsg_TextRoomViewDeleteReq(uint32 roomId, uint32 userId, int64 viewId)
{
	TextRoomViewDeleteReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_viewid(viewId);

	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomViewDeleteReq, req);
}

void TextConnection::SendMsg_TextRoomLiveViewDetailReq(TextRoomLiveViewDetailReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomLiveViewDetailReq, req);
}

void TextConnection::SendMsg_TextLiveChatReplyReq(TextLiveChatReplyReq& req)
{
	SEND_MESSAGE_EX(protocol::Sub_Vchat_TextLiveChatReplyReq, req, req.reqtextlen()+req.restextlen());
}

void TextConnection::SendMsg_TextRoomLiveViewGroupReq(uint32 roomId, uint32 userId, uint32 teacherId)
{
	TextRoomLiveViewGroupReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_teacherid(teacherId);

	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomLiveViewReq, req);
}

void TextConnection::SendMsg_TextRoomLiveViewListReq(TextRoomLiveViewListReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomViewListShowReq, req);
}

void TextConnection::SendMsg_TextRoomInterestOnTeacher(uint32 roomId, uint32 userId, uint32 teacherId, int16 optype)
{
	TextRoomInterestForReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_teacherid(teacherId);
	req.set_optype(optype);

	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomInterestForReq, req);
}

void TextConnection::SendMsg_LikeForTextLiveInTextRoom(uint32 roomId, uint32 userId, int64  messageId)
{
	TextRoomZanForReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_messageid(messageId);

	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomZanForReq, req);
}

void TextConnection::SendMsg_UserPayReq(UserPayReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_UserPayReq, req);
}

void TextConnection::SendMsg_GetUserAccountBalanceReq(uint32 userId)
{
	GetUserAccountBalanceReq req;
	req.set_userid(userId);

	SEND_MESSAGE(protocol::Sub_Vchat_GetUserAccountBalanceReq, req);
}

void TextConnection::SendMsg_GetUserGoodStatusReq(uint32 userId, uint32 salerid, uint32 type, uint32 goodclassid)
{
	TextRoomGetUserGoodStatusReq req;
	req.set_userid(userId);
	req.set_salerid(salerid);
	req.set_type(type);
	req.set_goodclassid(goodclassid);

	SEND_MESSAGE(protocol::Sub_Vchat_GetUserGoodStatusReq, req);
}

void TextConnection::SendMsg_TextRoomSecretsTotalReq(uint32 roomId, uint32 userId, uint32 teacherId)
{
	TextRoomSecretsTotalReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_teacherid(teacherId);

	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomSecretsTotalReq, req);
}

void TextConnection::SendMsg_TextRoomSecretsReq(TextRoomLiveListReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomSecretsListReq, req);
}

void TextConnection::SendMsg_TextRoomSecretsBuyReq(TextRoomBuySecretsReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TextRoomBuySecretsReq, req);
}

void TextConnection::SendMsg_UserQuestionReq(TextRoomQuestionReq& req)
{
	SEND_MESSAGE_EX(protocol::Sub_Vchat_TextRoomQuestionReq, req, req.stocklen()+req.textlen());
}

void TextConnection::SendMsg_ZanReq(uint32 roomId, uint32 userId, int64  messageId)
{
	TextRoomZanForReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_messageid(messageId);

	SEND_MESSAGE(protocol::Sub_Vchat_TextLiveViewZanForReq, req);
}

void TextConnection::SendMsg_SendFlowers(uint32 roomId, uint32 userId, int64  messageId, int32  count)
{
	TextLiveViewFlowerReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_messageid(messageId);
	req.set_count(count);

	SEND_MESSAGE(protocol::Sub_Vchat_TextLiveViewFlowerReq, req);
}

void TextConnection::SendMsg_ViewCommentReq(TextRoomViewCommentReq& req)
{
	SEND_MESSAGE_EX(protocol::Sub_Vchat_TextRoomViewCommentReq, req, req.textlen());
}

void TextConnection::SendMsg_GetLiveHistoryListReq(TextLiveHistoryListReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TextLiveHistoryListReq, req);
}

void TextConnection::SendMsg_GetDaylyLiveHistoryReq(TextLiveHistoryDaylyReq& req)
{
	SEND_MESSAGE(protocol::Sub_Vchat_TextLiveHistoryDaylyReq, req);
}

void TextConnection::SendMsg_BeTeacherReq(uint32 roomId, uint32 userId, uint32 teacherId, uint8 opMode)
{
	BeTeacherReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_teacherid(teacherId);
	req.set_opmode(opMode);

	SEND_MESSAGE(protocol::Sub_Vchat_BeTeacherReq, req);
}

void TextConnection::SendMsg_GetPrivilegeReq(uint32 userId, uint32 packageNum)
{
	GetPackagePrivilegeReq req;
	req.set_userid(userId);
	req.set_packagenum(packageNum);

	SEND_MESSAGE(protocol::Sub_Vchat_GetPrivilegeReq, req);
}

void TextConnection::SendMsg_GetBeTeacherInfoReqNormal(uint32 roomId, uint32 userId, uint32 teacherId)
{
	GetBeTeacherInfoReq req;
	req.set_vcbid(roomId);
	req.set_userid(userId);
	req.set_teacherid(teacherId);

	SEND_MESSAGE(protocol::Sub_Vchat_GetBeTeacherInfoReq, req);
}

void TextConnection::DispatchSocketMessage(void* msg)
{
	static std::vector<RoomUserInfo> g_vec_RoomUserInfo;//房间用户列表
	static std::vector<TextRoomLiveListNoty> g_vec_TextRoomLiveListNoty;//加载直播记录列表
	static std::vector<TextRoomLivePointNoty> g_vec_TextRoomLivePointNoty;//加载直播重点记录列表
	static std::vector<TextRoomLivePointNoty> g_vec_TextRoomLiveForecastNoty;//加载明日预测记录列表
	static std::vector<TextLiveHistoryListResp> g_vec_TextLiveHistoryListResp;//直播历史列表(概况)列表
	static std::vector<TextRoomLiveListNoty> g_vec_TextLiveHistoryDaylyResp;//加载历史直播记录列表
	static std::vector<TextRoomViewGroupResp> g_vec_TextRoomViewGroupResp;//观点类型分类列表
	static std::vector<TextRoomLiveViewResp> g_vec_TextRoomLiveViewResp;//观点列表
	static std::vector<TextRoomViewInfoResp> g_vec_TextRoomViewInfoResp;//评论列表
	static std::vector<TextRoomSecretsListResp> g_vec_TextRoomSecretsListResp;//加载个人秘籍记录列表
	static std::vector<TextRoomSecretsListResp> g_vec_TextRoomBuySecretsResp;//加载个人秘籍已购买记录列表
	static std::vector<NormalUserGetBeTeacherInfoRespItem> g_vec_NormalUserGetBeTeacherInfoRespItem;//拜师信息列表
	static std::vector<TeacherGetBeTeacherInfoRespItem> g_vec_TeacherGetBeTeacherInfoRespItem;//拜师信息列表
	static std::vector<GetPackagePrivilegeResp> g_vec_GetPackagePrivilegeResp;//拜师信息列表
	static std::vector<TextRoomEmoticonListResp> g_vec_TextRoomEmoticonListResp;//专属表情
	

	protocol::COM_MSG_HEADER* head = (protocol::COM_MSG_HEADER*)msg;

	uint8* body = (uint8*)(head->content);

	int sub_cmd = head->subcmd;
	int body_len = head->length - sizeof(protocol::COM_MSG_HEADER);

	LOG("on message:%d", sub_cmd);

	switch ( sub_cmd ) {
		//加入房间失败
		case protocol::Sub_Vchat_TextRoomJoinErr:
			ON_MESSAGE(listener,JoinRoomErr, OnJoinRoomErr);
			break;
		//加入房间成功
		case protocol::Sub_Vchat_TextRoomJoinResp:
			ON_MESSAGE(listener, JoinRoomResp, OnJoinRoomResp);
			break;

		//用户加入房间通知
		case protocol::Sub_Vchat_TextUserRoomJoinNoty:
			ON_MESSAGE(listener,RoomUserInfo, OnRoomUserNoty);
			break;

		//房间用户列表开始
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
		//房间用户列表结束
		case protocol::Sub_Vchat_RoomUserListFinished:
			listener->OnRoomUserList(g_vec_RoomUserInfo);
			break;

		//收到禁言关键词刷新通知
		case protocol::Sub_Vchat_AdKeyWordOperateNoty:
			ON_MESSAGE(listener, AdKeywordsNotify, OnAdKeyWordOperateNoty);
			break;
		//收到禁言关键词更新通知
		case protocol::Sub_Vchat_AdKeyWordOperateResp:
			ON_MESSAGE(listener, AdKeywordsResp, OnAdKeyWordOperateResp);
			break;

		//设置房间信息响应
		case protocol::Sub_Vchat_SetRoomInfoResp:
			ON_MESSAGE(listener, SetRoomInfoResp, OnSetRoomInfoResp);
			break;
		//房间信息数据通知
		case protocol::Sub_Vchat_RoomInfoNotify:
			ON_MESSAGE(listener, RoomBaseInfo, OnRoomInfoNotify);
			break;
		//房间状态数据通知
		case protocol::Sub_Vchat_RoomOPStatusNotify:
			ON_MESSAGE(listener, RoomOpState, OnRoomOpState);
			break;

		//禁言通知
		case protocol::Sub_Vchat_ForbidUserChatNotify:
			ON_MESSAGE(listener, ForbidUserChat, OnForbidUserChatNotify);
			break;

		//封杀房间用户响应
		case protocol::Sub_Vchat_ThrowUserResp:
			ON_MESSAGE(listener, ThrowUserInfoResp, OnThrowUserResp);
			break;
		//房间封杀用户通知
		case protocol::Sub_Vchat_ThrowUserNotify:
			ON_MESSAGE(listener, ThrowUserInfo, OnThrowUserNotify);
			break;

		//设置用户权限(管理)响应
		case protocol::Sub_Vchat_SetUserPriorityResp:
			ON_MESSAGE(listener, SetUserPriorityResp, OnSetUserPriorityResp);
			break;
		//设置用户权限(管理)通知
		case protocol::Sub_Vchat_SetUserPriorityNotify:
			ON_MESSAGE(listener, SetUserPriorityResp, OnSetUserPriorityNotify);
			break;

		//查看用户IP响应
		case protocol::Sub_Vchat_SeeUserIpResp:
			ON_MESSAGE(listener, SeeUserIpResp, OnSeeUserIpResp);
			break;
		//察看用户IP错误
		case protocol::Sub_Vchat_SeeUserIpErr:
			ON_MESSAGE(listener, SeeUserIpResp, OnSeeUserIpErr);
			break;

		//赠送礼物返回响应消息
		case protocol::Sub_Vchat_TradeGiftResp:
			ON_MESSAGE(listener, TradeGiftRecord, OnTradeGiftRecordResp);
			break;
		//赠送礼物返回错误消息
		case protocol::Sub_Vchat_TradeGiftErr:
			ON_MESSAGE(listener, TradeGiftErr, OnTradeGiftErr);
			break;
		//赠送礼物通知数据
		case protocol::Sub_Vchat_TradeGiftNotify:
			ON_MESSAGE(listener, TradeGiftRecord, OnTradeGiftNotify);
			break;

		case protocol::Sub_Vchat_FavoriteVcbResp:
			//暂无操作
			break;
		case protocol::Sub_Vchat_ReportMediaGateResp:
			//暂无操作
			break;

		//普通用户个人资料	
		case protocol::Sub_Vchat_GetUserInfoResp:
			ON_MESSAGE(listener,RoomUserInfoResp, OnRoomUserInfoResp);
			break;
		//文字讲师个人资料
		case protocol::Sub_Vchat_GetTeacherInfoResp:
			ON_MESSAGE(listener,TeacherInfoResp, OnTeacherInfoResp);
			break;
		//获取用户个人资料失败
		case protocol::Sub_Vchat_GetUserInfoErr:
			ON_MESSAGE(listener,UserInfoErr, OnUserInfoErr);
			break;

		//课程订阅返回
		case protocol::Sub_Vchat_RoomTeacherSubscriptionResp:
			ON_MESSAGE(listener,TeacherSubscriptionResp, OnTeacherSubscriptionResp);
			break;

		//房间用户踢出通知
		case protocol::Sub_Vchat_RoomKickoutUserNoty:
			ON_MESSAGE(listener,UserKickoutRoomInfo_ext, OnRoomKickoutUserNoty);
			break;
		//用户退出房间
		case protocol::Sub_Vchat_TextLiveUserExitResp:
			break;
		//用户退出房间通知
		case protocol::Sub_Vchat_RoomUserExitNoty:
		//用户异常退出房间
		case protocol::Sub_Vchat_RoomUserExceptExitNoty:
			ON_MESSAGE(listener,UserExceptExitRoomInfo_ext, OnRoomUserExceptExitNoty);
			break;

		//收到服务器ping消息的返回,表示房间活着
		case protocol::Sub_Vchat_ClientPingResp:
			ON_MESSAGE(listener, ClientPingResp, OnClientPingResp);
			break;

		//讲师加入房间通知
		case protocol::Sub_Vchat_TextTeacherRoomJoinNoty:
			ON_MESSAGE(listener, TeacherComeNotify, OnTeacherComeNotify);
			break;
		//讲师信息		
		case protocol::Sub_Vchat_TextRoomTeacherNotify:
			ON_MESSAGE(listener,TextRoomTeacherNoty, OnTextRoomTeacherNoty);
			break;	

		//加载直播记录（单条）开始
		case protocol::Sub_Vchat_TextRoomLiveListBegin:
			g_vec_TextRoomLiveListNoty.clear();
			break;	
		//加载直播记录（单条）
		case protocol::Sub_Vchat_TextRoomLiveListNotify:
			{
				TextRoomLiveListNoty liveList;
				liveList.ParseFromArray(body, liveList.ByteSize());
				g_vec_TextRoomLiveListNoty.push_back(liveList);
			}
			break;	
		//加载直播记录（单条）结束
		case protocol::Sub_Vchat_TextRoomLiveListEnd:
			listener->OnTextRoomLiveListNoty(g_vec_TextRoomLiveListNoty);
			break;	

		//加载直播重点记录（单条）开始	
		case protocol::Sub_Vchat_TextRoomLivePointBegin:
			g_vec_TextRoomLivePointNoty.clear();
			break;	
		//加载直播重点记录（单条）
		case protocol::Sub_Vchat_TextRoomLivePointNotify:
			{
				TextRoomLivePointNoty liveList;
				liveList.ParseFromArray(body, liveList.ByteSize());
				g_vec_TextRoomLivePointNoty.push_back(liveList);
			}
			break;	
		//加载直播重点记录（单条）结束
		case protocol::Sub_Vchat_TextRoomLivePointEnd:
			listener->OnTextRoomLivePointNoty(g_vec_TextRoomLivePointNoty);
			break;

		//加载明日预测记录（单条）开始
		case protocol::Sub_Vchat_TextRoomForecastBegin:
			g_vec_TextRoomLiveForecastNoty.clear();
			break;	
		//加载明日预测记录（单条）
		case protocol::Sub_Vchat_TextRoomForecastNotify:
			{
				TextRoomLivePointNoty liveList;
				liveList.ParseFromArray(body, liveList.ByteSize());
				g_vec_TextRoomLiveForecastNoty.push_back(liveList);
			}
			break;	
		//加载明日预测记录（单条）结束
		case protocol::Sub_Vchat_TextRoomForecastEnd:
			listener->OnTextRoomLiveForecastNoty(g_vec_TextRoomLiveForecastNoty);
			break;

		//直播历史列表(概况)（单条）开始
		case protocol::Sub_Vchat_TextLiveHistoryListBegin:
			g_vec_TextLiveHistoryListResp.clear();
			break;
		//直播历史列表(概况)（单条）Item
		case protocol::Sub_Vchat_TextLiveHistoryListResp:
			{
				TextLiveHistoryListResp liveList;
				liveList.ParseFromArray(body, liveList.ByteSize());
				g_vec_TextLiveHistoryListResp.push_back(liveList);
			}
			break;
		//直播历史列表(概况)（单条）结束
		case protocol::Sub_Vchat_TextLiveHistoryListEnd:
			listener->OnTextLiveHistoryListResp(g_vec_TextLiveHistoryListResp);
			break;

		//加载历史直播记录（单条）开始
		case protocol::Sub_Vchat_TextLiveHistoryDaylyBegin:
			g_vec_TextLiveHistoryDaylyResp.clear();
			break;	
		//加载历史直播记录（单条）
		case protocol::Sub_Vchat_TextLiveHistoryDaylyResp:
			{
				TextRoomLiveListNoty liveList;
				liveList.ParseFromArray(body, liveList.ByteSize());
				g_vec_TextLiveHistoryDaylyResp.push_back(liveList);
			}
			break;	
		//加载历史直播记录（单条）结束
		case protocol::Sub_Vchat_TextLiveHistoryDaylyEnd:
			listener->OnTextLiveHistoryDaylyResp(g_vec_TextLiveHistoryDaylyResp);
			break;	

		//观点类型分类（单条）列表开始	
	    case protocol::Sub_Vchat_TextRoomViewGroupBegin:
			g_vec_TextRoomViewGroupResp.clear();
            break;
		//观点类型分类（单条）列表
        case protocol::Sub_Vchat_TextRoomViewGroupResp:
			{
				TextRoomViewGroupResp liveList;
				liveList.ParseFromArray(body, liveList.ByteSize());
				g_vec_TextRoomViewGroupResp.push_back(liveList);
			}
            break;
		//观点类型分类（单条）列表结束
        case protocol::Sub_Vchat_TextRoomViewGroupEnd:
			listener->OnTextRoomViewGroupResp(g_vec_TextRoomViewGroupResp);
            break;

		//观点列表（单条）开始
        case protocol::Sub_Vchat_TextRoomLiveViewBegin:
			g_vec_TextRoomLiveViewResp.clear();
            break;
		//观点列表（单条）
        case protocol::Sub_Vchat_TextRoomLiveViewResp:
			{
				TextRoomLiveViewResp liveList;
				liveList.ParseFromArray(body, liveList.ByteSize());
				g_vec_TextRoomLiveViewResp.push_back(liveList);
			}
            break;
		//观点列表（单条）结束
        case protocol::Sub_Vchat_TextRoomLiveViewEnd:
			listener->OnTextRoomLiveViewResp(g_vec_TextRoomLiveViewResp);
            break;

		//观点详情，评论列表 （单条）开头
		case protocol::Sub_Vchat_TextRoomViewInfoBegin:
			g_vec_TextRoomViewInfoResp.clear();
			break;
		//观点详情（一条）
		case protocol::Sub_Vchat_TextRoomLiveViewDetailResp:
			ON_MESSAGE(listener,TextRoomLiveViewResp, OnTextRoomLiveViewDetailResp);
			break;
		//评论列表，评论列表 （单条）
		case protocol::Sub_Vchat_TextRoomViewInfoResp:
			{
				TextRoomViewInfoResp liveList;
				liveList.ParseFromArray(body, liveList.ByteSize());
				g_vec_TextRoomViewInfoResp.push_back(liveList);
			}
			break;
		//观点详情，评论列表（单条） 结束
		case protocol::Sub_Vchat_TextRoomViewInfoEnd:
			listener->OnTextRoomViewInfoResp(g_vec_TextRoomViewInfoResp);
			break;

		//拜师信息头(普通用户)
		case protocol::Sub_Vchat_NormalUserGetBeTeacherInfoHead:
			{
				ON_MESSAGE(listener,NormalUserGetBeTeacherInfoRespHead, OnNormalUserGetBeTeacherInfoRespHead);
				g_vec_NormalUserGetBeTeacherInfoRespItem.clear();
			}
			break;	
		//拜师信息body(普通用户)
		case protocol::Sub_Vchat_NormalUserGetBeTeacherInfoBody:
			{
				int livelen=body_len;
				while(livelen>0)
				{
					NormalUserGetBeTeacherInfoRespItem liveList;
					liveList.ParseFromArray(body, liveList.ByteSize());
					g_vec_NormalUserGetBeTeacherInfoRespItem.push_back(liveList);
					body += liveList.ByteSize();
					livelen -= liveList.ByteSize();
				}
			}
			break;	
		//拜师信息结束(普通用户)
		case protocol::Sub_Vchat_NormalUserGetBeTeacherInfoEnd:
			listener->OnNormalUserGetBeTeacherInfoRespItem(g_vec_NormalUserGetBeTeacherInfoRespItem);
			break;

		//拜师信息头(讲师)
		case protocol::Sub_Vchat_TeacherGetBeTeacherInfoHead:
			{
				ON_MESSAGE(listener,TeacherGetBeTeacherInfoRespHead, OnTeacherGetBeTeacherInfoRespHead);
				g_vec_TeacherGetBeTeacherInfoRespItem.clear();
			}
			break;	
		//拜师信息body(讲师)
		case protocol::Sub_Vchat_TeacherGetBeTeacherInfoBody:
			{
				int livelen=body_len;
				while(livelen>0)
				{
					TeacherGetBeTeacherInfoRespItem liveList;
					liveList.ParseFromArray(body, liveList.ByteSize());
					g_vec_TeacherGetBeTeacherInfoRespItem.push_back(liveList);
					body += liveList.ByteSize();
					livelen -= liveList.ByteSize();
				}
			}
			break;	
		//拜师信息结束(讲师)
		case protocol::Sub_Vchat_TeacherGetBeTeacherInfoEnd:
			listener->OnTeacherGetBeTeacherInfoRespItem(g_vec_TeacherGetBeTeacherInfoRespItem);
			break;

		//特权信息头
		case protocol::Sub_Vchat_GetPrivilegeRespHead:
			g_vec_GetPackagePrivilegeResp.clear();
			break;	
		//特权信息body
		case protocol::Sub_Vchat_GetPrivilegeRespBody:
			{
				int livelen=body_len;
				while(livelen>0)
				{
					GetPackagePrivilegeResp liveList;
					liveList.ParseFromArray(body, liveList.ByteSize());
					g_vec_GetPackagePrivilegeResp.push_back(liveList);
					body += liveList.ByteSize();
					livelen -= liveList.ByteSize();
				}
			}
			break;
		//特权信息结束
		case protocol::Sub_Vchat_GetPrivilegeRespEnd:
			listener->OnGetPackagePrivilegeResp(g_vec_GetPackagePrivilegeResp);
			break;

		//加载直播记录（组包）			
		case protocol::Sub_Vchat_TextRoomLiveListRes_Mobile:
			{
				g_vec_TextRoomLiveListNoty.clear();
				int livelen=body_len;
				TextRoomList_mobile headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();
				livelen -= headmsg.ByteSize();

				while(livelen>0)
				{
					TextRoomLiveListNoty liveList;
					liveList.ParseFromArray(body, liveList.ByteSize());
					g_vec_TextRoomLiveListNoty.push_back(liveList);
					body += liveList.ByteSize() + liveList.textlen() + liveList.destextlen();
					livelen -= liveList.ByteSize() + liveList.textlen() + liveList.destextlen();
				}
				listener->OnTextRoomLiveListNoty(g_vec_TextRoomLiveListNoty);
			}
			break;

		//加载直播重点记录（组包）	
		case protocol::Sub_Vchat_TextRoomLivePointRes_Mobile:
			{
				g_vec_TextRoomLivePointNoty.clear();
				int livelen=body_len;
				TextRoomList_mobile headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();
				livelen -= headmsg.ByteSize();

				while(livelen>0)
				{
					TextRoomLivePointNoty liveList;
					liveList.ParseFromArray(body, liveList.ByteSize());
					g_vec_TextRoomLivePointNoty.push_back(liveList);
					body += liveList.ByteSize() + liveList.textlen();
					livelen -= liveList.ByteSize() + liveList.textlen();
				}
				listener->OnTextRoomLivePointNoty(g_vec_TextRoomLivePointNoty);
			}
			break;

		//加载明日预测记录（组包）
		case protocol::Sub_Vchat_TextRoomForecastRes_Mobile:
			{
				g_vec_TextRoomLiveForecastNoty.clear();
				int livelen=body_len;
				TextRoomList_mobile headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();
				livelen -= headmsg.ByteSize();

				while(livelen>0)
				{
					TextRoomLivePointNoty liveList;
					liveList.ParseFromArray(body, liveList.ByteSize());
					g_vec_TextRoomLiveForecastNoty.push_back(liveList);
					body += liveList.ByteSize() + liveList.textlen();
					livelen -= liveList.ByteSize() + liveList.textlen();
				}
				listener->OnTextRoomLiveForecastNoty(g_vec_TextRoomLiveForecastNoty);
			}
			break;

		//加载个人秘籍记录（组包）
		case protocol::Sub_Vchat_TextRoomSecretsListResp:
			{
				g_vec_TextRoomSecretsListResp.clear();

				int livelen=body_len;
				TextRoomListHead headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();
				livelen -= headmsg.ByteSize();

				while(livelen>0)
				{
					TextRoomSecretsListResp liveList;
					liveList.ParseFromArray(body, liveList.ByteSize());
					g_vec_TextRoomSecretsListResp.push_back(liveList);
					body += liveList.ByteSize() + liveList.coverlittlelen() + liveList.titlelen() + liveList.textlen();
					livelen -= liveList.ByteSize() + liveList.coverlittlelen() + liveList.titlelen() + liveList.textlen();
				}
				listener->OnTextRoomSecretsListResp(g_vec_TextRoomSecretsListResp);
			}
			break;

		//加载个人秘籍已购买记录
		case protocol::Sub_Vchat_TextRoomSecBuyListResp:
			{
				g_vec_TextRoomBuySecretsResp.clear();

				int livelen=body_len;
				TextRoomListHead headmsg;
				headmsg.ParseFromArray(body, headmsg.ByteSize());
				body += headmsg.ByteSize();
				livelen -= headmsg.ByteSize();

				while(livelen>0)
				{
					TextRoomSecretsListResp liveList;
					liveList.ParseFromArray(body, liveList.ByteSize());
					g_vec_TextRoomBuySecretsResp.push_back(liveList);
					body += liveList.ByteSize() + liveList.coverlittlelen() + liveList.titlelen() + liveList.textlen();
					livelen -= liveList.ByteSize() + liveList.coverlittlelen() + liveList.titlelen() + liveList.textlen();
				}
				listener->OnTextRoomSecBuyListResp(g_vec_TextRoomBuySecretsResp);
			}
			break;

		//专属表情
		case protocol::Sub_Vchat_TextRoomEmoticonResp:
			{
				g_vec_TextRoomEmoticonListResp.clear();
				int livelen=body_len;
				while(livelen>0)
				{
					TextRoomEmoticonListResp liveList;
					liveList.ParseFromArray(body, liveList.ByteSize());
					g_vec_TextRoomEmoticonListResp.push_back(liveList);
					body += liveList.ByteSize();
					livelen -= liveList.ByteSize();
				}
				listener->OnTextRoomEmoticonListResp(g_vec_TextRoomEmoticonListResp);
			}
			break;	

		//加载个人秘籍总体信息响应
		case protocol::Sub_Vchat_TextRoomSecretsTotalResp:
			ON_MESSAGE(listener,TextRoomSecretsTotalResp, OnTextRoomSecretsTotalResp);
			break;
		//个人秘籍单次订阅响应
		case protocol::Sub_Vchat_TextRoomBuySecretsResp:
			ON_MESSAGE(listener,TextRoomBuySecretsResp, OnTextRoomBuySecretsResp);
			break;	
		//讲师发表个人秘籍通知
		 case protocol::Sub_Vchat_TextRoomSecretsPHPNoty:
			ON_MESSAGE(listener,TextRoomSecretsPHPResp, OnTextRoomSecretsPHPResp);
			break;
			
		//讲师发送文字直播响应
		case protocol::Sub_Vchat_TextRoomLiveMessageResp:
			ON_MESSAGE(listener,TextRoomLiveMessageResp, OnTextRoomLiveMessageResp);
			break;
		//用户对直播内容点赞响应
        case protocol::Sub_Vchat_TextRoomZanForResp:
			ON_MESSAGE(listener,TextRoomZanForResp, OnTextRoomZanForResp);
            break;

		//发送聊天响应
		case protocol::Sub_Vchat_TextRoomLiveChatResp:
			ON_MESSAGE(listener,TextRoomLiveChatResp, OnTextRoomLiveChatResp);
			break;
		//聊天回复响应
		case protocol::Sub_Vchat_TextLiveChatReplyResp:
			ON_MESSAGE(listener,TextLiveChatReplyResp, OnTextLiveChatReplyResp);
			break;

		//讲师修改和新增观点类型分类响应
		case protocol::Sub_Vchat_TextRoomViewTypeResp:
			ON_MESSAGE(listener,TextRoomViewTypeResp, OnTextRoomViewTypeResp);
			break;
		//讲师发表观点响应
         case protocol::Sub_Vchat_TextRoomViewMessageResp:
			ON_MESSAGE(listener,TextRoomViewMessageReqResp, OnTextRoomViewMessageReqResp);
			break;
		//讲师发表观点响应PHP
		 case protocol::Sub_Vchat_TextRoomViewPHPResp:
			 ON_MESSAGE(listener,TextRoomViewPHPResp, OnTextRoomViewPHPResp);
			break;
		//观点评论响应
        case protocol::Sub_Vchat_TextRoomViewCommentResp:
			ON_MESSAGE(listener,TextRoomLiveActionResp, OnTextRoomLiveActionResp);
			break;
		//观点点赞响应
		case protocol::Sub_Vchat_TextLiveViewZanForResp:
			ON_MESSAGE(listener,TextRoomZanForResp, OnTextLiveViewZanForResp);
			break;
		//观点送花响应
		case protocol::Sub_Vchat_TextLiveViewFlowerResp:
			ON_MESSAGE(listener,TextLiveViewFlowerResp, OnTextLiveViewFlowerResp);
			break;
		//观点删除响应
		case protocol::Sub_Vchat_TextRoomViewDeleteResp:
			ON_MESSAGE(listener,TextRoomViewDeleteResp, OnTextRoomViewDeleteResp);
			break;	

		//用户提问响应
		case protocol::Sub_Vchat_TextRoomQuestionResp:
			ON_MESSAGE(listener,TextRoomQuestionResp, OnTextRoomQuestionResp);
			break;
		//用户点击关注响应
        case protocol::Sub_Vchat_TextRoomInterestForResp:
			ON_MESSAGE(listener,TextRoomInterestForResp, OnTextRoomInterestForResp);
            break;

		//商品状态
		case protocol::Sub_Vchat_GetUserGoodStatusResp:
			ON_MESSAGE(listener,TextRoomGetUserGoodStatusResp, OnTextRoomGetUserGoodStatusResp);
			break;	
		//用户付费
		case protocol::Sub_Vchat_UserPayResp:
			ON_MESSAGE(listener,UserPayResp, OnUserPayResp);
			break;
		//查寻账户余额		
		case protocol::Sub_Vchat_GetUserAccountBalanceResp:
			ON_MESSAGE(listener,GetUserAccountBalanceResp, OnGetUserAccountBalanceResp);
			break;

		//拜师请求返回
		case protocol::Sub_Vchat_BeTeacherResp:
			ON_MESSAGE(listener,BeTeacherResp, OnBeTeacherResp);
			break;	
		//请求拜师信息失败
		case protocol::Sub_Vchat_GetBeTeacherInfoReqFailed:
			{
				if (listener)
					listener->OnGetBeTeacherInfoReqFailed();
			}
			break;

		//视频房间上麦通知
		case protocol::Sub_Vchat_TextRoomTeacherOnVideoLive:
			ON_MESSAGE(listener,VideoRoomOnMicClientResp, OnVideoRoomOnMicClientResp);
			break;

		default:
			break;
	}
}
