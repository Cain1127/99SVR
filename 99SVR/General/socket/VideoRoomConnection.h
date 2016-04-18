#ifndef __ROOM_CONNECTION_H__
#define __ROOM_CONNECTION_H__

#include <vector>
#include "Connection.h"
#include "VideoRoomListener.h"
#include "HallListener.h"
#include "PushListener.h"
#include "VideoRoomMessage.pb.h"
#include "LoginConnection.h"
#include "TextRoomMessage.pb.h"

class RoomConnection : public Connection
{
private:

	RoomListener* room_listener;

	JoinRoomReq2 join_req;
	JoinRoomResp room_info;

	void dispatch_push_message(void* body);

protected:

	void on_do_connected();
	void on_dispatch_message(void* msg);

public:
	void SendMsg_Ping();

	void RegisterMessageListener(RoomListener* message_listener);

	void DispatchSocketMessage(void* msg);



	void SendMsg_JoinRoomReq2(JoinRoomReq2& req);

	void SendMsg_ExitRoomReq();

	void SendMsg_ModifyAdKeywordsReq(AdKeywordsReq& req);

	void SendMsg_KickoutUserReq(UserKickoutRoomInfo& req);

	void SendMsg_SetMicStateReq(UserMicState& req);

	void SendMsg_TradeGiftReq(TradeGiftRecord& req);

	void SendMsg_RoomChatReq(RoomChatMsg& req);

	void SendMsg_RoomConnMediaReq(TransMediaInfo& req);

	void SendMsg_RoomConnMediaResp(TransMediaInfo& req);

	void SendMsg_RoomConnMediaErr(TransMediaInfo& req);
	
	void SendMsg_SetRoomOPStatusReq(SetRoomOPStatusReq& req);

	void SendMsg_SetRoomBaseInfoReq(SetRoomInfoReq& req);

	void SendMsg_SetRoomBaseInfoReq_v2(SetRoomInfoReq_v2& req);

	void SendMsg_SetRoomNoticeReq(SetRoomNoticeReq& req);

	void SendMsg_ChangePubMicStateReq(ChangePubMicStateReq& req);

	void SendMsg_UpWaitMicReq(uint32 vcbid,uint32 srcuserid,uint32 touserid,int32 insertindex);

	void SendMsg_OperateWaitMicIndxReq(OperateWaitMic& req);

	void SendMsg_AddUserToBlackListReq(ThrowUserInfo& req);

	void SendMsg_SetUserPriorityReq(UserPriority& req);

	void SendMsg_CollectRoomReq(int actionid);

	void SendMsg_ChangeUserAliasStateReq(UserAliasState& req);

	void SendMsg_QueryUserAccountInfo(int userid, int vcbid);

	void SendMsg_MoneyAndPointOpReq(MoneyAndPointOp& req);

	void SendMsg_SetRoomMediaReq(RoomMediaInfo& req);

	void SendMsg_SetRoomWaitMicMaxNumLimit(SetRoomWaitMicMaxNumLimit req);

	void SendMsg_SendSealReq(SendUserSeal& req);

	void SendMsg_SeeUserIpReq(SeeUserIpReq& req);

	void SendMsg_SetForbidInviteUpMicReq(SetForbidInviteUpMic& req);

	void SendMsg_OpenChestReq(OpenChestReq& req);

	void SendMsg_MgrRelieveBlackDB(RelieveUserInfo& req);

	void SendMsg_MgrRefreshList(MgrRefreshList& req);

	void SendMsg_ForbidUserChat(ForbidUserChat& req);

	void SendMsg_SetDevStateReq(UserDevState& req);

	void SendMsg_SetUserHideStateReq(SetUserHideStateReq& req);

	void SendMsg_ReportMediaGate(int RoomId, int UserId, char* mediasvr, uint16 mediaport);

	void SendMsg_TeacherScoreReq(TeacherScoreReq& req);

	void SendMsg_UserScoreReq(TeacherScoreRecordReq& req);

	void SendMsg_TeacherGiftReq(TeacherGiftListReq& req);

	//查看用户信息
	void SendMsg_GetUserInfoReq(TextRoomList_mobile& head,GetUserInfoReq& req);

	//课程订阅查询
	void SendMsg_TeacherSubscriptionStateQueryReq(TeacherSubscriptionStateQueryReq& req);

	//课程订阅
	void SendMsg_TeacherSubscriptionReq(TeacherSubscriptionReq& req);

	void close();

	RoomConnection();

	~RoomConnection(void);
};


#endif
