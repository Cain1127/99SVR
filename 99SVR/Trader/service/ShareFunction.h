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
 *  计算出字体的长度已经高度。并且要设置行距。会对Lable进行处理。返回宽度和高度可以不用处理。
 *
 *  @param string  字体
 *  @param label   目标Lable
 *  @param font    字体大小
 *  @param width label最大的宽度
 *  @param spacing 行距
 *
 *  @return 处理过的Lable
 */
+(CGRect)calculationOfTheText:(NSString *)string inLabel:(UILabel *)label withFont:(CGFloat)font withMaxWidth:(CGFloat)width withLineSpacing:(CGFloat)spacing;

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
 *  名片详情弹出的UIAlertController视图 下标为0就是取消 1就是其他按钮
 *
 *  @param title              标题
 *  @param cancelStr          取消按钮
 *  @param otherBthStr        other按钮
 *  @param message            提示信息
 *  @param completionCallback （下标为0就是取消 1就是其他按钮）
 *
 *  @return UIAlertController
 */
+(void)createAlertViewWithTitle:(NSString *)title withViewController:(UIViewController *)viewController withCancleBtnStr:(NSString *)cancelStr withOtherBtnStr:(NSString *)otherBthStr withMessage:(NSString *)message completionCallback:(void (^)(NSInteger index))completionCallback;


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

@end
