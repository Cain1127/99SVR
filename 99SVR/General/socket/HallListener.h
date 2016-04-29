
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

	virtual void OnSystemInfoResp(std::vector<HallSystemInfoListResp>& infos) = 0;

	virtual void OnInterestForResp(InterestForResp& info) = 0;

	virtual void OnBuyPrivateVipResp(BuyPrivateVipResp& info) = 0;

	virtual void OnBuyPrivateVipErr(ErrCodeResp& info) = 0;
};

#endif
