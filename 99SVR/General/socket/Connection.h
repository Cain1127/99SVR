#ifndef __CONNECT_H__
#define __CONNECT_H__

#include "login_cmd_vchat.h"
#include "videoroom_cmd_vchat.h"
#include "proto_message_vchat.h"
#include "commonroom_cmd_vchat.h"

#include "Socket.h"
#include "Thread.h"

#include "ConnectionListener.h"
#include "MessageListener.h"

#define MAX_MESSAGE_SIZE 8192
#define STYPE_COUNT  3

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


void InitProtocolContext(const char* path);

void ReadProtocolCache(const char *suffix_path, std::string& cache_content);

void WriteProtocolCache(const char *suffix_path, std::string& cache_content);


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
	void on_tick();
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
