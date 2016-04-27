

/**股票详情 数据model*/


#import <Foundation/Foundation.h>

@interface StockDealModel : NSObject

/**操盘id*/
@property (nonatomic , copy) NSString *operateid;
/**战队id*/
@property (nonatomic , copy) NSString *teamid;
/**战队名称*/
@property (nonatomic , copy) NSString *teamname;
/**战队头像*/
@property (nonatomic , copy) NSString *teamicon;
/**操盘名称*/
@property (nonatomic , copy) NSString *focus;
/**目标收益*/
@property (nonatomic , copy) NSString *goalprofit;
/**总收益*/
@property (nonatomic , copy) NSString *totalprofit;
/**日收益*/
@property (nonatomic , copy) NSString *dayprofit;
/**月收益*/
@property (nonatomic , copy) NSString *monthprofit;
/**超赢*/
@property (nonatomic , copy) NSString *winrate;
/**vip等级*/
@property (nonatomic , copy) NSString *vipLevel;
/**交易类型 买入 卖出*/
@property (nonatomic , copy) NSString *buytype;
/**股票代码*/
@property (nonatomic , copy) NSString *stockid;
/**股票名称*/
@property (nonatomic , copy) NSString *stockname;
/**成交价*/
@property (nonatomic , copy) NSString *price;
/**成交量*/
@property (nonatomic , copy) NSString *count;
/**成交额*/
@property (nonatomic , copy) NSString *money;
/**成交时间*/
@property (nonatomic , copy) NSString *time;
/**记录下面最新的id*/
@property (nonatomic , copy) NSString *transId;

/**cost 成本*/
@property (nonatomic , copy) NSString *cost;
/**currprice 现价*/
@property (nonatomic , copy) NSString *currprice;;
/**profitrate 利润率*/
@property (nonatomic , copy) NSString *profitrate;
/**profitmoney 盈利的钱*/
@property (nonatomic , copy) NSString *profitmoney;

/**当前vip等级*/
@property (nonatomic , copy) NSString *currLevelId;
/**最小vip等级*/
@property (nonatomic , copy) NSString *minVipLevel;

#pragma mark 股票详情--股票头部详情数据
/**股票头部详情数据*/
- (instancetype)initWithStockDealHeaderData:(void *)profit;


#pragma mark 股票详情--股票走势图
/**股票走势图*/
- (instancetype)initWithStockDealStockData:(void *)stockData;

#pragma mark 股票详情--交易动态记录
/**交易动态*/
- (instancetype)initWithStockDealBusinessRecoreData:(void *)trans;

#pragma mark 股票详情--持仓记录
/**持仓情况*/
- (instancetype)initWithStockDealWareHouseRecoreData:(void *)stocks;

#pragma mark 交易记录详情--交易记录的模型
/**初始化交易记录详情--交易记录的模型*/
- (instancetype)initWithStockRecordBusinessData:(void *)pData;

#pragma mark 交易记录详情--持仓情况的模型
/**初始化交易记录详情--持仓情况的模型*/
- (instancetype)initWithStockRecordWareHouseData:(void *)pdata;
#pragma mark 股票首页
/**股票首页*/
- (instancetype)initWithHomeRecordData:(void *)pData;




@end
