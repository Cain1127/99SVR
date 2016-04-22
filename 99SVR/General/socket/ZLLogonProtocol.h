//
//  Test.h
//  testprotocol
//
//  Created by xia zhonglin  on 3/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#ifndef Test_h
#define Test_h


#import <Foundation/Foundation.h>
@class RoomInfo;
#import "videoroom_cmd_vchat.h"
#import "VideoRoomListener.h"
#import "VideoRoomConnection.h"
#include "LoginConnection.h"

extern NSMutableArray *aryRoomChat;
extern NSMutableArray *aryRoomPrichat;
extern NSMutableArray *aryRoomUser;
extern NSMutableArray *aryRoomNotice;
extern NSMutableDictionary *dictRoomUser;
extern RoomInfo *currentRoom;


class ZLConnectionListerner : public ConnectionListener
{
    void OnConnected()
    {
        LOG("OnConnected");
        
    }
    void OnConnectError(int err_code)
    {
        LOG("OnConnectError");
    }
    
    void OnIOError(int err_code);
};

class ZLHallListener: public HallListener
{
    void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req);
    void OnSetUserPwdResp(SetUserPwdResp& info);
    void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info){}
    void OnGetUserMoreInfResp(GetUserMoreInfResp& info);
    void OnUserExitMessageResp(ExitAlertResp& info){}

    void OnHallMessageNotify(MessageNoty& info){}
    void OnMessageUnreadResp(MessageUnreadResp& info){}
    void OnInteractResp(std::vector<InteractResp>& infos){}
    void OnHallAnswerResp(std::vector<AnswerResp>& infos){}
    void OnViewShowResp(std::vector<ViewShowResp>& infos){}
    void OnTeacherFansResp(std::vector<TeacherFansResp>& infos){}
    void OnInterestResp(std::vector<InterestResp>& infos){}
    void OnUnInterestResp(std::vector<UnInterestResp>& infos){}
    void OnTextLivePointListResp(std::vector<TextLivePointListResp>& infos){}
    void OnSecretsListResp(HallSecretsListResp& infos){}
    void OnSystemInfoResp(HallSystemInfoListResp& infos){}
    void OnViewAnswerResp(ViewAnswerResp& info){}
    void OnInterestForResp(InterestForResp& info){}
    void OnFansCountResp(FansCountResp& info){}
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
};

class ZLPushListener: public PushListener
{
    
public:

    void OnConfChanged(int version);

    virtual void OnGiftListChanged(int version);
    
    virtual void OnShowFunctionChanged(int version);
    
    virtual void OnPrintLog();
    
    virtual void OnUpdateApp();
    
    virtual void OnMoneyChanged(uint64 money);
    
    virtual void OnBayWindow(BayWindow& info);
    
    virtual void OnRoomGroupChanged();
    
    virtual void OnRoomTeacherOnMicResp(RoomTeacherOnMicResp& info);
    
};


class ZLLoginListener : public LoginListener
{
    
public:
    
    void OnMessageComming(void* msg);
   
    void OnLogonSuccess(UserLogonSuccess2& info);
    
    void OnLogonErr(UserLogonErr2& info);
    
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
    void OnLogonTokenNotify(SessionTokenResp& info);
    
    void OnLogonFinished()
    {
        LOG("OnlogonFinished\n");
    }
};

class ZLLogonProtocol
{
    
public :
    ZLLogonProtocol();
    /**
     *  修改密码
     */
    int updatePwd(const char *cOld,const char *cNew);
    /**
     *  正常账号登录
     */
    int startLogin(const char *cloginid,const char *pwd,const char *md5Pwd);
    /**
     *  修改昵称
     */
    int updateNick(const char *cNick,const char *intro,int sex);
    /**
     *  第三方登录
     */
    int startOtherLogin(uint32 cloginid,const char *openid,const char *token);
    /**
     *  关闭protocol
     */
    int closeProtocol();
    /**
     *  connect Room
     */
    void connectRoomInfo(int nRoomId,int platform,const char *roomPwd="");
    /**
     *  送花
     */
    void sendRose();
    /**
     *  发送聊天信息
     */
    void sendMessage(const char *msg,int toId,const char *toalias);
    /**
     *  关闭房间信息
     */
    void exitRoomInfo();
    /**
     *  赠送礼物
     */
    void sendGift(int giftId,int num);
    
    ~ZLLogonProtocol();
};

class ZLRoomListener : public RoomListener
{
    void OnMessageComming(void* msg);//{vedio_room_conn.DispatchSocketMessage(msg);}
    
    void OnJoinRoomResp(JoinRoomResp& info);//{info.Log();}//º”»Î∑øº‰≥…π¶
    void OnJoinRoomErr(JoinRoomErr& info);//{info.Log();}//º”»Î∑øº‰ ß∞‹
    void OnRoomUserList(std::vector<RoomUserInfo>& infos);

