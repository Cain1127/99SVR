/**
 * todo
 * env->DeleteGlobalRef(jmsg);
 */

#include "jni_room_conv.h"
#include "platform.h"
#include "Thread.h"
#include "Socket.h"
#include "VideoRoomConnection.h"
#include "Json.h"
#include "Http.h"


static RoomConnection conn;

static int registed = 0;
static jobject roomListener = NULL;

static JNIEnv* gEnv;
static JNIEnv* uiEnv;

static bool isAttacked = false;

static void getGEnv()
{
	isAttacked = false;
	int status = gJavaVM->GetEnv((void **) &gEnv, JNI_VERSION_1_4);
	if (status < 0)
	{
		LOG("callback_handler:failed to get JNI environment assuming native thread........");
		status = gJavaVM->AttachCurrentThread(&gEnv, NULL);
		if (status < 0)
		{
			LOG("callback_handler: failed to attach current thread");
			return;
		}
		isAttacked = true;
	}
}

static void DetachEnv()
{
	if (isAttacked)
	{
		gJavaVM->DetachCurrentThread();
	}
}


class JNIRoomListener : public RoomListener
{
	void OnMessageComming(void* msg)
	{
		getGEnv();

		int msgLen = *((int*) msg);
		jbyte *by = (jbyte*) msg;
		//jbyteArray jarray = (jbyteArray) gEnv->NewGlobalRef(gEnv->NewByteArray(msgLen + 1));
		jbyteArray jarray = gEnv->NewByteArray(msgLen + 1);
		gEnv->SetByteArrayRegion(jarray, 0, msgLen + 1, by);
		delete[] (char*) msg;
		callback(gEnv, roomListener, "onMessageComming", "([B)V", jarray);
		gEnv->DeleteLocalRef(jarray);

		DetachEnv();
	}

	void OnJoinRoomResp(JoinRoomResp& info)
	{
		info.Log();
		jni_on_JoinRoomResp(uiEnv, roomListener, onJoinRoomResp, info);
	} //加入房间成功

	void OnJoinRoomErr(JoinRoomErr& info)
	{
		info.Log();
		jni_on_JoinRoomErr(uiEnv, roomListener, onJoinRoomErr, info);
	} //加入房间失败

	void OnRoomUserList(std::vector<RoomUserInfo>& infos) //房间用户列表数据
	{
		callback_list(uiEnv, roomListener, RoomUserInfo, onGetUserList);
	}

	void OnRoomUserNoty(RoomUserInfo& info) //新增用户通知
	{
		info.Log(); //OK
		jni_on_RoomUserInfo(uiEnv, roomListener, onUserCome, info);
	}

	void OnRoomPubMicStateNoty(std::vector<RoomPubMicState>& infos) //公麦状态数据
	{
		callback_list(uiEnv, roomListener, RoomPubMicState, onGetRoomPubMicState);
	}

	void OnRoomUserExitResp() //
	{
	}

