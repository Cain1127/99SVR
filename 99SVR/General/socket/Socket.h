#pragma once

#ifndef _SOCETK_H_
#define _SOCETK_H_





#include "Log.h"

#ifdef WIN
#include <winsock2.h>
#pragma comment(lib,"ws2_32.lib")
#define SOCKET_TIMEOUT WSAETIMEDOUT
#define SOCKET_NONE WSAENOTSOCK
#else

#include <sys/socket.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <sys/types.h>
#import <sys/ioctl.h>
#import <sys/poll.h>
#import <sys/uio.h>
#import <unistd.h>

#define SOCKET int

#define SOCKET_TIMEOUT EAGAIN
#define SOCKET_NONE EBADF
#define SOCKET_ERROR -1

#endif


class Socket
{
private:
	SOCKET socket;

	int create(void);

public:
	
	int connect(const char* host, short port);
	int close_(void);
	int send(const char* buf, int len);
	int recv(char* buf, int len);
	int get_error();
	int get_error2();

	static int startup();
	static int cleanup();

	Socket(void);
	~Socket(void);
};






#endif
