#ifndef __CONNECT_H__
#define __CONNECT_H__

#include <vector>
#include "login_cmd_vchat.h"
#include "videoroom_cmd_vchat.h"
#include "proto_message_vchat.h"
#include "commonroom_cmd_vchat.h"

#include "Socket.h"
#include "Thread.h"

#include "ConnectionListener.h"
#include "MessageListener.h"

using std::vector;

#if 1

//#define LBS0 "lbs1.99ducaijing.cn:2222,lbs2.99ducaijing.cn:2222,lbs3.99ducaijing.cn:2222,58.210.107.54:2222,122.193.102.23:2222,112.25.230.249:2222";
#define LBS0 "lbs4.99ducaijing.cn:2222"
#define CONFIG_URL "http://admin.99ducaijing.com/?m=Api&c=ClientConfig&clientType=2&versionNumber=1&parameterName=lbsios"
#define HTTP_API "phpapi.99ducaijing.cn"

#else

#define LBS0 "testlbs.99ducaijing.cn:2222"
#define CONFIG_URL "http://121.12.118.32/caijing/?m=Api&c=ClientConfig&clientType=4&versionNumber=1&parameterName=lbs"
#define HTTP_API "testphp.99ducaijing.cn"

#endif

#define HTTP_IMG_SVR "http://phppic.99ducaijing.cn"
#define HTTP_ICON_SVR "http://phppic.99ducaijing.cn"
#define HTTP_IMG_DFS_SVR "http://phppic.99ducaijing.cn"
#define HTTP_BANNER_SVR "http://phpapi.99ducaijing.cn"

#define MAX_MESSAGE_SIZE 8192
#define STYPE_COUNT  3

extern char lbs_from_file[256];
extern char lbs_from_http[256];
extern char lbs_from_set[256];
extern char lbs_curr[256];
extern char lbs_splited[8][64];
extern int lbs_count;

extern Socket g_socket;
extern char cache_path[256];
extern bool in_room;
extern bool need_join_room;
extern bool socket_closed;
extern bool socket_connecting;

extern char connect_ip[32];
extern short connect_port;

extern char send_buf[MAX_MESSAGE_SIZE];
extern char recv_buf[MAX_MESSAGE_SIZE];


extern UserLogonSuccess2 loginuser;
extern UserLogonReq4 login_req4;
extern UserLogonReq5 login_req5;

extern uint32 login_reqv;
extern uint32 login_nmobile;
extern uint32 login_version;
extern uint32 login_userid;
extern string login_password;
extern SessionTokenResp login_token;

extern JoinRoomReq join_req;
extern JoinRoomResp room_info;

extern uint32 main_room_id;
extern time_t last_joinroom_time;


extern vector<string> httphosts;


void InitProtocolContext(const char* path);
void ReadProtocolCache(const char *suffix_path, std::string& cache_content);
void WriteProtocolCache(const char *suffix_path, std::string& cache_content);

void get_http_servers_from_lbs_asyn();

class Connection
{

private:



protected:


	int main_cmd;

	
	ConnectionListener* conn_listener;
	MessageListener* message_listener;


	
	void SendMsg_Hello();

	virtual void SendMsg_Ping() = 0;

	int send(const char* buf, int len);

	int recv(char* buf, int offset, int len);

	int close();

	int get_error();

	void send_message(int sub_cmd, void* req, int req_len);

	int read_message(void);

	virtual void on_do_connected() = 0;
	virtual void on_tick(time_t ctime) = 0;
	void on_dispatch_message(void* msg);

	void on_connected();
	void on_connect_error(int err_code);
	void on_io_error(int err_code);

	void do_connect_error();
	void do_io_error();
	void do_error();

public:

	void SetLBS(char* lbs);
	void RegisterConnectionListener(ConnectionListener* connection_listener);
	void RegisterMessageListener(MessageListener* message_listener);
	virtual void DispatchSocketMessage(void* msg) = 0;

	void Reconnect();
	void OnNetworkChanged();

	void connect_from_lbs_asyn();
	void connect_asyn(const char* host, short port);
	int connect(const char* host, short port);

	void read_loop(void);
	void start_read_thread(void);

