



#import <UIKit/UIKit.h>

@interface SliderMenuBottomScroView : UIScrollView

@end

@interface SliderMenuView : UIView

@property (nonatomic, strong) SliderMenuBottomScroView *bottomScroView;
/**显示显示指定下标的红色提示*/
@property (nonatomic, assign) NSInteger showBadgeIndex;
/**H红色提示的颜色*/
@property (nonatomic, strong) UIColor *badgeColor;
/**标题的背景色*/
@property (nonatomic, strong) UIColor *titleBagColor;
/**默认选择的是哪一个按钮*/
@property (nonatomic , assign) NSInteger defaultSelectIndex;
/**顶部的控制menu的背景色*/
@property (nonatomic , strong) UIColor *topBagColor;

- (void)showUnBadgeIndex:(NSInteger)showBadgeIndex;


/**
 *  滚动控制视图
 *
 *  @param frame       frame
 *  @param titles      标题
 *  @param selectIndex 默认选择的模块（1，2，3，4....下标是按照1开始计算 不是从0开始计算）
 *
 */
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withDefaultSelectIndex:(NSInteger)selectIndex;
/**存储view的数组*/
@property (nonatomic, strong) NSArray *viewArrays;
/**点击顶部按钮 或者滑动切换对应页面时候的回调*/
@property (nonatomic, copy) void (^DidSelectSliderIndex)(NSInteger index);

-(void)hanleBlockWith:(NSInteger)index;

- (void)setDefaultIndex:(int)nIndex;

/**重置全部的红点提示*/
-(void)resetAllBadgePrompt;

/**重置会默认选择第一个按钮*/
-(void)resetSelectFirstIndex;

/**是否显示顶部的分割线*/
-(void)setTopLineViewHide:(BOOL)value;

@end
