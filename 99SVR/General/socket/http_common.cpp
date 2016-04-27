#include "Util.h"
#include "platform.h"
#include "http_common.h"
#include "LoginConnection.h"


std::string get_client_type()
{
#ifdef WIN
	return "1";
#elif defined ANDROID
	return "2";
#else
	return "3";
#endif
}

std::string get_user_id()
{
//	return int2string(login_userid);
    return "1817954";
}

std::string get_user_password()
{
	return login_password;
}

std::string& get_user_token()
{
    return login_password;
}

void set_user_id(uint32 user_id)
{
	login_userid = user_id;
}