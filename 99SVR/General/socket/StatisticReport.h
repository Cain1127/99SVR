#include "Util.h"

void get_out_ip();

//登陆失败
void ReportLoginFailed(int login_type, rstring login_id, rstring server_ip);

//注册失败
void ReportRegisterFailed(int reg_type, rstring server_ip, rstring err);

//获取大厅房间列表失败
void ReportGetRoomListFailed(int userid, int room_type, rstring server_ip);

//进房间失败
void ReportJoinRoomFailed(int userid, int room_type, int roomid, rstring server_ip, rstring err);

//获取房间成员列表失败
void ReportGetRoomUserListFailed(int userid, int room_type, int roomid, rstring server_ip, rstring err);

//直播质量数据
void ReportVideoWarn(int userid, int roomid, int warn_type, rstring server_ip);

//崩溃数据
void ReportCrash(rstring os, rstring version_name, rstring err);

//打开大厅首页失败
void ReportOpenHomepageFailed(int userid, rstring server_ip);

//上报本机安装了哪些软件
void ReportLocalAppData(rstring os, rstring serial_number, rstring version_name, rstring app_list);
