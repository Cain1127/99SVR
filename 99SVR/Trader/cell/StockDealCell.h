

/**股票详情*/
#import "BaseCell.h"
#import "StockChartView.h"
@interface StockDealCell : BaseCell

/**cell的类型*/
@property (nonatomic , copy) NSString *cellType;

/**股票走势图*/
@property (nonatomic , strong) StockChartView *chartView;



@end