	void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info) //房间用户退出通知
	{
		info.Log(); //OK
		jni_on_UserExceptExitRoomInfo_ext(uiEnv, roomListener, onUserExit, info);
	}

	void OnRoomKickoutUserResp()
	{
	} //

	void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info) //房间用户踢出通知
	{
		info.Log(); //OK
		jni_on_UserKickoutRoomInfo_ext(uiEnv, roomListener, onKickoutUserNoty, info);
	}

	void OnWaitiMicListInfo(std::vector<int> &infos)
	{
		for (int i = 0; i < infos.size(); i++)
		{
			LOG("%d", infos[i]);	//OK
		}
	}	//排麦列表

	void OnChatErr()
	{
	}	//

	void OnChatNotify(RoomChatMsg& info)
	{
		info.Log();	//OK
		jni_on_RoomChatMsg(uiEnv, roomListener, onChatNotify, info);
	}	//聊天通知数据

	//送礼物
	void OnTradeGiftRecordResp(TradeGiftRecord& info)
	{
		info.Log();
	}

	void OnTradeGiftErr(TradeGiftErr& info)
	{
		info.Log();
		jni_on_TradeGiftErr(uiEnv, roomListener, onGiveGiftError, info);
	}

	void OnTradeGiftNotify(TradeGiftRecord& info)
	{
		info.Log();	//OK
		jni_on_TradeGiftRecord(uiEnv, roomListener, onReceivedGift, info);
	}
	//送花
	void OnTradeFlowerResp(TradeFlowerRecord& info)
	{
		info.Log();
	}

	void OnTradeFlowerErr(TradeFlowerRecord& info)
	{
		info.Log();
	}

	void OnTradeFlowerNotify(TradeFlowerRecord& info)
	{
		info.Log();
	}

	//烟火
	void OnTradeFireworksErr(TradeFireworksErr& info)
	{
		info.Log();
	}

	void OnTradeFireworksNotify(TradeFireworksNotify& info)
	{
		info.Log();
	}

	void OnLotteryGiftNotify(LotteryGiftNotice& info)
	{
		info.Log();
	}	//礼物中奖通知数据

	void OnBoomGiftNotify(BoomGiftNotice& info)
	{
		info.Log();
	}	//爆炸中奖通知数据

	void OnSysNoticeInfo(SysCastNotice& info)
	{
		info.Log();	//OK
	}	//系统消息通知数据

	void OnUserAccountInfo(UserAccountInfo& info)
	{
		info.Log();
		jni_on_UserAccountInfo(uiEnv, roomListener, onUserAccountInfoChanged, info);
	}	//用户帐户数据

	void OnRoomManagerNotify()
	{
		//info.Log();
	}	//房间管理通知数据

	void OnRoomMediaInfo(RoomMediaInfo& info)
	{
		info.Log();
	}	//房间媒体数据通知

	void OnRoomNoticeNotify(RoomNotice& info)
	{
		info.Log();	//OK
		jni_on_RoomNotice(uiEnv, roomListener, onRoomNoticeNotify, info);
	}	//房间公告数据通知

	void OnRoomOpState(RoomOpState& info)
	{
		info.Log();
	}	//房间状态数据通知

	void OnRoomInfoNotify(RoomBaseInfo& info)
	{
		info.Log();	//OK
	}	//房间信息数据通知

	void OnThrowUserNotify(ThrowUserInfo& info)
	{
		info.Log();
	}	//房间封杀用户通知

	void OnUpWaitMicResp(UpWaitMic& info)
	{
		info.Log();
		//LOG("OnUpWaitMicResp = %d", ret);
	}	//上排麦响应
	void OnUpWaitMicErr(UpWaitMic& info)
	{
		info.Log();
		//LOG("OnUpWaitMicErr = %d", ret);
	}	//上排麦错误

	void OnChangePubMicStateNotify(ChangePubMicStateNoty& info)
	{
		info.Log();	//OK
	}	//公麦状态通知

		//传输媒体
	void OnTransMediaReq()
	{
	}	//传输媒体请求
	void OnTransMediaResp()
	{
	}	//传输媒体响应
	void OnTransMediaErr()
	{
	}	//传输媒体错误

	//设置麦状态
	void OnSetMicStateResp()
	{
	}	//设置麦状态响应
	void OnSetMicStateErr(UserMicState& info)
	{
		info.Log();
	}	//设置麦状态错误
	void OnSetMicStateNotify(UserMicState& info)
	{
		info.Log();	//OK
		jni_on_UserMicState(uiEnv, roomListener, onMicStateNotify, info);
	}	//设置麦状态通知

		//设置设备状态
	void OnSetDevStateResp(UserDevState& info)
	{
		info.Log();	//OK
	}	//设置设备状态响应
	void OnSetDevStateErr(UserDevState& info)
	{
		info.Log();	//OK
	}	//设置设备状态错误
	void OnSetDevStateNotify(UserDevState& info)
	{
		info.Log();	//OK
	}	//设置设备状态通知

		//设置用户呢称
	void OnSetUserAliasResp(UserAliasState& info)
	{
		info.Log();	//OK
	}	//设置用户呢称响应
	void OnSetUserAliasErr(UserAliasState& info)
	{
		info.Log();	//OK
	}	//设置用户呢称错误
	void OnSetUserAliasNotify(UserAliasState& info)
	{
		info.Log();	//OK
		jni_on_UserAliasState(uiEnv, roomListener, onUserAliasNotify, info);
	}	//设置用户呢称通知

		//设置用户权限(管理)
	void OnSetUserPriorityResp(SetUserPriorityResp& info)
	{
		info.Log();	//OK
	}	//设置用户权限(管理)响应
	void OnSetUserPriorityNotify(SetUserPriorityResp& info)
	{
		info.Log();	//OK
	}	//设置用户权限(管理)响应

		//察看用户IP
	void OnSeeUserIpResp(SeeUserIpResp& info)
	{
		info.Log();	//OK
	}	//察看用户IP响应
	void OnSeeUserIpErr(SeeUserIpResp& info)
	{
		info.Log();	//OK
	}	//察看用户IP错误

	void OnThrowUserResp(ThrowUserInfoResp& info)
	{
		info.Log();
	}	//封杀房间用户响应

	void OnForbidUserChatNotify(ForbidUserChat& info)
	{
		info.Log();	//OK
		jni_on_ForbidUserChat(uiEnv, roomListener, onForbidUserChat, info);
	}	//禁言通知

	void OnSetRoomNoticeResp(SetRoomNoticeResp& info)
	{
		info.Log();	//OK
	}	//设置房间公告响应

	void OnSetRoomInfoResp(SetRoomInfoResp& info)
	{
		info.Log();	//OK
	}	//设置房间信息响应

	void OnSetRoomOPStatusResp(SetRoomOPStatusResp& info)
	{
		info.Log();	//OK
	}	//设置房间状态信息响应

	void OnQueryUserAccountResp(QueryUserAccountResp& info)
	{
		info.Log();	//OK
	}	//查询用户帐户响应

	void OnSetWatMicMaxNumLimitNotify(SetRoomWaitMicMaxNumLimit& info)
	{
		info.Log();
	}	//设置房间最大排麦数，每人最多排麦次数 通知

	void OnChangeWaitMicIndexResp(ChangeWaitMicIndexResp& info)
	{
		info.Log();
	}	//修改排麦麦序响应

	void OnSetForbidInviteUpMicNotify(SetForbidInviteUpMic& info)
	{
		info.Log();
	}	//设置禁止抱麦通知

	void OnSiegeInfoNotify(SiegeInfo& info)
	{
		info.Log();
	}	//城主信息通知

	void OnOpenChestResp(OpenChestResp& info)
	{
		info.Log();
	}	//开宝箱响应

	void OnQueryUserMoreInfoResp(UserMoreInfo& info)
	{
		info.Log();
	}	//

	void OnSetUserProfileResp(SetUserProfileResp& info)
	{
		info.Log();
	}	//设置用户配置信息响应

	void OnClientPingResp(ClientPingResp& info)
	{
		info.Log();	//OK
	}	//收到服务器ping消息的返回,表示房间活着

	void OnCloseRoomNotify(CloseRoomNoty& info)
	{
		info.Log();
	}	//房间被关闭消息,直接退出当前房间

	void OnDoNotReachRoomServer()
	{
		//info.Log();
	}	//收到房间不可到达消息

	void OnLotteryPoolNotify(LotteryPoolInfo& info)
	{
		info.Log();
	}	//收到幸运宝箱奖池消息

		//暂时没用
	void OnSetUserHideStateResp(SetUserHideStateResp& info)
	{
		info.Log();
	}	//

	void OnSetUserHideStateNoty(SetUserHideStateNoty& info)
	{
		info.Log();
	}	//

		//暂时废置
	void OnUserAddChestNumNoty(UserAddChestNumNoty& info)
	{
		info.Log();
	}	//收到用户增加新宝箱通知

	void OnAddClosedFriendNoty(AddClosedFriendNotify& info)
	{
		info.Log();
	}	//收到赠送礼物增加密友通知

	void OnAdKeyWordOperateNoty(AdKeywordsNotify& info)
	{
		info.Log();	//OK
	}	//收到禁言关键词刷新通知

	void OnAdKeyWordOperateResp(AdKeywordsResp& info)
	{
		info.Log();	//OK
	}	//收到禁言关键词更新通知

	void OnTeacherScoreResp(TeacherScoreResp& info)
	{
		info.Log();	//OK
	}	//收到讲师评分响应

	void OnTeacherScoreRecordResp(TeacherScoreRecordResp& info)
	{
		info.Log();	//OK
	}	//收到用户评分响应

	void OnRobotTeacherIdNoty(RobotTeacherIdNoty& info)
	{
		info.Log();	//OK
		jni_on_RobotTeacherIdNoty(uiEnv, roomListener, onRobotTeacherIdNoty, info);
	}	//上麦机器人对应讲师ID通知

	void OnTeacherGiftListResp(std::vector<TeacherGiftListResp>& infos)
	{
		for (int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();	//OK
		}
	}	//讲师忠实度周版响应

	void OnHitGoldEggToClientNoty(HitGoldEggClientNoty& info)
	{
		info.Log();
	}	//砸金蛋更新99币最新值

	void OnUserScoreNotify(UserScoreNoty& info)
	{
		info.Log();	//OK
	}	//用户对讲师的评分

	void OnUserScoreListNotify(std::vector<UserScoreNoty>& infos)
	{
		for (int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();	//OK
		}
	}	//用户对讲师的评分列表

	void OnTeacherAvarageScoreNoty(TeacherAvarageScoreNoty& info)
	{
		info.Log();	//OK
	}	//用户对讲师的平均分

	void OnRoomAndSubRoomId_Noty(RoomAndSubRoomIdNoty& info)
	{
		info.Log();	//OK
		jni_on_RoomAndSubRoomIdNoty(uiEnv, roomListener, onGetMainRoomId, info);
	}	//

	void OnSysCastResp(Syscast& info)
	{
		info.Log();	//OK
	}	//系统公告

	//普通用户个人资料
	virtual void OnRoomUserInfoResp(RoomUserInfoResp& info) {}

	//文字讲师个人资料
	virtual void OnTeacherInfoResp(TeacherInfoResp& info) {}

	//获取用户个人资料失败
	virtual void OnUserInfoErr(UserInfoErr& info) {}

	//课程订阅返回
	virtual void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info) {}

	//查询订阅状态响应
	virtual void OnTeacherSubscriptionStateQueryResp(TeacherSubscriptionStateQueryResp& info) {}

};


