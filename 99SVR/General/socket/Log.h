#include "stdafx.h"

#ifdef WIN
#define LOG(format,...) printf("LINE: %d: "format"\n", __LINE__, ##__VA_ARGS__)
#elif defined ANDROID
#include <android/log.h>
#define LOG(...) ((void)__android_log_print(ANDROID_LOG_INFO, "native", __VA_ARGS__))
#else
//#include <android/log.h>
//#define LOG(format,...) printf("LINE: %d: "format"\n", __LINE__, ##__VA_ARGS__)
#define LOG(fmt, ...) printf(("%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#endif

