
/**股票交易详情的头部view*/


#import <UIKit/UIKit.h>

@interface StockDealHeaderView : UIView

/**标题*/
@property (nonatomic, strong) UILabel *titLab;
/**总收益*/
@property (nonatomic, strong) UILabel *totalLab;
/**日收益*/
@property (nonatomic , strong) UILabel *dayLab;
/**月收益*/
@property (nonatomic , strong) UILabel *monLab;
/**收益排行*/
@property (nonatomic , strong) UILabel *rankLab;
@end
