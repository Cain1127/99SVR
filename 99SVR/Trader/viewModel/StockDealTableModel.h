

/**股票详情的 TabViewModel*/


#import <Foundation/Foundation.h>
#import "StockDealModel.h"


@protocol StockDealTableModelDelegate <NSObject>

-(void)stockDealTableModelRefreshData;

@end

@interface StockDealTableModel : NSObject<UITableViewDelegate,UITableViewDataSource>
/**vip等级*/
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , weak) UIViewController *viewController;
@property (nonatomic , weak) id <StockDealTableModelDelegate> delegate;

-(void)setIsShowRecal:(NSString *)showRecal withDataModel:(StockDealModel *)model;


@end
