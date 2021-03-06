
#import "Socket.h"
#import "ZLLogonProtocol.h"
#import "UserInfo.h"
#import "BaseService.h"
#import "DecodeJson.h"
#include <fstream>
#include <cassert>
#include "crc32.h"
#include "json/json.h"
#import "SVRMediaClient.h"
#import "XConsumeRankModel.h"
#import "TQIdeaModel.h"
#import "TQIdeaDetailModel.h"
#import "RoomUser.h"
#import "RoomInfo.h"
#import "RoomService.h"
#import "DeviceUID.h"

NSString *strUser;
NSString *strPwd;

LoginConnection *conn;
ZLPushListener push_listener;
ZLHallListener hall_listener;
ZLConnectionListerner conn_listener;
ZLLoginListener login_listener;
ZLMessageListener message_listener;
ZLJoinRoomListener join_listener;
VideoRoomConnection *video_room;
ZLRoomListener room_listener;

NSString *roomTeachInfo;
NSMutableArray *aryRoomChat;
NSMutableArray *aryRoomPrichat;
NSMutableArray *aryRoomNotice;
int nRoom_count_info;
int nRoom_fans_info;
int nRoom_is_collet;
RoomInfo *currentRoom;
BOOL room_again_login;
int room_again_connctId;

void ZLConnectionListerner::OnConnected()
{
    DLog(@"OnConnected-连接成功");
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NETWORK_TCP_SOCKET_STATE_VC object:@{@"code":@"1"}];
}

void ZLConnectionListerner::OnConnectError(int err_code)
{
    DLog(@"OnConnectError-失去连接回调");
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NETWORK_TCP_SOCKET_STATE_VC object:@{@"code":@"0"}];
}

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
    DLog(@"money:%lld",money);
    [UserInfo sharedUserInfo].goldCoin = money/1000.0f;
    [[NSNotificationCenter defaultCenter] postNotificationName:MEESAGE_LOGIN_SET_PROFILE_VC object:nil];
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

void ZLPushListener::OnEmailNewMsgNoty(EmailNewMsgNoty& info)
{
    
}



//*********************************************************

void ZLHallListener::OnOnMicRobertResp(OnMicRobertResp& info)
{
    
}

void ZLHallListener::OnViewpointTradeGiftResp(ViewpointTradeGiftNoty& info)
{
    KUserSingleton.goldCoin = info.nk()/1000.0f;
    NSDictionary *dict = @{@"userid":@(info.userid()),@"roomid":@(info.roomid()),@"teamid":@(info.roomid()),@"giftid":@(info.giftid()),@"giftnum":@(info.giftnum())};
    DLog(@"send gift ok!");
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_VIEW_DETAILS_GIFT_VC object:dict];
    
    NSString *strName = [NSString stringWithCString:info.useralias().c_str() encoding:GBK_ENCODING];
    int gitId = info.giftid();
    int number = info.giftnum();
    NSString *toName = [NSString stringWithCString:info.teamalias().c_str() encoding:GBK_ENCODING];
    NSLog(@"string:%@ toname:%@",strName,toName);
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:strName forKey:@"srcName"];
//    [parameters setValue:@(gitId) forKey:@"gId"];
//    [parameters setValue:@(number) forKey:@"number"];
//    [parameters setValue:@(info.userid()) forKey:@"srcId"];
//    [parameters setValue:toName forKey:@"toName"];
    NSDictionary *parameters = @{@"srcName":strName,@"gId":@(gitId),@"number":@(number),@"srcId":@(info.userid()),@"toName":toName};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_VIEWPOINT_GIFT_NOTIFY_VC object:parameters];
    
}

void ZLHallListener::OnViewpointTradeGiftErr(ErrCodeResp& info)
{
    DLog(@"send gift fail");
    NSString *strErr = [NSString stringWithUTF8String:conn->get_error_desc(info.errcode()).c_str()];
    if (strErr!=nil)
    {
        DLog(@"strerr:%@",strErr);
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_VIEW_POINT_TRADER_ERR_VC object:strErr];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_VIEW_POINT_TRADER_ERR_VC object:@"送礼失败"];
    }
}

