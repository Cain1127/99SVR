#if 0
#include "platform.h"
#include "Http.h"
#include "LoginConnection.h"
#include "VideoRoomConnection.h"
#include "TextRoomConnection.h"
#include "crc32.h"
#include "StatisticReport.h"

#include <exception>
#include <vector>

/*
#include "rapidjson/document.h"
#include "rapidjson/prettywriter.h"
#include "rapidjson/stringbuffer.h"
*/

#include <fstream>
#include <cassert>
#include "json/json.h"

using namespace::std;

LoginConnection conn;
RoomConnection vedio_room_conn;
TextConnection text_room_conn;


class TestLoginListener : public LoginListener
{

public:

	void OnMessageComming(void* msg)
	{
		conn.DispatchSocketMessage(msg);
	}

	void OnLogonSuccess(UserLogonSuccess2& info) 
	{
		info.Log();
	}

	void OnLogonErr(UserLogonErr2& info) 
	{
		info.Log();
	}

	void OnRoomGroupList(RoomGroupItem items[], int count) 
	{
		for (int i = 0; i < count; i++)
		{
			items[i].Log();
		}
	}

	void OnQuanxianId2List(QuanxianId2Item items[], int count) 
	{
		for (int i = 0; i < count; i++)
		{
			items[i].Log();
		}
	}

	void OnQuanxianAction2List(QuanxianAction2Item items[], int count) 
	{
		for (int i = 0; i < count; i++)
		{
			//items[i].Log();
		}
	}

	void OnLogonTokenNotify(SessionTokenResp& info) 
	{
		info.Log();
	}

	void OnLogonFinished() 
	{
		LOG("OnlogonFinished\n");
	}

};

class TestHallListener: public HallListener
{

