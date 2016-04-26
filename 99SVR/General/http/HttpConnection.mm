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
    Splash info;
    info.set_imageurl("http://xx.x.x/x.png");
    listener->onResponse(info);
}


// 请求操盘列表-日收益排序
void HttpConnection::RequestOperateStockProfitOrderByDay(int teamId, int startId, int count, OperateStockProfitListenerDay* listener)
{
    NSLog(@"startId= %d",startId);
    
    
    std::vector<OperateStockProfit> day;
    static int initId = 10;
    int i = startId;
    if ( startId == 0 ) {
        i = initId;
        startId = initId;
    }else if (startId ==2){
        
        listener->onResponse(day);
        return;
    }
    
    for (; i>startId - count; i--) {
        OperateStockProfit profit;
        profit.set_operateid(1990);
        char cBuf[10]={0};
        sprintf(cBuf,"%d",90000+i);
        profit.set_teamid(cBuf);
        profit.set_teamname("日收益组合");
        profit.set_goalprofit(0.08);
        profit.set_monthprofit(0.2);
        profit.set_focus("日收益专注短线");
        profit.set_totalprofit(0.5);
        profit.set_dayprofit(0.1);
        profit.set_winrate(0.4);
        day.push_back(profit);
    
        NSLog(@" -----  transid %d",i);
        
    }
    listener->onResponse(day);
}

// 请求操盘列表-月收益排序
void HttpConnection::RequestOperateStockProfitOrderByMonth(int teamId, int startId, int count, OperateStockProfitListenerMonth* listener)
{
    std::vector<OperateStockProfit> mon;
    static int initId = 15;
    int i = startId;
    if ( startId == 0 ) {
        i = initId;
        startId = initId;
    }else if (startId ==3){
        
        listener->onResponse(mon);
        return;
    }
    
    NSLog(@"startId= %d",startId);
    
    for (; i>startId - count; i--) {
        OperateStockProfit profit;
        profit.set_operateid(i+1);
        char cBuf[10]={0};
        sprintf(cBuf,"%d",90000+i);
        profit.set_teamid(cBuf);
        profit.set_teamname("月收益组合");
        profit.set_goalprofit(0.08);
        profit.set_monthprofit(0.2);
        profit.set_focus("月专注长线");
        profit.set_totalprofit(0.5);
        profit.set_dayprofit(0.1);
        profit.set_winrate(0.4);
        mon.push_back(profit);
        
    }
    listener->onResponse(mon);
}

// 请求操盘列表-总收益排序
void HttpConnection::RequestOperateStockProfitOrderByTotal(int teamId, int startId, int count, OperateStockProfitListenerAll* listener)
{
    std::vector<OperateStockProfit> total;
    
    static int initId = 15;
    int i = startId;
    if ( startId == 0 ) {
        i = initId;
        startId = initId;
    }else if (startId ==3){
        
        listener->onResponse(total);
        return;
    }
    
    
    for (; i>startId - count; i--) {
        OperateStockProfit profit;
        profit.set_operateid(i+1);
        char cBuf[10]={0};
        sprintf(cBuf,"%d",90000+i);
        profit.set_teamid(cBuf);
        profit.set_teamname("总收益组合");
        profit.set_goalprofit(0.08);
        profit.set_monthprofit(0.2);
        profit.set_focus("总长期");
        profit.set_totalprofit(0.5);
        profit.set_dayprofit(0.1);
        profit.set_winrate(0.4);
        total.push_back(profit);
        
    }
    listener->onResponse(total);
}

// 请求操盘详情
void HttpConnection::RequestOperateStockAllDetail(int operateId, OperateStockAllDetailListener* listener)
{
}

// 请求操盘详情--交易记录
void HttpConnection::RequestOperateStockTransaction(int operateId, int startId, int count, OperateStockTransactionListener* listener)
{
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
    
}

// 讲师团队回答提问（PC端接口）
void HttpConnection::PostAnswer(int questionId, const char* content, HttpListener* listener)
{
    
}

/******************************解析json******************************/

