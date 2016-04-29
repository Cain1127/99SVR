
#ifndef __PROTO_MESSAGE_VCHAT_H__
#define __PROTO_MESSAGE_VCHAT_H__

#include "proto_message_comm.h"

namespace protocol
{
    
    enum {
        MDM_Vchat_Login = 103,  //��½
        MDM_Vchat_Hall = 104,  //����
        MDM_Vchat_Room = 105,  //����
        MDM_Vchat_Gate = 106,  //����
        MDM_Vchat_WEB = 107,  //����web��֪ͨ
        MDM_Vchat_Text = 108,   //����ֱ��������
        MDM_Vchat_Usermgr = 109,   //�����û����������
        MDM_Vchat_Frtiy = 110,  //�ⲿ 111
        MDM_Vchat_Trust = 112,
        MDM_Vchat_Notify = 113,   //����֪ͨ������
        MDM_Vchat_Subscrib = 114,  //���ķ�����
        MDM_Vchat_Redis_Sync = 115,  //redisͬ��
        MDM_Vchat_Stastics = 198,  //ͳ�Ʒ�����
        MDM_Vchat_Alarm = 199,  //�澯������
        
        MDM_Version_Value = 10  //Э��汾
    };
    
    enum {
        ERR_USER_IN_BLACK_LIST = 101,	//�û��ں�����
        ERR_JOINROOM_PWD_WRONG = 201,	//�������벻��
        ERR_FAIL_CREATE_USER = 203,		//�����û�ʧ��(�û���/����ʧ��)
        ERR_KICKOUT_SAMEACCOUNT = 107,	//ͬ�ż��뷿���߳�
        ERR_EXCEPTION_QUIT_ROOM = 108,
        ERR_ROOM_NOT_EXIST = 404,		//���䲻����
        ERR_ROOM_IS_CLOSED = 405,		//�����Ѿ��ر�
        ERR_ROOM_USER_IS_FULL = 502,	//������������
        ERR_KICKOUT_TIMEOUT = 522,		//��ʱ�߳�
        ERR_KICKOUT_AD = 600			//�����߳�
    };
    
    enum {
        ERR_CODE_SUCCESS = 0,	//�ɹ�
        
        ERR_CODE_FAILED =                   1000, //ʧ�� 1000~1999
        ERR_CODE_FAILED_PACKAGEERROR =      1001,  //��������ȴ���
        ERR_CODE_FAILED_DBERROR =           1002, //���ݿ����ʹ���
        
        ERR_CODE_FAILED_INVALIDCHAR =       1003,//�����˷Ƿ��ַ�
        ERR_CODE_FAILED_USERNOTFOUND =      1004, //�Ҳ������û�
        ERR_CODE_FAILED_USERFROSEN =        1005, //�û�������
        
        ERR_CODE_FAILED_UNKNONMESSAGETYPE = 1006, //δ֪��Ϣ����
        
        ERR_CODE_FAILED_REQUEST_OUTOFRANGE = 1007, //�������ݹ���������ݹ���
        
        ERR_CODE_FAILED_SAMEUSERLOGIN =     1008,   //��ȫ��ͬ���û����뷿��
        ERR_CODE_FAILED_AREAIDNOTFOUND =    1009,   //û���ҵ�����ID
        ERR_CODE_FAILED_ROOMIDNOTFOUND =    1010,   //û���ҵ�����ID
        ERR_CODE_FAILED_CRC =               1011,   //CRCУ�����
        ERR_CODE_FAILED_CREATEUSER =        1012,   //û���ҵ������û�ʧ��
        ERR_CODE_FAILED_KEYWORDFOUND =      1013,   //���ֹؼ��
        ERR_CODE_FAILED_NOT_ENOUGH_GOLD =   1014,   //��Ҳ���
        ERR_CODE_FAILED_ALREADY_BUY =       1015,   //�Ѿ�����
        ERR_CODE_FAILED_PRIVATENOTFOUND =   1016    //û�и�˽�˶���
    };
    
