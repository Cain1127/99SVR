#include "stdafx.h"



#ifdef DEBUG
#define LOG(fmt, ...) printf(("%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define LOG(fmt, ...)
#endif