void ZLHallListener::OnSetUserPwdResp(SetUserPwdResp& info)
{
    DLog(@"error:%d",info.errorid());
    int err = info.errorid();
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_PASSWORD_VC object:@(err)];
}

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
            strMsg = @"请升级版本";
        break;
        case 107:
            strMsg = @"账号已冻结";
        break;
        default:
        strMsg = @"密码错误";
        break;
    }
    if (room_again_login)
    {
        room_again_login = NO;
        [aryRoomChat addObject:@"[系统消息]验证用户信息失败,请重新登录"];
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
    }
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
    user.goldCoin = info.nk()/1000.0f;
    user.score = info.nb();
    user.sex = info.ngender();
    user.nUserId = info.userid();
    user.headid = info.headid();
    user.sex = info.ngender();
    if (user.nUserId>900000000 || user.nUserId < 1 )
    {
        user.strName = [NSString stringWithCString:info.cuseralias().c_str() encoding:GBK_ENCODING];
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 2;
        [UserInfo sharedUserInfo].strPwd = @"";
        [UserDefaults setBool:NO forKey:kIsLogin];
    }
    else
    {
        user.strName = [NSString stringWithCString:info.cuseralias().c_str() encoding:GBK_ENCODING];
        conn->SendMsg_GetUserMoreInfReq(user.nUserId);
        [UserInfo sharedUserInfo].bIsLogin = YES;
        [UserInfo sharedUserInfo].nType = 1;
        [UserInfo sharedUserInfo].banding = info.bboundtel();
        [UserDefaults setBool:YES forKey:kIsLogin];
        [UserDefaults setObject:strUser forKey:kUserId];
        [UserDefaults setObject:strPwd forKey:kUserPwd];
        if (strUser==nil || strPwd == nil) {
            DLog(@"username:%@--password:%@",strUser,strPwd);
        }
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
    if (room_again_login)
    {
        room_again_login = NO;
        [[ZLLogonServerSing sharedZLLogonServerSing] connectVideoRoom:room_again_connctId roomPwd:@""];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_SUCESS_VC object:@"登录成功"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
    [kHTTPSingle RequestUnreadCount];
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
 *  @param cloginid loginId分为99乐投数字Id/手机号/自定义账号
 *  @param pwd      密码   md5
 *
 *  @return 默认返回1
 */
int ZLLogonProtocol::startLogin(const char *cloginid,const char *pwd,const char *md5Pwd)
{
    if(cloginid == nil || pwd == nil)
    {
        return 1;
    }
    strUser = [NSString stringWithUTF8String:cloginid];
    strPwd = [NSString stringWithUTF8String:pwd];
    UserLogonReq4 req4;
    req4.set_nmessageid(1);
    DLog(@"用户信息登录");
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
    req4.set_cserial([[DeviceUID uid] UTF8String]);
    req4.set_cmacaddr("");
    req4.set_cipaddr("");
    req4.set_nimstate(0);
    req4.set_nmobile(2);
    conn->SendMsg_LoginReq4(req4);
    return 1;
}

/**
 *  @return 获取分享链接
 */
const char * ZLLogonProtocol::getVideoRoomUrl()
{
    return video_room->GetVideoRoomShareUrl().c_str();
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
    req.set_cserial([[DeviceUID uid] UTF8String]);
    req.set_cmacaddr("");
    req.set_cipaddr("");
    req.set_nimstate(0);
    req.set_nmobile(2);
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

int ZLLogonProtocol::updateNick(const char *cNick,const char *intro,int sex)
{
    if (cNick==NULL) {
        return 0;
    }
    SetUserProfileReq req;
    memset(&req, 0, sizeof(req));

    UserInfo *info = [UserInfo sharedUserInfo];
    req.set_userid(info.nUserId);
    req.set_headid(info.headid);
    req.set_cuseralias(cNick);
    req.set_ngender(sex);
    req.set_introduce(intro);
    req.set_cbirthday("");
    conn->SendMsg_SetUserInfoReq(req);
    
    return 1;
}

void ZLLogonProtocol::connectRoomInfo(int nRoomId,int platform,const char *roomPwd)
{
    if (aryRoomChat==nil)
    {
        aryRoomChat = [NSMutableArray array];
    }
    [aryRoomChat removeAllObjects];
    
    if (aryRoomPrichat==nil)
    {
        aryRoomPrichat = [NSMutableArray array];
    }
    [aryRoomPrichat removeAllObjects];
    [currentRoom.aryUser removeAllObjects];
    [currentRoom.dictUser removeAllObjects];
    
    if (aryRoomNotice == nil)
    {
        aryRoomNotice = [NSMutableArray array];
    }
    [aryRoomNotice removeAllObjects];
    roomTeachInfo = @"";
    
    JoinRoomReq req;
    const char *uId = [[DeviceUID uid] UTF8String];
    req.set_cserial(uId);
    req.set_vcbid(nRoomId);
    req.set_croompwd(roomPwd);
    req.set_devtype(2);
    req.set_bloginsource(platform);
    req.set_userid(KUserSingleton.nUserId);
    if(!KUserSingleton.strPwd)
    {
        req.set_cuserpwd(login_password);
    }
    else if(KUserSingleton.strMd5Pwd)
    {
        req.set_cuserpwd([KUserSingleton.strMd5Pwd UTF8String]);
    }
    else{
        req.set_cuserpwd([[DecodeJson XCmdMd5String:KUserSingleton.strPwd] UTF8String]);
    }
    if(KUserSingleton.nUserId != loginuser.userid())
    {
        DLog(@"重新登录!");
        room_again_login = YES;
        room_again_connctId = nRoomId;
        startLogin("0", "", "");
        return ;
    }
    conn->SendMsg_JoinRoomReq(req);
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
        conn->close();
        delete conn;
        conn = NULL;
    }
}
/**
 *  封装protocol类  构造方法
 */
ZLLogonProtocol::ZLLogonProtocol()
{
    conn = new LoginConnection();
    InitProtocolContext([kLibaryCache UTF8String]);
    conn->RegisterMessageListener(&message_listener);
    conn->RegisterLoginListener(&login_listener);
    conn->RegisterConnectionListener(&conn_listener);
    conn->RegisterPushListener(&push_listener);
    conn->RegisterHallListener(&hall_listener);
    
    video_room = new VideoRoomConnection();
    video_room->RegisterRoomJoinListener(&join_listener);
    video_room->RegisterRoomListener(&room_listener);
    
}

int ZLLogonProtocol::closeProtocol()
{
    conn->close();
    return 1;
}

void ZLLogonProtocol::sendRose(){
    const char *cRose = "[$999$]";
    RoomChatMsg msg;
    msg.set_content(cRose);
    uint32_t nLength = (int)strlen(cRose)+1;
    msg.set_textlen(nLength);
    msg.set_toid(0);
    video_room->SendMsg_RoomChatReq(msg);
}

void ZLLogonProtocol::sendMessage(const char *msg,int toId,const char *toalias){
    RoomChatMsg roomMsg;
    roomMsg.set_content(msg);
    uint32_t nLength = (int)strlen(msg)+1;
    roomMsg.set_textlen(nLength);
    roomMsg.set_toid(toId);
    if(toId)
    {
        RoomUser *_roomUser = [currentRoom findUser:toId];
        NSData *dataInfo = [_roomUser.m_strUserAlias dataUsingEncoding:GBK_ENCODING];
        char cName[64]={0};
        ::strncpy(cName,(const char*)dataInfo.bytes,dataInfo.length);
        roomMsg.set_toalias(cName);
        roomMsg.set_toviplevel(_roomUser.m_nVipLevel);
    }
    video_room->SendMsg_RoomChatReq(roomMsg);
}
void ZLLogonProtocol::sendQuestion(int roomId,int teamId,const char *stock,const char *question)
{
    AskQuestionReq req;
    req.set_roomid(roomId);
    req.set_teamid(teamId);
    req.set_stock(stock);
    req.set_question(question);
    req.set_questionlen((int)strlen(question));
    video_room->SendMsg_AskQuestionReq(req);
}

void ZLLogonProtocol::exitRoomInfo()
{
    video_room->SendMsg_ExitRoomReq(room_info.vcbid());
    [currentRoom.aryUser removeAllObjects];
    [currentRoom.dictUser removeAllObjects];
    [aryRoomChat removeAllObjects];
    [aryRoomNotice removeAllObjects];
    [aryRoomPrichat removeAllObjects];
    roomTeachInfo = @"";
}

/**
 *  发送礼物
 */
void ZLLogonProtocol::sendGift(int giftId,int num){
    TradeGiftRecord req;
    int toUserId=0;
    NSData *toUser = nil;
    for (RoomUser *room in currentRoom.aryUser) {
        if ([room isOnMic]) {
            toUserId = room.m_nUserId;
            toUser = [room.m_strUserAlias dataUsingEncoding:GBK_ENCODING];
            break;
        }
    }
    if (toUserId==0) {
        return ;
    }
    req.set_toid(toUserId);
    req.set_giftid(giftId);
    req.set_giftnum(num);
//    req.set_action(2);
    
    char cBuffer[2048]={0};
    ::strncpy(cBuffer, (const char *)toUser.bytes,toUser.length);
    req.set_toalias(cBuffer);
    
    //const char *toName = (const char *)toUser.bytes;
//    if(toName){
//        req.set_toalias(cBuffer);
//    }
    video_room->SendMsg_TradeGiftReq(req);
}

void ZLLogonProtocol::sendGiftInfo(int viewid, int giftId, int num, int toUser,int roomId)
{
    ViewpointTradeGiftReq req;
    req.set_teamid(toUser);
    req.set_giftid(giftId);
    req.set_giftnum(num);
    req.set_roomid(roomId);
    req.set_userid(KUserSingleton.nUserId);
    req.set_viewid(viewid);
    conn->SendMsg_ViewpointTradeGiftReq(req);
}

void ZLLogonProtocol::buyPrivateVip(int teacherId,int type)
{
    conn->SendMsg_BuyPrivateVipReq(teacherId, type);
}

void ZLLogonProtocol::requestRoomMsg()
{
    video_room->SendMsg_AfterJoinRoomReq();
}

void ZLLogonProtocol::colletRoomInfo(int action)
{
    video_room->SendMsg_CollectRoomReq(action);
}

/**
 *  网络变更
 */
void ZLLogonProtocol::networkfChanged()
{
    conn->OnNetworkChanged();
}

/**
 *  socket 重连
 */
void ZLLogonProtocol::reConnect()
{
    conn->Reconnect();
}
//**********************************************************************************
//**********************************************************************************
#pragma mark ZLHallListener
/**
 *  设置用户信息响应
 */
void ZLHallListener::OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req)
{
    DLog(@"error:%d",info.errorid());
    switch (info.errorid()) {
        case 0:
        {
            UserInfo *user = [UserInfo sharedUserInfo];
            user.strIntro = [NSString stringWithCString:req.introduce().c_str() encoding:GBK_ENCODING];
            user.strName = [NSString stringWithCString:req.cuseralias().c_str() encoding:GBK_ENCODING];
            user.strBirth = [NSString stringWithCString:req.cbirthday().c_str() encoding:GBK_ENCODING];
            user.sex = req.ngender();
            DLog(@"intro:%@---strname:%@",user.strIntro,user.strName);
        }
        break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MEESAGE_LOGIN_SET_PROFILE_VC object:@(info.errorid())];
}

void ZLHallListener::OnGetUserMoreInfResp(GetUserMoreInfResp& info)
{
    UserInfo *user = [UserInfo sharedUserInfo];
    user.strIntro = [NSString stringWithCString:info.autograph().c_str() encoding:GBK_ENCODING];
    user.strMobile = [NSString stringWithCString:info.tel().c_str() encoding:GBK_ENCODING];
    user.strBirth = [NSString stringWithCString:info.birth().c_str() encoding:GBK_ENCODING];
}

void ZLHallListener::OnBuyPrivateVipResp(BuyPrivateVipResp& info)
{
    /*
    uint32	_userid;
    uint32	_teacherid;
    uint32	_viptype;
    uint64	_nk;  */
    NSDictionary *didct = @{@"userid":@(info.userid()),@"teacherid":@(info.teacherid()),@"viptype":@(info.viptype()),@"goid":@(info.nk()),@"code":@"1"};
    [UserInfo sharedUserInfo].goldCoin = info.nk()/1000.0;
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_BUY_PRIVATE_VIP_VC object:didct];
}

