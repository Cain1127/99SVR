#ifndef __HTTP_CONNECTION_H__
#define __HTTP_CONNECTION_H__

#include "platform.h"
#include "Connection.h"
#include "HttpListener.h"
#include "Json.h"
#include "Http.h"
#include "http_common.h"

#include <exception>
#include <string>
#include <cstring>



struct HttpThreadParam
{
	char url[512];
	HttpListener* http_listener;
	ParseJson parser;
	RequestParamter* request;
	int request_method;
};

class HttpConnection
{

private:
	bool needHomePageCache;
	bool needViewPointCache;
	bool needOperateStocksCache[3];
	bool needRoomListCache;

	string GBKToUTF8(const std::string& strGBK);

public:

	HttpConnection()
	{
		needHomePageCache = true;
		needViewPointCache = true;
		needOperateStocksCache[0] = true;
		needOperateStocksCache[1] = true;
		needOperateStocksCache[2] = true;
		needRoomListCache = true;
	}

	~HttpConnection()
	{
	}

	//请求闪屏图片（X已提供）
	void RequestSplashImage(SplashImageListener* listener);


	// 请求操盘列表(日收益排序/月收益排序/总收益排序 type:0-全部收益;1-日收益;2-月收益;默认为0 )（已提供）
	void RequestOperateStockProfit(int type ,int team_id, int page, int size, OperateStockProfitListener* listener);
	
	// 请求操盘详情（已提供）
	void RequestOperateStockAllDetail(int operateId, OperateStockAllDetailListener* listener);

	// 请求操盘详情--交易记录（X已提供）
	void RequestOperateStockTransaction(int operateId, int startId, int count, OperateStockTransactionListener* listener);

	// 请求操盘详情--持仓情况（X已提供）
	void RequestOperateStocks(int operateId, OperateStocksListener* listener);


	// 什么是我的私人定制（已提供）
	void RequestWhatIsPrivateService(WhatIsPrivateServiceListener* listener);

	// 请求我已经购买的私人定制（已提供）
	void RequestMyPrivateService(MyPrivateServiceListener* listener);

	// 显示购买私人定制页（已提供）
	void RequestBuyPrivateServicePage(int teacher_id, BuyPrivateServiceListener* listener);

	// 请求战队的私人定制缩略信息（已提供）
	void RequestTeamPrivateServiceSummaryPack(int teamId, TeamPrivateServiceSummaryPackListener* listener);

	// 请求私人定制详情（已提供）
	void RequestPrivateServiceDetail(int privateServerceId, PrivateServiceDetailListener* listener);


	// 请求战队（财经直播）列表（已提供）
	void RequestTeamList(TeamListListener* listener);

	// 请求战队简介（已提供）
	void RequestTeamIntroduce(int teamId, TeamIntroduceListener* listener);

	// 请求战队视频列表（已提供）
	void RequestTeamVideo(int teamId, TeamVideoListener* listener);

	// 请求贡献榜（已提供）
	void RequestConsumeRankList(int teamId, ConsumeRankListener* listener);

	//首页列表数据（已提供）
	void RequestHomePage(HomePageListener* listener);

	// 我的关注（已提供）
	void RequestCollection(CollectionListener* listener);////收藏url


	// 请求观点列表（已提供）
	void RequestViewpointSummary(int authorId, int startId, int requestCount, ViewpointSummaryListener* listener);

	// 请求观点详情（已提供）
	void RequestViewpointDetail(int viewpointId, ViewpointDetailListener* listener);

	// 请求观点回复（已提供）
	void RequestReply(int viewpointId, int startId, int requestCount, ReplyListener* listener);

	// 回复观点（已提供）
	void PostReply(int viewpointId, int parentReplyId, int authorId, int fromAuthorId, const char* content, PostReplyListener* listener);

	// 请求每个分类的未读数（已提供）
	void RequestUnreadCount(UnreadListener* listener);

	// 请求总的未读数（已未提供）
	void RequestTotalUnreadCount(TotalUnreadListener* listener);

	// 请求系统消息（已提供）
	void RequestSystemMessage(int startId, int count, SystemMessageListener* listener);

	// 请求问题回复--已回答的（已提供）
	void RequestQuestionAnswer(int startId, int count, QuestionAnswerListener* listener);

	// 请求评论回复--收到的评论（已提供）
	void RequestMailReply(int startId, int count, MailReplyListener* listener);

	// 请求私人定制（已提供）
	void RequestPrivateServiceSummary(int startId, int count, PrivateServiceSummaryListener* listener);

	// 高手操盘交易记录PC
	void RequestPrivateTradeRecord(int startId, int count,OperateStockTradeRecordListener* listener);

	// 提问（已提供）
	void PostAskQuestion(int teamId, const char* stock, const char* question, AskQuestionListener* listener);

	// 获取剩余提问次数等信息（未提供）
	void RequestUserTeamRelatedInfo(int teamId, UserTeamRelatedInfoListener* listener);

	// 请求问题回复--未回回答的（PC端接口）
	void RequestQuestionUnAnswer(int startId, int count, QuestionAnswerListener* listener);

	// 请求评论回复--发出的评论（PC端接口）
	void RequestMailSendReply(int startId, int count, MailReplyListener* listener);

	// 讲师团队回答提问（PC端接口）（X未提供）
	void PostAnswer(int questionId, int teamId, char* answer, AnswerQuestionListener* listener);

	// PC左侧菜单
	void RequestPcGroupsPage(GroupsPageListener* listener);

};

#endif