class JNIRoomConnectionListener: public ConnectionListener
{
public:
	void OnConnected()
	{
		LOG("OnConnected native");
		getGEnv();
		callback(gEnv, roomListener, "onConnected", "()V");
		DetachEnv();
	}

	void OnConnectError(int err_code)
	{
		LOG("OnConnectError:%d", err_code);
		getGEnv();
		callback(gEnv, roomListener, "onConnectError", "(I)V", err_code);
		DetachEnv();
	}

	void OnIOError(int err_code)
	{
		LOG("OnIOError");
		getGEnv();
		callback(gEnv, roomListener, "onIOError", "(I)V", err_code);
		DetachEnv();
	}

};

static JNIRoomConnectionListener conn_listener;
static JNIRoomListener room_listener;

extern "C"
{
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_RoomConnection_setRoomListener(JNIEnv* env, jobject obj, jobject jListener);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_RoomConnection_dispatchSocketMessage(JNIEnv* env, jobject obj, jbyteArray jmsg);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_RoomConnection_requestJoinRoom(JNIEnv* env, jobject obj, jobject jreq);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_RoomConnection_favoriteRoom(JNIEnv* env, jobject obj, jint action);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_RoomConnection_sendChatMessage(JNIEnv* env, jobject obj, jobject jreq);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_RoomConnection_giveGift(JNIEnv* env, jobject obj, jobject jreq);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_RoomConnection_close(JNIEnv* env, jobject obj);
}

