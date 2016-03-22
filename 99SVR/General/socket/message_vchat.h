
#ifndef __MESSAGE_VCHAT_HH_20130715__
#define __MESSAGE_VCHAT_HH_20130715__

#include "message_comm.h"

#define MDM_Vchat_Login  103  //��½
#define MDM_Vchat_Hall   104  //����
#define MDM_Vchat_Room   105  //����
#define MDM_Vchat_Text   108  //����ֱ����

#define MDM_Version_Value 10  //Э��汾


enum {
	ERR_USER_IN_BLACK_LIST = 101,	//�û��ں�����
	ERR_JOINROOM_PWD_WRONG = 201,	//�������벻��
	ERR_FAIL_CREATE_USER = 203,		//�����û�ʧ��(�û���/����ʧ��)
	ERR_KICKOUT_SAMEACCOUNT = 107,	//ͬ�ż��뷿���߳�
	//add new
	ERR_EXCEPTION_QUIT_ROOM = 108,
	//end
	ERR_ROOM_NOT_EXIST = 404,		//���䲻����
	ERR_ROOM_IS_CLOSED = 405,		//�����Ѿ��ر�
	ERR_ROOM_USER_IS_FULL = 502,	//������������
	ERR_KICKOUT_TIMEOUT = 522,		//��ʱ�߳�
	ERR_KICKOUT_AD = 600			//�����߳�
};


enum {
    Sub_Vchat_ClientHello = 1,         //����,ÿ��MDM mainCmd��һ��
    Sub_Vchat_ClientPing = 2,             //ping,ÿ��MDM mainCmd��һ��
    Sub_Vchat_ClientPingResp = 3,         //ping��Ӧ

	//logon��Ϣ
    Sub_Vchat_logonReq = 4,               //��¼
    Sub_Vchat_logonErr = 5,               //��½ʧ��
    Sub_Vchat_logonSuccess = 6,           //��½�ɹ�
    Sub_Vchat_UserQuanxianBegin = 7,       //�û�Ȩ������
    Sub_Vchat_UserQuanxianLst = 8,         //
    Sub_Vchat_UserQuanxianEnd = 9,         //
    Sub_Vchat_logonFinished = 10,          //��¼���,������

	//�ݲ�ʹ��----- ʹ��webע��
    Sub_Vchat_RegisteReq = 11,             //ע��,Ŀǰ�򵥵�ע�ỹ����web(ͬ����ƽ̨).���Ϳ����ɱ�,��ת��Ƕ��ҳ��ע��.
    Sub_Vchat_RegisteErr = 12,
    Sub_Vchat_RegisteSuccess = 13,
	//-------------

    Sub_Vchat_SetUserIMStatusReq = 14,     //�����û�״̬(��dev,mic֮���online״̬: hide,busing,online,leave)
    Sub_Vchat_setUserIMStatusResp = 15,
    Sub_Vchat_setUserIMStatusErr = 16,

	//lobby��Ϣ,��ʱʹ�ó�����,��logonsvrʹ��һ��������
    Sub_Vchat_RoomGroupListReq = 17,        //�������б�����
    Sub_Vchat_RoomGroupListBegin = 18,
    Sub_Vchat_RoomGroupListResp = 19,
    Sub_Vchat_RoomGroupListFinished = 20,

    Sub_Vchat_RoomGroupStatusReq = 21,          //������״̬(����)����
    Sub_Vchat_RoomGroupStatusResp = 22,         //
    Sub_Vchat_RoomGroupStatusFinished = 23,     //������״̬(����)�б����

    Sub_Vchat_RoomListReq = 24,             //�����б�����
    Sub_Vchat_RoomListBegin = 25,
    Sub_Vchat_RoomListResp = 26,
    Sub_Vchat_RoomListFinished = 27,        //��ȡ�����б����

	//room��Ϣ
    Sub_Vchat_JoinRoomReq = 28,             //���뷿������
    Sub_Vchat_JoinRoomErr = 29,                   //����
    Sub_Vchat_JoinRoomResp = 30,                  //�ɹ�,�������б�
    Sub_Vchat_JoinOtherRoomNoty = 31,       //���� ��������֪ͨ (������֮����)

    Sub_Vchat_RoomUserListReq = 32,         //�����û��б�����
    Sub_Vchat_RoomUserListBegin = 33,  //ad by guchengzhi 20150202
    Sub_Vchat_RoomUserListResp = 34,              //��Ӧ(�Ʋ�)
    Sub_Vchat_RoomUserListFinished = 35,          //������뷿��׶����,�����������
    Sub_Vchat_RoomUserNoty = 36,            //�б����֪ͨ

