#ifndef __ROOMJOIN_LISTENER_H__
#define __ROOMJoin_LISTENER_H__

#include <vector>
#include "VideoRoomMessage.pb.h"
#include "CommonroomMessage.pb.h"

class VideoRoomJoinListener
{
public:
	//���뷿��Ԥ����
	virtual void OnPreJoinRoomResp(PreJoinRoomResp& info) = 0;

	//���뷿��ɹ�
	virtual void OnJoinRoomResp(JoinRoomResp& info) = 0;

	//���뷿��ʧ��
	virtual void OnJoinRoomErr(JoinRoomErr& info) = 0;

};


#endif
