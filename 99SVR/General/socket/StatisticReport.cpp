#include "StatisticReport.h"
#include "platform.h"
#include "Http.h"
#include "Thread.h"
#include "http_common.h"

#define REPORT_API "http://qs.99live.cn/AnalyticStatistics/"

void get_out_ip()
{
	Http http;
	char* content = http.request("http://ip.cn/");
	if (content)
	{
		LOG("IP:%s", content);
	}
}

ThreadVoid report_runnable(void* vparam)
{
	RequestParamter* param = (RequestParamter*)vparam;

	Http http(HTTP_POST);
	http.request(REPORT_API, param);

	delete param;

	ThreadReturn;
}

void report_asyn(RequestParamter* param)
{
	Thread::start(report_runnable, param);
}


void ReportLoginFailed(int login_type, rstring login_id, rstring server_ip)
{
	RequestParamter& param = get_request_param();
	param["ReportItem"] = "Login";
	param["ClientType"] = get_client_type();
	param["LoginType"] = int2string(login_type);
	param["UserId"] = "";
	param["UserName"] = login_id;
	param["MobilePhone"] = "";
	param["ServerIP"] = server_ip;
	param["ClientIP"] = "";
	param["Error"] = "";

	report_asyn(&param);
}

void ReportRegisterFailed(int reg_type, rstring server_ip)
{
	RequestParamter& param = get_request_param();
	param["ReportItem"] = "Register";
	param["ClientType"] = get_client_type();
	param["RegType"] = int2string(reg_type);
	param["ServerIP"] = server_ip;
	param["ClientIP"] = "";
	param["Error"] = "";

	report_asyn(&param);
}

//获取大厅房间列表失败
void ReportGetRoomListFailed(int userid, int room_type, rstring server_ip)
{
	RequestParamter& param = get_request_param();
	param["ReportItem"] = "GetRoomList";
	param["ClientType"] = get_client_type();
	param["UserId"] = int2string(userid);
	param["RoomType"] = int2string(room_type);
	param["ServerIP"] = server_ip;
	param["ClientIP"] = "";
	param["Error"] = "";

	report_asyn(&param);
}

//进房间失败
void ReportJoinRoomFailed(int userid, int room_type, int roomid, rstring server_ip, rstring err)
{
	RequestParamter& param = get_request_param();
	param["ReportItem"] = "IntoRoom";
	param["ClientType"] = get_client_type();
	param["UserId"] = int2string(userid);
	param["RoomType"] = int2string(room_type);
	param["RoomId"] = int2string(roomid);
	param["ServerIP"] = server_ip;
	param["ClientIP"] = "";
	param["Error"] = err;

	report_asyn(&param);
}

//获取房间成员列表失败
void ReportGetRoomUserListFailed(int userid, int room_type, int roomid, rstring server_ip, rstring err)
{
	RequestParamter& param = get_request_param();
	param["ReportItem"] = "GetRoomUserList";
	param["ClientType"] = get_client_type();
	param["UserId"] = int2string(userid);
	param["RoomType"] = int2string(room_type);
	param["RoomId"] = int2string(roomid);
	param["ServerIP"] = server_ip;
	param["ClientIP"] = "";
	param["Error"] = err;

	report_asyn(&param);
}

//直播质量数据
void ReportVideoWarn(int userid, int roomid, int warn_type, rstring server_ip)
{
	RequestParamter& param = get_request_param();
	param["ReportItem"] = "DirectSeedingQuality";
	param["ClientType"] = get_client_type();
	param["UserId"] = int2string(userid);
	param["RoomId"] = int2string(roomid);
	param["ErrorType"] = int2string(warn_type);
	param["ServerIP"] = server_ip;
	param["ClientIP"] = "";
	param["Error"] = "";

	report_asyn(&param);
}

//崩溃数据
void ReportCrash(rstring os, rstring version_name, rstring err)
{
	RequestParamter& param = get_request_param();
	param["ReportItem"] = "CrashData";
	param["ClientType"] = get_client_type();
	param["Os"] = os;
	param["VersionNumber"] = "";
	param["VersionName"] = version_name;
	param["ClientIP"] = "";
	param["Error"] = err;

	report_asyn(&param);
}


//打开大厅首页失败
void ReportOpenHomepageFailed(int userid, rstring server_ip)
{
	RequestParamter& param = get_request_param();
	param["ReportItem"] = "OpenFrontPageHall";
	param["ClientType"] = get_client_type();
	param["UserId"] = int2string(userid);
	param["ServerIP"] = server_ip;
	param["ClientIP"] = "";
	param["Error"] = "";

	report_asyn(&param);
}

void ReportLocalAppData(rstring os, rstring serial_number, rstring version_name, rstring app_list)
{
	RequestParamter& param = get_request_param();
	param["ReportItem"] = "UserLocalAppData";
	param["ClientType"] = get_client_type();
	param["Os"] = os;
	param["SerialNumber"] = serial_number;
	param["VersionName"] = version_name;
	param["AppList"] = app_list;

	report_asyn(&param);
}



