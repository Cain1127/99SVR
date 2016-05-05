//
//  HttpProtocolManager.m
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HttpManagerSing.h"
#include "HttpListener.h"
#include "HttpConnection.h"

SplashImageListener splashListener;
ViewpointSummaryListener pointSummaryListener;
ViewpointDetailListener detailsListener;
ReplyListener _replayListener;
PostReplyListener _postReplyListener;
OperateStockProfitListenerAll _operProfitListenerAll;
OperateStockProfitListenerMonth _operProfitListenerMonth;
OperateStockProfitListenerDay _operProfitListenerDay;
OperateStockAllDetailListener _stockAllListener;
OperateStockTransactionListener _transacionListener;
OperateStocksListener stocksListener;

WhatIsPrivateServiceListener whatsPrivateListener;
MyPrivateServiceListener myPrivateListener;
BuyPrivateServiceListener buyPrivateListener;
PrivateServiceDetailListener privateDetailListener;
ChargeRuleListener chargeListener;
TeamListListener _teamListListener;
TeamIntroduceListener _teamIntroduceListener;
TeamVideoListener _teamVideoListener;
ConsumeRankListener _consumeRankListener;
HomePageListener _homePageListener;
AskQuestionListener _askQuestionListener;
SystemMessageListener _systemMessageListener;
QuestionAnswerListener _questionAnswerListener;
MailReplyListener _mailReplyListener;
PrivateServiceSummaryListener _privateServiceSummaryListener;
UnreadListener _unreadListener;
//HttpListener _httpListener;
//FollowTeacherListener _followTeacherListener;
//FootPrintListener _footPrintListener;
CollectionListener _collectionListener;
//BannerListener _bannerListener;
TeamPrivateServiceSummaryPackListener _teamPrivateListener;

@interface HttpProtocolManager()
{
    HttpConnection *hConnection;
}

@end

@implementation HttpProtocolManager

DEFINE_SINGLETON_FOR_CLASS(HttpProtocolManager)

- (void)createHttpConnection{
    if(hConnection==NULL){
        hConnection = new HttpConnection();
    }
}

/**
 *  请求闪屏
 */
- (void)requestSplashImage{
    [self createHttpConnection];
    hConnection->RequestSplashImage(&splashListener);
}

/**
 *  请求观点列表
 */
- (void)RequestViewpointSummary:(int)authorId start:(int)startId count:(int)requestCount{
    [self createHttpConnection];
    hConnection->RequestViewpointSummary(authorId,startId,requestCount,&pointSummaryListener);
}

/**
 *  请求观点详情
 */
- (void)RequestViewpointDetail:(int)viewpointId{
    [self createHttpConnection];
    hConnection->RequestViewpointDetail(viewpointId,&detailsListener);
}

/**
 *  请求观点回复
 */
- (void)RequestReply:(int)viewpointId start:(int)startId count:(int)requestCount{
    [self createHttpConnection];
    hConnection->RequestReply(viewpointId, startId,requestCount,&_replayListener);
}

/**
 *  回复观点
 */
- (void)PostReply:(int)viewpointId replyId:(int)parentReplyId author:(int)authorId content:(char*)content fromId:(int)fromAuthorId
{
    [self createHttpConnection];
    hConnection->PostReply(viewpointId, parentReplyId, authorId, fromAuthorId, content, &_postReplyListener);
}

/**
 * 请求操盘列表
 */
- (void)RequestOperateStockProfitByDay:(int)teamId start:(int)startId count:(int)count
{
    [self createHttpConnection];
    hConnection->RequestOperateStockProfit(1,teamId, startId, count, &_operProfitListenerDay);
}

- (void)RequestOperateStockProfitByMonth:(int)teamId start:(int)startId count:(int)count
{
    [self createHttpConnection];
    hConnection->RequestOperateStockProfit(2,teamId, startId, count, &_operProfitListenerMonth);
}

- (void)RequestOperateStockProfitByAll:(int)teamId start:(int)startId count:(int)count
{
    [self createHttpConnection];
    hConnection->RequestOperateStockProfit(0,teamId,startId, count, &_operProfitListenerAll);
}

/**
 *  请求操盘详情
 */
- (void)RequestOperateStockAllDetail:(int)operateId{
    
    
    [self createHttpConnection];
    hConnection->RequestOperateStockAllDetail(operateId,&_stockAllListener);
}

/**
 * 请求操盘详情--交易记录
 */
- (void)RequestOperateStockTransaction:(int)operateId start:(int)startId cout:(int)count
{
    [self createHttpConnection];
    hConnection->RequestOperateStockTransaction(operateId,startId,count,&_transacionListener);
}

/**
 *  请求操盘详情--持仓情况
 */
