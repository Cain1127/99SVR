/*
  FileName: yc_datatypes.h
  Date:2011��10��29��
  By LiuYongsheng

  ˵��:�ϸ����˸����������ͣ��ڳ������Ƽ�ʹ����Щ����õ������͡�
  �ر�ע����ʹ�ñ������ָ������ʱʹ��voidptr���Ͷ���ñ�����
  �����ڵĶ�����Ҫ����SocketLite�⣬ֻ������voidptr���Ͷ��壬��
  �ڴ���32/64�����⡣���Ժ�SocketLite����Թ�ͬʹ�ò�������⡣

  С֪ʶ��Win VC �£�long����32��64λ�¶���32λ���ݡ�
          linux ��,long����32λ��Ϊ32λ����64λ��Ϊ64λ��
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