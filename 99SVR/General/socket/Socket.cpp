#include "stdafx.h"
#include "Socket.h"
#include <netdb.h>

const char * get_inet_addr(const char* host,int port,int *type,sockaddr_in6 *sock_in6,sockaddr_in *sock_in4)
{
    struct addrinfo *answer, hint, *curr;
    memset(&hint, 0, sizeof(hint));
    hint.ai_family   = PF_UNSPEC;
    hint.ai_socktype = SOCK_STREAM;
    hint.ai_protocol = IPPROTO_TCP;

    char cPort[10] = {0};
    sprintf(cPort,"%d",port);
    int ret = getaddrinfo(host, cPort, &hint, &answer);
    if (ret != 0)
    {
        return host;
    }
    for (curr = answer; curr != NULL; curr = curr->ai_next)
    {
        if (curr->ai_family == AF_INET)
        {
            memcpy (sock_in4, curr->ai_addr, curr->ai_addrlen);
            *type = 1;
            return "";
            
        }
        else if (curr->ai_family == AF_INET6)
        {
            *type = 2;
            memcpy (sock_in6, curr->ai_addr, curr->ai_addrlen);
            sock_in6->sin6_port = htons(port);
            return "";
        }
    }
    return "";
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
    int type = 0;
    sockaddr_in sock_in4;
    sockaddr_in6 sock_in6;
    memset(&sock_in4,0, sizeof(sock_in4));
    memset(&sock_in6,0, sizeof(sock_in6));
    get_inet_addr(host,port,&type,&sock_in6,&sock_in4);
    int ret = 0;
    if(type==1)
    {
        socket = ::socket(AF_INET, SOCK_STREAM, 0);
        set_block(socket, false);
        ret = ::connect(socket, (struct sockaddr*) &sock_in4, sizeof(sock_in4));
    }
    else if(type == 2)
    {
        if ((socket = ::socket(AF_INET6, SOCK_STREAM, 0)) < 0)
        {
            perror("create socket fail!\n");
        }
        set_block(socket, false);
        ret = ::connect(socket, (struct sockaddr*) &sock_in6, sizeof(sock_in6));
    }
    else
    {
        return -2;
    }

	if (socket < 0 || socket == SOCKET_INVALID)
	{
		return -2;
	}
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