    Sub_Vchat_RoomPubMicState = 37,         //���乫��״̬

    Sub_Vchat_RoomUserExitReq = 38,         //�û��Լ��˳�����
    Sub_Vchat_RoomUserExitResp = 39,              //
    Sub_Vchat_RoomUserExitNoty = 40,              //֪ͨ
	Sub_Vchat_RoomUserExceptExitNoty = 323, //�û��쳣�˳�֪ͨ

    Sub_Vchat_RoomKickoutUserReq = 41,      //�߳��û�����
    Sub_Vchat_RoomKickoutUserResp = 42,           //
    Sub_Vchat_RoomKickoutUserNoty = 43,           //֪ͨ

    Sub_Vchat_GetFlyGiftListReq = 44,       //����������б�(�ܵ���Ϣ)
    Sub_Vchat_FlyGiftListInfo = 45,         //�������б�(�ܵ���Ϣ)

    Sub_Vchat_WaitiMicListInfo = 46,          //�����û��б�

    Sub_Vchat_ChatReq = 47,                 //���췢����Ϣ
    Sub_Vchat_ChatErr = 48,                       //
    Sub_Vchat_ChatNotify = 49,                    //ת����Ϣ

    Sub_Vchat_TradeGiftReq = 50,             //��������(�緿��,��ƽ̨)����
    Sub_Vchat_TradeGiftResp = 51,                 //
    Sub_Vchat_TradeGiftErr = 52,                  //
    Sub_Vchat_TradeGiftNotify = 53,               //

    Sub_Vchat_TradeFlowerReq = 54,            //�����ʻ�����,��Ϊֻ�������ڵ�ǰ�����Ӧ��,��˲��������ٺܶ�
    Sub_Vchat_TradeFlowerResp = 55,                  //
    Sub_Vchat_TradeFlowerErr = 56,                   //
    Sub_Vchat_TradeFlowerNotify = 57,                //

    Sub_Vchat_TradeFireworksReq = 58,              //�����̻�(���)����, ���������̻�ʱ���ǵ�ʱ��ͨ���﷢��ȥ,ͨ��giftid�ж��ǲ����̻�������
    Sub_Vchat_TradeFireworksResp = 59,
    Sub_Vchat_TradeFireworksErr = 60,
    Sub_Vchat_TradeFireworksNotify = 61,           //�����̻�(���)֪ͨ?
	
    Sub_Vchat_LotteryPoolNotify = 62,          //���˽��ع㲥��Ϣ
    Sub_Vchat_LotteryGiftNotify = 63,          //�н���������㲥��Ϣ
    Sub_Vchat_BoomGiftNotify = 64,             //�н���ը����㲥��Ϣ
    Sub_Vchat_SysNoticeInfo = 65,              //ϵͳ�㲥(ר��)��Ϣ

    Sub_Vchat_UserAccountInfo = 66,            //�û��˻�(���)��Ϣ

    Sub_Vchat_RoomInfoNotify = 67,             //������Ϣ����
    Sub_Vchat_RoomManagerNotify = 68,          //�������Ա
    Sub_Vchat_RoomMediaNotify = 69,            //����ý��
    Sub_Vchat_RoomNoticeNotify = 70,           //���乫��
    Sub_Vchat_RoomOPStatusNotify = 71,         //����״̬

    Sub_Vchat_TransMediaReq = 72,              //����Ƶý������
    Sub_Vchat_TransMediaResp = 73,                 //
    Sub_Vchat_TransMediaErr = 74,                  //

    Sub_Vchat_SetMicStateReq = 75,             //������/����״̬
    Sub_Vchat_SetMicStateResp = 76,                //
    Sub_Vchat_SetMicStateErr = 77,                 //
    Sub_Vchat_SetMicStateNotify = 78,              //

    Sub_Vchat_SetDevStateReq = 79,             //�����豸״̬
    Sub_Vchat_SetDevStateResp = 80,                 //
    Sub_Vchat_SetDevStateErr = 81,                  //
    Sub_Vchat_SetDevStateNotify = 82,               //

    Sub_Vchat_SetUserAliasReq = 83,            //�����û��س�
    Sub_Vchat_SetUserAliasResp = 84,                //
    Sub_Vchat_SetUserAliasErr = 85,                 //
    Sub_Vchat_SetUserAliasNotify = 86,              //

    Sub_Vchat_SetUserPriorityReq = 87,         //�����û�Ȩ��
    Sub_Vchat_SetUserPriorityResp = 88,             //
    Sub_Vchat_SetUserPriorityNotify = 89,           //

