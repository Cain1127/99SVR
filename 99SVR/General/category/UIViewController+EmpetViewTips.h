

/**控制器空白提示view,数据加载失败View*/

#import <UIKit/UIKit.h>
typedef void(^TouchHanleBlock)(void);

@interface UIViewController (EmpetViewTips)

/**
 *  提示空白的View
 *
 *  @param targetView  添加在哪个view
 *  @param msg        提示信息
 *  @param hanleBlock 点击回调处理
 */
-(void)showEmptyViewInView:(UIView *)targetView withMsg:(NSString *)msg touchHanleBlock:(TouchHanleBlock)hanleBlock;
/**
 *  提示网络错误的View
 *
 *  @param targetView  添加在哪个view
 *  @param msg        提示信息
 *  @param hanleBlock 点击回调处理
 */
-(void)showErrorViewInView:(UIView *)targetView withMsg:(NSString *)msg touchHanleBlock:(TouchHanleBlock)hanleBlock;
/**
 *  隐藏提示的view
 *
 *  @param targetView 在哪个view
 */
-(void)hideEmptyViewInView:(UIView *)targetView;

@end
