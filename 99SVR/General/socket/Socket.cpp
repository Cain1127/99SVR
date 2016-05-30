#include "stdafx.h"
#include "Socket.h"

unsigned long get_inet_addr(const char* host)
{
#if 1
	if (inet_addr(host) == -1)
	{
		struct hostent* pHostEnt;
		pHostEnt = gethostbyname(host);
		if (pHostEnt == 0)
			return 0;
		return *(unsigned long*) pHostEnt->h_addr_list[0];
	}

	return inet_addr(host);
#else
    unsigned char buf[sizeof(struct in6_addr)];
    int domain, s;
    s = inet_pton(AF_INET6,host,buf);
    if(s<=0)
    {
        if(0 == s)
        {
            printf("Not in presentation format/n");
        }
        else
        {
            printf("inet_pton/n");
        }
    }
//    if(inet_ntop(domain, buf, str, INET6_ADDRSTRLEN) == NULL){
//        printf("inet ntop/n");
//    }
//    return buf;
#endif
}

int set_block(SOCKET socket, bool block)
{
#ifdef WIN
	{
		unsigned long arg = (block ? 0 : 1);
		return ::ioctlsocket(socket, FIONBIO, &arg);
	}
#else
	int flags = ::fcntl(socket, F_GETFL);
	if (block)
	{
		flags &= ~O_NONBLOCK;
	}
	else
	{
		flags |= O_NONBLOCK;
	}
	if (::fcntl(socket, F_SETFL, flags) == -1)
	{
		return -1;
	}
	return 0;
#endif

}

int set_timeout(SOCKET socket, int recv_timeout_second, int send_timeout_second)
{
#ifdef WIN
	int ret;
	int recv_timeout = recv_timeout_second * 1000;
	int send_timeout = send_timeout_second * 1000;
	ret = setsockopt(socket, SOL_SOCKET, SO_SNDTIMEO, (const char*)&send_timeout, sizeof(send_timeout));
	ret = setsockopt(socket, SOL_SOCKET, SO_RCVTIMEO, (const char*)&recv_timeout, sizeof(recv_timeout));
	return ret;
#else
	int ret;
	struct timeval recv_timeout = { recv_timeout_second, 0 };
	struct timeval send_timeout = { send_timeout_second, 0 };
	ret = setsockopt(socket, SOL_SOCKET, SO_SNDTIMEO, (const char*) &send_timeout, sizeof(send_timeout));
	ret = setsockopt(socket, SOL_SOCKET, SO_RCVTIMEO, (const char*) &recv_timeout, sizeof(recv_timeout));
	return ret;
#endif
}

void set_no_sigpipe(SOCKET socket)
{
#ifdef WIN
#elif defined ANDROID
#else
	int set = 1;
	setsockopt(socket, SOL_SOCKET, SO_NOSIGPIPE, (void*)&set, sizeof(int));
#endif
}

