#ifndef __HTTP_COMMON_H__
#define __HTTP_COMMON_H__

#include "yc_datatypes.h"

#include <string>


std::string get_client_type();

std::string get_user_id();

std::string get_user_password();

void set_user_id(uint32 user_id);

#endif

