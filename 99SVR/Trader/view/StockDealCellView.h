

/**股票交易详情cell的 交易动态和 持仓详情的label*/


#import <UIKit/UIKit.h>
#import "StockDealCellLabelView.h"
@interface StockDealCellView : UIView

/**标题*/
@property (nonatomic , strong) StockDealCellLabelView *titleLabV;
/**成本*/
@property (nonatomic , strong) StockDealCellLabelView *costRmbLabV;
/**现价*/
@property (nonatomic , strong) StockDealCellLabelView *nowRmbLabV;

@end
