#ifndef __HTTP_COMMON_H__
#define __HTTP_COMMON_H__


#include <string>
#include <map>
#include "Util.h"

using std::string;
using std::map;

typedef  map<string, string> RequestParamter;


string get_client_type();

RequestParamter& get_request_param();

#endif