    void OnRoomUserNoty(RoomUserInfo& info);
    
    void OnRoomPubMicStateNoty(std::vector<RoomPubMicState>& infos);
    void OnRoomUserExitResp()
    {
    }
    void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info);
    
    
    void OnRoomKickoutUserResp(){}//
    void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info);//∑øº‰”√ªßÃﬂ≥ˆÕ®÷™
    
    // ‘› ±“—ªƒ∑œ
    //void OnFlyGiftListInfoReq(TradeGiftRecord& info){}//¥Û¿ÒŒÔ–≈œ¢
    
    void OnWaitiMicListInfo(std::vector<int > &infos)
    {
        for(int i = 0; i < infos.size(); i++)
        {
            LOG("%d", infos[i]);//OK
        }
    }//≈≈¬Û¡–±Ì
    
    
    void OnChatErr(){}//
    void OnChatNotify(RoomChatMsg& info);
    
    //ÀÕ¿ÒŒÔ
    void OnTradeGiftRecordResp(TradeGiftRecord& info);
    
    void OnTradeGiftErr(TradeGiftErr& info);
    
    void OnTradeGiftNotify(TradeGiftRecord& info);
    
    //ÀÕª®
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
    
    //—Ãª
//    void OnTradeFireworksErr(TradeFireworksErr& info)
//    {
//        info.Log();
//    }
    void OnTradeFireworksNotify(TradeFireworksNotify& info)
    {
        info.Log();
    }
    
    void OnLotteryGiftNotify(LotteryGiftNotice& info)
    {
        info.Log();
    }//¿ÒŒÔ÷–Ω±Õ®÷™ ˝æ›
    
    void OnBoomGiftNotify(BoomGiftNotice& info)
    {
        info.Log();
    }//±¨’®÷–Ω±Õ®÷™ ˝æ›
    
    void OnSysNoticeInfo(SysCastNotice& info)
    {
        info.Log();//OK
    }//œµÕ≥œ˚œ¢Õ®÷™ ˝æ›
    
    void OnUserAccountInfo(UserAccountInfo& info)
    {
        info.Log();
    }//”√ªß’ ªß ˝æ›
    
    void OnRoomManagerNotify()
    {
        //info.Log();
    }//∑øº‰π‹¿ÌÕ®÷™ ˝æ›
    
    void OnRoomMediaInfo(RoomMediaInfo& info)
    {
        info.Log();
    }//∑øº‰√ΩÃÂ ˝æ›Õ®÷™
    
    void OnRoomNoticeNotify(RoomNotice& info);
    
    void OnRoomOpState(RoomOpState& info)
    {
        info.Log();
    }//∑øº‰◊¥Ã¨ ˝æ›Õ®÷™
    
    void OnRoomInfoNotify(RoomBaseInfo& info)
    {
        info.Log();//OK
    }//∑øº‰–≈œ¢ ˝æ›Õ®÷™
    
    void OnThrowUserNotify(ThrowUserInfo& info)
    {
        info.Log();
    }//∑øº‰∑‚…±”√ªßÕ®÷™
    
    void OnUpWaitMicResp(UpWaitMic& info)
    {
        info.Log();
        //LOG("OnUpWaitMicResp = %d", ret);
    }//…œ≈≈¬ÛœÏ”¶
    void OnUpWaitMicErr(UpWaitMic& info)
    {
        info.Log();
        //LOG("OnUpWaitMicErr = %d", ret);
    }//…œ≈≈¬Û¥ÌŒÛ
    
    void OnChangePubMicStateNotify(ChangePubMicStateNoty& info)
    {
        info.Log();//OK
    }//π´¬Û◊¥Ã¨Õ®÷™
    
    //¥´ ‰√ΩÃÂ
    void OnTransMediaReq(){}//¥´ ‰√ΩÃÂ«Î«Û
    void OnTransMediaResp(){}//¥´ ‰√ΩÃÂœÏ”¶
    void OnTransMediaErr(){}//¥´ ‰√ΩÃÂ¥ÌŒÛ
    
    //…Ë÷√¬Û◊¥Ã¨
    void OnSetMicStateResp(){}//…Ë÷√¬Û◊¥Ã¨œÏ”¶
    void OnSetMicStateErr(UserMicState& info)
    {
        info.Log();
    }//…Ë÷√¬Û◊¥Ã¨¥ÌŒÛ
    void OnSetMicStateNotify(UserMicState& info);
    
    //…Ë÷√…Ë±∏◊¥Ã¨
    void OnSetDevStateResp(UserDevState& info)
    {
        info.Log();//OK
    }//…Ë÷√…Ë±∏◊¥Ã¨œÏ”¶
    void OnSetDevStateErr(UserDevState& info)
    {
        info.Log();//OK
    }//…Ë÷√…Ë±∏◊¥Ã¨¥ÌŒÛ
    void OnSetDevStateNotify(UserDevState& info)
    {
        info.Log();//OK
    }//…Ë÷√…Ë±∏◊¥Ã¨Õ®÷™
    
    //…Ë÷√”√ªßƒÿ≥∆
    void OnSetUserAliasResp(UserAliasState& info)
    {
        info.Log();//OK
    }//…Ë÷√”√ªßƒÿ≥∆œÏ”¶
    void OnSetUserAliasErr(UserAliasState& info)
    {
        info.Log();//OK
    }//…Ë÷√”√ªßƒÿ≥∆¥ÌŒÛ
    void OnSetUserAliasNotify(UserAliasState& info)
    {
        info.Log();//OK
    }//…Ë÷√”√ªßƒÿ≥∆Õ®÷™
    
    //…Ë÷√”√ªß»®œﬁ(π‹¿Ì)
    void OnSetUserPriorityResp(SetUserPriorityResp& info)
    {
        info.Log();//OK
    }//…Ë÷√”√ªß»®œﬁ(π‹¿Ì)œÏ”¶
    void OnSetUserPriorityNotify(SetUserPriorityResp& info)
    {
        info.Log();//OK
    }//…Ë÷√”√ªß»®œﬁ(π‹¿Ì)œÏ”¶
    
    //≤Ïø¥”√ªßIP
    void OnSeeUserIpResp(SeeUserIpResp& info)
    {
        info.Log();//OK
    }//≤Ïø¥”√ªßIPœÏ”¶
    void OnSeeUserIpErr(SeeUserIpResp& info)
    {
        info.Log();//OK
    }//≤Ïø¥”√ªßIP¥ÌŒÛ
    
    void OnThrowUserResp(ThrowUserInfoResp& info)
    {
        info.Log();
    }//∑‚…±∑øº‰”√ªßœÏ”¶
    
    void OnForbidUserChatNotify(ForbidUserChat& info)
    {
        info.Log();//OK
    }//Ω˚—‘Õ®÷™
    
    //void OnFavoriteVcbResp(){}// ’≤ÿ∑øº‰œÏ”¶£¨’‚∏ˆ∑˛ŒÒ∆˜∆‰ µ «√ª”–œÏ”¶µƒ
    
    void OnSetRoomNoticeResp(SetRoomNoticeResp& info)
    {
        info.Log();//OK
    }//…Ë÷√∑øº‰π´∏ÊœÏ”¶
    
    void OnSetRoomInfoResp(SetRoomInfoResp& info)
    {
        info.Log();//OK
    }//…Ë÷√∑øº‰–≈œ¢œÏ”¶
    
    void OnSetRoomOPStatusResp(SetRoomOPStatusResp& info)
    {
        info.Log();//OK
    }//…Ë÷√∑øº‰◊¥Ã¨–≈œ¢œÏ”¶
    
    void OnQueryUserAccountResp(QueryUserAccountResp& info)
    {
        info.Log();//OK
    }//≤È—Ø”√ªß’ ªßœÏ”¶
    
    void OnSetWatMicMaxNumLimitNotify(SetRoomWaitMicMaxNumLimit& info)
    {
        info.Log();
    }//…Ë÷√∑øº‰◊Ó¥Û≈≈¬Û ˝£¨√ø»À◊Ó∂‡≈≈¬Û¥Œ ˝ Õ®÷™
    
    void OnChangeWaitMicIndexResp(ChangeWaitMicIndexResp& info)
    {
        info.Log();
    }//–ﬁ∏ƒ≈≈¬Û¬Û–ÚœÏ”¶
    
    void OnSetForbidInviteUpMicNotify(SetForbidInviteUpMic& info)
    {
        info.Log();
    }//…Ë÷√Ω˚÷π±ß¬ÛÕ®÷™
    
    void OnSiegeInfoNotify(SiegeInfo& info)
    {
        info.Log();
    }//≥«÷˜–≈œ¢Õ®÷™
    
    void OnOpenChestResp(OpenChestResp& info)
    {
        info.Log();
    }//ø™±¶œ‰œÏ”¶
    
    void OnQueryUserMoreInfoResp(UserMoreInfo& info)
    {
        info.Log();
    }//
    
    void OnSetUserProfileResp(SetUserProfileResp& info)
    {
        info.Log();
    }//…Ë÷√”√ªß≈‰÷√–≈œ¢œÏ”¶
    
    void OnClientPingResp(ClientPingResp& info)
    {
        info.Log();//OK
    }// ’µΩ∑˛ŒÒ∆˜pingœ˚œ¢µƒ∑µªÿ,±Ì æ∑øº‰ªÓ◊≈
    
    void OnCloseRoomNotify(CloseRoomNoty& info)
    {
        info.Log();
    }//∑øº‰±ªπÿ±’œ˚œ¢,÷±Ω”ÕÀ≥ˆµ±«∞∑øº‰
    
    void OnDoNotReachRoomServer()
    {
        //info.Log();
    }// ’µΩ∑øº‰≤ªø…µΩ¥Ôœ˚œ¢
    
    void OnLotteryPoolNotify(LotteryPoolInfo& info)
    {
        info.Log();
    }// ’µΩ–“‘À±¶œ‰Ω±≥ÿœ˚œ¢
    
    //‘› ±√ª”√
    void OnSetUserHideStateResp(SetUserHideStateResp& info)
    {
        info.Log();
    }//
    
    void OnSetUserHideStateNoty(SetUserHideStateNoty& info)
    {
        info.Log();
    }//
    
    //‘› ±∑œ÷√
    void OnUserAddChestNumNoty(UserAddChestNumNoty& info)
    {
        info.Log();
    }// ’µΩ”√ªß‘ˆº”–¬±¶œ‰Õ®÷™
    
    void OnAddClosedFriendNoty(AddClosedFriendNotify& info)
    {
        info.Log();
    }// ’µΩ‘˘ÀÕ¿ÒŒÔ‘ˆº”√‹”—Õ®÷™
    
    void OnAdKeyWordOperateNoty(AdKeywordsNotify& info)
    {
        info.Log();//OK
    }// ’µΩΩ˚—‘πÿº¸¥ À¢–¬Õ®÷™
    
    void OnAdKeyWordOperateResp(AdKeywordsResp& info)
    {
        info.Log();//OK
    }// ’µΩΩ˚—‘πÿº¸¥ ∏¸–¬Õ®÷™
    
    void OnTeacherScoreResp(TeacherScoreResp& info)
    {
        info.Log();//OK
    }// ’µΩΩ≤ ¶∆¿∑÷œÏ”¶
    
    void OnTeacherScoreRecordResp(TeacherScoreRecordResp& info)
    {
        info.Log();//OK
    }// ’µΩ”√ªß∆¿∑÷œÏ”¶
    
    void OnRobotTeacherIdNoty(RobotTeacherIdNoty& info)
    {
        info.Log();//OK
    }//…œ¬Ûª˙∆˜»À∂‘”¶Ω≤ ¶IDÕ®÷™
    
    void OnTeacherGiftListResp(std::vector<TeacherGiftListResp>& infos)
    {
        for(int i = 0; i < infos.size(); i++)
        {
            infos[i].Log();//OK
        }
    }//Ω≤ ¶÷“ µ∂»÷‹∞ÊœÏ”¶
    
    void OnHitGoldEggToClientNoty(HitGoldEggClientNoty& info)
    {
        info.Log();
    }//‘“Ωµ∞∏¸–¬99±“◊Ó–¬÷µ
    
    void OnUserScoreNotify(UserScoreNoty& info)
    {
        info.Log();//OK
    }//”√ªß∂‘Ω≤ ¶µƒ∆¿∑÷
    
    void OnUserScoreListNotify(std::vector<UserScoreNoty>& infos)
    {
        for(int i = 0; i < infos.size(); i++)
        {
            infos[i].Log();//OK
        }
    }//”√ªß∂‘Ω≤ ¶µƒ∆¿∑÷¡–±Ì
    
    void OnTeacherAvarageScoreNoty(TeacherAvarageScoreNoty& info)
    {
        info.Log();//OK
    }//”√ªß∂‘Ω≤ ¶µƒ∆Ωæ˘∑÷
    
    void OnRoomAndSubRoomId_Noty(RoomAndSubRoomIdNoty& info)
    {
        info.Log();//OK
    }//
    
    void OnSysCastResp(Syscast& info)
    {
        info.Log();//OK
    }//œµÕ≥π´∏Ê
    
    //∆’Õ®”√ªß∏ˆ»À◊ ¡œ
    void OnRoomUserInfoResp(RoomUserInfoResp& info)
    {
        info.Log();//OK
    }
    
    //Œƒ◊÷Ω≤ ¶∏ˆ»À◊ ¡œ
    void OnTeacherInfoResp(TeacherInfoResp& info)
    {
        info.Log();//OK
    }
    
    //ªÒ»°”√ªß∏ˆ»À◊ ¡œ ß∞‹
    void OnUserInfoErr(UserInfoErr& info)
    {
        info.Log();//OK
    }
    
    //øŒ≥Ã∂©‘ƒ∑µªÿ
    void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info)
    {
        info.Log();//OK
    }
    
    //≤È—Ø∂©‘ƒ◊¥Ã¨œÏ”¶
    void OnTeacherSubscriptionStateQueryResp(TeacherSubscriptionStateQueryResp& info)
    {
        info.Log();//OK
    }
};

#endif /* Test_h */
