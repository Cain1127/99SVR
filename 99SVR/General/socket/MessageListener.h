#ifndef __MESSAGE_LISTENER_H__
#define __MESSAGE_LISTENER_H__

#include "LoginMessage.pb.h"
#include "VideoRoomMessage.pb.h"
#include "CommonroomMessage.pb.h"

class MessageListener
{

public:

	virtual void OnLoginMessageComming(void* msg) = 0;

	virtual void OnVideoRoomMessageComming(void* msg) = 0;

};

#endif
