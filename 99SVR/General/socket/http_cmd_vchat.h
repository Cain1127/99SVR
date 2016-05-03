// –ﬁ∏ƒœÓ£∫
//1. Œª”Ú
//2. ≥«÷˜–≈œ¢ ‘§±‡“Î»•µÙµƒ◊÷∂Œ
//3. typedef struct ø’
//4. unsigned char/ long long
//5. √∂æŸ¿‡–Õ
//6. int ˝◊È openresult_1 members

#ifndef __CMD_HTTP_VCHAT_H__
#define __CMD_HTTP_VCHAT_H__

#include "yc_datatypes.h"

//#define __SWITCH_SERVER2__ 
//-----------------------------------------------------------
#pragma pack(1)

namespace protocol
{

	//…¡∆¡
	typedef struct tag_CMDSplash
	{
		char imageUrl[256];  // Õº∆¨µÿ÷∑
		char text[256];  // Œƒ◊÷Àµ√˜£®”¶∏√”√≤ªµΩ£©
		char url[256];
		uint64 starTime;  // …˙–ß ±º‰
		uint64 endTime;  //  ß–ß ±º‰
	}CMDSplash_t;

	//’Ω∂”–≈œ¢
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

	// π€µ„¡–±Ì£®’™“™£©
	typedef struct tag_CMDViewpointSummary
	{
		uint32 authorId;  // ∑¢±Ì’ﬂ£∫’Ω∂”ID/Team ID
		uint32 roomId;
		char authorName[32];  // ’Ω∂”√˚≥∆
		char authorIcon[256];  // Õ∑œÒ
		uint32 viewpointId;  // π€µ„ID
		char publishTime[32];  // ∑¢±Ì ±º‰
		char title[64];  // ±ÍÃ‚
		char content[256];  // π€µ„ºÚ“™
		uint32 replyCount;  // ªÿ∏¥ ˝
		uint32 giftCount;  // ¿ÒŒÔ ˝
	}CMDViewpointSummary_t;

	//π€µ„œÍ«È
	typedef struct tag_CMDViewpointDetail
	{
		uint32 authorId;
		uint32 roomId;
		char authorName[64];
		char authorIcon[256];
		uint32 viewpointId;
		char publishTime[32];
		char title[64];  // ±ÍÃ‚
		char content[4096];   // π€µ„’˝Œƒ
		uint32 replyCount;
		uint32 giftCount;
		char html5url[128];
	}CMDViewpointDetail_t;

	// π€µ„ªÿ∏¥
	typedef struct tag_CMDReply
	{
		uint32 replytId;  // ±æªÿ∏¥ID
		uint32 viewpointId;  // À˘ Ùπ€µ„
		uint32 parentReplyId;  // À˘ Ùªÿ∏¥
		uint32 authorId;  // ªÿ∏¥’ﬂID
		char authorName[64];  // ªÿ∏¥’ﬂ√˚≥∆
		char authorIcon[256];  // Õ∑œÒ
		uint32 authorRole; // 0£∫∆’Õ®”√ªß 1£∫Ω≤ ¶
		uint32 fromAuthorId;  // ªÿ∏¥’ﬂID
		char fromAuthorName[64];  // ±ªªÿ∏¥’ﬂ√˚≥∆
		char fromAuthorIcon[256];  // ±ªÕ∑œÒ
		uint32 fromAuthorRole; // 0£∫∆’Õ®”√ªß 1£∫Ω≤ ¶
		char publishTime[32];  // ªÿ∏¥ ±º‰
		char content[256];  // ªÿ∏¥ƒ⁄»›
	}CMDReply_t;

	// ∏ﬂ ÷≤Ÿ≈Ã£® ◊“≥£©
	typedef struct tag_CMDOperateStockProfit
	{
		uint32 operateId;  // ≤Ÿ≈ÃID
		uint32 teamId;  // ’Ω∂”ID
		char teamName[32];  // ’Ω∂”√˚≥∆
		char teamIcon[64];  //’Ω∂”Õ∑œÒ
		char focus[64];  // ≤Ÿ≈Ã√˚≥∆
		float goalProfit;  // ƒø±Í ’“Ê
		float totalProfit;  // ◊‹ ’“Ê
		float dayProfit;  // »’ ’“Ê
		float monthProfit;  // ‘¬ ’“Ê
		float winRate;
	}CMDOperateStockProfit_t;

