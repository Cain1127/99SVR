#include "stdafx.h"
#include "platform.h"
#include "Connection.h"
#include "Http.h"

#define STYPE_COUNT  3

//void (Connection::*PConnect)(const char* host, short port);//Ö¸ÕëµÄÉùÃ÷

static Connection* _self_ = NULL;

static const char* lbs0 = "lbs1.99ducaijing.cn:2222,lbs2.99ducaijing.cn:2222,58.210.107.54:2222,122.193.102.23:2222,112.25.230.249:2222";//,112.25.230.249:2222
//static const char* lbs0 = "testlbs.99ducaijing.cn:2222";
static char lbs[256];

static time_t start_connect_time = 0;
static int lbs_count;
static int lbs_err_counter;
static int get_host_index;
static char host_from_lbs[8][128];
static char lbss[STYPE_COUNT][8][24];
static int lbs_counter[STYPE_COUNT];
static bool islogining = false;
static bool isfirst_read = true;
static bool isfirst_error = true;

static char first_login_server[24];
static int connect_stype_index;
static int connect_stype_counter[STYPE_COUNT];
static char conncted_host[384];

static ThreadLock conn_lock;

void parse_ip_port(char* s, char* ip, short& port)
{
	char* e = strchr(s, ':');
	int len = e - s;
	memcpy(ip, s, len);
	ip[len] = 0;

	port = atoi(e + 1);
}


ThreadVoid get_host_form_lbs_runnable(void* param)
{

	char* lbs = (char*)param;
	char ip[64];
	short port;
	parse_ip_port(lbs, ip, port);

	//char recvbuf[HTTP_RECV_BUF_SIZE];
	Http http;
	
	char url[384];
	strcpy(url, "/tygetlogon");
	if (conncted_host[0] != '\0')
	{
		strcat(url, "?no=");
		strcat(url, conncted_host);
	}
	LOG("url:%s", url);
	
	char* content = http.GetString(ip, port, url);
	if (content != NULL && strlen(content) > 10)
	{
		Thread::lock(&conn_lock);
		char* end = strchr(content, '|');
		if (end != NULL)
		{
			*end = '\0';
		}

		++get_host_index;
		strcpy(host_from_lbs[get_host_index], content);
		LOG("index:%d time:%ld lbs:%s host:%s", get_host_index, clock(), ip, host_from_lbs[get_host_index]);
		Thread::unlock(&conn_lock);

		if (!islogining)
		{
			islogining = true;
			LOG("****DO LOGIN***");

			const char *d = ",";
			char *p = strtok(content, d);
			int stype;
			while (p)
			{
				if (strlen(p) == 1)
				{
					LOG("stype:%s", p);
					stype = p[0] - '0';
				}
				else
				{
					char ip[24];
					short port;
					parse_ip_port(p, ip, port);
					LOG("first login server: %s:%d", ip, port);
					strcpy(first_login_server, p);
					connect_stype_index = stype;
					(_self_)->connect(ip, port);
					break;
				}

				p = strtok(NULL, d);
			}  // end while split host
		} // end if logining
	}   
	else
	{
		Thread::lock(&conn_lock);
		lbs_err_counter++;
		LOG("lbs count:%d:%d", lbs_err_counter, lbs_count);
		Thread::unlock(&conn_lock);
	}

	if (lbs_err_counter == lbs_count)
	{
		//(_self_)->report_connect_error(-2);
		time_t time0 = time(0);
		if (time0 - start_connect_time > 60)
		{
			start_connect_time = 0;
			(_self_)->report_connect_error(-3);
		}
		else
		{
			conncted_host[0] = '\0';
			(_self_)->conenct_from_lbs();
		}
	}

	ThreadReturn;
}

void Connection::conenct_from_lbs()
{
	_self_ = this;
	Thread::initlock(&conn_lock);
	
	lbs_count = 0;
	lbs_err_counter = 0;
	get_host_index = -1;
	memset(host_from_lbs, 0, sizeof(host_from_lbs));
	memset(lbss, 0, sizeof(lbss));
	memset(lbs_counter, 0, sizeof(lbs_counter));
	islogining = false;
	isfirst_read = true;
	isfirst_error = true;

	memset(first_login_server, 0, sizeof(first_login_server));
	memset(connect_stype_counter, 0, sizeof(connect_stype_counter));
	connect_stype_index = 0;

	strcpy(lbs, lbs0);

	if (start_connect_time == 0)
	{
		start_connect_time = time(0);
		conncted_host[0] = '\0';
	}

	const char *d = ",";
	char *p = strtok(lbs, d);
	while (p)
	{
		lbs_count++;
		Thread::start(get_host_form_lbs_runnable, p);
		p = strtok(NULL, d);
	}

}