    enum {
        Sub_Vchat_ClientHello                               =1    ,       //����ÿ��MDMmainCmd��һ��
        Sub_Vchat_ClientPing                                =2    ,       //pingÿ��MDMmainCmd��һ��
        Sub_Vchat_ClientPingResp                            =3    ,       //ping��Ӧ
        Sub_Vchat_GetAllUserReq                             =4    ,       //  ��ȡ���е������û�
        Sub_Vchat_Resp_ErrCode                              =5    ,       //  ���ش���Ӧ��
        Sub_Vchat_DoNotReachRoomServer                      =6    ,       //
        Sub_Vchat_MgrRefreshListReq                         =7    ,       //  ˢ������
        Sub_Vchat_MgrRefreshListNotify                      =8    ,       //
        Sub_Vchat_MgrRelieveBlackDBReq                      =9    ,       //           �������������
        Sub_Vchat_MgrRelieveBlackDBNoty                     =10   ,       //
        
        Sub_Vchat_LogonNot                                  =361  ,       //  �û�����֪ͨ
        Sub_Vchat_LogoutNot                                 =362  ,       //  �û�����֪ͨ--���˷���������
        Sub_Vchat_ClientExistNot                            =363  ,       //  �û�����֪ͨ--���ͻ���
        Sub_Vchat_HitGoldEgg_ToClient_Noty                  =1001 ,       //   �ҽ�֪ͨ�ͻ���
        Sub_Vchat_ClientNotify                              =10194,       //    ��������
        Sub_Vchat_notifyReq                                 =10197,       //ͨ������
        
