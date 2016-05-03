

/**股票走势详情图*/

#import <UIKit/UIKit.h>
#import "DDLineChartView.h"

typedef void(^DidSelectIndex)(NSInteger index);

@interface StockChartView : UIView

/**顶部控制按钮*/
@property (nonatomic, strong) NSArray *topTitItems;
/**底部的标签*/
@property (nonatomic , strong) NSArray *lowTitArrays;
/**左边的标签*/
@property (nonatomic , strong) NSArray *leftTitArrays;
/**曲线图*/
@property (nonatomic, strong) DDLineChartView *lineChartView;
/**更新数据*/
@property (nonatomic , copy)  DidSelectIndex  didSelcetIndex;
/**选择的下标*/
@property (nonatomic , assign) __block NSInteger selectIndex;

@end
