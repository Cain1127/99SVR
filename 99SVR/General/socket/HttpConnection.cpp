/*
*我的：注册
*邮箱 总的未读数 PC端接口
*战队简介
*缓存
*/
#include "stdafx.h"
#include "HttpConnection.h"
#include "LoginConnection.h"
#include "StatisticReport.h"
#include "Http.h"
#include "http_common.h"
#include "Thread.h"
#include "Util.h"
#include "proto_err.h"
#include <cstring>


static int g_authorId;
static int g_startId;

static int g_type;
static int g_team_id;
static int g_page;

static int g_curr_api_host_index = -1;

static void get_full_banner_url(const std::string& relative_path, std::string& absolute_path)
{
	if(relative_path.size() == 0)
	{
		return;
	}

	if( relative_path.substr(0, 7) == string("http://") || relative_path.substr(0, 8) == string("https://") )
	{
		absolute_path = relative_path;
		return;
	}

	absolute_path = HTTP_BANNER_SVR;
	
	if(relative_path.at(0) != '/')
	{
		absolute_path += "/";
	}

	absolute_path += relative_path;
}

void get_full_img_url(const std::string& relative_path, std::string& absolute_path, bool is_dfs)
{
	if(relative_path.size() == 0)
	{
		return;
	}

	if( relative_path.substr(0, 7) == string("http://") || relative_path.substr(0, 8) == string("https://") )
	{
		absolute_path = relative_path;
		return;
	}

	if(false == is_dfs)
	{
		absolute_path = HTTP_IMG_SVR;
	}
	else
	{
		absolute_path = HTTP_IMG_DFS_SVR;
	}

	if(relative_path.at(0) != '/')
	{
		absolute_path += "/";
	}

	absolute_path += relative_path;
}

void get_full_head_icon(const std::string& headid, std::string& absolute_path)
{
	std::string relative_path = headid;

	if(string::npos == headid.find(".png") && string::npos == headid.find(".jpg"))
	{
		absolute_path = headid;
	}
	else
	{
		get_full_img_url(headid, absolute_path);
	}
}

static ThreadVoid http_request(void* _param)
{
	HttpThreadParam* param = (HttpThreadParam*)_param;

	char s[128];
	param->request->insert(make_pair("client", get_client_type()));
	param->request->insert(make_pair("token", get_user_token()));

	if (param->request_method == HTTP_POST)
	{
		std::map<string, string>::iterator it;

		it = param->request->find("s");
		if( it != param->request->end() )
		{
			strcpy(s, it->second.c_str());
			param->request->erase(it);
		}
	}

	if ( g_curr_api_host_index == -1 )
	{
		g_curr_api_host_index = httphosts.size() > 1 ? 0 : 0;
	}

	int try_count = httphosts.size() + 2;
	while ( --try_count >= 0 )
	{
		Http http(param->request_method);
		strcpy(param->url, "http://");
		strcat(param->url, httphosts[g_curr_api_host_index].c_str());
		strcat(param->url, "/api.php");

		if (param->request_method == HTTP_POST)
		{
			strcat(param->url, "?s=");
			strcat(param->url, s);
		}
		http.register_http_listener(param->http_listener);
		http.register_parser(param->parser);
		char* ret = http.request(param->url, param->request);
		if ( ret != NULL )
		{
			break;
		}

		g_curr_api_host_index = (g_curr_api_host_index + 1) % httphosts.size();
	}

	if ( try_count < 0 )
	{
		param->http_listener->OnError(PERR_CONNECT_ERROR);
		ReportHttpApiFailed(param->url, "");
	}

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
	//strcpy(param->url, HTTP_API);
	param->parser = jsonPaser;
	param->http_listener = uiListener;
	param->request = httpParam;
	param->request_method = req_method;

	Thread::start(http_request, param);
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

	std::vector<BannerItem> vec_banner;
	std::vector<Team> vec_team;
	std::vector<ViewpointSummary> vec_viewpoint;
	std::vector<OperateStockProfit> vec_operate;

	vec_banner.clear();
	vec_team.clear();
	vec_viewpoint.clear();
	vec_operate.clear();
	
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
					
					if(!banner.isNull())
					{
						size_ = banner.size();
						for(i = 0; i < size_; i++)
						{
							BannerItem bannerItem;
							bannerItem.set_url(banner[i]["url"].asString());
							bannerItem.set_type(banner[i]["type"].asString());

							std::string out;
							get_full_banner_url(banner[i]["banner"].asString(), out);
							bannerItem.set_croompic(out);
							
							vec_banner.push_back( bannerItem );
						}
					}

					JsonValue& team = value["data"]["videoroom"];

					if(!team.isNull())
					{
						size_ = team.size();
						for(i = 0; i < size_; i++)
						{
							Team teamItem;
							teamItem.set_roomid(atoi(team[i]["nvcbid"].asString().c_str()));

							std::string out;
							get_full_img_url(team[i]["croompic"].asString(), out, true);
							teamItem.set_teamicon(out);

							//videoroomItem.set_livetype(videoroom[i]["livetype"].asString());
							//????

							//videoroomItem.set_ncount(videoroom[i]["ncount"].asString());
							teamItem.set_onlineusercount(atoi(team[i]["ncount"].asString().c_str()));
							teamItem.set_locked(0);

							//videoroomItem.set_cname(videoroom[i]["cname"].asString());
							teamItem.set_teamname(team[i]["cname"].asString());

							int tid = team[i]["teacherid"].asInt();
							teamItem.set_teamid(tid == 0 ? -1 : tid);

							vec_team.push_back(teamItem);
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
						for(i = 0; i < size_; i++)
						{
							ViewpointSummary viewpointItem;
							
							viewpointItem.set_viewpointid(atoi(viewpoint[i]["viewpointId"].asString().c_str()));
							viewpointItem.set_authorid(atoi(viewpoint[i]["authorId"].asString().c_str()));
							//viewpointItem.set_publishtime(viewpoint[i]["publishTime"].asString());
							viewpointItem.set_title(viewpoint[i]["title"].asString());
							
							viewpointItem.set_replycount(atoi(viewpoint[i]["replyCount"].asString().c_str()));
							viewpointItem.set_content(viewpoint[i]["contents"].asString());

							viewpointItem.set_roomid(atoi(viewpoint[i]["roomid"].asString().c_str()));

							//viewpointItem.set_authoricon(viewpoint[i]["authorIcon"].asString());
							std::string icon;
							get_full_head_icon(viewpoint[i]["authorIcon"].asString(), icon);
							viewpointItem.set_authoricon(icon);
							viewpointItem.set_authorname(viewpoint[i]["authorName"].asString());

							viewpointItem.set_giftcount(atoi(viewpoint[i]["giftcount"].asString().c_str()));

							std::string strOut;
							string2timestamp(viewpoint[i]["publishTime"].asString(), strOut);
							viewpointItem.set_publishtime(strOut);
							
							vec_viewpoint.push_back(viewpointItem);
						}
					}

					JsonValue& operate = value["data"]["operate"];

					if(!operate.isNull())
					{
						size_ = operate.size();
						for(i = 0; i < size_; i++)
						{
							OperateStockProfit operateItem;
							operateItem.set_operateid(atoi(operate[i]["operateId"].asString().c_str()));
							operateItem.set_teamid(atoi(operate[i]["teamId"].asString().c_str()));
							operateItem.set_teamname(operate[i]["teamName"].asString());

							std::string icon;
							get_full_head_icon(operate[i]["teamIcon"].asString(), icon);
							operateItem.set_teamicon(icon);

							operateItem.set_focus(operate[i]["focus"].asString());
							operateItem.set_goalprofit(atof(operate[i]["goalProfit"].asString().c_str()));
							operateItem.set_totalprofit(atof(operate[i]["totalProfit"].asString().c_str()));
							operateItem.set_dayprofit(atof(operate[i]["dayProfit"].asString().c_str()));
							operateItem.set_monthprofit(atof(operate[i]["monthProfit"].asString().c_str()));
							operateItem.set_winrate(atof(operate[i]["winRate"].asString().c_str()));

							vec_operate.push_back(operateItem);
						}
					}

					homepage_listener->onResponse(vec_banner, vec_team, vec_viewpoint, vec_operate);
					
					WriteProtocolCache("homepage_cache.txt", strJson);
				}
				else
				{
					homepage_listener->onResponse(vec_banner, vec_team, vec_viewpoint, vec_operate);
				}
			}
			else
			{
				homepage_listener->onResponse(vec_banner, vec_team, vec_viewpoint, vec_operate);
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

	std::vector<Team> vec_collect;

	CollectionListener* collection_listener = (CollectionListener*)listener;

	int size_ = 0;
	int i = 0;

	vec_collect.clear();
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

						for(i = 0; i < size_; i++)
						{
							Team collect;

							//collect.set_teacherid(atoi(data[i]["teacherid"].asString().c_str()));

							int tid = data[i]["teacherid"].asInt();
							collect.set_teamid(tid == 0 ? -1 : tid);

							//collect.set_nvcbid(data[i]["nvcbid"].asString());
							collect.set_roomid(atoi(data[i]["nvcbid"].asString().c_str()));

							//collect.set_cname(data[i]["cname"].asString());
							collect.set_teamname(data[i]["cname"].asString());

							//collect.set_password(data[i]["password"].asString());
							collect.set_locked(atoi(data[i]["password"].asString().c_str()));

							std::string out;
							get_full_img_url(data[i]["croompic"].asString(), out, true);
							//collect.set_croompic(out);
							collect.set_teamicon(out);

							//collect.set_ncount(data[i]["ncount"].asString());
							collect.set_onlineusercount(atoi(data[i]["ncount"].asString().c_str()));

							//collect.set_cgateaddr(data[i]["cgateaddr"].asString());

							//collect.set_ntype(data[i]["ntype"].asString());

							vec_collect.push_back(collect);
						}

						collection_listener->onResponse(vec_collect);
					}
					else
					{
						collection_listener->onResponse(vec_collect);
					}
				}
				else
				{
					collection_listener->OnError(status);
				}
			}

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