        Sub_Vchat_JoinRoomReq                               =2000 ,       // ���뷿������
        Sub_Vchat_JoinRoomErr                               =2001 ,       // ����
        Sub_Vchat_JoinRoomResp                              =2002 ,       // �ɹ��������б�
        Sub_Vchat_JoinOtherRoomNoty                         =2003 ,       // ������������֪ͨ(������֮����)
        Sub_Vchat_RoomUserListReq                           =2004 ,       // �����û��б�����
        Sub_Vchat_RoomUserListBegin                         =2005 ,       // adbyguchengzhi20150202
        Sub_Vchat_RoomUserListResp                          =2006 ,       // ��Ӧ(�Ʋ�)
        Sub_Vchat_RoomUserListFinished                      =2007 ,       // ������뷿��׶���ɽ����������
        Sub_Vchat_RoomUserNoty                              =2008 ,       // �б����֪ͨ
        Sub_Vchat_RoomPubMicState                           =2009 ,       // ���乫��״̬
        Sub_Vchat_RoomUserExitReq                           =2010 ,       // �û��Լ��˳�����
        Sub_Vchat_RoomUserExitResp                          =2011 ,       //
        Sub_Vchat_RoomUserExitNoty                          =2012 ,       // ֪ͨ
        Sub_Vchat_RoomKickoutUserReq                        =2013 ,       // �߳��û�����
        Sub_Vchat_RoomKickoutUserResp                       =2014 ,       //
        Sub_Vchat_RoomKickoutUserNoty                       =2015 ,       // ֪ͨ
        Sub_Vchat_ChatReq                                   =2016 ,       // ���췢����Ϣ
        Sub_Vchat_ChatErr                                   =2017 ,       //
        Sub_Vchat_ChatNotify                                =2018 ,       // ת����Ϣ
        Sub_Vchat_TradeGiftReq                              =2019 ,       // ��������(�緿���ƽ̨)����
        Sub_Vchat_TradeGiftResp                             =2020 ,       //
        Sub_Vchat_TradeGiftErr                              =2021 ,       //
        Sub_Vchat_TradeGiftNotify                           =2022 ,       //
        Sub_Vchat_SysNoticeInfo                             =2023 ,       // ϵͳ�㲥(ר��)��Ϣ
        Sub_Vchat_UserAccountInfo                           =2024 ,       // �û��˻�(���)��Ϣ
        Sub_Vchat_RoomInfoNotify                            =2025 ,       // ������Ϣ����
        Sub_Vchat_RoomManagerNotify                         =2026 ,       // �������Ա
        Sub_Vchat_RoomMediaNotify                           =2027 ,       // ����ý��
        Sub_Vchat_RoomNoticeNotify                          =2028 ,       // ���乫��
        Sub_Vchat_RoomOPStatusNotify                        =2029 ,       // ����״̬
        Sub_Vchat_SetMicStateReq                            =2030 ,       // ������/����״̬
        Sub_Vchat_SetMicStateResp                           =2031 ,       //
        Sub_Vchat_SetMicStateErr                            =2032 ,       //
        Sub_Vchat_SetMicStateNotify                         =2033 ,       //
        Sub_Vchat_SetDevStateReq                            =2034 ,       // �����豸״̬
        Sub_Vchat_SetDevStateResp                           =2035 ,       //
        Sub_Vchat_SetDevStateErr                            =2036 ,       //
        Sub_Vchat_SetDevStateNotify                         =2037 ,       //
        Sub_Vchat_SetUserAliasReq                           =2038 ,       // �����û��س�
        Sub_Vchat_SetUserAliasResp                          =2039 ,       //
        Sub_Vchat_SetUserAliasErr                           =2040 ,       //
        Sub_Vchat_SetUserAliasNotify                        =2041 ,       //
        Sub_Vchat_SetUserPriorityReq                        =2042 ,       // �����û�Ȩ��
        Sub_Vchat_SetUserPriorityResp                       =2043 ,       //
        Sub_Vchat_SetUserPriorityNotify                     =2044 ,       //
        Sub_Vchat_SeeUserIpReq                              =2045 ,       // �鿴�û�IP����
        Sub_Vchat_SeeUserIpResp                             =2046 ,       //
        Sub_Vchat_SeeUserIpErr                              =2047 ,       //
        Sub_Vchat_ThrowUserReq                              =2048 ,       // ��ɱ�û�
        Sub_Vchat_ThrowUserResp                             =2049 ,       //
        Sub_Vchat_ThrowUserNotify                           =2050 ,       //
        Sub_Vchat_ForbidUserChatReq                         =2051 ,       // �����û�����
        Sub_Vchat_ForbidUserChatNotify                      =2052 ,       //
        Sub_Vchat_FavoriteVcbReq                            =2053 ,       //  �ղط�������
        Sub_Vchat_FavoriteVcbResp                           =2054 ,       //
        Sub_Vchat_SetRoomInfoReq                            =2055 ,       //  ���÷�����Ϣ����
        Sub_Vchat_SetRoomInfoResp                           =2056 ,       //
        Sub_Vchat_SetRoomOPStatusReq                        =2057 ,       //  ���÷�����������(״̬)
        Sub_Vchat_SetRoomOPStatusResp                       =2058 ,       //
        Sub_Vchat_SetRoomNoticeReq                          =2059 ,       //  ���÷��乫����Ϣ����
        Sub_Vchat_SetRoomNoticeResp                         =2060 ,       //
        Sub_Vchat_SetRoomMediaReq                           =2061 ,       //  ���÷���ý�����������addbyguchengzhi20150202
        Sub_Vchat_SetUserPwdReq                             =2062 ,       //  �����û�����
        Sub_Vchat_SetUserPwdResp                            =2063 ,       //
        Sub_Vchat_QueryUserAccountReq                       =2064 ,       //  �û��˻���ѯ(���в�ѯ)
        Sub_Vchat_QueryUserAccountResp                      =2065 ,       //
        Sub_Vchat_QueryVcbExistReq                          =2066 ,       //  ��ѯĳ�����Ƿ����
        Sub_Vchat_QueryVcbExistResp                         =2067 ,       //  ����Ϣû��err
        Sub_Vchat_QueryUserExistReq                         =2068 ,       //  ��ѯĳ�û��Ƿ����
        Sub_Vchat_QueryUserExistResp                        =2069 ,       //  ����Ϣû��err
        Sub_Vchat_GateCloseObjectReq                        =2070 ,       //  �ر���������Ķ���
        Sub_Vchat_CloseRoomNotify                           =2071 ,       //  �رշ���֪ͨ
        Sub_Vchat_RoomGatePing                              =2072 ,       //
        Sub_Vchat_SetRoomInfoReq_v2                         =2073 ,       //  ���÷�����Ϣ����ɲ��
        Sub_Vchat_SetRoomInfoResp_v2                        =2074 ,       //
        Sub_Vchat_SetRoomInfoNoty_v2                        =2075 ,       //
        Sub_Vchat_QueryRoomGateAddrReq                      =2076 ,       //  ��ȡ�������ص�ַ
        Sub_Vchat_QueryRoomGateAddrResp                     =2077 ,       //
        Sub_Vchat_AdKeyWordOperateReq                       =2078 ,       //   �ؼ��ֲ�������
        Sub_Vchat_AdKeyWordOperateResp                      =2079 ,       //  �ؼ��ֲ�����Ӧ
        Sub_Vchat_AdKeyWordOperateNoty                      =2080 ,       //   �ؼ��ֹ㲥֪ͨ
        Sub_Vchat_TeacherScoreReq                           =2081 ,       //  ��ʦ�������ִ�������
        Sub_Vchat_TeacherScoreResp                          =2082 ,       //  ��ʦ�������ִ�����Ӧ
        Sub_Vchat_TeacherScoreRecordReq                     =2083 ,       //  �û���������
        Sub_Vchat_TeacherScoreRecordResp                    =2084 ,       //  �û�������Ӧ
        Sub_Vchat_RoborTeacherIdNoty                        =2085 ,       //  �����˶�Ӧ��ʦID֪ͨ
        Sub_Vchat_TeacherGiftListReq                        =2086 ,       //  ��ʦ��ʵ���ܰ�����
        Sub_Vchat_TeacherGiftListResp                       =2087 ,       //  ��ʦ��ʵ���ܰ���Ӧ
        Sub_Vchat_ReportMediaGateReq                        =2088 ,       //  �ͻ��˱���ý������������ط�����
        Sub_Vchat_ReportMediaGateResp                       =2089 ,       //  �ͻ��˱���ý������������ط������Ļ�Ӧ
        Sub_Vchat_RoomUserExceptExitReq                     =2090 ,       //  �û��쳣�Ƴ�֪ͨroomsvr
        Sub_Vchat_UserScoreNotify                           =2091 ,       //  �û��Խ�ʦ������
        Sub_Vchat_UserScoreListNotify                       =2092 ,       //  �û��Խ�ʦ�����ֹ㲥
        Sub_Vchat_RoomAndSubRoomId_Noty                     =2093 ,       //  IOS��Android���棬��Ҫ�ڽ��뷿��ͽ�ʦ�����ʱ��õ���������ӷ����ID
        Sub_Vchat_TeacherAvarageScore_Noty                  =2094 ,       //  ĳ����ʦ��ƽ����
        Sub_Vchat_SysCast_Resp                              =2095 ,       //  ���䷢��ϵͳ����
        Sub_Vchat_RoomUserExceptExitNoty                    =2096 ,       //  �û��쳣�˳�֪ͨ
        Sub_Vchat_GateJoinRoom                              =2097 ,       //  gate�л��û���roomsvr
        Sub_Vchat_RoomAmong_Notify                          =2098 ,       //  roomsvr֮�����Ϣ֪ͨ
        Sub_Vchat_RoomTeacherSubscriptionReq                =2099 ,       //  ��������
        Sub_Vchat_RoomTeacherSubscriptionResp               =2100 ,       //  ������Ӧ
        Sub_Vchat_RoomTeacherSubscriptionStateQueryReq      =2101 ,       //  ��ѯ����״̬����
        Sub_Vchat_RoomTeacherSubscriptionStateQueryResp     =2102 ,       //  ��ѯ����״̬��Ӧ
        Sub_Vchat_RoomDataSyncReq                           =2103 ,       //
        Sub_Vchat_RoomDataSyncResp                          =2104 ,       //
        Sub_Vchat_RoomDataSyncComplete                      =2105 ,       //
        Sub_Vchat_RoomDataSync_JoinRoom                     =2106 ,       //
        Sub_Vchat_RoomDataSync_LeftRoom                     =2107 ,       //
        Sub_Vchat_RoomDataSync_MicChanged                   =2108 ,       //
        Sub_Vchat_RoomDataSync_UserUpdated                  =2109 ,       //
        Sub_Vchat_RedisRoomInfo_Req                         =2110 ,       //
        Sub_Vchat_RedisRoomInfo_Resp                        =2111 ,       //
        Sub_Vchat_RedisUserInfo_Req                         =2112 ,       //
        Sub_Vchat_RedisUserInfo_Last_Req                    =2113 ,       //
        Sub_Vchat_RedisUserInfo_Resp                        =2114 ,       //
        Sub_Vchat_RedisUserInfo_Complete                    =2115 ,       //
        Sub_Vchat_RedisSync_Err_Resp                        =2116 ,       //
        Sub_Vchat_RedisSync_log_index_Req                   =2117 ,       //
        Sub_Vchat_RedisSync_log_index_Resp                  =2118 ,       //
        Sub_Vchat_RedisSync_data_Req                        =2119 ,       //
        Sub_Vchat_RedisSync_data_Resp                       =2120 ,       //
        Sub_Vchat_RedisSync_data_Complete                   =2121 ,       //
        Sub_Vchat_RedisSync_Report_Status                   =2122 ,       //
        Sub_Vchat_ChatResp                                  =2123 ,       //   ���췢����ϢӦ��
        Sub_Vchat_PreJoinRoomReq                            =2124,        //���뷿��Ԥ��������
        Sub_Vchat_PreJoinRoomResp                           =2125,        //���뷿��Ԥ������Ӧ
        Sub_Vchat_WaitiMicListInfo                          =2126 ,       // �����û��б�
        Sub_Vchat_GetUserInfoReq                            =2127,        //��ѯ�û�������������
        Sub_Vchat_GetUserInfoResp                           =2128,        //��ѯ�û�����������Ӧ
        Sub_Vchat_GetTeacherInfoResp                        =2129,        //��ѯ����ֱ����ʦ����������Ӧ
        Sub_Vchat_GetUserInfoErr                            =2130,        //��ѯ�û�������������
        Sub_Vchat_UpWaitMicReq                              =2131,        //
        Sub_Vchat_UpWaitMicResp                             =2132,
        Sub_Vchat_UpWaitMicErr                              =2133,
        Sub_Vchat_TeamTopNReq                               =2134,	      //��ǿս���ܰ�����
        Sub_Vchat_TeamTopNResp                              =2135,	      //��ǿս���ܰ��Ӧ
        Sub_Vchat_AfterJoinRoomReq                          =2136,	      //���뷿��ɹ�������������Ϣ
        