    Sub_Vchat_SeeUserIpReq = 90,                 //�鿴�û�IP����
    Sub_Vchat_SeeUserIpResp = 91,                   //
    Sub_Vchat_SeeUserIpErr = 92,                    //

    Sub_Vchat_ThrowUserReq = 93,                 //��ɱ�û�
    Sub_Vchat_ThrowUserResp = 94,                   //
    Sub_Vchat_ThrowUserNotify = 95,                 //

    Sub_Vchat_SendUserSealReq = 96,              //��������
    Sub_Vchat_SendUserSealErr = 97,
    Sub_Vchat_SendUserSealNotify = 98,              //

    Sub_Vchat_ForbidUserChatReq = 99,            //�����û�����
    Sub_Vchat_ForbidUserChatNotify = 100,            //

    Sub_Vchat_FavoriteVcbReq = 101,                //�ղط�������
    Sub_Vchat_FavoriteVcbResp = 102,                  //

    Sub_Vchat_ChangePubMicStateReq = 103,          //���ù���״̬
    Sub_Vchat_ChangePubMicStateResp = 104,              //
    Sub_Vchat_ChangePubMicStateNotify = 105,            //

    Sub_Vchat_UpWaitMicReq = 106,                 //
    Sub_Vchat_UpWaitMicResp = 107,
    Sub_Vchat_UpWaitMicErr = 108,
    Sub_Vchat_ChangeWaitMicIndexReq = 109,        //������������
    Sub_Vchat_ChangeWaitMicIndexResp = 110,          //
    Sub_Vchat_ChangeWaitMicIndexNotify = 111,

    Sub_Vchat_LootUserMicReq = 112,                 //���û�(��)������
    Sub_Vcaht_lootUserMicResp = 113,                   //
    Sub_Vchat_LootUserMicNotify = 114,                 //

    Sub_Vchat_SetRoomInfoReq = 115,               //���÷�����Ϣ����
    Sub_Vchat_SetRoomInfoResp = 116,                 //
    Sub_Vchat_SetRoomOPStatusReq = 117,           //���÷�����������(״̬)
    Sub_Vchat_SetRoomOPStatusResp = 118,              //
    Sub_Vchat_SetRoomNoticeReq = 119,             //���÷��乫����Ϣ����
    Sub_Vchat_SetRoomNoticeResp = 120,                   //
    Sub_Vchat_SetRoomMediaReq = 121,              //���÷���ý����������� add by guchengzhi 20150202

    Sub_Vchat_SetUserProfileReq = 122,            //�����û�����
    Sub_Vchat_SetUserProfileResp = 123,              //
    Sub_Vchat_SetUserPwdReq = 124,                //�����û�����
    Sub_Vchat_SetUserPwdResp = 125,                  //

    Sub_Vchat_SetExecQueryReq = 126,
    Sub_Vchat_SetExecQueryResp = 127,
    Sub_Vchat_GetDBInfoReq = 128,
    Sub_Vchat_GetDBInfoResp = 129,

    Sub_Vchat_QueryUserAccountReq = 130,          // �û��˻���ѯ(���в�ѯ)
    Sub_Vchat_QueryUserAccountResp = 131,

	//��,ȡ������ //�����йؽ�һ��ֲ���ʹ��ͬһ������
    Sub_Vchat_MoneyAndPointOpReq = 132,
    Sub_Vchat_MoneyAndPointOpResp = 133,
    Sub_Vchat_MoneyAndPointOpErr = 134,
    Sub_Vchat_MoneyAndPointOpNotify = 135,

    Sub_Vchat_SetWatMicMaxNumLimitReq = 136,
    Sub_Vchat_SetWatMicMaxNumLimitErr = 137,
    Sub_Vchat_SetWatMicMaxNumLimitNotify = 138,

    Sub_Vchat_SetForbidInviteUpMicReq = 139,
    Sub_Vchat_SetForbidInviteUpMicResp = 140,
    Sub_Vchat_SetForbidInviteUpMicNotify = 141,

	Sub_Vchat_GetSiegeInfoRequest = 142,      //��ȡ������Ϣ
	Sub_Vchat_SiegeInfoNotify  =143,

    Sub_Vchat_QueryVcbExistReq = 144,      //��ѯĳ�����Ƿ����
    Sub_Vchat_QueryVcbExistResp = 145,     //����Ϣû��err
    Sub_Vchat_QueryUserExistReq = 146,     //��ѯĳ�û��Ƿ����
    Sub_Vchat_QueryUserExistResp = 147,    //����Ϣû��err

    Sub_Vchat_OpenChestReq = 148,         //�û�����������
    Sub_Vchat_OpenChestResp = 149,        //����Ҳ������

