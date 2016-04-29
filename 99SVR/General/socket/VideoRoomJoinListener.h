#ifndef __ROOMJOIN_LISTENER_H__
#define __ROOMJoin_LISTENER_H__

#include <vector>
#include "VideoRoomMessage.pb.h"
#include "CommonroomMessage.pb.h"

class VideoRoomJoinListener
{
public:
	//加入房间预处理
	virtual void OnPreJoinRoomResp(PreJoinRoomResp& info) = 0;

	//加入房间成功
	virtual void OnJoinRoomResp(JoinRoomResp& info) = 0;

	//加入房间失败
	virtual void OnJoinRoomErr(JoinRoomErr& info) = 0;

};


#endif
