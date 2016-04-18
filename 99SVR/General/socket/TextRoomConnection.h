#include <vector>
#include "Connection.h"
#include "TextRoomListener.h"
#include "TextRoomMessage.pb.h"
#include "CommonMessage.pb.h"

class TextConnection : public Connection
{
private:
	TextListener* listener;
	JoinRoomReq2 join_req;

	void dispatch_push_message(void* body);

protected:
	void on_do_connected();
	void on_dispatch_message(void* msg);

public:
	TextConnection(void);
	~TextConnection(void);

	void close(void);

	void SendMsg_Ping();

	//加入房间
	void SendMsg_JoinRoomReq(JoinRoomReq2& req, int useServerIndex=-1,int outTime=-1);

	//退出房间
	void SendMsg_ExitRoomReq();

	//屏蔽关键字请求
	void SendMsg_ModifyAdKeywordsReq(AdKeywordsReq& req);

	//设置房间信息
	void SendMsg_SetRoomBaseInfoReq_v2(SetRoomInfoReq_v2& req);

	//踢出房间
	void SendMsg_KickoutUserReq(UserKickoutRoomInfo& req);

	//赠送礼物
	void SendMsg_TradeGiftReq(TradeGiftRecord& req);

	//禁言/解禁言
	void SendMsg_ForbidUserChat(ForbidUserChat& req);

	//黑名单
	void SendMsg_AddUserToBlackListReq(ThrowUserInfo& req);

	//设置用户权限
	void SendMsg_SetUserPriorityReq(UserPriority& req);

	//查看用户IP请求
	void SendMsg_SeeUserIpReq(SeeUserIpReq& req);

	//报告网关服务器
	void SendMsg_ReportGate(int RoomId, int UserId, char* gateaddr, uint16 gateport);

	//收藏文字直播房间
	void SendMsg_CollectTextRoomReq(uint32 roomId, uint32 userId, int32 actionId);

	//查看用户信息
	void SendMsg_GetUserInfoReq(TextRoomList_mobile& head,GetUserInfoReq& req);

	//课程订阅
	void SendMsg_TeacherSubscriptionReq(TeacherSubscriptionReq& req);

	//每个收包处理
	void RegisterMessageListener(TextListener* message_listener);

	//收包消息处理
	void DispatchSocketMessage(void* msg);

	//发送ping包
	void SendMsg_TextRoomPingReq(uint32 userId, uint32 roomId);

	//讲师信息请求
	void SendMsg_TextRoomTeacherReq(uint32 userId, uint32 roomId);

	//加载直播记录请求
	void SendMsg_TextRoomLiveListReq(TextRoomLiveListReq& req);
	void SendMsg_TextRoomLiveListReq2(TextRoomList_mobile& head,TextRoomLiveListReq& req);

	//讲师发送文字直播请求
	void SendMsg_TextRoomLiveMessageReq(TextRoomLiveMessageReq& req);

	//聊天请求
	void SendMsg_TextRoomLiveChatReq(RoomLiveChatReq& req);

	//新增/修改/删除观点类型分类请求
	void SendMsg_TextRoomViewTypeReq(TextRoomViewTypeReq& req);

	//发布观点或修改观点
	void SendMsg_TextRoomViewMessageReq(TextRoomViewMessageReq& req);

	//删除观点请求
	void SendMsg_TextRoomViewDeleteReq(uint32 roomId, uint32 userId, int64 viewId);

	//查看观点详情请求
	void SendMsg_TextRoomLiveViewDetailReq(TextRoomLiveViewDetailReq& req);

	//聊天回复请求
	void SendMsg_TextLiveChatReplyReq(TextLiveChatReplyReq& req);

	//获取观点分组
	void SendMsg_TextRoomLiveViewGroupReq(uint32 roomId, uint32 userId, uint32 teacherId);

	//获取观点列表
	void SendMsg_TextRoomLiveViewListReq(TextRoomLiveViewListReq& req);

	//点击关注讲师
	void SendMsg_TextRoomInterestOnTeacher(uint32 roomId, uint32 userId, uint32 teacherId, int16 optype);

    //对直播内容点赞
	void SendMsg_LikeForTextLiveInTextRoom(uint32 roomId, uint32 userId, int64  messageId);

	//用户付费
	void SendMsg_UserPayReq(UserPayReq& req);

	//查询账户余额
	void SendMsg_GetUserAccountBalanceReq(uint32 userid);

	//查询用户商品请求
	void SendMsg_GetUserGoodStatusReq(uint32 userid, uint32 salerid, uint32 type, uint32 goodclassid);

	//个人秘籍总数请求
	void SendMsg_TextRoomSecretsTotalReq(uint32 roomId, uint32 userId, uint32 teacherId);

	//加载个人秘籍请求
	void SendMsg_TextRoomSecretsReq(TextRoomLiveListReq& req);

	//个人秘籍单次订阅请求
	void SendMsg_TextRoomSecretsBuyReq(TextRoomBuySecretsReq& req);

	//提问
	void SendMsg_UserQuestionReq(TextRoomQuestionReq& req);

	//观点详细页点赞
	void SendMsg_ZanReq(uint32 roomId, uint32 userId, int64  messageId);

	//观点详细页送花
	void SendMsg_SendFlowers(uint32 roomId, uint32 userId, int64  messageId, int32  count);

	//观点评论
	void SendMsg_ViewCommentReq(TextRoomViewCommentReq& req);

	//直播历史请求（按天列表）
	void SendMsg_GetLiveHistoryListReq(TextLiveHistoryListReq& req);

	//查看某一天的记录
	void SendMsg_GetDaylyLiveHistoryReq(TextLiveHistoryDaylyReq& req);

	//拜师请求
	void SendMsg_BeTeacherReq(uint32 roomId, uint32 userId, uint32 teacherId, uint8 opMode);

	//特权信息获取
	void SendMsg_GetPrivilegeReq(uint32 userid, uint32 packageNum);

	//拜师信息请求
	void SendMsg_GetBeTeacherInfoReqNormal(uint32 roomId, uint32 userId, uint32 teacherId);

};
