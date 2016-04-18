/**
 * todo
 * ���Զ�� close
 */
#include <stdio.h>
#include "platform.h"
#include "Connection.h"
#include "Http.h"
#include "Json.h"
#include "StatisticReport.h"

static char cache_path[256] = { 0 };

static const char* lbs0 = "lbs1.99ducaijing.cn:2222,lbs2.99ducaijing.cn:2222,lbs3.99ducaijing.cn:2222,58.210.107.54:2222,122.193.102.23:2222,112.25.230.249:2222";//,112.25.230.249:2222
//static const char* lbs0 = "testlbs.99ducaijing.cn:1999";
static char lbs_from_file[256] = {0};
static char lbs_from_http[256] = {0};
static char lbs_from_set[256] = {0};
static char lbs_curr[256] = {0};
static int lbs_count;


void SetProtocolCachePath(const char* path)
{
	strcpy(cache_path, path);
}

void Connection::SetLBS(char* lbs)
{
	is_set_lbs = true;
	strcpy(lbs_from_set, lbs);
}

char* get_lbs_from_file()
{
	char filename[256];
	strcpy(filename, cache_path);
	strcat(filename, FILE_SEPARATOR);
	strcat(filename, "lbs.dat");

	FILE *fp;
	if ((fp = fopen(filename, "r")) == NULL)
	{
		return NULL;
	}

	char* ret = fgets(lbs_from_file, 256, fp);
	
	fclose(fp);

	return ret;
}

int save_lbs_to_file(const char* lbs)
{
	char filename[256];
	strcpy(filename, cache_path);
	strcat(filename, FILE_SEPARATOR);
	strcat(filename, "lbs.dat");

	FILE *fp;
	if ((fp = fopen(filename, "w")) == NULL)
	{
		LOG("can not open lbs file to save.");
		return -1;
	}

	int ret = fputs(lbs, fp);

	fclose(fp);

	return ret;
}
#if 0
ThreadVoid get_lbs_from_http(void* param)
{
	Http http;
	char* json = http.request("http://admin.99ducaijing.com/?m=Api&c=ClientConfig&clientType=4&versionNumber=1&parameterName=lbs");
	//char* json = http.request("http://121.12.118.32/caijing/?m=Api&c=ClientConfig&clientType=4&versionNumber=1&parameterName=lbs");
	if (json)
	{
		JsonReader reader;
		JsonValue root;
		reader.parse(json, root);

		if (root.isObject())
		{
			const char* lbs = root["lbs"].asCString();
			strcpy(lbs_from_http, lbs);

			save_lbs_to_file(lbs);
			LOG("get lbs from http:%s", lbs);

			ThreadReturn;
		}
	}

	*lbs_from_http = '\0';
	LOG("get lbs from http faild");

	ThreadReturn;
}
#endif

typedef struct LbsThreadParam
{
	Connection* conn;
	char lbs[64];
} LbsThreadParam;

typedef struct ConnectThreadParam
{
	Connection* conn;
	char ip[32];
	short port;
}ConnectThreadParam;

ThreadVoid get_host_form_lbs_runnable(void* param)
{
	LbsThreadParam* p = (LbsThreadParam*)param;
    p->conn->get_host_form_lbs(p->lbs);
	delete p;
	ThreadReturn;
}

void parse_ip_port(char* s, char* ip, short& port)
{
	*ip = '\0';
	port =0;

	char* e = strchr(s, ':');
	if ( e )
	{
		int len = e - s;
		memcpy(ip, s, len);
		ip[len] = 0;

		port = atoi(e + 1);
	}
}

void Connection::get_host_form_lbs(char* lbs)
{

	char ip[64];
	short port;
	parse_ip_port(lbs, ip, port);

	char url[384];
	strcpy(url, lbs_type);
	if (*connected_host)
	{
		strcat(url, "?no=");
		strcat(url, connected_host);
	}
	LOG("url:%s", url);

	Http http;
	char* content = http.request(ip, port, url);
	if (content != NULL && strlen(content) > 10)
	{
		Thread::lock(&conn_lock);
		char* end = strchr(content, '|');
		if (end)
			*end = '\0';

		strcpy(host_from_lbs[get_host_index], content);
		LOG("index:%d time:%ld lbs:%s host:%s", get_host_index, clock(), ip, host_from_lbs[get_host_index]);
		get_host_index++;

		if (!islogining)
		{
			const char *d = ",;";
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
					char ip[32];
					short port;
					parse_ip_port(p, ip, port);
					if ( *ip && port )
					{
						LOG("****DO CONNECT***");
						LOG("first login server: %s:%d", ip, port);
						strcpy(first_login_server, p);
						connect_stype_index = stype;
						islogining = true;
						connect_asyn(ip, port);
					}
					break;
				}

				p = strtok(NULL, d);
			}  // end while split host
		} // end if logining
		Thread::unlock(&conn_lock);
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
		connect_start_time = 0;
		report_connect_error(-3);
	}
}