	void report_connect_error(int err_code);
	void get_host_form_lbs(char* lbs);

	string get_error_desc(int err_code);

	bool is_closed();

	Connection(void);
	virtual ~Connection(void);
};


#define SEND_MESSAGE2(sub_cmd, CMDXXX_t, req)                   \
	protocol::COM_MSG_HEADER* pHead = (protocol::COM_MSG_HEADER*)send_buf;        \
	pHead->length = sizeof(protocol::COM_MSG_HEADER) + sizeof(CMDXXX_t); \
	pHead->version = protocol::MDM_Version_Value;                        \
	pHead->checkcode = 0;                                      \
	pHead->maincmd = (short)main_cmd;                          \
	pHead->subcmd = (short)sub_cmd;                            \
	memcpy(pHead->content, req, sizeof(CMDXXX_t));             \
	this->send((const char*)pHead, pHead->length);


#define SEND_MESSAGE(sub_cmd, req)                   \
	memset(send_buf, 0, MAX_MESSAGE_SIZE);       \
	protocol::COM_MSG_HEADER* pHead = (protocol::COM_MSG_HEADER*)send_buf;        \
	pHead->length = sizeof(protocol::COM_MSG_HEADER) + req.ByteSize(); \
	pHead->version = protocol::MDM_Version_Value;                        \
	pHead->checkcode = 0;                                      \
	pHead->maincmd = (short)main_cmd;                          \
	pHead->subcmd = (short)sub_cmd;                            \
	req.SerializeToArray(pHead->content, req.ByteSize());             \
	this->send((const char*)pHead, pHead->length);

#define SEND_MESSAGE_F(param_maincmd, sub_cmd, req)                   \
	memset(send_buf, 0, MAX_MESSAGE_SIZE);       \
	protocol::COM_MSG_HEADER* pHead = (protocol::COM_MSG_HEADER*)send_buf;        \
	pHead->length = sizeof(protocol::COM_MSG_HEADER) + req.ByteSize(); \
	pHead->version = protocol::MDM_Version_Value;                        \
	pHead->checkcode = 0;                                      \
	pHead->maincmd = (short)param_maincmd;                          \
	pHead->subcmd = (short)sub_cmd;                            \
	req.SerializeToArray(pHead->content, req.ByteSize());             \
	this->send((const char*)pHead, pHead->length);

#define SEND_MESSAGELIST(sub_cmd, head, req)                   \
	memset(send_buf, 0, MAX_MESSAGE_SIZE);       \
	protocol::COM_MSG_HEADER* pHead = (protocol::COM_MSG_HEADER*)send_buf;        \
	pHead->length = sizeof(protocol::COM_MSG_HEADER) + head.ByteSize() + req.ByteSize(); \
	pHead->version = protocol::MDM_Version_Value;                        \
	pHead->checkcode = 0;                                      \
	pHead->maincmd = (short)main_cmd;                          \
	pHead->subcmd = (short)sub_cmd;                            \
	head.SerializeToArray(pHead->content, head.ByteSize());             \
	req.SerializeToArray(pHead->content + head.ByteSize(), req.ByteSize());             \
	this->send((const char*)pHead, pHead->length);

#define SEND_MESSAGE_EX(sub_cmd, req, exlen)                   \
	memset(send_buf, 0, MAX_MESSAGE_SIZE);       \
	protocol::COM_MSG_HEADER* pHead = (protocol::COM_MSG_HEADER*)send_buf;        \
	pHead->length = sizeof(protocol::COM_MSG_HEADER) + req.ByteSize() + exlen; \
	pHead->version = protocol::MDM_Version_Value;                        \
	pHead->checkcode = 0;                                      \
	pHead->maincmd = (short)main_cmd;                          \
	pHead->subcmd = (short)sub_cmd;                            \
	req.SerializeToArray(pHead->content, req.ByteSize());             \
	this->send((const char*)pHead, pHead->length);

#define ON_MESSAGE(listener, InfoClass, OnMethod) \
	{ \
		if ( listener != NULL ) \
		{ \
			InfoClass info; \
			info.ParseFromArray(body, info.ByteSize()); \
			listener->OnMethod(info); \
		} \
	}



#endif
