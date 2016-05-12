/**
 *  公共函数方法 全类通用
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareFunction : NSObject
#pragma mark 计算出字体的长度已经高度。这里不包括行距
/**
 *  计算出字体的长度已经高度。这里不包括行距
 *
 *  @param string  字体
 *  @param font    字体大小
 *  @param maxSize label最大的宽度和高度
 *
 *  @return 字体的CGsize
 */
+(CGSize)calculationOfTheText:(NSString *)string withFont:(CGFloat)font withMaxSize:(CGSize)maxSize;


/**
 *  设置导航条的颜色,已经隐藏导航条下面的线了
 *
 *  @param color  颜色
 *  @param target 直接传self
 */
#pragma mark 设置导航条的颜色
+(void)setNavigationBarColor:(UIColor *)color withTargetViewController:(id)target;
#pragma mark scrollView顶部视图下拉放大
/**
 *  scrollView顶部视图下拉放大
 *
 *  @param imageView  需要放大的图片
 *  @param headerView 图片所在headerView 如果没有则传图片自己本身
 *  @param height     图片的高度
 *  @param offsetY    设置偏移多少开始形变  例如是：offset_y = 64 说明就是y向下偏移64像素开始放大
 *  @param scrollView 对应的scrollView
 */
+(void)setHeaderViewDropDownEnlargeImageView:(UIImageView *)imageView withHeaderView:(UIView *)headerView withImageViewHeight:(CGFloat)height withOffsetY:(CGFloat)offsetY withScrollView:(UIScrollView *)scrollView;



/**
 *  传入当前控制器 传入同一个NAV的控制器类名 返回指定控制器
 *
 *  @param viewControllerName 控制器的类名
 *  @param viewController     当前控制器
 *
 *  @return 
 */
+(UIViewController *)getTargetViewController:(NSString *)viewControllerName withInTheCurrentController:(UIViewController *)viewController;
/**
 *  传入时间戳1296057600和输出格式 yyyy-MM-dd HH:mm:ss
 *
 *  @param seconds @"1296057600"
 *  @param format  @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 返回格式化的日期字符串
 */
+ (NSString *)dateWithTimeIntervalSince1970:(NSTimeInterval)seconds dateStringWithFormat:(NSString *)format;

/**
 *  排序 小到大
 *
 *  @param array 原来数据源
 *
 *  @return 返回小到大
 */
+(NSMutableArray *)sortOfSmallToBig:(NSArray *)array;

/**
 *  返回两个数组的最大值和最小值 数组第一个最小值，第二个是最大值
 *
 *  @param arrA A数组
 *  @param arrB B数组
 *
 */
+(NSArray *)returnMinandMaxWithArrayA:(NSArray *)arrA withArrayB:(NSArray *)arrB;
/**
 *  返回高手操盘股票详情右边的数值
 *
 *  @param array 传入一个数组【最小值，最大值】；
 *
 *  @return 一个处理好的数组
 */
+(NSArray *)returnStockDelChartLineViewLeftLabelTextWithDataArray:(NSArray *)array;



@end
