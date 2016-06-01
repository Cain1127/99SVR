
/**RGB 转换成 UIImage*/


#import <UIKit/UIKit.h>

@interface UIImage (RGB)
/**
 *  返回一个组合带渐变的颜色
 *
 *  @param colors       颜色数组
 *  @param gradientType 渐变的方向类型 0,//从上到下 1,//从左到右 2,//左到右 3,//右到左
 *  @param frame        frame
 *
 *  @return  返回一个组合带渐变的颜色
 */
+(UIImage *)imageFromColors:(NSArray *)colors byGradientType:(NSInteger)gradientType withFrame:(CGRect)frame;


/**
 *  图片更换颜色
 *
 *  @param tintColor 颜色
 *
 */
-(UIImage *)imageByColor:(UIColor *)tintColor;

@end
