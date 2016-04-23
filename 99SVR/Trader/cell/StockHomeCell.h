


/**高手操盘的首页的cell*/

#import "BaseCell.h"
#import "StockDealModel.h"

@interface StockHomeCell : BaseCell

/**头像*/
@property (nonatomic, strong) UIImageView *iconImv;
/**名字*/
@property (nonatomic, strong) UILabel *nameLab;
/**操盘命名*/
@property (nonatomic, strong) UILabel *traderNameLab;
/**目标收益*/
@property (nonatomic, strong) UILabel *targetLab;
/**总收益数字*/
@property (nonatomic, strong) UILabel *totalNumLab;
/**总收益标题*/
@property (nonatomic, strong) UILabel *totalTitLab;

-(void)setCellDataWithModel:(StockDealModel *)model;

@end