void parse_homepage(char* json, HttpListener* listener)
{
    HomePageListener* homepage_listener = (HomePageListener*)listener;
    
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    int size_ = 0;
    int i = 0;
    
    std::vector<HomePageVideoroomItem> vec_videoroom;
    std::vector<HomePageViewpointItem> vec_viewpoint;
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
                    JsonValue& videoroom = value["data"]["videoroom"];
                    if(!videoroom.isNull())
                    {
                        size_ = videoroom.size();
                        vec_videoroom.clear();
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
                    if(!viewpoint.isNull())
                    {
                        size_ = viewpoint.size();
                        vec_viewpoint.clear();
                        for(i = 0; i < size_; i++)
                        {
                            HomePageViewpointItem viewpointItem;
                            viewpointItem.set_viewid(viewpoint[i]["viewid"].asString());
                            viewpointItem.set_teacherid(viewpoint[i]["teacherid"].asString());
                            viewpointItem.set_dtime(viewpoint[i]["dtime"].asString());
                            viewpointItem.set_czans(viewpoint[i]["czans"].asString());
                            viewpointItem.set_title(viewpoint[i]["title"].asString());
                            viewpointItem.set_roomid(viewpoint[i]["roomid"].asString());
                            viewpointItem.set_calias(viewpoint[i]["calias"].asString());
                            
                            vec_viewpoint.push_back(viewpointItem);
                        }
                    }
                    
                    JsonValue& operate = value["data"]["operate"];
                    
                    if(!operate.isNull())
                    {
                        size_ = operate.size();
                        vec_operate.clear();
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
                    
                    homepage_listener->onResponse(vec_videoroom, vec_viewpoint, vec_operate);
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

void parse_followteacherlist(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<FollowTeacherRoomItem> vec_room;
    
    int size_ = 0;
    int i = 0;
    
    FollowTeacherListener* followteacher_listener = (FollowTeacherListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& rooms = value["rooms"];
            
            if(!rooms.isNull())
            {
                size_ = rooms.size();
                vec_room.clear();
                for(i = 0; i < size_; i++)
                {
                    FollowTeacherRoomItem room;
                    room.set_nvcbid(rooms[i]["nvcbid"].asString());
                    room.set_roomname(rooms[i]["roomname"].asString());
                    room.set_teacherid(rooms[i]["teacherid"].asString());
                    room.set_croompic(rooms[i]["croompic"].asString());
                    room.set_clabel(rooms[i]["clabel"].asString());
                    room.set_ncount(rooms[i]["ncount"].asString());
                    
                    vec_room.push_back(room);
                }
                
                followteacher_listener->onResponse(vec_room);
            }
            else
            {
                followteacher_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            followteacher_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        followteacher_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_footprintlist(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<FootPrintItem> vec_room;
    
    FootPrintListener* footprint_listener = (FootPrintListener*)listener;
    
    int size_ = 0;
    int i = 0;
    
    try
    {
        // 解析逻辑
        //..
        if (reader.parse(strJson, value))
        {
            JsonValue& arr = value["arr"];
            JsonValue& rooms = arr["FootPrint"];
            
            if(!rooms.isNull())
            {
                size_ = rooms.size();
                vec_room.clear();
                for(i = 0; i < size_; i++)
                {
                    FootPrintItem room;
                    room.set_nvcbid(rooms[i]["nvcbid"].asString());
                    room.set_cname(rooms[i]["cname"].asString());
                    room.set_password(rooms[i]["password"].asString());
                    room.set_croompic(rooms[i]["croompic"].asString());
                    room.set_ncount(rooms[i]["ncount"].asString());
                    room.set_cgateaddr(rooms[i]["cgateaddr"].asString());
                    room.set_livetype(rooms[i]["livetype"].asString());
                    room.set_ntype(rooms[i]["ntype"].asString());
                    
                    vec_room.push_back(room);
                }
            }
            
            footprint_listener->onResponse(vec_room);
        }
        else
        {
            footprint_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
    }
    catch ( std::exception& ex)
    {
        footprint_listener->OnError(PERR_JSON_PARSE_ERROR);
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
                        
                        int size_ = data.size();
                        
                        vec_collect.clear();
                        for(i = 0; i < size_; i++)
                        {
                            CollectItem collect;
//                            data[i]["teacherid"].asCString()
                            collect.set_teacherid(::atoi(data[i]["teacherid"].asString().c_str()));
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
    catch ( std::exception& ex)
    {
        collection_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}

void parse_bannerlist(char* json, HttpListener* listener)
{
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    std::vector<BannerItem> vec_banner;
    
    BannerListener* banner_listener = (BannerListener*)listener;
    
    try
    {
        // 解析逻辑
        //..
        vec_banner.clear();
        if (reader.parse(strJson, value))
        {
            if(!value["banner"].isNull())
            {
                JsonValue& bannerArray = value["banner"];
                
                int banner_size = bannerArray.size();
                
                for(int i = 0; i < banner_size; i++)
                {
                    BannerItem banner;
                    banner.set_url(bannerArray[i]["url"].asString());
                    banner.set_type(bannerArray[i]["type"].asString());
                    
                    vec_banner.push_back( banner );
                }
                
                banner_listener->onResponse(vec_banner);
            }
            else
            {
                //banner_listener->OnError(PERR_JSON_PARSE_ERROR);
            }
        }
        else
        {
            banner_listener->OnError(PERR_JSON_PARSE_ERROR);
        }
        
    }
    catch ( std::exception& ex )
    {
        banner_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
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

//获取Banner
void HttpConnection::RequestBanner(BannerListener* listener)
{
    std::string url = "http://admin.99ducaijing.com/index.php";
    //url += devType;
    
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_bannerlist;
    param->http_listener = listener;
    
    RequestParamter& request = get_request_param();
    param->request = &request;
    
    request["m"] = "Api";
    request["c"] = "Banner";
    request["client"] = get_client_type();
    
    Thread::start(http_request, param);
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
//    RequestParamter& request = get_request_param();
//    
//    request["s"] = "Personalsecrets/getMyPrivateService";
//    
//    request["userid"] = get_user_id();
//    
//    http_request_asyn(listener, parse_MyPrivateService, &request);
    std::vector<MyPrivateService> infos;
    for (int i=1; i<7; i++) {
        MyPrivateService service;
        service.set_teamid("123");
        service.set_teamname("三刀流");
        service.set_teamicon("personal_user_head");
        service.set_levelid(i);
        service.set_levelname("VIP3");
        service.set_expirationdate("有效期:2018-01-01");
        infos.push_back(service);
    }
    Team team;
    std::vector<TeamPrivateServiceSummaryPack> teamPrivate;
    listener->onResponse(infos,team,teamPrivate);
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
    request["pagecount"] = tmp;
    
    http_request_asyn(listener, parse_viewpoint, &request);
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=Viewpoint/viewpointList&authorid=%d&startid=%d&pagecount=%d",authorId,startId,requestCount);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_viewpoint;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
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
void HttpConnection::RequestCollection(std::string token, CollectionListener* listener)
{
    char tmp[128] = {0};
    
    RequestParamter& request = get_request_param();
    
    sprintf(tmp, "/user/getMyAttention/uid/%s/token/%s.html", get_user_id().c_str(), token.c_str());
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
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=viewpoint/detail/vid/%d",viewpointId);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_viewpointdetail;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
}

// 请求观点回复
void HttpConnection::RequestReply(int viewpointId, int startId, int requestCount, ReplyListener* listener)
{
    char tmp[512] = {0};
    sprintf(tmp,"viewpoint/getCommentsList/viewpointId/%d/startId/%d/requestCount/%d",viewpointId,startId,requestCount);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_viewpointreply, &request);
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=viewpoint/getCommentsList/viewpointId/%d/startId/%d/requestCount/%d",viewpointId,startId,requestCount);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_viewpointreply;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
}

// 回复观点
void HttpConnection::PostReply(int viewpointId, int parentReplyId, int authorId, int fromAuthorId, char* content, PostReplyListener* listener)
{
    char tmp[512] = {0};
    sprintf(tmp,"viewpoint/replycomments/viewpointId/%d/parentReplyId/%d/authorId/%d/fromAuthorId/%d/content/%s",viewpointId,parentReplyId,authorId,fromAuthorId,content);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_postreply, &request, HTTP_POST);
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=viewpoint/replycomments/viewpointId/%d/parentReplyId/%d/authorId/%d/fromAuthorId/%d/content/%s",viewpointId,parentReplyId,authorId,fromAuthorId,content);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_postreply;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
}

// 请求未读数
void HttpConnection::RequestUnreadCount(UnreadListener* listener)
{
    //Unread info;
    //info.set_total(12);
    //info.set_system(2);
    //info.set_answer(2);
    //info.set_reply(7);
    //info.set_privateservice(1);
    //listener->onResponse(info);
    
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=/mail/main/uid/%d",userId);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_unreadcount;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
    
    char tmp[512];
    sprintf(tmp,"/mail/main/uid/%d",login_userid);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_unreadcount, &request);
}

// 请求私人定制
void HttpConnection::RequestPrivateServiceSummary(int startId, int count,PrivateServiceSummaryListener* listener)
{
    //vector<PrivateServiceSummary> list;
    //for ( int i = startId; i < startId + count; i++ )
    //{
    //	PrivateServiceSummary info;
    //	info.set_id(i);
    //	info.set_publishtime("2016.4.19 12:20");
    //	info.set_title("互联网+股票池");
    //	info.set_summary("今日净值下跌今日净值下跌今日净值下跌今日净值下跌今日净值下跌今日净值下跌今日净值下跌今日净值下跌");
    //	info.set_teamname("三刀流");
    //	list.push_back(info);
    //}
    //listener->onResponse(list);
    
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=/mail/secret_index/uid/%d/size/%d/id/%d/type/%d",userId,count,startId,type);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_privateservicesummary;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
    char tmp[512];
    sprintf(tmp,"/mail/secret_index/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_privateservicesummary, &request);
    
}

// 请求系统消息
void HttpConnection::RequestSystemMessage(int startId, int count, SystemMessageListener* listener)
{
    //vector<SystemMessage> list;
    //for ( int i = startId; i < startId + count; i++ )
    //{
    //	SystemMessage info;
    //	info.set_id(i);
    //	info.set_publishtime("2016.4.19 12:20");
    //	info.set_title("系统消息：");
    //	info.set_content("系统维护，请注意。");
    //	list.push_back(info);
    //}
    //listener->onResponse(list);
    
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=/mail/system/uid/%d/size/%d/id/%d/type/%d",userId,count,startId,type);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_systemmessage;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
    
    char tmp[512];
    sprintf(tmp,"/mail/system/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_systemmessage, &request);
}

// 请求问题回复
void HttpConnection::RequestQuestionAnswer(int startId, int count, QuestionAnswerListener* listener, bool isTeamer)
{
    //vector<QuestionAnswer> list;
    //for ( int i = startId; i < startId + count; i++ )
    //{
    //	QuestionAnswer info;
    //	info.set_id(i);
    //	info.set_answerauthoricon("");
    //	info.set_answerauthorid("80060");
    //	info.set_answerauthorname("牛出没");
    //	info.set_answercontent("这里是回答内容这里是回答内容这里是回答内容这里是回答内容");
    //	info.set_answertime("2016.4.19 12:20");
    //	info.set_askauthorname("张三");
    //	info.set_askcontent("老师，这个票怎么样");
    //	list.push_back(info);
    //}
    //listener->onResponse(list);
    
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=/mail/question/uid/%d/size/%d/id/%d/type/%d",userId,count,startId,type);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_questionanswer;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
    
    char tmp[512];
    sprintf(tmp,"/mail/question/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_questionanswer, &request);
}

// 请求评论回复
void HttpConnection::RequestMailReply(int startId, int count, MailReplyListener* listener, bool isTeam)
{
    //vector<MailReply> list;
    //for ( int i = startId; i < startId + count; i++ )
    //{
    //	MailReply info;
    //	info.set_id(i);
    //	info.set_viewpointid(1);
    //	info.set_answerauthoricon("");
    //	info.set_answerauthorid("80060");
    //	info.set_answerauthorname("牛出没");
    //	info.set_answercontent("是啊，真不错。这里是回答内容这里是回答内容这里是回答内容这里是回答内容");
    //	info.set_answertime("2016.4.19 12:20");
    //	info.set_askauthorname("李四");
    //	info.set_askcontent("很好的观点，我觉得不错");
    //	list.push_back(info);
    //}
    //listener->onResponse(list);
    
    //char curl[512];
    //sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=/mail/comment/uid/%d/size/%d/id/%d/type/%d",userId,count,startId,type);
    
    //HttpThreadParam* param = new HttpThreadParam();
    //strcpy(param->url, curl);
    //param->parser = parse_comment;
    //param->http_listener = listener;
    
    //Thread::start(http_request, param);
    
    char tmp[512];
    sprintf(tmp,"/mail/comment/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
    
    RequestParamter& request = get_request_param();
    request["s"] = tmp;
    
    http_request_asyn(listener, parse_comment, &request);
}

// 请求战队简介（X未提供）
void HttpConnection::RequestTeamIntroduce(int teamId, TeamIntroduceListener* listener)
{
}

// 请求战队视频列表（X未提供）
void HttpConnection::RequestTeamVideo(int teamId, TeamVideoListener* listener)
{
}

void HttpConnection::PostAskQuestion(int teamId,const char* stock, const char* question, HttpListener* listener)
{
    
}

