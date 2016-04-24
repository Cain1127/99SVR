

/**新闻客户端顶部标题控件*/

#import <UIKit/UIKit.h>

@interface SliderLabel : UILabel

/**是否隐藏红点 默认就是不显示*/
@property (nonatomic, assign) BOOL isHideBadge;
/**背景色*/
@property (nonatomic, strong) UIColor *backgroundColor;
/**红点的颜色 默认是红色的*/
@property (nonatomic, strong) UIColor *badgeColor;

@end


@interface SliderMenuTopScrollView : UIScrollView <UIScrollViewDelegate>
/**点击事件*/
@property (nonatomic, copy) void (^DidSelectSliderIndex)(NSInteger index);

/**
 *  初始化顶部的控件
 *
 *  @param frame  frame
 *  @param titles 控件的标题
 *  @param index  默认选择的下标
 */
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withDefaultSelectIndex:(NSInteger)index;
/**
 *  设置顶部lineView的滑动
 *
 *  @param originx 坐标x值
 *  @param index   下标
 */
-(void)setLineViewOriginX:(CGFloat)originx withIndex:(NSInteger)index;

/**指定的title是否显示红点提示*/
-(void)setTitleIndex:(NSInteger)index badgeHide:(BOOL)value;
/**外部修改badge的颜色*/
-(void)setTitleBadgeColor:(UIColor *)color;
/**提供给外部修改标题背景的颜色*/
-(void)setTitleBagColor:(UIColor *)color;
@end