	// ∏ﬂ ÷≤Ÿ≈Ã«˙œﬂ ˝æ›
	typedef struct tag_CMDOperateStockData
	{
		uint32 operateId;  // ≤Ÿ≈ÃID
		float dataAll[2][60];  // ◊‹ ’“Ê«˙œﬂ
		float data3Month[2][60]; // ◊ÓΩ¸»˝‘¬«˙œﬂ
		float dataMonth[2][60];  // ‘¬«˙œﬂ
		float dataWeek[2][60];  // ÷‹«˙œﬂ
	}CMDOperateStockData_t;

	// ∏ﬂ ÷≤Ÿ≈ÃΩª“◊º«¬º
	typedef struct tag_CMDOperateStockTransaction
	{
		uint32 transId;  // ±æº«¬ºID
		uint32 operateId;  // ≤Ÿ≈ÃID
		char buytype[8];  // Ωª“◊¿‡–Õ ¬Ú»Î ¬Ù≥ˆ
		char stockId[8];  // π…∆±¥˙¬Î
		char stockName[16];  // π…∆±√˚≥∆
		float price;  // ≥…Ωªº€
		uint32 count;  // ≥…Ωª¡ø
		float money;  // ≥…Ωª∂Ó
		char time[32];  // ≥…Ωª ±º‰
	}CMDOperateStockTransaction_t;

	// ∏ﬂ ÷≤Ÿ≈Ã≥÷≤÷
	typedef struct tag_CMDOperateStocks
	{
		uint32 transId;  // ±æº«¬ºID
		uint32 operateId;  // ≤Ÿ≈ÃID
		char stockId[8];  // π…∆±¥˙¬Î
		char stockName[16];  // π…∆±√˚≥∆
		uint32 count;  // ≥÷”– ˝¡ø
		float cost;  // ≥…±æ;
		float currPrice;  // µ±«∞º€;
		float profitRate; //  ’“Ê¬ ;
		float ProfitMoney;  //  ’“Ê∂Ó;
	}tCMDOperateStocks_t;


	//Œ“µƒÀΩ»À∂®÷∆
	typedef struct tag_CMDMyPrivateService
	{
		uint32 teamId;  // ’Ω∂”
		char teamName[32];
		char teamIcon[32];
		uint32 levelId;  // ø™Õ®µƒµ»º∂–Ú∫≈1 ~ 6
		char levelName[16];  // µ»º∂√˚≥∆ VIP1...
		char expirationDate[32];  // ”––ß∆⁄
	}CMDMyPrivateService_t;

	//  ≤√¥ «ÀΩ»À∂®÷∆
	typedef struct tag_CMDWhatIsPrivateService
	{
		char content[1024]; // Html∏Ò Ω
	}CMDWhatIsPrivateService_t;

	//π∫¬ÚÀΩ»À∂®÷∆
	typedef struct tag_CMDPrivateServiceLevelDescription
	{
		uint32 levelId;  // –Ú∫≈
		char levelName[16];  // vipµ»º∂√˚≥∆
		char description[128];  // √Ë ˆ
		char buytime[32];
		char expirtiontime[32];
		float buyPrice;
		float updatePrice;
		uint32 isopen;
	}CMDPrivateServiceLevelDescription_t;

	// ÀΩ»À∂®÷∆Àı¬‘–≈œ¢
	typedef struct tag_CMDPrivateServiceSummary
	{
		uint32 id;
		char title[64];  // ±ÍÃ‚
		char summary[256];  // ºÚ“™
		char publishTime[32];  // ∑¢≤º»’∆⁄
		char teamName[32];  // ’Ω∂”√˚≥∆
	}CMDPrivateServiceSummary_t;

	//ÀΩ»À∂®÷∆œÍ«È
	typedef struct tag_CMDPrivateServiceDetail
	{
		char title[64];  // ±ÍÃ‚
		char content[1024];  // ƒ⁄»› HTML∏Ò Ω
		char publishTime[32];  // ∑¢≤º»’∆⁄
		char videoUrl[64];  //  ”∆µµÿ÷∑
		char videoName[64];  //  ”∆µ√˚≥∆
		char attachmentUrl[64];  // ∏Ωº˛URL
		char attachmentName[64];  // ∏Ωº˛√˚≥∆
		uint32 operateStockId; // ≤Ÿ≈ÃID
		char html5Url[64]; // HTML5 URL
	}CMDPrivateServiceDetail_t;


	// ≥‰÷µπÊ‘Ú
	typedef struct tag_CMDChargeRule
	{
		float originalPrice;   // ‘≠º€
		float discountPrice;  // ”≈ª›º€
		int coinCount;  // Ω±“ ˝
	}CMDChargeRule_t;

	// Ω≤ ¶ºÚΩÈ- ”∆µ
	typedef struct tag_CMDVideoInfo
	{
		int id;
		char name[64];  //  ”∆µ√˚≥∆
		char picUrl[64];  //  ”∆µÀı¬‘Õº
		char videoUrl[64];  //  ”∆µµÿ÷∑
	}CMDVideoInfo_t;