    Sub_Vchat_CurMobZhuboNotify = 150,      //��ǰ������Ϣ

    Sub_Vchat_UserCaifuCostLevelNotify = 151, //�û��Ƹ��������еȼ�ʵʱ������Ϣ

    Sub_Vchat_GetUserNetworkTypeReq = 152,  //��ȡ�û���������
    Sub_Vchat_GetUserNetworkTypeResp = 153,
    Sub_Vchat_SetUserNetworkTypeReq = 154,  //�����û�����������
    Sub_Vchat_SetUserNetworkTypeResp = 155,

    Sub_Vchat_GetUserVideoSmoothReq = 156,  //��ȡ�û�����Ƶ������
    Sub_Vchat_GetUserVideoSmoothResp = 157,
    Sub_Vchat_SetUserVideoSmoothReq = 158, //�����û�����Ƶ������
    Sub_Vchat_SetUserVideoSmoothResp = 159,

    Sub_Vchat_SetUserMoreInfoReq = 160,    //�����û�������Ϣ
    Sub_Vchat_SetUserMoreInfoResp = 161,
    Sub_Vchat_QueryUserMoreInfoReq = 162,   //��ѯ�û�������Ϣ
    Sub_Vchat_QueryUserMoreInfoResp = 163,

	Sub_Vchat_QuanxianId2ListResp =164, //Ȩ��id����
	Sub_Vchat_QuanxianAction2ListBegin=165, //Ȩ�޲�������
	Sub_Vchat_QuanxianAction2ListResp=166,
	Sub_Vchat_QuanxianAction2ListFinished=167,

	//3�ױ���ָ��, ��ռλ,ʹ�õ�ʱ��,���޸�ָ������
    Sub_Vchat_MessageReq_reserve1_req = 168,
    Sub_Vchat_MessageReq_reserve1_resp = 169,
    Sub_Vchat_MessageReq_reserve1_noty = 170,

    Sub_Vchat_MessageReq_reserve2_req = 171,
    Sub_Vchat_MessageReq_reserve2_resp = 172,
    Sub_Vchat_MessageReq_reserve2_noty = 173,

    Sub_Vchat_MessageReq_reserve3_req = 174,
    Sub_Vchat_MessageReq_reserve3_resp = 175,
    Sub_Vchat_MessageReq_reserve3_noty = 176,
    //~~~~

    Sub_Vchat_GateCloseObjectReq = 177,   //�ر���������Ķ���
    Sub_Vchat_CloseRoomNotify = 178,      //�رշ���֪ͨ
    Sub_Vchat_DoNotReachRoomServer = 179,
    Sub_Vchat_RoomGatePing = 180,

	//��������
    Sub_Vchat_SetRoomInfoReq_v2 = 181,    //���÷�����Ϣ����ɲ��
    Sub_Vchat_SetRoomInfoResp_v2 = 182,
    Sub_Vchat_SetRoomInfoNoty_v2 = 183,

    Sub_Vchat_QueryRoomGateAddrReq = 184,   //��ȡ�������ص�ַ
    Sub_Vchat_QueryRoomGateAddrResp = 185,

    Sub_Vchat_SetUserHideStateReq = 186,  //�����û�����״̬
    Sub_Vchat_SetUserHideStateResp = 187,
    Sub_VChat_SetUserHideStateNoty = 188,

    Sub_Vchat_UserAddChestNumNoty = 189,  //�û�����������Ϣ

    Sub_Vchat_AddClosedFriendReq = 190,   //�������ѹ���
    Sub_Vchat_AddClosedFriendResp = 191,
    Sub_Vchat_AddClosedFriendNoty = 192,
	
    Sub_Vchat_logonReq2 = 193, //�µĵ�¼�ṹ
	
    Sub_Vchat_AdKeyWordOperateReq = 194,	//�ؼ��ֲ�������
    Sub_Vchat_AdKeyWordOperateResp = 195,  //�ؼ��ֲ�����Ӧ
	Sub_Vchat_AdKeyWordOperateNoty = 196,	//�ؼ��ֹ㲥֪ͨ

	Sub_Vchat_TeacherScoreReq = 197,//��ʦ�������ִ�������
	Sub_Vchat_TeacherScoreResp = 198,//��ʦ�������ִ�����Ӧ
	Sub_Vchat_TeacherScoreRecordReq = 199,  //�û���������
	Sub_Vchat_TeacherScoreRecordResp = 200,//�û�������Ӧ

	Sub_Vchat_RoborTeacherIdNoty = 201,  //�����˶�Ӧ��ʦID֪ͨ  

