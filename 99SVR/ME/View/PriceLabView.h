
/**购买私人定制的价格View*/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PriceLabViewState){
    /**已经购买VIP*/
    PriceLabViewType_Vip,
    /**没有购买VIP*/
    PriceLabViewType_NotVip,
};

@interface PriceLabView : UIView

/**类型*/
@property (nonatomic , assign) PriceLabViewState state;

/**原价格*/
@property (nonatomic , copy) NSString *oldpriceStr;
/**新价格*/
@property (nonatomic , copy) NSString *newpriceStr;


@end
