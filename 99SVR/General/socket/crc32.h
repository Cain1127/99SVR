
#ifndef __CRC32_H__20110721__
#define __CRC32_H__20110721__
#include <stddef.h>

#define CRC_MAGIC  0xA7E0DF30

unsigned int crc32 (const void *buffer, size_t len, unsigned int crc);


#endif //__CRC32_H__20110721__



