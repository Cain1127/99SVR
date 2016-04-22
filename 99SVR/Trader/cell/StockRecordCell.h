

/**股票交易记录的 cell*/

#import "StockDealModel.h"
#import "BaseCell.h"
#import "StockDealCellView.h"

@interface StockRecordCell : BaseCell

@property (nonatomic , strong) StockDealCellView *dealView;

/**
 *  cell的数据
 *
 *  @param model cell的数据
 *  @param tag   1=>交易记录 2=>仓库记录
 */
-(void)setCellDataWithModel:(StockDealModel *)model withTag:(NSInteger)tag;


@end