- (void)RequestOperateStocks:(int)operateId{
    [self createHttpConnection];
    hConnection->RequestOperateStocks(operateId,&stocksListener);
}


// 什么是我的私人定制
- (void) RequestWhatIsPrivateService{
    [self createHttpConnection];
    hConnection->RequestWhatIsPrivateService(&whatsPrivateListener);
}

// 请求我已经购买的私人定制
- (void) RequestMyPrivateService:(int)userId{
    [self createHttpConnection];
    hConnection->RequestMyPrivateService(&myPrivateListener);
}

// 显示购买私人定制页
- (void) RequestBuyPrivateServicePage:(int)userId{
    [self createHttpConnection];
    hConnection->RequestBuyPrivateServicePage(userId,&buyPrivateListener);
    
}

// 请求战队的私人定制缩略信息
- (void) RequestTeamPrivateServiceSummaryPack:(int)teamId{
    [self createHttpConnection];
    hConnection->RequestTeamPrivateServiceSummaryPack(teamId,&_teamPrivateListener);

}

// 请求私人定制详情
- (void) RequestPrivateServiceDetail:(int)nId{
    [self createHttpConnection];
    hConnection->RequestPrivateServiceDetail(nId,&privateDetailListener);
}

// 请求充值规则列表
- (void) RequestChargeRuleList{
    [self createHttpConnection];
//    hConnection->RequestChargeRuleList(&chargeListener);
}

// 请求战队（财经直播）列表
- (void) RequestTeamList{
    [self createHttpConnection];
    hConnection->RequestTeamList(&_teamListListener);
}

// 请求战队简介
- (void) RequestTeamIntroduce:(int)teamId{
    [self createHttpConnection];
    hConnection->RequestTeamIntroduce(teamId,&_teamIntroduceListener);
    hConnection->RequestTeamVideo(teamId, &_teamVideoListener);
}

// 请求贡献榜
- (void) RequestConsumeRank:(int)teamId{
    [self createHttpConnection];
    hConnection->RequestConsumeRankList(teamId,&_consumeRankListener);
}

// 提问
- (void) PostAskQuestion:(int)teamId stock:(const char*)stock question:(const char *)question{
    [self createHttpConnection];
    hConnection->PostAskQuestion(teamId, stock, question, &_askQuestionListener);
}

// 请求系统消息
- (void)RequestSystemMessage:(int)startId count:(int)count
{
    [self createHttpConnection];
    hConnection->RequestSystemMessage(startId, count, &_systemMessageListener);
}

// 请求问题回复--已回答的
- (void)RequestQuestionAnswer:(int)startId count:(int)count teamer:(BOOL)isTeamer
{
    [self createHttpConnection];
    hConnection->RequestQuestionAnswer(startId, count, &_questionAnswerListener);
}

// 请求评论回复--收到的评论
- (void)RequestMailReply:(int)startId count:(int)count
{
    [self createHttpConnection];
    hConnection->RequestMailReply(startId, count, &_mailReplyListener);
}

// 请求私人定制
- (void)RequestPrivateServiceSummary:(int)startId count:(int)count
{
    [self createHttpConnection];
    hConnection->RequestPrivateServiceSummary(startId, count, &_privateServiceSummaryListener);
}

// 请求未读数
- (void)RequestUnreadCount
{
    [self createHttpConnection];
    hConnection->RequestUnreadCount(&_unreadListener);
}

// 请求问题回复--未回回答的（PC端接口）
- (void)RequestQuestionUnAnswer:(int)startId count:(int)count
{
    [self createHttpConnection];
    hConnection->RequestMailReply(startId, count, &_mailReplyListener);
}

// 请求评论回复--发出的评论（PC端接口）
- (void)RequestMailSendReply:(int)startId count:(int)count
{
    [self createHttpConnection];
//    hConnection->RequestMailSendReply(startId, count, &_mailReplyListener);
}

// 讲师团队回答提问（PC端接口）
- (void)PostAnswer:(int)questionId content:(const char *) content
{
    [self createHttpConnection];
}
//首页列表数据
- (void)RequestHomePage//首页列表数据
{
    [self createHttpConnection];
    hConnection->RequestHomePage(&_homePageListener);
}

//关注的讲师
- (void)RequestFollowTeacher
{
    [self createHttpConnection];
}

//足迹url
- (void)RequestFootPrint
{
    [self createHttpConnection];
}

//收藏url
- (void)RequestCollection
{
    [self createHttpConnection];
    hConnection->RequestCollection(&_collectionListener);
}
//获取Banner{
- (void)RequestBanner
{
    [self createHttpConnection];
}

- (NSString *)requestGoid
{
    [self createHttpConnection];
    NSString *str = [NSString stringWithUTF8String:hConnection->GetConsumeRecordUrl().c_str()];
    return str;
}

@end
