

/**股票详情的 TabViewModel*/


#import <Foundation/Foundation.h>
#import "StockDealModel.h"


@protocol StockDealTableModelDelegate <NSObject>

/**去购买Vip*/
-(void)goBuyVipService;
/**点击头部的提示跳转*/
-(void)didClickTableHeaderViewTag:(NSInteger)tag;
/**点击tableView的回调跳转*/
-(void)didSelectRowAtIndexPathWithTableView:(NSIndexPath *)indexPath;


@end

@interface StockDealTableModel : NSObject<UITableViewDelegate,UITableViewDataSource>
/**vip等级*/
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , weak) id<StockDealTableModelDelegate>delegate;


-(void)setIsShowRecal:(NSString *)showRecal withDataModel:(StockDealModel *)model;


@end
