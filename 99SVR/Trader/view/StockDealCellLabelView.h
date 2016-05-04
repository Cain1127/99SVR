
/**股票交易详情cell的 交易动态和 持仓详情的label*/

#import <UIKit/UIKit.h>

@interface StockDealCellLabelView : UIView
/**左边标签*/
@property (nonatomic , strong) UILabel *leftLab;
/**右边标签*/
@property (nonatomic , strong) UILabel *rightLab;

-(void)setLeftLabText:(NSString *)leftStr rightLabText:(NSString *)rightStr;

@end
