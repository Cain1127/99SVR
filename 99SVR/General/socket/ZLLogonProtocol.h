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
    
    void OnIOError(int err_code)
    {
        LOG("OnIOError");
    }
};



class ZLLoginListener : public LoginListener
{
public:
    LoginConnection *conn;
    
public:

    ZLLoginListener(LoginConnection *_conn):conn(_conn){};
    
    void OnMessageComming(void* msg)
    {
        conn->DispatchSocketMessage(msg);
    }
    
    void OnLogonSuccess(UserLogonSuccess2& info);
//    {
//        info.Log();
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MESSAGE_LOGON_SUC_VC" object:nil];
//    }
    
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
    
    void OnSetUserProfileResp(SetUserProfileResp& info)
    {
        
    }
    
    void OnSetUserPwdResp(SetUserPwdResp& info)
    {
        
    }
    
    void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info)
    {
        
    }
};

class ZLLogonProtocol
{
    LoginConnection *conn;
    ZLLoginListener *login_listener;
    ZLConnectionListerner *conn_listener;
public :
    ZLLogonProtocol();
    int startLogin(const char *cloginid,const char *pwd);
    ~ZLLogonProtocol();
};

#endif /* Test_h */
