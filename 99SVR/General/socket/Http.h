#ifndef __HTTP_H__
#define __HTTP_H__

#include "HttpListener.h"

#include "Socket.h"
#include <string>
#include <map>

using std::string;
using std::map;

#define HTTP_GET 0
#define HTTP_POST 1

typedef void (*ParseJson)(char* , HttpListener*);

typedef  map<string, string> RequestParamter;

RequestParamter& get_request_param();

class Http
{
private:
    Socket socket;
    int method;
    
    int size;
    char* recv_buf;
    
    HttpListener* http_listener;
    ParseJson parser;
    
    
    void build_request(string& req, const char* host, const char* url_tail, map<string, string>* param);
    void build_param(string& out, map<string, string>* param);
    
    //void build_request(string& req, const char* host, const char* url_tail, RequestParamter* param);
    //void build_param(string& out, RequestParamter* param);
    
public:
    
    void SetRecvBufSize(int sz) { size = sz; }
    char* request(const char* host, short port, const char* url_tail, RequestParamter* param = NULL);
    char* request(const char* url, RequestParamter* param = NULL);
    
    void register_http_listener(HttpListener* listener){this->http_listener = listener;}
    void register_parser(ParseJson parse_json){this->parser = parse_json;}
    
    Http(int get_post = HTTP_GET);
    
    ~Http();
};


#endif
