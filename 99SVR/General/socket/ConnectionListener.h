#ifndef __CONN_LISTENER_H__
#define __CONN_LISTENER_H__

#include "LoginMessage.pb.h"
#include "VideoRoomMessage.pb.h"
#include "CommonroomMessage.pb.h"

class ConnectionListener
{

public:

	virtual void OnConnected() = 0;
	virtual void OnConnectError(int err_code) = 0;
	virtual void OnIOError(int err_code) = 0;

};

#endif
