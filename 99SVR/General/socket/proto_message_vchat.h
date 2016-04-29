
#ifndef __PROTO_MESSAGE_VCHAT_H__
#define __PROTO_MESSAGE_VCHAT_H__

#include "proto_message_comm.h"

namespace protocol
{
    
    enum {
        MDM_Vchat_Login = 103,  //µÇÂ½
        MDM_Vchat_Hall = 104,  //´óÌü
        MDM_Vchat_Room = 105,  //·¿¼ä
        MDM_Vchat_Gate = 106,  //Íø¹Ø
        MDM_Vchat_WEB = 107,  //À´×ÔwebµÄÍ¨Öª
        MDM_Vchat_Text = 108,   //ÎÄ×ÖÖ±²¥·şÎñÆ÷
        MDM_Vchat_Usermgr = 109,   //À´×ÔÓÃ»§¹ÜÀí·şÎñÆ÷
        MDM_Vchat_Frtiy = 110,  //Íâ²¿ 111
        MDM_Vchat_Trust = 112,
        MDM_Vchat_Notify = 113,   //·¿¼äÍ¨Öª·şÎñÆ÷
        MDM_Vchat_Subscrib = 114,  //¶©ÔÄ·şÎñÆ÷
        MDM_Vchat_Redis_Sync = 115,  //redisÍ¬²½
        MDM_Vchat_Stastics = 198,  //Í³¼Æ·şÎñÆ÷
        MDM_Vchat_Alarm = 199,  //¸æ¾¯·şÎñÆ÷
        
        MDM_Version_Value = 10  //Ğ­Òé°æ±¾
    };
    
    enum {
        ERR_USER_IN_BLACK_LIST = 101,	//ÓÃ»§ÔÚºÚÃûµ¥
        ERR_JOINROOM_PWD_WRONG = 201,	//·¿¼äÃÜÂë²»¶Ô
        ERR_FAIL_CREATE_USER = 203,		//´´½¨ÓÃ»§Ê§°Ü(ÓÃ»§Ãû/ÃÜÂëÊ§°Ü)
        ERR_KICKOUT_SAMEACCOUNT = 107,	//Í¬ºÅ¼ÓÈë·¿¼äÌß³ö
        ERR_EXCEPTION_QUIT_ROOM = 108,
        ERR_ROOM_NOT_EXIST = 404,		//·¿¼ä²»´æÔÚ
        ERR_ROOM_IS_CLOSED = 405,		//·¿¼äÒÑ¾­¹Ø±Õ
        ERR_ROOM_USER_IS_FULL = 502,	//·¿¼äÈËÊıÒÑÂú
        ERR_KICKOUT_TIMEOUT = 522,		//³¬Ê±Ìß³ö
        ERR_KICKOUT_AD = 600			//´ò¹ã¸æÌß³ö
    };
    
    enum {
        ERR_CODE_SUCCESS = 0,	//³É¹¦
        
        ERR_CODE_FAILED =                   1000, //Ê§°Ü 1000~1999
        ERR_CODE_FAILED_PACKAGEERROR =      1001,  //ÇëÇó°ü³¤¶È´íÎó
        ERR_CODE_FAILED_DBERROR =           1002, //Êı¾İ¿âÀàĞÍ´íÎó
        
        ERR_CODE_FAILED_INVALIDCHAR =       1003,//ÊäÈëÁË·Ç·¨×Ö·û
        ERR_CODE_FAILED_USERNOTFOUND =      1004, //ÕÒ²»µ½¸ÃÓÃ»§
        ERR_CODE_FAILED_USERFROSEN =        1005, //ÓÃ»§±»¶³½á
        
        ERR_CODE_FAILED_UNKNONMESSAGETYPE = 1006, //Î´ÖªÏûÏ¢ÀàĞÍ
        
        ERR_CODE_FAILED_REQUEST_OUTOFRANGE = 1007, //ÇëÇóÊı¾İ¹ı¶à»òÕßÄÚÈİ¹ı³¤
        