void registerRoomListener()
{
	if (!registed)
	{
		registed = 1;
		conn.RegisterConnectionListener(&conn_listener);
		conn.RegisterMessageListener(&room_listener);
	}
}


JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_RoomConnection_setRoomListener(JNIEnv* env, jobject obj, jobject jListener)
{
	if (roomListener != NULL)
	{
		env->DeleteGlobalRef(roomListener);
	}
	roomListener = env->NewGlobalRef(jListener);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_RoomConnection_dispatchSocketMessage(JNIEnv* env, jobject obj, jbyteArray jmsg)
{
	uiEnv = env;
	jbyte* tmpdata = (jbyte*) env->GetByteArrayElements(jmsg, NULL);
	conn.DispatchSocketMessage(tmpdata);
	env->ReleaseByteArrayElements(jmsg, tmpdata, 0);
	//env->DeleteLocalRef(jmsg);
	//env->DeleteGlobalRef(jmsg);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_RoomConnection_requestJoinRoom(JNIEnv* env, jobject obj, jobject jreq)
{
	registerRoomListener();
	jni_send_JoinRoomReq2(SendMsg_JoinRoomReq2, env, jreq);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_RoomConnection_favoriteRoom(JNIEnv* env, jobject obj, jint action)
{
	conn.SendMsg_CollectRoomReq(action);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_RoomConnection_sendChatMessage(JNIEnv* env, jobject obj, jobject jreq)
{
	jni_send_RoomChatMsg(SendMsg_RoomChatReq, env, jreq);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_RoomConnection_giveGift(JNIEnv* env, jobject obj, jobject jreq)
{
	jni_send_TradeGiftRecord(SendMsg_TradeGiftReq, env, jreq);
}


JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_RoomConnection_close(JNIEnv* env, jobject obj)
{
	conn.close();
}

