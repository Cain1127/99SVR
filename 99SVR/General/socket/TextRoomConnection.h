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

	//���뷿��
	void SendMsg_JoinRoomReq(JoinRoomReq2& req, int useServerIndex=-1,int outTime=-1);

	//�˳�����
	void SendMsg_ExitRoomReq();

	//���ιؼ�������
	void SendMsg_ModifyAdKeywordsReq(AdKeywordsReq& req);

	//���÷�����Ϣ
	void SendMsg_SetRoomBaseInfoReq_v2(SetRoomInfoReq_v2& req);

	//�߳�����
	void SendMsg_KickoutUserReq(UserKickoutRoomInfo& req);

	//��������
	void SendMsg_TradeGiftReq(TradeGiftRecord& req);

	//����/�����
	void SendMsg_ForbidUserChat(ForbidUserChat& req);

	//������
	void SendMsg_AddUserToBlackListReq(ThrowUserInfo& req);

	//�����û�Ȩ��
	void SendMsg_SetUserPriorityReq(UserPriority& req);

	//�鿴�û�IP����
	void SendMsg_SeeUserIpReq(SeeUserIpReq& req);

	//�������ط�����
	void SendMsg_ReportGate(int RoomId, int UserId, char* gateaddr, uint16 gateport);

	//�ղ�����ֱ������
	void SendMsg_CollectTextRoomReq(uint32 roomId, uint32 userId, int32 actionId);

	//�鿴�û���Ϣ
	void SendMsg_GetUserInfoReq(TextRoomList_mobile& head,GetUserInfoReq& req);

	//�γ̶���
	void SendMsg_TeacherSubscriptionReq(TeacherSubscriptionReq& req);

	//ÿ���հ�����
	void RegisterMessageListener(TextListener* message_listener);

	//�հ���Ϣ����
	void DispatchSocketMessage(void* msg);

	//����ping��
	void SendMsg_TextRoomPingReq(uint32 userId, uint32 roomId);

	//��ʦ��Ϣ����
	void SendMsg_TextRoomTeacherReq(uint32 userId, uint32 roomId);

	//����ֱ����¼����
	void SendMsg_TextRoomLiveListReq(TextRoomLiveListReq& req);
	void SendMsg_TextRoomLiveListReq2(TextRoomList_mobile& head,TextRoomLiveListReq& req);

	//��ʦ��������ֱ������
	void SendMsg_TextRoomLiveMessageReq(TextRoomLiveMessageReq& req);

	//��������
	void SendMsg_TextRoomLiveChatReq(RoomLiveChatReq& req);

	//����/�޸�/ɾ���۵����ͷ�������
	void SendMsg_TextRoomViewTypeReq(TextRoomViewTypeReq& req);

	//�����۵���޸Ĺ۵�
	void SendMsg_TextRoomViewMessageReq(TextRoomViewMessageReq& req);

	//ɾ���۵�����
	void SendMsg_TextRoomViewDeleteReq(uint32 roomId, uint32 userId, int64 viewId);

	//�鿴�۵���������
	void SendMsg_TextRoomLiveViewDetailReq(TextRoomLiveViewDetailReq& req);

	//����ظ�����
	void SendMsg_TextLiveChatReplyReq(TextLiveChatReplyReq& req);

	//��ȡ�۵����
	void SendMsg_TextRoomLiveViewGroupReq(uint32 roomId, uint32 userId, uint32 teacherId);

	//��ȡ�۵��б�
	void SendMsg_TextRoomLiveViewListReq(TextRoomLiveViewListReq& req);

	//�����ע��ʦ
	void SendMsg_TextRoomInterestOnTeacher(uint32 roomId, uint32 userId, uint32 teacherId, int16 optype);

    //��ֱ�����ݵ���
	void SendMsg_LikeForTextLiveInTextRoom(uint32 roomId, uint32 userId, int64  messageId);

	//�û�����
	void SendMsg_UserPayReq(UserPayReq& req);

	//��ѯ�˻����
	void SendMsg_GetUserAccountBalanceReq(uint32 userid);

	//��ѯ�û���Ʒ����
	void SendMsg_GetUserGoodStatusReq(uint32 userid, uint32 salerid, uint32 type, uint32 goodclassid);

	//�����ؼ���������
	void SendMsg_TextRoomSecretsTotalReq(uint32 roomId, uint32 userId, uint32 teacherId);

	//���ظ����ؼ�����
	void SendMsg_TextRoomSecretsReq(TextRoomLiveListReq& req);

	//�����ؼ����ζ�������
	void SendMsg_TextRoomSecretsBuyReq(TextRoomBuySecretsReq& req);

	//����
	void SendMsg_UserQuestionReq(TextRoomQuestionReq& req);

	//�۵���ϸҳ����
	void SendMsg_ZanReq(uint32 roomId, uint32 userId, int64  messageId);

	//�۵���ϸҳ�ͻ�
	void SendMsg_SendFlowers(uint32 roomId, uint32 userId, int64  messageId, int32  count);

	//�۵�����
	void SendMsg_ViewCommentReq(TextRoomViewCommentReq& req);

	//ֱ����ʷ���󣨰����б�
	void SendMsg_GetLiveHistoryListReq(TextLiveHistoryListReq& req);

	//�鿴ĳһ��ļ�¼
	void SendMsg_GetDaylyLiveHistoryReq(TextLiveHistoryDaylyReq& req);

	//��ʦ����
	void SendMsg_BeTeacherReq(uint32 roomId, uint32 userId, uint32 teacherId, uint8 opMode);

	//��Ȩ��Ϣ��ȡ
	void SendMsg_GetPrivilegeReq(uint32 userid, uint32 packageNum);

	//��ʦ��Ϣ����
	void SendMsg_GetBeTeacherInfoReqNormal(uint32 roomId, uint32 userId, uint32 teacherId);

};
