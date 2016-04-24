
#include "platform.h"
#include "Thread.h"
#include "Socket.h"
#include "LoginConnection.h"
#include "Json.h"
#include "Http.h"

JavaVM *gJavaVM;

static LoginConnection conn;

static int registed = 0;
static jobject loginListener = NULL;
static jobject hallListener = NULL;
static jobject pushListener = NULL;

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

class JNILoginListener: public LoginListener
{

public:

	void OnMessageComming(void* msg)
	{
		getGEnv();

		int msgLen = *((int*) msg);
		jbyte *by = (jbyte*) msg;
		jbyteArray jarray = gEnv->NewByteArray(msgLen + 1);
		gEnv->SetByteArrayRegion(jarray, 0, msgLen + 1, by);
		delete[] (char*) msg;
		callback(gEnv, loginListener, "onMessageComming", "([B)V", jarray);
		gEnv->DeleteLocalRef(jarray);
		DetachEnv();
	}

	void OnLogonSuccess(UserLogonSuccess2& info)
	{
		jni_on_UserLogonSuccess2(uiEnv, loginListener, onLogonSuccess, info);
	}

	void OnLogonErr(UserLogonErr2& info)
	{
		jni_on_UserLogonErr2(uiEnv, loginListener, onLogonErr, info);
	}

	void OnRoomGroupList(RoomGroupItem items[], int count)
	{
		for (int i = 0; i < count; i++)
		{
			//items[i].Log();
		}
	}

	void OnQuanxianId2List(QuanxianId2Item items[], int count)
	{
		for (int i = 0; i < count; i++)
		{
			//items[i].Log();
		}
	}

	void OnQuanxianAction2List(QuanxianAction2Item items[], int count)
	{
		for (int i = 0; i < count; i++)
		{
			//items[i].Log();
		}
	}

	void OnLogonTokenNotify(SessionTokenResp& info)
	{
		jni_on_SessionTokenResp(uiEnv, loginListener, onLogonTokenNotify, info);
	}

	void OnLogonFinished()
	{
		callback(uiEnv, loginListener, "onLogonFinished", "()V");
	}

};

class JNIHallListener: public HallListener
{

	void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req)
	{
		info.Log();
		//jni_on_SetUserProfileResp(uiEnv, hallListener, onSetUserProfileResp, info);

		jni_get_SetUserProfileReq(uiEnv, req);
		callback(uiEnv, hallListener, "onSetUserProfileResp", "(ILcom/jjcj/protocol/jni/LoginMessage$SetUserProfileReq;)V", info.errorid(), jinfo);
	}

	void OnSetUserPwdResp(SetUserPwdResp& info)
	{
		jni_on_SetUserPwdResp(uiEnv, hallListener, onSetUserPwdResp, info);
	}

	void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info)
	{
		jni_on_QueryRoomGateAddrResp(uiEnv, hallListener, onQueryRoomGateAddrResp, info);
	}

	void OnGetUserMoreInfResp(GetUserMoreInfResp& info)
	{
		jni_on_GetUserMoreInfResp(uiEnv, hallListener, onGetUserMoreInfResp, info);
	}

	void OnUserExitMessageResp(ExitAlertResp& info)
	{
	}

	void OnHallMessageNotify(MessageNoty& info){}
	void OnMessageUnreadResp(MessageUnreadResp& info){}

	//7¸öÁÐ±í
	void OnInteractResp(std::vector<InteractResp>& infos){}
	void OnHallAnswerResp(std::vector<AnswerResp>& infos){}
	void OnViewShowResp(std::vector<ViewShowResp>& infos){}
	void OnTeacherFansResp(std::vector<TeacherFansResp>& infos){}
	void OnInterestResp(std::vector<InterestResp>& infos){}
	void OnUnInterestResp(std::vector<UnInterestResp>& infos){}
	void OnTextLivePointListResp(std::vector<TextLivePointListResp>& infos){}
	/////////

	//void OnSecretsListResp(HallSecretsListResp& infos){}
	//void OnSystemInfoResp(HallSystemInfoListResp& infos){}
	virtual void OnSecretsListResp(std::vector<HallSecretsListResp>& infos){}
	virtual void OnSystemInfoResp(std::vector<HallSystemInfoListResp>& infos) {}


	void OnViewAnswerResp(ViewAnswerResp& info){}
	void OnInterestForResp(InterestForResp& info){}
	void OnFansCountResp(FansCountResp& info){}

};

class JNIPushListener: public PushListener
{

	void OnConfChanged(int version)
	{
		callback(uiEnv, pushListener, "onConfChanged", "(I)V", version);
	}
	void OnGiftListChanged(int version)
	{
		callback(uiEnv, pushListener, "onGiftListChanged", "(I)V", version);
	}
	void OnShowFunctionChanged(int version)
	{
		callback(uiEnv, pushListener, "onShowFunctionChanged", "(I)V", version);
	}
	void OnPrintLog()
	{
		callback(uiEnv, pushListener, "onPrintLog", "()V");
	}
	void OnUpdateApp()
	{
		callback(uiEnv, pushListener, "onUpdateApp", "()V");
	}
	void OnMoneyChanged(uint64 money)
	{
		callback(uiEnv, pushListener, "onMoneyChanged", "(J)V", money);
	}
	void OnBayWindow(BayWindow& info)
	{
		jni_on_BayWindow(uiEnv, pushListener, onBayWindow, info);
	}
	void OnRoomGroupChanged()
	{
		callback(uiEnv, pushListener, "onRoomGroupChanged", "()V");
	}
	void OnRoomTeacherOnMicResp(RoomTeacherOnMicResp& info)
	{
	}
};

