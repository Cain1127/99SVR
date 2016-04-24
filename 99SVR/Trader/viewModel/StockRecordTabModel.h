

/**股票交易记录 持仓详情*/

#import <Foundation/Foundation.h>

@interface StockRecordTabModel : NSObject<UITableViewDelegate,UITableViewDataSource>

/**
 *  数据源
 *
 *  @param dataArray 数据源
 *  @param tag       1;交易记录 2持仓情况
 */
-(void)setDataArray:(NSArray *)dataArray WithRecordTableTag:(NSInteger)tag;

@end