void ZLHallListener::OnBuyPrivateVipErr(ErrCodeResp& info)
{
    NSString *code = [NSString stringWithFormat:@"%d",info.errcode()];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_BUY_PRIVATE_VIP_VC object:@{@"code":code}];
}

/**
 *  加入房间成功
 */
//void ZLRoomListener::OnJoinRoomResp(JoinRoomResp& info){
//    DLog(@"加入房间成功");
//    if(currentRoom==nil){
//        currentRoom = [[RoomInfo alloc] init];
//    }
//    [currentRoom setRoomInfo:&info];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
//}

/**
 *   加入房间失败
 */
//void ZLRoomListener::OnJoinRoomErr(JoinRoomErr& info){
//    DLog(@"加入房间失败");
//    NSDictionary *parameters = @{@"err":@(info.errid()),@"msg":@"test"};
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_ERR_VC object:parameters];
//}

/**
 *  用户列表
 */
void ZLRoomListener::OnRoomUserList(std::vector<RoomUserInfo>& infos){
    for(int i = 0; i < infos.size(); i++)
    {
        [RoomService addRoomUser:currentRoom user:&infos[i]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
}

/**
 *  用户加入房间通知
 */
void ZLRoomListener::OnRoomUserNoty(RoomUserInfo& info){
    [RoomService addRoomUser:currentRoom user:&info];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
}

/**
 *  麦克风消息
 */
void ZLRoomListener::OnRoomPubMicStateNoty(std::vector<RoomPubMicState>& infos){
    for(int i = 0; i < infos.size(); i++){
        DLog(@"mic状态:%d--类型:%d--userId:%d",infos[i].micid(),infos[i].mictimetype(),infos[i].userid());
    }
}

/**
 *  用户退出消息
 */
void ZLRoomListener::OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info){
    RoomUser *user = [currentRoom findUser:info.userid()];
    [currentRoom.aryUser removeObject:user];
    [currentRoom removeUser:info.userid()];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
}

/**
 *  消息信息
 */
void ZLRoomListener::OnChatNotify(RoomChatMsg& info)
{
    if(info.msgtype()==1)
    {
        //解析广播
        [RoomService getRibao:&info notice:aryRoomNotice];
    }else{
        //解析消息记录
        [RoomService getChatInfo:&info array:aryRoomChat prichat:aryRoomPrichat];
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
    }
}

/**
 *  用户被踢出通知
 */
void ZLRoomListener::OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info)
{
    if (info.toid()==KUserSingleton.nUserId) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_KICKOUT_VC object:nil];
    }
    else
    {
        RoomUser *user = [currentRoom findUser:info.toid()];
        [currentRoom.aryUser removeObject:user];
        [currentRoom removeUser:info.toid()];
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
    }
}

