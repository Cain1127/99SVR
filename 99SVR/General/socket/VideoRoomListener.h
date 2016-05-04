#ifndef __ROOM_LISTENER_H__
#define __ROOM_LISTENER_H__

#include <vector>
#include "VideoRoomMessage.pb.h"
#include "CommonroomMessage.pb.h"

class VideoRoomListener
{
public:

	//�����û��б�����
	virtual void OnRoomUserList(std::vector<RoomUserInfo>& infos) = 0;

	//�����û�֪ͨ
	virtual void OnRoomUserNoty(RoomUserInfo& info) = 0;

	//����״̬����
	virtual void OnRoomPubMicStateNoty(std::vector<RoomPubMicState>& infos) = 0;

	//�����û��˳���Ӧ
	virtual void OnRoomUserExitResp() = 0;

	//�����û��˳�֪ͨ
	virtual void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info) = 0;

	//�����û��߳���Ӧ
	virtual void OnRoomKickoutUserResp() = 0;

	//�����û��߳�֪ͨ
	virtual void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info) = 0;
	
	//�����б�
	virtual void OnWaitiMicListInfo(std::vector<int > &infos) = 0;
	
	//���췢��ʧ����Ӧ
	virtual void OnChatErr() = 0;

	//����֪ͨ����
	virtual void OnChatNotify(RoomChatMsg& info) = 0;

	//��������ɹ���Ӧ
	virtual void OnTradeGiftRecordResp(TradeGiftRecord& info) = 0;

	//��������ʧ����Ӧ
	virtual void OnTradeGiftErr(TradeGiftErr& info) = 0;

	//��������֪ͨ
	virtual void OnTradeGiftNotify(TradeGiftRecord& info) = 0;

	//ϵͳ��Ϣ֪ͨ����
	virtual void OnSysNoticeInfo(SysCastNotice& info) = 0;

	//�û��ʻ�����
	virtual void OnUserAccountInfo(UserAccountInfo& info) = 0;

	//�������֪ͨ����
	virtual void OnRoomManagerNotify() = 0;

	//����ý������֪ͨ
	virtual void OnRoomMediaInfo(RoomMediaInfo& info) = 0;

	//���乫������֪ͨ
	virtual void OnRoomNoticeNotify(RoomNotice& info) = 0;

	//����״̬����֪ͨ
	virtual void OnRoomOpState(RoomOpState& info) = 0;

	//������Ϣ����֪ͨ
	virtual void OnRoomInfoNotify(RoomBaseInfo& info) = 0;

	//�����ɱ�û�֪ͨ
	virtual void OnThrowUserNotify(ThrowUserInfo& info) = 0;

	//��������Ӧ
	virtual void OnUpWaitMicResp(UpWaitMic& info) = 0;

	//���������
	virtual void OnUpWaitMicErr(UpWaitMic& info) = 0;

	//����״̬֪ͨ
	virtual void OnChangePubMicStateNotify(ChangePubMicStateNoty& info) = 0;

	//������״̬��Ӧ
	virtual void OnSetMicStateResp() = 0;

	//������״̬����
	virtual void OnSetMicStateErr(UserMicState& info) = 0;

	//������״̬֪ͨ
	virtual void OnSetMicStateNotify(UserMicState& info) = 0;

	//�����豸״̬��Ӧ
	virtual void OnSetDevStateResp(UserDevState& info) = 0;

	//�����豸״̬����
	virtual void OnSetDevStateErr(UserDevState& info) = 0;

	//�����豸״̬֪ͨ
	virtual void OnSetDevStateNotify(UserDevState& info) = 0;

	//�����û�Ȩ��(����)��Ӧ
	virtual void OnSetUserPriorityResp(SetUserPriorityResp& info) = 0;

	//�����û�Ȩ��(����)֪ͨ
	virtual void OnSetUserPriorityNotify(UserPriority& info) = 0;

	//�鿴�û�IP��Ӧ
	virtual void OnSeeUserIpResp(SeeUserIpResp& info) = 0;

	//�鿴�û�IP����
	virtual void OnSeeUserIpErr(SeeUserIpResp& info) = 0;

	//��ɱ�����û���Ӧ
	virtual void OnThrowUserResp(ThrowUserInfoResp& info) = 0;

	//����֪ͨ
	virtual void OnForbidUserChatNotify(ForbidUserChat& info) = 0;

	//�ղط�����Ӧ
	virtual void OnFavoriteVcbResp(FavoriteRoomResp& info) = 0;

	//���÷��乫����Ӧ
	virtual void OnSetRoomNoticeResp(SetRoomNoticeResp& info) = 0;

	//���÷���״̬��Ϣ��Ӧ
	virtual void OnSetRoomOPStatusResp(SetRoomOPStatusResp& info) = 0;

	//��ѯ�û��ʻ���Ӧ
	virtual void OnQueryUserAccountResp(QueryUserAccountResp& info) = 0;

	//�յ�������ping��Ϣ�ķ���,��ʾ�������
	virtual void OnClientPingResp(ClientPingResp& info) = 0;

	//���䱻�ر���Ϣ,ֱ���˳���ǰ����
	virtual void OnCloseRoomNotify(CloseRoomNoty& info) = 0;
	
	//�յ����䲻�ɵ�����Ϣ
	virtual void OnDoNotReachRoomServer() = 0;

	//���÷�����Ϣ�ɲ����Ӧ
	virtual void OnSetRoomInfoResp(SetRoomInfoResp& info) = 0;

	//���÷�����Ϣ�ɲ��֪ͨ
	virtual void OnSetRoomInfoReq_v2(SetRoomInfoReq_v2& info) = 0;

	//�յ����Թؼ���ˢ��֪ͨ
	virtual void OnAdKeyWordOperateNoty(std::vector<AdKeywordInfo>& info) = 0;

	//�յ����Թؼ��ʸ���֪ͨ
	virtual void OnAdKeyWordOperateResp(AdKeywordsResp& info) = 0;

	//�յ���ʦ������Ӧ
	virtual void OnTeacherScoreResp(TeacherScoreResp& info) = 0;

	//�յ��û�������Ӧ
	virtual void OnTeacherScoreRecordResp(TeacherScoreRecordResp& info) = 0;

	//��������˶�Ӧ��ʦID֪ͨ
	virtual void OnRobotTeacherIdNoty(RobotTeacherIdNoty& info) = 0;

	//��ʦ��ʵ���ܰ���Ӧ
	virtual void OnTeacherGiftListResp(std::vector<TeacherGiftListResp>& infos) = 0;

	//�û��Խ�ʦ������
	virtual void OnUserScoreNotify(UserScoreNoty& info) = 0;

	//�û��Խ�ʦ�������б�
	virtual void OnUserScoreListNotify(std::vector<UserScoreNoty>& infos) = 0;

	//�û��Խ�ʦ��ƽ����
	virtual void OnTeacherAvarageScoreNoty(TeacherAvarageScoreNoty& info) = 0;

	//��������ӷ���id��Ŀǰֻ���ƶ����У�PC��û��
	virtual void OnRoomAndSubRoomId_Noty(RoomAndSubRoomIdNoty& info) = 0;

	//���䷢��ϵͳ����
	virtual void OnSysCastResp(Syscast& info) = 0;

	//��ͨ�û���������
	virtual void OnRoomUserInfoResp(RoomUserInfoResp& info) = 0;

	//���ֽ�ʦ��������
	virtual void OnTeacherInfoResp(TeacherInfoResp& info) = 0;

	//��ȡ�û���������ʧ��
	virtual void OnUserInfoErr(UserInfoErr& info) = 0;

	//�γ̶��ķ���
	virtual void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info) = 0;

	//��ѯ����״̬��Ӧ
	virtual void OnTeacherSubscriptionStateQueryResp(TeacherSubscriptionStateQueryResp& info) = 0;

	//ר�ҹ۵���Ϣ���ͣ������ڲ��㲥��
	virtual void OnExpertNewViewNoty(ExpertNewViewNoty& info) = 0;

	//��ǿս���ܰ��Ӧ
	virtual void OnTeamTopNResp(std::vector<TeamTopNResp>& infos) = 0;

	//�۵���������֪ͨ
	virtual void OnViewpointTradeGiftNoty(ViewpointTradeGiftNoty& info) = 0;

};


#endif