void Connection::connect_from_lbs_asyn()
{
	
	lbs_err_counter = 0;
	get_host_index = 0;
	memset(host_from_lbs, 0, sizeof(host_from_lbs));
	memset(lbss, 0, sizeof(lbss));
	memset(lbs_counter, 0, sizeof(lbs_counter));
	islogining = false;
	isfirst_read = true;
	isfirst_error = true;

	memset(first_login_server, 0, sizeof(first_login_server));
	memset(connect_stype_counter, 0, sizeof(connect_stype_counter));
	connect_stype_index = 0;

	memset(connect_ip, 0, sizeof(connect_ip));
	connect_port = 0;

	if (!is_set_lbs)
	{
		const char* lbs = lbs0;
//		if (*cache_path)
//		{
//			lbs = get_lbs_from_file();
//			if (lbs == NULL)
//			{
//				get_lbs_from_http(NULL);
//				if (*lbs_from_http)
//				{
//					lbs = lbs_from_http;
//					LOG("use lbs from http:%s", lbs);
//				}
//				else
//				{
//					lbs = lbs0;
//					LOG("use lbs from default:%s", lbs);
//				}
//			}
//			else
//			{
//				LOG("use lbs from file:%s", lbs);
//				Thread::start(get_lbs_from_http, NULL);
//			}
//		}
		
		strcpy(lbs_curr, lbs);
	}
	else
	{
		strcpy(lbs_curr, lbs_from_set);
	}

	if (connect_start_time == 0)
	{
		connect_start_time = time(0);
		connected_host[0] = '\0';
	}

	char lbs_splited[8][64];
	memset(lbs_splited, 0, sizeof(lbs_splited));

	const char *d = ",;";
	char *p = strtok(lbs_curr, d);
	lbs_count = 0;

	while (p)
	{
		strcpy(lbs_splited[lbs_count], p);
		lbs_count++;
		p = strtok(NULL, d);
	}

	for (int i = 0; i < lbs_count; i++)
	{
		LbsThreadParam* param = new LbsThreadParam();
		param->conn = this;
		strcpy(param->lbs, lbs_splited[i]);
		Thread::start(get_host_form_lbs_runnable, param);
	}
}

