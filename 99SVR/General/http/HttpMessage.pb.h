#ifndef __HTTP_MESSAGE_H__
#define __HTTP_MESSAGE_H__



#include <string>
#include "Log.h"
#include "http_cmd_vchat.h"
using std::string;


class Splash
{
    
private:
    
    string	_imageurl;
    string	_text;
    string	_url;
    uint64	_startime;
    uint64	_endtime;
    
    
public:
    
    inline string& imageurl() { return _imageurl; } const
    
    inline void set_imageurl(const string& value) { _imageurl = value; }
    
    inline string& text() { return _text; } const
    
    inline void set_text(const string& value) { _text = value; }
    
    inline string& url() { return _url; } const
    
    inline void set_url(const string& value) { _url = value; }
    
    inline uint64 startime() { return _startime; } const
    
    inline void set_startime(const uint64 value) { _startime = value; }
    
    inline uint64 endtime() { return _endtime; } const
    
    inline void set_endtime(const uint64 value) { _endtime = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDSplash); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDSplash* cmd = (protocol::tag_CMDSplash*) data;
        strcpy(cmd->imageUrl, _imageurl.c_str());
        strcpy(cmd->text, _text.c_str());
        strcpy(cmd->url, _url.c_str());
        cmd->starTime = _startime;
        cmd->endTime = _endtime;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDSplash* cmd = (protocol::tag_CMDSplash*) data;
        _imageurl = cmd->imageUrl;
        _text = cmd->text;
        _url = cmd->url;
        _startime = cmd->starTime;
        _endtime = cmd->endTime;
    }
    
    void Log()
    {
        LOG("--------Receive message: Splash---------");
        LOG("imageurl = %s", _imageurl.c_str());
        LOG("text = %s", _text.c_str());
        LOG("url = %s", _url.c_str());
        LOG("startime = %lld", _startime);
        LOG("endtime = %lld", _endtime);
    }
    
};


class Team
{
    
private:
    
    string	_teamid;
    string	_teamname;
    string	_teamicon;
    uint32	_onlineusercount;
    uint32	_locked;
    
    
public:
    
    inline string& teamid() { return _teamid; } const
    
    inline void set_teamid(const string& value) { _teamid = value; }
    
    inline string& teamname() { return _teamname; } const
    
    inline void set_teamname(const string& value) { _teamname = value; }
    
    inline string& teamicon() { return _teamicon; } const
    
    inline void set_teamicon(const string& value) { _teamicon = value; }
    
    inline uint32 onlineusercount() { return _onlineusercount; } const
    
    inline void set_onlineusercount(const uint32 value) { _onlineusercount = value; }
    
    inline uint32 locked() { return _locked; } const
    
    inline void set_locked(const uint32 value) { _locked = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDTeam); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDTeam* cmd = (protocol::tag_CMDTeam*) data;
        strcpy(cmd->teamId, _teamid.c_str());
        strcpy(cmd->teamName, _teamname.c_str());
        strcpy(cmd->teamIcon, _teamicon.c_str());
        cmd->onlineUserCount = _onlineusercount;
        cmd->locked = _locked;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDTeam* cmd = (protocol::tag_CMDTeam*) data;
        _teamid = cmd->teamId;
        _teamname = cmd->teamName;
        _teamicon = cmd->teamIcon;
        _onlineusercount = cmd->onlineUserCount;
        _locked = cmd->locked;
    }
    
    void Log()
    {
        LOG("--------Receive message: Team---------");
        LOG("teamid = %s", _teamid.c_str());
        LOG("teamname = %s", _teamname.c_str());
        LOG("teamicon = %s", _teamicon.c_str());
        LOG("onlineusercount = %d", _onlineusercount);
        LOG("locked = %d", _locked);
    }
    
};


class ViewpointSummary
{
    
private:
    
    string	_authorid;
    string	_authorname;
    string	_authoricon;
    uint32	_viewpointid;
    string	_publishtime;
    string	_content;
    uint32	_replycount;
    uint32	_giftcount;
    
    
public:
    
    inline string& authorid() { return _authorid; } const
    
    inline void set_authorid(const string& value) { _authorid = value; }
    
    inline string& authorname() { return _authorname; } const
    
    inline void set_authorname(const string& value) { _authorname = value; }
    
    inline string& authoricon() { return _authoricon; } const
    
    inline void set_authoricon(const string& value) { _authoricon = value; }
    
    inline uint32 viewpointid() { return _viewpointid; } const
    
    inline void set_viewpointid(const uint32 value) { _viewpointid = value; }
    
    inline string& publishtime() { return _publishtime; } const
    
    inline void set_publishtime(const string& value) { _publishtime = value; }
    
    inline string& content() { return _content; } const
    
    inline void set_content(const string& value) { _content = value; }
    
    inline uint32 replycount() { return _replycount; } const
    
    inline void set_replycount(const uint32 value) { _replycount = value; }
    
    inline uint32 giftcount() { return _giftcount; } const
    
    inline void set_giftcount(const uint32 value) { _giftcount = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDViewpointSummary); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDViewpointSummary* cmd = (protocol::tag_CMDViewpointSummary*) data;
        strcpy(cmd->authorId, _authorid.c_str());
        strcpy(cmd->authorName, _authorname.c_str());
        strcpy(cmd->authorIcon, _authoricon.c_str());
        cmd->viewpointId = _viewpointid;
        strcpy(cmd->publishTime, _publishtime.c_str());
        strcpy(cmd->content, _content.c_str());
        cmd->replyCount = _replycount;
        cmd->giftCount = _giftcount;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDViewpointSummary* cmd = (protocol::tag_CMDViewpointSummary*) data;
        _authorid = cmd->authorId;
        _authorname = cmd->authorName;
        _authoricon = cmd->authorIcon;
        _viewpointid = cmd->viewpointId;
        _publishtime = cmd->publishTime;
        _content = cmd->content;
        _replycount = cmd->replyCount;
        _giftcount = cmd->giftCount;
    }
    
    void Log()
    {
        LOG("--------Receive message: ViewpointSummary---------");
        LOG("authorid = %s", _authorid.c_str());
        LOG("authorname = %s", _authorname.c_str());
        LOG("authoricon = %s", _authoricon.c_str());
        LOG("viewpointid = %d", _viewpointid);
        LOG("publishtime = %s", _publishtime.c_str());
        LOG("content = %s", _content.c_str());
        LOG("replycount = %d", _replycount);
        LOG("giftcount = %d", _giftcount);
    }
    
};


