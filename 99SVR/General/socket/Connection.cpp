/**
 * todo
 * 测试多次 close
 */
#include "stdafx.h"
#include <stdio.h>
#include "platform.h"
#include "Connection.h"
#include "Http.h"
#include "Json.h"
#include "StatisticReport.h"

#define CLOSED -1
#define CLOSED_SOCKET -2
#define RESPONSE_TIMEOUT -5
#define RESPONSE_TIMEOUT_FIRST -6
#define RECV_NO_DATA 0
#define MSL_LEN_ERR -4

Socket g_socket;

char cache_path[256] = { 0 };
static const char* lbs0 = "lbs1.99ducaijing.cn:2222,lbs2.99ducaijing.cn:2222,lbs3.99ducaijing.cn:2222,58.210.107.54:2222,122.193.102.23:2222,112.25.230.249:2222";//,112.25.230.249:2222
//static const char* lbs0 = "testlbs.99ducaijing.cn:2222";
static char lbs_from_file[256] = {0};
static char lbs_from_http[256] = {0};
static char lbs_from_set[256] = {0};
static char lbs_curr[256] = {0};
static int lbs_count;


static time_t connect_start_time;
static int lbs_err_counter;
static int get_host_index;
static char host_from_lbs[8][128];
static char lbss[STYPE_COUNT][8][32];
static int lbs_counter[STYPE_COUNT];
static bool islogining;
static bool isfirst_read;
static bool isfirst_error;
static int read_counter;

static char first_login_server[32];
static int connect_stype_index;
static int connect_stype_counter[STYPE_COUNT];
static char connected_host[384];

static bool is_set_lbs;

static time_t last_ping_time;
static time_t last_send_time;

char connect_ip[32];
short connect_port;

bool socket_closed;
bool socket_connecting;
char send_buf[MAX_MESSAGE_SIZE];
char recv_buf[MAX_MESSAGE_SIZE];

ThreadLock conn_lock;

void InitProtocolContext(const char* path)
{
    strcpy(cache_path, path);
    in_room = false;
}

void ReadProtocolCache(const char *suffix_path, std::string& cache_content)
{
    if(!cache_path || !suffix_path)
    {
        return;
    }
    
    std::string full_path;
    
    full_path = cache_path;
    full_path += FILE_SEPARATOR;
    full_path += suffix_path;
    
    char contentBuf[256] = {0};
    
    LOG("read path:%s:", full_path.c_str());
    
    FILE *fp;
    fp = fopen(full_path.c_str(), "r");
    
    if(!fp)
    {
        return;
    }
    
    size_t n_read;
    while( (n_read = fread( contentBuf, 1, 255, fp)) > 0 )
    {
        contentBuf[n_read] = '\0';
        cache_content += contentBuf;
    }
    
    LOG("read json:%s:", cache_content.c_str());
    
    fclose(fp);
}

