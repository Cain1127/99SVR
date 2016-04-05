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
#include "LoginConnection.h"

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
};

class ZLPushListener: public PushListener
{
    
public:

    void OnConfChanged(int version);
//    {
//        LOG("OnConfChanged:%d", version);
//    }
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
    
    ~ZLLogonProtocol();
};

#endif /* Test_h */
