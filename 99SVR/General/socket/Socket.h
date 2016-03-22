#pragma once

#include "Log.h"

#ifdef WIN
#include <winsock2.h>
#pragma comment(lib,"ws2_32.lib")
#else
#include <sys/socket.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#define SOCKET int
#endif


class Socket
{
private:
	SOCKET socket;

	int create(void);

public:
	
	int connect(const char* host, short port);
	int close(void);
	int send(const char* buf, int len);
	int recv(char* buf, int len);

	static int startup();
	static int cleanup();

	Socket(void);
	virtual ~Socket(void);
};
