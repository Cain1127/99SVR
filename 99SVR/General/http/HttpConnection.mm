/*
 *我的：注册
 *邮箱 总的未读数 PC端接口
 *战队简介
 *缓存
 */

#include "HttpConnection.h"
#include "LoginConnection.h"
#include "Http.h"
#include "http_common.h"
#include "Thread.h"
#include "Util.h"
#include "proto_err.h"
#include <cstring>
#include <stdlib.h>


#define HTTP_API "http://testphp.99ducaijing.cn/api.php"

void parse_totalunreadcount(char* json, HttpListener* listener);
void parse_collectionlist(char* json, HttpListener* listener);
void parse_homepage(char* json, HttpListener* listener);
void parse_teamvideo(char* json, HttpListener* listener);
void parse_profitdetail(char* json, HttpListener* listener);
void parse_MyPrivateService(char* json, HttpListener* listener);
void parse_operatestocks(char* json, HttpListener* listener);
void parse_operatestocktransaction(char* json, HttpListener* listener);
void parse_splashimage(char* json, HttpListener* listener);
void parse_teamintroduce(char* json, HttpListener* listener);
void parse_postaskquestion(char* json, HttpListener* listener);


static ThreadVoid http_request(void* _param)
{
    HttpThreadParam* param = (HttpThreadParam*)_param;
    Http http(param->request_method);
    http.register_http_listener(param->http_listener);
    http.register_parser(param->parser);
    
    http.request(param->url, param->request);
    
    if(param)
    {
        if ( param->request )
        {
            delete param->request;
        }
        delete param;
    }
    
    ThreadReturn;
}

static void http_request_asyn(HttpListener* uiListener, ParseJson jsonPaser, RequestParamter* httpParam, int req_method = HTTP_GET)
{
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, HTTP_API);
    param->parser = jsonPaser;
    param->http_listener = uiListener;
    param->request = httpParam;
    param->request_method = req_method;
    
    Thread::start(http_request, param);
}

//请求闪屏图片
void HttpConnection::RequestSplashImage(SplashImageListener* listener)
{
<<<<<<< HEAD
    Splash info;
    info.set_imageurl("http://xx.x.x/x.png");
    listener->onResponse(info);
}



