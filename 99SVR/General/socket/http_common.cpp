
#include "http_common.h"


string get_client_type()
{
#ifdef WIN
	return "1";
#elif defined ANDROID
	return "2";
#else
	return "3";
#endif
}

RequestParamter& get_request_param()
{
	RequestParamter* param = new RequestParamter();
	return *param;
}



