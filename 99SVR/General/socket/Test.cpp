// JJClientProtocol.cpp : 定义控制台应用程序的入口点。

#include "platform.h"
#include "Http.h"
#include "LoginConnection.h"
#include "json.h"
#include <vector>

LoginConnection conn;



class TestLoginListener : public LoginListener
{

public:

	void OnMessageComming(void* msg)
	{
		conn.DispatchSocketMessage(msg);
	}

	void OnLogonSuccess(UserLogonSuccess2& info) 
	{
		info.Log();
	}

	void OnLogonErr(UserLogonErr2& info) 
	{
		info.Log();
	}

	void OnRoomGroupList(RoomGroupItem items[], int count) 
	{
		for (int i = 0; i < count; i++)
		{
			items[i].Log();
		}
	}

	void OnQuanxianId2List(QuanxianId2Item items[], int count) 
	{
		for (int i = 0; i < count; i++)
		{
			items[i].Log();
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
		info.Log();
	}

	void OnLogonFinished() 
	{
		LOG("OnlogonFinished\n");
	}

};

class TestHallListener: public HallListener
{

	void OnSetUserProfileResp(SetUserProfileResp& info, SetUserProfileReq& req)
	{

	}

	void OnSetUserPwdResp(SetUserPwdResp& info)
	{

	}

	void OnQueryRoomGateAddrResp(QueryRoomGateAddrResp& info)
	{

	}

	void OnGetUserMoreInfResp(GetUserMoreInfResp& info)
	{

	}
	void OnUserExitMessageResp(ExitAlertResp& info)
	{
	}
	void OnHallMessageNotify(MessageNoty& info)
	{
	}
	void OnMessageUnreadResp(MessageUnreadResp& info)
	{
	}

	void OnInteractResp(std::vector<InteractResp>& infos)
	{
	}

	void OnHallAnswerResp(std::vector<AnswerResp>& infos)
	{
	}
	void OnViewShowResp(std::vector<ViewShowResp>& infos)
	{
	}
	void OnTeacherFansResp(std::vector<TeacherFansResp>& infos)
	{
	}
	void OnInterestResp(std::vector<InterestResp>& infos)
	{
	}
	void OnUnInterestResp(std::vector<UnInterestResp>& infos)
	{
	}
	void OnTextLivePointListResp(std::vector<TextLivePointListResp>& infos)
	{
	}

	void OnSecretsListResp(HallSecretsListResp& infos)
	{
	}

	void OnSystemInfoResp(HallSystemInfoListResp& infos)
	{
	}

	void OnViewAnswerResp(ViewAnswerResp& info)
	{
	}

	void OnInterestForResp(InterestForResp& info)
	{
	}
	void OnFansCountResp(FansCountResp& info)
	{
	}
};

class TestPushListener: public PushListener
{

	void OnConfChanged(int version)
	{
		LOG("OnConfChanged:%d", version);
	}
	void OnGiftListChanged(int version)
	{
	}
	void OnShowFunctionChanged(int version)
	{
	}
	void OnPrintLog()
	{
		LOG("OnPrintLog");
	}
	void OnUpdateApp()
	{
		LOG("OnUpdateApp------");
	}
	void OnMoneyChanged(uint64 money)
	{
		LOG("OnMoneyChanged:%d", money);
	}
	void OnBayWindow(BayWindow& info)
	{
		info.Log();
	}
	void OnRoomGroupChanged()
	{
	}
	void OnRoomTeacherOnMicResp(RoomTeacherOnMicResp& info)
	{
	}
};

class TestConnectionListener : public ConnectionListener
{
	void OnConnected()
	{
		LOG("OnConnected");
	}
	
	void OnConnectError(int err_code)
	{
		LOG("OnConnectError");
	}

	void OnIOError(int err_code)
	{
		LOG("OnIOError");
	}
};


TestLoginListener login_listener;
TestHallListener hall_listener;
TestPushListener push_listener;
TestConnectionListener conn_listener;


void test()
{
	
	
	conn.RegisterMessageListener(&login_listener);
	conn.RegisterConnectionListener(&conn_listener);
	conn.RegisterHallListener(&hall_listener);
	conn.RegisterPushListener(&push_listener);

	UserLogonReq4 req4;

	req4.set_nmessageid(1);
	req4.set_cloginid("1752965");
	req4.set_nversion(3030822 + 5);
	req4.set_nmask((uint32)time(0));
	req4.set_cuserpwd("23b431acfeb41e15d466d75de822307c");
	req4.set_cserial("");
	req4.set_cmacaddr("");
	req4.set_cipaddr("");
	req4.set_nimstate(0);
	req4.set_nmobile(0);

	conn.SendMsg_LoginReq4(req4);
	

	//LOG("%s", content);

}


#ifdef ANDROID

#include <jni.h>

extern "C" {
    JNIEXPORT void JNICALL Java_com_example_test_ProtocolLib_testp(JNIEnv* env, jobject obj);
};


JNIEXPORT void JNICALL
Java_com_example_test_ProtocolLib_testp(JNIEnv* env, jobject obj) {
    test();
}

#endif


#ifdef WIN

void testjson()
{
	Http http;
	char* content = http.GetString("121.12.118.32", 80, "/caijing/?m=Api&c=ClientConfig&clientType=4&versionNumber=1&parameterName=lbs");
	json::Array jarray = json::Deserialize(content).ToArray();
	json::Object jobject = jarray[0].ToObject();
	LOG("key:%s value:%s", jobject["parametername"], jobject["parametervalue"]);
}

int main(int argc, char* argv[])
{
	
	Socket::startup();

	//test();
	//testlbs();
	testjson();

	//WaitForSingleObject((HANDLE)thread_handle, 0);

	system("pause");
	Socket::cleanup();
	system("pause");

	return 0;


}




#endif