	Sub_Vchat_TeacherGiftListReq = 202,  //��ʦ��ʵ���ܰ�����
	Sub_Vchat_TeacherGiftListResp = 203,  //��ʦ��ʵ���ܰ���Ӧ

	Sub_Vchat_MgrRefreshListReq = 204,            //ˢ���û��б�
	Sub_Vchat_MgrRefreshListNotify = 205,            //

	Sub_Vchat_MgrRelieveBlackDBReq = 206,		//�������
	Sub_Vchat_MgrRelieveBlackDBNoty = 207,

	Sub_Vchat_ReportMediaGateReq = 208, //�ͻ��˱���ý������������ط�����
	Sub_Vchat_ReportMediaGateResp = 209, //�ͻ��˱���ý������������ط������Ļ�Ӧ

	Sub_Vchat_UserScoreNotify = 214,  //�û��Խ�ʦ������
	Sub_Vchat_UserScoreListNotify = 215,  //�û��Խ�ʦ�����ֹ㲥

	Sub_Vchat_UserExitMessage_Req = 218,//�û��˳����������
	Sub_Vchat_TeacherAvarageScore_Noty = 217, //ĳ����ʦ��ƽ����
	Sub_Vchat_UserExitMessage_Resp = 219,//�û��˳��������Ӧ

	Sub_Vchat_SysCast_Resp = 220,//���䷢��ϵͳ����

    Sub_Vchat_GetSecureInfoReq = 311,//�ͻ��������ȥ�û�email,qq,�ֻ�����,�����Ѵ���
	Sub_Vchat_GetSecureInfoResp = 312,//�ͻ��������ȥ�û�email,qq,�ֻ�����,�����Ѵ����Ļ�Ӧ

	Sub_Vchat_HitGoldEgg_ToClient_Noty = 1001, //�ҽ�

	Sub_Vchat_logonReq3 = 1002, //�°��¼
	Sub_Vchat_logonReq4 = 1004, //logon new req
	Sub_Vchat_logonReq5 = 1005, //logon through other platform
	Sub_Vchat_logonErr2 = 1006,               //��½ʧ��
	Sub_Vchat_logonSuccess2 = 1007,           //��½�ɹ�
	Sub_Vchat_logonTokenReq = 1102,
	Sub_Vchat_logonTokenNotify = 1103,      //�û�����
	Sub_Vchat_HallMessageNotify =           10000,//����С������ѣ��������������ͣ�

	Sub_Vchat_HallMessageUnreadReq =        10001,//����δ����¼����������
	Sub_Vchat_HallMessageUnreadRes =        10002,//����δ����¼��������Ӧ

	Sub_Vchat_HallMessageReq =              10003,//�鿴�������󣨲�ͬ����������ͬһ����Ϣ���ͼ��ṹ��

	Sub_Vchat_HallInteractBegin =           10004,//�鿴�����ظ����б�ʼ
	Sub_Vchat_HallInteractRes =             10005,//�鿴�����ظ�����Ӧ
	Sub_Vchat_HallInteractEnd =             10006,//�鿴�����ظ����б����

	Sub_Vchat_HallAnswerBegin =             10007,//�鿴�ʴ����ѣ��б�ʼ
	Sub_Vchat_HallAnswerRes =               10008,//�鿴�ʴ����ѣ���Ӧ
	Sub_Vchat_HallAnswerEnd =               10009,//�鿴�ʴ����ѣ��б����

	Sub_Vchat_HallViewShowBegin =           10010,//�鿴�۵�ظ����б�ʼ
	Sub_Vchat_HallViewShowRes =             10011,//�鿴�۵�ظ�����Ӧ
	Sub_Vchat_HallViewShowEnd =             10012,//�鿴�۵�ظ����б����

	Sub_Vchat_HallTeacherFansBegin =        10013,//�鿴�ҵķ�˿���б�ʼ
	Sub_Vchat_HallTeacherFansRes =          10014,//�鿴�ҵķ�˿����Ӧ
	Sub_Vchat_HallTeacherFansEnd =          10015,//�鿴�ҵķ�˿���б����

	Sub_Vchat_HallInterestBegin =           10016,//�鿴�ҵĹ�ע���ѹ�ע��ʦ�����б�ʼ
	Sub_Vchat_HallInterestRes =             10017,//�鿴�ҵĹ�ע���ѹ�ע��ʦ������Ӧ
	Sub_Vchat_HallInterestEnd =             10018,//�鿴�ҵĹ�ע���ѹ�ע��ʦ�����б����

