#include "Socket.h"
#include <string>

using std::string;

#define HTTP_RECV_BUF_SIZE 16 * 1024

class Http
{
private:
	Socket socket;

public:

	char* GetString(const char* host, short port, const char* url, char* recv_buf);

	Http();
	~Http();
};