class ViewpointDetail
{
    
private:
    
    string	_authorid;
    string	_authorname;
    string	_authoricon;
    uint32	_viewpointid;
    string	_publishtime;
    string	_content;
    uint32	_replycount;
    uint32	_giftcount;
    
    
public:
    
    inline string& authorid() { return _authorid; } const
    
    inline void set_authorid(const string& value) { _authorid = value; }
    
    inline string& authorname() { return _authorname; } const
    
    inline void set_authorname(const string& value) { _authorname = value; }
    
    inline string& authoricon() { return _authoricon; } const
    
    inline void set_authoricon(const string& value) { _authoricon = value; }
    
    inline uint32 viewpointid() { return _viewpointid; } const
    
    inline void set_viewpointid(const uint32 value) { _viewpointid = value; }
    
    inline string& publishtime() { return _publishtime; } const
    
    inline void set_publishtime(const string& value) { _publishtime = value; }
    
    inline string& content() { return _content; } const
    
    inline void set_content(const string& value) { _content = value; }
    
    inline uint32 replycount() { return _replycount; } const
    
    inline void set_replycount(const uint32 value) { _replycount = value; }
    
    inline uint32 giftcount() { return _giftcount; } const
    
    inline void set_giftcount(const uint32 value) { _giftcount = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDViewpointDetail); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDViewpointDetail* cmd = (protocol::tag_CMDViewpointDetail*) data;
        strcpy(cmd->authorId, _authorid.c_str());
        strcpy(cmd->authorName, _authorname.c_str());
        strcpy(cmd->authorIcon, _authoricon.c_str());
        cmd->viewpointId = _viewpointid;
        strcpy(cmd->publishTime, _publishtime.c_str());
        strcpy(cmd->content, _content.c_str());
        cmd->replyCount = _replycount;
        cmd->giftCount = _giftcount;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDViewpointDetail* cmd = (protocol::tag_CMDViewpointDetail*) data;
        _authorid = cmd->authorId;
        _authorname = cmd->authorName;
        _authoricon = cmd->authorIcon;
        _viewpointid = cmd->viewpointId;
        _publishtime = cmd->publishTime;
        _content = cmd->content;
        _replycount = cmd->replyCount;
        _giftcount = cmd->giftCount;
    }
    
    void Log()
    {
        LOG("--------Receive message: ViewpointDetail---------");
        LOG("authorid = %s", _authorid.c_str());
        LOG("authorname = %s", _authorname.c_str());
        LOG("authoricon = %s", _authoricon.c_str());
        LOG("viewpointid = %d", _viewpointid);
        LOG("publishtime = %s", _publishtime.c_str());
        LOG("content = %s", _content.c_str());
        LOG("replycount = %d", _replycount);
        LOG("giftcount = %d", _giftcount);
    }
    
};


class Reply
{
    
private:
    
    uint32	_replytid;
    uint32	_viewpointid;
    uint32	_parentreplyid;
    string	_authorid;
    string	_authorname;
    string	_authoricon;
    string	_fromauthorname;
    string	_fromauthoricon;
    string	_publishtime;
    string	_content;
    
    
public:
    
    inline uint32 replytid() { return _replytid; } const
    
    inline void set_replytid(const uint32 value) { _replytid = value; }
    
    inline uint32 viewpointid() { return _viewpointid; } const
    
    inline void set_viewpointid(const uint32 value) { _viewpointid = value; }
    
    inline uint32 parentreplyid() { return _parentreplyid; } const
    
    inline void set_parentreplyid(const uint32 value) { _parentreplyid = value; }
    
    inline string& authorid() { return _authorid; } const
    
    inline void set_authorid(const string& value) { _authorid = value; }
    
    inline string& authorname() { return _authorname; } const
    
    inline void set_authorname(const string& value) { _authorname = value; }
    
    inline string& authoricon() { return _authoricon; } const
    
    inline void set_authoricon(const string& value) { _authoricon = value; }
    
    inline string& fromauthorname() { return _fromauthorname; } const
    
    inline void set_fromauthorname(const string& value) { _fromauthorname = value; }
    
    inline string& fromauthoricon() { return _fromauthoricon; } const
    
    inline void set_fromauthoricon(const string& value) { _fromauthoricon = value; }
    
    inline string& publishtime() { return _publishtime; } const
    
    inline void set_publishtime(const string& value) { _publishtime = value; }
    
    inline string& content() { return _content; } const
    