void parse_footprintlist(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	std::vector<Team> vec_footprint;

	FootPrintListener* footprint_listener = (FootPrintListener*)listener;

	int size_ = 0;
	int i = 0;

	vec_footprint.clear();
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

				for(i = 0; i < size_; i++)
				{
					Team footprint;
					/*footprint.set_nvcbid(rooms[i]["nvcbid"].asString());
					footprint.set_cname(rooms[i]["cname"].asString());
					footprint.set_password(rooms[i]["password"].asString());
					footprint.set_croompic(rooms[i]["croompic"].asString());
					footprint.set_ncount(rooms[i]["ncount"].asString());
					footprint.set_cgateaddr(rooms[i]["cgateaddr"].asString());
					footprint.set_livetype(rooms[i]["livetype"].asString());
					footprint.set_ntype(rooms[i]["ntype"].asString());*/

					int tid = atoi(rooms[i]["teacherid"].asString().c_str());
					footprint.set_teamid(tid == 0 ? -1 : tid);

					footprint.set_roomid(atoi(rooms[i]["nvcbid"].asString().c_str()));
					footprint.set_teamname(rooms[i]["cname"].asString());
					footprint.set_locked(atoi(rooms[i]["password"].asString().c_str()));

					std::string out;
					get_full_img_url(rooms[i]["croompic"].asString(), out, true);
					footprint.set_teamicon(out);
					
					footprint.set_onlineusercount(atoi(rooms[i]["ncount"].asString().c_str()));

					vec_footprint.push_back(footprint);
				}
			}

			footprint_listener->onResponse2(vec_footprint, false);
		}
		else
		{
			footprint_listener->OnError(PERR_JSON_PARSE_ERROR);
		}

		
	}
	catch ( std::exception& ex )
	{
		footprint_listener->OnError(PERR_JSON_PARSE_ERROR);
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

	operatestocks_list.clear();
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
						operatestockslistener->onResponse(operatestocks_list);
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

void parse_operatestocktransaction(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	std::vector<OperateStockTransaction> operatestockstrans_list;

	int size_ = 0;
	int i = 0;

	OperateStockTransactionListener* operatestockstranlistener = (OperateStockTransactionListener*)listener;

	operatestockstrans_list.clear();
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

						for(i = 0; i < size_; i++)
						{
							OperateStockTransaction stockstrans;

							stockstrans.set_operateid(data[i]["operateId"].asInt());
							stockstrans.set_transid(atoi(data[i]["transId"].asString().c_str()));
							stockstrans.set_buytypeflag(data[i]["buytypeflag"].asInt());
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
						operatestockstranlistener->onResponse(operatestockstrans_list);
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

void parse_PrivateServiceSummaryPack(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;
	int i,j;

	std::vector<TeamPrivateServiceSummaryPack> summary;

	TeamPrivateServiceSummaryPackListener* summary_listener = (TeamPrivateServiceSummaryPackListener*)listener;

	summary.clear();
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

						for(i = 0; i < size_; i++)
						{
							JsonValue& data_item = data[i];

							TeamPrivateServiceSummaryPack pack;
							int size1_ = data_item["list"].size();

							pack.set_vipLevelId(data_item["id"].asInt());
							if ( !data_item["vipinfoname"].isNull() ){
								pack.set_vipLevelName(data_item["vipinfoname"].asString());
							}
							pack.set_isOpen(data_item["isopen"].asInt());

							std::vector<PrivateServiceSummary> ss_list;
							for(j = 0; j < size1_; j++)
							{
								PrivateServiceSummary ss;

								JsonValue& list_item = data_item["list"][j];
								ss.set_id(atoi(list_item["psid"].asString().c_str()));
								ss.set_title(list_item["title"].asString());
								ss.set_cover(list_item["cover"].asString());
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
						summary_listener->onResponse(summary);
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

void parse_privatetraderecord(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	std::vector<OperateStockTransactionPC> vec_trans;

	int size_ = 0;
	int i = 0;

	OperateStockTradeRecordListener* detail_listener = (OperateStockTradeRecordListener*)listener;

	vec_trans.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				detail_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				detail_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				size_ = datas.size();
				vec_trans.clear();
				for(i = 0; i < size_; i++)
				{
					OperateStockTransactionPC trans;
					trans.set_operateid(datas[i]["operateId"].asUInt());
					trans.set_transid(datas[i]["transId"].asUInt());
					trans.set_title(datas[i]["title"].asString());
					trans.set_buytype(datas[i]["buytype"].asString());
					trans.set_stockid(datas[i]["stockId"].asString());
					trans.set_stockname(datas[i]["stockName"].asString());
					trans.set_price(atof((datas[i]["price"].asString()).c_str()));
					trans.set_count(atoi((datas[i]["count"].asString()).c_str()));
					trans.set_money(atof((datas[i]["money"].asString()).c_str()));

					std::string strOut;
					string2timestamp(datas[i]["time"].asString(), strOut);
					trans.set_time(strOut);

					trans.set_summary(datas[i]["summary"].asString());
					
					vec_trans.push_back(trans);
				}
				detail_listener->onResponse(vec_trans);
			}
			else
			{
				detail_listener->onResponse(vec_trans);
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

							std::string out;
							get_full_img_url(data_item["videourl"].asString(), out);
							detail.set_videourl(out);

							detail.set_videoname(data_item["videoname"].asString());

							get_full_img_url(data_item["attachmenturl"].asString(), out);
							detail.set_attachmenturl(out);

							detail.set_attachmentname(data_item["attachmentname"].asString());

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

	viewpoint_list.clear();
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
						
						for(i = 0; i < size_; i++)
						{
							ViewpointSummary viewpoint;

							JsonValue& data_item = data[i];
							viewpoint.set_viewpointid(atoi(data_item["viewpointid"].asString().c_str()));
							viewpoint.set_authorid(atoi(data_item["authorid"].asString().c_str()));
							viewpoint.set_authorname(data_item["authorname"].asString());

							std::string icon;
							get_full_head_icon(data_item["authoricon"].asString(), icon);
							viewpoint.set_authoricon(icon);

							std::string strOut;
							string2timestamp(data_item["publishtime"].asString(), strOut);
							viewpoint.set_publishtime(strOut);

							viewpoint.set_content(data_item["content"].asString());
							viewpoint.set_replycount(atoi(data_item["replycount"].asString().c_str()));
							viewpoint.set_giftcount(atoi(data_item["giftcount"].asString().c_str()));

							viewpoint_list.push_back(viewpoint);
						}

						view_listener->onResponse(viewpoint_list);

						if(0 == g_authorId && 0 == g_startId)
						{
							WriteProtocolCache("viewpoint_cache.txt", strJson);
						}
					}
					else
					{
						view_listener->onResponse(viewpoint_list);
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
	std::vector<Team> hiden_list;
	std::vector<Team> custom_service_list;

	TeamListListener* team_listener = (TeamListListener*)listener;

	team_list.clear();
	hiden_list.clear();
	custom_service_list.clear();
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

						for(i = 0; i < size_; i++)
						{
							Team team;

							JsonValue& data_item = data[i];
							team.set_roomid(data_item["nvcbid"].asInt());
							team.set_teamname(data_item["cname"].asString());

							std::string out;
							get_full_img_url(data_item["croompic"].asString(), out, true);
							team.set_teamicon(out);
							team.set_onlineusercount(data_item["ncount"].asInt());
							int tid = data_item["teacherid"].asInt();
							team.set_teamid(tid == 0 ? -1 : tid);
							team.set_alias(data_item["calias"].asString());
							team.set_locked(data_item["nusepwd"].asInt());

							if(0 == data_item["roomtype"].asInt())
							{
								hiden_list.push_back(team);
							}
							else if(1 == data_item["roomtype"].asInt())
							{
								team_list.push_back(team);
							}
							else if(2 == data_item["roomtype"].asInt())
							{
								custom_service_list.push_back(team);
							}

						}

						team_listener->onResponse(team_list, hiden_list, custom_service_list);

						WriteProtocolCache("teamlist_cache.txt", strJson);
					}
					else
					{
						team_listener->onResponse(team_list, hiden_list, custom_service_list);
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
			else
			{
				what_listener->OnError(PERR_JSON_PARSE_ERROR);
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
	char tmp[64] = {0};
	std::string sTmp;

	std::vector<MyPrivateService> mps_list;
	Team teamItem;
	std::vector<TeamPrivateServiceSummaryPack> summary;

	MyPrivateServiceListener* my_listener = (MyPrivateServiceListener*)listener;

	mps_list.clear();
	summary.clear();
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
							for(i = 0; i < size_; i++)
							{
								MyPrivateService mps;

								JsonValue& data_item = buylist[i];

								mps.set_teamid(data_item["teacherid"].asInt());
								mps.set_teamname(data_item["calias"].asString());

								std::string icon;
								get_full_head_icon(data_item["nheadid"].asString(), icon);
								mps.set_teamicon(icon);

								mps.set_levelid(data_item["viptype"].asInt());
								mps.set_levelname(data_item["vipinfoname"].asString());

								std::string strOut1, strOut2;
								string2timestamp(data_item["buytime"].asString(), strOut1);
								string2timestamp(data_item["expirtiontime"].asString(), strOut2);
								sprintf(tmp, "%s", strOut2.c_str());
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

								pack.set_vipLevelId(i + 1);
								pack.set_vipLevelName(data_item["vipinfoname"].asString());
								pack.set_isOpen(0);

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

							teamItem.set_teamid(team["id"].asInt());
							teamItem.set_teamname(team["name"].asString());

							std::string icon;
							get_full_head_icon(team["headid"].asString(), icon);
							teamItem.set_teamicon(icon);
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
			else
			{
				my_listener->OnError(PERR_JSON_PARSE_ERROR);
			}
		}
	}
	catch( std::exception& ex )
	{
		//my_listener->OnError(PERR_JSON_PARSE_ERROR);
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

	psld_list.clear();
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

						for(i = 0; i < size_; i++)
						{
							PrivateServiceLevelDescription psld;

							JsonValue& data_item = data[i];

							psld.set_levelid(atoi(data_item["viplevel"].asString().c_str()));
							psld.set_levelname(data_item["vipinfoname"].asString());
							psld.set_description(data_item["contents"].asString());
							psld.set_buyprice(data_item["price"].asFloat());
							psld.set_updateprice(data_item["upgrade_price"].asFloat());

							psld.set_isopen(data_item["flag"].asInt());
							psld.set_maxnum(data_item["maxnum"].asInt());

							std::string strOut1,strOut2;
							string2timestamp(data_item["buytime"].asString(), strOut1);
							string2timestamp(data_item["expirtiontime"].asString(), strOut2);

							psld.set_buytime(strOut1);
							psld.set_expirtiontime(strOut2);
							
							psld_list.push_back(psld);
						}

						buy_listener->onResponse(psld_list);
					}
					else
					{
						buy_listener->onResponse(psld_list);
					}
				}
				else
				{
					buy_listener->OnError(status);
				}
			}
		}
		else
		{
			buy_listener->OnError(PERR_JSON_PARSE_ERROR);
		}
	}
	catch ( std::exception& ex)
	{
		buy_listener->OnError(PERR_JSON_PARSE_ERROR);
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

	vec_consume.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				consumerank_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				consumerank_listener->OnError(statu);
				return;
			}

			JsonValue& consumes = value["data"];
			if(!consumes.isNull())
			{
				size_ = consumes.size();

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
				consumerank_listener->onResponse(vec_consume);
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

	vec_viewpoint.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				viewpoint_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				viewpoint_listener->OnError(statu);
				return;
			}

			JsonValue& viewpoints = value["data"];
			if(!viewpoints.isNull())
			{
				size_ = viewpoints.size();
				
				for(i = 0; i < size_; i++)
				{
					ViewpointSummary viewpoint;
					viewpoint.set_authorid(atoi(viewpoints[i]["authorid"].asString().c_str()));
					viewpoint.set_authorname(viewpoints[i]["authorname"].asString());

					std::string icon;
					get_full_head_icon(viewpoints[i]["authoricon"].asString(), icon);
					viewpoint.set_authoricon(icon);

					viewpoint.set_viewpointid(atoi((viewpoints[i]["viewpointid"].asString()).c_str()));

					std::string strOut;
					string2timestamp(viewpoints[i]["publishtime"].asString(), strOut);
					viewpoint.set_publishtime(strOut);
					viewpoint.set_title(viewpoints[i]["title"].asString());		
					viewpoint.set_content(viewpoints[i]["content"].asString());			
					viewpoint.set_replycount(atoi((viewpoints[i]["replycount"].asString()).c_str()));
					viewpoint.set_giftcount(atoi((viewpoints[i]["giftcount"].asString()).c_str()));
					vec_viewpoint.push_back(viewpoint);
				}

				viewpoint_listener->onResponse(vec_viewpoint);

				if(0 == g_authorId && 0 == g_startId)
				{
					WriteProtocolCache("viewpoint_cache.txt", strJson);
				}
			}
			else
			{
				viewpoint_listener->onResponse(vec_viewpoint);
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
void parse_viewpointdetail(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	ViewpointDetailListener* detail_listener = (ViewpointDetailListener*)listener;
	std::vector<ImageInfo> img_list;
	ViewpointDetail detail;
	int size_ = 0;
	int i = 0;

	img_list.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				detail_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				detail_listener->OnError(statu);
				return;
			}

			JsonValue& details = value["data"];
			if(!details.isNull())
			{
				detail.set_viewpointid(atoi((details["viewpointId"].asString()).c_str()));
				detail.set_authorid(atoi(details["teacherid"].asString().c_str()));
				detail.set_roomid(atoi(details["authorId"].asString().c_str()));
				detail.set_authorname(details["authorName"].asString());

				std::string icon;
				get_full_head_icon(details["authorIcon"].asString(), icon);
				detail.set_authoricon(icon);

				std::string strOut;
				string2timestamp(details["publishTime"].asString(), strOut);
				detail.set_publishtime(strOut);

				detail.set_title(details["title"].asString());
				detail.set_content(details["content"].asString());
				detail.set_replycount(atoi((details["replyCount"].asString()).c_str()));
				detail.set_giftcount(atoi((details["giftcount"].asString()).c_str()));
				detail.set_html5url(details["share_link"].asString());

				size_ = details["pic"].size();
				img_list.clear();

				for( i = 0; i < size_; i ++ )
				{
					ImageInfo image;
					image.set_height(atoi(details["pic"][i]["height"].asString().c_str()));
					image.set_width(atoi(details["pic"][i]["width"].asString().c_str()));

					std::string out;
					get_full_img_url(details["pic"][i]["img"].asString(), out);
					image.set_path(out);

					img_list.push_back(image);
				}
				
				detail_listener->onResponse(detail, img_list);
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

	vec_reply.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				reply_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				reply_listener->OnError(statu);
				return;
			}

			JsonValue& replys = value["data"];
			if(!replys.isNull())
			{
				size_ = replys.size();
				
				for(i = 0; i < size_; i++)
				{
					Reply reply;
					reply.set_replytid(atoi((replys[i]["replytId"].asString()).c_str()));
					reply.set_viewpointid(atoi((replys[i]["viewpointId"].asString()).c_str()));
					reply.set_parentreplyid(atoi((replys[i]["parentReplyId"].asString()).c_str()));
					reply.set_authorid(atoi(replys[i]["authorId"].asString().c_str()));
					reply.set_authorname(replys[i]["authorName"].asString());

					std::string icon;
					get_full_head_icon(replys[i]["authorIcon"].asString(), icon);//////////////////////////////////////
					reply.set_authoricon(icon);

					reply.set_fromauthorid(atoi(replys[i]["fromAuthorId"].asString().c_str()));
					reply.set_fromauthorname(replys[i]["fromAuthorName"].asString());

					get_full_head_icon(replys[i]["fromAuthorIcon"].asString(), icon);
					reply.set_fromauthoricon(icon);

					std::string strOut;
					string2timestamp(replys[i]["publishTime"].asString(), strOut);
					reply.set_publishtime(strOut);
					
					reply.set_content(replys[i]["content"].asString());

					reply.set_authorrole(atoi(replys[i]["authorRole"].asString().c_str()));
					reply.set_fromauthorrole(atoi(replys[i]["fromAuthorRole"].asString().c_str()));

					vec_reply.push_back(reply);
				}

				reply_listener->onResponse(vec_reply);
			}
			else
			{
				reply_listener->onResponse(vec_reply);
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

	Reply reply;

	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				reply_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				reply_listener->OnError(statu);
				return;
			}

			JsonValue& replys = value["data"];
			if(!replys.isNull())
			{
				reply.set_replytid(atoi((replys["replytId"].asString()).c_str()));
				reply.set_viewpointid(atoi((replys["viewpointId"].asString()).c_str()));
				reply.set_parentreplyid(atoi((replys["parentReplyId"].asString()).c_str()));
				reply.set_authorid(atoi(replys["authorId"].asString().c_str()));
				reply.set_authorname(replys["authorName"].asString());

				std::string icon;
				get_full_head_icon(replys["authorIcon"].asString(), icon);   ////////////////////////////
				reply.set_authoricon(icon);
				
				reply.set_fromauthorid(atoi(replys["fromAuthorId"].asString().c_str()));
				reply.set_fromauthorname(replys["fromAuthorName"].asString());

				get_full_head_icon(replys["fromAuthorIcon"].asString(), icon);
				reply.set_fromauthoricon(icon);

				std::string strOut;
				string2timestamp(replys["publishTime"].asString(), strOut);
				reply.set_publishtime(strOut);
				
				reply.set_content(replys["content"].asString());				


				reply_listener->onResponse(0,reply);

			}
			else
			{
				reply_listener->onResponse(0,reply);
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
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				unread_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				unread_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				TotalUnread unread;
				unread.set_total(atoi((datas["total"].asString()).c_str()));

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
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				unread_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				unread_listener->OnError(statu);
				return;
			}

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

	vec_private.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				private_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				private_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				size_ = datas["list"].size();
				
				for(i = 0; i < size_; i++)
				{
					PrivateServiceSummary privateserv;
					privateserv.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
					privateserv.set_title(datas["list"][i]["title"].asString());
					privateserv.set_summary(datas["list"][i]["summary"].asString());
					privateserv.set_teamname(datas["list"][i]["teamName"].asString());

					std::string strOut;
					string2timestamp(datas["list"][i]["publishTime"].asString(), strOut);
					privateserv.set_publishtime(strOut);

					vec_private.push_back(privateserv);
				}

				private_listener->onResponse(vec_private);
			}
			else
			{
				private_listener->onResponse(vec_private);
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

	PrivateServiceDetail detail;
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				detail_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				detail_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				
				detail.set_title(datas["row"]["title"].asString());
				detail.set_content(datas["row"]["content"].asString());

				std::string strOut;
				string2timestamp(datas["row"]["publishTime"].asString(), strOut);
				detail.set_publishtime(strOut);
				
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

	vec_system.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				system_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				system_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				size_ = datas["list"].size();
				
				for(i = 0; i < size_; i++)
				{
					SystemMessage system;
					system.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
					system.set_title(datas["list"][i]["title"].asString());
					system.set_content(datas["list"][i]["content"].asString());

					std::string strOut;
					string2timestamp(datas["list"][i]["publishTime"].asString(), strOut);
					system.set_publishtime(strOut);
					
					vec_system.push_back(system);
				}

				system_listener->onResponse(vec_system);
			}
			else
			{
				system_listener->onResponse(vec_system);
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

	vec_questionanswer.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				questionanswer_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				questionanswer_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				int isteacher=0;
				if(!datas["isTeacher"].isNull())
					isteacher=(atoi((datas["isTeacher"].asString()).c_str()));
				size_ = datas["list"].size();
				
				for(i = 0; i < size_; i++)
				{
					QuestionAnswer questionanswer;
					questionanswer.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
					questionanswer.set_answerauthorid(atoi(datas["list"][i]["answerAuthorId"].asString().c_str()));
					questionanswer.set_answerauthorname(datas["list"][i]["answerAuthorName"].asString());
					
					std::string icon;
					get_full_head_icon(datas["list"][i]["answerAuthorHead"].asString(), icon);
					questionanswer.set_answerauthorhead(icon);	
					
					
					questionanswer.set_answerauthorrole(atoi((datas["list"][i]["answerAuthorRole"].asString()).c_str()));

					std::string strOut;
					string2timestamp(datas["list"][i]["answerTime"].asString(), strOut);
					questionanswer.set_answertime(strOut);

					questionanswer.set_answercontent(datas["list"][i]["answerContent"].asString());
					questionanswer.set_askauthorid(atoi(datas["list"][i]["askAuthorId"].asString().c_str()));
					questionanswer.set_askauthorname(datas["list"][i]["askAuthorName"].asString());
					
					
					get_full_head_icon(datas["list"][i]["askAuthorHead"].asString(), icon);
					questionanswer.set_askauthorhead(icon);
					
					questionanswer.set_askauthorrole(atoi((datas["list"][i]["askAuthorRole"].asString()).c_str()));
					questionanswer.set_askstock(datas["list"][i]["askStock"].asString());
					questionanswer.set_askcontent(datas["list"][i]["askContent"].asString());

					string2timestamp(datas["list"][i]["askTime"].asString(), strOut);
					questionanswer.set_asktime(strOut);

					questionanswer.set_fromclient(atoi((datas["list"][i]["fromClient"].asString()).c_str()));
					vec_questionanswer.push_back(questionanswer);
				}

				questionanswer_listener->onResponse(vec_questionanswer,isteacher,0);
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

	vec_comment.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				comment_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				comment_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				int isteacher=0;
				if(!datas["isTeacher"].isNull())
					isteacher=(atoi((datas["isTeacher"].asString()).c_str()));
				size_ = datas["list"].size();
				
				for(i = 0; i < size_; i++)
				{
					MailReply comment;
					comment.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
					comment.set_viewpointid(atoi((datas["list"][i]["viewpointId"].asString()).c_str()));
					comment.set_title(datas["list"][i]["title"].asString());
					comment.set_askauthorid(atoi(datas["list"][i]["askAuthorId"].asString().c_str()));
					comment.set_askauthorname(datas["list"][i]["askAuthorName"].asString());

					std::string icon;
					get_full_head_icon(datas["list"][i]["askAuthorHead"].asString(), icon);
					comment.set_askauthorhead(icon);

					comment.set_askauthorrole(atoi((datas["list"][i]["askAuthorRole"].asString()).c_str()));
					comment.set_askcontent(datas["list"][i]["askContent"].asString());
					
					std::string strOut;
					string2timestamp(datas["list"][i]["askTime"].asString(), strOut);
					comment.set_asktime(strOut);


					comment.set_answerauthorid(datas["list"][i]["answerAuthorId"].asString());
					comment.set_answerauthorname(datas["list"][i]["answerAuthorName"].asString());

					get_full_head_icon(datas["list"][i]["answerAuthorHead"].asString(), icon);
					comment.set_answerauthorhead(icon);

					comment.set_answerauthorrole(atoi((datas["list"][i]["answerAuthorRole"].asString()).c_str()));

					string2timestamp(datas["list"][i]["answerTime"].asString(), strOut);
					comment.set_answertime(strOut);
					
					comment.set_answercontent(datas["list"][i]["answerContent"].asString());
					comment.set_fromclient(atoi((datas["list"][i]["fromClient"].asString()).c_str()));
					vec_comment.push_back(comment);
				}

				comment_listener->onResponse(vec_comment,isteacher,0);
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

void parse_postaskquestion(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	AskQuestionListener* ask_listener = (AskQuestionListener*)listener;
	//HttpListener* ask_listener = listener;

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

				//ask_listener->OnError(status);
				ask_listener->onResponse(status);
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
void parse_postanswer(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	AnswerQuestionListener* ans_listener = (AnswerQuestionListener*)listener;

	try
	{
		if (reader.parse(strJson, value))
		{
			if(!value["status"].isNull())
			{
				int status = value["status"].asInt();

				std::string info = value["info"].asString();

				LOG("---------[%s]---------", info.c_str());

				//TODO
				ans_listener->onResponse(status);
			}
			else
			{
				ans_listener->OnError(PERR_JSON_PARSE_ERROR);
			}
		}
	}
	catch( std::exception& ex )
	{
		ans_listener->OnError(PERR_JSON_PARSE_ERROR);
	}
}

void parse_groupspage(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	int size_ = 0;
	int i = 0;

	std::vector<NavigationItem> roomgroup_list;

	GroupsPageListener* page_listener = (GroupsPageListener*)listener;

	roomgroup_list.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			if(!value["status"].isNull())
			{
				int status = value["status"].asInt();
				JsonValue& data = value["data"];

				if(0 == status)
				{
					JsonValue& groupspage = value["data"];

					if(!groupspage.isNull())
					{
						size_ = groupspage.size();

						if(0 != size_)
						{
							for( i = 0; i < size_; i++ )
							{
								NavigationItem roomgroup;

								roomgroup.set_nid(atoi(groupspage[i]["nid"].asString().c_str()));
								roomgroup.set_level(atoi(groupspage[i]["nglevel"].asString().c_str()));
								roomgroup.set_grouptype(atoi(groupspage[i]["ngrouptype"].asString().c_str()));
								roomgroup.set_parentid(atoi(groupspage[i]["nparentid"].asString().c_str()));
								roomgroup.set_showflag(atoi(groupspage[i]["nshowflag"].asString().c_str()));
								roomgroup.set_sortid(atoi(groupspage[i]["nsortid"].asString().c_str()));
								roomgroup.set_name(groupspage[i]["cname"].asString());
								roomgroup.set_fontcolor(groupspage[i]["cfontcolor"].asString());
								roomgroup.set_curl(groupspage[i]["curl"].asString());
								roomgroup.set_gateurl(groupspage[i]["gateurl"].asString());
								roomgroup.set_roomid(atoi(groupspage[i]["roomid"].asString().c_str()));
								roomgroup.set_type(atoi(groupspage[i]["type"].asString().c_str()));

								roomgroup_list.push_back(roomgroup);
							}
						}

						page_listener->onResponse(roomgroup_list);
					}
					else
					{
						page_listener->onResponse(roomgroup_list);
					}

				}
				else
				{
					page_listener->OnError(status);
				}
			}
		}
	}
	catch ( std::exception& ex)
	{
		page_listener->OnError(PERR_JSON_PARSE_ERROR);
	}
}

void parse_UserTeamRelatedInfo(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	UserTeamRelatedInfo info;

	UserTeamRelatedInfoListener* related_listener = (UserTeamRelatedInfoListener*)listener;

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
					if(!data.isNull())
					{
						info.set_askremain(atoi(data["count"].asString().c_str()));
						info.set_askcoin(data["gold"].asInt());

						related_listener->onResponse(info);
					}
					else
					{
						related_listener->OnError(PERR_JSON_PARSE_ERROR);
					}
				}
				else
				{
					related_listener->OnError(status);
				}
			}
			else
			{
				related_listener->OnError(PERR_JSON_PARSE_ERROR);
			}
		}
		else
		{
			related_listener->OnError(PERR_JSON_PARSE_ERROR);
		}
	}
	catch(std::exception& ex)
	{
		related_listener->OnError(PERR_JSON_PARSE_ERROR);
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

	vec_video.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				video_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				video_listener->OnError(statu);
				return;
			}

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

					std::string out;
					get_full_img_url(datas[i]["pic"].asString(), out);
					video.set_picurl(out);

					get_full_img_url(datas[i]["video"].asString(), out);
					video.set_videourl(out);
					vec_video.push_back(video);
				}

				video_listener->onResponse(vec_video);
			}
			else
			{
				video_listener->onResponse(vec_video);
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
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				introduce_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				introduce_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				Team introduce;
				introduce.set_teamname(datas["cname"].asString());

				std::string icon;
				get_full_head_icon(datas["headid"].asString(), icon);
				introduce.set_teamicon(icon);

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

void parse_profitorder(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	std::vector<OperateStockProfit> vec_profitorder;
	int seq = 0;
	bool bRefresh = false;

	int size_ = 0;
	int i = 0;

	OperateStockProfitListener* profitorder_listener = (OperateStockProfitListener*)listener;

	vec_profitorder.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				profitorder_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				profitorder_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				size_ = datas["list"].size();
				
				for(i = 0; i < size_; i++)
				{
					OperateStockProfit profitorder;

					profitorder.set_operateid(datas["list"][i]["operateId"].asUInt());
					profitorder.set_teamid(atoi(datas["list"][i]["teamId"].asString().c_str()));
					//profitorder.set_teamname(UTF8ToGBK(datas["list"][i]["teamName"].asString()));
					profitorder.set_teamname(datas["list"][i]["teamName"].asString());

					std::string icon;
					get_full_head_icon(datas["list"][i]["teamIcon"].asString(), icon);
					profitorder.set_teamicon(icon);

					//profitorder.set_focus(UTF8ToGBK(datas["list"][i]["focus"].asString()));
					profitorder.set_focus(datas["list"][i]["focus"].asString());
					profitorder.set_goalprofit(atof((datas["list"][i]["goalProfit"].asString()).c_str()));
					profitorder.set_totalprofit(atof((datas["list"][i]["totalProfit"].asString()).c_str()));
					profitorder.set_dayprofit(atof((datas["list"][i]["dayProfit"].asString()).c_str()));
					profitorder.set_monthprofit(atof((datas["list"][i]["monthProfit"].asString()).c_str()));
					profitorder.set_winrate(atof((datas["list"][i]["winRate"].asString()).c_str()));

					vec_profitorder.push_back(profitorder);
				}

				seq = atoi(datas["seq"].asString().c_str());
				bRefresh = datas["refresh"].asBool();

				profitorder_listener->onResponse(vec_profitorder, seq, bRefresh);

				char cache_file[256] = {0};
				if( (g_type ==1)  && (0 == g_team_id) && ( g_page <= 1))
				{
					sprintf(cache_file, "operatestock_cache_%d.txt", g_type);

					WriteProtocolCache((const char*)cache_file, strJson);
				}
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

	std::vector<OperateDataByTime> vec_total;
	std::vector<OperateDataByTime> vec_3month;
	std::vector<OperateDataByTime> vec_month;
	std::vector<OperateDataByTime> vec_week;
	std::vector<OperateStockTransaction> vec_trans;
	std::vector<OperateStocks> vec_stocks;

	int size_ = 0;
	int i = 0;

	OperateStockAllDetailListener* detail_listener = (OperateStockAllDetailListener*)listener;

	vec_total.clear();
	vec_3month.clear();
	vec_month.clear();
	vec_week.clear();
	vec_trans.clear();
	vec_stocks.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				detail_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				detail_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				OperateStockProfit osprofit;
				osprofit.set_operateid(atoi((datas["profile"]["operateId"].asString()).c_str()));
				osprofit.set_teamid(atoi(datas["profile"]["teamId"].asString().c_str()));
				osprofit.set_teamname(datas["profile"]["teamName"].asString());

				std::string icon;
				get_full_head_icon(datas["profile"]["teamIcon"].asString(), icon);
				osprofit.set_teamicon(icon);

				osprofit.set_focus(datas["profile"]["focus"].asString());
				osprofit.set_goalprofit(atof((datas["profile"]["goalProfit"].asString()).c_str()));
				osprofit.set_totalprofit(atof((datas["profile"]["totalProfit"].asString()).c_str()));
				osprofit.set_dayprofit(atof((datas["profile"]["dayProfit"].asString()).c_str()));
				osprofit.set_monthprofit(atof((datas["profile"]["monthProfit"].asString()).c_str()));
				osprofit.set_winrate(atof((datas["profile"]["winRate"].asString()).c_str()));
				
				size_ = datas["curve"]["dataAll"].size();
				
				for(i = 0; i < size_; i++)
				{
					OperateDataByTime total;
					total.set_rate(atof((datas["curve"]["dataAll"][i]["rate"].asString()).c_str()));
					total.set_trend(atof((datas["curve"]["dataAll"][i]["cpi"].asString()).c_str()));
					total.set_date(datas["curve"]["dataAll"][i]["date"].asString());
					vec_total.push_back(total);
				}

				size_ = datas["curve"]["data3Month"].size();
				
				for(i = 0; i < size_; i++)
				{
					OperateDataByTime total;
					total.set_rate(atof((datas["curve"]["data3Month"][i]["rate"].asString()).c_str()));
					total.set_trend(atof((datas["curve"]["data3Month"][i]["cpi"].asString()).c_str()));
					total.set_date(datas["curve"]["data3Month"][i]["date"].asString());
					vec_3month.push_back(total);
				}

				size_ = datas["curve"]["dataMonth"].size();
				
				for(i = 0; i < size_; i++)
				{
					OperateDataByTime total;
					total.set_rate(atof((datas["curve"]["dataMonth"][i]["rate"].asString()).c_str()));
					total.set_trend(atof((datas["curve"]["dataMonth"][i]["cpi"].asString()).c_str()));
					total.set_date(datas["curve"]["dataMonth"][i]["date"].asString());
					vec_month.push_back(total);
				}

				size_ = datas["curve"]["dataWeek"].size();
				
				for(i = 0; i < size_; i++)
				{
					OperateDataByTime total;
					total.set_rate(atof((datas["curve"]["dataWeek"][i]["rate"].asString()).c_str()));
					total.set_trend(atof((datas["curve"]["dataWeek"][i]["cpi"].asString()).c_str()));
					total.set_date(datas["curve"]["dataWeek"][i]["date"].asString());
					vec_week.push_back(total);
				}

				size_ = datas["trans"].size();
				
				for(i = 0; i < size_; i++)
				{
					OperateStockTransaction trans;
					trans.set_operateid(datas["trans"][i]["operateId"].asUInt());
					trans.set_transid(datas["trans"][i]["transId"].asUInt());
					trans.set_buytype(datas["trans"][i]["buytype"].asString());
					trans.set_stockid(datas["trans"][i]["stockId"].asString());
					trans.set_stockname(datas["trans"][i]["stockName"].asString());
					trans.set_price(atof((datas["trans"][i]["price"].asString()).c_str()));
					trans.set_count(atoi((datas["trans"][i]["count"].asString()).c_str()));
					trans.set_money(atof((datas["trans"][i]["money"].asString()).c_str()));

					std::string strOut;
					string2timestamp(datas["trans"][i]["time"].asString(), strOut);
					trans.set_time(strOut);

					vec_trans.push_back(trans);
				}

				size_ = datas["stocks"].size();
				
				for(i = 0; i < size_; i++)
				{
					OperateStocks stocks;
					stocks.set_transid(datas["stocks"][i]["transId"].asUInt());
					stocks.set_operateid(datas["stocks"][i]["operateId"].asUInt());
					stocks.set_stockid(datas["stocks"][i]["stockId"].asString());
					stocks.set_stockname(datas["stocks"][i]["stockName"].asString());
					stocks.set_count(atoi((datas["stocks"][i]["count"].asString()).c_str()));
					stocks.set_cost(atof((datas["stocks"][i]["cost"].asString()).c_str()));
					stocks.set_currprice(atof((datas["stocks"][i]["currPrice"].asString()).c_str()));
					stocks.set_profitrate(atof((datas["stocks"][i]["profitRate"].asString()).c_str()));
					stocks.set_profitmoney(atof((datas["stocks"][i]["ProfitMoney"].asString()).c_str()));
					
					vec_stocks.push_back(stocks);
				}

				uint32 currLevelId=datas["currLevelId"].asUInt();
				uint32 minVipLevel=datas["minVipLevel"].asUInt();


				detail_listener->onResponse(osprofit,vec_total,vec_3month,vec_month,vec_week,vec_trans,vec_stocks,currLevelId,minVipLevel);
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
					if(!data.isNull())
					{
						std::string out;
						get_full_img_url(data["imageUrl"].asString(), out);
						info.set_imageurl(out);
						info.set_text(data["text"].asString());
						info.set_url(data["url"].asString());
						info.set_startime(atol(data["starTime"].asString().c_str()));
						info.set_endtime(atol(data["endTime"].asString().c_str()));
						splash_listener->onResponse(info);
					}
					else
					{
						splash_listener->OnError(PERR_JSON_PARSE_ERROR);
					}
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


 void parse_questionunanswer(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	std::vector<QuestionAnswer> vec_questionanswer;

	int size_ = 0;
	int i = 0;

	QuestionAnswerListener* questionanswer_listener = (QuestionAnswerListener*)listener;

	vec_questionanswer.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				questionanswer_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				questionanswer_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				int isteacher=0;
				if(!datas["isTeacher"].isNull())
					isteacher=(atoi((datas["isTeacher"].asString()).c_str()));
				size_ = datas["list"].size();
				
				for(i = 0; i < size_; i++)
				{
					QuestionAnswer questionanswer;
					if(isteacher==0)
					{
						questionanswer.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
						questionanswer.set_answerauthorid(atoi(datas["list"][i]["answerAuthorId"].asString().c_str()));
						questionanswer.set_answerauthorname(datas["list"][i]["answerAuthorName"].asString());
						questionanswer.set_answerauthorhead(datas["list"][i]["answerAuthorHead"].asString());	
						questionanswer.set_answerauthorrole(atoi((datas["list"][i]["answerAuthorRole"].asString()).c_str()));
						questionanswer.set_askstock(datas["list"][i]["askStock"].asString());
						questionanswer.set_askcontent(datas["list"][i]["askContent"].asString());

						std::string strOut;
						string2timestamp(datas["list"][i]["askTime"].asString(), strOut);
						questionanswer.set_asktime(strOut);

						questionanswer.set_answertime("");
						questionanswer.set_answercontent("");
						questionanswer.set_askauthorid(0);
						questionanswer.set_askauthorname("");
						questionanswer.set_askauthorhead("");
						questionanswer.set_askauthorrole(0);
						questionanswer.set_fromclient(0);
					}
					else
					{
						questionanswer.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
						questionanswer.set_askauthorid(atoi(datas["list"][i]["askAuthorId"].asString().c_str()));
						questionanswer.set_askauthorname(datas["list"][i]["askAuthorName"].asString());
						std::string icon;
						get_full_head_icon(datas["list"][i]["answerAuthorHead"].asString(), icon);
						questionanswer.set_askauthorhead(icon);
						questionanswer.set_askauthorrole(atoi((datas["list"][i]["askAuthorRole"].asString()).c_str()));
						questionanswer.set_askstock(datas["list"][i]["askStock"].asString());
						questionanswer.set_askcontent(datas["list"][i]["askContent"].asString());

						std::string strOut;
						string2timestamp(datas["list"][i]["askTime"].asString(), strOut);
						questionanswer.set_asktime(strOut);
						
						questionanswer.set_answerauthorid(0);
						questionanswer.set_answerauthorname("");
						questionanswer.set_answerauthorhead("");	
						questionanswer.set_answerauthorrole(0);
						questionanswer.set_answertime("");
						questionanswer.set_answercontent("");
						questionanswer.set_fromclient(0);
					}
					vec_questionanswer.push_back(questionanswer);
				}

				questionanswer_listener->onResponse(vec_questionanswer,isteacher,1);
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

void parse_sendcomment(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	std::vector<MailReply> vec_comment;

	int size_ = 0;
	int i = 0;

	MailReplyListener* comment_listener = (MailReplyListener*)listener;

	vec_comment.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				comment_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				comment_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				int isteacher=0;
				if(!datas["isTeacher"].isNull())
					isteacher=(atoi((datas["isTeacher"].asString()).c_str()));
				size_ = datas["list"].size();
				
				for(i = 0; i < size_; i++)
				{
					MailReply comment;
					comment.set_id(atoi((datas["list"][i]["id"].asString()).c_str()));
					comment.set_viewpointid(atoi((datas["list"][i]["viewpointId"].asString()).c_str()));
					comment.set_title(datas["list"][i]["title"].asString());
					comment.set_askauthorid(atoi(datas["list"][i]["askAuthorId"].asString().c_str()));
					comment.set_askauthorname(datas["list"][i]["askAuthorName"].asString());
					std::string icon;
					get_full_head_icon(datas["list"][i]["askAuthorHead"].asString(), icon);
					comment.set_askauthorhead(icon);
					comment.set_askauthorrole(atoi((datas["list"][i]["askAuthorRole"].asString()).c_str()));
					comment.set_askcontent(datas["list"][i]["askContent"].asString());

					std::string strOut;
					string2timestamp(datas["list"][i]["askTime"].asString(), strOut);
					comment.set_asktime(strOut);

					comment.set_answerauthorid("");
					comment.set_answerauthorname("");
					comment.set_answerauthorhead("");	
					comment.set_answerauthorrole(0);
					comment.set_answertime("");
					comment.set_answercontent("");
					comment.set_fromclient(0);
					vec_comment.push_back(comment);
				}

				comment_listener->onResponse(vec_comment,isteacher,1);
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

void parse_teacherfans(char* json, HttpListener* listener)
{
	std::string strJson = json;

	JsonValue value;
	JsonReader reader;

	std::vector<TeacherFansResp> vec_fans;

	int size_ = 0;
	int i = 0;

	TeacherFansListener* fans_listener = (TeacherFansListener*)listener;

	vec_fans.clear();
	try
	{
		// 解析逻辑
		//..
		if (reader.parse(strJson, value))
		{
			JsonValue& status = value["status"];
			if(status.isNull())
			{
				fans_listener->OnError(PERR_JSON_PARSE_ERROR);
				return;
			}
			int statu = value["status"].asInt();
			if(statu!=0)
			{
				fans_listener->OnError(statu);
				return;
			}

			JsonValue& datas = value["data"];
			if(!datas.isNull())
			{
				size_ = datas["list"].size();
				
				for(i = 0; i < size_; i++)
				{
					TeacherFansResp fans;
					fans.set_userid(atoi((datas["list"][i]["userid"].asString()).c_str()));
					fans.set_useralias(datas["list"][i]["useralias"].asString());
					fans.set_userheadid(atoi(datas["list"][i]["userheadid"].asString().c_str()));
					vec_fans.push_back(fans);
				}

				fans_listener->onResponse(vec_fans);
			}
			else
			{
				fans_listener->OnError(PERR_JSON_PARSE_ERROR);
			}
		}
		else
		{
			fans_listener->OnError(PERR_JSON_PARSE_ERROR);
		}
	}
	catch ( std::exception& ex)
	{
		fans_listener->OnError(PERR_JSON_PARSE_ERROR);
	}
}

/******************************发起请求******************************/

//首页列表数据
void HttpConnection::RequestHomePage(HomePageListener* listener)
{
	std::string cache_content;
	if(needHomePageCache)
	{
		needHomePageCache = false;

		ReadProtocolCache("homepage_cache.txt", cache_content);

		if (!cache_content.empty())
		{
			const char* tmp = cache_content.c_str();
			parse_homepage((char*)tmp, listener);
		}
	}

	RequestParamter& param = get_request_param();
	param["s"] = "index/index";

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
	std::string cache_content;
	if(needRoomListCache)
	{/*
		needRoomListCache = false;

		ReadProtocolCache("teamlist_cache.txt", cache_content);

		if (!cache_content.empty())
		{
			const char* tmp = cache_content.c_str();
			parse_TeamList((char*)tmp, listener);
		}
	*/}

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
}

// 请求观点列表
void HttpConnection::RequestViewpointSummary(int authorId, int startId, int requestCount, ViewpointSummaryListener* listener)
{
	std::string cache_content;
	if(needViewPointCache)
	{
		needViewPointCache = false;

		ReadProtocolCache("viewpoint_cache.txt", cache_content);

		if (!cache_content.empty())
		{
			const char* tmp = cache_content.c_str();
			parse_viewpoint((char*)tmp, listener);
		}
	}

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

void HttpConnection::RequestFootPrint(FootPrintListener* listener)
{
	RequestParamter& request = get_request_param();

	request["s"] = "user/getMyFootPrint";
	request["userid"] = get_user_id();

	http_request_asyn(listener, parse_footprintlist, &request);
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
void HttpConnection::PostReply(int viewpointId, int parentReplyId, int authorId, int fromAuthorId, const char* content, PostReplyListener* listener)
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
	sprintf(tmp,"/mail/unread/uid/%d/guest/%d",login_userid, get_user_isguest());
	
	RequestParamter& request = get_request_param();
	request["s"] = tmp;

	http_request_asyn(listener, parse_totalunreadcount, &request);
}

// 请求未读数
void HttpConnection::RequestUnreadCount(UnreadListener* listener)
{
	char tmp[512];
	sprintf(tmp,"/mail/main/uid/%d/guest/%d",login_userid, get_user_isguest());
	
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

// 高手操盘交易记录PC
void HttpConnection::RequestPrivateTradeRecord(int startId, int count,OperateStockTradeRecordListener* listener)
{
	char tmp[512];
	sprintf(tmp,"/operate/tradeRecord/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
	
	RequestParamter& request = get_request_param();
	request["s"] = tmp;

	http_request_asyn(listener, parse_privatetraderecord, &request);

}

// 请求系统消息
void HttpConnection::RequestSystemMessage(int startId, int count, SystemMessageListener* listener)
{
	char tmp[512];
	sprintf(tmp,"/mail/system/uid/%d/size/%d/id/%d/type/%d/guest/%d",login_userid,count,startId,0, get_user_isguest());
	
	RequestParamter& request = get_request_param();
	request["s"] = tmp;

	http_request_asyn(listener, parse_systemmessage, &request);
}

// 请求问题回复
void HttpConnection::RequestQuestionAnswer(int startId, int count, QuestionAnswerListener* listener)
{
	char tmp[512];
	sprintf(tmp,"/mail/question/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
	
	RequestParamter& request = get_request_param();
	request["s"] = tmp;

	http_request_asyn(listener, parse_questionanswer, &request);
}

// 请求评论回复
void HttpConnection::RequestMailReply(int startId, int count, MailReplyListener* listener)
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

void HttpConnection::PostAskQuestion(int teamId, const char* stock, const char* question, AskQuestionListener* listener)
{
	RequestParamter& request = get_request_param();
	request["s"] = "questions/postaskquestion";
	request["userid"] = get_user_id();
	request["teamId"] = int2string(teamId);
	request["stock"] = stock;
	request["question"] = question;
	request["clienttype"] = get_client_type().c_str();

	http_request_asyn(listener, parse_postaskquestion, &request, HTTP_POST);
}

// 讲师团队回答提问（PC端接口）
void HttpConnection::PostAnswer(int questionId, int askuserid, const char* answer, AnswerQuestionListener* listener)
{	
	RequestParamter& request = get_request_param();
	request["s"] = "Questions/PostAnswer";
	request["userid"] = int2string(askuserid);

	request["questionid"] = int2string(questionId);
	request["teamId"] = int2string(login_userid);
	request["answer"] = answer;
	request["questionstype"] = get_client_type();

	http_request_asyn(listener, parse_postanswer, &request, HTTP_POST);
}

// 请求操盘列表(日收益排序/月收益排序/总收益排序 type:0-全部收益;1-日收益;2-月收益;默认为0 )
void HttpConnection::RequestOperateStockProfit(int type ,int team_id, int page, int size, OperateStockProfitListener* listener)
{
	g_type = type;
	g_team_id = team_id;
	g_page = page;

	char cache_file[256] = {0};
	std::string cache_content;

	if( (g_type ==1)  && (0 == g_team_id) && (g_page <= 1))
	{
		if(needOperateStocksCache[type])
		{
			needOperateStocksCache[type] = false;

			sprintf(cache_file, "operatestock_cache_%d.txt", g_type);

			ReadProtocolCache((const char*)cache_file, cache_content);

			if (!cache_content.empty())
			{
				const char* tmp = cache_content.c_str();
				parse_profitorder((char*)tmp, listener);
			}
		}
	}

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
	sprintf(tmp,"/operate/detail/id/%d/uid/%s",operateId,get_user_id().c_str());
	
	RequestParamter& request = get_request_param();
	request["s"] = tmp;


	http_request_asyn(listener, parse_profitdetail, &request);
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

// 请求操盘详情--交易记录
void HttpConnection::RequestOperateStockTransaction(int operateId, int startId, int count, OperateStockTransactionListener* listener)
{
	char tmp[128] = {0};
	
	RequestParamter& request = get_request_param();

	sprintf(tmp, "operate/stockTransaction/operateId/%d/startId/%d/count/%d", operateId, startId, count);
	request["s"] = tmp;
	
	http_request_asyn(listener, parse_operatestocktransaction, &request);
}

//请求闪屏图片
void HttpConnection::RequestSplashImage(SplashImageListener* listener)
{
	RequestParamter& request = get_request_param();
	
	request["s"] = "Index/getSplashScreen";

	http_request_asyn(listener, parse_splashimage, &request);
}

//请求PC首页导航
void HttpConnection::RequestPcGroupsPage(GroupsPageListener* listener)
{
	RequestParamter& request = get_request_param();
	
	request["s"] = "index/pcgroupspage";

	http_request_asyn(listener, parse_groupspage, &request);
}

void HttpConnection::RequestUserTeamRelatedInfo(int teamId, UserTeamRelatedInfoListener* listener)
{
	char tmp[128] = {0};
	
	RequestParamter& request = get_request_param();

	sprintf(tmp, "/Questions/getAskCount/teamId/%d/userid/%s", teamId, get_user_id().c_str());
	request["s"] = tmp;

	http_request_asyn(listener, parse_UserTeamRelatedInfo, &request);
}

// 请求问题回复--未回回答的（PC端接口）
void HttpConnection::RequestQuestionUnAnswer(int startId, int count, QuestionAnswerListener* listener)
{
	char tmp[512];
	//sprintf(tmp,"/mail/questionUnread/uid/%d",1793418);
	sprintf(tmp,"/mail/questionUnread/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
	
	RequestParamter& request = get_request_param();
	request["s"] = tmp;

	http_request_asyn(listener, parse_questionunanswer, &request);
}


// 请求评论回复--发出的评论（PC端接口）
void HttpConnection::RequestMailSendReply(int startId, int count, MailReplyListener* listener)
{
	char tmp[512];
	//sprintf(tmp,"/mail/commentPosted/uid/%d",1793418);
	sprintf(tmp,"/mail/commentPosted/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
	
	RequestParamter& request = get_request_param();
	request["s"] = tmp;

	http_request_asyn(listener, parse_sendcomment, &request);
}

// 请求评论回复--发出的评论（PC端接口）
void HttpConnection::RequestTeacherFans(int startId, int count, TeacherFansListener* listener)
{
	char tmp[512];
	sprintf(tmp,"/mail/fansList/uid/%d/size/%d/id/%d/type/%d",login_userid,count,startId,0);
	
	RequestParamter& request = get_request_param();
	request["s"] = tmp;

	http_request_asyn(listener, parse_teacherfans, &request);
}

string HttpConnection::GetPrivateServiceDetailUrl(int psid)
{
	return string("http://") + httphosts[g_curr_api_host_index] + "/mobile.php?s=/User/personalSecrets/id/" + int2string(psid) + "/uid/" + get_user_id() + "/token/" + get_user_token() + "/client/" + get_client_type();
//    	return string("http://")+"testphp.99ducaijing.cn/mobile.php?s=/User/personalSecrets/id/" + int2string(psid) + "/uid/" + get_user_id() + "/token/" + get_user_token() + "/client/" + get_client_type();
}

string HttpConnection::GetConsumeRecordUrl()
{
	return string("http://") + httphosts[g_curr_api_host_index] + "/mobile.php?s=/User/getConsumeRecord/uid/" + get_user_id() + "/token/" + get_user_token();
}


// 获取 API host
string HttpConnection::GetHttpApiHost()
{
	return string("http://") + httphosts[g_curr_api_host_index];
}

// 获取图片 host
string HttpConnection::GetImageHost()
{
	return HTTP_IMG_SVR;
}

