#include "HttpConnection.h"
#import "UserInfo.h"
#include "Http.h"
#include "http_common.h"
#include "Thread.h"
#include <cstring>
#include "proto_err.h"

#define HTTP_API "http://hall.99ducaijing.cn:8081"

void parse_WhatIsPrivateService(char* json, HttpListener* listener);
void parse_PrivateServiceSummaryPack(char* json, HttpListener* listener);
void parse_PrivateServiceDetail(char* json, HttpListener* listener);
void parse_TeamList(char* json, HttpListener* listener);
void parse_PrivateServiceSummaryPack(char* json, HttpListener* listener);
void parse_consumerank(char* json, HttpListener* listener);

static ThreadVoid http_request(void* _param)
{
    HttpThreadParam* param = (HttpThreadParam*)_param;
    Http http;
    http.register_http_listener(param->http_listener);
    http.register_parser(param->parser);
    
    http.request(param->url, param->request);
    
    if(param)
    {
        if ( param->request ) {
            delete param->request;
        }
        delete param;
    }
    
    ThreadReturn;
}

static void http_request_asyn(HttpListener* uiListener, ParseJson jsonPaser, RequestParamter* httpParam)
{
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, HTTP_API);
    param->parser = jsonPaser;
    param->http_listener = uiListener;
    param->request = httpParam;
    
    Thread::start(http_request, param);
}

//请求闪屏图片
void HttpConnection::RequestSplashImage(SplashImageListener* listener)
{
    Splash info;
    info.set_text("info");
    info.set_url("http://www.baidu.com");
    info.set_imageurl("http://xx.x.x/x.png");
    //model
    listener->onResponse(info);
}

void testRequest(const char *curl)
{
//    HttpThreadParam* param = new HttpThreadParam();
//    strcpy(param->url, curl);
//    param->parser = parse_viewpoint;
//    param->http_listener = listener;
//    Thread::start(http_request, param);
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

// 请求观点列表
void HttpConnection::RequestViewpointSummary(int authorId, int startId, int requestCount, ViewpointSummaryListener* listener){

    char curl[512];
    sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=Viewpoint/viewpointList&authorid=%d&startid=%d&pagecount=%d",authorId,startId,requestCount);
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, curl);
    param->parser = parse_viewpoint;
    param->http_listener = listener;
    Thread::start(http_request, param);
}

// 请求观点详情
void HttpConnection::RequestViewpointDetail(int viewpointId, ViewpointDetailListener* listener){
    ViewpointDetail infos;
    infos.set_authorid("123");
    infos.set_authorname("测试");
    infos.set_viewpointid(viewpointId);
    infos.set_content("真是一个无语的情况");
    infos.set_replycount(15);
    listener->onResponse(infos);
}

// 请求观点回复
void HttpConnection::RequestReply(int viewpointId, int startId, int requestCount, ReplyListener* listener){
    vector<Reply> infos;
    for (int i=0; i<20; i++) {
        Reply summary;
        char cBuf[10]={0};
        sprintf(cBuf,"%d",80000+i);
        summary.set_replytid(i+1);
        summary.set_viewpointid(viewpointId);
        summary.set_parentreplyid(0);
        summary.set_authorid(cBuf);
        summary.set_authorname("第九");
        summary.set_authoricon("personal_user_head");
        summary.set_publishtime("201601091223");
        summary.set_fromauthorname([[UserInfo sharedUserInfo].strName UTF8String]);
        summary.set_fromauthoricon("personal_user_head");
        summary.set_content("这是一段用来测试的文字.....需要很长很长很长");
        infos.push_back(summary);
    }
    listener->onResponse(infos);
}

// 回复观点
void HttpConnection::PostReply(int viewpointId, int parentReplyId, int authorId, int fromAuthorId, char* content, PostReplyListener* listener){

}

