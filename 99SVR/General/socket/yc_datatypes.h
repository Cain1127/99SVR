/*
  FileName: yc_datatypes.h
  Date:2011年10月29日
  By LiuYongsheng

  说明:严格定义了各种数据类型，在程序中推荐使用这些定义好的数据型。
  特别注意在使用变量存放指针数据时使用voidptr类型定义该变量。
  另：下在的定义主要来自SocketLite库，只是增加voidptr类型定义，用
  于处理32/64的问题。所以和SocketLite库可以共同使用不会出问题。

  小知识：Win VC 下，long型在32、64位下都是32位数据。
          linux 下,long型在32位下为32位，在64位下为64位。
  reference:http://en.wikipedia.org/wiki/64-bit
*/

#ifndef __YC_DATAYPTES_H__
#define __YC_DATAYPTES_H__

////////////////////////////////////////////////////////

typedef unsigned char			byte;
typedef unsigned short			ushort;
typedef unsigned int			uint;
typedef unsigned long			ulong;
typedef float					f32;
typedef double					f64;


typedef char				int8;
typedef short				int16;
typedef int					int32;
typedef long long			int64;
typedef unsigned char		uint8;
typedef unsigned short		uint16;
typedef unsigned int		uint32;
typedef unsigned long long	uint64;
typedef unsigned long		voidptr;


///////////////////////////////////////////////////////
#define MD5LEN        32
#define PWDLEN        64
#define NAMELEN       32
#define NAMELEN2      64
#define URLLEN        64
#define URLLEN4       256
#define IPADDRLEN     32
#define GIFTTEXTLEN   64
#define GATEADDRLEN   128
#define MEDIAADDRLEN  128
#define DEVICENAMELEN 128
#define BIRTHLEN      32
///////////////////////////////////////////////////////




#endif