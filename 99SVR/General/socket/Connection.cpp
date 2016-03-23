#include "StdAfx.h"
#include "Connection.h"
#include "Thread.h"

void Connection::RegisterConnectionListener(ConnectionListener* connection_listener)
{
	conn_listener = connection_listener;
}

void Connection::connect(const char* host, short port)
{
	socket = new Socket();
	int ret = socket->connect(host, port);
	if (ret == 0) 
	{
		on_connected();
	}
	else
	{
		on_connect_error(-1);
	}
}


void Connection::SendMsg_Hello()
{
	CMDClientHello_t hello;
	hello.param1 = 12;
	hello.param2 = 8;
	hello.param3 = 7;
	hello.param4 = 1;

	SEND_MESSAGE2(Sub_Vchat_ClientHello, CMDClientHello_t, &hello);
}


int Connection::recv(char* buf, int offset, int len) 
{
    LOG("recv********************");
	int ret = socket->recv(buf + offset, len);
    LOG("recv********************");

	if (ret < 0)
	{
		on_io_error(CONN_ERR_READ);
	}

	return ret;
}

int Connection::send(const char* buf, int len)
{
	int ret = socket->send(buf, len);
	if (ret < 0)
	{
		on_io_error(CONN_ERR_WRITE);
	}
	
	return ret;
}


void Connection::send_message(int sub_cmd, void* req, int req_len)
{
	COM_MSG_HEADER* pHead = (COM_MSG_HEADER*) send_buf;
	pHead->length = sizeof(COM_MSG_HEADER) + req_len;
	pHead->version = MDM_Version_Value;
	pHead->checkcode = 0;
	pHead->maincmd = (short)main_cmd;
	pHead->subcmd = (short)sub_cmd;

	memcpy(pHead->content, req, req_len);

	socket->send((const char*)pHead, pHead->length);
}

int Connection::read_message(void) 
{
	int recvLen = 0;
	do 
	{
		int len = recv(recv_buf, recvLen, 4 - recvLen);
		if (len < 0) 
		{
			LOG("read message length error: %d", len);
			return -1;
		}
		recvLen += len;
	} while (recvLen != 4);
	
	int msgLen = *((int*)recv_buf);
	if (msgLen <= 0 || msgLen > MAX_MESSAGE_SIZE) 
	{
		LOG("message len error: %d", msgLen);
		return -1;
	}

	do 
	{
		int len = recv(recv_buf, recvLen, msgLen - recvLen);
		if (len < 0) 
		{
			LOG("read message content error: %d", recvLen);
			return -1;
		}
		recvLen += len;
	} while (recvLen != msgLen);

	uint8* new_msg = new uint8[msgLen + 1];
	memcpy(new_msg, recv_buf, msgLen);
	new_msg[msgLen] = 0;

	on_dispatch_message(new_msg);

	return recvLen;
}


ThreadVoid read_runnable(void* param)
{
	Connection* conn = (Connection*) param;
	conn->start_read();
    
    return NULL;
}


void Connection::start_read(void)
{
	while ( read_message() > 0 ) 
	{
	}
}

void Connection::start_read_thread(void)
{
	Thread::start(read_runnable, this);
}

void Connection::on_connected()
{
	if (conn_listener != NULL)
	{
		conn_listener->OnConnected();
	}
}

void Connection::on_connect_error(int err_code)
{
	if (conn_listener != NULL)
	{
		conn_listener->OnConnectError(err_code);
	}
}

void Connection::on_io_error(int err_code)
{
	if (conn_listener != NULL)
	{
		conn_listener->OnIOError(err_code);
	}
}

Connection::Connection(void) : socket(NULL), conn_listener(NULL)
{
}

Connection::~Connection(void)
{
}
