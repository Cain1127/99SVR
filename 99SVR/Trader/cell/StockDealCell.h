

/**股票详情*/
#import "BaseCell.h"
#import "StockChartView.h"
#import "StockDealCellLabelView.h"
#import "StockDealModel.h"
#import "StockDealCellView.h"
@interface StockDealCell : BaseCell

/**股票走势图*/
@property (nonatomic , strong) StockChartView *chartView;
/**交易动态的view*/
@property (nonatomic , strong) StockDealCellLabelView *tradeLabeView;
/**持仓情况*/
@property (nonatomic , strong) StockDealCellView *wareHouseViw;


-(void)setCellDataWithModel:(StockDealModel *)model withIsVip:(BOOL)value withCellId:(NSString *)cellId;

@end