        ERR_CODE_FAILED_SAMEUSERLOGIN =     1008,   //ÍêÈ«ÏàÍ¬µÄÓÃ»§¼ÓÈë·¿¼ä
        ERR_CODE_FAILED_AREAIDNOTFOUND =    1009,   //Ã»ÓĞÕÒµ½ÇøÓòID
        ERR_CODE_FAILED_ROOMIDNOTFOUND =    1010,   //Ã»ÓĞÕÒµ½·¿¼äID
        ERR_CODE_FAILED_CRC =               1011,   //CRCĞ£Ñé´íÎó
        ERR_CODE_FAILED_CREATEUSER =        1012,   //Ã»ÓĞÕÒµ½´´½¨ÓÃ»§Ê§°Ü
        ERR_CODE_FAILED_KEYWORDFOUND =      1013,   //·¢ÏÖ¹Ø¼ü´
        ERR_CODE_FAILED_NOT_ENOUGH_GOLD =   1014,   //½ğ±Ò²»×ã
        ERR_CODE_FAILED_ALREADY_BUY =       1015,   //ÒÑ¾­¹ºÂò
        ERR_CODE_FAILED_PRIVATENOTFOUND =   1016    //Ã»ÓĞ¸ÃË½ÈË¶©ÖÆ
    };
    
    enum {
        Sub_Vchat_ClientHello                               =1    ,       //ÎÕÊÖÃ¿¸öMDMmainCmd²»Ò»Ñù
        Sub_Vchat_ClientPing                                =2    ,       //pingÃ¿¸öMDMmainCmd²»Ò»Ñù
        Sub_Vchat_ClientPingResp                            =3    ,       //ping»ØÓ¦
        Sub_Vchat_GetAllUserReq                             =4    ,       //  »ñÈ¡ËùÓĞµÄÔÚÏßÓÃ»§
        Sub_Vchat_Resp_ErrCode                              =5    ,       //  ·µ»Ø´íÎóÓ¦´ğ
        Sub_Vchat_DoNotReachRoomServer                      =6    ,       //
        Sub_Vchat_MgrRefreshListReq                         =7    ,       //  Ë¢ĞÂÇëÇó
        Sub_Vchat_MgrRefreshListNotify                      =8    ,       //
        Sub_Vchat_MgrRelieveBlackDBReq                      =9    ,       //           ½â³ıºÚÃûµ¥ÇëÇó
        Sub_Vchat_MgrRelieveBlackDBNoty                     =10   ,       //
        
        Sub_Vchat_LogonNot                                  =361  ,       //  ÓÃ»§ÉÏÏßÍ¨Öª
        Sub_Vchat_LogoutNot                                 =362  ,       //  ÓÃ»§ÏÂÏßÍ¨Öª--ÌßÈË·şÎñÆ÷¹ıÀ´
        Sub_Vchat_ClientExistNot                            =363  ,       //  ÓÃ»§ÏÂÏßÍ¨Öª--¸ø¿Í»§¶Ë
        Sub_Vchat_HitGoldEgg_ToClient_Noty                  =1001 ,       //   ÔÒ½ğµ°Í¨Öª¿Í»§¶Ë
        Sub_Vchat_ClientNotify                              =10194,       //    ÍÆËÍÃüÁî
        Sub_Vchat_notifyReq                                 =10197,       //Í¨¸æÇëÇó
        
