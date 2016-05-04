
#ifndef __HALL_LISTENER_H__
#define __HALL_LISTENER_H__

#include <vector>
#include "LoginMessage.pb.h"
#include "VideoRoomMessage.pb.h"

class HallListener
{

public:

	//�����û�����
	virtual void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req) = 0;

	//�����û�����
	virtual void OnSetUserPwdResp(SetUserPwdResp& info) = 0;

	//��ȡ�������ص�ַ
	virtual void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info) = 0;

	//��ȡ�û�������Ϣ���ֻ�������ǩ���ȣ�
	virtual void OnGetUserMoreInfResp(GetUserMoreInfResp& info) = 0;

	//�û��˳����
	virtual void OnUserExitMessageResp(ExitAlertResp& info) = 0;

	//����С�������
	virtual void OnHallMessageNotify(MessageNoty& info) = 0;

	//����δ����¼��
	virtual void OnMessageUnreadResp(MessageUnreadResp& info) = 0;

	//�鿴�����ظ�
	virtual void OnInteractResp(std::vector<InteractResp>& infos) = 0;

	//�鿴�ʴ�����
	virtual void OnHallAnswerResp(std::vector<AnswerResp>& infos) = 0;

	//�鿴�۵�ظ�
	//virtual void OnViewShowResp(std::vector<ViewShowResp>& infos) = 0;

	//�鿴�ҵķ�˿
	//virtual void OnTeacherFansResp(std::vector<TeacherFansResp>& infos) = 0;

	//�鿴�ҵĹ�ע���ѹ�ע��ʦ��
	//virtual void OnInterestResp(std::vector<InterestResp>& infos) = 0;

	//�鿴�ҵĹ�ע���޹�ע��ʦ��
	//virtual void OnUnInterestResp(std::vector<UnInterestResp>& infos) = 0;

	//�鿴����Ԥ�⣨�ѹ�ע�Ľ�ʦ��
	//virtual void OnTextLivePointListResp(std::vector<TextLivePointListResp>& infos) = 0;

	//�鿴�ѹ���ĸ����ؼ�
	//virtual void OnSecretsListResp(std::vector<HallSecretsListResp>& infos) = 0;

	//�鿴ϵͳ��Ϣ
	virtual void OnSystemInfoResp(std::vector<HallSystemInfoListResp>& infos) = 0;

	//��ʦ�ظ��������۵�ظ��ͻش����ʣ�
	//virtual void OnViewAnswerResp(ViewAnswerResp& info) = 0;

	//��ע���޹�ע��ʦʱ�������н�ʦ�б������ע��
	virtual void OnInterestForResp(InterestForResp& info) = 0;

	//��ȡ��ʦ�ķ�˿������Ӧ
	//virtual void OnFansCountResp(FansCountResp& info) = 0;

	//˽�˶��ƹ�����Ӧ
	virtual void OnBuyPrivateVipResp(BuyPrivateVipResp& info) = 0;

	//˽�˶��ƹ���ʧ��
	virtual void OnBuyPrivateVipErr(ErrCodeResp& info) = 0;

	//�۵�����������Ӧ
	virtual void OnViewpointTradeGiftResp(ViewpointTradeGiftNoty& info) = 0;

	//�۵���������ʧ��
	virtual void OnViewpointTradeGiftErr(ErrCodeResp& info) = 0;
	
};

#endif
