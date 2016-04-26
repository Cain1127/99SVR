
/**购买私人订制的价格View*/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PriceLabViewType){
    /**已经购买VIP*/
    PriceLabViewType_Vip,
    /**没有购买VIP*/
    PriceLabViewType_NotVip,
};

@interface PriceLabView : UIView

/**类型*/
@property (nonatomic , assign) PriceLabViewType type;

/**原价格*/
@property (nonatomic , copy) NSString *oldPriceStr;
/**新价格*/
@property (nonatomic , copy) NSString *newPriceStr;

@end
