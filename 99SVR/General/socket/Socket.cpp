#include "platform.h"
#include "Socket.h"

unsigned long get_inet_addr(const char* host)
{
	if (inet_addr(host) == -1)
	{
		struct hostent* pHostEnt;
		pHostEnt = gethostbyname(host);
		if (pHostEnt == 0)
			return 0;
		return *(unsigned long*) pHostEnt->h_addr_list[0];
	}

	return inet_addr(host);
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
	struct timeval recv_timeout =
	{ recv_timeout_second, 0 };
	struct timeval send_timeout =
	{ send_timeout_second, 0 };
	ret = setsockopt(socket, SOL_SOCKET, SO_SNDTIMEO, (const char*) &send_timeout, sizeof(send_timeout));
	ret = setsockopt(socket, SOL_SOCKET, SO_RCVTIMEO, (const char*) &recv_timeout, sizeof(recv_timeout));
	return ret;
#endif
}

int Socket::create(void)
{
	socket = ::socket(AF_INET, SOCK_STREAM, 0);

	LOG("socket create: %d", socket);

	return get_error();
}

int Socket::connect(const char* host, short port)
{
	int ret;
	sockaddr_in sockAddr;
	memset(&sockAddr, 0, sizeof(sockAddr));
	sockAddr.sin_family = AF_INET;
	sockAddr.sin_port = htons(port);
	sockAddr.sin_addr.s_addr = get_inet_addr(host);

	create();

	//ret = ::connect(socket, (struct sockaddr*)&sockAddr, sizeof(sockAddr));
	set_block(socket, false);
	ret = ::connect(socket, (struct sockaddr*) &sockAddr, sizeof(sockAddr));
	if (socket == 0)
	{
		LOG("connected!:%d", ret);
		return 0;
	}
	if (ret == SOCKET_ERROR)
	{
		timeval timeout;
		timeout.tv_sec = 5;
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
			LOG("socket connect error: %d:%d", ret, get_error2());
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
		LOG("socket connect error: %d:%d", ret, get_error());
		return -1;
	}
		
	LOG("socket connect: %d", ret);

	ret = set_block(socket, true);
	ret = set_timeout(socket, 5, 5);

	LOG("socket set_block: %d", ret);

	return ret;
}

int Socket::send(const char *buf, int len)
{
	return ::send(socket, buf, len, 0);
}

int Socket::recv(char* buf, int len)
{
	return ::recv(socket, buf, len, 0);
}

int Socket::close_(void)
{
#ifdef WIN
	//return closesocket(socket);
	return ::shutdown(socket, 2);
#else
	//::close(socket);
	::shutdown(socket, 2);
	return 0;
#endif
}

int Socket::get_error()
{
#ifdef WIN
	return GetLastError();
#else
	return errno;
	//get_error2();
#endif
}

int Socket::get_error2()
{
	int socket_error = 0;
	int socket_error_len = sizeof(int);
    if (::getsockopt(socket, SOL_SOCKET, SO_ERROR, (char*) &socket_error, (socklen_t*)&socket_error_len) < 0)
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
		socket(-1)
{
}

Socket::~Socket(void)
{
}