	// π±œ◊∞Ò
	typedef struct tag_CMDConsumeRank
	{
		char userName[32];  // ”√ªß√˚
		int headId;  // Õ∑œÒ
		uint64 consume;  // œ˚∑—Ω±“ ˝
	}CMDConsumeRank_t;

	// –≈œ‰--œµÕ≥œ˚œ¢
	typedef struct tag_CMDSystemMessage
	{
		uint32 id;  // œ˚œ¢ID
		char title[64];  // ±ÍÃ‚
		char content[256];  // ƒ⁄»›
		char publishTime[32];  // ∑¢≤º ±º‰
	}CMDSystemMessage_t;

	typedef struct tag_CMDQuestionAnswer
	  {
	    uint32 id;
	    uint32 roomId;
	    uint32 answerAuthorId;  // ªÿ¥’ﬂ
	    char answerAuthorName[32];  // ªÿ¥’ﬂ√˚≥∆
	    char answerAuthorHead[64];  // ªÿ¥’ﬂICON
	    uint32 answerAuthorRole; // 0£∫∆’Õ®”√ªß 1£∫Ω≤ ¶
	    char answerTime[32];  // ªÿ¥ ±º‰
	    char answerContent[256];  // ªÿ¥ƒ⁄»›
		uint32 askAuthorId;  // ªÿ¥’ﬂ
	    char askAuthorName[32];  // Ã·Œ ’ﬂ
	    char askAuthorHead[64];  // Ã·Œ ’ﬂÕ∑œÒ
	    uint32 askAuthorRole; // 0£∫∆’Õ®”√ªß 1£∫Ω≤ ¶
	    char askStock[32];  // Ã·Œ µƒπ…∆±
	    char askContent[256];  // Ã·Œ ƒ⁄»›
	    char askTime[32];  // Ã·Œ  ±º‰
	    uint32 fromClient;
	  }CMDQuestionAnswer_t;

	  // –≈œ‰--∆¿¬€
	  typedef struct tag_CMDMailReply
	  {
	    uint32 id;
	    uint32 roomId;
	    uint32 viewpointId;  // π€µ„ID
	    char title[32];  // π€µ„±ÍÃ‚
		uint32 askAuthorId;  // ‘≠∆¿¬€’ﬂ
	    char askAuthorName[32];  // ‘≠∆¿¬€
	    char askAuthorHead[64];
	    uint32 askAuthorRole; // 0£∫∆’Õ®”√ªß 1£∫Ω≤ ¶
	    char askContent[256];
	    char askTime[32];
	    char answerAuthorId[16];  //ªÿ∏¥µƒ∆¿¬€
	    char answerAuthorName[32];
	    char answerAuthorHead[64];
	    uint32 answerAuthorRole; // 0£∫∆’Õ®”√ªß 1£∫Ω≤ ¶
	    char answerTime[32];
	    char answerContent[256];
	    uint32 fromClient;
	  }CMDMailReply_t;

	// –≈œ‰--◊‹Œ¥∂¡ ˝¡ø
	typedef struct tag_CMDTotalUnread
	{
		uint32 total;  // ◊‹µƒŒ¥∂¡ ˝
	}CMDTotalUnread_t;

	// –≈œ‰--Œ¥∂¡ ˝¡ø
	typedef struct tag_CMDUnread
	{
		uint32 system;  // œµÕ≥œ˚œ¢Œ¥∂¡ ˝
		uint32 answer;  // Œ Ã‚ªÿ∏¥Œ¥∂¡ ˝
		uint32 reply;  // ∆¿¬€ªÿ∏¥Œ¥∂¡ ˝
		uint32 privateService;  // ÀΩ»À∂®÷∆Œ¥∂¡ ˝
	}CMDUnread_t;

	typedef struct tag_CMDTeamTopN
	{
		char teamName[32];  // ’Ω∂”√˚≥∆
		char teamIcon[64];  // ’Ω∂”ICON
		float yieldRate;  //  ’“Ê¬ 
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
		char path[128];  // Õº∆¨¬∑æ∂
		uint32 width; // øÌ∂»
		uint32 height;  // ∏ﬂ∂»
	}CMDImageInfo_t;

	typedef struct tag_CMDUserTeamRelatedInfo
	{
		uint32 askremain; //  £”‡Ã·Œ ¥Œ ˝
		uint32 viplevel; // ø™Õ®µƒvipµ»º∂
	}CMDUserTeamRelatedInfo_t;

    
};

#pragma pack()


#endif //__CMD_VCHAT_HH_20110409__