        Sub_Vchat_JoinRoomReq                               =2000 ,       // ¼ÓÈë·¿¼äÇëÇó
        Sub_Vchat_JoinRoomErr                               =2001 ,       // ´íÎó
        Sub_Vchat_JoinRoomResp                              =2002 ,       // ³É¹¦º¬¹ÜÀíÁĞ±í
        Sub_Vchat_JoinOtherRoomNoty                         =2003 ,       // ½øÈëÆäËû·¿¼äÍ¨Öª(·şÎñÆ÷Ö®¼äÓÃ)
        Sub_Vchat_RoomUserListReq                           =2004 ,       // ·¿¼äÓÃ»§ÁĞ±íÇëÇó
        Sub_Vchat_RoomUserListBegin                         =2005 ,       // adbyguchengzhi20150202
        Sub_Vchat_RoomUserListResp                          =2006 ,       // »ØÓ¦(ÍÆ²¥)
        Sub_Vchat_RoomUserListFinished                      =2007 ,       // ÇëÇó¼ÓÈë·¿¼ä½×¶ÎÍê³É½çÃæ¸üĞÂÊı¾İ
        Sub_Vchat_RoomUserNoty                              =2008 ,       // ÁĞ±í¸üĞÂÍ¨Öª
        Sub_Vchat_RoomPubMicState                           =2009 ,       // ·¿¼ä¹«Âó×´Ì¬
        Sub_Vchat_RoomUserExitReq                           =2010 ,       // ÓÃ»§×Ô¼ºÍË³ö·¿¼ä
        Sub_Vchat_RoomUserExitResp                          =2011 ,       //
        Sub_Vchat_RoomUserExitNoty                          =2012 ,       // Í¨Öª
        Sub_Vchat_RoomKickoutUserReq                        =2013 ,       // Ìß³öÓÃ»§ÇëÇó
        Sub_Vchat_RoomKickoutUserResp                       =2014 ,       //
        Sub_Vchat_RoomKickoutUserNoty                       =2015 ,       // Í¨Öª
        Sub_Vchat_ChatReq                                   =2016 ,       // ÁÄÌì·¢³öÏûÏ¢
        Sub_Vchat_ChatErr                                   =2017 ,       //
        Sub_Vchat_ChatNotify                                =2018 ,       // ×ª·¢ÏûÏ¢
        Sub_Vchat_TradeGiftReq                              =2019 ,       // ÔùËÍÀñÎï(¿ç·¿¼ä¿çÆ½Ì¨)ÇëÇó
        Sub_Vchat_TradeGiftResp                             =2020 ,       //
        Sub_Vchat_TradeGiftErr                              =2021 ,       //
        Sub_Vchat_TradeGiftNotify                           =2022 ,       //
        Sub_Vchat_SysNoticeInfo                             =2023 ,       // ÏµÍ³¹ã²¥(×¨ÃÅ)ÏûÏ¢
        Sub_Vchat_UserAccountInfo                           =2024 ,       // ÓÃ»§ÕË»§(Óà¶î)ĞÅÏ¢
        Sub_Vchat_RoomInfoNotify                            =2025 ,       // ·¿¼äĞÅÏ¢×ÊÁÏ
        Sub_Vchat_RoomManagerNotify                         =2026 ,       // ·¿¼ä¹ÜÀíÔ±
        Sub_Vchat_RoomMediaNotify                           =2027 ,       // ·¿¼äÃ½Ìå
        Sub_Vchat_RoomNoticeNotify                          =2028 ,       // ·¿¼ä¹«¸æ
        Sub_Vchat_RoomOPStatusNotify                        =2029 ,       // ·¿¼ä×´Ì¬
        Sub_Vchat_SetMicStateReq                            =2030 ,       // ÉèÖÃÉÏ/ÏÂÂó×´Ì¬
        Sub_Vchat_SetMicStateResp                           =2031 ,       //
        Sub_Vchat_SetMicStateErr                            =2032 ,       //
        Sub_Vchat_SetMicStateNotify                         =2033 ,       //
        Sub_Vchat_SetDevStateReq                            =2034 ,       // ÉèÖÃÉè±¸×´Ì¬
        Sub_Vchat_SetDevStateResp                           =2035 ,       //
        Sub_Vchat_SetDevStateErr                            =2036 ,       //
        Sub_Vchat_SetDevStateNotify                         =2037 ,       //
        Sub_Vchat_SetUserAliasReq                           =2038 ,       // ÉèÖÃÓÃ»§ÄØ³Æ
        Sub_Vchat_SetUserAliasResp                          =2039 ,       //
        Sub_Vchat_SetUserAliasErr                           =2040 ,       //
        Sub_Vchat_SetUserAliasNotify                        =2041 ,       //
        Sub_Vchat_SetUserPriorityReq                        =2042 ,       // ÉèÖÃÓÃ»§È¨ÏŞ
        Sub_Vchat_SetUserPriorityResp                       =2043 ,       //
        Sub_Vchat_SetUserPriorityNotify                     =2044 ,       //
        Sub_Vchat_SeeUserIpReq                              =2045 ,       // ²é¿´ÓÃ»§IPÇëÇó
        Sub_Vchat_SeeUserIpResp                             =2046 ,       //
        Sub_Vchat_SeeUserIpErr                              =2047 ,       //
        Sub_Vchat_ThrowUserReq                              =2048 ,       // ·âÉ±ÓÃ»§
        Sub_Vchat_ThrowUserResp                             =2049 ,       //
        Sub_Vchat_ThrowUserNotify                           =2050 ,       //
        Sub_Vchat_ForbidUserChatReq                         =2051 ,       // ½ûÑÔÓÃ»§ÇëÇó
        Sub_Vchat_ForbidUserChatNotify                      =2052 ,       //
        Sub_Vchat_FavoriteVcbReq                            =2053 ,       //  ÊÕ²Ø·¿¼äÇëÇó
        Sub_Vchat_FavoriteVcbResp                           =2054 ,       //
        Sub_Vchat_SetRoomInfoReq                            =2055 ,       //  ÉèÖÃ·¿¼äĞÅÏ¢ÇëÇó
        Sub_Vchat_SetRoomInfoResp                           =2056 ,       //
        Sub_Vchat_SetRoomOPStatusReq                        =2057 ,       //  ÉèÖÃ·¿¼äÔËĞĞÊôĞÔ(×´Ì¬)
        Sub_Vchat_SetRoomOPStatusResp                       =2058 ,       //
        Sub_Vchat_SetRoomNoticeReq                          =2059 ,       //  ÉèÖÃ·¿¼ä¹«¸æĞÅÏ¢ÇëÇó
        Sub_Vchat_SetRoomNoticeResp                         =2060 ,       //
        Sub_Vchat_SetRoomMediaReq                           =2061 ,       //  ÉèÖÃ·¿¼äÃ½Ìå·şÎñÆ÷ÇëÇóaddbyguchengzhi20150202
        Sub_Vchat_SetUserPwdReq                             =2062 ,       //  ÉèÖÃÓÃ»§ÃÜÂë
        Sub_Vchat_SetUserPwdResp                            =2063 ,       //
        Sub_Vchat_QueryUserAccountReq                       =2064 ,       //  ÓÃ»§ÕË»§²éÑ¯(ÒøĞĞ²éÑ¯)
        Sub_Vchat_QueryUserAccountResp                      =2065 ,       //
        Sub_Vchat_QueryVcbExistReq                          =2066 ,       //  ²éÑ¯Ä³·¿¼äÊÇ·ñ´æÔÚ
        Sub_Vchat_QueryVcbExistResp                         =2067 ,       //  ¸ÃÏûÏ¢Ã»ÓĞerr
        Sub_Vchat_QueryUserExistReq                         =2068 ,       //  ²éÑ¯Ä³ÓÃ»§ÊÇ·ñ´æÔÚ
        Sub_Vchat_QueryUserExistResp                        =2069 ,       //  ¸ÃÏûÏ¢Ã»ÓĞerr
        Sub_Vchat_GateCloseObjectReq                        =2070 ,       //  ¹Ø±ÕÍø¹ØÉÏÃæµÄ¶ÔÏó
        Sub_Vchat_CloseRoomNotify                           =2071 ,       //  ¹Ø±Õ·¿¼äÍ¨Öª
        Sub_Vchat_RoomGatePing                              =2072 ,       //
        Sub_Vchat_SetRoomInfoReq_v2                         =2073 ,       //  ÉèÖÃ·¿¼äĞÅÏ¢ÇëÇó·É²æ°æ
        Sub_Vchat_SetRoomInfoResp_v2                        =2074 ,       //
        Sub_Vchat_SetRoomInfoNoty_v2                        =2075 ,       //
        Sub_Vchat_QueryRoomGateAddrReq                      =2076 ,       //  »ñÈ¡·¿¼äÍø¹ØµØÖ·
        Sub_Vchat_QueryRoomGateAddrResp                     =2077 ,       //
        Sub_Vchat_AdKeyWordOperateReq                       =2078 ,       //   ¹Ø¼ü×Ö²Ù×÷ÇëÇó
        Sub_Vchat_AdKeyWordOperateResp                      =2079 ,       //  ¹Ø¼ü×Ö²Ù×÷»ØÓ¦
        Sub_Vchat_AdKeyWordOperateNoty                      =2080 ,       //   ¹Ø¼ü×Ö¹ã²¥Í¨Öª
        Sub_Vchat_TeacherScoreReq                           =2081 ,       //  ½²Ê¦·¢ËÍÆÀ·Ö´¦ÀíÇëÇó
        Sub_Vchat_TeacherScoreResp                          =2082 ,       //  ½²Ê¦·¢ËÍÆÀ·Ö´¦ÀíÏìÓ¦
        Sub_Vchat_TeacherScoreRecordReq                     =2083 ,       //  ÓÃ»§ÆÀ·ÖÇëÇó
        Sub_Vchat_TeacherScoreRecordResp                    =2084 ,       //  ÓÃ»§ÆÀ·ÖÏìÓ¦
        Sub_Vchat_RoborTeacherIdNoty                        =2085 ,       //  »úÆ÷ÈË¶ÔÓ¦½²Ê¦IDÍ¨Öª
        Sub_Vchat_TeacherGiftListReq                        =2086 ,       //  ½²Ê¦ÖÒÊµ¶ÈÖÜ°æÇëÇó
        Sub_Vchat_TeacherGiftListResp                       =2087 ,       //  ½²Ê¦ÖÒÊµ¶ÈÖÜ°æÏìÓ¦
        Sub_Vchat_ReportMediaGateReq                        =2088 ,       //  ¿Í»§¶Ë±¨¸æÃ½Ìå·şÎñÆ÷ºÍÍø¹Ø·şÎñÆ÷
        Sub_Vchat_ReportMediaGateResp                       =2089 ,       //  ¿Í»§¶Ë±¨¸æÃ½Ìå·şÎñÆ÷ºÍÍø¹Ø·şÎñÆ÷µÄ»ØÓ¦
        Sub_Vchat_RoomUserExceptExitReq                     =2090 ,       //  ÓÃ»§Òì³£ÍÆ³öÍ¨Öªroomsvr
        Sub_Vchat_UserScoreNotify                           =2091 ,       //  ÓÃ»§¶Ô½²Ê¦µÄÆÀ·Ö
        Sub_Vchat_UserScoreListNotify                       =2092 ,       //  ÓÃ»§¶Ô½²Ê¦µÄÆÀ·Ö¹ã²¥
        Sub_Vchat_RoomAndSubRoomId_Noty                     =2093 ,       //  IOSºÍAndroid·½Ãæ£¬ĞèÒªÔÚ½øÈë·¿¼äºÍ½²Ê¦ÉÏÂóµÄÊ±ºòµÃµ½Ö÷·¿¼äºÍ×Ó·¿¼äµÄID
        Sub_Vchat_TeacherAvarageScore_Noty                  =2094 ,       //  Ä³¸ö½²Ê¦µÄÆ½¾ù·Ö
        Sub_Vchat_SysCast_Resp                              =2095 ,       //  ·¿¼ä·¢ËÍÏµÍ³¹«¸æ
        Sub_Vchat_RoomUserExceptExitNoty                    =2096 ,       //  ÓÃ»§Òì³£ÍË³öÍ¨Öª
        Sub_Vchat_GateJoinRoom                              =2097 ,       //  gateÇĞ»»ÓÃ»§µ½roomsvr
        Sub_Vchat_RoomAmong_Notify                          =2098 ,       //  roomsvrÖ®¼äµÄÏûÏ¢Í¨Öª
        Sub_Vchat_RoomTeacherSubscriptionReq                =2099 ,       //  ¶©ÔÄÇëÇó
        Sub_Vchat_RoomTeacherSubscriptionResp               =2100 ,       //  ¶©ÔÄÏìÓ¦
        Sub_Vchat_RoomTeacherSubscriptionStateQueryReq      =2101 ,       //  ²éÑ¯¶©ÔÄ×´Ì¬ÇëÇó
        Sub_Vchat_RoomTeacherSubscriptionStateQueryResp     =2102 ,       //  ²éÑ¯¶©ÔÄ×´Ì¬ÏìÓ¦
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
        Sub_Vchat_ChatResp                                  =2123 ,       //   ÁÄÌì·¢³öÏûÏ¢Ó¦´ğ
        Sub_Vchat_PreJoinRoomReq                            =2124,        //¼ÓÈë·¿¼äÔ¤´¦ÀíÇëÇó
        Sub_Vchat_PreJoinRoomResp                           =2125,        //¼ÓÈë·¿¼äÔ¤´¦ÀíÏìÓ¦
        Sub_Vchat_WaitiMicListInfo                          =2126 ,       // ÅÅÂóÓÃ»§ÁĞ±í
        Sub_Vchat_GetUserInfoReq                            =2127,        //²éÑ¯ÓÃ»§¸öÈË×ÊÁÏÇëÇó
        Sub_Vchat_GetUserInfoResp                           =2128,        //²éÑ¯ÓÃ»§¸öÈË×ÊÁÏÏìÓ¦
        Sub_Vchat_GetTeacherInfoResp                        =2129,        //²éÑ¯ÎÄ×ÖÖ±²¥½²Ê¦¸öÈË×ÊÁÏÏìÓ¦
        Sub_Vchat_GetUserInfoErr                            =2130,        //²éÑ¯ÓÃ»§¸öÈË×ÊÁÏÇëÇó
        Sub_Vchat_UpWaitMicReq                              =2131,        //
        Sub_Vchat_UpWaitMicResp                             =2132,
        Sub_Vchat_UpWaitMicErr                              =2133,
        Sub_Vchat_TeamTopNReq                               =2134,	      //×îÇ¿Õ½¶ÓÖÜ°ñÇëÇó
        Sub_Vchat_TeamTopNResp                              =2135,	      //×îÇ¿Õ½¶ÓÖÜ°ñ»ØÓ¦
        Sub_Vchat_AfterJoinRoomReq                          =2136,	      //¼ÓÈë·¿¼ä³É¹¦ºóÇëÇóÍÆËÍĞÅÏ¢
        