// 请求操盘列表-日收益排序
void HttpConnection::RequestOperateStockProfitOrderByDay(int teamId, int startId, int count, OperateStockProfitListenerDay* listener){
    std::vector<OperateStockProfit> day;
    for (int i=0; i<10; i++) {
        OperateStockProfit profit;
        profit.set_operateid(i+1);
        char cBuf[10]={0};
        sprintf(cBuf,"%d",90000+i);
        profit.set_teamid(cBuf);
        profit.set_teamname("日收益组合");
        profit.set_goalprofit(0.08);
        profit.set_monthprofit(0.2);
        profit.set_focus("日收益");
        profit.set_totalprofit(0.5);
        profit.set_dayprofit(0.1);
        profit.set_winrate(0.4);
        day.push_back(profit);
    }
    listener->onResponse(day);
}
// 请求操盘列表-月收益排序
void HttpConnection::RequestOperateStockProfitOrderByMonth(int teamId, int startId, int count, OperateStockProfitListenerMonth* listener)
{
    std::vector<OperateStockProfit> day;
    for (int i=0; i<10; i++) {
        OperateStockProfit profit;
        profit.set_operateid(i+1);
        char cBuf[10]={0};
        sprintf(cBuf,"%d",90000+i);
        profit.set_teamid(cBuf);
        profit.set_teamname("月收益组合");
        profit.set_goalprofit(0.08);
        profit.set_monthprofit(0.2);
        profit.set_focus("月收益");
        profit.set_totalprofit(0.5);
        profit.set_dayprofit(0.1);
        profit.set_winrate(0.4);
        day.push_back(profit);
    }
    listener->onResponse(day);
}
// 请求操盘列表-总收益排序
void HttpConnection::RequestOperateStockProfitOrderByTotal(int teamId, int startId, int count, OperateStockProfitListenerAll* listener)
{
    std::vector<OperateStockProfit> day;
    for (int i=0; i<10; i++) {
        OperateStockProfit profit;
        profit.set_operateid(i+1);
        char cBuf[10]={0};
        sprintf(cBuf,"%d",90000+i);
        profit.set_teamid(cBuf);
        profit.set_teamname("总收益组合");
        profit.set_goalprofit(0.08);
        profit.set_monthprofit(0.2);
        profit.set_focus("总收益");
        profit.set_totalprofit(0.5);
        profit.set_dayprofit(0.1);
        profit.set_winrate(0.4);
        day.push_back(profit);
    }
    listener->onResponse(day);
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
    listener->onResponse(profit,data, trans,stocks,operateId);
}

// 请求操盘详情--持仓情况
void HttpConnection::RequestOperateStocks(int operateId, OperateStocksListener* listener){
    
    std::vector<OperateStocks>house;
    for (int i=0; i!=10; i++) {
        
        OperateStocks stock;
        stock.set_stockname("仓库详情");
        stock.set_operateid(i+100);
        stock.set_stockid("1008699");
        stock.set_count(i+110);
        stock.set_cost(10000+1);
        stock.set_profitrate(1+i);
        stock.set_profitmoney(20000+i);
        stock.set_currprice(30000+i);
        house.push_back(stock);
    }
    listener->onResponse(house);
}

// 请求操盘详情--交易记录
void HttpConnection::RequestOperateStockTransaction(int operateId, int startId, int count, OperateStockTransactionListener* listener){
    
    std::vector<OperateStockTransaction>trans;
    
    for (int i=0; i!=5; i++) {
        
        OperateStockTransaction stock;
        stock.set_stockname("交易记录");
        stock.set_operateid(i+200);
        stock.set_stockid("1008699");
        stock.set_count(i+220);
        stock.set_money(110000+1);
        stock.set_price(9999);
        stock.set_time("2015 15 15");
        stock.set_buytype("买入 卖出");
        trans.push_back(stock);
    }
    listener->onResponse(trans);

    
    
}

// 什么是我的私人定制
void HttpConnection::RequestWhatIsPrivateService(WhatIsPrivateServiceListener* listener){
    std::string url = "http://testphp.99ducaijing.cn/api.php";
    
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_WhatIsPrivateService;
    param->http_listener = listener;
    
    RequestParamter& request = get_request_param();
    param->request = &request;
    
    request["s"] = "Personalsecrets/getWhatIsPrivateService";
    
    Thread::start(http_request, param);
}

// 请求我已经购买的私人定制
void HttpConnection::RequestMyPrivateService(int userId, MyPrivateServiceListener* listener){
    
}

// 显示购买私人定制页
void HttpConnection::RequestBuyPrivateServicePage(int userId, BuyPrivateServiceListener* listener){}

