#include "stdafx.h"
#include "platform.h"
#include "proto_err.h"
#include "Http.h"
#include "Util.h"
#include "Log.h"

Http::Http(int get_post) : method(get_post), size(1024), recv_buf(NULL), parser(NULL), http_listener(NULL)
{
}

RequestParamter& get_request_param()
{
	RequestParamter* param = new RequestParamter();
	return *param;
}

char* parse_response(char* recv_buf)
{
	char* content = strstr(recv_buf, "\r\n\r\n");
	if (content != NULL)
	{
		content = content + 4;
		char* check_json = strstr(content, "\r\n");
		if (check_json != NULL)
		{
			content = check_json + 2;
			char* check_json_end = strstr(content, "\r\n");
			if (check_json_end != NULL)
			{
				*check_json_end = '\0';
			}
		}

		//LOG("%s", content);
		return content ;
	}

	return NULL;
}


void parse_url(const char* url, char* host, short& port, char* url_tail)
{
	const char* host_start = url;
	
	host_start = strstr(url, "://");
	if (host_start != NULL)
	{
		host_start += 3;
	}

	const char* host_end = strchr(host_start, '/');
	if (host_end != NULL)
	{
		strncpy(host, host_start, host_end - host_start);
		host[host_end - host_start] = '\0';
		strcpy(url_tail, host_end);
	}
	else 
	{
		strcpy(host, host_start);
		strcpy(url_tail, "/");
	}

	char* port_start = strchr(host, ':');
	if (port_start != NULL)
	{
		port = atoi(port_start + 1);
		*port_start = '\0';
	}
	else
	{
		port = 80;
	}

	//LOG("host:%s port:%d url:%s", host, port, url_tail);
}

char* Http::request(const char* url, RequestParamter* param)
{
	char host[64];
	short port;
	char url_tail[512];

	parse_url(url, host, port, url_tail);

	return request(host, port, url_tail, param);
}

void Http::build_param(string& out, RequestParamter* param)
{
	if (param == NULL) return;

	bool isfirst = true;
	RequestParamter::iterator it;
	for (it = param->begin(); it != param->end(); ++it)
	{
		if (isfirst)
		{
			out += (out.find('=') != string::npos) ? "&" : (method == HTTP_GET ? "?" : "");
			isfirst = false;
		} 
		else
		{
			out += "&";
		}
		out += it->first;
		out += "=";
#ifdef WIN
		out += GBKToUTF8(it->second);
#else
		out += it->second;
#endif
	}
}

void Http::build_request(string& req, const char* host, const char* url_tail, RequestParamter* param)
{
	req += (method == HTTP_GET) ? "GET " : "POST ";
	req += url_tail;
	if (method == HTTP_GET)
	{
		build_param(req, param);
		LOG("req:%s", req.c_str());
	}
	req += " HTTP/1.0\r\n";
	req += string("Host: ") + host + "\r\n";
	req += "Accept: */*\r\n";
	req += "Connection: Close\r\n";
	req += "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)\r\n";
	if (method == HTTP_POST)
	{
		string content;
		build_param(content, param);

		req += "Content-Type: application/x-www-form-urlencoded\r\n";
		req += string("Content-Length: ") + int2string(content.size()) + "\r\n";
		req += "\r\n";
		req += content;
	}
	else
	{
		req += "\r\n";
	}


}

char* Http::request(const char* host, short port, const char* url_tail, RequestParamter* param)
{
	int ret;
	Socket socket;
	string req;
	char buf[1024];

	build_request(req, host, url_tail, param);

	socket.set_recv_timeout(5);
	ret = socket.connect(host, port, 5);
	if (ret != 0) 
	{
		socket.close_();
		/*if (http_listener)
			http_listener->OnError(PERR_CONNECT_ERROR);*/
		return NULL;
	}

	ret = socket.send(req.data(), req.size());
	if (ret <= 0)  
	{
		socket.close_();
		/*if (http_listener)
			http_listener->OnError(PERR_IO_ERROR);*/
		return NULL;
	}

	string recvbytes;
	while ((ret = socket.recv(buf, 1024)) > 0)
	{
		recvbytes.append(buf, ret);
	}

	socket.close_();

	int recvsize = recvbytes.size();
	if (recvsize > 0)
	{
		char* content = new char[recvsize + 1];
		memcpy(content, recvbytes.data(), recvsize);
		content[recvsize] = 0;

		content = parse_response(content);
		if (content)
		{
			if (this->parser)
			{
				this->parser(content, http_listener);
			}

			return content;
		}
	}

	/*if (http_listener)
		http_listener->OnError(PERR_IO_ERROR);*/

	return NULL;
}

Http::~Http()
{
	if ( recv_buf )
		delete[] recv_buf;
}



//char request[1024] = "GET / HTTP/1.1\r\nAccept: */*\r\nHost: www.sohu.com\r\nConnection: Close\r\nUser-Agent:Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)\r\n\r\n";
//char request[1024] = "GET /tygetgate HTTP/1.1\r\nAccept: */*\r\nHost: lbs1.99ducaijing.cn\r\nConnection: Close\r\nUser-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)\r\n\r\n";
