#ifndef __HTTP_LISTENER_H__
#define __HTTP_LISTENER_H__

#include "HttpMessageComplex.pb.h"

#include <vector>
#include "ConnectionListener.h"

using std::vector;

class HttpListener
{
public:

	virtual void OnError(int errCode)=0;

#ifdef WIN
	void onResponseRawData(string data){}
#endif

};

class OperateStockProfitListener : public HttpListener
{
public:
    virtual void onResponse(vector<OperateStockProfit>& infos)=0;
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
	virtual void onResponse(ViewpointDetail& info);void OnError(int errCode);
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
	virtual void onResponse(OperateStockProfit& profit, OperateStockData& data, vector<OperateStockTransaction>& trans, vector<OperateStocks>& stocks, uint32 currLevelId, uint32 minVipLevel);void OnError(int errCode);
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
	virtual void onResponse(vector<Team>& infos);void OnError(int errCode);
};

class TeamIntroduceListener : public HttpListener
{
public:
	virtual void onResponse(Team& info);void OnError(int errCode);
};

class TeamVideoListener : public HttpListener
{
public:
	virtual void onResponse(vector<VideoInfo> infos);void OnError(int errCode);
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

class SystemMessageListener : public HttpListener
{
public:
	virtual void onResponse(vector<SystemMessage>& info);void OnError(int errCode);
};

class QuestionAnswerListener : public HttpListener
{
public:
	virtual void onResponse(vector<QuestionAnswer>& info);void OnError(int errCode);
};

class MailReplyListener : public HttpListener
{
public:
	virtual void onResponse(vector<MailReply>& info);void OnError(int errCode);
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
	virtual void onResponse(std::vector<BannerItem> banner_data, std::vector<HomePageVideoroomItem> vedioroom_data, std::vector<ViewpointSummary> viewpoint_data, std::vector<OperateStockProfit> operate_data);void OnError(int errCode);
};

class CollectionListener : public HttpListener
{
public:
	virtual void onResponse(std::vector<CollectItem> room_data);void OnError(int errCode);
};

#endif