int Socket::connect(const char* host, short port, int connect_timeout)
{
	if (!host || !(*host) || !port) return -2;
#if 0
	sockaddr_in sockAddr;
	memset(&sockAddr, 0, sizeof(sockAddr));
	sockAddr.sin_family = AF_INET;
	sockAddr.sin_port = htons(port);
	sockAddr.sin_addr.s_addr = get_inet_addr(host);
    socket = ::socket(AF_INET, SOCK_STREAM, 0);
#else
    sockaddr sockAddr;
    struct in6_addr iSin6_addr;
    int s = inet_pton(AF_INET6,host,&iSin6_addr);
    if (s<=0)
    {
        printf("sin6_addr err\n");
        sockaddr_in sockAddr_in4;
        memset(&sockAddr_in4, 0, sizeof(sockAddr_in4));
        sockAddr_in4.sin_family = AF_INET;
        sockAddr_in4.sin_port = htons(port);
        sockAddr_in4.sin_addr.s_addr = get_inet_addr(host);
        memcpy(&sockAddr, &sockAddr_in4,sizeof(struct sockaddr));
        socket = ::socket(AF_INET, SOCK_STREAM, 0);
    }
    else
    {
        sockaddr_in6 sockAddr6;
        memset(&sockAddr6, 0, sizeof(sockAddr6));
        sockAddr6.sin6_family = AF_INET6;
        sockAddr6.sin6_port = htons(port);
        memcpy(&sockAddr6.sin6_addr, &iSin6_addr,sizeof(struct in6_addr));
        memcpy(&sockAddr,&sockAddr6,sizeof(struct sockaddr));
        socket = ::socket(AF_INET6, SOCK_STREAM, 0);
    }
#endif

	if (socket < 0 || socket == SOCKET_INVALID)
	{
		return -2;
	}

	LOG("socket create: %d host:%s port:%d", socket, host, port);

	set_block(socket, false);
	int ret = ::connect(socket, (struct sockaddr*) &sockAddr, sizeof(sockAddr));
	if (ret == SOCKET_ERROR)
	{
		timeval timeout;
		timeout.tv_sec = (long)connect_timeout;
		timeout.tv_usec = 0;

		fd_set read_set;
		fd_set write_set;
		FD_ZERO(&read_set);
		FD_ZERO(&write_set);
		FD_SET(socket, &read_set);
		FD_SET(socket, &write_set);
#ifdef WIN
		int n = ::select(0, &read_set, &write_set, NULL , &timeout);
#else
		int n = ::select(socket + 1, &read_set, &write_set, NULL, &timeout);
#endif
		if (n <= 0)
		{
			LOG("socket connect error0: %d host:%s port:%d", ret, host, port);
			close_();
			return -1;
		}
		if (FD_ISSET(socket, &read_set) || FD_ISSET(socket, &write_set))
		{
			if (get_error2() == 0)
			{
				ret = 0;
			}
		}
	}
	
	if (ret != 0)
	{
		LOG("socket connect error1: %d host:%s port:%d", ret, host, port);
		close_();
		return -1;
	}
		
	LOG("socket connect: %d host:%s port:%d", ret, host, port);

	set_no_sigpipe(socket);
	set_block(socket, true);
	set_timeout(socket, recv_timeout, 3);

	//get_address();

	return ret;
}

int Socket::send(const char *buf, int len)
{
	return ::send(socket, buf, len, SOCKET_SEND_FLAG);
}

int Socket::recv(char* buf, int len)
{
	return ::recv(socket, buf, len, 0);
}

int Socket::close_(void)
{
	if ((socket < 0) || (socket == SOCKET_INVALID))
	{
		return -1;
	}

#ifdef WIN
	closesocket(socket);
#elif defined ANDROID
	::close(socket);
#else
	::shutdown(socket, 2);
#endif

	socket = SOCKET_INVALID;
	return 0;
}

//Õ®π˝Ã◊Ω”◊÷ªÒ»°IP°¢Portµ»µÿ÷∑–≈œ¢
int Socket::get_address()
{
//	sockaddr_in sockAddr;
//	memset(&sockAddr, 0, sizeof(sockAddr));
//	my_socklen_t nAddrLen = sizeof(sockAddr);
//
//	if (::getsockname(socket, (struct sockaddr*)&sockAddr, &nAddrLen) != 0)
//	{
//		printf("Get IP address by socket failed!n");
//		return -1;
//	}

	return 0;
}

void Socket::set_recv_timeout(int timeout)
{
	recv_timeout = timeout;
}

int Socket::get_error()
{
#ifdef WIN
	return GetLastError();
#else
	return errno;
#endif
}

int Socket::get_error2()
{
	int socket_error = 0;
	int socket_error_len = sizeof(my_socklen_t);
	if (getsockopt(socket, SOL_SOCKET, SO_ERROR, (char*) &socket_error, (my_socklen_t*) &socket_error_len) < 0)
	{
		return -1;
	}
	return socket_error;
}

int Socket::startup(void)
{
#ifdef WIN
	WSADATA wsaData;
	return WSAStartup(MAKEWORD(2, 2), &wsaData);
#else
	return 0;
#endif
}

int Socket::cleanup(void)
{
#ifdef WIN
	return WSACleanup();
#else
	return 0;
#endif
}

Socket::Socket(void) :
		socket(SOCKET_INVALID), recv_timeout(6)
{
}

Socket::~Socket(void)
{
}