void ZLRoomListener::OnRoomNoticeNotify(RoomNotice& info){
    if (info.index()==0)
    {
        roomTeachInfo = [RoomService getTeachInfo:&info];
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_TEACH_INFO_VC object:nil];
    }
    else if(info.index()==2)
    {
        [RoomService getNoticeInfo:&info notice:aryRoomNotice];
    }
}

/**
 *  上麦后，用户信息修改
 */
void ZLRoomListener::OnRobotTeacherIdNoty(std::vector<RobotTeacherIdNoty>& infos)
{
    for (int i=0; i<infos.size(); i++)
    {
        RobotTeacherIdNoty info = infos[i];
        RoomUser *_roomUser = [currentRoom.dictUser objectForKey:NSStringFromInt(info.vcbid())];
        _roomUser.m_strUserAlias = [NSString stringWithUTF8String:info.teacheralias().c_str()];
        for (int nTimes=0; nTimes<currentRoom.aryUser.count;nTimes++)
        {
            RoomUser *rUser = [currentRoom.aryUser objectAtIndex:nTimes];
            if (rUser.m_nUserId == info.roborid())
            {
                rUser.m_strUserAlias = [NSString stringWithCString:info.teacheralias().c_str() encoding:GBK_ENCODING ];
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
                break;
            }
        }
    }
}