	void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req)
	{
		info.Log();
	}

	void OnSetUserPwdResp(SetUserPwdResp& info)
	{
		info.Log();
	}

	void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info)
	{
		info.Log();
	}

	void OnGetUserMoreInfResp(GetUserMoreInfResp& info)
	{
		info.Log();
	}

	void OnUserExitMessageResp(ExitAlertResp& info)
	{
		info.Log();
	}

	void OnHallMessageNotify(MessageNoty& info)
	{
		info.Log();
	}

	void OnMessageUnreadResp(MessageUnreadResp& info)
	{
		info.Log();
	}

	void OnInteractResp(std::vector<InteractResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnHallAnswerResp(std::vector<AnswerResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnViewShowResp(std::vector<ViewShowResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnTeacherFansResp(std::vector<TeacherFansResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnInterestResp(std::vector<InterestResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnUnInterestResp(std::vector<UnInterestResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnTextLivePointListResp(std::vector<TextLivePointListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnSecretsListResp(std::vector<HallSecretsListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnSystemInfoResp(std::vector<HallSystemInfoListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	void OnViewAnswerResp(ViewAnswerResp& info)
	{
		info.Log();
	}

	void OnInterestForResp(InterestForResp& info)
	{
		info.Log();
	}
	void OnFansCountResp(FansCountResp& info)
	{
		info.Log();
	}
};

class TestRoomListener : public RoomListener
{
	void OnMessageComming(void* msg){vedio_room_conn.DispatchSocketMessage(msg);}
	
	void OnJoinRoomResp(JoinRoomResp& info){info.Log();}//���뷿��ɹ�
	void OnJoinRoomErr(JoinRoomErr& info){info.Log();}//���뷿��ʧ��
	void OnRoomUserList(std::vector<RoomUserInfo>& infos)//�����û��б�����
	{
		for(int i = 0; i < infos.size(); i++)
		{
			//infos[i].Log();//OK
		}
	}
	void OnRoomUserNoty(RoomUserInfo& info)//�����û�֪ͨ
	{
		info.Log();//OK
	}

	void OnRoomPubMicStateNoty(std::vector<RoomPubMicState>& infos)//����״̬����
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();//OK
		}
	}
	void OnRoomUserExitResp()//
	{
	}
	void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info)//�����û��˳�֪ͨ
	{
		info.Log();//OK
	}

	void OnRoomKickoutUserResp(){}//
	void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info)//�����û��߳�֪ͨ
	{
		info.Log();//OK
	}

	// ��ʱ�ѻķ�
	//void OnFlyGiftListInfoReq(TradeGiftRecord& info){}//��������Ϣ
	
	void OnWaitiMicListInfo(std::vector<int > &infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			LOG("%d", infos[i]);//OK
		}
	}//�����б�
	

	void OnChatErr(){}//
	void OnChatNotify(RoomChatMsg& info)
	{
		info.Log();//OK
	}//����֪ͨ����

	//������
	void OnTradeGiftRecordResp(TradeGiftRecord& info)
	{
		info.Log();
	}
	void OnTradeGiftErr(TradeGiftErr& info)
	{
		info.Log();
	}
	void OnTradeGiftNotify(TradeGiftRecord& info)
	{
		info.Log();//OK
	}

	//�ͻ�
	void OnTradeFlowerResp(TradeFlowerRecord& info)
	{
		info.Log();
	}
	void OnTradeFlowerErr(TradeFlowerRecord& info)
	{
		info.Log();
	}
	void OnTradeFlowerNotify(TradeFlowerRecord& info)
	{
		info.Log();
	}

	//�̻�
	void OnTradeFireworksErr(TradeFireworksErr& info)
	{
		info.Log();
	}
	void OnTradeFireworksNotify(TradeFireworksNotify& info)
	{
		info.Log();
	}

	void OnLotteryGiftNotify(LotteryGiftNotice& info)
	{
		info.Log();
	}//�����н�֪ͨ����

	void OnBoomGiftNotify(BoomGiftNotice& info)
	{
		info.Log();
	}//��ը�н�֪ͨ����

	void OnSysNoticeInfo(SysCastNotice& info)
	{
		info.Log();//OK
	}//ϵͳ��Ϣ֪ͨ����

	void OnUserAccountInfo(UserAccountInfo& info)
	{
		info.Log();
	}//�û��ʻ�����

	void OnRoomManagerNotify()
	{
		//info.Log();
	}//�������֪ͨ����

	void OnRoomMediaInfo(RoomMediaInfo& info)
	{
		info.Log();
	}//����ý������֪ͨ

	void OnRoomNoticeNotify(RoomNotice& info)
	{
		info.Log();//OK
	}//���乫������֪ͨ

	void OnRoomOpState(RoomOpState& info)
	{
		info.Log();
	}//����״̬����֪ͨ

	void OnRoomInfoNotify(RoomBaseInfo& info)
	{
		info.Log();//OK
	}//������Ϣ����֪ͨ

	void OnThrowUserNotify(ThrowUserInfo& info)
	{
		info.Log();
	}//�����ɱ�û�֪ͨ

	void OnUpWaitMicResp(UpWaitMic& info)
	{
		info.Log();
		//LOG("OnUpWaitMicResp = %d", ret);
	}//��������Ӧ
	void OnUpWaitMicErr(UpWaitMic& info)
	{
		info.Log();
		//LOG("OnUpWaitMicErr = %d", ret);
	}//���������

	void OnChangePubMicStateNotify(ChangePubMicStateNoty& info)
	{
		info.Log();//OK
	}//����״̬֪ͨ

	//����ý��
	void OnTransMediaReq(){}//����ý������
	void OnTransMediaResp(){}//����ý����Ӧ
	void OnTransMediaErr(){}//����ý�����

	//������״̬
	void OnSetMicStateResp(){}//������״̬��Ӧ
	void OnSetMicStateErr(UserMicState& info)
	{
		info.Log();
	}//������״̬����
	void OnSetMicStateNotify(UserMicState& info)
	{
		info.Log();//OK
	}//������״̬֪ͨ

	//�����豸״̬
	void OnSetDevStateResp(UserDevState& info)
	{
		info.Log();//OK
	}//�����豸״̬��Ӧ
	void OnSetDevStateErr(UserDevState& info)
	{
		info.Log();//OK
	}//�����豸״̬����
	void OnSetDevStateNotify(UserDevState& info)
	{
		info.Log();//OK
	}//�����豸״̬֪ͨ

	//�����û��س�
	void OnSetUserAliasResp(UserAliasState& info)
	{
		info.Log();//OK
	}//�����û��س���Ӧ
	void OnSetUserAliasErr(UserAliasState& info)
	{
		info.Log();//OK
	}//�����û��سƴ���
	void OnSetUserAliasNotify(UserAliasState& info)
	{
		info.Log();//OK
	}//�����û��س�֪ͨ

	//�����û�Ȩ��(����)
	void OnSetUserPriorityResp(SetUserPriorityResp& info)
	{
		info.Log();//OK
	}//�����û�Ȩ��(����)��Ӧ
	void OnSetUserPriorityNotify(SetUserPriorityResp& info)
	{
		info.Log();//OK
	}//�����û�Ȩ��(����)��Ӧ

	//�쿴�û�IP
	void OnSeeUserIpResp(SeeUserIpResp& info)
	{
		info.Log();//OK
	}//�쿴�û�IP��Ӧ
	void OnSeeUserIpErr(SeeUserIpResp& info)
	{
		info.Log();//OK
	}//�쿴�û�IP����

	void OnThrowUserResp(ThrowUserInfoResp& info)
	{
		info.Log();
	}//��ɱ�����û���Ӧ

	void OnForbidUserChatNotify(ForbidUserChat& info)
	{
		info.Log();//OK
	}//����֪ͨ

	//void OnFavoriteVcbResp(){}//�ղط�����Ӧ�������������ʵ��û����Ӧ��

	void OnSetRoomNoticeResp(SetRoomNoticeResp& info)
	{
		info.Log();//OK
	}//���÷��乫����Ӧ

	void OnSetRoomInfoResp(SetRoomInfoResp& info)
	{
		info.Log();//OK
	}//���÷�����Ϣ��Ӧ

	void OnSetRoomOPStatusResp(SetRoomOPStatusResp& info)
	{
		info.Log();//OK
	}//���÷���״̬��Ϣ��Ӧ

	void OnQueryUserAccountResp(QueryUserAccountResp& info)
	{
		info.Log();//OK
	}//��ѯ�û��ʻ���Ӧ

	void OnSetWatMicMaxNumLimitNotify(SetRoomWaitMicMaxNumLimit& info)
	{
		info.Log();
	}//���÷��������������ÿ������������ ֪ͨ

	void OnChangeWaitMicIndexResp(ChangeWaitMicIndexResp& info)
	{
		info.Log();
	}//�޸�����������Ӧ
	
	void OnSetForbidInviteUpMicNotify(SetForbidInviteUpMic& info)
	{
		info.Log();
	}//���ý�ֹ����֪ͨ

	void OnSiegeInfoNotify(SiegeInfo& info)
	{
		info.Log();
	}//������Ϣ֪ͨ

	void OnOpenChestResp(OpenChestResp& info)
	{
		info.Log();
	}//��������Ӧ

	void OnQueryUserMoreInfoResp(UserMoreInfo& info)
	{
		info.Log();
	}//

	void OnSetUserProfileResp(SetUserProfileResp& info)
	{
		info.Log();
	}//�����û�������Ϣ��Ӧ

	void OnClientPingResp(ClientPingResp& info)
	{
		info.Log();//OK
	}//�յ�������ping��Ϣ�ķ���,��ʾ�������

	void OnCloseRoomNotify(CloseRoomNoty& info)
	{
		info.Log();
	}//���䱻�ر���Ϣ,ֱ���˳���ǰ����
	
	void OnDoNotReachRoomServer()
	{
		//info.Log();
	}//�յ����䲻�ɵ�����Ϣ
	
	void OnLotteryPoolNotify(LotteryPoolInfo& info)
	{
		info.Log();
	}//�յ����˱��佱����Ϣ

	//��ʱû��
	void OnSetUserHideStateResp(SetUserHideStateResp& info)
	{
		info.Log();
	}//

	void OnSetUserHideStateNoty(SetUserHideStateNoty& info)
	{
		info.Log();
	}//

	//��ʱ����
	void OnUserAddChestNumNoty(UserAddChestNumNoty& info)
	{
		info.Log();
	}//�յ��û������±���֪ͨ

	void OnAddClosedFriendNoty(AddClosedFriendNotify& info)
	{
		info.Log();
	}//�յ�����������������֪ͨ

	void OnAdKeyWordOperateNoty(AdKeywordsNotify& info)
	{
		info.Log();//OK
	}//�յ����Թؼ���ˢ��֪ͨ

	void OnAdKeyWordOperateResp(AdKeywordsResp& info)
	{
		info.Log();//OK
	}//�յ����Թؼ��ʸ���֪ͨ

	void OnTeacherScoreResp(TeacherScoreResp& info)
	{
		info.Log();//OK
	}//�յ���ʦ������Ӧ

	void OnTeacherScoreRecordResp(TeacherScoreRecordResp& info)
	{
		info.Log();//OK
	}//�յ��û�������Ӧ

	void OnRobotTeacherIdNoty(RobotTeacherIdNoty& info)
	{
		info.Log();//OK
	}//��������˶�Ӧ��ʦID֪ͨ

	void OnTeacherGiftListResp(std::vector<TeacherGiftListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();//OK
		}
	}//��ʦ��ʵ���ܰ���Ӧ

	void OnHitGoldEggToClientNoty(HitGoldEggClientNoty& info)
	{
		info.Log();
	}//�ҽ𵰸���99������ֵ

	void OnUserScoreNotify(UserScoreNoty& info)
	{
		info.Log();//OK
	}//�û��Խ�ʦ������

	void OnUserScoreListNotify(std::vector<UserScoreNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();//OK
		}
	}//�û��Խ�ʦ�������б�

	void OnTeacherAvarageScoreNoty(TeacherAvarageScoreNoty& info)
	{
		info.Log();//OK
	}//�û��Խ�ʦ��ƽ����

	void OnRoomAndSubRoomId_Noty(RoomAndSubRoomIdNoty& info)
	{
		info.Log();//OK
	}//

	void OnSysCastResp(Syscast& info)
	{
		info.Log();//OK
	}//ϵͳ����
	
	//��ͨ�û���������
	void OnRoomUserInfoResp(RoomUserInfoResp& info)
	{
		info.Log();//OK
	}
	
	//���ֽ�ʦ��������
	void OnTeacherInfoResp(TeacherInfoResp& info)
	{
		info.Log();//OK
	}

	//��ȡ�û���������ʧ��
	void OnUserInfoErr(UserInfoErr& info)
	{
		info.Log();//OK
	}

	//�γ̶��ķ���
	void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info)
	{
		info.Log();//OK
	}

	//��ѯ����״̬��Ӧ
	void OnTeacherSubscriptionStateQueryResp(TeacherSubscriptionStateQueryResp& info)
	{
		info.Log();//OK
	}
};