class JNIConnectionListener: public ConnectionListener
{
public:
	void OnConnected()
	{
		LOG("OnConnected");
		getGEnv();
		callback(gEnv, loginListener, "onConnected", "()V");
		DetachEnv();
	}

	void OnConnectError(int err_code)
	{
		LOG("OnConnectError:%d", err_code);
		getGEnv();
		callback(gEnv, loginListener, "onConnectError", "(I)V", err_code);
		DetachEnv();
	}

	void OnIOError(int err_code)
	{
		LOG("OnIOError");
		getGEnv();
		callback(gEnv, loginListener, "onIOError", "(I)V", err_code);
		DetachEnv();
	}

};

static JNIConnectionListener conn_listener;
static JNILoginListener login_listener;
static JNIHallListener hall_listener;
static JNIPushListener push_listener;

extern "C"
{
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_setCachePath(JNIEnv* env, jobject obj, jstring jpath);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_setLoginListener(JNIEnv* env, jobject obj, jobject jListener);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_setPushListener(JNIEnv* env, jobject obj, jobject jListener);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_setHallListener(JNIEnv* env, jobject obj, jobject jListener);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_requestLogin(JNIEnv* env, jobject obj, jobject jreq);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_requestLoginOutsize(JNIEnv* env, jobject obj, jobject jreq);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_dispatchSocketMessage(JNIEnv* env, jobject obj, jbyteArray jmsg);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_setUserInfoReq(JNIEnv* env, jobject obj, jobject jreq);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_setUserPwdReq(JNIEnv* env, jobject obj, jint vcbid, jint pwdtype, jstring joldpwd, jstring jnewpwd);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_sessionTokenReq(JNIEnv* env, jobject obj, jint userid);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_getUserMoreInfReq(JNIEnv* env, jobject obj, jint userid);
JNIEXPORT void JNICALL Java_com_jjcj_protocol_jni_LoginConnection_close(JNIEnv* env, jobject obj);
}

void registerLogin()
{
	if (!registed)
	{
		registed = 1;
		conn.RegisterConnectionListener(&conn_listener);
		conn.RegisterMessageListener(&login_listener);
		conn.RegisterHallListener(&hall_listener);
		conn.RegisterPushListener(&push_listener);
	}
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_setCachePath(JNIEnv* env, jobject obj, jstring jpath)
{
	const char *path = env->GetStringUTFChars(jpath, 0);
	SetProtocolCachePath(path);
	env->ReleaseStringUTFChars(jpath, path);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_setLoginListener(JNIEnv* env, jobject obj, jobject jListener)
{
	if (loginListener != NULL)
	{
		env->DeleteGlobalRef(loginListener);
	}
	loginListener = env->NewGlobalRef(jListener);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_setHallListener(JNIEnv* env, jobject obj, jobject jListener)
{
	if (hallListener != NULL)
	{
		env->DeleteGlobalRef(hallListener);
	}
	hallListener = env->NewGlobalRef(jListener);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_setPushListener(JNIEnv* env, jobject obj, jobject jListener)
{
	if (pushListener != NULL)
	{
		env->DeleteGlobalRef(pushListener);
	}
	pushListener = env->NewGlobalRef(jListener);
}


JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_dispatchSocketMessage(JNIEnv* env, jobject obj, jbyteArray jmsg)
{
	uiEnv = env;
	jbyte* tmpdata = (jbyte*) env->GetByteArrayElements(jmsg, NULL);
	conn.DispatchSocketMessage(tmpdata);
	env->ReleaseByteArrayElements(jmsg, tmpdata, 0);
	//env->DeleteLocalRef(jmsg);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_requestLogin(JNIEnv* env, jobject obj, jobject jreq)
{
	registerLogin();
	jni_send_UserLogonReq4(SendMsg_LoginReq4, env, jreq);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_requestLoginOutsize(JNIEnv* env, jobject obj, jobject jreq)
{
	registerLogin();
	jni_send_UserLogonReq5(SendMsg_LoginReq5, env, jreq);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_sessionTokenReq(JNIEnv* env, jobject obj, jint userid)
{
	conn.SendMsg_SessionTokenReq(userid);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_setUserInfoReq(JNIEnv* env, jobject obj, jobject jreq)
{
	jni_send_SetUserProfileReq(SendMsg_SetUserInfoReq, env, jreq);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_setUserPwdReq(JNIEnv* env, jobject obj, jint vcbid, jint pwdtype, jstring joldpwd, jstring jnewpwd)
{
	const char *oldpwd = env->GetStringUTFChars(joldpwd, 0);
	const char *newpwd = env->GetStringUTFChars(jnewpwd, 0);

	conn.SendMsg_SetUserPwdReq(vcbid, pwdtype, oldpwd, newpwd);

	env->ReleaseStringUTFChars(joldpwd, oldpwd);
	env->ReleaseStringUTFChars(jnewpwd, newpwd);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_getUserMoreInfReq(JNIEnv* env, jobject obj, jint userid)
{
	conn.SendMsg_GetUserMoreInfReq(userid);
}

JNIEXPORT void JNICALL
Java_com_jjcj_protocol_jni_LoginConnection_close(JNIEnv* env, jobject obj)
{
	conn.close();
}

jint JNI_OnLoad(JavaVM* vm, void* reserved)
{
	gJavaVM = vm;

	if (vm->GetEnv((void**) &gEnv, JNI_VERSION_1_4) != JNI_OK)
	{
		LOG("ERROR: GetEnv failed\n");
	}

	return JNI_VERSION_1_4;
}

