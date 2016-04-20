

/**股票详情 数据model*/


#import <Foundation/Foundation.h>
#import "HttpMessage.pb.h"


@interface StockDealModel : NSObject

/**股票头部详情数据*/
- (instancetype)initWithProfit:(OperateStockProfit &)profit;
/**<#type#>*/
@property (nonatomic , copy) NSString *operateid;
/**<#type#>*/
@property (nonatomic , copy) NSString *teamid;
/**<#type#>*/
@property (nonatomic , copy) NSString *teamname;
/**<#type#>*/
@property (nonatomic , copy) NSString *teamicon;
/**<#type#>*/
@property (nonatomic , copy) NSString *focus;
/**<#type#>*/
@property (nonatomic , copy) NSString *goalprofit;
/**总收益*/
@property (nonatomic , copy) NSString *totalprofit;
/**日收益*/
@property (nonatomic , copy) NSString *dayprofit;
/**月收益*/
@property (nonatomic , copy) NSString *monthprofit;
/**超赢*/
@property (nonatomic , copy) NSString *winrate;

/**股票走势图*/
- (instancetype)initWithStockData:(OperateStockData &)stockData;

/**交易动态*/
- (instancetype)initWithOperateStockTransaction:(OperateStockTransaction *)trans;
/**buytype*/
@property (nonatomic , copy) NSString *buytype;
/**stockid*/
@property (nonatomic , copy) NSString *stockid;
/**stockname*/
@property (nonatomic , copy) NSString *stockname;
/**price*/
@property (nonatomic , copy) NSString *price;
/**count*/
@property (nonatomic , copy) NSString *count;
/**_money*/
@property (nonatomic , copy) NSString *money;
/**time*/
@property (nonatomic , copy) NSString *time;

/**持仓情况*/
- (instancetype)initWithOperateStocks:(OperateStocks *)stocks;
/**cost*/
@property (nonatomic , copy) NSString *cost;
/**currprice*/
@property (nonatomic , copy) NSString *currprice;;
/**profitrate*/
@property (nonatomic , copy) NSString *profitrate;
/**profitmoney*/
@property (nonatomic , copy) NSString *profitmoney;



@end
