


/**高手操盘的首页的cell*/

#import "BaseCell.h"
//#import "StockDealModel.h"
@class ZLOperateStock;
@class StockDealModel;

@interface StockHomeCell : BaseCell

/**头像*/
@property (nonatomic, strong) UIImageView *iconImv;
/**操盘名字*/
@property (nonatomic, strong) UILabel *nameLab;
/**战队的名字*/
@property (nonatomic, strong) UILabel *traderNameLab;
/**目标收益*/
@property (nonatomic, strong) UILabel *targetLab;
/**总收益数字*/
@property (nonatomic, strong) UILabel *totalNumLab;
/**总收益标题*/
@property (nonatomic, strong) UILabel *totalTitLab;

/**tabbar高手操盘 和 首页的高手操盘的cell 1是财经直播tabbar的，2是高手操盘tabbar的*/
-(void)setCellDataWithModel:(StockDealModel *)model withTabBarInteger:(NSInteger)integer;

/**房间内高手操盘*/
- (void)setXTraderVCcellStockModel:(StockDealModel *)model;

@end
