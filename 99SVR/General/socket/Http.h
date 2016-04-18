#ifndef __HTTP_H__
#define __HTTP_H__

#include "Socket.h"
#include <string>
#include <map>

using std::string;
using std::map;

#define HTTP_GET 0
#define HTTP_POST 1

typedef  map<string, string> RequestParamter;

class Http
{
private:
	Socket socket;
	int method;

	int size;
	char* recv_buf;

	void build_request(string& req, const char* host, const char* url_tail, RequestParamter* param);
	void build_param(string& out, RequestParamter* param);

public:

	void SetRecvBufSize(int sz) { size = sz; }
	char* request(const char* host, short port, const char* url_tail, RequestParamter* param = NULL);
	char* request(const char* url, RequestParamter* param = NULL);

	Http(int get_post = HTTP_GET);

	~Http();
};


#endif
