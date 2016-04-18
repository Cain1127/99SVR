#pragma once

#ifndef _SOCETK_H_
#define _SOCETK_H_





#include "Log.h"

#ifdef WIN
#include <winsock2.h>
#pragma comment(lib,"ws2_32.lib")

typedef int  my_socklen_t;

#define SOCKET_TIMEOUT WSAETIMEDOUT
#define SOCKET_NONE WSAENOTSOCK
#define SOCKET_CLOSED 10058
#define SOCKET_INVALID INVALID_SOCKET

#define SOCKET_SEND_FLAG 0

#else
#include <sys/socket.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <net/if.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/poll.h>
#include <sys/uio.h>
#include <unistd.h>
#include <signal.h>

#define SOCKET int
typedef socklen_t my_socklen_t;

#define SOCKET_TIMEOUT EAGAIN
#define SOCKET_NONE EBADF
#define SOCKET_CLOSED ENOTCONN

#define SOCKET_ERROR -1
#define SOCKET_INVALID -1

#ifdef ANDROID
#define SOCKET_SEND_FLAG (MSG_DONTWAIT | MSG_NOSIGNAL)
#else
#define SOCKET_SEND_FLAG MSG_DONTWAIT
#endif

#endif

#define IS_SOCKET_CLOSED(err_code) (err_code == SOCKET_NONE || err_code == SOCKET_CLOSED)


class Socket
{

private:

	SOCKET socket;

public:
	
	int connect(const char* host, short port, int timeout = 4);
	int close_(void);
	int send(const char* buf, int len);
	int recv(char* buf, int len);
	
	int get_address();
	int get_error();
	int get_error2();

	static int startup();
	static int cleanup();

	Socket(void);
	~Socket(void);

};






#endif