        Sub_Vchat_TeacherOnMicReq                           =20000,       //    ��ʦ����֪ͨ�����û�����
        Sub_Vchat_PrivateVipNoty                            =20001,       //    ˽�˶���֪ͨ�����û�����
        
        Sub_Vchat_UserQuanxianBegin                         =21001,       //�û�Ȩ������
        Sub_Vchat_UserQuanxianLst                           =21002,       //
        Sub_Vchat_UserQuanxianEnd                           =21003,       //
        Sub_Vchat_logonFinished                             =21004,       // ��¼���������
        Sub_VChat_QuanxianId2ListResp                       =21005,       //  Ȩ��id����
        Sub_VChat_QuanxianAction2ListBegin                  =21006,       //  Ȩ�޲�������
        Sub_VChat_QuanxianAction2ListResp                   =21007,       //
        Sub_VChat_QuanxianAction2ListFinished               =21008,       //
        Sub_Vchat_UserExitMessage_Req                       =21009,       //  �û��˳����������
        Sub_Vchat_UserExitMessage_Resp                      =21010,       //  �û��˳��������Ӧ
        Sub_Vchat_GetSecureInfoReq                          =21011,       //  �ͻ��������û�emailqq�ֻ����������Ѵ���
        Sub_Vchat_GetSecureInfoResp                         =21012,       //  �ͻ��������û�emailqq�ֻ����������Ѵ����Ļ�Ӧ
        Sub_Vchat_ClientCloseSocket_Req                     =21013,       //  clientclosesocket(thegatetellthelobbysvr)
        Sub_Vchat_logonReq4                                 =21014,       //   logonnewreq
        Sub_Vchat_logonReq5                                 =21015,       //   logonthroughotherplatform
        Sub_Vchat_logonErr2                                 =21016,       //   ��½ʧ��
        Sub_Vchat_logonSuccess2                             =21017,       //   ��½�ɹ�
        Sub_Vchat_logonTokenReq                             =21018,       //   usertokennotify
        Sub_Vchat_logonTokenNotify                          =21019,       //user token notify
        Sub_Vchat_GetUserMoreInfReq                         =21020,       //    ��ȡ�û�������Ϣ�����ֻ�������ǩ���ȣ�
        Sub_Vchat_GetUserMoreInfResp                        =21021,       //    ��ȡ�û�������ϢӦ���ֻ�������ǩ���ȣ�
        Sub_Vchat_SetUserProfileReq                         =21022,       //�����û�����
        Sub_Vchat_SetUserProfileResp                        =21023,       //
        Sub_Vchat_SetUserMoreInfoReq                        =21024,       //�����û�������Ϣ
        Sub_Vchat_SetUserMoreInfoResp                       =21025,
        