//Ã·Œ œÏ”¶
void ZLRoomListener::OnAskQuestionResp(AskQuestionResp& info)
{
    DLog(@"提问成功");
    [UserInfo sharedUserInfo].goldCoin = info.nk()/1000.0f;
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_QUESTION_VC object:@{@"code":@(1)}];
}
/**
 *  麦状态变换触发
 */
void ZLRoomListener::OnSetMicStateNotify(UserMicState& info){
    DLog(@"mic状态:%d",info.micstate());
    RoomUser *roomUser = [currentRoom.dictUser objectForKey:NSStringFromInt(info.toid())];
    roomUser.m_nInRoomState = info.micstate();
    for (int i=0; i<currentRoom.aryUser.count;i++)
    {
        RoomUser *rUser = [currentRoom.aryUser objectAtIndex:i];
        if (![rUser isManager])
        {
            break;
        }
        if (rUser.m_nUserId == info.toid())
        {
            rUser.m_nInRoomState = info.micstate();
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
            break;
        }
    }
    if (info.micstate() == 0)
    {
        DLog(@"有人下麦了");
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_MIC_CLOSE_VC object:nil];
    }
    else
    {
        DLog(@"有人上M了,pInfo->toid:%d",info.toid());
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_MIC_UPDATE_VC object:nil];
    }
}