    inline void set_content(const string& value) { _content = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDReply); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDReply* cmd = (protocol::tag_CMDReply*) data;
        cmd->replytId = _replytid;
        cmd->viewpointId = _viewpointid;
        cmd->parentReplyId = _parentreplyid;
        strcpy(cmd->authorId, _authorid.c_str());
        strcpy(cmd->authorName, _authorname.c_str());
        strcpy(cmd->authorIcon, _authoricon.c_str());
        strcpy(cmd->fromAuthorName, _fromauthorname.c_str());
        strcpy(cmd->fromAuthorIcon, _fromauthoricon.c_str());
        strcpy(cmd->publishTime, _publishtime.c_str());
        strcpy(cmd->content, _content.c_str());
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDReply* cmd = (protocol::tag_CMDReply*) data;
        _replytid = cmd->replytId;
        _viewpointid = cmd->viewpointId;
        _parentreplyid = cmd->parentReplyId;
        _authorid = cmd->authorId;
        _authorname = cmd->authorName;
        _authoricon = cmd->authorIcon;
        _fromauthorname = cmd->fromAuthorName;
        _fromauthoricon = cmd->fromAuthorIcon;
        _publishtime = cmd->publishTime;
        _content = cmd->content;
    }
    
    void Log()
    {
        LOG("--------Receive message: Reply---------");
        LOG("replytid = %d", _replytid);
        LOG("viewpointid = %d", _viewpointid);
        LOG("parentreplyid = %d", _parentreplyid);
        LOG("authorid = %s", _authorid.c_str());
        LOG("authorname = %s", _authorname.c_str());
        LOG("authoricon = %s", _authoricon.c_str());
        LOG("fromauthorname = %s", _fromauthorname.c_str());
        LOG("fromauthoricon = %s", _fromauthoricon.c_str());
        LOG("publishtime = %s", _publishtime.c_str());
        LOG("content = %s", _content.c_str());
    }
    
};


class OperateStockProfit
{
    
private:
    
    uint32	_operateid;
    string	_teamid;
    string	_teamname;
    string	_teamicon;
    string	_focus;
    float	_goalprofit;
    float	_totalprofit;
    float	_dayprofit;
    float	_monthprofit;
    float	_winrate;
    
    
public:
    
    inline uint32 operateid() { return _operateid; } const
    
    inline void set_operateid(const uint32 value) { _operateid = value; }
    
    inline string& teamid() { return _teamid; } const
    
    inline void set_teamid(const string& value) { _teamid = value; }
    
    inline string& teamname() { return _teamname; } const
    
    inline void set_teamname(const string& value) { _teamname = value; }
    
    inline string& teamicon() { return _teamicon; } const
    
    inline void set_teamicon(const string& value) { _teamicon = value; }
    
    inline string& focus() { return _focus; } const
    
    inline void set_focus(const string& value) { _focus = value; }
    
    inline float goalprofit() { return _goalprofit; } const
    
    inline void set_goalprofit(const float value) { _goalprofit = value; }
    
    inline float totalprofit() { return _totalprofit; } const
    
    inline void set_totalprofit(const float value) { _totalprofit = value; }
    
    inline float dayprofit() { return _dayprofit; } const
    
    inline void set_dayprofit(const float value) { _dayprofit = value; }
    
    inline float monthprofit() { return _monthprofit; } const
    
    inline void set_monthprofit(const float value) { _monthprofit = value; }
    
    inline float winrate() { return _winrate; } const
    
    inline void set_winrate(const float value) { _winrate = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDOperateStockProfit); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDOperateStockProfit* cmd = (protocol::tag_CMDOperateStockProfit*) data;
        cmd->operateId = _operateid;
        strcpy(cmd->teamId, _teamid.c_str());
        strcpy(cmd->teamName, _teamname.c_str());
        strcpy(cmd->teamIcon, _teamicon.c_str());
        strcpy(cmd->focus, _focus.c_str());
        cmd->goalProfit = _goalprofit;
        cmd->totalProfit = _totalprofit;
        cmd->dayProfit = _dayprofit;
        cmd->monthProfit = _monthprofit;
        cmd->winRate = _winrate;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDOperateStockProfit* cmd = (protocol::tag_CMDOperateStockProfit*) data;
        _operateid = cmd->operateId;
        _teamid = cmd->teamId;
        _teamname = cmd->teamName;
        _teamicon = cmd->teamIcon;
        _focus = cmd->focus;
        _goalprofit = cmd->goalProfit;
        _totalprofit = cmd->totalProfit;
        _dayprofit = cmd->dayProfit;
        _monthprofit = cmd->monthProfit;
        _winrate = cmd->winRate;
    }
    
    void Log()
    {
        LOG("--------Receive message: OperateStockProfit---------");
        LOG("operateid = %d", _operateid);
        LOG("teamid = %s", _teamid.c_str());
        LOG("teamname = %s", _teamname.c_str());
        LOG("teamicon = %s", _teamicon.c_str());
        LOG("focus = %s", _focus.c_str());
        LOG("goalprofit = %f", _goalprofit);
        LOG("totalprofit = %f", _totalprofit);
        LOG("dayprofit = %f", _dayprofit);
        LOG("monthprofit = %f", _monthprofit);
        LOG("winrate = %f", _winrate);
    }
    
};


class OperateStockData
{
    
private:
    
    uint32	_operateid;
    
    
public:
    
    inline uint32 operateid() { return _operateid; } const
    
    inline void set_operateid(const uint32 value) { _operateid = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDOperateStockData); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDOperateStockData* cmd = (protocol::tag_CMDOperateStockData*) data;
        cmd->operateId = _operateid;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDOperateStockData* cmd = (protocol::tag_CMDOperateStockData*) data;
        _operateid = cmd->operateId;
    }
    
    void Log()
    {
        LOG("--------Receive message: OperateStockData---------");
        LOG("operateid = %d", _operateid);
    }
    
};


class OperateStockTransaction
{
    
private:
    
    uint32	_operateid;
    string	_buytype;
    string	_stockid;
    string	_stockname;
    float	_price;
    uint32	_count;
    float	_money;
    string	_time;
    
    
public:
    
    inline uint32 operateid() { return _operateid; } const
    
    inline void set_operateid(const uint32 value) { _operateid = value; }
    
    inline string& buytype() { return _buytype; } const
    
    inline void set_buytype(const string& value) { _buytype = value; }
    
    inline string& stockid() { return _stockid; } const
    
    inline void set_stockid(const string& value) { _stockid = value; }
    
    inline string& stockname() { return _stockname; } const
    
