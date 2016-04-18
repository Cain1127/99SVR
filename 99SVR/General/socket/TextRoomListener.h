#ifndef __TEXTROOM_LISTENER_H__
#define __TEXTROOM_LISTENER_H__

#include <vector>
#include "TextRoomMessage.pb.h"
#include "CommonMessage.pb.h"

class TextListener
{
public:	
	virtual void OnMessageComming(void* msg) = 0;

	//�յ�������ping��Ϣ�ķ���,��ʾ�������
	virtual void OnClientPingResp(ClientPingResp& info) = 0;

	//���뷿��ʧ��
	virtual void OnJoinRoomErr(JoinRoomErr& info) = 0;

	//���뷿��ɹ�
	virtual void OnJoinRoomResp(JoinRoomResp& info) = 0;

	//�û����뷿��֪ͨ
	virtual void OnRoomUserNoty(RoomUserInfo& info) = 0;

	//�����û��б�
	virtual void OnRoomUserList(std::vector<RoomUserInfo>& infos) = 0;

	//�յ����Թؼ���ˢ��֪ͨ
	virtual void OnAdKeyWordOperateNoty(AdKeywordsNotify& info) = 0;

	//�յ����Թؼ��ʸ���֪ͨ
	virtual void OnAdKeyWordOperateResp(AdKeywordsResp& info) = 0;

	//���÷�����Ϣ��Ӧ
	virtual void OnSetRoomInfoResp(SetRoomInfoResp& info) = 0;

	//������Ϣ����֪ͨ
	virtual void OnRoomInfoNotify(RoomBaseInfo& info) = 0;

	//����״̬����֪ͨ
	virtual void OnRoomOpState(RoomOpState& info) = 0;

	//����֪ͨ
	virtual void OnForbidUserChatNotify(ForbidUserChat& info) = 0;

	//��ɱ�����û���Ӧ
	virtual void OnThrowUserResp(ThrowUserInfoResp& info) = 0;

	//�����ɱ�û�֪ͨ
	virtual void OnThrowUserNotify(ThrowUserInfo& info) = 0;

	//�����û�Ȩ��(����)��Ӧ
	virtual void OnSetUserPriorityResp(SetUserPriorityResp& info) = 0;

	//�����û�Ȩ��(����)��Ӧ
	virtual void OnSetUserPriorityNotify(SetUserPriorityResp& info) = 0;

	//�쿴�û�IP��Ӧ
	virtual void OnSeeUserIpResp(SeeUserIpResp& info) = 0;

	//�쿴�û�IP����
	virtual void OnSeeUserIpErr(SeeUserIpResp& info) = 0;

	//�������ﷵ����Ӧ��Ϣ
	virtual void OnTradeGiftRecordResp(TradeGiftRecord& info) = 0;

	//�������ﷵ�ش�����Ϣ
	virtual void OnTradeGiftErr(TradeGiftErr& info) = 0;

	//��������֪ͨ����
	virtual void OnTradeGiftNotify(TradeGiftRecord& info) = 0;

