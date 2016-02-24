//
//  TextTcpSocket.m
//  99SVR
//
//  Created by xia zhonglin  on 1/11/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextTcpSocket.h"
#import "GCDAsyncSocket.h"
#import "IdeaDetails.h"
#import "HistoryTextModel.h"
#import "IdeaDetailRePly.h"
#import "IdeaModel.h"
#import "TextLiveModel.h"
#import "cmd_vchat.h"
#import "moonDefines.h"
#import "DecodeJson.h"
#import "message_comm.h"
#import "UserInfo.h"
#import "message_vchat.h"
#import "crc32.h"
#import "ChatReplyModel.h"
#import "TeacherModel.h"

#define _PRODUCT_CORE_MESSAGE_VER_   10690001
#define SOCKET_READ_LENGTH     1
#define SOCKET_READ_DATA       2

//#define kUserInfoId [UserInfo sharedUserInfo].nUserId
#define kUserInfoId 1772664
#define kUserInfoPwd @"123456"

@interface TextTcpSocket()<GCDAsyncSocketDelegate>
{
    char cBuf[16384];
    dispatch_queue_t socketQueue;
}
//@property (nonatomic,strong) NSMutableArray *aryText;
@property (nonatomic,strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic) int32_t roomid;

@end

@implementation TextTcpSocket

#pragma mark 解析文字直播数据

- (void)authTextRoom:(COM_MSG_HEADER *)in_msg
{
    int nMsgLen=in_msg->length-sizeof(COM_MSG_HEADER);
    char* pNewMsg=0;
    DLog(@"数据指令:%d",in_msg->subcmd);
    if(nMsgLen>0)
    {
        pNewMsg= (char*) malloc(nMsgLen);
        DLog(@"数组长度:%d",nMsgLen);
        memcpy(pNewMsg,in_msg->content,nMsgLen);
    }
    else
    {
        switch (in_msg->subcmd)
        {
            case Sub_Vchat_TextRoomLiveListEnd:
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEXT_LOAD_TODAY_LIST_VC object:nil];
//                [self reqTextRoomList:0 count:20 type:2];//测试的时候使用
//                [self createTextMessage:1680014 type:1 msg:@"这个也是用来测试的"];
//                [self reqQuestion:@"吃多少长身体" title:@"关于吃饭" teach:1680014];
//                [self reqInterest:1680014];
//                [self reqZans:275844 type:1];
//                [self reqLiveChat:@"测试一下" to:0 toalias:@""];
//                [self reqChatReply:@"再试一下" to:1680014 source:@"测试一次"];
//                [self reqLiveView:0];//查看讲师所有观点内容
//                [self reqNewList:1680014 index:0 count:20];//观点列表请求
//                [self reqOperViewType:0 name:@"测试一下" type:1];  //添加观点
            break;
            case Sub_Vchat_TextRoomLivePointEnd:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEXT_TODAY_VIP_VC object:nil];
            }
            break;
            case Sub_Vchat_TextRoomLiveViewEnd:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEXT_NEW_VC object:nil];
            }
                break;
            default:
                break;
        }
        [_asyncSocket readDataToLength:sizeof(int32) withTimeout:-1 tag:SOCKET_READ_LENGTH];
        return ;
    }
    switch (in_msg->subcmd)
    {
        case Sub_Vchat_TextRoomJoinErr:
        {
            [self joinRoomError:pNewMsg];
            return ;
        }
            break;
        case Sub_Vchat_TextRoomJoinRes:
        {
            [self joinRoomSuccess:pNewMsg];
        }
        break;
        case Sub_Vchat_TextRoomTeacherReq:
        case Sub_Vchat_TextRoomTeacherNotify:
        {
            [self authTeacherInfo:pNewMsg];//成功
        }
        break;
        case Sub_Vchat_TextRoomLiveListNotify:
        {
            [self respTextRoomList:pNewMsg];//获取直播消息
        }
        break;
        case Sub_Vchat_TextRoomLivePointNotify:
        {
            [self respPointTextList:pNewMsg type:2];//直播重点
        }
        break;
        case Sub_Vchat_TextRoomForecastNotify:
        {
            [self respPointTextList:pNewMsg type:3];//明日预测
        }
        break;
        case Sub_Vchat_TextRoomLiveMessageRes:
        {
            [self respTextRoomMessage:pNewMsg];//讲师新的直播
        }
        break;
        case Sub_Vchat_TextRoomQuestionRes:
        {
            [self respTextQuestion:pNewMsg];//提问回复
        }
        break;
        case Sub_Vchat_TextRoomInterestForRes://收藏回复
        {
            [self respInterestForRes:pNewMsg];//完成
        }
        break;
        case Sub_Vchat_TextRoomZanForRes:
        {
            [self respZanForRes:pNewMsg];//点赞回复   已完成
        }
        break;
        case Sub_Vchat_TextRoomLiveChatRes:
        {
            [self respChatMsg:pNewMsg];//聊天消息响应   已完成
        }
        break;
        case Sub_Vchat_TextLiveChatReplyRes:
        {
            [self respChatReply:pNewMsg];//互动回复
        }
        break;
        case Sub_Vchat_TextRoomViewGroupRes:
        {
            [self respViewGroupList:pNewMsg];//可以  现有版本不适应  观点类型列表
        }
        break;
        case Sub_Vchat_TextRoomLiveViewRes:
        {
            [self respViewList:pNewMsg];//观点详细列表 完成
        }
        break;
        case Sub_Vchat_TextRoomLiveViewDetailRes:
        {
            [self respViewList:pNewMsg];
        }
        break;
        case Sub_Vchat_TextRoomViewInfoRes:
        {
            [self respIdeaReplay:pNewMsg];//观点详细内容列表返回
        }
        break;
        case Sub_Vchat_TextRoomViewTypeRes://讲师观点修改、添加回复
        {
            DLog(@"暂时不处理添加的消息");
        }
        break;
        case Sub_Vchat_TextRoomViewMessageRes://讲师发布观点或修改观点
        {
            DLog(@"暂时不处理");
            [self respMessageUpdate:pNewMsg];
        }
        break;
        case Sub_Vchat_TextRoomViewDeleteRes:
        {
            [self respDeleteTeacherView:pNewMsg];
        }
        break;
        case Sub_Vchat_TextRoomViewCommentRes:
        {
            CMDTextRoomLiveActionRes_t *resp = (CMDTextRoomLiveActionRes_t*)pNewMsg;
            DLog(@"评论结果:%d",resp->result);
        }
        break;
        case Sub_Vchat_TextLiveViewZanForRes:
        {
            //点赞结果
            [self respCommentZan:pNewMsg];
        }
        break;
        case Sub_Vchat_TextLiveViewFlowerRes:
        {
            //送花响应
            [self respSendFlower:pNewMsg];
        }
            break;
        case Sub_Vchat_TextLiveHistoryListRes:
        {
            [self respHistoryList:pNewMsg];
        }
        break;
        case Sub_Vchat_TextLiveHistoryDaylyRes:
        {
            [self respDayHistoryList:pNewMsg];
        }
        break;
        case Sub_Vchat_TextLiveUserExitRes:
        {
            DLog(@"退出房间成功");
            [self closeSocket];
        }
        break;
        default:
        {
            DLog(@"其余消息:%d",in_msg->subcmd);
        }
        break;
    }
    free(pNewMsg);
    [_asyncSocket readDataToLength:sizeof(int32) withTimeout:-1 tag:SOCKET_READ_LENGTH];
}

