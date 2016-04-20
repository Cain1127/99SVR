
/**股票交易详情的头部view*/


#import <UIKit/UIKit.h>


@interface StockLabel : UIView
/**标题*/
@property (nonatomic , strong) UILabel *titLab;
/**数值*/
@property (nonatomic , strong) UILabel *numLab;
/**右边的线*/
@property (nonatomic , assign) BOOL isShowLine;
@end



@interface StockDealHeaderView : UIView

/**日收益*/
@property (nonatomic , strong) StockLabel *dayLabView;
/**月收益*/
@property (nonatomic , strong) StockLabel *monLabView;
/**总收益*/
@property (nonatomic , strong) StockLabel *rankLabView;
/**底部的分割线*/
@property (strong, nonatomic)  UIView *midLineView;
/**股票的名称*/
@property (strong, nonatomic)  UILabel *stockLab;
/**总收益数字*/
@property (strong, nonatomic)  UILabel *totalNumLab;
/**总收益*/
@property (nonatomic , strong) UILabel *totalLab;
@end
