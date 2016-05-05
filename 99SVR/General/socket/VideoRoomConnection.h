#ifndef __ROOM_CONNECTION_H__
#define __ROOM_CONNECTION_H__

#include <vector>
#include "Connection.h"
#include "VideoRoomListener.h"
#include "VideoRoomJoinListener.h"
#include "HallListener.h"
#include "PushListener.h"
#include "VideoRoomMessage.pb.h"
#include "LoginConnection.h"

class VideoRoomConnection : public Connection
{
private:

	uint32 main_room_id;

	VideoRoomListener* room_listener;
	VideoRoomJoinListener* room_join_listener;

	void dispatch_push_message(void* body);
	void dispatch_error_message(void* body);

protected:

	void on_do_connected();
	void on_dispatch_message(void* msg);

public:
	//ping请求
	void SendMsg_Ping();

	void RegisterRoomListener(VideoRoomListener* room_listener);

	void RegisterRoomJoinListener(VideoRoomJoinListener* room_join_listener);

	void DispatchSocketMessage(void* msg);

	//加入房间预处理请求
	void SendMsg_RreJoinRoomReq(PreJoinRoomReq& req);

	//加入房间请求版本
	void SendMsg_JoinRoomReq(JoinRoomReq& req);

	//加入房间成功后请求推送信息
	void SendMsg_AfterJoinRoomReq();

	//用户自己退出房间
	void SendMsg_ExitRoomReq(uint32 roomid);

	//关键字操作请求
	void SendMsg_ModifyAdKeywordsReq(AdKeywordsReq& req);

	//踢出用户请求
	void SendMsg_KickoutUserReq(UserKickoutRoomInfo& req);

	 //设置上/下麦状态请求
	void SendMsg_SetMicStateReq(UserMicState& req);

	//赠送礼物请求
	void SendMsg_TradeGiftReq(TradeGiftRecord& req);

	//聊天发出消息请求
	void SendMsg_RoomChatReq(RoomChatMsg& req);

	//音视频媒体请求
	void SendMsg_RoomConnMediaReq(TransMediaInfo& req);

	//音视频媒体响应
	void SendMsg_RoomConnMediaResp(TransMediaInfo& req);

	//音视频媒体出错
	void SendMsg_RoomConnMediaErr(TransMediaInfo& req);
	
	//设置房间运行属性(状态)请求
	void SendMsg_SetRoomOPStatusReq(SetRoomOPStatusReq& req);

	 //设置房间信息请求
	void SendMsg_SetRoomBaseInfoReq(SetRoomInfoReq& req);

	//设置房间信息请求飞叉版
	void SendMsg_SetRoomBaseInfoReq_v2(SetRoomInfoReq_v2& req);

	//设置房间公告信息请求
	void SendMsg_SetRoomNoticeReq(SetRoomNoticeReq& req);

	//上麦请求
	void SendMsg_UpWaitMicReq(uint32 vcbid,uint32 srcuserid,uint32 touserid,int32 insertindex);

	//封杀用户，加入黑名单请求
	void SendMsg_AddUserToBlackListReq(ThrowUserInfo& req);

	 //设置用户权限请求
	void SendMsg_SetUserPriorityReq(UserPriority& req);

	//收藏房间请求
	void SendMsg_CollectRoomReq(int actionid);

	// 用户账户查询(银行查询)请求
	void SendMsg_QueryUserAccountInfo(int userid, int vcbid);

	//设置房间媒体服务器请求
	void SendMsg_SetRoomMediaReq(RoomMediaInfo& req);

	//查看用户IP请求
	void SendMsg_SeeUserIpReq(SeeUserIpReq& req);

	//禁言用户请求
	void SendMsg_ForbidUserChat(ForbidUserChat& req);

	//设置设备状态
	void SendMsg_SetDevStateReq(UserDevState& req);

	//客户端报告媒体服务器和网关服务器
	void SendMsg_ReportMediaGate(int RoomId, int UserId, char* mediasvr, uint16 mediaport);

	//讲师发送评分处理请求
	void SendMsg_TeacherScoreReq(TeacherScoreReq& req);

	//用户评分请求
	void SendMsg_UserScoreReq(TeacherScoreRecordReq& req);

	//讲师忠实度周版请求
	void SendMsg_TeacherGiftReq(TeacherGiftListReq& req);

	//查看用户信息
	void SendMsg_GetUserInfoReq(TextRoomList_mobile& head,GetUserInfoReq& req);

	//课程订阅查询
	void SendMsg_TeacherSubscriptionStateQueryReq(TeacherSubscriptionStateQueryReq& req);

	//课程订阅
	void SendMsg_TeacherSubscriptionReq(TeacherSubscriptionReq& req);

	//最强战队周榜请求
	void SendMsg_TeamTopNReq(TeamTopNReq& req);

	//提问响应
	void SendMsg_AskQuestionReq(AskQuestionReq& req);

	void close();


	string GetVideoRoomShareUrl();

	VideoRoomConnection();

	~VideoRoomConnection(void);
};


#endif
