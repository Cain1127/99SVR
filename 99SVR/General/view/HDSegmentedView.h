
/**
 *  自定义的UISegmentedControl 回调用block
*/

#import <UIKit/UIKit.h>

@interface HDSegmentedViewLabel : UILabel
/**红点提示数*/
@property (nonatomic , assign) NSInteger badgeNum;
/**是否隐藏红点 默认就是不显示*/
@property (nonatomic, assign) BOOL isHideBadge;
/**红点的颜色*/
@property (nonatomic , strong) UIColor *badgeColor;
@end


typedef NS_ENUM(NSInteger,ChangeColorDirection){
    /**上下渐变*/
    ChangeColorDirection_U_D,
    /**下上渐变*/
    ChangeColorDirection_D_U,
    /**左右渐变*/
    ChangeColorDirection_L_R,
    /**右左渐变*/
    ChangeColorDirection_R_L,
    
};

@interface HDSegmentedView : UIView

@property (nonatomic , copy) void (^DidSelectSegmentedViewIndex)(NSInteger index);

/**设置顶部渐变的颜色 只支持两种颜色渐变*/
@property (nonatomic , strong) NSArray *colorArrays;
/**设置渐变颜色的方向*/
@property (nonatomic , assign) ChangeColorDirection colorDirectionType;
/**设置选中的模块*/
@property (nonatomic , assign) NSInteger selectIndex;
/**边框的颜色*/
@property (nonatomic , strong) UIColor *borderColor;
/**显示指定的badge 不显示数字*/
@property (nonatomic, assign) NSInteger showBadgeIndex;
/**修改提示的颜色*/
@property (nonatomic , strong) UIColor *badgeColor;
/**标题的颜色 0：默认的颜色 1：选中的颜色*/
@property (nonatomic , strong) NSArray *titleColors;
/**
 *  初始化方法
 *
 *  @param frame frame
 *  @param items 按钮的标题
 *
 */
- (instancetype)initWithFrame:(CGRect)frame initWithItems:(NSArray *)items;
/**显示指定的badge 并且显示数字*/
-(void)setShowBadgeIndex:(NSInteger)index andBadgeNum:(NSInteger)num;

@end
