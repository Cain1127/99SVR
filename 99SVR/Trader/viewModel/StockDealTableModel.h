

/**股票详情的 TabViewModel*/


#import <Foundation/Foundation.h>

@interface StockDealTableModel : NSObject<UITableViewDelegate,UITableViewDataSource>
/**vip等级*/
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , weak) UIViewController *viewController;

-(void)setIsShowRecal:(NSString *)showRecal withOperateId:(NSInteger)operateId;

@end