void WriteProtocolCache(const char *suffix_path, std::string& cache_content)
{
    if(!cache_path || !suffix_path)
    {
        return;
    }
    
    std::string full_path;
    
    full_path = cache_path;
    full_path += FILE_SEPARATOR;
    full_path += suffix_path;
    
    LOG("save path:%s:", full_path.c_str());
    
    FILE *fp;
    fp = fopen(full_path.c_str(), "w");
    
    if(!fp)
    {
        return;
    }
    
    const char* pContent = cache_content.c_str();
    const char* pStart = pContent;
    
    int length = cache_content.size();
    
    fwrite(pStart, 1, length, fp);
    
    LOG("save json:%s:", cache_content.c_str());
    
    fclose(fp);
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
    strcpy(url, "/tygetlogon");
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
                        LOG("first connect server: %s:%d", ip, port);
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
    socket_connecting = true;
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
    
    connect("121.12.118.32", 7301);
    
    return;
    
    if (!is_set_lbs)
    {
        const char* lbs = lbs0;
        if (*cache_path)
        {
            lbs = get_lbs_from_file();
            if (lbs == NULL)
            {
                get_lbs_from_http(NULL);
                if (*lbs_from_http)
                {
                    lbs = lbs_from_http;
                    LOG("use lbs from http:%s", lbs);
                }
                else
                {
                    lbs = lbs0;
                    LOG("use lbs from default:%s", lbs);
                }
            }
            else
            {
                LOG("use lbs from file:%s", lbs);
                Thread::start(get_lbs_from_http, NULL);
            }
        }
        
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

string Connection::get_error_desc(int err_code)
{
    string str="";
    switch(err_code)
    {
        case protocol::ERR_CODE_SUCCESS:
            str="成功";
            break;
        case protocol::ERR_CODE_FAILED:
            str="失败";
            break;
        case protocol::ERR_CODE_FAILED_PACKAGEERROR:
            str="请求包长度错误";
            break;
        case protocol::ERR_CODE_FAILED_DBERROR:
            str="数据库类型错误";
            break;
        case protocol::ERR_CODE_FAILED_INVALIDCHAR:
            str="输入了非法字符";
            break;
        case protocol::ERR_CODE_FAILED_USERNOTFOUND:
            str="找不到该用户";
            break;
        case protocol::ERR_CODE_FAILED_USERFROSEN:
            str="用户被冻结";
            break;
        case protocol::ERR_CODE_FAILED_UNKNONMESSAGETYPE:
            str="未知消息类型";
            break;
        case protocol::ERR_CODE_FAILED_REQUEST_OUTOFRANGE:
            str="请求数据过多或者内容过长";
            break;
        case protocol::ERR_CODE_FAILED_SAMEUSERLOGIN:
            str="完全相同的用户加入房间";
            break;
        case protocol::ERR_CODE_FAILED_AREAIDNOTFOUND:
            str="没有找到区域ID";
            break;
        case protocol::ERR_CODE_FAILED_ROOMIDNOTFOUND:
            str="没有找到房间ID";
            break;
        case protocol::ERR_CODE_FAILED_CRC:
            str="CRC校验错误";
            break;
        case protocol::ERR_CODE_FAILED_CREATEUSER:
            str="没有找到创建用户失败";
            break;
        case protocol::ERR_CODE_FAILED_KEYWORDFOUND:
            str="发现关键词";
            break;
        case protocol::ERR_CODE_FAILED_NOT_ENOUGH_GOLD:
            str="金币不足";
            break;
        case protocol::ERR_CODE_FAILED_ALREADY_BUY:
            str="已经购买";
            break;
        case protocol::ERR_CODE_FAILED_PRIVATENOTFOUND:
            str="没有该私人订制";
            break;
        case protocol::ERR_CODE_FAILED_TEAMNOTFOUND:
            str="没有找到战队ID";
            break;
        case protocol::ERR_CODE_FAILED_GIFTNOTFOUND:
            str="没有找到礼物ID";
            break;
        default:
            str="未知错误";
            break;
    }
    
    return str;
}

void Connection::RegisterConnectionListener(
                                            ConnectionListener* connection_listener)
{
    this->conn_listener = connection_listener;
}

void Connection::RegisterMessageListener(
                                         MessageListener* message_listener)
{
    this->message_listener = message_listener;
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
    int ret = g_socket.connect(host, port);
    isfirst_read = true;
    read_counter = 0;
    if (ret == 0)
    {
        socket_closed = false;
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
        return CLOSED;
    
    int ret = g_socket.recv(buf + offset, len);
    
    if (ret <= 0)
    {
        int err_no = get_error();
        if (IS_SOCKET_CLOSED(err_no))  // Socket operation on non-socket
        {
            LOG("socket closed.");
            return CLOSED_SOCKET;
        }
        else
        {
            if (err_no == SOCKET_TIMEOUT) // timed out
            {
                if ( last_send_time > 0 )  // there is a request, so must response in 5 second
                {
                    if (isfirst_read)
                    {
                        LOG("first recv time out..error..");
                        //on_connect_error(err_no);
                        return RESPONSE_TIMEOUT_FIRST;
                    }
                    else
                    {
                        time_t curr_time = time(0);
                        if ( curr_time - last_send_time >= 5 )
                        {
                            LOG("recv timeout err: %d", err_no);
                            //on_io_error(-4);
                            return RESPONSE_TIMEOUT;
                        }
                        else
                        {
                            LOG("recv timeout no data0: %d", err_no);
                            return RECV_NO_DATA;
                        }
                    }
                }
                else
                {
                    LOG("recv timeout no data: %d", err_no);
                    return RECV_NO_DATA;
                }
            }
            else
            {
                LOG("recv err: %d", err_no);
                //on_io_error(err_no);
                return err_no < 0 ? err_no : -err_no;
            }
        }
    }
    else
    {
        last_send_time = 0;
        return ret;
    }
}

int Connection::send(const char* buf, int len)
{
    if (is_closed())
    {
        LOG("socket CLOSED when send.");
        report_connect_error(CLOSED);
        return -1;
    }
    
    int ret = g_socket.send(buf, len);
    
    if ( last_send_time == 0)
    {
        last_send_time = time(0);
    }
    
    if (ret <= 0)
    {
        int err_code = get_error();
        if (IS_SOCKET_CLOSED(err_code))    // Socket operation on non-socket
        {
            LOG("socket closed when send.");
            report_connect_error(-err_code);
        }
        else
        {
            LOG("send errno:%d:%d", ret, err_code);
            report_connect_error(-err_code);
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
    socket_closed = true;
    int ret = g_socket.close_();
    return ret;
}

int Connection::get_error()
{
    if (is_closed())
        return -1;
    
    return g_socket.get_error();
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
    
    g_socket.send((const char*) pHead, pHead->length);
}

int Connection::read_message(void)
{
    int recvLen = 0;
    do
    {
        int len = recv(recv_buf, recvLen, 4 - recvLen);
        if (len <= 0)
        {
            //LOG("read message length error: %d", len);
            return len;
        }
        recvLen += len;
    } while (recvLen != 4);
    
    int msgLen = *((int*) recv_buf);
    if (msgLen <= 0 || msgLen > MAX_MESSAGE_SIZE)
    {
        LOG("message len error: %d", msgLen);
        return MSL_LEN_ERR;
    }
    
    do
    {
        int len = recv(recv_buf, recvLen, msgLen - recvLen);
        if (len <= 0)
        {
            LOG("read message content error: %d", recvLen);
            return len;
        }
        recvLen += len;
    } while (recvLen != msgLen);
    
    uint8* new_msg = new uint8[msgLen + 1];
    memcpy(new_msg, recv_buf, msgLen);
    new_msg[msgLen] = 0;
    
    on_dispatch_message(new_msg);
    
    return recvLen;
}

void Connection::on_dispatch_message(void* msg)
{
    if (message_listener != NULL)
    {
        protocol::COM_MSG_HEADER* head = (protocol::COM_MSG_HEADER*)msg;
        switch ( head->maincmd )
        {
            case protocol::MDM_Vchat_Login:
            case protocol::MDM_Vchat_Hall:
                message_listener->OnLoginMessageComming(msg);
                break;
            case protocol::MDM_Vchat_Room:
                message_listener->OnVideoRoomMessageComming(msg);
                break;
            case protocol::MDM_Vchat_Usermgr:
            {
                protocol::COM_MSG_HEADER* head = (protocol::COM_MSG_HEADER*)msg;
                int sub_cmd = head->subcmd;
                if(sub_cmd==protocol::Sub_Vchat_HitGoldEgg_ToClient_Noty || sub_cmd==protocol::Sub_Vchat_ClientNotify)
                {
                    protocol::tag_CMDPushGateMask* push = (protocol::tag_CMDPushGateMask*) (head->content);
                    if(push->type==8)
                    {
                        message_listener->OnVideoRoomMessageComming(msg);
                    }
                    else
                    {
                        message_listener->OnLoginMessageComming(msg);
                    }
                }
                else if(sub_cmd==protocol::Sub_Vchat_ClientNotify)
                {
                    message_listener->OnLoginMessageComming(msg);
                }
            }
                break;
        }
    }
}

void Connection::read_loop(void)
{
    
    while (!is_closed())
    {
        int ret = read_message();
        
        LOG("read loop ret:%d", ret);
        
        if (ret < 0)
        {
            int err_no = get_error();
            switch (ret)
            {
                case CLOSED:
                    return;
                case CLOSED_SOCKET:
                    report_connect_error(CLOSED_SOCKET);
                    return;
                case RESPONSE_TIMEOUT_FIRST:
                    on_connect_error(err_no);
                    return;
                case RESPONSE_TIMEOUT:
                    on_io_error(err_no);
                    return;
                case MSL_LEN_ERR:
                    on_io_error(err_no);
                    return;
                default:
                    on_io_error(err_no);
                    return;
            }
        }
        
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
        
        isfirst_read = false;
        socket_connecting = false;
        
        time_t curr_time = time(0);
        if (curr_time - last_ping_time > 10)
        {
            LOG("send ping...");
            SendMsg_Ping();
            last_ping_time = time(0);
        }
        
        on_tick();
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
    
    socket_connecting = false;
    
    if (conn_listener != NULL)
    {
        conn_listener->OnConnectError(err_code);
    }
}

void Connection::on_tick()
{
    
}

bool Connection::is_closed()
{
    return socket_closed;
}

Connection::Connection(void) 
{
    last_ping_time = 0;
    is_set_lbs = false;
    socket_closed = true;
    socket_connecting = false;
    connect_start_time = 0;
    read_counter = 0;
    last_send_time = 0;
    conn_listener = NULL;
    Thread::initlock(&conn_lock);
}

Connection::~Connection(void)
{
}