    inline void set_stockname(const string& value) { _stockname = value; }
    
    inline float price() { return _price; } const
    
    inline void set_price(const float value) { _price = value; }
    
    inline uint32 count() { return _count; } const
    
    inline void set_count(const uint32 value) { _count = value; }
    
    inline float money() { return _money; } const
    
    inline void set_money(const float value) { _money = value; }
    
    inline string& time() { return _time; } const
    
    inline void set_time(const string& value) { _time = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDOperateStockTransaction); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDOperateStockTransaction* cmd = (protocol::tag_CMDOperateStockTransaction*) data;
        cmd->operateId = _operateid;
        strcpy(cmd->buytype, _buytype.c_str());
        strcpy(cmd->stockId, _stockid.c_str());
        strcpy(cmd->stockName, _stockname.c_str());
        cmd->price = _price;
        cmd->count = _count;
        cmd->money = _money;
        strcpy(cmd->time, _time.c_str());
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDOperateStockTransaction* cmd = (protocol::tag_CMDOperateStockTransaction*) data;
        _operateid = cmd->operateId;
        _buytype = cmd->buytype;
        _stockid = cmd->stockId;
        _stockname = cmd->stockName;
        _price = cmd->price;
        _count = cmd->count;
        _money = cmd->money;
        _time = cmd->time;
    }
    
    void Log()
    {
        LOG("--------Receive message: OperateStockTransaction---------");
        LOG("operateid = %d", _operateid);
        LOG("buytype = %s", _buytype.c_str());
        LOG("stockid = %s", _stockid.c_str());
        LOG("stockname = %s", _stockname.c_str());
        LOG("price = %f", _price);
        LOG("count = %d", _count);
        LOG("money = %f", _money);
        LOG("time = %s", _time.c_str());
    }
    
};


class OperateStocks
{
    
private:
    
    uint32	_operateid;
    string	_stockid;
    string	_stockname;
    uint32	_count;
    float	_cost;
    float	_currprice;
    float	_profitrate;
    float	_profitmoney;
    
    
public:
    
    inline uint32 operateid() { return _operateid; } const
    
    inline void set_operateid(const uint32 value) { _operateid = value; }
    
    inline string& stockid() { return _stockid; } const
    
    inline void set_stockid(const string& value) { _stockid = value; }
    
    inline string& stockname() { return _stockname; } const
    
    inline void set_stockname(const string& value) { _stockname = value; }
    
    inline uint32 count() { return _count; } const
    
    inline void set_count(const uint32 value) { _count = value; }
    
    inline float cost() { return _cost; } const
    
    inline void set_cost(const float value) { _cost = value; }
    
    inline float currprice() { return _currprice; } const
    
    inline void set_currprice(const float value) { _currprice = value; }
    
    inline float profitrate() { return _profitrate; } const
    
    inline void set_profitrate(const float value) { _profitrate = value; }
    
    inline float profitmoney() { return _profitmoney; } const
    
    inline void set_profitmoney(const float value) { _profitmoney = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDOperateStocks); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDOperateStocks* cmd = (protocol::tag_CMDOperateStocks*) data;
        cmd->operateId = _operateid;
        strcpy(cmd->stockId, _stockid.c_str());
        strcpy(cmd->stockName, _stockname.c_str());
        cmd->count = _count;
        cmd->cost = _cost;
        cmd->currPrice = _currprice;
        cmd->profitRate = _profitrate;
        cmd->ProfitMoney = _profitmoney;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDOperateStocks* cmd = (protocol::tag_CMDOperateStocks*) data;
        _operateid = cmd->operateId;
        _stockid = cmd->stockId;
        _stockname = cmd->stockName;
        _count = cmd->count;
        _cost = cmd->cost;
        _currprice = cmd->currPrice;
        _profitrate = cmd->profitRate;
        _profitmoney = cmd->ProfitMoney;
    }
    
    void Log()
    {
        LOG("--------Receive message: OperateStocks---------");
        LOG("operateid = %d", _operateid);
        LOG("stockid = %s", _stockid.c_str());
        LOG("stockname = %s", _stockname.c_str());
        LOG("count = %d", _count);
        LOG("cost = %f", _cost);
        LOG("currprice = %f", _currprice);
        LOG("profitrate = %f", _profitrate);
        LOG("profitmoney = %f", _profitmoney);
    }
    
};


class MyPrivateService
{
    
private:
    
    string	_teamid;
    string	_teamname;
    string	_teamicon;
    uint32	_levelid;
    string	_levelname;
    string	_expirationdate;
    
    
public:
    
    inline string& teamid() { return _teamid; } const
    
    inline void set_teamid(const string& value) { _teamid = value; }
    
    inline string& teamname() { return _teamname; } const
    
    inline void set_teamname(const string& value) { _teamname = value; }
    
    inline string& teamicon() { return _teamicon; } const
    
    inline void set_teamicon(const string& value) { _teamicon = value; }
    
    inline uint32 levelid() { return _levelid; } const
    
    inline void set_levelid(const uint32 value) { _levelid = value; }
    
    inline string& levelname() { return _levelname; } const
    
    inline void set_levelname(const string& value) { _levelname = value; }
    
    inline string& expirationdate() { return _expirationdate; } const
    
