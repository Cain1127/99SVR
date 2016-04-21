#ifndef __HTTP_CONNECTION_H__
#define __HTTP_CONNECTION_H__

#include "platform.h"
#include "Connection.h"
#include "HttpListener.h"
#include "Json.h"

#include <exception>

/*
 struct HttpThreadParam
 {
	char url[512];
	HttpListener* http_listener;
	ParseJson parser;
 };
 */
class HttpConnection
{
private:
    
public:
    //请求闪屏图片
    void RequestSplashImage(SplashImageListener* listener);
    
    // 请求观点列表
    void RequestViewpointSummary(int authorId, int startId, int requestCount, ViewpointSummaryListener* listener);
    
    // 请求观点详情
    void RequestViewpointDetail(int viewpointId, ViewpointDetailListener* listener);
    
    // 请求观点回复
    void RequestReply(int viewpointId, int startId, int requestCount, ReplyListener* listener);
    
    // 回复观点
    void PostReply(int viewpointId, int parentReplyId, int authorId, char* content, PostReplyListener* listener);
    
    // 请求操盘列表-日收益排序
    void RequestOperateStockProfitOrderByDay(int teamId, int startId, int count, OperateStockProfitListener* listener);
    // 请求操盘列表-月收益排序
    void RequestOperateStockProfitOrderByMonth(int teamId, int startId, int count, OperateStockProfitListener* listener);
    // 请求操盘列表-总收益排序
    void RequestOperateStockProfitOrderByTotal(int teamId, int startId, int count, OperateStockProfitListener* listener);
    
    // 请求操盘详情
    void RequestOperateStockAllDetail(int operateId, OperateStockAllDetailListener* listener);
    
    // 请求操盘详情--交易记录
    void RequestOperateStockTransaction(int operateId, OperateStockTransactionListener* listener);
    
    // 请求操盘详情--持仓情况
    void RequestOperateStocks(int operateId, OperateStocksListener* listener);
    // 什么是我的私人定制
    void RequestWhatIsPrivateService(WhatIsPrivateServiceListener* listener);
    
    // 请求我已经购买的私人定制
    void RequestMyPrivateService(int userId, MyPrivateServiceListener* listener);
    
    // 显示购买私人定制页
    void RequestBuyPrivateServicePage(int userId, BuyPrivateServiceListener* listener);
    
    // 请求战队的私人定制缩略信息
    void RequestTeamPriviteServiceSummaryPack(int teamId, TeamPriviteServiceSummaryPackListener* listener);
    
    // 请求私人定制详情
    void RequestPrivateServiceDetail(int id, PrivateServiceDetailListener* listener);
    
    
    // 请求充值规则列表
    void RequestChargeRuleList(ChargeRuleListener* listener);
    
    // 请求战队（财经直播）列表
    void RequestTeamList(TeamListListener* listener);
    
    // 请求战队简介
    void RequestTeamIntroduce(int teamId, TeamIntroduceListener* listener);
    
    // 请求贡献榜
    void RequestConsumeRank(int teamId, ConsumeRankListener* listener);
    
    // 提问
    void PostAskQuestion(int teamId, string stock, string question, AskQuestionListener* listener);
    
    
    // 请求系统消息
    void RequestSystemMessage(int startId, int count, SystemMessageListener* listener);
    
    // 请求问题回复--已回答的
    void RequestQuestionAnswer(int startId, int count, QuestionAnswerListener* listener, bool isTeamer = false);
    
    // 请求评论回复--收到的评论
    void RequestMailReply(int startId, int count, MailReplyListener* listener);
    
    // 请求私人定制
    void RequestPrivateServiceSummary(int startId, int count, PrivateServiceSummaryListener* listener);
    
    // 请求未读数
    void RequestUnreadCount(UnreadListener* listener);
    
    // 请求问题回复--未回回答的（PC端接口）
    void RequestQuestionUnAnswer(int startId, int count, QuestionAnswerListener* listener, bool isTeamer = false);
    
    // 请求评论回复--发出的评论（PC端接口）
    void RequestMailSendReply(int startId, int count, MailReplyListener* listener);
    
    // 讲师团队回答提问（PC端接口）
    void PostAnswer(int questionId, string content, HttpListener* listener);
    
    void RequestHomePage(std::string devType, HomePageListener* listener);//首页列表数据
    
    void RequestFollowTeacher(int userId, std::string devType, FollowTeacherListener* listener);//关注的讲师
    
    void RequestFootPrint(int userId, std::string devType, FootPrintListener* listener);//足迹url
    
    void RequestCollection(int userId, std::string devType, CollectionListener* listener);////收藏url
    
    void RequestBanner(std::string url, BannerListener* listener);////获取Banner
    
};

#endif