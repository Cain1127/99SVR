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
    virtual void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req);
    virtual void OnSetUserPwdResp(SetUserPwdResp& info);
    virtual void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info){}
    virtual void OnGetUserMoreInfResp(GetUserMoreInfResp& info);
    virtual void OnUserExitMessageResp(ExitAlertResp& info){}
    virtual void OnHallMessageNotify(MessageNoty& info){}
    virtual void OnMessageUnreadResp(MessageUnreadResp& info){}
    virtual void OnInteractResp(std::vector<InteractResp>& infos){}
    virtual void OnHallAnswerResp(std::vector<AnswerResp>& infos){}
    virtual void OnSystemInfoResp(std::vector<HallSystemInfoListResp>& infos){}
    virtual void OnInterestForResp(InterestForResp& info){}
    virtual void OnBuyPrivateVipResp(BuyPrivateVipResp& info);
    
    virtual void OnBuyPrivateVipErr(ErrCodeResp& info);
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
    
    void OnRoomTeacherOnMicResp(RoomTeacherOnMicResp& info);
    
    void OnEmailNewMsgNoty(EmailNewMsgNoty& info);
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
    /**
     *   购买VIP
     */
    void buyPrivateVip(int teacherId,int type);
    /**
     *   加入房间成功后，请求信息
     */
    void requestRoomMsg();
    ~ZLLogonProtocol();
};

class ZLRoomListener : public VideoRoomListener
{
    virtual void OnRoomUserList(std::vector<RoomUserInfo>& infos);//{}
    
    //–¬‘ˆ”√ªßÕ®÷™
    virtual void OnRoomUserNoty(RoomUserInfo& info);//{}
    
    //π´¬Û◊¥Ã¨ ˝æ›
    virtual void OnRoomPubMicStateNoty(std::vector<RoomPubMicState>& infos);//{}
    
    //∑øº‰”√ªßÕÀ≥ˆœÏ”¶
    virtual void OnRoomUserExitResp(){}
    