    inline void set_expirationdate(const string& value) { _expirationdate = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDMyPrivateService); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDMyPrivateService* cmd = (protocol::tag_CMDMyPrivateService*) data;
        strcpy(cmd->teamId, _teamid.c_str());
        strcpy(cmd->teamName, _teamname.c_str());
        strcpy(cmd->teamIcon, _teamicon.c_str());
        cmd->levelId = _levelid;
        strcpy(cmd->levelName, _levelname.c_str());
        strcpy(cmd->expirationDate, _expirationdate.c_str());
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDMyPrivateService* cmd = (protocol::tag_CMDMyPrivateService*) data;
        _teamid = cmd->teamId;
        _teamname = cmd->teamName;
        _teamicon = cmd->teamIcon;
        _levelid = cmd->levelId;
        _levelname = cmd->levelName;
        _expirationdate = cmd->expirationDate;
    }
    
    void Log()
    {
        LOG("--------Receive message: MyPrivateService---------");
        LOG("teamid = %s", _teamid.c_str());
        LOG("teamname = %s", _teamname.c_str());
        LOG("teamicon = %s", _teamicon.c_str());
        LOG("levelid = %d", _levelid);
        LOG("levelname = %s", _levelname.c_str());
        LOG("expirationdate = %s", _expirationdate.c_str());
    }
    
};


class WhatIsPrivateService
{
    
private:
    
    string	_content;
    
    
public:
    
    inline string& content() { return _content; } const
    
    inline void set_content(const string& value) { _content = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDWhatIsPrivateService); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDWhatIsPrivateService* cmd = (protocol::tag_CMDWhatIsPrivateService*) data;
        strcpy(cmd->content, _content.c_str());
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDWhatIsPrivateService* cmd = (protocol::tag_CMDWhatIsPrivateService*) data;
        _content = cmd->content;
    }
    
    void Log()
    {
        LOG("--------Receive message: WhatIsPrivateService---------");
        LOG("content = %s", _content.c_str());
    }
    
};


class PrivateServiceLevelDescription
{
    
private:
    
    uint32	_levelid;
    string	_levelname;
    string	_description;
    float	_buyprice;
    float	_updateprice;
    
    
public:
    
    inline uint32 levelid() { return _levelid; } const
    
    inline void set_levelid(const uint32 value) { _levelid = value; }
    
    inline string& levelname() { return _levelname; } const
    
    inline void set_levelname(const string& value) { _levelname = value; }
    
    inline string& description() { return _description; } const
    
    inline void set_description(const string& value) { _description = value; }
    
    inline float buyprice() { return _buyprice; } const
    
    inline void set_buyprice(const float value) { _buyprice = value; }
    
    inline float updateprice() { return _updateprice; } const
    
    inline void set_updateprice(const float value) { _updateprice = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDPrivateServiceLevelDescription); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDPrivateServiceLevelDescription* cmd = (protocol::tag_CMDPrivateServiceLevelDescription*) data;
        cmd->levelId = _levelid;
        strcpy(cmd->levelName, _levelname.c_str());
        strcpy(cmd->description, _description.c_str());
        cmd->buyPrice = _buyprice;
        cmd->updatePrice = _updateprice;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDPrivateServiceLevelDescription* cmd = (protocol::tag_CMDPrivateServiceLevelDescription*) data;
        _levelid = cmd->levelId;
        _levelname = cmd->levelName;
        _description = cmd->description;
        _buyprice = cmd->buyPrice;
        _updateprice = cmd->updatePrice;
    }
    
    void Log()
    {
        LOG("--------Receive message: PrivateServiceLevelDescription---------");
        LOG("levelid = %d", _levelid);
        LOG("levelname = %s", _levelname.c_str());
        LOG("description = %s", _description.c_str());
        LOG("buyprice = %f", _buyprice);
        LOG("updateprice = %f", _updateprice);
    }
    
};


class PrivateServiceSummary
{
    
private:
    
    uint32	_id;
    string	_title;
    string	_summary;
    string	_publishtime;
    string	_teamname;
    
    
public:
    
    inline uint32 id() { return _id; } const
    
    inline void set_id(const uint32 value) { _id = value; }
    
    inline string& title() { return _title; } const
    
    inline void set_title(const string& value) { _title = value; }
    
    inline string& summary() { return _summary; } const
    
    inline void set_summary(const string& value) { _summary = value; }
    
    inline string& publishtime() { return _publishtime; } const
    
    inline void set_publishtime(const string& value) { _publishtime = value; }
    
    inline string& teamname() { return _teamname; } const
    
    inline void set_teamname(const string& value) { _teamname = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDPrivateServiceSummary); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDPrivateServiceSummary* cmd = (protocol::tag_CMDPrivateServiceSummary*) data;
        cmd->id = _id;
        strcpy(cmd->title, _title.c_str());
        strcpy(cmd->summary, _summary.c_str());
        strcpy(cmd->publishTime, _publishtime.c_str());
        strcpy(cmd->teamName, _teamname.c_str());
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDPrivateServiceSummary* cmd = (protocol::tag_CMDPrivateServiceSummary*) data;
        _id = cmd->id;
        _title = cmd->title;
        _summary = cmd->summary;
        _publishtime = cmd->publishTime;
        _teamname = cmd->teamName;
    }
    
    void Log()
    {
        LOG("--------Receive message: PrivateServiceSummary---------");
        LOG("id = %d", _id);
        LOG("title = %s", _title.c_str());
        LOG("summary = %s", _summary.c_str());
        LOG("publishtime = %s", _publishtime.c_str());
        LOG("teamname = %s", _teamname.c_str());
    }
    
};


class PrivateServiceDetail
{
    
private:
    
    string	_title;
    string	_content;
    string	_publishtime;
    string	_videourl;
    string	_videoname;
    string	_attachmenturl;
    string	_attachmentname;
    
    
public:
    
    inline string& title() { return _title; } const
    
    inline void set_title(const string& value) { _title = value; }
    
    inline string& content() { return _content; } const
    
    inline void set_content(const string& value) { _content = value; }
    
    inline string& publishtime() { return _publishtime; } const
    
    inline void set_publishtime(const string& value) { _publishtime = value; }
    
    inline string& videourl() { return _videourl; } const
    
    inline void set_videourl(const string& value) { _videourl = value; }
    
    inline string& videoname() { return _videoname; } const
    
    inline void set_videoname(const string& value) { _videoname = value; }
    
