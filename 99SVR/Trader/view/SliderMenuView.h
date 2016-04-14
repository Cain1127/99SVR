
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



- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;
/**存储view的数组*/
@property (nonatomic, strong) NSArray *viewArrays;
@property (nonatomic, copy) void (^DidSelectSliderIndex)(NSInteger index);

@end