	Sub_Vchat_HallUnInterestBegin =         10019,//�鿴�ҵĹ�ע���޹�ע��ʦ�����б�ʼ
	Sub_Vchat_HallUnInterestRes =           10020,//�鿴�ҵĹ�ע���޹�ע��ʦ������Ӧ
	Sub_Vchat_HallUnInterestEnd =           10021,//�鿴�ҵĹ�ע���޹�ע��ʦ�����б����
	
	Sub_Vchat_TextLivePointListBegin =      10022,//�鿴����Ԥ�⣨�ѹ�ע�Ľ�ʦ�����б�ʼ
	Sub_Vchat_TextLivePointListRes =        10023,//�鿴����Ԥ�⣨�ѹ�ע�Ľ�ʦ������Ӧ
	Sub_Vchat_TextLivePointListEnd =        10024,//�鿴����Ԥ�⣨�ѹ�ע�Ľ�ʦ�����б����

	Sub_Vchat_HallViewAnswerReq =           10025,//��ʦ�ظ��������۵�ظ��ͻش����ʣ�����
	Sub_Vchat_HallViewAnswerRes =           10026,//��ʦ�ظ��������۵�ظ��ͻش����ʣ���Ӧ

	Sub_Vchat_HallInterestForReq =          10027,//��ע���޹�ע��ʦʱ�������н�ʦ�б������ע������
	Sub_Vchat_HallInterestForRes =          10028,//��ע���޹�ע��ʦʱ�������н�ʦ�б������ע����Ӧ

	Sub_Vchat_HallMessageReq_Mobile =       10029,//�鿴�������󣨲�ͬ����������ͬһ����Ϣ���ͼ��ṹ��(��ʱֻ���ֻ���ѯ�б�)

	Sub_Vchat_HallInteractRes_Mobile =      10030,//�鿴�����ظ�����Ӧ(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_HallAnswerRes_Mobile =        10031,//�鿴�ʴ����ѣ���Ӧ(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_HallViewShowRes_Mobile =      10032,//�鿴�۵�ظ�����Ӧ(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_HallTeacherFansRes_Mobile =   10033,//�鿴�ҵķ�˿����Ӧ(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_HallInterestRes_Mobile =      10034,//�鿴�ҵĹ�ע���ѹ�ע��ʦ������Ӧ(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_HallUnInterestRes_Mobile =    10035,//�鿴�ҵĹ�ע���޹�ע��ʦ������Ӧ(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_TextLivePointListRes_Mobile = 10036,//�鿴����Ԥ�⣨�ѹ�ע�Ľ�ʦ������Ӧ(��ʱֻ���ֻ���ѯ�б�)


	Sub_Vchat_TextRoomJoinReq =             10100,//���뷿������
	Sub_Vchat_TextRoomJoinErr =             10101,//���뷿�������Ӧ
	Sub_Vchat_TextRoomJoinRes =             10102,//���뷿��ɹ���Ӧ

	Sub_Vchat_TextTeacherRoomJoinNoty =     10103,//��ʦ���뷿��ɹ�֪ͨ
	Sub_Vchat_TextUserRoomJoinNoty =        10104,//�û����뷿��ɹ�֪ͨ

	Sub_Vchat_TextRoomTeacherReq =          10105,//���뷿��ɹ������ͽ�ʦ��Ϣ����
	Sub_Vchat_TextRoomTeacherNotify =       10106,//���뷿��ɹ������ͽ�ʦ��Ϣ��Ӧ

	Sub_Vchat_TextRoomLiveListReq =         10107,//����ֱ����¼����

	Sub_Vchat_TextRoomLiveListBegin =       10108,//����ֱ����¼���б�ʼ
	Sub_Vchat_TextRoomLiveListNotify  =     10109,//����ֱ����¼����Ӧ
	Sub_Vchat_TextRoomLiveListEnd =         10110,//����ֱ����¼�����б����

	Sub_Vchat_TextRoomLivePointBegin =      10111,//����ֱ���ص��¼���б�ʼ
	Sub_Vchat_TextRoomLivePointNotify  =    10112,//����ֱ���ص��¼����Ӧ
	Sub_Vchat_TextRoomLivePointEnd =        10113,//����ֱ���ص��¼���б����

	Sub_Vchat_TextRoomForecastBegin =       10114,//��������Ԥ���¼���б�ʼ
	Sub_Vchat_TextRoomForecastNotify  =     10115,//��������Ԥ���¼����Ӧ
	Sub_Vchat_TextRoomForecastEnd =         10116,//��������Ԥ���¼���б����

	Sub_Vchat_TextRoomLiveMessageReq =      10117,//��ʦ��������ֱ������
	Sub_Vchat_TextRoomLiveMessageRes =      10118,//��ʦ��������ֱ����Ӧ