    inline string& attachmenturl() { return _attachmenturl; } const
    
    inline void set_attachmenturl(const string& value) { _attachmenturl = value; }
    
    inline string& attachmentname() { return _attachmentname; } const
    
    inline void set_attachmentname(const string& value) { _attachmentname = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDPrivateServiceDetail); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDPrivateServiceDetail* cmd = (protocol::tag_CMDPrivateServiceDetail*) data;
        strcpy(cmd->title, _title.c_str());
        strcpy(cmd->content, _content.c_str());
        strcpy(cmd->publishTime, _publishtime.c_str());
        strcpy(cmd->videoUrl, _videourl.c_str());
        strcpy(cmd->videoName, _videoname.c_str());
        strcpy(cmd->attachmentUrl, _attachmenturl.c_str());
        strcpy(cmd->attachmentName, _attachmentname.c_str());
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDPrivateServiceDetail* cmd = (protocol::tag_CMDPrivateServiceDetail*) data;
        _title = cmd->title;
        _content = cmd->content;
        _publishtime = cmd->publishTime;
        _videourl = cmd->videoUrl;
        _videoname = cmd->videoName;
        _attachmenturl = cmd->attachmentUrl;
        _attachmentname = cmd->attachmentName;
    }
    
    void Log()
    {
        LOG("--------Receive message: PrivateServiceDetail---------");
        LOG("title = %s", _title.c_str());
        LOG("content = %s", _content.c_str());
        LOG("publishtime = %s", _publishtime.c_str());
        LOG("videourl = %s", _videourl.c_str());
        LOG("videoname = %s", _videoname.c_str());
        LOG("attachmenturl = %s", _attachmenturl.c_str());
        LOG("attachmentname = %s", _attachmentname.c_str());
    }
    
};


class ChargeRule
{
    
private:
    
    float	_originalprice;
    float	_discountprice;
    int32	_coincount;
    
    
public:
    
    inline float originalprice() { return _originalprice; } const
    
    inline void set_originalprice(const float value) { _originalprice = value; }
    
    inline float discountprice() { return _discountprice; } const
    
    inline void set_discountprice(const float value) { _discountprice = value; }
    
    inline int32 coincount() { return _coincount; } const
    
    inline void set_coincount(const int32 value) { _coincount = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDChargeRule); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDChargeRule* cmd = (protocol::tag_CMDChargeRule*) data;
        cmd->originalPrice = _originalprice;
        cmd->discountPrice = _discountprice;
        cmd->coinCount = _coincount;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDChargeRule* cmd = (protocol::tag_CMDChargeRule*) data;
        _originalprice = cmd->originalPrice;
        _discountprice = cmd->discountPrice;
        _coincount = cmd->coinCount;
    }
    
    void Log()
    {
        LOG("--------Receive message: ChargeRule---------");
        LOG("originalprice = %f", _originalprice);
        LOG("discountprice = %f", _discountprice);
        LOG("coincount = %d", _coincount);
    }
    
};


class VideoInfo
{
    
private:
    
    string	_name;
    string	_picurl;
    string	_videourl;
    
    
public:
    
    inline string& name() { return _name; } const
    
    inline void set_name(const string& value) { _name = value; }
    
    inline string& picurl() { return _picurl; } const
    
    inline void set_picurl(const string& value) { _picurl = value; }
    
    inline string& videourl() { return _videourl; } const
    
    inline void set_videourl(const string& value) { _videourl = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDVideoInfo); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDVideoInfo* cmd = (protocol::tag_CMDVideoInfo*) data;
        strcpy(cmd->name, _name.c_str());
        strcpy(cmd->picUrl, _picurl.c_str());
        strcpy(cmd->videoUrl, _videourl.c_str());
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDVideoInfo* cmd = (protocol::tag_CMDVideoInfo*) data;
        _name = cmd->name;
        _picurl = cmd->picUrl;
        _videourl = cmd->videoUrl;
    }
    
    void Log()
    {
        LOG("--------Receive message: VideoInfo---------");
        LOG("name = %s", _name.c_str());
        LOG("picurl = %s", _picurl.c_str());
        LOG("videourl = %s", _videourl.c_str());
    }
    
};


class ConsumeRank
{
    
private:
    
    string	_username;
    int32	_headid;
    float	_consume;
    
    
public:
    
    inline string& username() { return _username; } const
    
    inline void set_username(const string& value) { _username = value; }
    
    inline int32 headid() { return _headid; } const
    
    inline void set_headid(const int32 value) { _headid = value; }
    
    inline float consume() { return _consume; } const
    
    inline void set_consume(const float value) { _consume = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDConsumeRank); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDConsumeRank* cmd = (protocol::tag_CMDConsumeRank*) data;
        strcpy(cmd->userName, _username.c_str());
        cmd->headId = _headid;
        cmd->consume = _consume;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDConsumeRank* cmd = (protocol::tag_CMDConsumeRank*) data;
        _username = cmd->userName;
        _headid = cmd->headId;
        _consume = cmd->consume;
    }
    
    void Log()
    {
        LOG("--------Receive message: ConsumeRank---------");
        LOG("username = %s", _username.c_str());
        LOG("headid = %d", _headid);
        LOG("consume = %f", _consume);
    }
    
};


class SystemMessage
{
    
private:
    
    uint32	_id;
    string	_title;
    string	_content;
    string	_publishtime;
    
    
public:
    
    inline uint32 id() { return _id; } const
    
    inline void set_id(const uint32 value) { _id = value; }
    
    inline string& title() { return _title; } const
    
    inline void set_title(const string& value) { _title = value; }
    
    inline string& content() { return _content; } const
    
    inline void set_content(const string& value) { _content = value; }
    
    inline string& publishtime() { return _publishtime; } const
    