// 请求战队的私人定制缩略信息
void HttpConnection::RequestTeamPrivateServiceSummaryPack(int teamId, TeamPrivateServiceSummaryPackListener* listener){
    std::string url = "http://testphp.99ducaijing.cn/api.php";
    char tmp[32] = {0};
    
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_PrivateServiceSummaryPack;
    param->http_listener = listener;
    
    RequestParamter& request = get_request_param();
    param->request = &request;
    
    request["s"] = "Personalsecrets/getPSList";
    
    sprintf(tmp, "%d", teamId);

    request["teamid"] = tmp;
    
    Thread::start(http_request, param);
}

// 请求私人定制详情
void HttpConnection::RequestPrivateServiceDetail(int id, PrivateServiceDetailListener* listener){
    std::string url = "http://testphp.99ducaijing.cn/api.php";
    char tmp[32] = {0};
    
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_PrivateServiceDetail;
    param->http_listener = listener;
    
    RequestParamter& request = get_request_param();
    param->request = &request;
    
    request["s"] = "Personalsecrets/getPSDetail";
    
    sprintf(tmp, "%d", id);
    request["psid"] = tmp;
    
    Thread::start(http_request, param);
}


// 请求充值规则列表
void HttpConnection::RequestChargeRuleList(ChargeRuleListener* listener){}

// 请求战队（财经直播）列表
void HttpConnection::RequestTeamList(TeamListListener* listener){
    std::string url = "http://testphp.99ducaijing.cn/api.php";
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_TeamList;
    param->http_listener = listener;
    
    RequestParamter& request = get_request_param();
    param->request = &request;
    
    request["s"] = "room/getRoomList";
    
    Thread::start(http_request, param);
}

// 请求战队简介
void HttpConnection::RequestTeamIntroduce(int teamId, TeamIntroduceListener* listener){}

// 请求贡献榜
void HttpConnection::RequestConsumeRankList(int teamId, ConsumeRankListener* listener){
//    char curl[512];
//    sprintf(curl,"http://testphp.99ducaijing.cn/api.php?s=rankinglist/getWeeklyChart&teacherid=%d",teamId);
//    HttpThreadParam* param = new HttpThreadParam();
//    strcpy(param->url, curl);
//    param->parser = parse_consumerank;
//    param->http_listener = listener;
//    Thread::start(http_request, param);
    std::vector<ConsumeRank> info;
    for (int i=0; i<10; i++) {
        ConsumeRank rank;
        rank.set_username("大中大");
        rank.set_headid(1);
        rank.set_consume((i+1)*11);
        info.push_back(rank);
    }
    listener->onResponse(info);
}

// 提问
void HttpConnection::PostAskQuestion(int teamId, string stock, string question, AskQuestionListener* listener){
    
}


// 请求系统消息
void HttpConnection::RequestSystemMessage(int startId, int count, SystemMessageListener* listener)
{
    vector<SystemMessage> list;
    for ( int i = startId; i < startId + count; i++ )
    {
        SystemMessage info;
        info.set_id(i);
        info.set_publishtime("2016.4.19 12:20");
        info.set_title("系统消息：");
        info.set_content("系统维护，请注意。用于测试的一段长文,用于测试的一段长文用于测试的一段长文用于测试的一段长文用于测试的一段长文用于测试的一段长文用于测试的一段长文用于测试的一段长文用于测试的一段长文");
        list.push_back(info);
    }
    listener->onResponse(list);
}

// 请求问题回复
void HttpConnection::RequestQuestionAnswer(int startId, int count, QuestionAnswerListener* listener, bool isTeamer)
{
    vector<QuestionAnswer> list;
    for ( int i = startId; i < startId + count; i++ )
    {
        QuestionAnswer info;
        info.set_id(i);
        info.set_answerauthorid("personal_user_head");
        info.set_answerauthorid("80060");
        info.set_answerauthorname("牛出没");
        info.set_answercontent("测试数据:这里是回答内容!这里是回答内容!这里是回答内容!这里是回答内容这里是回答内容这里是回答内容");
        info.set_answertime("2016.4.19 12:20");
        info.set_askauthorname("张三");
        info.set_askcontent("老师，这个票怎么样");
        list.push_back(info);
    }
    listener->onResponse(list);
}

// 请求评论回复
void HttpConnection::RequestMailReply(int startId, int count, MailReplyListener* listener)
{
    vector<MailReply> list;
    for ( int i = startId; i < startId + count; i++ )
    {
        MailReply info;
        info.set_id(i);
        info.set_viewpointid(1);
//        info.set_answerauthoricon("personal_user_head");
        info.set_answerauthorid("80060");
        info.set_answerauthorname("牛出没");
        info.set_answercontent("是啊，真不错。这里是回答内容这里是回答内容这里是回答内容这里是回答内容");
        info.set_answertime("201604191220");
        info.set_askauthorname("李四");
        info.set_askcontent("很好的观点，我觉得不错");
        list.push_back(info);
    }
    listener->onResponse(list);
}