#pragma mark 请求观点详细记录
- (void)reqIdeaDetails:(int)nIndex count:(int)nCount ideaId:(int)ideaId
{
    CMDTextRoomLiveViewDetailReq_t req = {0};
    req.vcbid = _roomid;
    req.userid = kUserInfoId;
    req.count = nCount;
    req.startcommentpos = nIndex;
    req.viewid = ideaId;
    [self sendMessage:(char *)&req size:sizeof(CMDTextRoomLiveViewDetailReq_t)
              version:MDM_Version_Value maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomLiveViewDetailReq];
}

#pragma mark 提问
- (void)respTextQuestion:(char *)pInfo
{
    CMDTextRoomLiveActionRes_t *resp = (CMDTextRoomLiveActionRes_t *)pInfo;
//    DLog(@"提问结果:%d--提问消息:%d",resp->result,resp->messageid);
}

#pragma mark 某天记录的响应
- (void)respDayHistoryList:(char *)pInfo
{
    CMDTextRoomLiveListNoty_t *resp = (CMDTextRoomLiveListNoty_t*)pInfo;
    HistoryTextModel *text = [[HistoryTextModel alloc] initWithHistoryText:resp];
    DLog(@"text:%@",text.strContent);
}

#pragma mark 请求某一天的直播记录
- (void)reqDayHistoryList:(int)nIndex count:(int)nCount time:(NSTimeInterval)time teacher:(int32)teid
{
    CMDTextLiveHistoryDaylyReq_t req = {0};
    req.userid = kUserInfoId;
    req.vcbid = _roomid;
    req.teacherid = teid;
    req.messageid = nIndex;
    req.count = nCount;
    req.datetime = time;
    [self sendMessage:(char *)&req size:sizeof(CMDTextLiveHistoryDaylyReq_t) version:MDM_Version_Value
              maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextLiveHistoryDaylyReq];
}

#pragma mark 返回历史的分页  汇总
- (void)respHistoryList:(char *)pInfo
{
    CMDTextLiveHistoryListRes_t *resp = (CMDTextLiveHistoryListRes_t *)pInfo;
    DLog(@"start:%zi--end:%zi",resp->beginTime,resp->datetime);
    DLog(@"renqi:%zi--answer:%zi",resp->renQi,resp->cAnswer);
}

#pragma mark 点击请求直播历史记录
- (void)reqHistoryList:(int)nIndex count:(int)nCount
{
    CMDTextLiveHistoryListReq_t req = {0};
    req.vcbid = _roomid;
    req.userid = kUserInfoId;
    req.fromIndex = nIndex;
    req.teacherid = 1680014;
    req.count = nCount;
    req.fromdate = [self getdateFromString:@"20160114"];
    req.bInc = 1;
    [self sendMessage:(char *)&req size:sizeof(CMDTextLiveHistoryListReq_t) version:MDM_Version_Value maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextLiveHistoryListReq];
}