    //∑øº‰”√ªßÕÀ≥ˆÕ®÷™
    virtual void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info);
    
    //∑øº‰”√ªßÃﬂ≥ˆœÏ”¶
    virtual void OnRoomKickoutUserResp(){}
    
    //∑øº‰”√ªßÃﬂ≥ˆÕ®÷™
    virtual void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info);//{}
    
    //≈≈¬Û¡–±Ì
    virtual void OnWaitiMicListInfo(std::vector<int > &infos){}
    
    //¡ƒÃÏ∑¢ÀÕ ß∞‹œÏ”¶
    virtual void OnChatErr(){}
    
    //¡ƒÃÏÕ®÷™ ˝æ›
    virtual void OnChatNotify(RoomChatMsg& info);//{}
    
    //‘˘ÀÕ¿ÒŒÔ≥…π¶œÏ”¶
    virtual void OnTradeGiftRecordResp(TradeGiftRecord& info);//{}
    
    //‘˘ÀÕ¿ÒŒÔ ß∞‹œÏ”¶
    virtual void OnTradeGiftErr(TradeGiftErr& info);//{}
    
    //‘˘ÀÕ¿ÒŒÔÕ®÷™
    virtual void OnTradeGiftNotify(TradeGiftRecord& info);//{}
    
    //œµÕ≥œ˚œ¢Õ®÷™ ˝æ›
    virtual void OnSysNoticeInfo(SysCastNotice& info){}
    
    //”√ªß’ ªß ˝æ›
    virtual void OnUserAccountInfo(UserAccountInfo& info){}
    
    //∑øº‰π‹¿ÌÕ®÷™ ˝æ›
    virtual void OnRoomManagerNotify(){}
    
    //∑øº‰√ΩÃÂ ˝æ›Õ®÷™
    virtual void OnRoomMediaInfo(RoomMediaInfo& info){}
    
    //∑øº‰π´∏Ê ˝æ›Õ®÷™
    virtual void OnRoomNoticeNotify(RoomNotice& info);//{}
    
    //∑øº‰◊¥Ã¨ ˝æ›Õ®÷™
    virtual void OnRoomOpState(RoomOpState& info){}
    
    //∑øº‰–≈œ¢ ˝æ›Õ®÷™
    virtual void OnRoomInfoNotify(RoomBaseInfo& info){}
    
    //∑øº‰∑‚…±”√ªßÕ®÷™
    virtual void OnThrowUserNotify(ThrowUserInfo& info){}
    
    //…œ≈≈¬ÛœÏ”¶
    virtual void OnUpWaitMicResp(UpWaitMic& info){}
    
    //…œ≈≈¬Û¥ÌŒÛ
    virtual void OnUpWaitMicErr(UpWaitMic& info){}
    
    //π´¬Û◊¥Ã¨Õ®÷™
    virtual void OnChangePubMicStateNotify(ChangePubMicStateNoty& info){}
    
    //…Ë÷√¬Û◊¥Ã¨œÏ”¶
    virtual void OnSetMicStateResp(){}
    
    //…Ë÷√¬Û◊¥Ã¨¥ÌŒÛ
    virtual void OnSetMicStateErr(UserMicState& info){}
    
    //…Ë÷√¬Û◊¥Ã¨Õ®÷™
    virtual void OnSetMicStateNotify(UserMicState& info);//{}
    
    //…Ë÷√…Ë±∏◊¥Ã¨œÏ”¶
    virtual void OnSetDevStateResp(UserDevState& info){}
    
    //…Ë÷√…Ë±∏◊¥Ã¨¥ÌŒÛ
    virtual void OnSetDevStateErr(UserDevState& info){}
    
    //…Ë÷√…Ë±∏◊¥Ã¨Õ®÷™
    virtual void OnSetDevStateNotify(UserDevState& info){}
    
    //…Ë÷√”√ªß»®œﬁ(π‹¿Ì)œÏ”¶
    virtual void OnSetUserPriorityResp(SetUserPriorityResp& info){}
    
    //…Ë÷√”√ªß»®œﬁ(π‹¿Ì)Õ®÷™
    virtual void OnSetUserPriorityNotify(UserPriority& info){}
    
    //≤Èø¥”√ªßIPœÏ”¶
    virtual void OnSeeUserIpResp(SeeUserIpResp& info){}
    
    //≤Èø¥”√ªßIP¥ÌŒÛ
    virtual void OnSeeUserIpErr(SeeUserIpResp& info){}
    
    //∑‚…±∑øº‰”√ªßœÏ”¶
    virtual void OnThrowUserResp(ThrowUserInfoResp& info){}
    
    //Ω˚—‘Õ®÷™
    virtual void OnForbidUserChatNotify(ForbidUserChat& info){}
    
    //…Ë÷√∑øº‰π´∏ÊœÏ”¶
    virtual void OnSetRoomNoticeResp(SetRoomNoticeResp& info){}
    
    //…Ë÷√∑øº‰◊¥Ã¨–≈œ¢œÏ”¶
    virtual void OnSetRoomOPStatusResp(SetRoomOPStatusResp& info){}
    
    //≤È—Ø”√ªß’ ªßœÏ”¶
    virtual void OnQueryUserAccountResp(QueryUserAccountResp& info){}
    
    // ’µΩ∑˛ŒÒ∆˜pingœ˚œ¢µƒ∑µªÿ,±Ì æ∑øº‰ªÓ◊≈
    virtual void OnClientPingResp(ClientPingResp& info){}
    
    //∑øº‰±ªπÿ±’œ˚œ¢,÷±Ω”ÕÀ≥ˆµ±«∞∑øº‰
    virtual void OnCloseRoomNotify(CloseRoomNoty& info){}
    
    // ’µΩ∑øº‰≤ªø…µΩ¥Ôœ˚œ¢
    virtual void OnDoNotReachRoomServer(){}
    
    //…Ë÷√∑øº‰–≈œ¢∑…≤Ê∞ÊœÏ”¶
    virtual void OnSetRoomInfoResp(SetRoomInfoResp& info){}
    
    //…Ë÷√∑øº‰–≈œ¢∑…≤Ê∞ÊÕ®÷™
    virtual void OnSetRoomInfoReq_v2(SetRoomInfoReq_v2& info){}
    
    // ’µΩΩ˚—‘πÿº¸¥ À¢–¬Õ®÷™
    virtual void OnAdKeyWordOperateNoty(std::vector<AdKeywordInfo>& info){}
    
    // ’µΩΩ˚—‘πÿº¸¥ ∏¸–¬Õ®÷™
    virtual void OnAdKeyWordOperateResp(AdKeywordsResp& info){}
    
    // ’µΩΩ≤ ¶∆¿∑÷œÏ”¶
    virtual void OnTeacherScoreResp(TeacherScoreResp& info){}
    
    // ’µΩ”√ªß∆¿∑÷œÏ”¶
    virtual void OnTeacherScoreRecordResp(TeacherScoreRecordResp& info){}
    
    //…œ¬Ûª˙∆˜»À∂‘”¶Ω≤ ¶IDÕ®÷™
    virtual void OnRobotTeacherIdNoty(RobotTeacherIdNoty& info);//{}
    
    //Ω≤ ¶÷“ µ∂»÷‹∞ÊœÏ”¶
    virtual void OnTeacherGiftListResp(std::vector<TeacherGiftListResp>& infos){}
    
    //”√ªß∂‘Ω≤ ¶µƒ∆¿∑÷
    virtual void OnUserScoreNotify(UserScoreNoty& info){}
    
    //”√ªß∂‘Ω≤ ¶µƒ∆¿∑÷¡–±Ì
    virtual void OnUserScoreListNotify(std::vector<UserScoreNoty>& infos){}
    
    //”√ªß∂‘Ω≤ ¶µƒ∆Ωæ˘∑÷
    virtual void OnTeacherAvarageScoreNoty(TeacherAvarageScoreNoty& info){}
    
    //÷˜∑øº‰∫Õ◊”∑øº‰id£¨ƒø«∞÷ª”–“∆∂Ø∂À”–£¨PC∂À√ª”–
    virtual void OnRoomAndSubRoomId_Noty(RoomAndSubRoomIdNoty& info){}
    
    //∑øº‰∑¢ÀÕœµÕ≥π´∏Ê
    virtual void OnSysCastResp(Syscast& info){}
    
    //∆’Õ®”√ªß∏ˆ»À◊ ¡œ
    virtual void OnRoomUserInfoResp(RoomUserInfoResp& info){}
    
    //Œƒ◊÷Ω≤ ¶∏ˆ»À◊ ¡œ
    virtual void OnTeacherInfoResp(TeacherInfoResp& info){}
    
    //ªÒ»°”√ªß∏ˆ»À◊ ¡œ ß∞‹
    virtual void OnUserInfoErr(UserInfoErr& info){}
    
    //øŒ≥Ã∂©‘ƒ∑µªÿ
    virtual void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info){}
    
    //≤È—Ø∂©‘ƒ◊¥Ã¨œÏ”¶
    virtual void OnTeacherSubscriptionStateQueryResp(TeacherSubscriptionStateQueryResp& info){}
    
    /**
     *  专家观点请求
     */
    virtual void OnExpertNewViewNoty(ExpertNewViewNoty& info){}
    
    //◊Ó«ø’Ω∂”÷‹∞Òªÿ”¶
    virtual void OnTeamTopNResp(std::vector<TeamTopNResp>& infos){}
};


class ZLMessageListener : public MessageListener
{
public:
    
    virtual void OnLoginMessageComming(void* msg);;
    
    virtual void OnVideoRoomMessageComming(void* msg);
};

class ZLJoinRoomListener : public VideoRoomJoinListener
{
   	void OnPreJoinRoomResp(PreJoinRoomResp& info);
    
    void OnJoinRoomResp(JoinRoomResp& info);

    void OnJoinRoomErr(JoinRoomErr& info);
};

#endif /* Test_h */