// 请求私人定制
void HttpConnection::RequestPrivateServiceSummary(int startId, int count, PrivateServiceSummaryListener* listener)
{
    vector<PrivateServiceSummary> list;
    for ( int i = startId; i < startId + count; i++ )
    {
        PrivateServiceSummary info;
        info.set_id(i);
        info.set_publishtime("2016.4.19 12:20");
        info.set_title("互联网+股票池");
        info.set_summary("今日净值下跌今日净值下跌今日净值下跌今日净值下跌今日净值下跌今日净值下跌今日净值下跌今日净值下跌");
        info.set_teamname("三刀流");
        list.push_back(info);
    }
    listener->onResponse(list);
}

// 请求未读数
void HttpConnection::RequestUnreadCount(UnreadListener* listener)
{
    Unread info;
    info.set_total(12);
    info.set_system(2);
    info.set_answer(2);
    info.set_reply(7);
    info.set_privateservice(1);
    listener->onResponse(info);
}

// 请求问题回复--未回回答的（PC端接口）
void HttpConnection::RequestQuestionUnAnswer(int startId, int count, QuestionAnswerListener* listener, bool isTeamer)
{
    
}

// 请求评论回复--发出的评论（PC端接口）
void HttpConnection::RequestMailSendReply(int startId, int count, MailReplyListener* listener)
{
    
}

// 讲师团队回答提问（PC端接口）
void HttpConnection::PostAnswer(int questionId, string content, HttpListener* listener)
{
    
}

void HttpConnection::RequestHomePage(HomePageListener* listener)//首页列表数据
{
    
}

void HttpConnection::RequestFollowTeacher(FollowTeacherListener* listener)//关注的讲师
{
//    std::string url = "http://hall.99ducaijing.cn:8081/mobile/text_rooms.php";
//    
//    HttpThreadParam* param = new HttpThreadParam();
//    strcpy(param->url, url.c_str());
//    param->parser = parse_followteacherlist;
//    param->http_listener = listener;
//    
//    RequestParamter& request = get_request_param();
//    param->request = &request;
//    
//    request["act"] = "follow";
//    request["userid"] = get_user_id();
//    request["client"] = get_client_type();
//    
//    Thread::start(http_request, param);
}

void HttpConnection::RequestFootPrint(FootPrintListener* listener)//足迹url
{
//    std::string url = "http://hall.99ducaijing.cn:8081/roomdata/room.php";
//
//    HttpThreadParam* param = new HttpThreadParam();
//    strcpy(param->url, url.c_str());
//    param->parser = parse_footprintlist;
//    param->http_listener = listener;
//    
//    RequestParamter& request = get_request_param();
//    param->request = &request;
//    
//    request["act"] = "history";
//    request["type"] = "footprint";
//    request["userid"] = get_user_id();
//    request["client"] = get_client_type();
//    
//    Thread::start(http_request, param);
}

void HttpConnection::RequestCollection(CollectionListener* listener)////收藏url
{
//    std::string url = "http://hall.99ducaijing.cn:8081/roomdata/room.php";
//    
//    HttpThreadParam* param = new HttpThreadParam();
//    strcpy(param->url, url.c_str());
//    param->parser = parse_collectionlist;
//    param->http_listener = listener;
//    
//    RequestParamter& request = get_request_param();
//    param->request = &request;
//    
//    request["act"] = "history";
//    request["type"] = "collent";
//    request["userid"] = get_user_id();
//    request["client"] = get_client_type();
//    
//    Thread::start(http_request, param);
}

void HttpConnection::RequestBanner(BannerListener* listener)////获取Banner
{
    
}