	Sub_Vchat_TextRoomInterestForReq =      10119,//�û������ע����
	Sub_Vchat_TextRoomInterestForRes =      10120,//�û������ע��Ӧ

	Sub_Vchat_TextRoomQuestionReq =         10121,//�û������������
	Sub_Vchat_TextRoomQuestionRes =         10122,//�û����������Ӧ

	Sub_Vchat_TextRoomZanForReq =           10123,//�û���ֱ�����ݵ�������
	Sub_Vchat_TextRoomZanForRes =           10124,//�û���ֱ�����ݵ�����Ӧ

	Sub_Vchat_TextRoomLiveChatReq =         10125,//��������
	Sub_Vchat_TextRoomLiveChatRes =         10126,//������Ӧ

	Sub_Vchat_TextLiveChatReplyReq =        10127,//����ظ�(����)����
	Sub_Vchat_TextLiveChatReplyRes =        10128,//����ظ�(����)��Ӧ

	Sub_Vchat_TextRoomLiveViewReq =         10129,//����鿴�۵�����

	Sub_Vchat_TextRoomViewGroupBegin =      10130,//�۵����ͷ��࣬�б�ʼ
	Sub_Vchat_TextRoomViewGroupRes =        10131,//�۵����ͷ��࣬��Ӧ
	Sub_Vchat_TextRoomViewGroupEnd =        10132,//�۵����ͷ��࣬�б����

	Sub_Vchat_TextRoomViewListShowReq =     10133,//����۵����ͷ�������

	Sub_Vchat_TextRoomLiveViewBegin =       10134,//�۵��б���ʼ
	Sub_Vchat_TextRoomLiveViewRes =         10135,//�۵��б���Ӧ
	Sub_Vchat_TextRoomLiveViewEnd =         10136,//�۵��б�����

	Sub_Vchat_TextRoomLiveViewDetailReq =   10137,//����鿴�۵���������

	Sub_Vchat_TextRoomViewInfoBegin =       10138,//�۵���ϸ��Ϣ���б�ʼ
	Sub_Vchat_TextRoomLiveViewDetailRes =   10139,//�۵���ϸ��Ϣ���۵㣩����Ӧ
	Sub_Vchat_TextRoomViewInfoRes =         10140,//�۵���ϸ��Ϣ�����ۣ�����Ӧ
	Sub_Vchat_TextRoomViewInfoEnd =         10141,//�۵���ϸ��Ϣ���б����
                                           
	Sub_Vchat_TextRoomViewTypeReq =         10142,//��ʦ����/�޸�/ɾ���۵����ͷ�������
	Sub_Vchat_TextRoomViewTypeRes =         10143,//��ʦ����/�޸�/ɾ���۵����ͷ�����Ӧ
                                           
	Sub_Vchat_TextRoomViewMessageReq =      10144,//��ʦ�����۵���޸Ĺ۵�����
	Sub_Vchat_TextRoomViewMessageRes =      10145,//��ʦ�����۵���޸Ĺ۵���Ӧ
                                           
	Sub_Vchat_TextRoomViewDeleteReq =       10146,//��ʦɾ���۵�����
	Sub_Vchat_TextRoomViewDeleteRes =       10147,//��ʦɾ���۵���Ӧ
                                           
	Sub_Vchat_TextRoomViewCommentReq =      10148,//�۵������������
	Sub_Vchat_TextRoomViewCommentRes =      10149,//�۵����������Ӧ
                                           
	Sub_Vchat_TextLiveViewZanForReq =       10150,//�۵����۲鿴ҳ���������
	Sub_Vchat_TextLiveViewZanForRes =       10151,//�۵����۲鿴ҳ�������Ӧ
                                           
	Sub_Vchat_TextLiveViewFlowerReq =       10152,//�۵�������ϸҳ�ͻ�����
	Sub_Vchat_TextLiveViewFlowerRes =       10153,//�۵�������ϸҳ�ͻ���Ӧ
                                           
	Sub_Vchat_TextLiveHistoryListReq =      10154,//ֱ����ʷ���ɷ�ҳ����չʾ������

	Sub_Vchat_TextLiveHistoryListBegin =    10155,//ֱ����ʷ���б�ʼ
	Sub_Vchat_TextLiveHistoryListRes =      10156,//ֱ����ʷ����Ӧ
	Sub_Vchat_TextLiveHistoryListEnd =      10157,//ֱ����ʷ���б����
                                           
	Sub_Vchat_TextLiveHistoryDaylyReq =     10158,//ĳһ���ֱ����¼�б����󣨿ɷ�ҳ����չʾ������

