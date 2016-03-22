
#import "stdafx.h"
#import "cmd_vchat.h"
#import "Socket.h"
#import "ZLLogonProtocol.h"
#import "UserInfo.h"

void ZLLoginListener::OnLogonSuccess(UserLogonSuccess2& info)
{
    UserInfo *user = [UserInfo sharedUserInfo];
    user.m_nVipLevel = info.viplevel();
    user.goldCoin = info.nk();
    user.score = info.nb();
    user.sex = info.ngender();
    user.nUserId = info.userid();
    user.strName = [NSString stringWithCString:info.cuseralias().c_str() encoding:GBK_ENCODING];
    if ((user.nUserId>900000000 && user.nUserId < 1000000000) || user.nUserId == 0)
    {
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 2;
    }
    else
    {
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 1;
        [UserInfo sharedUserInfo].banding = info.bboundtel();
        [UserDefaults setBool:YES forKey:kIsLogin];
        [[UserInfo sharedUserInfo] setUserDefault:user.nUserId];
        if ([UserInfo sharedUserInfo].otherLogin ==0)
        {
            [UserDefaults setInteger:0 forKey:kOtherLogin];
        }
        else
        {
            [UserDefaults setObject:[UserInfo sharedUserInfo].strOpenId forKey:kOpenId];
            [UserDefaults setObject:[UserInfo sharedUserInfo].strToken forKey:kToken];
            [UserDefaults setInteger:[UserInfo sharedUserInfo].otherLogin forKey:kOtherLogin];
        }
    }
//    [[CrashReporter sharedInstance] setUserId:[NSString stringWithFormat:@"用户:%@",NSStringFromInt(user.nUserId)]];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
}

int ZLLogonProtocol::startLogin(const char *cloginid,const char *pwd)
{
    conn->RegisterMessageListener(login_listener);
    conn->RegisterConnectionListener(conn_listener);
    
    UserLogonReq4 req4;
    req4.set_nmessageid(1);
    req4.set_cloginid(cloginid);
    req4.set_nversion(3030822 + 5);
    req4.set_nmask((uint32)time(0));
    req4.set_cuserpwd(pwd);
    req4.set_cserial("");
    req4.set_cmacaddr("");
    req4.set_cipaddr("");
    req4.set_nimstate(0);
    req4.set_nmobile(0);
    conn->SendMsg_LoginReq4(req4);
    return 1;
}
ZLLogonProtocol::~ZLLogonProtocol()
{
    delete conn;
    conn = NULL;
    delete login_listener;
    login_listener = NULL;
    delete conn_listener;
    conn_listener = NULL;
}

ZLLogonProtocol::ZLLogonProtocol()
{
    conn = new LoginConnection();
    login_listener = new ZLLoginListener(conn);
    conn_listener = new ZLConnectionListerner();
}



