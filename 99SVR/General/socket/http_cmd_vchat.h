// �޸��
//1. λ��
//2. ������Ϣ Ԥ����ȥ�����ֶ�
//3. typedef struct ��
//4. unsigned char/ long long
//5. ö������
//6. int���� openresult_1 members

#ifndef __CMD_HTTP_VCHAT_H__
#define __CMD_HTTP_VCHAT_H__

#include "yc_datatypes.h"

//#define __SWITCH_SERVER2__ 
//-----------------------------------------------------------
#pragma pack(1)

namespace protocol
{

	//����
	typedef struct tag_CMDSplash
	{
		uint32 imageUrl;
		char text[256];
		uint64 starTime;
		uint64 endTime;
	}CMDSplash_t;

	// �۵��б�ժҪ��
	typedef struct tag_CMDViewpointSummary
	{
		char authorId[16];
		char authorName[32];
		char authorIcon[256];
		char publishTime[32];
		char content[256];
		uint32 replyCount;
		uint32 flowerCount;
	}CMDViewpointSummary_t;

	//�۵�����
	typedef struct tag_CMDViewpointDetail
	{
		char authorId[16];
		char authorName[64];
		char authorIcon[256];
		char publishTime[32];
		char content[256];
		uint32 replyCount;
		uint32 flowerCount;
	}CMDViewpointDetail_t;

	// �۵�ظ�
	typedef struct tag_CMDReply
	{
		char authorId[16];
		char authorName[64];
		char authorIcon[256];
		char publishTime[32];
		char content[256];
	}CMDReply_t;

	// ���ֲ��̣���ҳ��
	typedef struct tag_CMDOperateStockProfit
	{
		char teamId[16];
		char teamName[32];
		char teamIcon[64];
		char focus[64];
		float goalProfit;
		float currProfit;
		float winRate;
	}CMDOperateStockProfit_t;

	// ���ֲ�����������
	typedef struct tag_CMDOperateStockData
	{
		char teamId[16];
		float dataAll[2][60];
		float data3Month[2][60];
		float dataMonth[2][60];
		float dataWeek[2][60];
	}CMDOperateStockData_t;

	// ���ֲ��̽��׼�¼
	typedef struct tag_CMDOperateStockTransaction
	{
		char teamId[16];
		char buytype[8];
		char stockId[8];
		char stockName[16];
		float price;
		uint32 count;
		float money;
		char time[32];
	}CMDOperateStockTransaction_t;

	// ���ֲ��ֲ̳�
	typedef struct tag_CMDOperateStocks
	{
		char teamId[16];
		char stockId[8];
		char stockName[16];
		uint32 count;
		float cost;
		float currPrice;
		float profitRate;
		float ProfitMoney;
	}tCMDOperateStocks_t;



};

#pragma pack()


#endif //__CMD_VCHAT_HH_20110409__