#pragma mark 送花响应
- (void)respSendFlower:(char *)pInfo
{
    CMDTextLiveViewFlowerRes_t *resp = (CMDTextLiveViewFlowerRes_t *)pInfo;
    if (resp->result)
    {
        DLog(@"送花成功:%d",resp->recordflowers);
    }
}

#pragma mark 观点评论送花
- (void)reqSendFlower:(int64_t)msgId count:(int32_t)nCount
{
    CMDTextLiveViewFlowerReq_t req = {0};
    req.userid = kUserInfoId;
    req.messageid = msgId;
    req.vcbid = _roomid;
    req.count = nCount;
    [self sendMessage:(char *)&req size:sizeof(CMDTextLiveViewFlowerReq_t) version:MDM_Version_Value
              maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextLiveViewFlowerReq];
}

#pragma mark 点赞回应
- (void)respCommentZan:(char *)pInfo
{
    CMDTextRoomZanForRes_t *resp = (CMDTextRoomZanForRes_t *)pInfo;
    if (resp->result)
    {
        DLog(@"点赞成功");
    }
}

#pragma mark 点赞某个评论
- (void)reqCommentZan:(int64_t)msgid
{
    CMDTextRoomZanForReq_t req = {0};
    req.userid = kUserInfoId;
    req.messageid = msgid;
    [self sendMessage:(char *)&req size:sizeof(CMDTextRoomZanForReq_t) version:MDM_Version_Value maincmd:MDM_Vchat_Text
               subcmd:Sub_Vchat_TextLiveViewZanForReq];
}

#pragma mark 暂未使用
- (void)respReplyComment:(char *)pInfo
{
    
}

#pragma mark 评论某条观点
- (void)replyCommentReq:(NSString *)strComment msgid:(int64_t)msgId toid:(int)toId
{
    NSData *commentData = [strComment dataUsingEncoding:GBK_ENCODING];
    int nLength = (int)commentData.length+1+sizeof(CMDTextRoomViewCommentReq_t);
    char szBuf[nLength];
    memset(szBuf, 0, nLength);
    CMDTextRoomViewCommentReq_t *req = (CMDTextRoomViewCommentReq_t *)szBuf;
    req->fromid = kUserInfoId;
    req->messageid = msgId;
    req->textlen = nLength;
    memcpy(req->content,commentData.bytes,commentData.length);
    req->toid = 1680014;
    req->content[req->textlen-1] = '\0';
    [self sendMessage:szBuf size:nLength version:MDM_Version_Value maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomViewCommentReq length:nLength+12];
}
#pragma mark 讲师观点删除响应
- (void)respDeleteTeacherView:(char *)pInfo
{
    CMDTextRoomViewDeleteRes_t *resp = (CMDTextRoomViewDeleteRes_t *)pInfo;
    if (resp->result)
    {
        //操作成功
        //删除某一条记录 resp->viewid;
    }
}

#pragma mark 请求讲师观点删除
- (void)reqDeleteTeacherView:(int64_t)messageid
{
    CMDTextRoomViewDeleteReq_t req;
    memset(&req, 0, sizeof(CMDTextRoomViewDeleteReq_t));
    req.userid = kUserInfoId;
    req.vcbid = _roomid;
    req.viewid = messageid;
    [self sendMessage:(char *)&req size:sizeof(CMDTextRoomViewDeleteReq_t) version:MDM_Version_Value
              maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomViewDeleteReq];
}

#pragma mark 观点修改响应
- (void)respMessageUpdate:(char *)pInfo
{
    CMDTextRoomViewMessageReqRes_t *resp = (CMDTextRoomViewMessageReqRes_t *)pInfo;
    //resp->messageid   查找某条id
    //从 IdeaDetails  查找messageid == resp->messageid
    DLog(@"msgid:%zi",resp->messageid);
    NSString *strContent = [NSString stringWithCString:resp->content encoding:GBK_ENCODING];
    DLog(@"内容:%@",strContent);
}

#pragma mark 请求修改观点
- (void)reqViewMessage:(NSString *)strContent title:(NSString *)strTitle msgid:(int64)messageId
{
    NSData *contentData = [strContent dataUsingEncoding:GBK_ENCODING];
    NSData *titleData = [strTitle dataUsingEncoding:GBK_ENCODING];
    int nLength = (int)contentData.length+(int)titleData.length+1+sizeof(CMDTextRoomViewMessageReq_t);
    char szBuf[nLength];
    memset(szBuf, 0, nLength);
    CMDTextRoomViewMessageReq_t *req = (CMDTextRoomViewMessageReq_t *)szBuf;
    req->vcbid = _roomid;
    req->userid = kUserInfoId;
    req->messageid = messageId;
    req->textlen = contentData.length;
    req->titlelen = titleData.length;
    strncpy(req->content,titleData.bytes,titleData.length);
    strncpy(req->content+titleData.length,contentData.bytes, contentData.length);
    req->content[nLength-1] = '\0';
    [self sendMessage:szBuf size:nLength version:MDM_Version_Value
              maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomViewMessageReq length:nLength];
}

