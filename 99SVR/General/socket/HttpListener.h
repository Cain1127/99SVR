#ifndef __HTTP_LISTENER_H__
#define __HTTP_LISTENER_H__

#include "HttpMessageComplex.pb.h"

#include <vector>
#include "ConnectionListener.h"

using std::vector;

class HttpListener
{
public:
	virtual void OnError(int errCode)= 0;
};

class SplashImageListener : public HttpListener
{
public:
	virtual void onResponse(Splash& info);void OnError(int errCode);
};

class ViewpointSummaryListener : public HttpListener
{
public:
	virtual void onResponse(vector<ViewpointSummary>& infos);void OnError(int errCode);
};

class ViewpointDetailListener : public HttpListener
{
public:
	virtual void onResponse(ViewpointDetail& info, vector<ImageInfo>& images);void OnError(int errCode);
};

class ReplyListener : public HttpListener
{
public:
	virtual void onResponse(vector<Reply>& infos);void OnError(int errCode);
};

class PostReplyListener : public HttpListener
{
public:
	virtual void onResponse(int errorCode, Reply& info);void OnError(int errCode);
};

class OperateStockProfitListener : public HttpListener
{
public:
	virtual void onResponse(vector<OperateStockProfit>& infos)=0;
};
class OperateStockProfitListenerDay : public OperateStockProfitListener
{
public:
	virtual void onResponse(vector<OperateStockProfit>& infos);void OnError(int errCode);
};
class OperateStockProfitListenerMonth : public OperateStockProfitListener
{
public:
    virtual void onResponse(vector<OperateStockProfit>& infos);void OnError(int errCode);
};
class OperateStockProfitListenerAll : public OperateStockProfitListener
{
public:
    virtual void onResponse(vector<OperateStockProfit>& infos);void OnError(int errCode);
};

class OperateStockAllDetailListener : public HttpListener
{
public:
	virtual void onResponse(OperateStockProfit& profit, vector<OperateDataByTime>& totals, vector<OperateDataByTime>& month3s, vector<OperateDataByTime>& months, vector<OperateDataByTime>& weeks, vector<OperateStockTransaction>& trans, vector<OperateStocks>& stocks, uint32 currLevelId, uint32 minVipLevel);void OnError(int errCode);
};

class OperateStockTransactionListener : public HttpListener
{
public:
	virtual void onResponse(vector<OperateStockTransaction>& trans);void OnError(int errCode);
};

class OperateStocksListener : public HttpListener
{
public:
	virtual void onResponse(vector<OperateStocks>& stocks);void OnError(int errCode);
};

class MyPrivateServiceListener : public HttpListener
{
public:
	virtual void onResponse(vector<MyPrivateService>& infos, Team recommendTeam, std::vector<TeamPrivateServiceSummaryPack>& teamSummaryPackList);void OnError(int errCode);
};

class WhatIsPrivateServiceListener : public HttpListener
{
public:
	virtual void onResponse(WhatIsPrivateService& infos);void OnError(int errCode);
};

class BuyPrivateServiceListener : public HttpListener
{
public :
	virtual void onResponse(vector<PrivateServiceLevelDescription>& infos);void OnError(int errCode);
};

class TeamPrivateServiceSummaryPackListener : public HttpListener
{
public :
	virtual void onResponse(vector<TeamPrivateServiceSummaryPack>& infos);void OnError(int errCode);
};

class PrivateServiceDetailListener : public HttpListener
{
public:
	virtual void onResponse(PrivateServiceDetail& info);void OnError(int errCode);
};

class ChargeRuleListener: public HttpListener
{
public:
	virtual void onResponse(vector<ChargeRule>& infos);void OnError(int errCode);
};

class TeamListListener : public HttpListener
{
public:
	virtual void onResponse(vector<Team>& team_infos, vector<Team>& hiden_infos, vector<Team>& custom_service_infos);void OnError(int errCode);
};

class TeamIntroduceListener : public HttpListener
{
public:
	virtual void onResponse(Team& info);void OnError(int errCode);
};

class TeamVideoListener : public HttpListener
{
public:
	virtual void onResponse(vector<VideoInfo>& infos);void OnError(int errCode);
};

class ConsumeRankListener : public HttpListener
{
public:
	virtual void onResponse(vector<ConsumeRank>& info);void OnError(int errCode);
};

class AskQuestionListener : public HttpListener
{
public:
	virtual void onResponse(int retCode);void OnError(int errCode);
};

class AnswerQuestionListener : public HttpListener
{
public:
	virtual void onResponse(int retCode);void OnError(int errCode);
};

class UserTeamRelatedInfoListener : public HttpListener
{
public:
	virtual void onResponse(UserTeamRelatedInfo& info);void OnError(int errCode);
};

class SystemMessageListener : public HttpListener
{
public:
	virtual void onResponse(vector<SystemMessage>& info);void OnError(int errCode);
};

class QuestionAnswerListener : public HttpListener
{
public:
	virtual void onResponse(vector<QuestionAnswer>& info,int isteacher);void OnError(int errCode);
};

class MailReplyListener : public HttpListener
{
public:
	virtual void onResponse(vector<MailReply>& info,int isteacher);void OnError(int errCode);
};

class PrivateServiceSummaryListener : public HttpListener
{
public:
	virtual void onResponse(vector<PrivateServiceSummary>& info);void OnError(int errCode);
};

class UnreadListener : public HttpListener
{
public:
	virtual void onResponse(Unread& info);void OnError(int errCode);
};

class TotalUnreadListener : public HttpListener
{
public:
	virtual void onResponse(TotalUnread& info);void OnError(int errCode);
};

class TeamTopNListener : public HttpListener
{
public:
	virtual void onResponse(vector<TeamTopN>& info);void OnError(int errCode);
};

class HomePageListener : public HttpListener
{
public:
	virtual void onResponse(std::vector<BannerItem>& banner_data, std::vector<Team>& team_data, std::vector<ViewpointSummary>& viewpoint_data, std::vector<OperateStockProfit>& operate_data);void OnError(int errCode);
};

class CollectionListener : public HttpListener
{
public:
	virtual void onResponse(std::vector<Team>& room_data);void OnError(int errCode);
};

class GroupsPageListener : public HttpListener
{
public:
	virtual void onResponse(std::vector<NavigationItem>& roomgroup_data);void OnError(int errCode);
};

class OperateStockTradeRecordListener : public HttpListener
{
public:
	virtual void onResponse(vector<OperateStockTransactionPC>& infos);void OnError(int errCode);
};

#endif