/******************************解析json******************************/
/*
void parse_homepage(char* json, HttpListener* listener)
{
    HomePageListener* homepage_listener = (HomePageListener*)listener;
    
    std::string strJson = json;
    
    JsonValue value;
    JsonReader reader;
    
    int size_ = 0;
    int i = 0;
    
    std::vector<HomePageVideoroomItem> vec_videoroom;
    std::vector<HomePageTextroomItem> vec_textroom;
    std::vector<HomePageViewpointItem> vec_viewpoint;
    
    try
    {
        // 解析逻辑
        if (reader.parse(strJson, value))
        {
            JsonValue& videoroom = value["videoroom"];
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
            
            JsonValue& textroom = value["textroom"];
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
            
            JsonValue& viewpoint = value["viewpoint"];
            if(!textroom.isNull())
            {
                size_ = textroom.size();
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
            
            homepage_listener->onResponse(vec_videoroom, vec_textroom, vec_viewpoint);
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
            JsonValue Collection = value["arr"];
            
            size_ = Collection["Collent"].size();
            vec_collect.clear();
            for(i = 0; i < size_; i++)
            {
                CollectItem collect;
                
                collect.set_nvcbid(Collection["Collent"][i]["nvcbid"].asString());
                collect.set_cname(Collection["Collent"][i]["cname"].asString());
                collect.set_password(Collection["Collent"][i]["password"].asString());
                collect.set_croompic(Collection["Collent"][i]["croompic"].asString());
                collect.set_ncount(Collection["Collent"][i]["ncount"].asString());
                collect.set_cgateaddr(Collection["Collent"][i]["cgateaddr"].asString());
                collect.set_ntype(Collection["Collent"][i]["ntype"].asString());
                
                vec_collect.push_back(collect);
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
    catch ( std::exception& ex)
    {
        banner_listener->OnError(PERR_JSON_PARSE_ERROR);
    }
}
//请求
 
//首页列表数据
void HttpConnection::RequestHomePage(std::string devType, HomePageListener* listener)
{
    std::string url = "http://hall.99ducaijing.cn:8081/mobile/index.php?client=";
    url += devType;
    
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_homepage;
    
    param->http_listener = listener;
    
    Thread::start(http_request, param);
    
}

//关注的讲师
void HttpConnection::RequestFollowTeacher(int userId, std::string devType, FollowTeacherListener* listener)
{
    std::string url = "http://hall.99ducaijing.cn:8081/mobile/text_rooms.php?act=follow&userid=";
    url += userId;
    url += "&client=";
    url += devType;
    
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_followteacherlist;
    param->http_listener = listener;
    
    Thread::start(http_request, param);
}

//足迹url
void HttpConnection::RequestFootPrint(int userId, std::string devType, FootPrintListener* listener)
{
    std::string url = "http://hall.99ducaijing.cn:8081/roomdata/room.php?act=history&type=footprint&userid=";
    url += userId;
    url += "&client=";
    url += devType;
    
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_footprintlist;
    param->http_listener = listener;
    
    Thread::start(http_request, param);
}

//收藏url
void HttpConnection::RequestCollection(int userId, std::string devType, CollectionListener* listener)
{
    std::string url = "http://hall.99ducaijing.cn:8081/roomdata/room.php?act=history&type=collent&userid=";
    url += userId;
    url += "&client=";
    url += devType;
    
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_collectionlist;
    param->http_listener = listener;
    
    Thread::start(http_request, param);
}

//获取Banner
void HttpConnection::RequestBanner(std::string devType, BannerListener* listener)
{
    std::string url = "http://admin.99ducaijing.com/index.php?m=Api&c=Banner&client=";
    url += devType;
    
    HttpThreadParam* param = new HttpThreadParam();
    strcpy(param->url, url.c_str());
    param->parser = parse_bannerlist;
    param->http_listener = listener;
    
    Thread::start(http_request, param);
}

*/

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
                            detail.set_publishtime(data_item["publishtime"].asString());
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
                            viewpoint.set_publishtime(data_item["publishtime"].asString());
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
                            
                            std::vector<PrivateServiceSummary> ss_list;
                            for(j = 0; j < size1_; j++)
                            {
                                PrivateServiceSummary ss;
                                
                                JsonValue& list_item = data_item["list"][j];
                                ss.set_id(atoi(list_item["psid"].asString().c_str()));
                                ss.set_title(list_item["title"].asString());
                                ss.set_summary(list_item["summary"].asString());
                                ss.set_publishtime(list_item["publishtime"].asString());
                                
                                ss_list.push_back(ss);
                            }
                            
                            pack.set_summaryList(ss_list);
                            
                            summary.push_back(pack);
                        }
                        
                        summary_listener->onResponse(summary, 0);
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
        // Ω‚Œˆ¬ﬂº≠
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