#pragma mark 新增观点类型分类  1-新增；2-修改；3-删除（需要删除分类下所有观点后才可操作）；
- (void)reqOperViewType:(int)viewTypeId name:(NSString *)strContent type:(int16_t)type
{
    NSData *typeData = [strContent dataUsingEncoding:GBK_ENCODING];
    CMDTextRoomViewTypeReq_t req;
    req.vcbid = _roomid;
    req.teacherid = 1680014;
    req.actiontypeid = type;
    req.viewtypeid = viewTypeId;
    int nLength = typeData.length >= NAMELEN ? NAMELEN : (int)typeData.length;
    strncpy(req.viewtypename,typeData.bytes,nLength);
    [self sendMessage:(char *)&req size:sizeof(CMDTextRoomViewTypeReq_t)
              version:MDM_Version_Value maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomViewTypeReq];
}

#pragma mark 观点详情
- (void)respIdeaReplay:(char*)pInfo
{
    CMDTextRoomViewInfoRes_t *resp = (CMDTextRoomViewInfoRes_t *)pInfo;
    IdeaDetailRePly *idea = [[IdeaDetailRePly alloc] initWithIdeaRePly:resp];
    DLog(@"%@---%@---%@",idea.strContent,idea.strName,idea.strSrcName);
    idea = nil;
}

- (void)respNewDetails:(char *)pInfo
{
    CMDTextRoomLiveViewRes_t *resp = (CMDTextRoomLiveViewRes_t *)pInfo;
    IdeaDetails *idea = [[IdeaDetails alloc] initWithIdeaDetails:resp];
    DLog(@"观点信息:%zi--%@",idea.messageid,idea.strContent);
}

#pragma mark 观点列表返回
- (void)respViewList:(char *)pInfo
{
    CMDTextRoomLiveViewRes_t *resp = (CMDTextRoomLiveViewRes_t *)pInfo;
    IdeaDetails *idea = [[IdeaDetails alloc] initWithIdeaDetails:resp];
    DLog(@"观点信息:%zi--%@",idea.messageid,idea.strContent);
    [_aryNew addObject:idea];
    idea = nil;
}

#pragma mark 观点列表
- (void)reqNewList:(int)teacherid index:(int)nIndex count:(int)nCount
{
    CMDTextRoomLiveViewListReq_t req= {0};
    req.vcbid = _roomid;
    req.userid = kUserInfoId;
//    req.teacherid = teacherid;
    req.teacherid = _teacher.teacherid;
    req.viewtypeid = 0;
    req.messageid = nIndex;
    req.count = nCount;
    [self sendMessage:(char *)&req size:sizeof(CMDTextRoomLiveViewListReq_t) version:MDM_Version_Value
              maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomViewListShowReq];
}

#pragma mark 观点列表
- (void)respViewGroupList:(char *)pInfo
{
    CMDTextRoomViewGroupRes_t *resp = (CMDTextRoomViewGroupRes_t*)pInfo;
    IdeaModel *idea = [[IdeaModel alloc] initWithIdea:resp];
    
    idea = nil;
}

#pragma mark 查看观点类型
- (void)reqLiveView:(UInt64)teacherid
{
    CMDTextRoomLiveViewGroupReq_t viewReq={0};
    viewReq.vcbid = _roomid;
    viewReq.userid = kUserInfoId;
    viewReq.teacherid = 1680014;
    [self sendMessage:(char*)&viewReq size:sizeof(CMDTextRoomLiveViewGroupReq_t) version:MDM_Version_Value
              maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomLiveViewReq];
}

#pragma mark 回复响应
- (void)respChatReply:(char *)pInfo
{
    CMDTextLiveChatReplyRes_t *resp = (CMDTextLiveChatReplyRes_t *)pInfo;
    ChatReplyModel *chat = [[ChatReplyModel alloc] initWithChatResp:resp];
    DLog(@"content:%@",chat.strContent);
    chat = nil;
}

#pragma mark 聊天回复请求
- (void)reqChatReply:(NSString *)strContent to:(int)toId source:(NSString *)strSrc
{
    NSData *contentData = [strContent dataUsingEncoding:GBK_ENCODING];
    NSData *srcData = [strSrc dataUsingEncoding:GBK_ENCODING];
    size_t sLength = sizeof(CMDTextLiveChatReplyReq_t)+contentData.length+srcData.length+1;
    char szBuf[sLength];
    memset(szBuf, 0, sLength);
    CMDTextLiveChatReplyReq_t *req = (CMDTextLiveChatReplyReq_t *)szBuf;
    req->toid = toId;
    req->vcbid = _roomid;
    req->fromid = kUserInfoId;
    req->messagetime = [self getNowTime];
    req->reqtextlen = srcData.length;
    req->restextlen = contentData.length;
    memcpy(req->content,srcData.bytes, srcData.length);
    memcpy(req->content+srcData.length, contentData.bytes, contentData.length);
    req->content[sLength-1] = '\0';
    [self sendMessage:szBuf size:(int)sLength version:MDM_Version_Value
              maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextLiveChatReplyReq length:sLength+12];
}