        Sub_Vchat_TeacherOnMicReq                           =20000,       //    ½²Ê¦ÉÏÂóÍ¨Öª¶©ÔÄÓÃ»§ÇëÇó
        Sub_Vchat_PrivateVipNoty                            =20001,       //    Ë½ÈË¶©ÖÆÍ¨Öª¶©ÔÄÓÃ»§ÇëÇó
        
        Sub_Vchat_UserQuanxianBegin                         =21001,       //ÓÃ»§È¨ÏŞÊı¾İ
        Sub_Vchat_UserQuanxianLst                           =21002,       //
        Sub_Vchat_UserQuanxianEnd                           =21003,       //
        Sub_Vchat_logonFinished                             =21004,       // µÇÂ¼Íê³ÉÎŞÊı¾İ
        Sub_VChat_QuanxianId2ListResp                       =21005,       //  È¨ÏŞidÊı¾İ
        Sub_VChat_QuanxianAction2ListBegin                  =21006,       //  È¨ÏŞ²Ù×÷Êı¾İ
        Sub_VChat_QuanxianAction2ListResp                   =21007,       //
        Sub_VChat_QuanxianAction2ListFinished               =21008,       //
        Sub_Vchat_UserExitMessage_Req                       =21009,       //  ÓÃ»§ÍË³öÈí¼şµÄÇëÇó
        Sub_Vchat_UserExitMessage_Resp                      =21010,       //  ÓÃ»§ÍË³öÈí¼şµÄÏìÓ¦
        Sub_Vchat_GetSecureInfoReq                          =21011,       //  ¿Í»§¶ËÇëÇóÓÃ»§emailqqÊÖ»úºÅÂëÒÑÌáĞÑ´ÎÊı
        Sub_Vchat_GetSecureInfoResp                         =21012,       //  ¿Í»§¶ËÇëÇóÓÃ»§emailqqÊÖ»úºÅÂëÒÑÌáĞÑ´ÎÊıµÄ»ØÓ¦
        Sub_Vchat_ClientCloseSocket_Req                     =21013,       //  clientclosesocket(thegatetellthelobbysvr)
        Sub_Vchat_logonReq4                                 =21014,       //   logonnewreq
        Sub_Vchat_logonReq5                                 =21015,       //   logonthroughotherplatform
        Sub_Vchat_logonErr2                                 =21016,       //   µÇÂ½Ê§°Ü
        Sub_Vchat_logonSuccess2                             =21017,       //   µÇÂ½³É¹¦
        Sub_Vchat_logonTokenReq                             =21018,       //   usertokennotify
        Sub_Vchat_logonTokenNotify                          =21019,       //user token notify
        Sub_Vchat_GetUserMoreInfReq                         =21020,       //    »ñÈ¡ÓÃ»§¸ü¶àĞÅÏ¢ÇëÇó£¨ÊÖ»ú£¬¸öĞÔÇ©ÃûµÈ£©
        Sub_Vchat_GetUserMoreInfResp                        =21021,       //    »ñÈ¡ÓÃ»§¸ü¶àĞÅÏ¢Ó¦´ğ£¨ÊÖ»ú£¬¸öĞÔÇ©ÃûµÈ£©
        Sub_Vchat_SetUserProfileReq                         =21022,       //ÉèÖÃÓÃ»§×ÊÁÏ
        Sub_Vchat_SetUserProfileResp                        =21023,       //
        Sub_Vchat_SetUserMoreInfoReq                        =21024,       //ÉèÖÃÓÃ»§¸ü¶àĞÅÏ¢
        Sub_Vchat_SetUserMoreInfoResp                       =21025,
        
