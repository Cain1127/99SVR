#include "proto_cmd_vchat.h"
#include "message_vchat.h"

#include "Socket.h"
#include "Thread.h"

#include "ConnectionListener.h"

#define CONN_ERR_READ  0
#define CONN_ERR_WRITE  1

#define MAX_MESSAGE_SIZE 8192


class Connection
{

private:



protected:

	char send_buf[MAX_MESSAGE_SIZE];
	char recv_buf[MAX_MESSAGE_SIZE];

	int main_cmd;
	time_t last_ping_time;

	Socket* socket;
	
	ConnectionListener* conn_listener;


	
	void SendMsg_Hello();

	virtual void SendMsg_Ping() = 0;

	bool is_closed();

	int send(const char* buf, int len);

	int recv(char* buf, int offset, int len);

	int close();

	int get_error();

	void send_message(int sub_cmd, void* req, int req_len);

	int read_message(void);

	virtual void on_do_connected() = 0;
	virtual void on_dispatch_message(void* msg) = 0;

	void on_connected();
	void on_connect_error(int err_code);
	void on_io_error(int err_code);

	void do_connect_error();
	void do_io_error();
	void do_error();

public:

	void RegisterConnectionListener(ConnectionListener* connection_listener);
	virtual void DispatchSocketMessage(void* msg) = 0;

	void conenct_from_lbs();
	int connect(const char* host, short port);

	void read_loop(void);
	void start_read_thread(void);

	void report_connect_error(int err_code);

	Connection(void);
	virtual ~Connection(void);
};



#define SEND_MESSAGE2(sub_cmd, CMDXXX_t, req)                   \
	COM_MSG_HEADER* pHead = (COM_MSG_HEADER*)send_buf;        \
	pHead->length = sizeof(COM_MSG_HEADER)+sizeof(CMDXXX_t); \
	pHead->version = MDM_Version_Value;                        \
	pHead->checkcode = 0;                                      \
	pHead->maincmd = (short)main_cmd;                          \
	pHead->subcmd = (short)sub_cmd;                            \
	memcpy(pHead->content, req, sizeof(CMDXXX_t));             \
	this->send((const char*)pHead, pHead->length);


#define SEND_MESSAGE(sub_cmd, req)                   \
	memset(send_buf, 0, MAX_MESSAGE_SIZE);       \
	COM_MSG_HEADER* pHead = (COM_MSG_HEADER*)send_buf;        \
	pHead->length = sizeof(COM_MSG_HEADER)+req.ByteSize(); \
	pHead->version = MDM_Version_Value;                        \
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

