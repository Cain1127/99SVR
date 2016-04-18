
#ifndef __PROTO_MESSAGE_COMMON_NET_HH_20131027__
#define __PROTO_MESSAGE_COMMON_NET_HH_20131027__

#include "yc_datatypes.h"


namespace protocol
{
	//----------------------------------------------------------
#pragma pack(1)

	//10 bytes
	typedef struct tag_COM_MSG_HEADER
	{
		int32  length;       //���������λ��
		uint8  version;      //�汾��,��ǰΪ11
		uint8  checkcode;
		uint16 maincmd;     //������
		uint16 subcmd;      //������
		char   content[0];  //����
	}COM_MSG_HEADER;

	//6*8=48bytes
	typedef struct tag_ClientGateMask
	{
		int64 param1;    //gate-obj
		int64 param2;    //gate-connect-id
		int64 param3;    //client-obj
		int64 param4;    //client-connect-id
		int64 param5;    //client-ip
		int64 param6;    //client-port
	}ClientGateMask_t;

#pragma pack()

}

//COM_MSG_HEADER + ClientGateMask_t + ...

#endif //__MESSAGE_COMMON_NET_HH_20131027__