void ZLRoomListener::OnTradeGiftRecordResp(TradeGiftRecord& info){
    DLog(@"赠送礼物成功");
    [[NSNotificationCenter defaultCenter] postNotificationName:MEESAGE_ROOM_SEND_LIWU_RESP_VC object:nil];
}

void ZLRoomListener::OnTradeGiftErr(TradeGiftErr& info){
    DLog(@"赠送礼物失败");
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TRADE_GIFT_VC object:@(info.nerrid())];
}
void ZLRoomListener::OnTradeGiftNotify(TradeGiftRecord& info){
    DLog(@"收到赠送礼物的通知");
    NSString *strName = [NSString stringWithCString:info.srcalias().c_str() encoding:GBK_ENCODING];
    int gitId = info.giftid();
    int number = info.giftnum();
    NSString *toName = [NSString stringWithCString:info.toalias().c_str() encoding:GBK_ENCODING];
    
    if (toName==nil) {
        toName = @"";
    }
    NSDictionary *parameters = @{@"srcName":strName,@"gId":@(gitId),@"number":@(number),@"srcId":@(info.srcid()),
                                 @"toName":toName};
    [[NSNotificationCenter defaultCenter] postNotificationName:MEESAGE_ROOM_SEND_LIWU_NOTIFY_VC object:parameters];
}

void ZLRoomListener::OnViewpointTradeGiftNoty(ViewpointTradeGiftNoty& info)
{
    DLog(@"收到观点详情礼物通知!");
    NSString *strName = [NSString stringWithCString:info.useralias().c_str() encoding:GBK_ENCODING];
    int gitId = info.giftid();
    int number = info.giftnum();
    NSString *toName = [NSString stringWithCString:info.teamalias().c_str() encoding:GBK_ENCODING];
    NSDictionary *parameters = @{@"srcName":strName,@"gId":@(gitId),@"number":@(number),@"srcId":@(info.userid()),@"toName":toName};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_VIEWPOINT_GIFT_NOTIFY_VC object:parameters];
}


void ZLMessageListener::OnLoginMessageComming(void* msg)
{
    conn->DispatchSocketMessage(msg);
}

void ZLMessageListener::OnVideoRoomMessageComming(void* msg)
{
    video_room->DispatchSocketMessage(msg);
}

