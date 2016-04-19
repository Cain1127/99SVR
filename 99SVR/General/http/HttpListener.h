#ifndef __HTTP_LISTENER_H__
#define __HTTP_LISTENER_H__

#include "HttpMessage.pb.h"
#include <vector>
#include "ConnectionListener.h"
#include "HttpMessageComplex.pb.h"

using std::vector;

class HttpListener
{
public:

//	virtual void OnError() = 0;
};

class SplashImageListener : public HttpListener
{
public:
	virtual void onResponse(Splash& info);

};

class ViewpointSummaryListener : public HttpListener
{
public:
    virtual void onResponse(vector<ViewpointSummary>& infos);
};

class ViewpointDetailListener : public HttpListener
{
public:
	virtual void onResponse(ViewpointDetail& infos);
};

class ReplyListener : public HttpListener
{
public:
	virtual void onResponse(vector<Reply>& infos);
};

class PostReplyListener : public HttpListener
{
public:
	virtual void onResponse(int errorCode, Reply& info);
};

class OperateStockProfitListener : public HttpListener
{
public:
	virtual void onResponse(vector<OperateStockProfit>& day, vector<OperateStockProfit>& month, vector<OperateStockProfit>& total);
};

class OperateStockAllDetailListener : public HttpListener
{
public:
	virtual void onResponse(OperateStockProfit& profit, OperateStockData& data,
                            vector<OperateStockTransaction>& trans, vector<OperateStocks>& stocks);
};

class OperateStockTransactionListener : public HttpListener
{
public:
	virtual void onResponse(vector<OperateStockTransaction>& trans);
};

class OperateStocksListener : public HttpListener
{
public:
	virtual void onResponse(vector<OperateStocks>& stocks);
};

class MyPrivateServiceListener : public HttpListener
{
public:
    virtual void onResponse(vector<MyPrivateService>& infos, Team recommendTeam, TeamPriviteServiceSummaryPack& teamSummaryPack);
};

class WhatIsPrivateServiceListener : public HttpListener
{
public:
    virtual void onResponse(WhatIsPrivateService& infos);
};

class BuyPrivateServiceListener : public HttpListener
{
    public :
    virtual void onResponse(vector<PrivateServiceLevelDescription>& infos, string expirationDate, uint32 currLevelId);
};

class TeamPriviteServiceSummaryPackListener : public HttpListener
{
    public :
    virtual void onResponse(vector<TeamPriviteServiceSummaryPack>& infos);
};

class PrivateServiceDetailListener : public HttpListener
{
public:
    virtual void onResponse(PrivateServiceDetail& info);
};

class ChargeRuleListener: public HttpListener
{
public:
    virtual void onResponse(vector<ChargeRule>& infos);
};

class TeamListListener : public HttpListener
{
public:
    virtual void onResponse(vector<Team>& infos);
};

class TeamIntroduceListener : public HttpListener
{
public:
    virtual void onResponse(TeamIntroduce& info);
};

class ConsumeRankListener : public HttpListener
{
public:
    virtual void onResponse(vector<ConsumeRank>& info);
};

class AskQuestionListener : public HttpListener
{
    public :
    virtual void onResponse(int errCode, string errMsg);
};



/*
class HomePageListener : public HttpListener
{
public:
	virtual void onResponse(std::vector<HomePageHttpResponseVideoroomItem> vedio_data, std::vector<HomePageHttpResponseTextroomItem> textroom_data, std::vector<HomePageHttpResponseViewpointItem> viewpoint_data) = 0;
};

class FollowTeacherListener : public HttpListener
{
public:
	virtual void onResponse(std::vector<FollowTeacherHttpResponseRoomItem> room_data) = 0;
};

class FootPrintListener : public HttpListener
{
public:
	virtual void onResponse(std::vector<FootPrintHttpResponseItem> room_data) = 0;
};

class CollectionListener : public HttpListener
{
public:
	virtual void onResponse(std::vector<CollectHttpResponseItem> room_data) = 0;
};

class BannerListener : public HttpListener
{
public:
	virtual void onResponse(std::vector<BannerHttpResponseItem> room_data) = 0;
};
*/

#endif