#pragma mark 文字直播回复
- (void)respChatMsg:(char *)pInfo
{
    CMDTextRoomLiveChatRes_t *resp = (CMDTextRoomLiveChatRes_t *)pInfo;
    NSString *strFrom = [NSString stringWithCString:resp->srcalias encoding:GBK_ENCODING];
    NSString *strMsg = [NSString stringWithCString:resp->content encoding:GBK_ENCODING];
    NSString *strTo = [NSString stringWithCString:resp->toalias encoding:GBK_ENCODING];
    NSString *strInfo = [NSString stringWithFormat:@"%@对%@:%@",strFrom,strTo,strMsg];
    //发送通知信息
    [_aryChat addObject:strInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEXT_NEW_CHAT_VC object:nil];
}

#pragma mark 发送聊天信息
- (void)reqLiveChat:(NSString *)strContent to:(int)toId toalias:(NSString *)toName
{
    NSData *contentData = [strContent dataUsingEncoding:GBK_ENCODING];
    size_t nLength = sizeof(CMDRoomLiveChatReq_t)+[contentData length]+1;
    char szBuf[nLength];
    memset(szBuf, 0, nLength);
    CMDRoomLiveChatReq_t *req = (CMDRoomLiveChatReq_t *)szBuf;
    memset(req, 0, sizeof(CMDRoomLiveChatReq_t));
    req->vcbid = _roomid;
    req->srcid = kUserInfoId;
    req->toid = toId;
    req->textlen = [contentData length]+1;
    req->msgtype = 0;
    req->messagetime = [self getNowTime];
    memcpy(req->content,[contentData bytes], [contentData length]);
    req->content[req->textlen-1] = '\0';
    [self sendMessage:szBuf size:(int)nLength version:MDM_Version_Value maincmd:MDM_Vchat_Text
               subcmd:Sub_Vchat_TextRoomLiveChatReq length:nLength+20];
}

#pragma mark 直播消息赞返回
- (void)respZanForRes:(char *)pInfo
{
    CMDTextRoomZanForRes_t *resp = (CMDTextRoomZanForRes_t *)pInfo;
    if(resp->result)
    {
        //点赞成功
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEXT_ZAN_SUC_VC object:NSStringFromInt64(resp->messageid)];
    }
    DLog(@"result:%d--zans:%lld--total:%lld",resp->result,resp->recordzans,resp->totalzans);
}

#pragma mark 用户点击提问
- (void)reqQuestion:(NSString *)strInfo title:(NSString *)strTitle teach:(int)teacherid
{
    NSData *infoData = [strInfo dataUsingEncoding:GBK_ENCODING];
    NSData *titleData = [strTitle dataUsingEncoding:GBK_ENCODING];
    size_t nLength = sizeof(CMDTextRoomQuestionReq_t)+infoData.length+titleData.length+1;
    char szBuf[nLength];
    memset(szBuf, 0, nLength);
    CMDTextRoomQuestionReq_t *req = (CMDTextRoomQuestionReq_t *)szBuf;
    req->vcbid = _roomid;
    req->userid = kUserInfoId;
    req->textlen = [infoData length];
    req->stocklen = [titleData length];
    memcpy(req->content,titleData.bytes, titleData.length);
    memcpy(req->content+titleData.length, infoData.bytes, infoData.length);
    req->content[nLength-1] = '\0';
    [self sendMessage:szBuf size:(int)nLength version:MDM_Version_Value maincmd:MDM_Vchat_Text
               subcmd:Sub_Vchat_TextRoomQuestionReq length:nLength+12];
}

#pragma makr 用户对直播点赞
- (void)reqZans:(int64_t)messageid
{
    CMDTextRoomZanForReq_t zan;
    memset(&zan, 0, sizeof(CMDTextRoomZanForReq_t));
    zan.vcbid = _roomid;
    zan.userid = kUserInfoId;
    zan.messageid = messageid;
    [self sendMessage:(char *)&zan size:sizeof(CMDTextRoomZanForReq_t)
              version:MDM_Version_Value maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomZanForReq];
}

#pragma mark 用户点击关注
- (void)reqTeacherCollet:(short)oper
{
    CMDTextRoomInterestForReq_t req;
    memset(&req, 0, sizeof(req));
    req.vcbid = _roomid;
    req.userid = (UInt32)kUserInfoId;
    req.teacherid = _teacher.teacherid;
    req.optype = oper;
    [self sendMessage:(char *)&req size:sizeof(CMDTextRoomInterestForReq_t) version:MDM_Version_Value maincmd:MDM_Vchat_Text
               subcmd:Sub_Vchat_TextRoomInterestForReq];
}