	Sub_Vchat_TextLiveHistoryDaylyBegin =   10159,//ĳһ���ֱ����¼�б��б�ʼ
	Sub_Vchat_TextLiveHistoryDaylyRes =     10160,//ĳһ���ֱ����¼�б���Ӧ
	Sub_Vchat_TextLiveHistoryDaylyEnd =     10161,//ĳһ���ֱ����¼�б��б����
                                           
	Sub_Vchat_TextLiveUserExitReq =         10162,//�˳���������
	Sub_Vchat_TextLiveUserExitRes =         10163,//�˳�������Ӧ

    	Sub_Vchat_TextRoomViewListReq_Mobile =  10164,//����۵����ͷ�������(��ʱֻ���ֻ���ѯ�б�)
    	Sub_Vchat_TextRoomViewRes_Mobile     =  10165, //�۵��б���Ӧ(��ʱֻ���ֻ���ѯ�б�)

	Sub_Vchat_TextRoomLiveListReq_Mobile =  10166,//����ֱ����¼����(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_TextRoomLiveListRes_Mobile =  10167,//����ֱ����¼����Ӧ(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_TextRoomLivePointRes_Mobile  =10168,//����ֱ���ص��¼����Ӧ(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_TextRoomForecastRes_Mobile  = 10169,//��������Ԥ���¼����Ӧ(��ʱֻ���ֻ���ѯ�б�)

	Sub_Vchat_TextRoomLiveViewReq_Mobile=   10170,//����鿴�۵�����(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_TextRoomViewGroupRes_Mobile = 10171,///�۵����ͷ��࣬��Ӧ(��ʱֻ���ֻ���ѯ�б�)

	Sub_Vchat_TextRoomLiveViewDetailReq_Mobile=10172,//����鿴�۵���������(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_TextRoomViewInfoRes_Mobile =     10173,//�۵���ϸ��Ϣ�����ۣ�����Ӧ(��ʱֻ���ֻ���ѯ�б�)

	Sub_Vchat_TextLiveHistoryListReq_Mobile=10174,//ֱ����ʷ���ɷ�ҳ����չʾ������(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_TextLiveHistoryListRes_Mobile=10175,//ֱ����ʷ����Ӧ(��ʱֻ���ֻ���ѯ�б�)

	Sub_Vchat_TextLiveHistoryDaylyReq_Mobile=10176,//ĳһ���ֱ����¼�б����󣨿ɷ�ҳ����չʾ������(��ʱֻ���ֻ���ѯ�б�)
	Sub_Vchat_TextLiveHistoryDaylyRes_Mobile=10177,//ĳһ���ֱ����¼�б���Ӧ(��ʱֻ���ֻ���ѯ�б�)

	Sub_Vchat_TextRoomViewPHPReq =      10178,//��ʦͨ��PHPҳ�淢���۵���޸Ĺ۵��ɾ���۵�����
	Sub_Vchat_TextRoomViewPHPRes =      10179,//��ʦͨ��PHPҳ�淢���۵���޸Ĺ۵��ɾ���۵���Ӧ

    Sub_Vchat_HallGetFansCountReq =     10180,//��ȡ��ʦ�ķ�˿��������
    Sub_Vchat_HallGetFansCountRes =     10181,//��ȡ��ʦ�ķ�˿������Ӧ

};

typedef enum MediaConnectActionType
{
	Connect_You = 1,
	Disconnect_You = 3,
}e_MediaConnectActionType;


//----------------------------------------------------------
#pragma pack(1)

//4 bytes
typedef struct tag_CMDClientHello
{
	uint8 param1;
	uint8 param2;
	uint8 param3;
	uint8 param4;
}CMDClientHello_t;

//4 bytes
typedef struct tag_CMDClientPing
{
	uint32 userid;        //�û�id
	uint32 roomid;        //����id
}CMDClientPing_t;

typedef struct tag_CMDSetExecQueryReq
{
	uint32 userid;
    int32  textlen;
	char   content[0];
}CMDSetExecQueryReq_t;

typedef struct tag_CMDSetExecQueryResp
{
   uint32 userid;
   int32  errorid;
}CMDSetExecQueryResp_t;

typedef struct tag_CMDGetDBInfoReq
{
   uint32 userid;
}CMDGetDBInfoReq_t;

typedef struct tag_CMDGetDBInfoResp
{
	uint32 userid;
	int32  dbport;
	char szServer[32];
	char szdbname[32];
	char szdbuser[32];
	char szdbuserpwd[32];
}CMDGetDBInfoResp_t;

#pragma pack()



#endif  //__MESSAGE_VCHAT_HH_20130715__