// 请求操盘详情
void HttpConnection::RequestOperateStockAllDetail(int operateId, OperateStockAllDetailListener* listener)
{
    
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
    for (i=0; i<1; i++) {
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
    listener->onResponse(profit,data, trans,stocks,operateId);
}

// 请求操盘详情--交易记录
void HttpConnection::RequestOperateStockTransaction(int operateId, int startId, int count, OperateStockTransactionListener* listener)
{
    std::vector<OperateStockTransaction>trans;
    
    static int initId = 15;
    int i = startId;
    if ( startId == 0 ) {
        i = initId;
        startId = initId;
    }else if (startId ==3){
        
        listener->onResponse(trans);
        return;
    }
    for (; i>=startId - count; i--) {
        
        OperateStockTransaction stock;
        stock.set_stockname("交易记录");
        stock.set_transid(i);
        stock.set_operateid(100);
        stock.set_stockid("1008699");
        stock.set_count(i+220);
        stock.set_money(110000+1);
        stock.set_price(9999);
        stock.set_time("2015 15 15");
        
        if (i%2==0) {
            
            stock.set_buytype("买入");
        }else{
            stock.set_buytype("卖出");
        }
        trans.push_back(stock);
    }
    listener->onResponse(trans);
}

// 请求操盘详情--持仓情况
void HttpConnection::RequestOperateStocks(int operateId, OperateStocksListener* listener)
{
}

// 请求问题回复--未回回答的（PC端接口）
void HttpConnection::RequestQuestionUnAnswer(int startId, int count, QuestionAnswerListener* listener, bool isTeamer)
{
    
}

// 请求评论回复--发出的评论（PC端接口）
void HttpConnection::RequestMailSendReply(int startId, int count, MailReplyListener* listener,bool isTeamer)
{
=======
    RequestParamter& request = get_request_param();
>>>>>>> 422602f61852b419090bfaac1ca723c8a9751110
    
    request["s"] = "Index/getSplashScreen";
    
    http_request_asyn(listener, parse_splashimage, &request);
}

void parse_profitorder(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<OperateStockProfit> vec_profitorder;
    
    int size_ = 0;
    int i = 0;
    
    OperateStockProfitListener* profitorder_listener = (OperateStockProfitListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                size_ = datas["list"].size();
                vec_profitorder.clear();
                for(i = 0; i < size_; i++)
                {
                    OperateStockProfit profitorder;
                    
                    profitorder.set_operateid(datas["list"][i]["operateId"].asUInt());
                    profitorder.set_teamid(datas["list"][i]["teamId"].asString());
                    profitorder.set_teamname(datas["list"][i]["teamName"].asString());
                    profitorder.set_teamicon(datas["list"][i]["teamIcon"].asString());
                    profitorder.set_focus(datas["list"][i]["focus"].asString());
                    profitorder.set_goalprofit(atof((datas["list"][i]["goalProfit"].asString()).c_str()));
                    profitorder.set_totalprofit(atof((datas["list"][i]["totalProfit"].asString()).c_str()));
                    profitorder.set_dayprofit(atof((datas["list"][i]["dayProfit"].asString()).c_str()));
                    profitorder.set_monthprofit(atof((datas["list"][i]["monthProfit"].asString()).c_str()));
                    profitorder.set_winrate(atof((datas["list"][i]["winRate"].asString()).c_str()));
                    
                    vec_profitorder.push_back(profitorder);
                }
                
                profitorder_listener->onResponse(vec_profitorder);
            }
            else
            {
                profitorder_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            profitorder_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        profitorder_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_profitdetail(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<OperateStockTransaction> vec_trans;
    std::vector<OperateStocks> vec_stocks;
    
    int size_ = 0;
    int i = 0;
    
    OperateStockAllDetailListener* detail_listener = (OperateStockAllDetailListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                OperateStockProfit osprofit;
                osprofit.set_operateid(datas["profile"]["operateId"].asUInt());
                osprofit.set_teamid(datas["profile"]["teamId"].asString());
                osprofit.set_teamname(datas["profile"]["teamName"].asString());
                osprofit.set_teamicon(datas["profile"]["teamIcon"].asString());
                osprofit.set_focus(datas["profile"]["focus"].asString());
                osprofit.set_goalprofit(atof((datas["profile"]["goalProfit"].asString()).c_str()));
                osprofit.set_totalprofit(atof((datas["profile"]["totalProfit"].asString()).c_str()));
                osprofit.set_dayprofit(atof((datas["profile"]["dayProfit"].asString()).c_str()));
                osprofit.set_monthprofit(atof((datas["profile"]["monthProfit"].asString()).c_str()));
                osprofit.set_winrate(atof((datas["profile"]["winRate"].asString()).c_str()));
                
                OperateStockData osdata;
                osprofit.set_operateid(datas["curve"]["operateId"].asUInt());
                
                size_ = datas["trans"].size();
                vec_trans.clear();
                for(i = 0; i < size_; i++)
                {
                    OperateStockTransaction trans;
                    trans.set_transid(datas["trans"][i]["transId"].asUInt());
                    trans.set_operateid(datas["trans"][i]["operateId"].asUInt());
                    trans.set_buytype(datas["trans"][i]["buytype"].asString());
                    trans.set_stockid(datas["trans"][i]["stockId"].asString());
                    trans.set_stockname(datas["trans"][i]["stockName"].asString());
                    trans.set_price(atof((datas["trans"][i]["price"].asString()).c_str()));
                    trans.set_count(datas["trans"][i]["count"].asUInt());
                    trans.set_money(atof((datas["trans"][i]["money"].asString()).c_str()));
                    trans.set_time(datas["trans"][i]["time"].asString());
                    vec_trans.push_back(trans);
                }
                
                size_ = datas["stocks"].size();
                vec_stocks.clear();
                for(i = 0; i < size_; i++)
                {
                    OperateStocks stocks;
                    stocks.set_transid(datas["stocks"][i]["transId"].asUInt());
                    stocks.set_operateid(datas["stocks"][i]["operateId"].asUInt());
                    stocks.set_stockid(datas["stocks"][i]["stockId"].asString());
                    stocks.set_stockname(datas["stocks"][i]["stockName"].asString());
                    stocks.set_count(datas["stocks"][i]["count"].asUInt());
                    stocks.set_cost(atof((datas["stocks"][i]["cost"].asString()).c_str()));
                    stocks.set_currprice(atof((datas["stocks"][i]["currPrice"].asString()).c_str()));
                    stocks.set_profitrate(atof((datas["stocks"][i]["profitRate"].asString()).c_str()));
                    stocks.set_profitmoney(atof((datas["stocks"][i]["ProfitMoney"].asString()).c_str()));
                    
                    vec_stocks.push_back(stocks);
                }
                
                uint32 currLevelId=datas["currLevelId"].asUInt();
                uint32 minVipLevel=datas["minVipLevel"].asUInt();
                
                
                detail_listener->onResponse(osprofit,osdata,vec_trans,vec_stocks,currLevelId,minVipLevel);
            }
            else
            {
                detail_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            detail_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        detail_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

// 请求操盘列表-日收益排序
void HttpConnection::RequestOperateStockProfit(int type ,int team_id, int page, int size, OperateStockProfitListener* listener)
{
   	char tmp[1024] = {0};
    sprintf(tmp,"/operate/lists/type/%d/team_id/%d/page/%d/size/%d",type,team_id,page,size);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;

    http_request_asyn(listener, parse_profitorder, &request);
}

// 请求操盘详情
void HttpConnection::RequestOperateStockAllDetail(int operateId, OperateStockAllDetailListener* listener)
{
    char tmp[1024] = {0};
    sprintf(tmp,"/operate/detail/id/%d/uid/%d",operateId,login_userid);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    
    http_request_asyn(listener, parse_profitdetail, &request);
}

// 请求操盘详情--交易记录
void HttpConnection::RequestOperateStockTransaction(int operateId, int startId, int count, OperateStockTransactionListener* listener)
{
    char tmp[128] = {0};
    
    RequestParamter& request = get_request_param();
    
    sprintf(tmp, "operate/stockTransaction/operateId/%d/startId/%d/count/%d", operateId, startId, count);
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_operatestocktransaction, &request);
}

// 请求操盘详情--持仓情况
void HttpConnection::RequestOperateStocks(int operateId, OperateStocksListener* listener)
{
    char tmp[128] = {0};
    
    RequestParamter& request = get_request_param();
    
    sprintf(tmp, "operate/stockPool/operateId/%d/startId/%d/count/%d", operateId, 0, 100);
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_operatestocks, &request);
}

// 请求问题回复--未回回答的（PC端接口）
//void HttpConnection::RequestQuestionUnAnswer(int startId, int count, QuestionAnswerListener* listener, bool isTeamer)
//{
//    
//}

// 请求评论回复--发出的评论（PC端接口）
//void HttpConnection::RequestMailSendReply(int startId, int count, MailReplyListener* listener,bool isTeamer)
//{
//    
//}

// 讲师团队回答提问（PC端接口）
//void HttpConnection::PostAnswer(int questionId, const char* content, HttpListener* listener)
//{
//    
//}

/******************************解析json******************************/

void parse_followteacherlist(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
   
   
}

void parse_PrivateServiceSummaryPack(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    int i,j;
    
    std::vector<TeamPrivateServiceSummaryPack> summary;
    
    TeamPrivateServiceSummaryPackListener* summary_listener = (TeamPrivateServiceSummaryPackListener*)listener;
    
    try
    {
        summary.clear();
        
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    if(!value["data"].isNull())
                    {
                        JsonValue& data = value["data"];
                        
                        int size_ = data.size();
                        
                        for(i = 0; i < size_; i++)
                        {
                            JsonValue& data_item = data[i];
                            
                            TeamPrivateServiceSummaryPack pack;
                            int size1_ = data_item["list"].size();
                            
                            pack.set_vipLevelId(data_item["id"].asInt());
                            pack.set_vipLevelName(data_item["vipinfoname"].asString());
                            pack.set_isOpen(data_item["isopen"].asBool());
                            
                            std::vector<PrivateServiceSummary> ss_list;
                            for(j = 0; j < size1_; j++)
                            {
                                PrivateServiceSummary ss;
                                
                                JsonValue& list_item = data_item["list"][j];
                                ss.set_id(atoi(list_item["psid"].asString().c_str()));
                                ss.set_title(list_item["title"].asString());
                                ss.set_summary(list_item["summary"].asString());
                                
                                std::string strOut;
                                string2timestamp(list_item["publishtime"].asString(), strOut);
                                ss.set_publishtime(strOut);
                                
                                ss_list.push_back(ss);
                            }
                            
                            pack.set_summaryList(ss_list);
                            
                            summary.push_back(pack);
                        }
                        
                        summary_listener->onResponse(summary);
                    }
                    else
                    {
                        summary_listener->OnError(PERR_JSON_PARSE_ERROR);
                    }
                    
                }
                else
                {
                    summary_listener->OnError(status);
                }
            }
        }
    }
    catch( std::exception& ex )
    {
        summary_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
    
}

void parse_PrivateServiceDetail(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    PrivateServiceDetail detail;
    
    PrivateServiceDetailListener* detail_listener = (PrivateServiceDetailListener*)listener;
    
    try
    {
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    if(!value["data"].isNull())
                    {
                        JsonValue& data = value["data"];
                        
                        if(data.size() > 0)
                        {
                            JsonValue& data_item = data[0];
                            detail.set_title(data_item["title"].asString());
                            detail.set_content(data_item["content"].asString());
                            
                            std::string strOut;
                            string2timestamp(data_item["publishtime"].asString(), strOut);
                            detail.set_publishtime(strOut);
                            detail.set_videourl(data_item["videourl"].asString());
                            detail.set_videoname(data_item["videoname"].asString());
                            detail.set_attachmenturl(data_item["attachmenturl"].asString());
                            detail.set_attachmentname(data_item["attachmentname"].asString());
                            
                            detail_listener->onResponse(detail);
                        }
                    }
                }
                else
                {
                    detail_listener->OnError(status);
                }
            }
        }
    }
    catch( std::exception& ex )
    {
        detail_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
    
}

