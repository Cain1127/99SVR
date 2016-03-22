#include "StdAfx.h"
#include "Socket.h"

unsigned long get_inet_addr(const char* host)
{
	if (inet_addr(host) == -1)
	{
		struct hostent* pHostEnt;
		pHostEnt = gethostbyname(host);
		if (pHostEnt == 0)
			return 0;
		return *(unsigned long*)pHostEnt->h_addr_list[0];
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

int Socket::create(void)
{
	socket = ::socket(AF_INET, SOCK_STREAM, 0);

	LOG("socket create: %d", socket);

	return 0;
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

	ret = ::connect(socket, (struct sockaddr*)&sockAddr, sizeof(sockAddr));

	LOG("socket connect: %d", ret);

	ret = set_block(socket, true);

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


int Socket::close(void)
{
#ifdef WIN
	return closesocket(socket);
#else
//    return ::close(socket);
    return 1;
#endif
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


Socket::Socket(void) : socket(-1)
{
}

Socket::~Socket(void)
{
}

