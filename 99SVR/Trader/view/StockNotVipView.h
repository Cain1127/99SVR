

/**没有vip显示的view 去购买：1    什么是私人定制：2*/


#import <UIKit/UIKit.h>


@protocol StockNotVipViewDelegate <NSObject>

-(void)stockNotVipViewDidSelectIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger,StockNotVipViewType){
    /**交易动态*/
    StockNotVipViewType_Business,
    /**持仓情况*/
    StockNotVipViewType_Storehouse,
};
@interface StockNotVipView : UIView

/**类型*/
@property (nonatomic , assign) StockNotVipViewType type;

/**去购买*/
@property (nonatomic , strong) UILabel *buyLab;
/**文字*/
@property (nonatomic , strong) UILabel *textLab;
/**什么是定制服务*/
@property (nonatomic , strong) UILabel *serviceLab;
@property (nonatomic , weak) id <StockNotVipViewDelegate>delegate;
@end
