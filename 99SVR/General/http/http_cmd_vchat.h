// 修改项：
//1. 位域
//2. 城主信息 预编译去掉的字段
//3. typedef struct 空
//4. unsigned char/ long long
//5. 枚举类型
//6. int数组 openresult_1 members

#ifndef __CMD_HTTP_VCHAT_H__
#define __CMD_HTTP_VCHAT_H__

#include "yc_datatypes.h"

//#define __SWITCH_SERVER2__
//-----------------------------------------------------------
#pragma pack(1)

namespace protocol
{
    
    //闪屏
    typedef struct tag_CMDSplash
    {
        char imageUrl[256];  // 图片地址
        char text[256];  // 文字说明（应该用不到）
        uint64 starTime;  // 生效时间
        uint64 endTime;  // 失效时间
    }CMDSplash_t;
    
    //战队信息
    typedef struct tag_CMDTeam
    {
        char teamId[16];
        char teamName[32];
        char teamIcon[64];
        uint32 onlineUserCount;
        uint32 locked;
    }CMDTeam_t;
    
    // 观点列表（摘要）
    typedef struct tag_CMDViewpointSummary
    {
        char authorId[16];  // 发表者：战队ID/Team ID/房间ID
        char authorName[32];  // 战队名称
        char authorIcon[256];  // 头像
        uint32 viewpointId;  // 观点ID
        char publishTime[32];  // 发表时间
        char content[256];  // 观点简要
        uint32 replyCount;  // 回复数
        uint32 flowerCount;  // 献花数
    }CMDViewpointSummary_t;
    
    //观点详情
    typedef struct tag_CMDViewpointDetail
    {
        char authorId[16];
        char authorName[64];
        char authorIcon[256];
        uint32 viewpointId;
        char publishTime[32];
        char content[4096];   // 观点正文
        uint32 replyCount;
        uint32 flowerCount;
    }CMDViewpointDetail_t;
    
    // 观点回复
    typedef struct tag_CMDReply
    {
        uint32 replytId;  // 本回复ID
        uint32 viewpointId;  // 所属观点
        uint32 parentReplyId;  // 所属回复
        char authorId[16];  // 回复者ID
        char authorName[64];  // 回复者名称
        char authorIcon[256];  // 头像
        char publishTime[32];  // 回复时间
        char content[256];  // 回复内容
    }CMDReply_t;
    
    // 高手操盘（首页）
    typedef struct tag_CMDOperateStockProfit
    {
        uint32 operateId;  // 操盘ID
        char teamId[16];  // 战队ID
        char teamName[32];  // 战队名称
        char teamIcon[64];  //战队头像
        char focus[64];  // 操盘名称
        float goalProfit;  // 目标收益
        float totalProfit;  // 总收益
        float dayProfit;  // 日收益
        float monthProfit;  // 月收益
        float winRate;
    }CMDOperateStockProfit_t;
    
    // 高手操盘曲线数据
    typedef struct tag_CMDOperateStockData
    {
        uint32 operateId;  // 操盘ID
        float dataAll[2][60];  // 总收益曲线
        float data3Month[2][60]; // 最近三月曲线
        float dataMonth[2][60];  // 月曲线
        float dataWeek[2][60];  // 周取消
    }CMDOperateStockData_t;
    
    // 高手操盘交易记录
    typedef struct tag_CMDOperateStockTransaction
    {
        uint32 operateId;  // 操盘ID
        char buytype[8];  // 交易类型 买入 卖出
        char stockId[8];  // 股票代码
        char stockName[16];  // 股票名称
        float price;  // 成交价
        uint32 count;  // 成交量
        float money;  // 成交额
        char time[32];  // 成交时间
    }CMDOperateStockTransaction_t;
    
    // 高手操盘持仓
    typedef struct tag_CMDOperateStocks
    {
        uint32 operateId;  // 操盘ID
        char stockId[8];  // 股票代码
        char stockName[16];  // 股票名称
        uint32 count;  // 持有数量
        float cost;  // 成本;
        float currPrice;  // 当前价;
        float profitRate; // 收益率;
        float ProfitMoney;  // 收益额;
    }tCMDOperateStocks_t;
    
    
    //我的私人定制
    typedef struct tag_CMDMyPrivateService
    {
        char teamId[16];  // 战队
        char teamName[32];
        char teamIcon[32];
        uint32 levelId;  // 开通的等级序号1 ~ 6
        char levelName[16];  // 等级名称 VIP1...
        char expirationDate[32];  // 有效期
    }CMDMyPrivateService_t;
    
    // 什么是私人定制
    typedef struct tag_CMDWhatIsPrivateService
    {
        char content[1024]; // Html格式
    }CMDWhatIsPrivateService_t;
    
    //购买私人定制
    typedef struct tag_CMDPrivateServiceLevelDescription
    {
        uint32 levelId;  // 序号
        char levelName[16];  // vip等级名称
        char description[128];  // 描述
    }CMDPrivateServiceLevelDescription_t;
    
    // 私人定制缩略信息
    typedef struct tag_CMDPrivateServiceSummary
    {
        uint32 id;
        char title[64];  // 标题
        char summary[256];  // 简要
        char publishTime[32];  // 发布日期
    }CMDPrivateServiceSummary_t;
    
    //私人定制详情
    typedef struct tag_CMDPrivateServiceDetail
    {
        char title[64];  // 标题
        char content[1024];  // 内容 HTML格式
        char publishTime[32];  // 发布日期
        char videoUrl[64];  // 视频地址
        char videoName[64];  // 视频名称
        char attachmentUrl[64];  // 附件URL
        char attachmentName[64];  // 附件名称
    }CMDPrivateServiceDetail_t;
    
    
    // 充值规则
    typedef struct tag_CMDChargeRule
    {
        float originalPrice;   // 原价
        float discountPrice;  // 优惠价
        int coinCount;  // 金币数
    }CMDChargeRule_t;
    
    // 讲师简介-视频
    typedef struct tag_CMDVideoInfo
    {
        char name[64];  // 视频名称
        char picUrl[64];  // 视频缩略图
        char videoUrl[64];  // 视频地址
    }CMDVideoInfo_t;
    
    // 贡献榜
    typedef struct tag_CMDConsumeRank
    {
        char userName[32];  // 用户名
        char userIcon[64];  // 头像
        float consume;  // 消费金币数
    }CMDConsumeRank_t;
    
};

#pragma pack()


#endif //__CMD_VCHAT_HH_20110409__

