

/**股票详情的 TabViewModel*/


#import <Foundation/Foundation.h>

@interface StockDealTableModel : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSArray *dataArray;

@property (nonatomic , weak) UIViewController *viewController;

@end