void Connection::do_error()
{
	if (isfirst_error)
	{
		isfirst_error = false;

		memset(lbss, 0, sizeof(lbss));
		memset(lbs_counter, 0, sizeof(lbs_counter));

		for (int i = 0; i < get_host_index; i++)
		{
			char* content = host_from_lbs[i];
			if (strlen(content) < 10) continue;

			const char *d = ",;";
			char *p = strtok(content, d);
			int stype = -1;
			while (p)
			{

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
			char ip[32];
			short port;
			char* p = lbss[connect_stype_index][curr_stype_counter];
			parse_ip_port(p, ip, port);
			LOG("try... login server: stype:%d host %s:%d", connect_stype_index, ip, port);
			connect_stype_counter[connect_stype_index]++;
			connect_asyn(ip, port);
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
		if (time0 - connect_start_time > 60)
		{
			connect_start_time = 0;
			report_connect_error(get_error());
		} 
		else
		{
			connected_host[0] = '\0';
			for (int i = 0; i < STYPE_COUNT; i++)
			{
				for (int j = 0; j < lbs_counter[i]; j++)
				{
					char* host = lbss[i][j];
					char* end = strchr(host, ':');
					*end = '\0';
					strcat(connected_host, host);
					strcat(connected_host, ",");
				}
			}
			connect_from_lbs_asyn();
		}
	}

}

void Connection::RegisterConnectionListener(
		ConnectionListener* connection_listener)
{
	conn_listener = connection_listener;
}

ThreadVoid connect_runnable(void * vparam)
{
	ConnectThreadParam* param = (ConnectThreadParam*)vparam;
	param->conn->connect(param->ip, param->port);
	delete param;

	ThreadReturn;
}

int Connection::connect(const char* host, short port)
{
	int ret = socket.connect(host, port);
	isfirst_read = true;
	read_counter = 0;
	if (ret == 0)
	{
		closed = false;
		strcpy(connect_ip, host);
		connect_port = port;
		on_connected();
	}
	else
	{
		on_connect_error(get_error());
	}

	return ret;
}

void Connection::connect_asyn(const char* host, short port)
{
	ConnectThreadParam* param = new ConnectThreadParam();
	param->conn = this;
	param->port = port;
	strcpy(param->ip, host);
	Thread::start(connect_runnable, param);
}

void Connection::SendMsg_Hello()
{
	protocol::CMDClientHello_t hello;
	hello.param1 = 12;
	hello.param2 = 8;
	hello.param3 = 7;
	hello.param4 = 1;

	SEND_MESSAGE2(protocol::Sub_Vchat_ClientHello, protocol::CMDClientHello_t, &hello);
}

int Connection::recv(char* buf, int offset, int len)
{
	if (is_closed())
		return -1;

	int ret = socket.recv(buf + offset, len);

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
	if (is_closed())
		return -1;

	int ret = socket.send(buf, len);

	if (ret <= 0)
	{
		int err_code = get_error();
		if (IS_SOCKET_CLOSED(err_code))    // Socket operation on non-socket 
		{
			LOG("socket closed when send.");
		}
		else
		{
			LOG("send errno:%d:%d", ret, err_code);
			//on_io_error(err_code);
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
	closed = true;
	int ret = socket.close_();
	return ret;
}

int Connection::get_error()
{
	if (is_closed())
		return -1;

	return socket.get_error();
}

void Connection::send_message(int sub_cmd, void* req, int req_len)
{
	protocol::COM_MSG_HEADER* pHead = (protocol::COM_MSG_HEADER*)send_buf;
	pHead->length = sizeof(protocol::COM_MSG_HEADER) + req_len;
	pHead->version = protocol::MDM_Version_Value;
	pHead->checkcode = 0;
	pHead->maincmd = (short) main_cmd;
	pHead->subcmd = (short) sub_cmd;

	memcpy(pHead->content, req, req_len);

	socket.send((const char*) pHead, pHead->length);
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
		on_io_error(-4);
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

void Connection::read_loop(void)
{

	while (!is_closed())
	{
		int ret = read_message();

		if (ret < 0)
		{
			int err_no = get_error();

			if (err_no == SOCKET_TIMEOUT)  // 10060 =  time out
			{
				//LOG("read time out:%d", socket.get_error());
				if (isfirst_read)
				{
					LOG("first recv time out..error..");
					on_connect_error(err_no);
					return;
				}
			}
			else
			{
				LOG("exit read thread: exit code:%d", err_no);
				//on_io_error() in recv method
				return;
			}
			
		}

		if (ret > 0)
		{
			if ( isfirst_read )
			{
				if (conn_listener != NULL)
				{
					conn_listener->OnConnected();
				}
			}

			read_counter++;
			if ( read_counter >= 2 )
			{
				connect_start_time = 0;
			}
		}

		isfirst_read = false;

		time_t curr_time = time(0);
		if (curr_time - last_ping_time > 10)
		{
			SendMsg_Ping();
			last_ping_time = time(0);
			LOG("send ping");
		}
	}

}


ThreadVoid read_runnable(void* param)
{
	Connection* conn = (Connection*)param;
	if ( conn != NULL )
	{
		conn->read_loop();
	}

	ThreadReturn;
}

void Connection::start_read_thread(void)
{
	Thread::start(read_runnable, this);
}

void Connection::do_connect_error()
{
	do_error();
}

void Connection::do_io_error()
{
	do_error();
}

void Connection::on_connected()
{
	on_do_connected();
}

void Connection::on_connect_error(int err_code)
{
	close();
	do_connect_error();
}

void Connection::on_io_error(int err_code)
{
	LOG("on_io_error: %d", err_code);

	if (is_closed()) return;

	close();

	if (connect_start_time != 0)  // 5 + 2
	{
		do_io_error();
	}
	else
	{
		connect_from_lbs_asyn();
	}
}

void Connection::report_connect_error(int err_code)
{
	close();

	//ReportLoginFailed();

	if (conn_listener != NULL)
	{
		conn_listener->OnConnectError(err_code);
	}
}

bool Connection::is_closed()
{
	return closed;
}

Connection::Connection(void) :
conn_listener(NULL), last_ping_time(0), is_set_lbs(false), closed(true),connect_start_time(0),read_counter(0)
{
	Thread::initlock(&conn_lock);
}

Connection::~Connection(void)
{
}
