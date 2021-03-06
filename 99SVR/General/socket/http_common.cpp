#include "stdafx.h"
#include "Util.h"
#include "platform.h"
#include "http_common.h"
#include "LoginConnection.h"


std::string get_client_type()
{
#ifdef WIN
	return "0";
#elif defined ANDROID
	return "1";
#else
	return "2";
#endif
}

std::string get_user_id()
{
	return int2string(login_userid);
}

std::string get_user_password()
{
	return login_password;
}

std::string& get_user_token()
{
	return login_token.sessiontoken();
}

int get_user_isguest()
{
	return loginuser.viplevel() == 1 ? 1 : 0;
}

void set_user_id(uint32 user_id)
{
	login_userid = user_id;
}
