

/**画折线*/


#import <UIKit/UIKit.h>

//范围
struct RangeValue {
    CGFloat max;
    CGFloat min;
};
typedef struct RangeValue CGRange;
CG_INLINE CGRange CGRangeMake(CGFloat max, CGFloat min);

CG_INLINE CGRange
CGRangeMake(CGFloat min, CGFloat max){
    CGRange r;
    r.max = max;
    r.min = min;
    return r;
}
@interface DDLineChartView : UIView

/**画横线*/
@property (nonatomic, assign) BOOL drawLine_X;
/**画竖线*/
@property (nonatomic, assign) BOOL drawLine_Y;
/**目标值*/
@property (nonatomic, assign) CGFloat targetValue_Y;


/**数据源 二维数组 有几条线就有几个数据组*/
@property (nonatomic, strong) NSArray *valuePoints_Y;
/**颜色数组*/
@property (nonatomic, strong) NSArray *lineColors;
/**Y取值范围*/
@property (nonatomic, assign) CGRange raneValue_Y;
/**Y取值的阶级*/
@property (nonatomic, assign) NSInteger level_Y;
/**X取值范围*/
@property (nonatomic, assign) CGRange raneValue_X;
/**X取值的阶级*/
@property (nonatomic, assign) NSInteger level_X;
/**画线的时间*/
@property (nonatomic, assign) CGFloat timeValue;


/**画线*/
-(void)drawLine;
/**移除线*/
-(void)clearLine;

@end
