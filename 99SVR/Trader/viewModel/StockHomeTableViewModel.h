

/**高手操盘TableViewModel首页*/


#import <Foundation/Foundation.h>

@interface StockHomeTableViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>
- (instancetype)initWithViewController:(UIViewController *)viewController;
/**
 *  数据源
 *
 *  @param dataArray 数据源
 */
-(void)setDataArray:(NSArray *)dataArray;

@end