        Sub_Vchat_RoomGroupListReq                          =22001,       // �������б�����
        Sub_Vchat_RoomGroupListBegin                        =22002,       //
        Sub_Vchat_RoomGroupListResp                         =22003,       //
        Sub_Vchat_RoomGroupListFinished                     =22004,       //
        Sub_Vchat_RoomGroupStatusReq                        =22005,       // ������״̬(����)����
        Sub_Vchat_RoomGroupStatusResp                       =22006,       //
        Sub_Vchat_RoomGroupStatusFinished                   =22007,       // ������״̬(����)�б����
        Sub_Vchat_SendRoomGroupList                         =22008,       //    ��¼����hallsvr���ͷ�������б�
        Sub_Vchat_GetOnMicRobertReq                         =22009,       //    ��ȡ�����ת��������ID����
        Sub_Vchat_GetOnMicRobertResp                        =22010,       //    ��ȡ�����ת��������IDӦ��
        Sub_Vchat_BuyPrivateVipReq                          =22011,       //    ����˽�˶�������
        Sub_Vchat_BuyPrivateVipResp                         =22012,       //    ����˽�˶�����Ӧ
        Sub_Vchat_HallInterestForReq                        =22013,       //��ע����
        Sub_Vchat_HallInterestForResp                       =22014        //��ע��Ӧ
        
    };
    
