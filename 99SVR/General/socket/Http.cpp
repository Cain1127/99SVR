#include "platform.h"
#include "Http.h"
#include "Util.h"
#include "Log.h"

enum
{
    PERR_CONNECT_ERROR = 0x100,
    PERR_IO_ERROR,
    PERR_JSON_PARSE_ERROR = 0x200
};

Http::Http(int get_post) : method(get_post), size(4096), recv_buf(NULL), parser(NULL), http_listener(NULL)
{
}

char* parse_response(char* recv_buf)
{
    LOG("%s", recv_buf);
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
        out += it->second;
    }
}

void Http::build_request(string& req, const char* host, const char* url_tail, RequestParamter* param)
{
    req += (method == HTTP_GET) ? "GET " : "POST ";
    req += url_tail;
    if (method == HTTP_GET)
    {
        build_param(req, param);
    }
    req += " HTTP/1.1\r\n";
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
    
    LOG("req:%s", req.c_str());
}

char* Http::request(const char* host, short port, const char* url_tail, RequestParamter* param)
{
    int ret;
    Socket socket;
    string req;
    build_request(req, host, url_tail, param);
    
    ret = socket.connect(host, port, 5);
    if (ret != 0)
    {
        socket.close_();
        if (http_listener)
            http_listener->OnError(PERR_CONNECT_ERROR);
        return NULL;
    }
    
    ret = socket.send(req.data(), req.size());
    if (ret <= 0)
    {
        socket.close_();
        if (http_listener)
            http_listener->OnError(PERR_IO_ERROR);
        return NULL;
    }
    
    if (recv_buf == NULL)
    {
        recv_buf = new char[size];
    }
    
    if ((ret = socket.recv(recv_buf, size - 1)) > 0)
    {
        recv_buf[ret] = 0;
    }
    else
    {
        if (http_listener)
            http_listener->OnError(PERR_IO_ERROR);
    }
    
    socket.close_();
    
    if (ret > 0)
    {
        char* content = parse_response(recv_buf);
        if (content)
        {
            if (this->parser)
            {
                this->parser(content, http_listener);
            }
            
            return content;
        }
    }
    
    return NULL;
}

Http::~Http()
{
    delete[] recv_buf;
}
