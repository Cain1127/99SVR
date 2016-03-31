
#import "stdafx.h"
#import "cmd_vchat.h"
#import "Socket.h"
#import "ZLLogonProtocol.h"
#import "UserInfo.h"
#import "BaseService.h"
#import "DecodeJson.h"

#pragma mark ZLPushListener

NSString *strUser;
NSString *strPwd;
LoginConnection *conn;
ZLPushListener push_listener;
ZLHallListener hall_listener;
ZLConnectionListerner conn_listener;
ZLLoginListener login_listener;

void ZLPushListener::OnConfChanged(int version)
{
    DLog(@"金币发生变化!");
}

void ZLPushListener::OnGiftListChanged(int version)
{
    
}

void ZLPushListener::OnShowFunctionChanged(int version)
{
    
}

void ZLPushListener::OnPrintLog()
{
    
}

void ZLPushListener::OnUpdateApp()
{
    
}

void ZLPushListener::OnMoneyChanged(uint64 money)
{
    DLog(@"金币更新了");
}

void ZLPushListener::OnBayWindow(BayWindow& info)
{
    
}

void ZLPushListener::OnRoomGroupChanged()
{
    
}

//ZLPushListener::ZLPushListener()
//{
//    
//}

void ZLPushListener::OnRoomTeacherOnMicResp(RoomTeacherOnMicResp &info)
{
    
}

//*********************************************************
//*********************************************************


void ZLConnectionListerner::OnIOError(int err_code)
{
    switch (err_code) {
        case 0:
        {
            DLog(@"关闭登录线程");
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_PROTOCOL_DISCONNECT_VC object:nil];
        }
        break;
        default:
        break;
    }
}

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
    int loginType = [UserInfo sharedUserInfo].otherLogin ? [UserInfo sharedUserInfo].otherLogin : 0;
    NSString *strUrl = [NSString stringWithFormat:@"ReportItem=Login&ClientType=3&LoginType=%d&UserId=%d&ServerIP=%@&Error=%@",
                        loginType,[UserInfo sharedUserInfo].nUserId,@"121.14.211.60",@"login_fail"];
    [DecodeJson postPHPServerMsg:strUrl];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_ERROR_VC object:strMsg];
}

void ZLLoginListener::OnMessageComming(void *msg)
{
    conn->DispatchSocketMessage(msg);
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
    user.goldCoin = info.nk()/1000;
    user.score = info.nb();
    user.sex = info.ngender();
    user.nUserId = info.userid();
    if ((user.nUserId>900000000 && user.nUserId < 1000000000) || user.nUserId <= 0)
    {
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 2;
        [UserInfo sharedUserInfo].strPwd = @"";
    }
    else
    {
        user.strName = [NSString stringWithCString:info.cuseralias().c_str() encoding:GBK_ENCODING];
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 1;
        [UserInfo sharedUserInfo].banding = info.bboundtel();
        [UserDefaults setBool:YES forKey:kIsLogin];
        [UserDefaults setObject:strUser forKey:kUserId];
        [UserDefaults setObject:strPwd forKey:kUserPwd];
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
int ZLLogonProtocol::startLogin(const char *cloginid,const char *pwd,const char *md5Pwd)
{
    strUser = [NSString stringWithUTF8String:cloginid];
    strPwd = [NSString stringWithUTF8String:pwd];
    
    UserLogonReq4 req4;
    req4.set_nmessageid(1);
    if(cloginid==NULL)
    {
        req4.set_cloginid("0");
    }
    else
    {
        req4.set_cloginid(cloginid);
    }
    req4.set_nversion(3030822 + 5);
    req4.set_nmask((uint32)time(0));
    req4.set_cuserpwd(md5Pwd);
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
//    conn->RegisterMessageListener(login_listener);
//    conn->RegisterConnectionListener(conn_listener);
    strUser = [NSString stringWithFormat:@"%d",cloginid];
    strPwd =@"";
    if (openid == NULL || token == NULL) {
        DLog(@"第三方登录发生错误");
        return 0;
    }
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
 *  修改密码
 */
int ZLLogonProtocol::updatePwd(const char *cOld,const char *cNew)
{
    conn->SendMsg_SetUserPwdReq(0,1,cOld,cNew);
    return 1;
}

int ZLLogonProtocol::updateNick(const char *cNick,const char *cBirthDat)
{
    if (cNick==NULL) {
        return 0;
    }
    SetUserProfileReq req;
    UserInfo *info = [UserInfo sharedUserInfo];
    req.set_userid(info.nUserId);
    req.set_headid(0);
    req.set_cuseralias(cNick);
    req.set_cbirthday(cBirthDat);
    req.set_ngender(1);
    conn->SendMsg_SetUserInfoReq(req);
    return 1;
}

/**
 *  析构
 */
ZLLogonProtocol::~ZLLogonProtocol()
{
    if(conn)
    {
        conn->RegisterMessageListener(NULL);
        conn->RegisterConnectionListener(NULL);
        conn->RegisterPushListener(NULL);
        conn->RegisterHallListener(NULL);
        DLog(@"释放logon protocol");
    }
}
/**
 *  封装protocol类  构造方法
 */
ZLLogonProtocol::ZLLogonProtocol()
{
    conn = new LoginConnection();
    conn->RegisterMessageListener(&login_listener);
    conn->RegisterConnectionListener(&conn_listener);
    conn->RegisterPushListener(&push_listener);
    conn->RegisterHallListener(&hall_listener);
}

//**********************************************************************************
//**********************************************************************************
#pragma mark ZLHallListener
/**
 *  设置用户信息响应
 */

//void ZLHallListener::OnSetUserProfileResp(SetUserProfileResp& info)
//{

//}
/**
 *  设置用户密码响应
 */
//void ZLHallListener::OnSetUserPwdResp(SetUserPwdResp& info)
//{

//}
/**
 *  查询房间IP响应
 */
/*
void ZLHallListener::OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info)
{
    
}

void ZLHallListener::OnUserExitMessageResp(ExitAlertResp& info)
{
    
}

void ZLHallListener::OnHallMessageNotify(MessageNoty& info)
{
    
}

void ZLHallListener::OnMessageUnreadResp(MessageUnreadResp& info)
{
    
}

void ZLHallListener::OnInteractResp(std::vector<InteractResp>& infos)
{
    
}

void ZLHallListener::OnHallAnswerResp(std::vector<AnswerResp>& infos)
{
    
}

void ZLHallListener::OnViewShowResp(std::vector<ViewShowResp>& infos)
{
    
}

void ZLHallListener::OnTeacherFansResp(std::vector<TeacherFansResp>& infos)
{
    
}

void ZLHallListener::OnInterestResp(std::vector<InterestResp>& infos)
{
    
}

void ZLHallListener::OnUnInterestResp(std::vector<UnInterestResp>& infos)
{
    
}

void ZLHallListener::OnTextLivePointListResp(std::vector<TextLivePointListResp>& infos)
{
    
}

void ZLHallListener::OnSecretsListResp(HallSecretsListResp& infos)
{
    
}

void ZLHallListener::OnSystemInfoResp(HallSystemInfoListResp& infos)
{
    
}

void ZLHallListener::OnViewAnswerResp(ViewAnswerResp& info)
{
    
}

void ZLHallListener::OnInterestForResp(InterestForResp& info)
{
    
}

void ZLHallListener::OnFansCountResp(FansCountResp& info)
{
    
}
*/
//**********************************************************************************
//**********************************************************************************