	//�����û��߳�֪ͨ
	virtual void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info) = 0;

	//�����û��˳�֪ͨ
	virtual void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info) = 0;

	//��ʦ���뷿��֪ͨ
	virtual void OnTeacherComeNotify(TeacherComeNotify& info) = 0;

	//��ʦ��Ϣ
	virtual void OnTextRoomTeacherNoty(TextRoomTeacherNoty& info) = 0;

	//����ֱ����¼�б�
	virtual void OnTextRoomLiveListNoty(std::vector<TextRoomLiveListNoty>& infos) = 0;

	//����ֱ���ص��¼�б�
	virtual void OnTextRoomLivePointNoty(std::vector<TextRoomLivePointNoty>& infos) = 0;

	//��������Ԥ���¼�б�
	virtual void OnTextRoomLiveForecastNoty(std::vector<TextRoomLivePointNoty>& infos) = 0;

	//ֱ����ʷ�б�(�ſ�)�б�
	virtual void OnTextLiveHistoryListResp(std::vector<TextLiveHistoryListResp>& infos) = 0;

	//������ʷֱ����¼�б�
	virtual void OnTextLiveHistoryDaylyResp(std::vector<TextRoomLiveListNoty>& infos) = 0;

	//�۵����ͷ����б�
	virtual void OnTextRoomViewGroupResp(std::vector<TextRoomViewGroupResp>& infos) = 0;

	//�۵��б�
	virtual void OnTextRoomLiveViewResp(std::vector<TextRoomLiveViewResp>& infos) = 0;

	//�����б�
	virtual void OnTextRoomViewInfoResp(std::vector<TextRoomViewInfoResp>& infos) = 0;

	//�۵�����
	virtual void OnTextRoomLiveViewDetailResp(TextRoomLiveViewResp& info) = 0;

	//��ʦ��Ϣ(��ͨ�û�)ͷ
	virtual void OnNormalUserGetBeTeacherInfoRespHead(NormalUserGetBeTeacherInfoRespHead& info) = 0;

	//��ʦ��Ϣ(��ͨ�û�)�б�
	virtual void OnNormalUserGetBeTeacherInfoRespItem(std::vector<NormalUserGetBeTeacherInfoRespItem>& infos) = 0;

	//��ʦ��Ϣ(��ʦ)ͷ
	virtual void OnTeacherGetBeTeacherInfoRespHead(TeacherGetBeTeacherInfoRespHead& info) = 0;

	//��ʦ��Ϣ(��ʦ)�б�
	virtual void OnTeacherGetBeTeacherInfoRespItem(std::vector<TeacherGetBeTeacherInfoRespItem>& infos) = 0;

	//��Ȩ��Ϣ�б�
	virtual void OnGetPackagePrivilegeResp(std::vector<GetPackagePrivilegeResp>& infos) = 0;

	//ר�������б�
	virtual void OnTextRoomEmoticonListResp(std::vector<TextRoomEmoticonListResp>& infos) = 0;

	//���ظ����ؼ���¼�б�
	virtual void OnTextRoomSecretsListResp(std::vector<TextRoomSecretsListResp>& infos) = 0;

	//���ظ����ؼ��ѹ����¼�б�
	virtual void OnTextRoomSecBuyListResp(std::vector<TextRoomSecretsListResp>& infos) = 0;

	//���ظ����ؼ�������Ϣ��Ӧ
	virtual void OnTextRoomSecretsTotalResp(TextRoomSecretsTotalResp& info) = 0;

	//�����ؼ����ζ�����Ӧ
	virtual void OnTextRoomBuySecretsResp(TextRoomBuySecretsResp& info) = 0;

	//��ʦ��������ؼ�֪ͨ
	virtual void OnTextRoomSecretsPHPResp(TextRoomSecretsPHPResp& info) = 0;

	//��ʦ��������ֱ����Ӧ
	virtual void OnTextRoomLiveMessageResp(TextRoomLiveMessageResp& info) = 0;

	//�û���ֱ�����ݵ�����Ӧ
	virtual void OnTextRoomZanForResp(TextRoomZanForResp& info) = 0;

	//����������Ӧ
	virtual void OnTextRoomLiveChatResp(TextRoomLiveChatResp& info) = 0;

	//����ظ���Ӧ
	virtual void OnTextLiveChatReplyResp(TextLiveChatReplyResp& info) = 0;

	//��ʦ�޸ĺ������۵����ͷ�����Ӧ
	virtual void OnTextRoomViewTypeResp(TextRoomViewTypeResp& info) = 0;

	//��ʦ����۵���Ӧ
	virtual void OnTextRoomViewMessageReqResp(TextRoomViewMessageReqResp& info) = 0;

	//��ʦ����۵���ӦPHP
	virtual void OnTextRoomViewPHPResp(TextRoomViewPHPResp& info) = 0;

	//�۵�������Ӧ
	virtual void OnTextRoomLiveActionResp(TextRoomLiveActionResp& info) = 0;

	//�۵������Ӧ
	virtual void OnTextLiveViewZanForResp(TextRoomZanForResp& info) = 0;

	//�۵������Ӧ
	virtual void OnTextLiveViewFlowerResp(TextLiveViewFlowerResp& info) = 0;

	//�۵�ɾ����Ӧ
	virtual void OnTextRoomViewDeleteResp(TextRoomViewDeleteResp& info) = 0;

	//�û�������Ӧ
	virtual void OnTextRoomQuestionResp(TextRoomQuestionResp& info) = 0;

	//�û������ע��Ӧ
	virtual void OnTextRoomInterestForResp(TextRoomInterestForResp& info) = 0;

	//��Ʒ״̬
	virtual void OnTextRoomGetUserGoodStatusResp(TextRoomGetUserGoodStatusResp& info) = 0;

	//�û�����
	virtual void OnUserPayResp(UserPayResp& info) = 0;

	//��Ѱ�˻����
	virtual void OnGetUserAccountBalanceResp(GetUserAccountBalanceResp& info) = 0;

	//��ͨ�û���������
	virtual void OnRoomUserInfoResp(RoomUserInfoResp& info) = 0;

	//���ֽ�ʦ��������
	virtual void OnTeacherInfoResp(TeacherInfoResp& info) = 0;

	//��ȡ�û���������ʧ��
	virtual void OnUserInfoErr(UserInfoErr& info) = 0;

	//��ʦ���󷵻�
	virtual void OnBeTeacherResp(BeTeacherResp& info) = 0;

	//�����ʦ��Ϣʧ��
	virtual void OnGetBeTeacherInfoReqFailed() = 0;

	//��Ƶ��������֪ͨ
	virtual void OnVideoRoomOnMicClientResp(VideoRoomOnMicClientResp& info) = 0;

	//�γ̶��ķ���
	virtual void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info) = 0;

};


#endif
