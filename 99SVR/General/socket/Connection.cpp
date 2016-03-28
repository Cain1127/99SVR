#include "platform.h"
#include "Connection.h"
#include "Thread.h"

void Connection::RegisterConnectionListener(
		ConnectionListener* connection_listener)
{
	conn_listener = connection_listener;
}

int Connection::connect(const char* host, short port)
{
	socket = new Socket();
	int ret = socket->connect(host, port);

	if (ret == 0)
	{
		on_connected();
	}
	else
	{
		on_connect_error(get_error());
	}

	return ret;
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
	if (socket == NULL)
		return -1;

	int ret = socket->recv(buf + offset, len);

	if (ret <= 0)
	{
		int err_no = get_error();
		if (err_no == SOCKET_NONE)  // Socket operation on non-socket 
		{
			LOG("socket closed.");
		}
		else
		{
			if (err_no == SOCKET_TIMEOUT) // timed out
			{
				LOG("recv time out");
			}
			else
			{
				LOG("recv err: %d", err_no);
				on_io_error(err_no);
			}
		}

		return -1;
	}

	return ret;
}

int Connection::send(const char* buf, int len)
{
	if (socket == NULL)
		return -1;

	int ret = socket->send(buf, len);

	if (ret <= 0)
	{
		if (get_error() == SOCKET_NONE)    // Socket operation on non-socket 
		{
			LOG("socket closed.");
		}
		else
		{
			LOG("send errno:%d:%d", ret, get_error());
			on_io_error(get_error());
		}

		return -1;
	}
	else
	{
		LOG("send:%d:%d.", ret, get_error());
	}

	return ret;
}

int Connection::close()
{
	if (socket == NULL)
		return -1;

	int ret = socket->close_();

	socket = NULL;

	return ret;
}

int Connection::get_error()
{
	if (socket == NULL)
		return -1;

	return socket->get_error();
}

void Connection::send_message(int sub_cmd, void* req, int req_len)
{
	COM_MSG_HEADER* pHead = (COM_MSG_HEADER*) send_buf;
	pHead->length = sizeof(COM_MSG_HEADER) + req_len;
	pHead->version = MDM_Version_Value;
	pHead->checkcode = 0;
	pHead->maincmd = (short) main_cmd;
	pHead->subcmd = (short) sub_cmd;

	memcpy(pHead->content, req, req_len);

	socket->send((const char*) pHead, pHead->length);
}

int Connection::read_message(void)
{
	int recvLen = 0;
	do
	{
		int len = recv(recv_buf, recvLen, 4 - recvLen);
		if (len < 0)
		{
			//LOG("read message length error: %d", len);
			return -1;
		}
		recvLen += len;
	} while (recvLen != 4);

	int msgLen = *((int*) recv_buf);
	if (msgLen <= 0 || msgLen > MAX_MESSAGE_SIZE)
	{
		LOG("message len error: %d", msgLen);
		on_io_error(-1);
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
	Connection* conn = (Connection*)param;
	conn->start_read();

#ifndef WIN
	return NULL;
#endif
}

void Connection::start_read(void)
{
	static int read_i = 0;

	while (!is_closed())
	{
		read_i++;
		int ret = read_message();

		if (ret < 0)
		{
			int err_no = get_error();

			if (err_no != SOCKET_TIMEOUT)  // 10060 =  time out
			{
				LOG("exit read thread: exit code:%d", err_no);
				return;
			}
			else
			{
				//LOG("read time out:%d", socket->get_error());
			}
		}

		time_t curr_time = time(0);
		if (curr_time - last_ping_time > 10)
		{
			SendMsg_Ping();
			last_ping_time = time(0);
			LOG("send ping");
		}


		 LOG("read no:%d", read_i);

		 /*if (read_i > 32) {
			 socket->close_();
		 }*/
	}
}

void Connection::start_read_thread(void)
{
	Thread::start(read_runnable, this);
}

bool Connection::is_closed()
{
	return socket == NULL;
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
	LOG("on_io_error: %d", err_code);

	close();

	if (conn_listener != NULL && err_code != -1)
	{
		conn_listener->OnIOError(err_code);
	}
}

Connection::Connection(void) :
		socket(NULL), conn_listener(NULL), last_ping_time(0)
{
}

Connection::~Connection(void)
{
	if (socket != NULL)
	{
		delete socket;
	}
}