    typedef enum MediaConnectActionType
    {
        Connect_You = 1,
        Disconnect_You = 3,
    }e_MediaConnectActionType;
    
    typedef enum NoticeDevType
    {
        e_Notice_PC = 0,
        e_Notice_Android = 1,
        e_Notice_IOS = 2,
        e_Notice_Web = 3,
        e_Notice_AllType = 4
    }e_NoticeDevType;
    
    typedef enum enum_AlarmLevel
    {
        alarm_level_general = 0,
        alarm_level_major,
        alarm_level_fatal
    }e_AlarmLevel;
    
    //#define BROADCAST_TYPE 9999
    
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
    typedef struct tag_CMDGateHello
    {
        uint8 param1;
        uint8 param2;
        uint8 param3;
        uint8 param4;
        uint16 gateid;
    }CMDGateHello_t;
    
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
    
    typedef struct tag_CmdServerAuthInfo
    {
        char sz1[64];
        char sz2[64];
        char sz3[64];
        char sz4[64];
        char sz5[64];
    }CmdServerAuthInfo_t;
    
    //128 bytes
    typedef struct tag_CMDClientHello_2
    {
        char encrytionContent[16];  //���ܺ������
        char encrytionKey[16];
    }CMDClientHello_t_2;
    
}

#pragma pack()

#endif  //__MESSAGE_VCHAT_HH_20130715__