class TestTextListener : public TextListener
{
	void OnMessageComming(void* msg)
	{
		text_room_conn.DispatchSocketMessage(msg);
	}

	//�յ�������ping��Ϣ�ķ���,��ʾ�������
	void OnClientPingResp(ClientPingResp& info)
	{
		info.Log();
	}

	//���뷿��ʧ��
	void OnJoinRoomErr(JoinRoomErr& info)
	{
		info.Log();
	}

	//���뷿��ɹ�
	void OnJoinRoomResp(JoinRoomResp& info)
	{
		info.Log();
	}

	//�û����뷿��֪ͨ
	void OnRoomUserNoty(RoomUserInfo& info)
	{
		info.Log();//OK
	}

	//�����û��б�����
	void OnRoomUserList(std::vector<RoomUserInfo>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();//OK
		}
	}

	//�յ����Թؼ���ˢ��֪ͨ
	void OnAdKeyWordOperateNoty(AdKeywordsNotify& info)
	{
		info.Log();
	}

	//�յ����Թؼ��ʸ���֪ͨ
	void OnAdKeyWordOperateResp(AdKeywordsResp& info)
	{
		info.Log();
	}

	//���÷�����Ϣ��Ӧ
	void OnSetRoomInfoResp(SetRoomInfoResp& info)
	{
		info.Log();
	}

	//������Ϣ����֪ͨ
	void OnRoomInfoNotify(RoomBaseInfo& info)
	{
		info.Log();
	}

	//����״̬����֪ͨ
	void OnRoomOpState(RoomOpState& info)
	{
		info.Log();
	}

	//����֪ͨ
	void OnForbidUserChatNotify(ForbidUserChat& info)
	{
		info.Log();
	}

	//��ɱ�����û���Ӧ
	void OnThrowUserResp(ThrowUserInfoResp& info)
	{
		info.Log();
	}

	//�����ɱ�û�֪ͨ
	void OnThrowUserNotify(ThrowUserInfo& info)
	{
		info.Log();
	}

	//�����û�Ȩ��(����)��Ӧ
	void OnSetUserPriorityResp(SetUserPriorityResp& info)
	{
		info.Log();
	}

	//�����û�Ȩ��(����)��Ӧ
	void OnSetUserPriorityNotify(SetUserPriorityResp& info)
	{
		info.Log();
	}

	//�쿴�û�IP��Ӧ
	void OnSeeUserIpResp(SeeUserIpResp& info)
	{
		info.Log();
	}

	//�쿴�û�IP����
	void OnSeeUserIpErr(SeeUserIpResp& info)
	{
		info.Log();
	}

	//�������ﷵ����Ӧ��Ϣ
	void OnTradeGiftRecordResp(TradeGiftRecord& info)
	{
		info.Log();
	}

	//�������ﷵ�ش�����Ϣ
	void OnTradeGiftErr(TradeGiftErr& info)
	{
		info.Log();
	}

	//��������֪ͨ����
	void OnTradeGiftNotify(TradeGiftRecord& info)
	{
		info.Log();
	}

	//�����û��߳�֪ͨ
	void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info)
	{
		info.Log();
	}

	//�����û��˳�֪ͨ
	void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info)
	{
		info.Log();
	}

	//��ʦ���뷿��֪ͨ
	void OnTeacherComeNotify(TeacherComeNotify& info)
	{
		info.Log();
	}

	//��ʦ��Ϣ
	void OnTextRoomTeacherNoty(TextRoomTeacherNoty& info)
	{
		info.Log();
	}

	//����ֱ����¼�б�
	void OnTextRoomLiveListNoty(std::vector<TextRoomLiveListNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//����ֱ���ص��¼�б�
	void OnTextRoomLivePointNoty(std::vector<TextRoomLivePointNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//��������Ԥ���¼�б�
	void OnTextRoomLiveForecastNoty(std::vector<TextRoomLivePointNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//ֱ����ʷ�б�(�ſ�)�б�
	void OnTextLiveHistoryListResp(std::vector<TextLiveHistoryListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//������ʷֱ����¼�б�
	void OnTextLiveHistoryDaylyResp(std::vector<TextRoomLiveListNoty>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//�۵����ͷ����б�
	void OnTextRoomViewGroupResp(std::vector<TextRoomViewGroupResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//�۵��б�
	void OnTextRoomLiveViewResp(std::vector<TextRoomLiveViewResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//�����б�
	void OnTextRoomViewInfoResp(std::vector<TextRoomViewInfoResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//�۵�����
	void OnTextRoomLiveViewDetailResp(TextRoomLiveViewResp& info)
	{
		info.Log();
	}

	//��ʦ��Ϣ(��ͨ�û�)ͷ
	void OnNormalUserGetBeTeacherInfoRespHead(NormalUserGetBeTeacherInfoRespHead& info)
	{
		info.Log();
	}

	//��ʦ��Ϣ(��ͨ�û�)�б�
	void OnNormalUserGetBeTeacherInfoRespItem(std::vector<NormalUserGetBeTeacherInfoRespItem>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//��ʦ��Ϣ(��ʦ)ͷ
	void OnTeacherGetBeTeacherInfoRespHead(TeacherGetBeTeacherInfoRespHead& info)
	{
		info.Log();
	}

	//��ʦ��Ϣ(��ʦ)�б�
	void OnTeacherGetBeTeacherInfoRespItem(std::vector<TeacherGetBeTeacherInfoRespItem>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//��Ȩ��Ϣ�б�
	void OnGetPackagePrivilegeResp(std::vector<GetPackagePrivilegeResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//ר�������б�
	void OnTextRoomEmoticonListResp(std::vector<TextRoomEmoticonListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//���ظ����ؼ���¼�б�
	void OnTextRoomSecretsListResp(std::vector<TextRoomSecretsListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//���ظ����ؼ��ѹ����¼�б�
	void OnTextRoomSecBuyListResp(std::vector<TextRoomSecretsListResp>& infos)
	{
		for(int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();
		}
	}

	//���ظ����ؼ�������Ϣ��Ӧ
	void OnTextRoomSecretsTotalResp(TextRoomSecretsTotalResp& info)
	{
		info.Log();
	}

	//�����ؼ����ζ�����Ӧ
	void OnTextRoomBuySecretsResp(TextRoomBuySecretsResp& info)
	{
		info.Log();
	}

	//��ʦ��������ؼ�֪ͨ
	void OnTextRoomSecretsPHPResp(TextRoomSecretsPHPResp& info)
	{
		info.Log();
	}

	//��ʦ��������ֱ����Ӧ
	void OnTextRoomLiveMessageResp(TextRoomLiveMessageResp& info)
	{
		info.Log();
	}

	//�û���ֱ�����ݵ�����Ӧ
	void OnTextRoomZanForResp(TextRoomZanForResp& info)
	{
		info.Log();
	}

	//����������Ӧ
	void OnTextRoomLiveChatResp(TextRoomLiveChatResp& info)
	{
		info.Log();
	}

	//����ظ���Ӧ
	void OnTextLiveChatReplyResp(TextLiveChatReplyResp& info)
	{
		info.Log();
	}

	//��ʦ�޸ĺ������۵����ͷ�����Ӧ
	void OnTextRoomViewTypeResp(TextRoomViewTypeResp& info)
	{
		info.Log();
	}

	//��ʦ����۵���Ӧ
	void OnTextRoomViewMessageReqResp(TextRoomViewMessageReqResp& info)
	{
		info.Log();
	}

	//��ʦ����۵���ӦPHP
	void OnTextRoomViewPHPResp(TextRoomViewPHPResp& info)
	{
		info.Log();
	}

	//�۵�������Ӧ
	void OnTextRoomLiveActionResp(TextRoomLiveActionResp& info)
	{
		info.Log();
	}

	//�۵������Ӧ
	void OnTextLiveViewZanForResp(TextRoomZanForResp& info)
	{
		info.Log();
	}

	//�۵������Ӧ
	void OnTextLiveViewFlowerResp(TextLiveViewFlowerResp& info)
	{
		info.Log();
	}

	//�۵�ɾ����Ӧ
	void OnTextRoomViewDeleteResp(TextRoomViewDeleteResp& info)
	{
		info.Log();
	}

	//�û�������Ӧ
	void OnTextRoomQuestionResp(TextRoomQuestionResp& info)
	{
		info.Log();
	}

	//�û������ע��Ӧ
	void OnTextRoomInterestForResp(TextRoomInterestForResp& info)
	{
		info.Log();
	}

	//��Ʒ״̬
	void OnTextRoomGetUserGoodStatusResp(TextRoomGetUserGoodStatusResp& info)
	{
		info.Log();
	}

	//�û�����
	void OnUserPayResp(UserPayResp& info)
	{
		info.Log();
	}

	//��Ѱ�˻����
	void OnGetUserAccountBalanceResp(GetUserAccountBalanceResp& info)
	{
		info.Log();
	}

	//��ͨ�û���������
	void OnRoomUserInfoResp(RoomUserInfoResp& info)
	{
		info.Log();
	}

	//���ֽ�ʦ��������
	void OnTeacherInfoResp(TeacherInfoResp& info)
	{
		info.Log();
	}

	//��ȡ�û���������ʧ��
	void OnUserInfoErr(UserInfoErr& info)
	{
		info.Log();
	}

	//��ʦ���󷵻�
	void OnBeTeacherResp(BeTeacherResp& info)
	{
		info.Log();
	}

	//�����ʦ��Ϣʧ��
	void OnGetBeTeacherInfoReqFailed()
	{
		//OK
	}

	//��Ƶ��������֪ͨ
	void OnVideoRoomOnMicClientResp(VideoRoomOnMicClientResp& info)
	{
		info.Log();
	}

	//�γ̶��ķ���
	void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info)
	{
		info.Log();
	}

};


class TestPushListener: public PushListener
{

	void OnConfChanged(int version)
	{
		LOG("OnConfChanged:%d", version);
	}
	void OnGiftListChanged(int version)
	{
	}
	void OnShowFunctionChanged(int version)
	{
	}
	void OnPrintLog()
	{
		LOG("OnPrintLog");
	}
	void OnUpdateApp()
	{
		LOG("OnUpdateApp------");
	}
	void OnMoneyChanged(uint64 money)
	{
		LOG("OnMoneyChanged:%d", money);
	}
	void OnBayWindow(BayWindow& info)
	{
		info.Log();
	}
	void OnRoomGroupChanged()
	{
	}
	void OnRoomTeacherOnMicResp(RoomTeacherOnMicResp& info)
	{
	}
};

class TestConnectionListener : public ConnectionListener
{
	void OnConnected()
	{
		LOG("OnConnected");
	}
	
	void OnConnectError(int err_code)
	{
		LOG("OnConnectError");
	}

	void OnIOError(int err_code)
	{
		LOG("OnIOError");
	}
};


TestLoginListener login_listener;
TestHallListener hall_listener;
TestPushListener push_listener;
TestConnectionListener conn_listener;

TestRoomListener room_listener;

TestTextListener text_listener;

void test()
{
	
	
	conn.RegisterMessageListener(&login_listener);
	conn.RegisterConnectionListener(&conn_listener);
	conn.RegisterHallListener(&hall_listener);
	conn.RegisterPushListener(&push_listener);

	UserLogonReq4 req4;

	req4.set_nmessageid(1);
	req4.set_cloginid("1752965");
	req4.set_nversion(3030822 + 5);
	req4.set_nmask((uint32)time(0));
	req4.set_cuserpwd("23b431acfeb41e15d466d75de822307c");
	req4.set_cserial("");
	req4.set_cmacaddr("");
	req4.set_cipaddr("");
	req4.set_nimstate(0);
	req4.set_nmobile(0);

	conn.SendMsg_LoginReq4(req4);
	
	Thread::sleep(2000);


//conn.SendMsg_MessageUnreadReq();


//HallMessageReq req;
//req.set_userid(1680008);
//req.set_teacherflag(0);
//req.set_type(12);
//req.set_messageid(0);
//req.set_startindex(0);
//req.set_count(10);
//conn.SendMsg_HallMessageReq(req);


//HallMessageReq req;
//req.set_userid(1680008);
//req.set_teacherflag(0);
//req.set_type(12);
//req.set_messageid(0);
//req.set_startindex(0);
//req.set_count(10);
//
//TextRoomList_mobile head;
//head.set_uuid("123456789");
//conn.SendMsg_HallMessageReq2(head,req);


	
//HallMessageReq req;
//req.set_userid(1680008);
//req.set_teacherflag(0);
//req.set_type(12);
//req.set_messageid(0);
//req.set_startindex(0);
//req.set_count(60);
//
//TextRoomList_mobile head;
//head.set_uuid("123456789");
//conn.SendMsg_HallMessageReq2(head,req);


//string str="���ӽ�����";
//ViewAnswerReq req;
//req.set_fromid(1680014);
//req.set_toid(1680008);
//req.set_type(3);
//req.set_messageid(111);
//req.set_textlen(strlen(str.c_str()));
//req.set_commentstype(0);
//req.set_content(str);
//conn.SendMsg_ViewAnswerReq(req);

	
	/*
	vedio_room_conn.RegisterMessageListener(&room_listener);
	vedio_room_conn.RegisterConnectionListener(&conn_listener);

	JoinRoomReq req;

	protocol::CMDJoinRoomReq2_t temreq = {0};
	
	req.set_userid(1752965);
	req.set_cuserpwd("23b431acfeb41e15d466d75de822307c");
	req.set_cipaddr("");
	req.set_cmacaddr("");
	req.set_cserial("");
	
	
	req.set_vcbid(80055);
	req.set_croompwd("588");
	req.set_devtype(0);
	req.set_time(0);



	
	text_room_conn.RegisterMessageListener(&text_listener);
	text_room_conn.RegisterConnectionListener(&conn_listener);

	JoinRoomReq2 req2;	
	protocol::CMDJoinRoomReq2_t temreq2 = {0};

	req2.set_userid(1680008);
	req2.set_cuserpwd("dad3a37aa9d50688b5157698acfd7aee");
	req2.set_cipaddr("");
	req2.set_cmacaddr("");
	req2.set_cserial("");
	req2.set_vcbid(88601);
	req2.set_croompwd("");
	req2.set_devtype(0);
	req2.set_time(0);
	req2.set_crc32(15);
	req2.set_coremessagever(10690001);
	req2.set_bloginsource(0);
	req2.set_reserve1(0);
	req2.set_reserve2(0);

	req2.SerializeToArray(&temreq2, sizeof(protocol::CMDJoinRoomReq2_t));
	uint32 crcval2 = crc32((void*)&temreq2,sizeof(protocol::CMDJoinRoomReq2_t),CRC_MAGIC);
	req2.set_crc32( crcval2 );
	text_room_conn.SendMsg_JoinRoomReq(req2, -1, -1);


text_room_conn.SendMsg_TextRoomTeacherReq(88601,1680008);


//TextRoomLiveListReq livereq;
//livereq.set_vcbid(88601);
//livereq.set_userid(1680008);
//livereq.set_teacherid(188601);
//livereq.set_type(1);
//livereq.set_messageid(0);
//livereq.set_count(10);
//text_room_conn.SendMsg_TextRoomLiveListReq(livereq);

//TextRoomList_mobile head;
//head.set_uuid("123456789");
//text_room_conn.SendMsg_TextRoomLiveListReq2(head,livereq);


//TextRoomLiveListReq livereq;
//livereq.set_vcbid(88601);
//livereq.set_userid(1680008);
//livereq.set_teacherid(188601);
//livereq.set_type(2);
//livereq.set_messageid(0);
//livereq.set_count(10);
//text_room_conn.SendMsg_TextRoomLiveListReq(livereq);
//
//TextRoomList_mobile head;
//head.set_uuid("123456789");
//text_room_conn.SendMsg_TextRoomLiveListReq2(head,livereq);


//TextRoomLiveListReq livereq;
//livereq.set_vcbid(88601);
//livereq.set_userid(1680008);
//livereq.set_teacherid(188601);
//livereq.set_type(3);
//livereq.set_messageid(0);
//livereq.set_count(10);
//text_room_conn.SendMsg_TextRoomLiveListReq(livereq);
//
//TextRoomList_mobile head;
//head.set_uuid("123456789");
//text_room_conn.SendMsg_TextRoomLiveListReq2(head,livereq);


//text_room_conn.SendMsg_LikeForTextLiveInTextRoom(88601, 1680008, 527581);

//RoomLiveChatReq livereq;
//char str[]="���ӽ���ֻ������";
//livereq.set_vcbid(88601);
//livereq.set_srcid(1680014);
//livereq.set_toid(1763584);
//livereq.set_msgtype(0);
//livereq.set_textlen(strlen(str));
//livereq.set_commentstype(20160411095236);
//livereq.set_commentstype(0);
//livereq.set_content(str);
//text_room_conn.SendMsg_TextRoomLiveChatReq(livereq);


//AdKeywordsReq KeywordPacket;
//KeywordPacket.set_num(1);
//KeywordPacket.set_ntype(1);
//KeywordPacket.set_nrunerid(1680008);
//KeywordPacket.set_naction(1);
//KeywordPacket.set_keyword("���ӽ���ֻ��");
//KeywordPacket.set_createtime("2016-02-23 16:21");
//text_room_conn.SendMsg_ModifyAdKeywordsReq(KeywordPacket);


//SetRoomInfoReq_v2 req;
//req.set_cname("��ǧ��");
//req.set_cpwd("");
//req.set_nallowjoinmode(0);
//req.set_nclosecolorbar(0);
//req.set_nclosefreemic(0);
//req.set_ncloseinoutmsg(0);
//req.set_ncloseprvchat(0);
//req.set_nclosepubchat(0);
//req.set_ncloseroom(0);
//req.set_runnerid(1680014);
//req.set_vcbid(88601);
//text_room_conn.SendMsg_SetRoomBaseInfoReq_v2(req);


//SeeUserIpReq req;
//req.set_runid(1680014);
//req.set_toid(1680008);
//req.set_vcbid(88601);
//text_room_conn.SendMsg_SeeUserIpReq(req);


//UserPriority req1;
//req1.set_vcbid(88601);
//req1.set_runnerid(1680014);
//req1.set_userid(1680008);
//req1.set_action(1);
//req1.set_priority(1);
//text_room_conn.SendMsg_SetUserPriorityReq(req1);


//ForbidUserChat req22;
//req22.set_vcbid(88601);
//req22.set_action(1);
//req22.set_srcid(1680014);
//req22.set_toid(1680008);
//text_room_conn.SendMsg_ForbidUserChat(req22);


//UserKickoutRoomInfo req3;
//req3.set_mins(1);
//req3.set_resonid(0);
//req3.set_srcid(1680014);
//req3.set_toid(1763584);
//req3.set_vcbid(88601);
//text_room_conn.SendMsg_KickoutUserReq(req3);


//ThrowUserInfo req4;
//req4.set_vcbid(88601);
//req4.set_runnerid(1680014);
//req4.set_toid(1680008);
//req4.set_nscopeid(1);
//text_room_conn.SendMsg_AddUserToBlackListReq(req4);
	
	vedio_room_conn.SendMsg_JoinRoomReq2(req);
	*/

	/*
	TeacherScoreRecordReq req;

	req.set_score(5);
	req.set_userid(1803191);
	req.set_teacher_userid(198616);
	req.set_vcbid(90003);

	vedio_room_conn.SendMsg_UserScoreReq(req);
	*/

	/*
	vedio_room_conn.RegisterMessageListener(&room_listener);
	vedio_room_conn.RegisterConnectionListener(&conn_listener);

	QueryUserAccountReq req;

	req.set_userid(1803191);
	req.set_vcbid(90003);

	vedio_room_conn.SendMsg_QueryUserAccountInfo(1803191, 90003);
	*/

	/*
	vedio_room_conn.RegisterMessageListener(&room_listener);
	vedio_room_conn.RegisterConnectionListener(&conn_listener);

	SeeUserIpReq req;

	req.set_runid(1803191);
	req.set_toid(1803191);
	req.set_vcbid(90003);
	
	vedio_room_conn.SendMsg_SeeUserIpReq(req);
	*/

	/*
	vedio_room_conn.RegisterMessageListener(&room_listener);
	vedio_room_conn.RegisterConnectionListener(&conn_listener);

	UpWaitMic req;

	req.set_nmicindex(0);
	req.set_ruunerid(1803191);
	req.set_touser(1803191);
	req.set_vcbid(90003);
	
	vedio_room_conn.SendMsg_UpWaitMicReq(90003,1803191,1680040, 1);
	*/
	
	
	//LOG("%s", content);

}


#ifdef ANDROID

#include <jni.h>

extern "C" {
    JNIEXPORT void JNICALL Java_com_example_test_ProtocolLib_testp(JNIEnv* env, jobject obj);
};


JNIEXPORT void JNICALL
Java_com_example_test_ProtocolLib_testp(JNIEnv* env, jobject obj) {
    test();
}

#endif


#ifdef WIN
/*
char* lbs0 = "lbs1.99ducaijing.cn:2222,lbs2.99ducaijing.cn:2222,58.210.107.54:2222,122.193.102.23:2222,112.25.230.249:2222";
char lbs[256];


char lbss[3][10][20];
int lbs_counter[3];
bool islogining = false;

void parse_ip_port(char* s, char* ip, short& port)
{
	char* e = strchr(s, ':');
	int len = e - s;
	memcpy(ip, s, len);
	ip[len] = 0;

	port = atoi(e + 1);
}


ThreadVoid get_host_form_lbs_runnable(void* param)
{
	char recvbuf[HTTP_RECV_BUF_SIZE];
	Http http;

	char* lbs = (char*)param;
	
	char ip[20];
	short port;
	parse_ip_port(lbs, ip, port);

	//LOG("thread:lbs--:%s--%d", ip, port);

	char* content = http.GetString(ip, port, "/tygetweb", recvbuf);
	if (content != NULL)
	{
		char* end = strchr(content, '|');
		if (end != NULL)
		{
			*end = '\0';
		}

		LOG("time:%d lbs:%s host:%s", clock(), ip, content);
		if (!islogining)
		{
			islogining = true;
			LOG("****DO LOGIN***");

			const char *d = ",";
			char *p;
			p = strtok(content, d);
			while (p)
			{
				//printf("%s\n", p);

				if (strlen(p) == 1)
				{
					LOG("stype:%s", p);
				}
				else
				{
					char ip[20];
					short port;
					parse_ip_port(p, ip, port);
					LOG("first login server: %s:%d", ip, port);
					break;
				}

				p = strtok(NULL, d);
			}
		}
	}

	ThreadReturn;
}

void testlbs()
{
	const char *d = ",";
	char *p;
	strcpy(lbs, lbs0);
	p = strtok(lbs, d);
	int stype = -1;
	while (p)
	{
		//printf("%s\n", p);

		Thread::start(get_host_form_lbs_runnable, p);
		p = strtok(NULL, d);
	}
}

void testlbs2()
{
	//http://hall.99ducaijing.cn:8081/roomdata/room.php?act=roomdata
	char recvbuf[HTTP_RECV_BUF_SIZE];
	Http http;

	memset(lbss, 0, sizeof(lbss));
	memset(lbs_counter, 0, sizeof(lbs_counter));

	char* content = http.GetString("lbs1.99ducaijing.cn", 2222, "/tygetweb", recvbuf);
	//int ret = http.GetString("lbs1.99ducaijing.cn", 2222, "/tygetgate", recvbuf);
	//int ret = http.GetString("hall.99ducaijing.cn", 8081, "/roomdata/room.php?act=roomdata", recvbuf);
	if (content != NULL)
	{
		LOG("%s", recvbuf);
		//char s[] = "Golden Global   View,disk * desk";
		char* end = strchr(content, '|');
		if (end != NULL)
		{
			*end = '\0';
		}

		const char *d = ",";
		char *p;
		p = strtok(content, d);
		int stype = -1;
		while (p)
		{
			//printf("%s\n", p);
			
			if (strlen(p) == 1)
			{
				stype = p[0] - '0';
				LOG("stype:%d", stype);
			}
			else
			{
				if (stype >= 0 && stype <= 2)
				{
					int n = lbs_counter[stype];
					strcpy(lbss[stype][n], p);
					LOG("lbs:%d:%s", n, lbss[stype][n]);

					char ip[20];
					short port;
					parse_ip_port(lbss[stype][n], ip, port);
					LOG("ip:%s port:%d", ip, port);

					if (islogining == false)
					{
						islogining = true;

					}

					lbs_counter[stype]++;
				}
			}

			p = strtok(NULL, d);
		}
	}

}
*/

int main(int argc, char* argv[])
{
	
	Socket::startup();

	//get_out_ip();

	//test();
	//testlbs();

	//WaitForSingleObject((HANDLE)thread_handle, 0);

	//ReportLoginFailed(9, "testlogin", "127.0.0.1", "192.168.0.1");

	//void ReportRegisterFailed(int reg_type, rstring server_ip, rstring client_ip);
	//ReportRegisterFailed(1, "127.0.0.1", "192.168.0.1");


	//void ReportGetRoomListFailed(int userid, int room_type, rstring server_ip, rstring client_ip)
	//ReportGetRoomListFailed(1752965, 1, "127.0.0.1", "192.168.0.1");


	//void ReportJoinRoomFailed(int userid, int room_type, int roomid, rstring server_ip, rstring client_ip, rstring err)
	//ReportJoinRoomFailed(1752965, 1, 80060, "127.0.0.1", "192.168.0.1", "");

	//void ReportGetRoomUserListFailed(int userid, int room_type, int roomid, rstring server_ip, rstring client_ip, rstring err)
	//ReportGetRoomUserListFailed(1752965, 1, 80060, "127.0.0.1", "192.168.0.1", "");

	//void ReportVideoWarn(int userid, int roomid, int warn_type, rstring server_ip, rstring client_ip)
	//ReportVideoWarn(100123, 80060, 1, "127.0.0.1", "192.168.0.1");

	//void ReportCrash(rstring os, rstring version_name, rstring client_ip, rstring err)
	//ReportCrash("WIN", "1.0", "127.0.0.1", "192.168.0.1");

	//void ReportOpenHomepageFailed(int userid, rstring server_ip, rstring client_ip)
	//ReportOpenHomepageFailed(1752965, "127.0.0.1", "192.168.0.1");

	//void ReportLocalAppData(rstring os, rstring serial_number, rstring version_name, rstring app_list)
	ReportLocalAppData("WIN", "ffaa", "1.2", "99�ƾ�|offce");

	system("pause");
	Socket::cleanup();
	system("pause");

	return 0;
	/*
	Http objHttp;

	std::string request = "";
	std::string response = "";
	objHttp.SetRecvBufSize(32*1024);
	char* c_resp = objHttp.request("hall.99ducaijing.cn", 8081, "/roomdata/room2.php?act=roomList&groupid=14&client=pc");

	response = c_resp;

	
	std::string strValue = c_resp;

	time_t t1 = clock();
	ProtocolJson::Reader reader;
	ProtocolJson::Value value;

	try
	{

		if (reader.parse(strValue, value))
		{
			if(!value["groupId"].isNull())
			{
				int id_s = value["groupId"].asInt();
				//printf("\ngroupId : [%d]\n", id_s);
				
			}

			if(!value["groupList"].isNull())
			{
				ProtocolJson::Value& groupList = value["groupList"];

				int size_ = groupList.size();

				
				for(int i = 0; i < size_; i++)
				{
					//printf("\n\tgroupId :\t [%d]\n", groupList[i]["groupId"].asInt());

					ProtocolJson::Value& roomList = groupList[i]["roomList"];

					int room_size = roomList.size();

					for(int j = 0; j < room_size; j++)
					{
						//printf("\n\t\tvcbId :\t\t [%s]\t", roomList[j]["nvcbid"].asCString());
					}
					//printf("\n");
				}
				
			}
			
		}
	}
	catch ( std::exception& ex)
	{
		printf( "some error..");
	}

	time_t t2 = clock();

	printf( "cost time : %d", t2 - t1);
	
	system("pause");
	Socket::cleanup();
	system("pause");

	return 0;
	*/

}

#endif


#endif

