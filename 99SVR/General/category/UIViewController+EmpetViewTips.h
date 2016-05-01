

/**控制器空白提示view,数据加载失败View*/

#import <UIKit/UIKit.h>

@interface UIViewController (EmpetViewTips)

/**
 *  提示空白数据的View
 *
 *  @param targetView 添加在哪个view
 *  @param msg        提示信息
 */
-(void)showEmptyViewInView:(UIView *)targetView withMsg:(NSString *)msg;
/**
 *  提示网络错误的View
 *
 *  @param targetView 添加在哪个view
 *  @param msg        提示信息
 */
-(void)showErrorViewInView:(UIView *)targetView withMsg:(NSString *)msg;

@end
