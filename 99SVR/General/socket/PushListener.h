
#ifndef __PUSH_LISTENER_H__
#define __PUSH_LISTENER_H__

#include <vector>
#include "LoginMessage.pb.h"
#include "VideoRoomMessage.pb.h"

class PushListener
{

public:

	// Õ∆ÀÕœ‡πÿ
	virtual void OnConfChanged(int version) = 0;
	virtual void OnGiftListChanged(int version) = 0;
	virtual void OnShowFunctionChanged(int version) = 0;
	virtual void OnPrintLog() = 0;
	virtual void OnUpdateApp() = 0;
	virtual void OnMoneyChanged(uint64 money) = 0;
	virtual void OnBayWindow(BayWindow& info) = 0;
	virtual void OnRoomGroupChanged() = 0;
	virtual void OnRoomTeacherOnMicResp(RoomTeacherOnMicResp& info) = 0;
};

#endif
