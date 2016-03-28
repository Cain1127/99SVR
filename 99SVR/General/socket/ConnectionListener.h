#include "LoginMessage.pb.h"

class ConnectionListener
{

public:

	virtual void OnConnected() = 0;
	virtual void OnConnectError(int err_code) = 0;
	virtual void OnIOError(int err_code) = 0;

};