void ZLJoinRoomListener::OnPreJoinRoomResp(PreJoinRoomResp& info)
{
    
}

void ZLJoinRoomListener::OnJoinRoomResp(JoinRoomResp& info)
{
    DLog(@"加入房间成功");
    if(currentRoom==nil){
        currentRoom = [[RoomInfo alloc] init];
    }
    [currentRoom setRoomInfo:&info];
    [aryRoomChat addObject:@"<span style=\"color:#919191\">[系统消息]加入房间成功</span>"];
    nRoom_count_info = info.naccess_times();
    nRoom_fans_info = info.ncollect_times();
    nRoom_is_collet = info.biscollectroom();
    [aryRoomNotice removeAllObjects];
    roomTeachInfo=@"";
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_SUC_VC object:@{@"collet":[NSString stringWithFormat:@"%d",nRoom_is_collet]}];
}

void ZLJoinRoomListener::OnJoinRoomErr(JoinRoomErr& info)
{
    DLog(@"加入房间失败");
    NSString *strMsg = nil;
    switch (info.errid()) {
    
    case 201:
    {
        strMsg = @"需要输入密码";
    }
    break;
    case 101:
    {
        strMsg = @"房间黑名单";
    }
    break;
    case 203:
    {
        strMsg = @"用户名/密码查询错误，无法加入房间!";
    }
    break;
    case 404:
    {
        strMsg = @"加入房间 不存在";
    }
    break;
    case 405:
    {
        strMsg = @"房间已经被房主关闭，不能进入";
    }
    break;
    case 502:
    {
        strMsg = @"房间人数已满";
    }
    break;
    case 505:
    {
        strMsg = @"通信版本过低，不能使用，请升级";
    }
    break;
    default:
    {
        strMsg = @"未知错误";
    }
    break;
    }
    NSDictionary *parameters = @{@"err":@(info.errid()),@"msg":strMsg};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_ERR_VC object:parameters];
}

#pragma mark 新观点的通知
void ZLRoomListener::OnExpertNewViewNoty(ExpertNewViewNoty& info)
{
    //新观点通知
    TQIdeaModel *idea = [[TQIdeaModel alloc] initWIthNewPointNotify:&info];
    NSDictionary *dict = @{@"code":@"1",@"data":idea};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TQIdeaView_NewNotifi_VC object:dict];
}

void ZLRoomListener::OnUserAccountInfo(UserAccountInfo& info)
{
    [UserInfo sharedUserInfo].goldCoin = info.nk()/1000.0f;
}

void ZLRoomListener::OnFavoriteVcbResp(FavoriteRoomResp& info)
{
    NSDictionary *dict = @{@"code":@(info.actionid())};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_COLLET_RESP_VC object:dict];
}

void ZLRoomListener::OnAskQuestionErr(ErrCodeResp& info)
{
    NSString *strErr = [NSString stringWithUTF8String:conn->get_error_desc(info.errcode()).c_str()];
    if (strErr!=nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_QUESTION_FAIL_VC object:strErr];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_QUESTION_FAIL_VC object:@"提问失败"];
    }
}


void ZLRoomListener::OnTeacherGiftListResp(std::vector<TeacherGiftListResp>& infos)
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<infos.size(); i++)
    {
        TeacherGiftListResp giftList = infos[i];
        XConsumeRankModel *model = [[XConsumeRankModel alloc] init];
        model.headid = 0;
        model.username = [NSString stringWithCString:giftList.useralias().c_str() encoding:GBK_ENCODING];
        model.consume = @(giftList.t_num()/1000.0f);
        [array addObject:model];
    }
    NSDictionary *parameter = @{@"code":@(1),@"data":array};
    DLog(@"贡献榜数据:%ld!",infos.size());
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CONSUMERANK_LIST_VC object:parameter];
}

void ZLRoomListener::OnRoomAndSubRoomId_Noty(RoomAndSubRoomIdNoty& info)
{
    DLog(@"roomid:%d",info.roomid());
    [[SVRMediaClient sharedSVRMediaClient] setMainRoomId:info.roomid()];
}