        Sub_Vchat_RoomGroupListReq                          =22001,       // ·¿¼ä×éÁĞ±íÇëÇó
        Sub_Vchat_RoomGroupListBegin                        =22002,       //
        Sub_Vchat_RoomGroupListResp                         =22003,       //
        Sub_Vchat_RoomGroupListFinished                     =22004,       //
        Sub_Vchat_RoomGroupStatusReq                        =22005,       // ·¿¼ä×é×´Ì¬(ÈËÊı)ÇëÇó
        Sub_Vchat_RoomGroupStatusResp                       =22006,       //
        Sub_Vchat_RoomGroupStatusFinished                   =22007,       // ·¿¼ä×é×´Ì¬(ÈËÊı)ÁĞ±í½áÊø
        Sub_Vchat_SendRoomGroupList                         =22008,       //    µÇÂ¼´¥·¢hallsvr·¢ËÍ·¿¼ä·Ö×éÁĞ±í
        Sub_Vchat_GetOnMicRobertReq                         =22009,       //    »ñÈ¡·¿¼äµÄ×ª²¥»úÆ÷ÈËIDÇëÇó
        Sub_Vchat_GetOnMicRobertResp                        =22010,       //    »ñÈ¡·¿¼äµÄ×ª²¥»úÆ÷ÈËIDÓ¦´ğ
        Sub_Vchat_BuyPrivateVipReq                          =22011,       //    ¹ºÂòË½ÈË¶©ÖÆÇëÇó
        Sub_Vchat_BuyPrivateVipResp                         =22012,       //    ¹ºÂòË½ÈË¶©ÖÆÏìÓ¦
        Sub_Vchat_HallInterestForReq                        =22013,       //¹Ø×¢ÇëÇó
        Sub_Vchat_HallInterestForResp                       =22014        //¹Ø×¢ÏìÓ¦
        
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
        uint32 userid;        //ÓÃ»§id
        uint32 roomid;        //·¿¼äid
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
        char encrytionContent[16];  //¼ÓÃÜºóµÄÄÚÈİ
        char encrytionKey[16];
    }CMDClientHello_t_2;
    
}

#pragma pack()

#endif  //__MESSAGE_VCHAT_HH_20130715__


