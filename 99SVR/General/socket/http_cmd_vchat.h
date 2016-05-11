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
		char imageUrl[256];  // ͼƬ��ַ
		char text[256];  // ����˵����Ӧ���ò�����
		char url[256];
		uint64 starTime;  // ��Чʱ��
		uint64 endTime;  // ʧЧʱ��
	}CMDSplash_t;

	//ս����Ϣ
	typedef struct tag_CMDTeam
	{
		uint32 roomId;
		uint32 teamId;
		char teamName[32];
		char teamIcon[64];
		char Introduce[1024];
		uint32 onlineUserCount;
		uint32 locked;
		char alias[32];
	}CMDTeam_t;

	// �۵��б�ժҪ��
	typedef struct tag_CMDViewpointSummary
	{
		uint32 authorId;  // �����ߣ�ս��ID/Team ID
		uint32 roomId;
		char authorName[32];  // ս������
		char authorIcon[256];  // ͷ��
		uint32 viewpointId;  // �۵�ID
		char publishTime[32];  // ����ʱ��
		char title[64];  // ����
		char content[256];  // �۵��Ҫ
		uint32 replyCount;  // �ظ���
		uint32 giftCount;  // ������
	}CMDViewpointSummary_t;

	//�۵�����
	typedef struct tag_CMDViewpointDetail
	{
		uint32 authorId;
		uint32 roomId;
		char authorName[64];
		char authorIcon[256];
		uint32 viewpointId;
		char publishTime[32];
		char title[64];  // ����
		char content[4096];   // �۵�����
		uint32 replyCount;
		uint32 giftCount;
		char html5url[128];
	}CMDViewpointDetail_t;

	// �۵�ظ�
	typedef struct tag_CMDReply
	{
		uint32 replytId;  // ���ظ�ID
		uint32 viewpointId;  // �����۵�
		uint32 parentReplyId;  // �����ظ�
		uint32 authorId;  // �ظ���ID
		char authorName[64];  // �ظ�������
		char authorIcon[256];  // ͷ��
		uint32 authorRole; // 0����ͨ�û� 1����ʦ
		uint32 fromAuthorId;  // �ظ���ID
		char fromAuthorName[64];  // ���ظ�������
		char fromAuthorIcon[256];  // ��ͷ��
		uint32 fromAuthorRole; // 0����ͨ�û� 1����ʦ
		char publishTime[32];  // �ظ�ʱ��
		char content[256];  // �ظ�����
	}CMDReply_t;

	// ���ֲ��̣���ҳ��
	typedef struct tag_CMDOperateStockProfit
	{
		uint32 operateId;  // ����ID
		uint32 teamId;  // ս��ID
		char teamName[32];  // ս������
		char teamIcon[64];  //ս��ͷ��
		char focus[64];  // ��������
		float goalProfit;  // Ŀ������
		float totalProfit;  // ������
		float dayProfit;  // ������
		float monthProfit;  // ������
		float winRate;
	}CMDOperateStockProfit_t;

	// ���ֲ����������ݣ�����������/�����������/������/�����ߣ�
	typedef struct tag_CMDOperateDataByTime
	{
		float rate;  // ����
		float trend; // ��������
		char date[32];  // ʱ��
	}CMDOperateDataByTime_t;

	// ���ֲ��̽��׼�¼
	typedef struct tag_CMDOperateStockTransaction
	{
		uint32 transId;  // ����¼ID
		uint32 operateId;  // ����ID
<<<<<<< HEAD
        uint32 buytypeflag;  // �������� ���� ����
        char buytype[8];  // �������� ���� ����
=======
		uint32 buytypeflag;  // �������� ���� ����
		char buytype[8];  // �������� ���� ����
>>>>>>> d1a7034d39fe5ddd34d5fc2af3d5182ebea5ae9d
		char stockId[8];  // ��Ʊ����
		char stockName[16];  // ��Ʊ����
		float price;  // �ɽ���
		uint32 count;  // �ɽ���
		float money;  // �ɽ���
		char time[32];  // �ɽ�ʱ��
	}CMDOperateStockTransaction_t;

	// ���ֲ��ֲ̳�
	typedef struct tag_CMDOperateStocks
	{
		uint32 transId;  // ����¼ID
		uint32 operateId;  // ����ID
		char stockId[8];  // ��Ʊ����
		char stockName[16];  // ��Ʊ����
		uint32 count;  // ��������
		float cost;  // �ɱ�;
		float currPrice;  // ��ǰ��;
		float profitRate; // ������;
		float ProfitMoney;  // �����;
	}tCMDOperateStocks_t;


	//�ҵ�˽�˶���
	typedef struct tag_CMDMyPrivateService
	{
		uint32 teamId;  // ս��
		char teamName[32];
		char teamIcon[32];
		uint32 levelId;  // ��ͨ�ĵȼ����1 ~ 6
		char levelName[16];  // �ȼ����� VIP1...
		char expirationDate[32];  // ��Ч��
	}CMDMyPrivateService_t;

	// ʲô��˽�˶���
	typedef struct tag_CMDWhatIsPrivateService
	{
		char content[1024]; // Html��ʽ
	}CMDWhatIsPrivateService_t;

	//����˽�˶���
	typedef struct tag_CMDPrivateServiceLevelDescription
	{
		uint32 levelId;  // ���
		char levelName[16];  // vip�ȼ�����
		char description[128];  // ����
		char buytime[32];
		char expirtiontime[32];
		float buyPrice;
		float updatePrice;
		uint32 isopen;
		uint32 maxnum;
	}CMDPrivateServiceLevelDescription_t;

	// ˽�˶���������Ϣ
	typedef struct tag_CMDPrivateServiceSummary
	{
		uint32 id;
		char title[64];  // ����
		char cover[128];  // ��������
		char summary[256];  // ��Ҫ
		char publishTime[32];  // ��������
		char teamName[32];  // ս������
	}CMDPrivateServiceSummary_t;

	// ���ֲ��̽��׼�¼PC
	typedef struct tag_CMDOperateStockTransactionPC
	{
		uint32 transId;  // ����¼ID
		uint32 operateId;  // ����ID
		char title[64];  // �������
		char buytype[8];  // �������� ���� ����
		char stockId[8];  // ��Ʊ����
		char stockName[16];  // ��Ʊ����
		float price;  // �ɽ���
		uint32 count;  // �ɽ���
		float money;  // �ɽ���
		char time[32];  // �ɽ�ʱ��
		char summary[256];  // ��������
	}CMDOperateStockTransactionPC_t;

	//˽�˶�������
	typedef struct tag_CMDPrivateServiceDetail
	{
		char title[64];  // ����
		char content[1024];  // ���� HTML��ʽ
		char publishTime[32];  // ��������
		char videoUrl[64];  // ��Ƶ��ַ
		char videoName[64];  // ��Ƶ����
		char attachmentUrl[64];  // ����URL
		char attachmentName[64];  // ��������
		uint32 operateStockId; // ����ID
		char html5Url[64]; // HTML5 URL
	}CMDPrivateServiceDetail_t;


	// ��ֵ����
	typedef struct tag_CMDChargeRule
	{
		float originalPrice;   // ԭ��
		float discountPrice;  // �Żݼ�
		int coinCount;  // �����
	}CMDChargeRule_t;

	// ��ʦ���-��Ƶ
	typedef struct tag_CMDVideoInfo
	{
		int id;
		char name[64];  // ��Ƶ����
		char picUrl[64];  // ��Ƶ����ͼ
		char videoUrl[64];  // ��Ƶ��ַ
	}CMDVideoInfo_t;

	// ���װ�
	typedef struct tag_CMDConsumeRank
	{
		char userName[32];  // �û���
		int headId;  // ͷ��
		uint64 consume;  // ���ѽ����
	}CMDConsumeRank_t;

	// ����--ϵͳ��Ϣ
	typedef struct tag_CMDSystemMessage
	{
		uint32 id;  // ��ϢID
		char title[64];  // ����
		char content[256];  // ����
		char publishTime[32];  // ����ʱ��
	}CMDSystemMessage_t;

	typedef struct tag_CMDQuestionAnswer
	  {
	    uint32 id;
	    uint32 roomId;
	    uint32 answerAuthorId;  // �ش���
	    char answerAuthorName[32];  // �ش�������
	    char answerAuthorHead[64];  // �ش���ICON
	    uint32 answerAuthorRole; // 0����ͨ�û� 1����ʦ
	    char answerTime[32];  // �ش�ʱ��
	    char answerContent[256];  // �ش�����
		uint32 askAuthorId;  // �ش���
	    char askAuthorName[32];  // ������
	    char askAuthorHead[64];  // ������ͷ��
	    uint32 askAuthorRole; // 0����ͨ�û� 1����ʦ
	    char askStock[32];  // ���ʵĹ�Ʊ
	    char askContent[256];  // ��������
	    char askTime[32];  // ����ʱ��
	    uint32 fromClient;
	  }CMDQuestionAnswer_t;

	  // ����--����
	  typedef struct tag_CMDMailReply
	  {
	    uint32 id;
	    uint32 roomId;
	    uint32 viewpointId;  // �۵�ID
	    char title[32];  // �۵����
		uint32 askAuthorId;  // ԭ������
	    char askAuthorName[32];  // ԭ����
	    char askAuthorHead[64];
	    uint32 askAuthorRole; // 0����ͨ�û� 1����ʦ
	    char askContent[256];
	    char askTime[32];
	    char answerAuthorId[16];  //�ظ�������
	    char answerAuthorName[32];
	    char answerAuthorHead[64];
	    uint32 answerAuthorRole; // 0����ͨ�û� 1����ʦ
	    char answerTime[32];
	    char answerContent[256];
	    uint32 fromClient;
	  }CMDMailReply_t;

	// ����--��δ������
	typedef struct tag_CMDTotalUnread
	{
		uint32 total;  // �ܵ�δ����
	}CMDTotalUnread_t;

	// ����--δ������
	typedef struct tag_CMDUnread
	{
		uint32 system;  // ϵͳ��Ϣδ����
		uint32 answer;  // ����ظ�δ����
		uint32 reply;  // ���ۻظ�δ����
		uint32 privateService;  // ˽�˶���δ����
	}CMDUnread_t;

	typedef struct tag_CMDTeamTopN
	{
		char teamName[32];  // ս������
		char teamIcon[64];  // ս��ICON
		float yieldRate;  // ������
	}CMDTeamTopN_t;

	typedef struct tag_CMDBannerItem
	{
		char url[32];
		char type[32];
		char croompic[32];
	}CMDBannerItem_t;

	typedef struct tag_NavigationItem
	{
		uint32 nid;
		uint32 level;
		uint32 grouptype;
		uint32 parentid;
		uint32 showflag;
		uint32 sortid;
		char name[NAMELEN];
		char fontcolor[NAMELEN];
		char curl[URLLEN4];
		char gateurl[URLLEN4];
		uint32 roomid;
		uint32 type;
	}NavigationItem_t;

	typedef struct tag_CMDImageInfo
	{
		char path[128];  // ͼƬ·��
		uint32 width; // ���
		uint32 height;  // �߶�
	}CMDImageInfo_t;

	typedef struct tag_CMDUserTeamRelatedInfo
	{
		uint32 askremain; // ʣ�����ʴ���
		uint32 askcoin; // ��������Ľ����
		uint32 viplevel; // ��ͨ��vip�ȼ�
	}CMDUserTeamRelatedInfo_t;

	//�鿴�ҵķ�˿
	typedef struct tag_CMDTeacherFansResp
	{
		uint32 userid;                 //�û�ID
		char   useralias[NAMELEN];     //�û��ǳ�
		uint32 userheadid;             //�û�ͷ��
	}CMDTeacherFansResp_t;
};

#pragma pack()


#endif //__CMD_VCHAT_HH_20110409__