#pragma mark 关注响应
- (void)respInterestForRes:(char *)pInfo
{
    CMDTextRoomInterestForRes_t *resp = (CMDTextRoomInterestForRes_t *)pInfo;
    DLog(@"关注 响应:%d",resp->result);
    DLog(@"粉丝数:%d",resp->result);
    NSDictionary *dict = @{@"result":NSStringFromInt(resp->result),@"opertype":NSStringFromInt(resp->optype)};
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEXT_COLLET_VC object:dict];
}

#pragma mark 收到讲师发送的文字直播
- (void)respTextRoomMessage:(char *)pInfo
{
    DLog(@"CMDTextRoomLiveMessageRes_t:%zi",sizeof(CMDTextRoomLiveMessageRes_t));
    CMDTextRoomLiveMessageRes_t *notify = (CMDTextRoomLiveMessageRes_t*)pInfo;
    DLog(@"livetype---:%d",notify->livetype);
    TextLiveModel *textModel = [[TextLiveModel alloc] initWithMessageNotify:notify];
    DLog(@"textModel---:%@",textModel.strContent);
    textModel = nil;
}

#pragma mark 明日推荐 直播重点
- (void)respPointTextList:(char *)pInfo type:(int)nType
{
    CMDTextRoomLivePointNoty_t *notify = (CMDTextRoomLivePointNoty_t *)pInfo;
    TextLiveModel *textModel = [[TextLiveModel alloc] initWithPointNotify:notify];
    DLog(@"消息类型%d--消息:%@",textModel.type,textModel.strContent);
    textModel.type = nType;
    
}

#pragma mark 文字直播列表响应 完成
- (void)respTextRoomList:(char *)pInfo
{
    CMDTextRoomLiveListNoty_t *notify = (CMDTextRoomLiveListNoty_t *)pInfo;
    //push notify
    if (notify->livetype == 5)
    {
        TextLiveModel *textModel = [[TextLiveModel alloc] initWithNotify:notify];
        [_aryChat addObject:textModel];
        DLog(@"观点消息");
    }
    else
    {
        TextLiveModel *textModel = [[TextLiveModel alloc] initWithNotify:notify];
        [_aryText addObject:textModel];
        DLog(@"文字直播");
    }
}

#pragma mark 请求文字直播列表
- (void)reqTextRoomList:(int)nIndex count:(int)nCount type:(int)nType
{
    CMDTextRoomLiveListReq_t req;
    memset(&req, 0, sizeof(CMDTextRoomLiveListReq_t));
    req.vcbid = _roomid;
    req.userid = kUserInfoId;
    req.teacherid = _teacher.teacherid;
    req.type = nType;
    req.messageid = nIndex;
    req.count = nCount;
    [self sendMessage:(char*)&req size:sizeof(CMDTextRoomLiveListReq_t) version:MDM_Version_Value
              maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomLiveListReq];
}

#pragma mark 验证讲师信息
- (void)authTeacherInfo:(char *)pInfo
{
    CMDTextRoomTeacherNoty_t *notify = (CMDTextRoomTeacherNoty_t *)pInfo;
    if (_teacher)
    {
        _teacher  = nil;
    }
    _teacher = [[TeacherModel alloc] initWithTeacher:notify];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TEXT_TEACHER_INFO_VC object:nil];
}

#pragma mark 请求讲师信息
- (void)reqTeacherInfo
{
    CMDTextRoomTeacherReq_t req;
    req.userid = kUserInfoId;
    req.vcbid = _roomid;
    [self sendMessage:(char *)&req size:sizeof(CMDTextRoomTeacherReq_t) version:MDM_Version_Value maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomTeacherReq];
}

#pragma mark 加入房间成功
- (void)joinRoomSuccess:(char *)pInfo
{
    DLog(@"加入房间成功!");
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
    __weak TextTcpSocket *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [__self thread_room];//发送心跳
    });
    [self reqTeacherInfo];
}

#pragma mark 心跳线程
- (void)thread_room
{
    int nTimes = 0;
    while (_asyncSocket)
    {
        if (nTimes%29==28)
        {
            [self sendRoomPing];
            nTimes = 0;
        }
        nTimes++;
        [NSThread sleepForTimeInterval:1.0];
    }
}

#pragma mark 发送房间心跳
- (void)sendRoomPing
{
    CMDClientPing_t req;
    memset(&req,0,sizeof(CMDClientPing_t));
    req.userid = kUserInfoId;
    req.roomid = _roomid;
    char szBuf[128]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER*)szBuf;
    pHead->length = sizeof(COM_MSG_HEADER) + sizeof(CMDClientPing_t);
    pHead->checkcode =0;
    pHead->version = MDM_Version_Value;
    pHead->maincmd = MDM_Vchat_Text;
    pHead->subcmd = Sub_Vchat_ClientPing;
    memcpy(pHead->content,&req,sizeof(CMDClientPing_t));
    NSData *data = [NSData dataWithBytes:szBuf length:pHead->length];
    [_asyncSocket writeData:data withTimeout:20 tag:2];
}

#pragma mark 加入房间错误