void Connection::do_error()
{
	if (isfirst_error)
	{
		isfirst_error = false;

		memset(lbss, 0, sizeof(lbss));
		memset(lbs_counter, 0, sizeof(lbs_counter));

		LOG("size:%d:%d", sizeof(lbss), sizeof(lbs_counter));

		for (int i = 0; i <= get_host_index; i++)
		{

			const char *d = ",";
			char* content = host_from_lbs[i];
			char *p = strtok(content, d);
			int stype = -1;
			while (p)
			{
				//printf("%s\n", p);

				if (strlen(p) == 1)
				{
					stype = p[0] - '0';
					LOG("stype:%d", stype);
				}
				else
				{
					if (stype >= 0 && stype < STYPE_COUNT)
					{
						int n = lbs_counter[stype];
						int j = 0;
						for (; j < n; j++)
						{
							if (strcmp(p, lbss[stype][j]) == 0)
							{
								LOG("host existed:%s", p);
								break;
							}
						}
						if (j == n)
						{
							strcpy(lbss[stype][n], p);
							LOG("add lbs:%d:%s", n, lbss[stype][n]);
							lbs_counter[stype]++;
						}
					}
				}

				p = strtok(NULL, d);
			}
		}  // end for all lbs return
	} // end if is first login

	int none_counter = 0;
	while (none_counter < STYPE_COUNT)
	{
		connect_stype_index = (connect_stype_index + 1) % STYPE_COUNT;
		int curr_stype_counter = connect_stype_counter[connect_stype_index];
		if (strcmp(first_login_server, lbss[connect_stype_index][curr_stype_counter]) == 0)
		{
			connect_stype_counter[connect_stype_index]++;
			curr_stype_counter = connect_stype_counter[connect_stype_index];

			LOG("is first login server, try next..");
		}

		if (lbss[connect_stype_index][curr_stype_counter][0] != '\0')
		{
			char ip[24];
			short port;
			char* p = lbss[connect_stype_index][curr_stype_counter];
			parse_ip_port(p, ip, port);
			LOG("try... login server: stype:%d host %s:%d", connect_stype_index, ip, port);
			connect_stype_counter[connect_stype_index]++;
			(_self_)->connect(ip, port);
			break;
		}
		else
		{
			none_counter++;
			LOG("stype end:%d", connect_stype_index);
		}
	}

	if (none_counter >= STYPE_COUNT)
	{
		LOG("all host tried.. all failed");

		time_t time0 = time(0);
		if (time0 - start_connect_time > 60)
		{
			start_connect_time = 0;
			report_connect_error(get_error());
		} 
		else
		{
			conncted_host[0] = '\0';
			for (int i = 0; i < STYPE_COUNT; i++)
			{
				for (int j = 0; j < lbs_counter[i]; j++)
				{
					char* host = lbss[i][j];
					char* end = strchr(host, ':');
					*end = '\0';
					strcat(conncted_host, host);
					strcat(conncted_host, ",");
				}
			}
			conenct_from_lbs();
		}
	}

}

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
		isfirst_read = true;
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
		if (IS_SOCKET_CLOSED(err_no))  // Socket operation on non-socket 
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
		int err_code = get_error();
		if (IS_SOCKET_CLOSED(err_code))    // Socket operation on non-socket 
		{
			LOG("socket closed.");
		}
		else
		{
			LOG("send errno:%d:%d", ret, err_code);
			on_io_error(err_code);
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


	Socket* tsocket = socket;
	socket = NULL;

	int ret = tsocket->close_();

	delete tsocket;

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
	conn->read_loop();

	ThreadReturn;
}

void Connection::read_loop(void)
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
				if (isfirst_read)
				{
					LOG("first recv time out..error..");
					on_io_error(err_no);
					return;
				}
			}
			
		}

		if (ret > 0 && isfirst_read)
		{
			if (conn_listener != NULL)
			{
				conn_listener->OnConnected();
			}
			start_connect_time = 0;
		}

		isfirst_read = false;

		time_t curr_time = time(0);
		if (curr_time - last_ping_time > 10)
		{
			SendMsg_Ping();
			last_ping_time = time(0);
			LOG("send ping");
		}

		
		 LOG("read no:%d", read_i);
		 if (read_i > 23) {
			 //socket->close_();
			 //close();
		 }
	}
}

void Connection::do_connect_error()
{
	do_error();
}

void Connection::do_io_error()
{
	do_error();
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
	on_do_connected();
}

void Connection::on_connect_error(int err_code)
{
	do_connect_error();
}

void Connection::on_io_error(int err_code)
{
	LOG("on_io_error: %d", err_code);

	if (socket == NULL) return;

	close();

	if (start_connect_time != 0)  // 5 + 2
	{
		do_io_error();
	}
	else
	{
		conenct_from_lbs();
	}
}

void Connection::report_connect_error(int err_code)
{
	//if (socket == NULL) return;

	close();

	if (conn_listener != NULL)
	{
		conn_listener->OnConnectError(err_code);
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
