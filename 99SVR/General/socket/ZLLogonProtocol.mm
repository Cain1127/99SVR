
#import "stdafx.h"
#import "cmd_vchat.h"
#import "Socket.h"
#import "ZLLogonProtocol.h"
#import "UserInfo.h"
//双芳封装类
/**
 *  登录失败
 *
 */
void ZLLoginListener::OnLogonErr(UserLogonErr2& info)
{
    NSString *strMsg = nil;
    switch (info.errid()) {
        case 103:
            strMsg = @"没有此用户";
        break;
        case 101:
            strMsg = @"你被限制进入,登录失败!请联系在线客服.";
        break;
        case 106:
            strMsg = @"账号错误";
        break;
        case 104:
            strMsg = @"密码错误";
        break;
        case 105:
            strMsg = @"请升级";
        break;
        case 107:
            strMsg = @"账号已冻结";
        break;
        default:
        strMsg = @"密码错误";
        break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_ERROR_VC object:strMsg];
}

/**
 *  登录成功
 *
 *  @param info
 */
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
        [UserDefaults synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_SUCESS_VC object:@"登录成功"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
}

/**
 *  Token返回通知
 *
 *  @param info
 */
void ZLLoginListener::OnLogonTokenNotify(SessionTokenResp& info)
{
    //直接将token 放入内存中，作为全局对象
    [UserInfo sharedUserInfo].strToken = [NSString stringWithUTF8String:info.sessiontoken().c_str()];
    DLog(@"token:%@",[UserInfo sharedUserInfo].strToken);
}

//实例调用类
/**
 *  直接登录
 *
 *  @param cloginid loginId分为99财经数字Id/手机号/自定义账号
 *  @param pwd      密码   md5
 *
 *  @return 默认返回1
 */
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

/**
 *  第三方登录
 *
 *  @param cloginid userId
 *  @param openid   openid
 *  @param token    token
 *
 *  @return 默认1
 */
int ZLLogonProtocol::startOtherLogin(uint32 cloginid,const char *openid,const char *token){
    conn->RegisterMessageListener(login_listener);
    conn->RegisterConnectionListener(conn_listener);
    
    UserLogonReq5 req;
    req.set_nmessageid(1);
    req.set_userid(cloginid);
    req.set_nversion(3030822 + 5);
    req.set_nmask((uint32)time(0));
    req.set_openid(openid);
    req.set_opentoken(token);
    int platform = [UserInfo sharedUserInfo].otherLogin;
    req.set_platformtype(platform);
    req.set_cserial("");
    req.set_cmacaddr("");
    req.set_cipaddr("");
    req.set_nimstate(0);
    req.set_nmobile(0);
    conn->SendMsg_LoginReq5(req);
    return 1;
}
/**
 *  析构
 */
ZLLogonProtocol::~ZLLogonProtocol()
{
    delete conn;
    conn = NULL;
    delete login_listener;
    login_listener = NULL;
    delete conn_listener;
    conn_listener = NULL;
}
/**
 *  封装protocol类  构造方法
 */
ZLLogonProtocol::ZLLogonProtocol()
{
    conn = new LoginConnection();
    login_listener = new ZLLoginListener(conn);
    conn_listener = new ZLConnectionListerner();
}



