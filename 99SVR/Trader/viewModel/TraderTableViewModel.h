

/**高手操盘TableViewModel首页*/


#import "BaseTableViewModel.h"

@interface TraderTableViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>
- (instancetype)initWithViewController:(UIViewController *)viewController;
/**
 *  数据源
 *
 *  @param dataArray 数据源
 */
-(void)setDataArray:(NSArray *)dataArray;
@end
