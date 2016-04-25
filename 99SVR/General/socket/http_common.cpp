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
    return int2string(login_userid);
}

std::string get_user_password()
{
    return login_password;
}

