

/**股票交易详情*/
typedef NS_ENUM(NSInteger,Stock_State){
    
    /**购买VIP*/
    Stock_State_Vip,
    /**未购买VIP*/
    Stock_State_Non,
    
};

#import "CustomViewController.h"

@interface StockDealViewController : CustomViewController

/**是否是会员*/
@property (nonatomic , assign) Stock_State stockState;

@end
