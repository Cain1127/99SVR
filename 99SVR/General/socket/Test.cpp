// JJClientProtocol.cpp : 定义控制台应用程序的入口点。

#include "platform.h"
#include "Http.h"
#include "LoginConnection.h"
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
/*
char* lbs0 = "lbs1.99ducaijing.cn:2222,lbs2.99ducaijing.cn:2222,58.210.107.54:2222,122.193.102.23:2222,112.25.230.249:2222";
char lbs[256];


char lbss[3][10][20];
int lbs_counter[3];
bool islogining = false;

void parse_ip_port(char* s, char* ip, short& port)
{
	char* e = strchr(s, ':');
	int len = e - s;
	memcpy(ip, s, len);
	ip[len] = 0;

	port = atoi(e + 1);
}


ThreadVoid get_host_form_lbs_runnable(void* param)
{
	char recvbuf[HTTP_RECV_BUF_SIZE];
	Http http;

	char* lbs = (char*)param;
	
	char ip[20];
	short port;
	parse_ip_port(lbs, ip, port);

	//LOG("thread:lbs--:%s--%d", ip, port);

	char* content = http.GetString(ip, port, "/tygetweb", recvbuf);
	if (content != NULL)
	{
		char* end = strchr(content, '|');
		if (end != NULL)
		{
			*end = '\0';
		}

		LOG("time:%d lbs:%s host:%s", clock(), ip, content);
		if (!islogining)
		{
			islogining = true;
			LOG("****DO LOGIN***");

			const char *d = ",";
			char *p;
			p = strtok(content, d);
			while (p)
			{
				//printf("%s\n", p);

				if (strlen(p) == 1)
				{
					LOG("stype:%s", p);
				}
				else
				{
					char ip[20];
					short port;
					parse_ip_port(p, ip, port);
					LOG("first login server: %s:%d", ip, port);
					break;
				}

				p = strtok(NULL, d);
			}
		}
	}

	ThreadReturn;
}

void testlbs()
{
	const char *d = ",";
	char *p;
	strcpy(lbs, lbs0);
	p = strtok(lbs, d);
	int stype = -1;
	while (p)
	{
		//printf("%s\n", p);

		Thread::start(get_host_form_lbs_runnable, p);
		p = strtok(NULL, d);
	}
}

void testlbs2()
{
	//http://hall.99ducaijing.cn:8081/roomdata/room.php?act=roomdata
	char recvbuf[HTTP_RECV_BUF_SIZE];
	Http http;

	memset(lbss, 0, sizeof(lbss));
	memset(lbs_counter, 0, sizeof(lbs_counter));

	char* content = http.GetString("lbs1.99ducaijing.cn", 2222, "/tygetweb", recvbuf);
	//int ret = http.GetString("lbs1.99ducaijing.cn", 2222, "/tygetgate", recvbuf);
	//int ret = http.GetString("hall.99ducaijing.cn", 8081, "/roomdata/room.php?act=roomdata", recvbuf);
	if (content != NULL)
	{
		LOG("%s", recvbuf);
		//char s[] = "Golden Global   View,disk * desk";
		char* end = strchr(content, '|');
		if (end != NULL)
		{
			*end = '\0';
		}

		const char *d = ",";
		char *p;
		p = strtok(content, d);
		int stype = -1;
		while (p)
		{
			//printf("%s\n", p);
			
			if (strlen(p) == 1)
			{
				stype = p[0] - '0';
				LOG("stype:%d", stype);
			}
			else
			{
				if (stype >= 0 && stype <= 2)
				{
					int n = lbs_counter[stype];
					strcpy(lbss[stype][n], p);
					LOG("lbs:%d:%s", n, lbss[stype][n]);

					char ip[20];
					short port;
					parse_ip_port(lbss[stype][n], ip, port);
					LOG("ip:%s port:%d", ip, port);

					if (islogining == false)
					{
						islogining = true;

					}

					lbs_counter[stype]++;
				}
			}

			p = strtok(NULL, d);
		}
	}

}
*/

int main(int argc, char* argv[])
{
	
	Socket::startup();

	test();
	//testlbs();

	//WaitForSingleObject((HANDLE)thread_handle, 0);

	system("pause");
	Socket::cleanup();
	system("pause");

	return 0;


}




#endif

