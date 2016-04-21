

/**股票详情 数据model*/


#import <Foundation/Foundation.h>
#import "HttpMessage.pb.h"


@interface StockDealModel : NSObject

/**股票头部详情数据*/
- (instancetype)initWithProfit:(OperateStockProfit &)profit;
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
/**股票走势图*/
- (instancetype)initWithStockData:(OperateStockData &)stockData;

/**交易动态*/
- (instancetype)initWithOperateStockTransaction:(OperateStockTransaction *)trans;
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

/**持仓情况*/
- (instancetype)initWithOperateStocks:(OperateStocks *)stocks;
/**cost 成本*/
@property (nonatomic , copy) NSString *cost;
/**currprice 现价*/
@property (nonatomic , copy) NSString *currprice;;
/**profitrate 利润率*/
@property (nonatomic , copy) NSString *profitrate;
/**profitmoney 盈利的钱*/
@property (nonatomic , copy) NSString *profitmoney;



@end