    inline void set_publishtime(const string& value) { _publishtime = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDSystemMessage); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDSystemMessage* cmd = (protocol::tag_CMDSystemMessage*) data;
        cmd->id = _id;
        strcpy(cmd->title, _title.c_str());
        strcpy(cmd->content, _content.c_str());
        strcpy(cmd->publishTime, _publishtime.c_str());
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDSystemMessage* cmd = (protocol::tag_CMDSystemMessage*) data;
        _id = cmd->id;
        _title = cmd->title;
        _content = cmd->content;
        _publishtime = cmd->publishTime;
    }
    
    void Log()
    {
        LOG("--------Receive message: SystemMessage---------");
        LOG("id = %d", _id);
        LOG("title = %s", _title.c_str());
        LOG("content = %s", _content.c_str());
        LOG("publishtime = %s", _publishtime.c_str());
    }
    
};


class QuestionAnswer
{
    
private:
    
    uint32	_id;
    string	_answerauthorid;
    string	_answerauthorname;
    string	_answerauthoricon;
    string	_answertime;
    string	_answercontent;
    string	_askauthorname;
    uint32	_askauthorheadid;
    string	_askstock;
    string	_askcontent;
    string	_asktime;
    uint32	_fromclient;
    
    
public:
    
    inline uint32 id() { return _id; } const
    
    inline void set_id(const uint32 value) { _id = value; }
    
    inline string& answerauthorid() { return _answerauthorid; } const
    
    inline void set_answerauthorid(const string& value) { _answerauthorid = value; }
    
    inline string& answerauthorname() { return _answerauthorname; } const
    
    inline void set_answerauthorname(const string& value) { _answerauthorname = value; }
    
    inline string& answerauthoricon() { return _answerauthoricon; } const
    
    inline void set_answerauthoricon(const string& value) { _answerauthoricon = value; }
    
    inline string& answertime() { return _answertime; } const
    
    inline void set_answertime(const string& value) { _answertime = value; }
    
    inline string& answercontent() { return _answercontent; } const
    
    inline void set_answercontent(const string& value) { _answercontent = value; }
    
    inline string& askauthorname() { return _askauthorname; } const
    
    inline void set_askauthorname(const string& value) { _askauthorname = value; }
    
    inline uint32 askauthorheadid() { return _askauthorheadid; } const
    
    inline void set_askauthorheadid(const uint32 value) { _askauthorheadid = value; }
    
    inline string& askstock() { return _askstock; } const
    
    inline void set_askstock(const string& value) { _askstock = value; }
    
    inline string& askcontent() { return _askcontent; } const
    
    inline void set_askcontent(const string& value) { _askcontent = value; }
    
    inline string& asktime() { return _asktime; } const
    
    inline void set_asktime(const string& value) { _asktime = value; }
    
    inline uint32 fromclient() { return _fromclient; } const
    
    inline void set_fromclient(const uint32 value) { _fromclient = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDQuestionAnswer); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDQuestionAnswer* cmd = (protocol::tag_CMDQuestionAnswer*) data;
        cmd->id = _id;
        strcpy(cmd->answerAuthorId, _answerauthorid.c_str());
        strcpy(cmd->answerAuthorName, _answerauthorname.c_str());
        strcpy(cmd->answerAuthorIcon, _answerauthoricon.c_str());
        strcpy(cmd->answerTime, _answertime.c_str());
        strcpy(cmd->answerContent, _answercontent.c_str());
        strcpy(cmd->askAuthorName, _askauthorname.c_str());
        cmd->askAuthorHeadId = _askauthorheadid;
        strcpy(cmd->askStock, _askstock.c_str());
        strcpy(cmd->askContent, _askcontent.c_str());
        strcpy(cmd->askTime, _asktime.c_str());
        cmd->fromClient = _fromclient;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDQuestionAnswer* cmd = (protocol::tag_CMDQuestionAnswer*) data;
        _id = cmd->id;
        _answerauthorid = cmd->answerAuthorId;
        _answerauthorname = cmd->answerAuthorName;
        _answerauthoricon = cmd->answerAuthorIcon;
        _answertime = cmd->answerTime;
        _answercontent = cmd->answerContent;
        _askauthorname = cmd->askAuthorName;
        _askauthorheadid = cmd->askAuthorHeadId;
        _askstock = cmd->askStock;
        _askcontent = cmd->askContent;
        _asktime = cmd->askTime;
        _fromclient = cmd->fromClient;
    }
    
    void Log()
    {
        LOG("--------Receive message: QuestionAnswer---------");
        LOG("id = %d", _id);
        LOG("answerauthorid = %s", _answerauthorid.c_str());
        LOG("answerauthorname = %s", _answerauthorname.c_str());
        LOG("answerauthoricon = %s", _answerauthoricon.c_str());
        LOG("answertime = %s", _answertime.c_str());
        LOG("answercontent = %s", _answercontent.c_str());
        LOG("askauthorname = %s", _askauthorname.c_str());
        LOG("askauthorheadid = %d", _askauthorheadid);
        LOG("askstock = %s", _askstock.c_str());
        LOG("askcontent = %s", _askcontent.c_str());
        LOG("asktime = %s", _asktime.c_str());
        LOG("fromclient = %d", _fromclient);
    }
    
};


class MailReply
{
    
private:
    
    uint32	_id;
    uint32	_viewpointid;
    string	_title;
    string	_askauthorname;
    uint32	_askauthorheadid;
    string	_askcontent;
    string	_asktime;
    string	_answerauthorid;
    string	_answerauthorname;
    string	_answerauthoricon;
    string	_answertime;
    string	_answercontent;
    uint32	_fromclient;
    
    
public:
    
    inline uint32 id() { return _id; } const
    
    inline void set_id(const uint32 value) { _id = value; }
    
    inline uint32 viewpointid() { return _viewpointid; } const 
    
