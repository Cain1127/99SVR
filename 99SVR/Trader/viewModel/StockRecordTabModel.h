

/**股票交易记录 持仓详情*/

#import <Foundation/Foundation.h>

@interface StockRecordTabModel : NSObject<UITableViewDelegate,UITableViewDataSource>

- (instancetype)initWithViewController:(UIViewController *)viewController withDayTabViews:(NSArray *)tableViews;

-(void)setTableViewDataWithModel:(id)s;
@end
