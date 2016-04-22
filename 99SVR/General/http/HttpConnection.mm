#include "HttpConnection.h"
#import "UserInfo.h"

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
        summary.set_authoricon("personal_user_head");
        char cBuf[10]={0};
        sprintf(cBuf,"%d",80000+i);
        summary.set_authorid(cBuf);
        summary.set_authorname("第九");
        summary.set_content("这是一段用来测试的文字.....需要很长很长很长");
        summary.set_viewpointid(i+1);
        summary.set_replycount(0);
        summary.set_publishtime("201601091223");
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
void HttpConnection::PostReply(int viewpointId, int parentReplyId, int authorId, char* content, PostReplyListener* listener){

}

// 请求操盘列表-日收益排序
void HttpConnection::RequestOperateStockProfitOrderByDay(int teamId, int startId, int count, OperateStockProfitListener* listener){
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
    listener->onResponse(day);
}
// 请求操盘列表-月收益排序
void HttpConnection::RequestOperateStockProfitOrderByMonth(int teamId, int startId, int count, OperateStockProfitListener* listener)
{
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
    listener->onResponse(day);
}
// 请求操盘列表-总收益排序
void HttpConnection::RequestOperateStockProfitOrderByTotal(int teamId, int startId, int count, OperateStockProfitListener* listener)
{
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
    listener->onResponse(profit,data, trans,stocks);
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
void HttpConnection::RequestOperateStockTransaction(int operateId, OperateStockTransactionListener* listener){
    
    std::vector<OperateStockTransaction>trans;
    
    for (int i=0; i!=10; i++) {
        
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
        info.set_content("系统维护，请注意。");
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
        info.set_answerauthoricon("");
        info.set_answerauthorid("80060");
        info.set_answerauthorname("牛出没");
        info.set_answercontent("这里是回答内容这里是回答内容这里是回答内容这里是回答内容");
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
        info.set_answerauthoricon("");
        info.set_answerauthorid("80060");
        info.set_answerauthorname("牛出没");
        info.set_answercontent("是啊，真不错。这里是回答内容这里是回答内容这里是回答内容这里是回答内容");
        info.set_answertime("2016.4.19 12:20");
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

void HttpConnection::RequestHomePage(std::string devType, HomePageListener* listener)//首页列表数据
{
    
}

void HttpConnection::RequestFollowTeacher(int userId, std::string devType, FollowTeacherListener* listener)//关注的讲师
{
    
}

void HttpConnection::RequestFootPrint(int userId, std::string devType, FootPrintListener* listener)//足迹url
{
    
}

void HttpConnection::RequestCollection(int userId, std::string devType, CollectionListener* listener)////收藏url
{
    
}

void HttpConnection::RequestBanner(std::string url, BannerListener* listener)////获取Banner
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

