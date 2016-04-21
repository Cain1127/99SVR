

/**股票详情*/
#import "BaseCell.h"
#import "StockChartView.h"
#import "StockDealCellLabelView.h"
#import "StockDealModel.h"
#import "StockDealCellView.h"
#import "StockNotVipView.h"
@interface StockDealCell : BaseCell

/**股票走势图*/
@property (nonatomic , strong) StockChartView *chartView;
/**交易动态的view*/
@property (nonatomic , strong) StockDealCellLabelView *tradeLabeView;
/**持仓情况*/
@property (nonatomic , strong) StockDealCellView *wareHouseViw;
/**不是VIP 的交易动态*/
@property (nonatomic , strong) StockNotVipView *notVipView;

-(void)setCellDataWithModel:(StockDealModel *)model withIsVip:(BOOL)vipBool withCellId:(NSString *)cellId;

@end
