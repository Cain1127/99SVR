

/**股票交易记录*/

#import <Foundation/Foundation.h>

@interface StockRecordTabModel : NSObject<UITableViewDelegate,UITableViewDataSource>

- (instancetype)initWithViewController:(UIViewController *)viewController withDayTabViews:(NSArray *)tableViews;

@end