    inline void set_viewpointid(const uint32 value) { _viewpointid = value; }
    
    inline string& title() { return _title; } const 
    
    inline void set_title(const string& value) { _title = value; }
    
    inline string& askauthorname() { return _askauthorname; } const 
    
    inline void set_askauthorname(const string& value) { _askauthorname = value; }
    
    inline uint32 askauthorheadid() { return _askauthorheadid; } const 
    
    inline void set_askauthorheadid(const uint32 value) { _askauthorheadid = value; }
    
    inline string& askcontent() { return _askcontent; } const 
    
    inline void set_askcontent(const string& value) { _askcontent = value; }
    
    inline string& asktime() { return _asktime; } const 
    
    inline void set_asktime(const string& value) { _asktime = value; }
    
    inline string& answerauthorid() { return _answerauthorid; } const 
    
    inline void set_answerauthorid(const string& value) { _answerauthorid = value; }
    
    inline string& answerauthorname() { return _answerauthorname; } const 
    
    inline void set_answerauthorname(const string& value) { _answerauthorname = value; }
    
    inline string& answerauthoricon() { return _answerauthoricon; } const 
    
    inline void set_answerauthoricon(const string& value) { _answerauthoricon = value; }
    
    inline string& answertime() { return _answertime; } const 
    
    inline void set_answertime(const string& value) { _answertime = value; }
    
    inline string& answercontent() { return _answercontent; } const 
    
    inline void set_answercontent(const string& value) { _answercontent = value; }
    
    inline uint32 fromclient() { return _fromclient; } const 
    
    inline void set_fromclient(const uint32 value) { _fromclient = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDMailReply); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDMailReply* cmd = (protocol::tag_CMDMailReply*) data;
        cmd->id = _id;
        cmd->viewpointId = _viewpointid;
        strcpy(cmd->title, _title.c_str());
        strcpy(cmd->askAuthorName, _askauthorname.c_str());
        cmd->askAuthorHeadId = _askauthorheadid;
        strcpy(cmd->askContent, _askcontent.c_str());
        strcpy(cmd->askTime, _asktime.c_str());
        strcpy(cmd->answerAuthorId, _answerauthorid.c_str());
        strcpy(cmd->answerAuthorName, _answerauthorname.c_str());
        strcpy(cmd->answerAuthorIcon, _answerauthoricon.c_str());
        strcpy(cmd->answerTime, _answertime.c_str());
        strcpy(cmd->answerContent, _answercontent.c_str());
        cmd->fromClient = _fromclient;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDMailReply* cmd = (protocol::tag_CMDMailReply*) data;
        _id = cmd->id;
        _viewpointid = cmd->viewpointId;
        _title = cmd->title;
        _askauthorname = cmd->askAuthorName;
        _askauthorheadid = cmd->askAuthorHeadId;
        _askcontent = cmd->askContent;
        _asktime = cmd->askTime;
        _answerauthorid = cmd->answerAuthorId;
        _answerauthorname = cmd->answerAuthorName;
        _answerauthoricon = cmd->answerAuthorIcon;
        _answertime = cmd->answerTime;
        _answercontent = cmd->answerContent;
        _fromclient = cmd->fromClient;
    }
    
    void Log()
    {
        LOG("--------Receive message: MailReply---------");
        LOG("id = %d", _id);
        LOG("viewpointid = %d", _viewpointid);
        LOG("title = %s", _title.c_str());
        LOG("askauthorname = %s", _askauthorname.c_str());
        LOG("askauthorheadid = %d", _askauthorheadid);
        LOG("askcontent = %s", _askcontent.c_str());
        LOG("asktime = %s", _asktime.c_str());
        LOG("answerauthorid = %s", _answerauthorid.c_str());
        LOG("answerauthorname = %s", _answerauthorname.c_str());
        LOG("answerauthoricon = %s", _answerauthoricon.c_str());
        LOG("answertime = %s", _answertime.c_str());
        LOG("answercontent = %s", _answercontent.c_str());
        LOG("fromclient = %d", _fromclient);
    }
    
};


class Unread
{
    
private:
    
    uint32	_total;
    uint32	_system;
    uint32	_answer;
    uint32	_reply;
    uint32	_privateservice;
    
    
public:
    
    inline uint32 total() { return _total; } const 
    
    inline void set_total(const uint32 value) { _total = value; }
    
    inline uint32 system() { return _system; } const 
    
    inline void set_system(const uint32 value) { _system = value; }
    
    inline uint32 answer() { return _answer; } const 
    
    inline void set_answer(const uint32 value) { _answer = value; }
    
    inline uint32 reply() { return _reply; } const 
    
    inline void set_reply(const uint32 value) { _reply = value; }
    
    inline uint32 privateservice() { return _privateservice; } const 
    
    inline void set_privateservice(const uint32 value) { _privateservice = value; }
    
    
    int ByteSize() { return sizeof(protocol::tag_CMDUnread); }
    
    void SerializeToArray(void* data, int size)
    {
        protocol::tag_CMDUnread* cmd = (protocol::tag_CMDUnread*) data;
        cmd->total = _total;
        cmd->system = _system;
        cmd->answer = _answer;
        cmd->reply = _reply;
        cmd->privateService = _privateservice;
    }
    
    void ParseFromArray(void* data, int size)
    {
        protocol::tag_CMDUnread* cmd = (protocol::tag_CMDUnread*) data;
        _total = cmd->total;
        _system = cmd->system;
        _answer = cmd->answer;
        _reply = cmd->reply;
        _privateservice = cmd->privateService;
    }
    
    void Log()
    {
        LOG("--------Receive message: Unread---------");
        LOG("total = %d", _total);
        LOG("system = %d", _system);
        LOG("answer = %d", _answer);
        LOG("reply = %d", _reply);
        LOG("privateservice = %d", _privateservice);
    }
    
};







#endif
