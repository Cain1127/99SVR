

/**股票详情的 TabViewModel*/


#import <Foundation/Foundation.h>

@interface StockDealTableModel : NSObject<UITableViewDelegate,UITableViewDataSource>
/**vip等级*/
@property (nonatomic , assign) NSInteger vipLevel;
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , weak) UIViewController *viewController;

@end
