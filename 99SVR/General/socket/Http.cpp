#include "stdafx.h"
#include "platform.h"
#include "Http.h"


Http::Http()
{
}

char* parse_response(char* recv_buf)
{
	char* content = strstr(recv_buf, "\r\n\r\n");
	if (content != NULL)
	{
		return content + 4;
	}

	return NULL;
}

char* Http::GetString(const char* host, short port, const char* url, char* recv_buf)
{
	int ret;
	Socket socket;
	string req;
	req += "GET ";
	req += url;
	req += " HTTP/1.1\r\n";
	req += string("Host: ") + host + "\r\n";
	req += "Accept: */*\r\n";
	req += "Connection: Close\r\n";
	req += "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)\r\n";
	req += "\r\n";

	ret = socket.connect(host, port, 3);
	if (ret != 0) 
	{
		return NULL;
	}

	ret = socket.send(req.data(), req.size());
	if (ret <= 0)  
	{
		return NULL;
	}

	ret = socket.recv(recv_buf, HTTP_RECV_BUF_SIZE);

	socket.close_();

	if (ret >= 0)
	{
		recv_buf[ret] = 0;
		return parse_response(recv_buf);
	}

	return NULL;
}

Http::~Http()
{
}



//char request[1024] = "GET / HTTP/1.1\r\nAccept: */*\r\nHost: www.sohu.com\r\nConnection: Close\r\nUser-Agent:Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)\r\n\r\n";
//char request[1024] = "GET /tygetgate HTTP/1.1\r\nAccept: */*\r\nHost: lbs1.99ducaijing.cn\r\nConnection: Close\r\nUser-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)\r\n\r\n";
