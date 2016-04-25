
#ifndef __PLATFORM_H__
#define __PLATFORM_H__




#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>




#if (defined WIN32) || (defined WIN64)
#define WIN

#pragma warning(disable:4996)
#pragma warning(disable:4200)

#define FILE_SEPARATOR "\\"
#define CLIENT_TYPE 0

#else

#ifdef ANDROID
#define CLIENT_TYPE 1
#else
#define CLIENT_TYPE 2
#endif

#define FILE_SEPARATOR "/"



#endif





#endif