- (void)joinRoomError:(char *)pInfo
{
    CMDJoinRoomErr_t *pResp = (CMDJoinRoomErr_t *)pInfo;
    DLog(@"加入错误:%d",pResp->errid);
    NSString *strMsg = nil;
    switch (pResp->errid)
    {
        case 201:
        {
            strMsg = @"需要输入密码";
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_ERR_VC object:strMsg];
            return ;
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
    DLog(@"strMsg:%@",strMsg);
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_JOIN_ROOM_ERR_VC object:strMsg];
}

#pragma mark 发送消息
- (void)sendMessage:(char *)pReq size:(int)nSize version:(int)nVersion maincmd:(int)nMainCmd subcmd:(int)nSubCmd length:(size_t)nLength
{
    char szBuf[nLength];
    memset(szBuf, 0, nLength);
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER*)szBuf;
    pHead->length = sizeof(COM_MSG_HEADER) + nSize;
    pHead->checkcode =0;
    pHead->version = nVersion;
    pHead->maincmd = nMainCmd;
    pHead->subcmd = nSubCmd;
    memcpy(pHead->content,pReq,nSize);
    NSData *data = [NSData dataWithBytes:szBuf length:pHead->length];
    [_asyncSocket writeData:data withTimeout:-1 tag:1];
}

#pragma mark 往服务器发送消息
- (void)sendMessage:(char *)pReq size:(int)nSize version:(int)nVersion maincmd:(int)nMainCmd subcmd:(int)nSubCmd
{
    char szBuf[1024]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER*)szBuf;
    pHead->length = sizeof(COM_MSG_HEADER) + nSize;
    pHead->checkcode =0;
    pHead->version = nVersion;
    pHead->maincmd = nMainCmd;
    pHead->subcmd = nSubCmd;
    memcpy(pHead->content,pReq,nSize);
    NSData *data = [NSData dataWithBytes:szBuf length:pHead->length];
    [_asyncSocket writeData:data withTimeout:-1 tag:1];
}

#pragma mark 发送hello信息
- (void)sendHello:(int)nMDM_Vchat
{
    char szTemp[32]={0};
    COM_MSG_HEADER* pHead = (COM_MSG_HEADER *)szTemp;
    pHead->length = sizeof(COM_MSG_HEADER) + sizeof(CMDClientHello_t);
    pHead->checkcode = 0;
    pHead->version = MDM_Version_Value;
    pHead->maincmd = nMDM_Vchat;
    pHead->subcmd = Sub_Vchat_ClientHello;
    CMDClientHello_t* pHollo = (CMDClientHello_t *)pHead->content;
    pHollo->param1 = 12;
    pHollo->param2 = 8;
    pHollo->param3 = 7;
    pHollo->param4 = 1;
    NSData *data = [NSData dataWithBytes:szTemp length:pHead->length];
    [_asyncSocket writeData:data withTimeout:20 tag:1];
}

#pragma mark 关闭socket
-(void)closeSocket
{
    if(_asyncSocket)
    {
        [_asyncSocket disconnectAfterReading];
        _asyncSocket = nil;
    }
}

#pragma mark 加入房间
- (void)joinRoomInfo
{
    CMDJoinRoomReq_t req;
    memset(&req,0,sizeof(CMDJoinRoomReq_t));
    req.userid = kUserInfoId;
    req.vcbid = (uint32)_roomid;
    req.coremessagever = _PRODUCT_CORE_MESSAGE_VER_;
//    req.devtype = 2;
    strcpy(req.cMacAddr,[[DecodeJson macaddress] UTF8String]);
    [UserInfo sharedUserInfo].strPwd = @"123456";
    if([UserInfo sharedUserInfo].strPwd)
    {
        [UserInfo sharedUserInfo].strMd5Pwd = [DecodeJson XCmdMd5String:@"123456"];
    }
    if([UserInfo sharedUserInfo].strMd5Pwd!=nil)
    {
        strcpy(req.cuserpwd, [[UserInfo sharedUserInfo].strMd5Pwd UTF8String]);
    }
    req.time = (uint32)time(0);
    req.crc32 = 15;
    uint32 crcval = crc32((void*)&req,sizeof(CMDJoinRoomReq_t),CRC_MAGIC);
    req.crc32 = crcval;
    [self sendMessage:(char *)&req size:sizeof(CMDJoinRoomReq_t) version:MDM_Version_Value maincmd:MDM_Vchat_Text
               subcmd:Sub_Vchat_TextRoomJoinReq];
}

- (void)reconnectTextRoom
{
    if (_aryText==nil)
    {
        _aryText = [NSMutableArray array];
    }
    [_aryText removeAllObjects];
    if (_aryChat==nil)
    {
        _aryChat = [NSMutableArray array];
    }
    [_aryChat removeAllObjects];
    if (_aryNew == nil)
    {
        _aryNew = [NSMutableArray array];
    }
    [_aryNew removeAllObjects];
    [self connectTextServer:@"122.13.81.62" port:22806];
    DLog(@"再次连接");
}

