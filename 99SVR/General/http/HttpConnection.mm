#include "HttpConnection.h"

//请求闪屏图片
void HttpConnection::RequestSplashImage(SplashImageListener* listener)
{
    Splash info;
    info.set_imageurl("http://xx.x.x/x.png");
    listener->onResponse(info);
}

// 请求观点列表
void HttpConnection::RequestViewpointSummary(int authorId, int startId, int requestCount, ViewpointSummaryListener* listener){
    
    std::vector<ViewpointSummary> infos;
    for (int i=0; i<20; i++) {
        ViewpointSummary summary;
        summary.set_authoricon("");
        char cBuf[10]={0};
        sprintf(cBuf,"%d",80000+i);
        summary.set_authorid(cBuf);
        summary.set_authorname("帅哥");
        summary.set_content("你是个好人");
        summary.set_viewpointid(i+1);
        summary.set_replycount(0);
        summary.set_publishtime("201601091223");
        summary.set_flowercount(10+i);
        infos.push_back(summary);
    }
    listener->onResponse(infos);
}

// 请求观点详情
void HttpConnection::RequestViewpointDetail(int viewpointId, ViewpointDetailListener* listener){
    ViewpointDetail infos;
    infos.set_authorid("123");
    infos.set_authorname("测试");
    infos.set_viewpointid(viewpointId);
    infos.set_content("是附近的卡萨积分可是大家福克斯");
    infos.set_replycount(0);
    infos.set_flowercount(0);
    listener->onResponse(infos);
}

// 请求观点回复
void HttpConnection::RequestReply(int viewpointId, int startId, int requestCount, ReplyListener* listener){
    
}

// 回复观点
void HttpConnection::PostReply(int viewpointId, int parentReplyId, int authorId, char* content, PostReplyListener* listener){
    
}

// 请求操盘列表
void HttpConnection::RequestOperateStockProfit(int teamId, OperateStockProfitListener* listener){
    std::vector<OperateStockProfit> day;
    for (int i=0; i<10; i++) {
        OperateStockProfit profit;
        profit.set_operateid(i+1);
        char cBuf[10]={0};
        sprintf(cBuf,"%d",90000+i);
        profit.set_teamid(cBuf);
        profit.set_teamname("组合");
        profit.set_goalprofit(0.08);
        profit.set_monthprofit(0.2);
        profit.set_focus("长线跟短线有关系吗");
        profit.set_totalprofit(0.5);
        profit.set_dayprofit(0.1);
        profit.set_winrate(0.4);
        day.push_back(profit);
    }
    listener->onResponse(day, day, day);
}

// 请求操盘详情
void HttpConnection::RequestOperateStockAllDetail(int operateId, OperateStockAllDetailListener* listener){
    OperateStockProfit profit;
    profit.set_operateid(operateId);
    char cBuf[10]={0};
    sprintf(cBuf,"%d",90000);
    profit.set_teamid(cBuf);
    profit.set_teamname("组合");
    profit.set_goalprofit(0.08);
    profit.set_monthprofit(0.2);
    profit.set_focus("长线跟短线有关系吗");
    profit.set_totalprofit(0.5);
    profit.set_dayprofit(0.1);
    profit.set_winrate(0.4);
    OperateStockData data;
    data.set_operateid(operateId);
    std::vector<OperateStockTransaction> trans;
    std::vector<OperateStocks> stocks;
    int i=0;
    for (i=0; i<2; i++) {
        OperateStockTransaction saction;
        OperateStocks stock;

        saction.set_operateid(i+1);
        saction.set_stockid("12345");
        saction.set_buytype("VIP");
        saction.set_stockname("VIP");
        saction.set_price(5555);
        saction.set_count(123);
        saction.set_money(9999);
        
        trans.push_back(saction);
        
        stock.set_operateid(i+1);
        stock.set_stockid("321");
        stock.set_stockname("shenme");
        stock.set_count(12+i);
        stock.set_cost(123);
        stock.set_currprice(55);
        stock.set_profitrate(0.5);
        stock.set_profitmoney(888);
        stocks.push_back(stock);
    }
    listener->onResponse(profit,data, trans,stocks);
    
}

// 请求操盘详情--交易记录
void HttpConnection::RequestOperateStockTransaction(int operateId, OperateStockTransactionListener* listener){
    std::vector<OperateStockTransaction> trans;
    OperateStockTransaction oper;
    oper.set_operateid(operateId);
    oper.set_buytype("v1");
    oper.set_stockid("stock");
    oper.set_stockname("vip");
    oper.set_price(5);
    oper.set_count(5);
    oper.set_money(25);
    listener->onResponse(trans);
}

// 请求操盘详情--持仓情况
void HttpConnection::RequestOperateStocks(int operateId, OperateStocksListener* listener){
    
}

// 什么是我的私人定制
void HttpConnection::RequestWhatIsPrivateService(WhatIsPrivateServiceListener* listener){
    
}

// 请求我已经购买的私人定制
void HttpConnection::RequestMyPrivateService(int userId, MyPrivateServiceListener* listener){
    
}

// 显示购买私人定制页
void HttpConnection::RequestBuyPrivateServicePage(int userId, BuyPrivateServiceListener* listener){}

// 请求战队的私人定制缩略信息
void HttpConnection::RequestTeamPriviteServiceSummaryPack(int teamId, TeamPriviteServiceSummaryPackListener* listener){}

// 请求私人定制详情
void HttpConnection::RequestPrivateServiceDetail(int id, PrivateServiceDetailListener* listener){}


// 请求充值规则列表
void HttpConnection::RequestChargeRuleList(ChargeRuleListener* listener){}

// 请求战队（财经直播）列表
void HttpConnection::RequestTeamList(TeamListListener* listener){}

// 请求战队简介
void HttpConnection::RequestTeamIntroduce(int teamId, TeamIntroduceListener* listener){}

// 请求贡献榜
void HttpConnection::RequestConsumeRank(int teamId, ConsumeRankListener* listener){}

// 提问
void HttpConnection::PostAskQuestion(int teamId, string stock, string question, AskQuestionListener* listener){
    
}