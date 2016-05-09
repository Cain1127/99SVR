

/**高手操盘TableViewModel首页*/


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,StockHomeTableViewType) {

    /**tabbar高手操盘首页*/
    StockHomeTableViewType_StockHomeVC = 1,
    /**房间内高手操盘模块*/
    StockHomeTableViewType_XTraderViewVC = 2,
    
};


@protocol StockHomeTableViewModelDelegate <NSObject>
/**点击cell的回调*/
-(void)tabViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(id)model;

@end

@interface StockHomeTableViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , weak) id<StockHomeTableViewModelDelegate>delegate;

- (instancetype)initWithViewModelType:(StockHomeTableViewType)viewModelType;
/**
 *  数据源
 *
 *  @param dataArray 数据源
 */
-(void)setDataArray:(NSArray *)dataArray;

@end