#pragma mark 连接房间
- (void)connectRoom:(int32_t)roomId
{
    _roomid = roomId;
    if (_aryText==nil)
    {
        _aryText = [NSMutableArray array];
    }
    [_aryText removeAllObjects];
    if (_aryChat==nil)
    {
        _aryChat = [NSMutableArray array];
    }
    [_aryChat removeAllObjects];
    if (_aryNew == nil) {
        _aryNew = [NSMutableArray array];
    }
    [_aryNew removeAllObjects];
//    NSString *strAry = [[UserInfo sharedUserInfo].strRoomAddr componentsSeparatedByString:@","][0];
//    NSString *strAddr = [strAry componentsSeparatedByString:@":"][0];
//    NSInteger nPort = [[strAry componentsSeparatedByString:@":"][1] integerValue];
//    [self connectTextServer:strAddr port:nPort];
    [self closeSocket];
//    [self connectTextServer:@"122.13.81.62" port:22806];
    [self connectTextServer:@"172.16.41.96" port:22806];
}

- (void)connectTextServer:(NSString *)strIp port:(NSInteger)nPort
{
    if (socketQueue==nil)
    {
        socketQueue = dispatch_queue_create("tcp_socket", 0);
    }
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:socketQueue];
    if (![_asyncSocket connectToHost:strIp onPort:nPort error:nil])
    {
        DLog(@"连接失败");
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    //连接成功
    //sendHello,sendJoinRoom
    [_asyncSocket performBlock:^{
        [_asyncSocket enableBackgroundingOnSocket];
    }];
    [_asyncSocket readDataToLength:sizeof(int32) withTimeout:-1 tag:SOCKET_READ_LENGTH];
    DLog(@"连接成功!");
    [self sendHello:MDM_Vchat_Text];
    [self joinRoomInfo];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    DLog(@"收到字节:%zi",data.length);
    switch(tag)
    {
        case SOCKET_READ_LENGTH:
        {
            memset(cBuf, 0,16384);
            char *p = (char *)[data bytes];
            int32 nSize = *((int32 *)p);
            memcpy(cBuf, [data bytes], sizeof(int32));
            if(nSize == 0)
            {
                [_asyncSocket readDataToLength:sizeof(int32) withTimeout:-1 tag:SOCKET_READ_LENGTH];
            }
            else
            {
                [_asyncSocket readDataToLength:nSize-sizeof(int32) withTimeout:-1 tag:SOCKET_READ_DATA];
            }
        }
        break;
        case SOCKET_READ_DATA:
        {
            char *p = cBuf;
            int32 nSize = *((int32 *)p);
            if(nSize==0)
            {
                DLog(@"nSize=%d!",nSize);
            }
            memcpy(p+sizeof(int32), [data bytes], data.length);
            [self getSocketHead:cBuf len:(int32)(data.length+sizeof(int32))];
        }
            break;
        default:
            break;
    }
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    DLog(@"关闭连接:%@",err);
}

-(int)getSocketHead:(char *)pBuf len:(int)nLen
{
    COM_MSG_HEADER* in_msg = (COM_MSG_HEADER *)pBuf;
    if(in_msg->maincmd == MDM_Vchat_Text)
    {
        [self authTextRoom:in_msg];
    }
    else
    {
        DLog(@"%d-%d",in_msg->maincmd,in_msg->subcmd);
    }
    return 0;
}


#pragma mark 临时使用 
- (void)createTextMessage:(uint32_t)teacherid type:(int)nType msg:(NSString *)strMsg
{
    NSData *msgData = [strMsg dataUsingEncoding:GBK_ENCODING];
    int nLength = (int)msgData.length+1+sizeof(CMDTextRoomLiveMessageReq_t);
    char szBuf[nLength];
    memset(szBuf, 0, nLength);
    CMDTextRoomLiveMessageReq_t *req = (CMDTextRoomLiveMessageReq_t *)szBuf;
    req->vcbid = _roomid;
    req->textlen = msgData.length+1;
    req->teacherid = teacherid;
    if (nType==2)
    {
        req->pointflag = 1;
    }
    else if(nType ==3)
    {
        req->forecastflag = 1;
    }
    else
    {
        
    }
    req->livetype = 1;
    req->messagetime = [self getNowTime];
    memcpy(req->content, msgData.bytes, msgData.length);
    req->content[req->textlen -1] = '\0';
    [self sendMessage:szBuf size:nLength version:MDM_Version_Value
              maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextRoomLiveMessageReq length:nLength+100];
}

- (void)exitRoom
{
    CMDUserExitRoomInfo_t req= {0};
    req.userid = kUserInfoId;
    req.vcbid = _roomid;
    [self sendMessage:(char *)&req size:sizeof(CMDUserExitRoomInfo_t) version:MDM_Version_Value maincmd:MDM_Vchat_Text subcmd:Sub_Vchat_TextLiveUserExitReq];
    [self closeSocket];
}

- (int64_t)getNowTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDate = [fmt stringFromDate:date];
    int64_t messageTime = atoll([strDate UTF8String]);
    return messageTime;
}

- (int32_t)getdateFromString:(NSString *)strInfo
{
    int32_t messageTime = [strInfo intValue];
    return messageTime;
}

@end