void parse_ViewpointSummary(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    int i;
    
    std::vector<ViewpointSummary> viewpoint_list;
    
    ViewpointSummaryListener* view_listener = (ViewpointSummaryListener*)listener;
    
    try
    {
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    if(!value["data"].isNull())
                    {
                        JsonValue& data = value["data"];
                        
                        int size_ = data.size();
                        
                        viewpoint_list.clear();
                        for(i = 0; i < size_; i++)
                        {
                            ViewpointSummary viewpoint;
                            
                            JsonValue& data_item = data[i];
                            viewpoint.set_viewpointid(atoi(data_item["viewpointid"].asString().c_str()));
                            viewpoint.set_authorid(data_item["authorid"].asString());
                            viewpoint.set_authorname(data_item["authorname"].asString());
                            viewpoint.set_authoricon(data_item["authoricon"].asString());
                            
                            std::string strOut;
                            string2timestamp(data_item["publishtime"].asString(), strOut);
                            viewpoint.set_publishtime(strOut);
                            viewpoint.set_content(data_item["content"].asString());
                            viewpoint.set_replycount(atoi(data_item["replycount"].asString().c_str()));
                            viewpoint.set_giftcount(atoi(data_item["giftcount"].asString().c_str()));
                            
                            viewpoint_list.push_back(viewpoint);
                        }
                        
                        view_listener->onResponse(viewpoint_list);
                    }
                    else
                    {
                        view_listener->OnError(PERR_JSON_PARSE_ERROR);
                    }
                }
                else
                {
                    view_listener->OnError(status);
                }
            }
        }
    }
    catch( std::exception& ex )
    {
        view_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_TeamList(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    int i;
    
    std::vector<Team> team_list;
    
    TeamListListener* team_listener = (TeamListListener*)listener;
    
    try
    {
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    if(!value["data"].isNull())
                    {
                        JsonValue& data = value["data"];
                        
                        int size_ = data.size();
                        
                        team_list.clear();
                        for(i = 0; i < size_; i++)
                        {
                            Team team;
                            
                            JsonValue& data_item = data[i];
                            team.set_roomid(data_item["nvcbid"].asInt());
                            team.set_teamname(data_item["cname"].asString());
                            team.set_teamicon(data_item["croompic"].asString());
                            team.set_onlineusercount(data_item["ncount"].asInt());
                            team.set_teamid(data_item["ncreateid"].asInt());
                            team.set_alias(data_item["calias"].asString());
                            
                            team_list.push_back(team);
                        }
                        
                        team_listener->onResponse(team_list);
                    }
                    else
                    {
                        team_listener->OnError(PERR_JSON_PARSE_ERROR);
                    }
                }
                else
                {
                    team_listener->OnError(status);
                }
            }
        }
    }
    catch( std::exception& ex )
    {
        team_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_WhatIsPrivateService(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    int i;
    
    WhatIsPrivateService wips;
    
    WhatIsPrivateServiceListener* what_listener = (WhatIsPrivateServiceListener*)listener;
    
    try
    {
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    std::string data = value["data"].asString();
                    
                    wips.set_content(data);
                    what_listener->onResponse(wips);
                }
                else
                {
                    what_listener->OnError(status);
                }
            }
        }
    }
    catch( std::exception& ex )
    {
        what_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_MyPrivateService(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    int i,j;
    int size_;
    char tmp[32] = {0};
    std::string sTmp;
    
    std::vector<MyPrivateService> mps_list;
    Team teamItem;
    std::vector<TeamPrivateServiceSummaryPack> summary;
    
    MyPrivateServiceListener* my_listener = (MyPrivateServiceListener*)listener;
    
    try
    {
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    if(!value["data"].isNull())
                    {
                        JsonValue& data = value["data"];
                        
                        JsonValue& buylist = data["buylist"];
                        JsonValue& recommend = data["recommend"];
                        JsonValue& team = data["team"];
                        
                        size_ = buylist.size();
                        
                        if( 0 != size_ )
                        {
                            mps_list.clear();
                            for(i = 0; i < size_; i++)
                            {
                                MyPrivateService mps;
                                
                                JsonValue& data_item = data[i];
                                
                                sprintf(tmp, "%d", data_item["teacherid"].asInt());
                                sTmp = tmp;
                                mps.set_teamid(sTmp);
                                mps.set_teamname(data_item["teacherid"].asString());
                                mps.set_teamicon(data_item["nheadid"].asString());
                                mps.set_levelid(data_item["viplevel"].asInt());
                                mps.set_levelname(data_item["vipinfoname"].asString());
                                
                                std::string strOut1, strOut2;
                                string2timestamp(data_item["buytime"].asString(), strOut1);
                                string2timestamp(data_item["expirtiontime"].asString(), strOut2);
                                sprintf(tmp, "%s-%s", strOut1.c_str(), strOut2.c_str());
                                sTmp = tmp;
                                mps.set_expirationdate(sTmp);
                                
                                mps_list.push_back(mps);
                            }
                        }
                        else
                        {
                            size_ = recommend.size();
                            
                            for(i = 0; i < size_; i++)
                            {
                                JsonValue& data_item = recommend[i];
                                
                                TeamPrivateServiceSummaryPack pack;
                                int size1_ = data_item["list"].size();
                                
                                pack.set_vipLevelId(data_item["id"].asInt());
                                pack.set_vipLevelName(data_item["vipinfoname"].asString());
                                
                                std::vector<PrivateServiceSummary> ss_list;
                                ss_list.clear();
                                for(j = 0; j < size1_; j++)
                                {
                                    PrivateServiceSummary ss;
                                    
                                    JsonValue& list_item = data_item["list"][j];
                                    ss.set_id(atoi(list_item["psid"].asString().c_str()));
                                    ss.set_title(list_item["title"].asString());
                                    ss.set_summary(list_item["summary"].asString());
                                    
                                    std::string strOut;
                                    string2timestamp(list_item["publishtime"].asString(), strOut);
                                    ss.set_publishtime(strOut);
                                    
                                    ss_list.push_back(ss);
                                }
                                
                                pack.set_summaryList(ss_list);
                                
                                summary.push_back(pack);
                            }
                            
                            teamItem.set_roomid(team["id"].asInt());
                            teamItem.set_teamname(team["name"].asString());
                            teamItem.set_teamicon(team["headid"].asString());
                        }
                        
                        my_listener->onResponse(mps_list, teamItem, summary);
                    }
                    else
                    {
                        my_listener->OnError(PERR_JSON_PARSE_ERROR);
                    }
                }
                else
                {
                    my_listener->OnError(status);
                }
            }
        }
    }
    catch( std::exception& ex )
    {
        my_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

//void ConvertUtf8ToGBK(CString &strUtf8)
//{
//	int len=MultiByteToWideChar(CP_UTF8, 0, (LPCTSTR)strUtf8, -1, NULL,0);
//	wchar_t * wszGBK = new wchar_t[len];
//	memset(wszGBK,0,len);
//	MultiByteToWideChar(CP_UTF8, 0, (LPCTSTR)strUtf8, -1, wszGBK, len);
//
//	len = WideCharToMultiByte(CP_ACP, 0, wszGBK, -1, NULL, 0, NULL, NULL);
//	char *szGBK=new char[len + 1];
//	memset(szGBK, 0, len + 1);
//	WideCharToMultiByte (CP_ACP, 0, wszGBK, -1, szGBK, len, NULL,NULL);
//
//	strUtf8 = szGBK;
//	delete[] szGBK;
//	delete[] wszGBK;
//}

void parse_consumerank(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<ConsumeRank> vec_consume;
    
    int size_ = 0;
    int i = 0;
    
    ConsumeRankListener* consumerank_listener = (ConsumeRankListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& consumes = value["data"];
            
            if(!consumes.isNull())
            {
                size_ = consumes.size();
                vec_consume.clear();
                for(i = 0; i < size_; i++)
                {
                    ConsumeRank consume;
                    //consume.set_username(ConvertUtf8ToGBK(consumes[i]["calias"].asCString()));
                    consume.set_username(consumes[i]["username"].asString());
                    consume.set_headid(atoi((consumes[i]["headid"].asString()).c_str()));
                    consume.set_consume(atol((consumes[i]["consume"].asString()).c_str()));
                    
                    //consume.set_headid(consumes[i]["nuserid"].asInt());
                    //consume.set_consume(consumes[i]["totalmoney"].asUInt64());
                    vec_consume.push_back(consume);
                }
                
                consumerank_listener->onResponse(vec_consume);
            }
            else
            {
                consumerank_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            consumerank_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        consumerank_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_viewpoint(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<ViewpointSummary> vec_viewpoint;
    
    int size_ = 0;
    int i = 0;
    
    ViewpointSummaryListener* viewpoint_listener = (ViewpointSummaryListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& viewpoints = value["data"];
            
            if(!viewpoints.isNull())
            {
                size_ = viewpoints.size();
                vec_viewpoint.clear();
                for(i = 0; i < size_; i++)
                {
                    ViewpointSummary viewpoint;
                    viewpoint.set_authorid(viewpoints[i]["authorid"].asString());
                    viewpoint.set_authorname(viewpoints[i]["authorname"].asString());
                    viewpoint.set_authoricon(viewpoints[i]["authoricon"].asString());
                    viewpoint.set_viewpointid(atoi((viewpoints[i]["viewpointid"].asString()).c_str()));
                    viewpoint.set_publishtime(viewpoints[i]["publishtime"].asString());
                    viewpoint.set_title(viewpoints[i]["title"].asString());
                    viewpoint.set_content(viewpoints[i]["content"].asString());
                    viewpoint.set_replycount(atoi((viewpoints[i]["replycount"].asString()).c_str()));
                    viewpoint.set_giftcount(atoi((viewpoints[i]["giftcount"].asString()).c_str()));
                    vec_viewpoint.push_back(viewpoint);
                }
                
                viewpoint_listener->onResponse(vec_viewpoint);
            }
            else
            {
                viewpoint_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            viewpoint_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        viewpoint_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_BuyPrivateService(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<PrivateServiceLevelDescription> psld_list;
    
    int size_ = 0;
    int i = 0;
    
    BuyPrivateServiceListener* buy_listener = (BuyPrivateServiceListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    if(!value["data"].isNull())
                    {
                        JsonValue& data = value["data"];
                        
                        int size_ = data.size();
                        
                        psld_list.clear();
                        for(i = 0; i < size_; i++)
                        {
                            PrivateServiceLevelDescription psld;
                            
                            JsonValue& data_item = data[i];
                            
                            psld.set_levelid(atoi(data_item["viplevel"].asString().c_str()));
                            psld.set_levelname(data_item["vipinfoname"].asString());
                            psld.set_description(data_item["contents"].asString());
                            psld.set_buyprice(atof(data_item["price"].asString().c_str()));
                            //psld.set_updateprice();
                            
                            psld.set_isopen(data_item["flag"].asInt());
                            psld.set_buytime(data_item["buytime"].asString());
                            psld.set_expirtiontime(data_item["expirtiontime"].asString());
                            
                            psld_list.push_back(psld);
                        }
                        
                        buy_listener->onResponse(psld_list);
                    }
                    else
                    {
                        buy_listener->OnError(PERR_JSON_PARSE_ERROR);
                    }
                }
                else
                {
                    buy_listener->OnError(status);
                }
            }
        }
    }
    catch ( std::exception& ex)
    {
        buy_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_viewpointdetail(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    ViewpointDetailListener* detail_listener = (ViewpointDetailListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& details = value["data"];
            
            if(!details.isNull())
            {
                ViewpointDetail detail;
                detail.set_viewpointid(atoi((details["viewpointid"].asString()).c_str()));
                detail.set_authorid(details["authorid"].asString());
                detail.set_authorname(details["authorname"].asString());
                detail.set_authoricon(details["authoricon"].asString());
                detail.set_publishtime(details["publishtime"].asString());
                detail.set_title(details["title"].asString());
                detail.set_content(details["content"].asString());
                detail.set_replycount(atoi((details["replycount"].asString()).c_str()));
                detail.set_giftcount(atoi((details["giftcount"].asString()).c_str()));
                detail_listener->onResponse(detail);
            }
            else
            {
                detail_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            detail_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        detail_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_viewpointreply(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<Reply> vec_reply;
    
    int size_ = 0;
    int i = 0;
    
    ReplyListener* reply_listener = (ReplyListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& replys = value["data"];
            
            if(!replys.isNull())
            {
                size_ = replys.size();
                vec_reply.clear();
                for(i = 0; i < size_; i++)
                {
                    Reply reply;
                    reply.set_replytid(atoi((replys[i]["replytId"].asString()).c_str()));
                    reply.set_viewpointid(atoi((replys[i]["viewpointId"].asString()).c_str()));
                    reply.set_parentreplyid(atoi((replys[i]["parentReplyId"].asString()).c_str()));
                    reply.set_authorid(replys[i]["authorId"].asString());
                    reply.set_authorname(replys[i]["authorName"].asString());
                    reply.set_authoricon(replys[i]["authorIcon"].asString());
                    reply.set_fromauthorid(replys[i]["fromAuthorId"].asString());
                    reply.set_fromauthorname(replys[i]["fromAuthorName"].asString());
                    reply.set_fromauthoricon(replys[i]["fromAuthorIcon"].asString());
                    reply.set_publishtime(replys[i]["publishTime"].asString());
                    reply.set_content(replys[i]["content"].asString());
                    
                    vec_reply.push_back(reply);
                }
                
                reply_listener->onResponse(vec_reply);
            }
            else
            {
                reply_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            reply_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        reply_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_postreply(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    PostReplyListener* reply_listener = (PostReplyListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& replys = value["data"];
            
            if(!replys.isNull())
            {
                Reply reply;
                reply.set_replytid(atoi((replys["replytId"].asString()).c_str()));
                reply.set_viewpointid(atoi((replys["viewpointId"].asString()).c_str()));
                reply.set_parentreplyid(atoi((replys["parentReplyId"].asString()).c_str()));
                reply.set_authorid(replys["authorId"].asString());
                reply.set_authorname(replys["authorName"].asString());
                reply.set_authoricon(replys["authorIcon"].asString());
                reply.set_fromauthorid(replys["fromAuthorId"].asString());
                reply.set_fromauthorname(replys["fromAuthorName"].asString());
                reply.set_fromauthoricon(replys["fromAuthorIcon"].asString());
                reply.set_publishtime(replys["publishTime"].asString());
                reply.set_content(replys["content"].asString());
                
                reply_listener->onResponse(0,reply);
            }
            else
            {
                reply_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            reply_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        reply_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_unreadcount(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    UnreadListener* unread_listener = (UnreadListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                Unread unread;
                unread.set_privateservice(atoi((datas["tips"]["privateService"].asString()).c_str()));
                unread.set_system(atoi((datas["tips"]["system"].asString()).c_str()));
                unread.set_reply(atoi((datas["tips"]["reply"].asString()).c_str()));
                unread.set_answer(atoi((datas["tips"]["answer"].asString()).c_str()));
                //unread.set_total(unread.privateservice()+unread.system()+unread.reply()+unread.answer());
                
                unread_listener->onResponse(unread);
            }
            else
            {
                unread_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            unread_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        unread_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_privateservicesummary(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<PrivateServiceSummary> vec_private;
    
    int size_ = 0;
    int i = 0;
    
    PrivateServiceSummaryListener* private_listener = (PrivateServiceSummaryListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                size_ = datas["list"].size();
                vec_private.clear();
                for(i = 0; i < size_; i++)
                {
                    PrivateServiceSummary privateserv;
                    privateserv.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
                    privateserv.set_title(datas["list"][i]["title"].asString());
                    privateserv.set_summary(datas["list"][i]["summary"].asString());
                    privateserv.set_teamname(datas["list"][i]["teamName"].asString());
                    privateserv.set_publishtime(datas["list"][i]["publishTime"].asString());
                    
                    vec_private.push_back(privateserv);
                }
                
                private_listener->onResponse(vec_private);
            }
            else
            {
                private_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            private_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        private_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_privateservicedetail(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    PrivateServiceDetailListener* detail_listener = (PrivateServiceDetailListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                PrivateServiceDetail detail;
                detail.set_title(datas["row"]["title"].asString());
                detail.set_content(datas["row"]["content"].asString());
                detail.set_publishtime(datas["row"]["publishTime"].asString());
                detail.set_videourl(datas["row"]["videoUrl"].asString());
                detail.set_videoname(datas["row"]["videoName"].asString());
                detail.set_attachmenturl(datas["row"]["attachmentUrl"].asString());
                detail.set_attachmentname(datas["row"]["attachmentName"].asString());
                detail.set_operatestockid(atoi((datas["row"]["operateStockId"].asString()).c_str()));
                detail.set_html5url(datas["row"]["html5Url"].asString());
                
                detail_listener->onResponse(detail);
            }
            else
            {
                detail_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            detail_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        detail_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_systemmessage(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<SystemMessage> vec_system;
    
    int size_ = 0;
    int i = 0;
    
    SystemMessageListener* system_listener = (SystemMessageListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                size_ = datas["list"].size();
                vec_system.clear();
                for(i = 0; i < size_; i++)
                {
                    SystemMessage system;
                    system.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
                    system.set_title(datas["list"][i]["title"].asString());
                    system.set_content(datas["list"][i]["content"].asString());
                    system.set_publishtime(datas["list"][i]["publishTime"].asString());
                    vec_system.push_back(system);
                }
                
                system_listener->onResponse(vec_system);
            }
            else
            {
                system_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            system_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        system_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_questionanswer(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<QuestionAnswer> vec_questionanswer;
    
    int size_ = 0;
    int i = 0;
    
    QuestionAnswerListener* questionanswer_listener = (QuestionAnswerListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                size_ = datas["list"].size();
                vec_questionanswer.clear();
                for(i = 0; i < size_; i++)
                {
                    QuestionAnswer questionanswer;
                    questionanswer.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
                    questionanswer.set_answerauthorid(datas["list"][i]["answerAuthorId"].asString());
                    questionanswer.set_answerauthorname(datas["list"][i]["answerAuthorName"].asString());
                    questionanswer.set_answerauthorhead(datas["list"][i]["answerAuthorHead"].asString());
                    questionanswer.set_answerauthorrole(atoi((datas["list"][i]["answerAuthorRole"].asString()).c_str()));
                    questionanswer.set_answertime(datas["list"][i]["answerTime"].asString());
                    questionanswer.set_answercontent(datas["list"][i]["answerContent"].asString());
                    questionanswer.set_askauthorid(datas["list"][i]["askAuthorId"].asString());
                    questionanswer.set_askauthorname(datas["list"][i]["askAuthorName"].asString());
                    questionanswer.set_askauthorhead(datas["list"][i]["askAuthorHead"].asString());
                    questionanswer.set_askauthorrole(atoi((datas["list"][i]["askAuthorRole"].asString()).c_str()));
                    questionanswer.set_askstock(datas["list"][i]["askStock"].asString());
                    questionanswer.set_askcontent(datas["list"][i]["askContent"].asString());
                    questionanswer.set_asktime(datas["list"][i]["askTime"].asString());
                    questionanswer.set_fromclient(atoi((datas["list"][i]["fromClient"].asString()).c_str()));
                    vec_questionanswer.push_back(questionanswer);
                }
                
                questionanswer_listener->onResponse(vec_questionanswer);
            }
            else
            {
                questionanswer_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            questionanswer_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        questionanswer_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_comment(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<MailReply> vec_comment;
    
    int size_ = 0;
    int i = 0;
    
    MailReplyListener* comment_listener = (MailReplyListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                size_ = datas["list"].size();
                vec_comment.clear();
                for(i = 0; i < size_; i++)
                {
                    MailReply comment;
                    comment.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
                    comment.set_viewpointid(atoi((datas["list"][i]["viewpointid"].asString()).c_str()));
                    comment.set_title(datas["list"][i]["title"].asString());
                    comment.set_askauthorid(datas["list"][i]["askAuthorId"].asString());
                    comment.set_askauthorname(datas["list"][i]["askAuthorName"].asString());
                    comment.set_askauthorhead(datas["list"][i]["askAuthorHead"].asString());
                    comment.set_askauthorrole(atoi((datas["list"][i]["askAuthorRole"].asString()).c_str()));
                    comment.set_askcontent(datas["list"][i]["askContent"].asString());
                    comment.set_asktime(datas["list"][i]["askTime"].asString());
                    comment.set_answerauthorid(datas["list"][i]["answerAuthorId"].asString());
                    comment.set_answerauthorname(datas["list"][i]["answerAuthorName"].asString());
                    comment.set_answerauthorhead(datas["list"][i]["answerAuthorHead"].asString());	
                    comment.set_answerauthorrole(atoi((datas["list"][i]["answerAuthorRole"].asString()).c_str()));
                    comment.set_answertime(datas["list"][i]["answerTime"].asString());
                    comment.set_answercontent(datas["list"][i]["answerContent"].asString());
                    comment.set_fromclient(atoi((datas["list"][i]["fromClient"].asString()).c_str()));
                    vec_comment.push_back(comment);
                }
                
                comment_listener->onResponse(vec_comment);
            }
            else
            {
                comment_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            comment_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        comment_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

/******************************发起请求******************************/

//首页列表数据
void HttpConnection::RequestHomePage(HomePageListener* listener)
{
    RequestParamter& param = get_request_param();
    param["s"] = "index/index";
    param["client"] = get_client_type();
    
    http_request_asyn(listener, parse_homepage, &param);	
}

// 请求战队的私人定制缩略信息
void HttpConnection::RequestTeamPrivateServiceSummaryPack(int teamId, TeamPrivateServiceSummaryPackListener* listener)
{
    char tmp[32] = {0};
    
    RequestParamter& request = get_request_param();
    //param->request = &request;
    
    request["s"] = "Personalsecrets/getPSList";
    
    sprintf(tmp, "%d", teamId);
    request["teamid"] = tmp;
    
    request["userid"] = get_user_id();
    
    http_request_asyn(listener, parse_PrivateServiceSummaryPack, &request);
}

// 请求私人定制详情
void HttpConnection::RequestPrivateServiceDetail(int id, PrivateServiceDetailListener* listener)
{
    char tmp[32] = {0};
    
    RequestParamter& request = get_request_param();
    
    request["s"] = "Personalsecrets/getPSDetail";
    
    sprintf(tmp, "%d", id);
    request["psid"] = tmp;
    
    http_request_asyn(listener, parse_PrivateServiceDetail, &request);
}

// 请求战队（财经直播）列表
void HttpConnection::RequestTeamList(TeamListListener* listener)
{
    char tmp[32] = {0};
    
    RequestParamter& request = get_request_param();
    
    request["s"] = "room/getRoomList";
    
    http_request_asyn(listener, parse_TeamList, &request);
}

// 什么是我的私人定制
void HttpConnection::RequestWhatIsPrivateService(WhatIsPrivateServiceListener* listener)
{
    
    RequestParamter& request = get_request_param();
    
    request["s"] = "Personalsecrets/getWhatIsPrivateService";
    
    http_request_asyn(listener, parse_WhatIsPrivateService, &request);
}

// 请求我已经购买的私人定制
void HttpConnection::RequestMyPrivateService(MyPrivateServiceListener* listener)
{
    RequestParamter& request = get_request_param();
    
    request["s"] = "Personalsecrets/getMyPrivateService";
    
    request["userid"] = get_user_id();
    
    http_request_asyn(listener, parse_MyPrivateService, &request);
}


// 请求贡献榜（忠实周榜）列表
void HttpConnection::RequestConsumeRankList(int teamId, ConsumeRankListener* listener)
{
    char tmp[32] = {0};
    
    RequestParamter& request = get_request_param();
    request["s"] = "rankinglist/getWeeklyChart";
    
    sprintf(tmp, "%d", teamId);
    request["teacherid"] = tmp;
    
    http_request_asyn(listener, parse_consumerank, &request);
    
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=rankinglist/getWeeklyChart&teacherid=%d",teamId);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_consumerank;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
}

// 请求观点列表
void HttpConnection::RequestViewpointSummary(int authorId, int startId, int requestCount, ViewpointSummaryListener* listener)
{
    char tmp[32] = {0};
    
    RequestParamter& request = get_request_param();
    request["s"] = "Viewpoint/viewpointList";

    sprintf(tmp, "%d", authorId);
    request["authorid"] = tmp;
    sprintf(tmp, "%d", startId);
    request["startid"] = tmp;
    sprintf(tmp, "%d", requestCount);
    request["count"] = tmp;
    
    http_request_asyn(listener, parse_viewpoint, &request);
    
}

// 显示购买私人定制页
void HttpConnection::RequestBuyPrivateServicePage(int teacher_id, BuyPrivateServiceListener* listener)
{
    char tmp[128] = {0};
    
    RequestParamter& request = get_request_param();
    
    sprintf(tmp, "personalsecrets/getVipLevelContents/teacherid/%d/userid/%s", teacher_id, get_user_id().c_str());
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_BuyPrivateService, &request);
}

//收藏url(改名为我的关注)
void HttpConnection::RequestCollection(CollectionListener* listener)
{
    char tmp[128] = {0};
    
    RequestParamter& request = get_request_param();
    
    sprintf(tmp, "/user/getMyAttention/uid/%s/token/%s.html", get_user_id().c_str(), get_user_token().c_str());
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_collectionlist, &request);
}

// 请求观点详情
void HttpConnection::RequestViewpointDetail(int viewpointId, ViewpointDetailListener* listener)
{
    char tmp[512] = {0};
    sprintf(tmp,"viewpoint/detail/vid/%d",viewpointId);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_viewpointdetail, &request);

}

// 请求观点回复
void HttpConnection::RequestReply(int viewpointId, int startId, int requestCount, ReplyListener* listener)
{
    char tmp[512] = {0};
    sprintf(tmp,"viewpoint/getCommentsList/viewpointId/%d/startId/%d/requestCount/%d",viewpointId,startId,requestCount);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_viewpointreply, &request);
}

// 回复观点
void HttpConnection::PostReply(int viewpointId, int parentReplyId, int authorId, int fromAuthorId, char* content, PostReplyListener* listener)
{
    RequestParamter& request = get_request_param();
    request["s"] = "viewpoint/replycomments";
    request["viewpointId"] = int2string(viewpointId);
    request["parentReplyId"] = int2string(parentReplyId);
    request["authorId"] = int2string(authorId);
    request["fromAuthorId"] = int2string(fromAuthorId);
    request["content"] = content;
    
    http_request_asyn(listener, parse_postreply, &request, HTTP_POST);
}

// 请求总的未读数
void HttpConnection::RequestTotalUnreadCount(TotalUnreadListener* listener)
{
    char tmp[512];
    sprintf(tmp,"/mail/unread/uid/%d",login_userid);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_totalunreadcount, &request);
}

// 请求未读数
void HttpConnection::RequestUnreadCount(UnreadListener* listener)
{
    char tmp[512];
    sprintf(tmp,"/mail/main/uid/%d",login_userid);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_unreadcount, &request);
}

// 请求私人定制
void HttpConnection::RequestPrivateServiceSummary(int startId, int count,PrivateServiceSummaryListener* listener)
{
    char tmp[512];
    sprintf(tmp,"/mail/secret_index/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_privateservicesummary, &request);
    
}

// 请求系统消息
void HttpConnection::RequestSystemMessage(int startId, int count, SystemMessageListener* listener)
{
    char tmp[512];
    sprintf(tmp,"/mail/system/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_systemmessage, &request);
}

// 请求问题回复
void HttpConnection::RequestQuestionAnswer(int startId, int count, QuestionAnswerListener* listener, bool isTeamer)
{
    char tmp[512];
    sprintf(tmp,"/mail/question/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_questionanswer, &request);
}

// 请求评论回复
void HttpConnection::RequestMailReply(int startId, int count, MailReplyListener* listener, bool isTeam)
{
    char tmp[512];
    sprintf(tmp,"/mail/comment/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_comment, &request);
}

// 请求战队简介
void HttpConnection::RequestTeamIntroduce(int teamId, TeamIntroduceListener* listener)
{
    char tmp[512];
    sprintf(tmp,"personalsecrets/getTeacherIntroduce/teamid/%d",teamId);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_teamintroduce, &request);
}

// 请求战队视频列表
void HttpConnection::RequestTeamVideo(int teamId, TeamVideoListener* listener)
{
    char tmp[512];
    sprintf(tmp,"personalsecrets/getTeacherVideo/teamid/%d",teamId);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_teamvideo, &request);
}

void HttpConnection::PostAskQuestion(int teamId,const char* stock,const char* question, HttpListener* listener)
{
    RequestParamter& request = get_request_param();
    request["s"] = "questions/postaskquestion";
    request["userId"] = int2string(188609);
    request["teamId"] = int2string(teamId);
    request["stock"] = stock;
    request["question"] = question;
    request["clienttype"] = get_client_type();
    
    char tmp[1024] = { 0 };
    sprintf(tmp, "viewpoint/replycomments/userId/%d/teamId/%d/stock/%s/question/%s/clienttype/%s", login_userid, teamId, stock, question, get_client_type().c_str());
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_postaskquestion, &request, HTTP_POST);
}

void parse_splashimage(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    SplashImageListener* splash_listener = (SplashImageListener*)listener;
    
    Splash info;
    
    try
    {
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                JsonValue& data = value["data"];
                
                if(0 == status)
                {
                    info.set_imageurl(data["imageUrl"].asString());
                    info.set_text(data["text"].asString());
                    info.set_url(data["url"].asString());
                    info.set_startime(data["starTime"].asInt64());
                    info.set_endtime(data["endTime"].asInt64());
                    
                    splash_listener->onResponse(info);
                }
                else
                {
                    splash_listener->OnError(status);
                }
            }
        }
        else
        {
            splash_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex )
    {
        splash_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_teamvideo(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<VideoInfo> vec_video;
    
    int size_ = 0;
    int i = 0;
    
    TeamVideoListener* video_listener = (TeamVideoListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                size_ = datas.size();
                vec_video.clear();
                for(i = 0; i < size_; i++)
                {
                    VideoInfo video;
                    video.set_id(atoi((datas[i]["id"].asString()).c_str()));
                    video.set_name(datas[i]["title"].asString());
                    video.set_picurl(datas[i]["pic"].asString());
                    video.set_videourl(datas[i]["video"].asString());
                    vec_video.push_back(video);
                }
                
                video_listener->onResponse(vec_video);
            }
            else
            {
                video_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            video_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        video_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_teamintroduce(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    TeamIntroduceListener* introduce_listener = (TeamIntroduceListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                Team introduce;
                introduce.set_teamname(datas["cname"].asString());
                introduce.set_teamicon(datas["headid"].asString());
                introduce.set_introduce(datas["introduce"].asString());
                
                introduce.set_roomid(0);
                introduce.set_teamid(0);
                introduce.set_onlineusercount(0);
                introduce.set_locked(0);
                introduce.set_alias("");
                
                introduce_listener->onResponse(introduce);
            }
            else
            {
                introduce_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            introduce_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        introduce_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}
void parse_operatestocktransaction(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<OperateStockTransaction> operatestockstrans_list;
    
    int size_ = 0;
    int i = 0;
    
    OperateStockTransactionListener* operatestockstranlistener = (OperateStockTransactionListener*)listener;
    
    try
    {
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    if(!value["data"].isNull())
                    {
                        JsonValue& data = value["data"];
                        
                        size_ = data.size();
                        
                        operatestockstrans_list.clear();
                        
                        for(i = 0; i < size_; i++)
                        {
                            OperateStockTransaction stockstrans;
                            
                            stockstrans.set_operateid(data[i]["operateId"].asInt());
                            stockstrans.set_transid(atoi(data[i]["transId"].asString().c_str()));
                            stockstrans.set_buytype(data[i]["buytype"].asString());
                            stockstrans.set_stockid(data[i]["stockId"].asString());
                            stockstrans.set_stockname(data[i]["stockName"].asString());
                            stockstrans.set_price(atof(data[i]["price"].asString().c_str()));
                            stockstrans.set_count(atoi(data[i]["count"].asString().c_str()));
                            stockstrans.set_money(data[i]["money"].asFloat());
                            
                            std::string strOut;
                            string2timestamp(data[i]["time"].asString(), strOut);
                            stockstrans.set_time(strOut);
                            
                            operatestockstrans_list.push_back(stockstrans);
                        }
                        
                        operatestockstranlistener->onResponse(operatestockstrans_list);
                    }
                    else
                    {
                        operatestockstranlistener->OnError(PERR_JSON_PARSE_ERROR);
                    }
                }
                else
                {
                    operatestockstranlistener->OnError(status);
                }
            }
        }
        else
        {
            operatestockstranlistener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch( std::exception& ex )
    {
        operatestockstranlistener->OnError(PERR_JSON_PARSE_ERROR);
    }
}



void parse_operatestocks(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    vector<OperateStocks> operatestocks_list;
    
    int size_ = 0;
    int i = 0;
    
    OperateStocksListener* operatestockslistener = (OperateStocksListener*)listener;
    
    try
    {
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    if(!value["data"].isNull())
                    {
                        JsonValue& data = value["data"];
                        
                        size_ = data.size();
                        
                        operatestocks_list.clear();
                        
                        for(i = 0; i < size_; i++)
                        {
                            OperateStocks stocks;
                            
                            stocks.set_operateid(data[i]["operateId"].asInt());
                            stocks.set_stockid(data[i]["stockId"].asString());
                            stocks.set_stockname(data[i]["stockName"].asString());
                            stocks.set_count(atoi(data[i]["count"].asString().c_str()));
                            stocks.set_cost(atof(data[i]["cost"].asString().c_str()));
                            stocks.set_currprice(atof(data[i]["currPrice"].asString().c_str()));
                            stocks.set_profitmoney(atof(data[i]["ProfitMoney"].asString().c_str()));
                            stocks.set_profitrate(atof(data[i]["profitRate"].asString().c_str()));
                            
                            operatestocks_list.push_back(stocks);
                        }
                        
                        operatestockslistener->onResponse(operatestocks_list);
                    }
                    else
                    {
                        operatestockslistener->OnError(PERR_JSON_PARSE_ERROR);
                    }
                }
                else
                {
                    operatestockslistener->OnError(status);
                }
            }
        }
        else
        {
            operatestockslistener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch( std::exception& ex )
    {
        operatestockslistener->OnError(PERR_JSON_PARSE_ERROR);
    }
}



void parse_homepage(char* json, HttpListener* listener)
{
    HomePageListener* homepage_listener = (HomePageListener*)listener;
    
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    int size_ = 0;
    int i = 0;
    
    std::vector<BannerItem> vec_banner;
    std::vector<HomePageVideoroomItem> vec_videoroom;
    std::vector<ViewpointSummary> vec_viewpoint;
    std::vector<OperateStockProfit> vec_operate;
    
    try
    {
        // 解析逻辑
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                
                if(0 == status)
                {
                    JsonValue& banner = value["data"]["banner"];
                    
                    vec_banner.clear();
                    if(!banner.isNull())
                    {
                        size_ = banner.size();
                        for(i = 0; i < size_; i++)
                        {
                            BannerItem bannerItem;
                            bannerItem.set_url(banner[i]["url"].asString());
                            bannerItem.set_type(banner[i]["type"].asString());
                            bannerItem.set_croompic(banner[i]["croompic"].asString());
                            
                            vec_banner.push_back( bannerItem );
                        }
                    }
                    
                    JsonValue& videoroom = value["data"]["videoroom"];
                    
                    vec_videoroom.clear();
                    if(!videoroom.isNull())
                    {
                        size_ = videoroom.size();
                        for(i = 0; i < size_; i++)
                        {
                            HomePageVideoroomItem videoroomItem;
                            videoroomItem.set_nvcbid(videoroom[i]["nvcbid"].asString());
                            videoroomItem.set_croompic(videoroom[i]["croompic"].asString());
                            videoroomItem.set_livetype(videoroom[i]["livetype"].asString());
                            videoroomItem.set_ncount(videoroom[i]["ncount"].asString());
                            videoroomItem.set_cname(videoroom[i]["cname"].asString());
                            
                            vec_videoroom.push_back(videoroomItem);
                        }
                    }
                    
                    /*
                     JsonValue& textroom = value["data"]["textroom"];
                     if(!textroom.isNull())
                     {
                     size_ = textroom.size();
                     vec_textroom.clear();
                     for(i = 0; i < size_; i++)
                     {
                     HomePageTextroomItem textroomItem;
                     
                     textroomItem.set_nvcbid(textroom[i]["nvcbid"].asString());
                     textroomItem.set_roomname(textroom[i]["roomname"].asString());
                     textroomItem.set_croompic(textroom[i]["croompic"].asString());
                     textroomItem.set_livetype(textroom[i]["livetype"].asString());
                     textroomItem.set_ncount(textroom[i]["ncount"].asString());
                     textroomItem.set_clabel(textroom[i]["clabel"].asString());
                     textroomItem.set_teacherid(textroom[i]["teacherid"].asString());
                     
                     vec_textroom.push_back(textroomItem);
                     }
                     }
                     */
                    
                    JsonValue& viewpoint = value["data"]["viewpoint"];
                    
                    vec_viewpoint.clear();
                    if(!viewpoint.isNull())
                    {
                        size_ = viewpoint.size();
                        for(i = 0; i < size_; i++)
                        {
                            ViewpointSummary viewpointItem;
                            
                            viewpointItem.set_viewpointid(atoi(viewpoint[i]["viewpointId"].asString().c_str()));
                            viewpointItem.set_authorid(viewpoint[i]["authorId"].asString());
                            //viewpointItem.set_publishtime(viewpoint[i]["publishTime"].asString());
                            viewpointItem.set_title(viewpoint[i]["title"].asString());
                            
                            viewpointItem.set_replycount(atoi(viewpoint[i]["replyCount"].asString().c_str()));
                            viewpointItem.set_content(viewpoint[i]["contents"].asString());
                            //viewpointItem.set_roomid(atoi(viewpoint[i]["roomid"].asString().c_str()));
                            viewpointItem.set_authoricon(viewpoint[i]["authorIcon"].asString());
                            viewpointItem.set_authorname(viewpoint[i]["authorName"].asString());
                            
                            std::string strOut;
                            string2timestamp(viewpoint[i]["publishTime"].asString(), strOut);
                            viewpointItem.set_publishtime(strOut);
                            
                            vec_viewpoint.push_back(viewpointItem);
                        }
                    }
                    
                    JsonValue& operate = value["data"]["operate"];
                    
                    vec_operate.clear();
                    if(!operate.isNull())
                    {
                        size_ = operate.size();
                        for(i = 0; i < size_; i++)
                        {
                            OperateStockProfit operateItem;
                            operateItem.set_totalprofit(atof(operate[i]["rate"].asString().c_str()));
                            operateItem.set_focus(operate[i]["name"].asString());
                            operateItem.set_goalprofit(atof(operate[i]["target"].asString().c_str()));
                            operateItem.set_teamname(operate[i]["nickname"].asString());
                            
                            vec_operate.push_back(operateItem);
                        }
                    }
                    
                    homepage_listener->onResponse(vec_banner, vec_videoroom, vec_viewpoint, vec_operate);
                }
                else
                {
                    homepage_listener->OnError(status);
                }
            }
            else
            {
                homepage_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            homepage_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
        
    }
    catch ( std::exception& ex)
    {
        homepage_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_collectionlist(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<CollectItem> vec_collect;
    
    CollectionListener* collection_listener = (CollectionListener*)listener;
    
    int size_ = 0;
    int i = 0;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                if(0 == status)
                {
                    if(!value["data"].isNull())
                    {
                        JsonValue& data = value["data"];
                        
                        size_ = data.size();
                        
                        vec_collect.clear();
                        for(i = 0; i < size_; i++)
                        {
                            CollectItem collect;
                            
                            collect.set_teacherid(atoi(data[i]["teacherid"].asString().c_str()));
                            collect.set_nvcbid(data[i]["nvcbid"].asString());
                            collect.set_cname(data[i]["cname"].asString());
                            collect.set_password(data[i]["password"].asString());
                            collect.set_croompic(data[i]["croompic"].asString());
                            collect.set_ncount(data[i]["ncount"].asString());
                            //collect.set_cgateaddr(data[i]["cgateaddr"].asString());
                            collect.set_ntype(data[i]["ntype"].asString());
                            
                            vec_collect.push_back(collect);
                        }
                        
                        collection_listener->onResponse(vec_collect);
                    }
                    else
                    {
                        collection_listener->OnError(PERR_JSON_PARSE_ERROR);
                    }
                }
                else
                {
                    collection_listener->OnError(status);
                }
            }
            
            collection_listener->onResponse(vec_collect);
        }
        else
        {
            collection_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
        
        
    }
    catch ( std::exception& ex )
    {
        collection_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_totalunreadcount(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    TotalUnreadListener* unread_listener = (TotalUnreadListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& datas = value["data"];
            if(!datas.isNull())
            {
                TotalUnread unread;
                unread.set_total(atoi((datas["tips"]["total"].asString()).c_str()));
                
                unread_listener->onResponse(unread);
            }
            else
            {
                unread_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            unread_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        unread_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_postaskquestion(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    //AskQuestionListener* ask_listener = (AskQuestionListener*)listener;
    HttpListener* ask_listener = listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            if(!value["status"].isNull())
            {
                int status = value["status"].asInt();
                string info="";
                if(!value["info"].isNull())
                {
                    info=value["info"].asString();
                }
                
                ask_listener->OnError(status);
            }
            else
            {
                ask_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            ask_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        ask_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

