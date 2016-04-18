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
	} //���뷿��ɹ�

	void OnJoinRoomErr(JoinRoomErr& info)
	{
		info.Log();
		jni_on_JoinRoomErr(uiEnv, roomListener, onJoinRoomErr, info);
	} //���뷿��ʧ��

	void OnRoomUserList(std::vector<RoomUserInfo>& infos) //�����û��б�����
	{
		callback_list(uiEnv, roomListener, RoomUserInfo, onGetUserList);
	}

	void OnRoomUserNoty(RoomUserInfo& info) //�����û�֪ͨ
	{
		info.Log(); //OK
		jni_on_RoomUserInfo(uiEnv, roomListener, onUserCome, info);
	}

	void OnRoomPubMicStateNoty(std::vector<RoomPubMicState>& infos) //����״̬����
	{
		callback_list(uiEnv, roomListener, RoomPubMicState, onGetRoomPubMicState);
	}

	void OnRoomUserExitResp() //
	{
	}

	void OnRoomUserExceptExitNoty(UserExceptExitRoomInfo_ext& info) //�����û��˳�֪ͨ
	{
		info.Log(); //OK
		jni_on_UserExceptExitRoomInfo_ext(uiEnv, roomListener, onUserExit, info);
	}

	void OnRoomKickoutUserResp()
	{
	} //

	void OnRoomKickoutUserNoty(UserKickoutRoomInfo_ext& info) //�����û��߳�֪ͨ
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
	}	//�����б�

	void OnChatErr()
	{
	}	//

	void OnChatNotify(RoomChatMsg& info)
	{
		info.Log();	//OK
		jni_on_RoomChatMsg(uiEnv, roomListener, onChatNotify, info);
	}	//����֪ͨ����

	//������
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
	//�ͻ�
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

	//�̻�
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
	}	//�����н�֪ͨ����

	void OnBoomGiftNotify(BoomGiftNotice& info)
	{
		info.Log();
	}	//��ը�н�֪ͨ����

	void OnSysNoticeInfo(SysCastNotice& info)
	{
		info.Log();	//OK
	}	//ϵͳ��Ϣ֪ͨ����

	void OnUserAccountInfo(UserAccountInfo& info)
	{
		info.Log();
		jni_on_UserAccountInfo(uiEnv, roomListener, onUserAccountInfoChanged, info);
	}	//�û��ʻ�����

	void OnRoomManagerNotify()
	{
		//info.Log();
	}	//�������֪ͨ����

	void OnRoomMediaInfo(RoomMediaInfo& info)
	{
		info.Log();
	}	//����ý������֪ͨ

	void OnRoomNoticeNotify(RoomNotice& info)
	{
		info.Log();	//OK
		jni_on_RoomNotice(uiEnv, roomListener, onRoomNoticeNotify, info);
	}	//���乫������֪ͨ

	void OnRoomOpState(RoomOpState& info)
	{
		info.Log();
	}	//����״̬����֪ͨ

	void OnRoomInfoNotify(RoomBaseInfo& info)
	{
		info.Log();	//OK
	}	//������Ϣ����֪ͨ

	void OnThrowUserNotify(ThrowUserInfo& info)
	{
		info.Log();
	}	//�����ɱ�û�֪ͨ

	void OnUpWaitMicResp(UpWaitMic& info)
	{
		info.Log();
		//LOG("OnUpWaitMicResp = %d", ret);
	}	//��������Ӧ
	void OnUpWaitMicErr(UpWaitMic& info)
	{
		info.Log();
		//LOG("OnUpWaitMicErr = %d", ret);
	}	//���������

	void OnChangePubMicStateNotify(ChangePubMicStateNoty& info)
	{
		info.Log();	//OK
	}	//����״̬֪ͨ

		//����ý��
	void OnTransMediaReq()
	{
	}	//����ý������
	void OnTransMediaResp()
	{
	}	//����ý����Ӧ
	void OnTransMediaErr()
	{
	}	//����ý�����

	//������״̬
	void OnSetMicStateResp()
	{
	}	//������״̬��Ӧ
	void OnSetMicStateErr(UserMicState& info)
	{
		info.Log();
	}	//������״̬����
	void OnSetMicStateNotify(UserMicState& info)
	{
		info.Log();	//OK
		jni_on_UserMicState(uiEnv, roomListener, onMicStateNotify, info);
	}	//������״̬֪ͨ

		//�����豸״̬
	void OnSetDevStateResp(UserDevState& info)
	{
		info.Log();	//OK
	}	//�����豸״̬��Ӧ
	void OnSetDevStateErr(UserDevState& info)
	{
		info.Log();	//OK
	}	//�����豸״̬����
	void OnSetDevStateNotify(UserDevState& info)
	{
		info.Log();	//OK
	}	//�����豸״̬֪ͨ

		//�����û��س�
	void OnSetUserAliasResp(UserAliasState& info)
	{
		info.Log();	//OK
	}	//�����û��س���Ӧ
	void OnSetUserAliasErr(UserAliasState& info)
	{
		info.Log();	//OK
	}	//�����û��سƴ���
	void OnSetUserAliasNotify(UserAliasState& info)
	{
		info.Log();	//OK
		jni_on_UserAliasState(uiEnv, roomListener, onUserAliasNotify, info);
	}	//�����û��س�֪ͨ

		//�����û�Ȩ��(����)
	void OnSetUserPriorityResp(SetUserPriorityResp& info)
	{
		info.Log();	//OK
	}	//�����û�Ȩ��(����)��Ӧ
	void OnSetUserPriorityNotify(SetUserPriorityResp& info)
	{
		info.Log();	//OK
	}	//�����û�Ȩ��(����)��Ӧ

		//�쿴�û�IP
	void OnSeeUserIpResp(SeeUserIpResp& info)
	{
		info.Log();	//OK
	}	//�쿴�û�IP��Ӧ
	void OnSeeUserIpErr(SeeUserIpResp& info)
	{
		info.Log();	//OK
	}	//�쿴�û�IP����

	void OnThrowUserResp(ThrowUserInfoResp& info)
	{
		info.Log();
	}	//��ɱ�����û���Ӧ

	void OnForbidUserChatNotify(ForbidUserChat& info)
	{
		info.Log();	//OK
		jni_on_ForbidUserChat(uiEnv, roomListener, onForbidUserChat, info);
	}	//����֪ͨ

	void OnSetRoomNoticeResp(SetRoomNoticeResp& info)
	{
		info.Log();	//OK
	}	//���÷��乫����Ӧ

	void OnSetRoomInfoResp(SetRoomInfoResp& info)
	{
		info.Log();	//OK
	}	//���÷�����Ϣ��Ӧ

	void OnSetRoomOPStatusResp(SetRoomOPStatusResp& info)
	{
		info.Log();	//OK
	}	//���÷���״̬��Ϣ��Ӧ

	void OnQueryUserAccountResp(QueryUserAccountResp& info)
	{
		info.Log();	//OK
	}	//��ѯ�û��ʻ���Ӧ

	void OnSetWatMicMaxNumLimitNotify(SetRoomWaitMicMaxNumLimit& info)
	{
		info.Log();
	}	//���÷��������������ÿ������������ ֪ͨ

	void OnChangeWaitMicIndexResp(ChangeWaitMicIndexResp& info)
	{
		info.Log();
	}	//�޸�����������Ӧ

	void OnSetForbidInviteUpMicNotify(SetForbidInviteUpMic& info)
	{
		info.Log();
	}	//���ý�ֹ����֪ͨ

	void OnSiegeInfoNotify(SiegeInfo& info)
	{
		info.Log();
	}	//������Ϣ֪ͨ

	void OnOpenChestResp(OpenChestResp& info)
	{
		info.Log();
	}	//��������Ӧ

	void OnQueryUserMoreInfoResp(UserMoreInfo& info)
	{
		info.Log();
	}	//

	void OnSetUserProfileResp(SetUserProfileResp& info)
	{
		info.Log();
	}	//�����û�������Ϣ��Ӧ

	void OnClientPingResp(ClientPingResp& info)
	{
		info.Log();	//OK
	}	//�յ�������ping��Ϣ�ķ���,��ʾ�������

	void OnCloseRoomNotify(CloseRoomNoty& info)
	{
		info.Log();
	}	//���䱻�ر���Ϣ,ֱ���˳���ǰ����

	void OnDoNotReachRoomServer()
	{
		//info.Log();
	}	//�յ����䲻�ɵ�����Ϣ

	void OnLotteryPoolNotify(LotteryPoolInfo& info)
	{
		info.Log();
	}	//�յ����˱��佱����Ϣ

		//��ʱû��
	void OnSetUserHideStateResp(SetUserHideStateResp& info)
	{
		info.Log();
	}	//

	void OnSetUserHideStateNoty(SetUserHideStateNoty& info)
	{
		info.Log();
	}	//

		//��ʱ����
	void OnUserAddChestNumNoty(UserAddChestNumNoty& info)
	{
		info.Log();
	}	//�յ��û������±���֪ͨ

	void OnAddClosedFriendNoty(AddClosedFriendNotify& info)
	{
		info.Log();
	}	//�յ�����������������֪ͨ

	void OnAdKeyWordOperateNoty(AdKeywordsNotify& info)
	{
		info.Log();	//OK
	}	//�յ����Թؼ���ˢ��֪ͨ

	void OnAdKeyWordOperateResp(AdKeywordsResp& info)
	{
		info.Log();	//OK
	}	//�յ����Թؼ��ʸ���֪ͨ

	void OnTeacherScoreResp(TeacherScoreResp& info)
	{
		info.Log();	//OK
	}	//�յ���ʦ������Ӧ

	void OnTeacherScoreRecordResp(TeacherScoreRecordResp& info)
	{
		info.Log();	//OK
	}	//�յ��û�������Ӧ

	void OnRobotTeacherIdNoty(RobotTeacherIdNoty& info)
	{
		info.Log();	//OK
		jni_on_RobotTeacherIdNoty(uiEnv, roomListener, onRobotTeacherIdNoty, info);
	}	//��������˶�Ӧ��ʦID֪ͨ

	void OnTeacherGiftListResp(std::vector<TeacherGiftListResp>& infos)
	{
		for (int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();	//OK
		}
	}	//��ʦ��ʵ���ܰ���Ӧ

	void OnHitGoldEggToClientNoty(HitGoldEggClientNoty& info)
	{
		info.Log();
	}	//�ҽ𵰸���99������ֵ

	void OnUserScoreNotify(UserScoreNoty& info)
	{
		info.Log();	//OK
	}	//�û��Խ�ʦ������

	void OnUserScoreListNotify(std::vector<UserScoreNoty>& infos)
	{
		for (int i = 0; i < infos.size(); i++)
		{
			infos[i].Log();	//OK
		}
	}	//�û��Խ�ʦ�������б�

	void OnTeacherAvarageScoreNoty(TeacherAvarageScoreNoty& info)
	{
		info.Log();	//OK
	}	//�û��Խ�ʦ��ƽ����

	void OnRoomAndSubRoomId_Noty(RoomAndSubRoomIdNoty& info)
	{
		info.Log();	//OK
		jni_on_RoomAndSubRoomIdNoty(uiEnv, roomListener, onGetMainRoomId, info);
	}	//

	void OnSysCastResp(Syscast& info)
	{
		info.Log();	//OK
	}	//ϵͳ����

	//��ͨ�û���������
	virtual void OnRoomUserInfoResp(RoomUserInfoResp& info) {}

	//���ֽ�ʦ��������
	virtual void OnTeacherInfoResp(TeacherInfoResp& info) {}

	//��ȡ�û���������ʧ��
	virtual void OnUserInfoErr(UserInfoErr& info) {}

	//�γ̶��ķ���
	virtual void OnTeacherSubscriptionResp(TeacherSubscriptionResp& info) {}

	//��ѯ����״̬��Ӧ
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

