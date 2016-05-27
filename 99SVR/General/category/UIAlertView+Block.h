

/**iOS8以上自动调用 UIAlertController iOS8以下使用UIAlertView*/


#import <UIKit/UIKit.h>

typedef void(^UIAlertViewCallBackBlock)(UIAlertView *alertView,NSInteger buttonIndex);

@interface UIAlertView (Block)<UIAlertViewDelegate>

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;
///**
// *  不对外使用
//*/
//+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
//                         title:(NSString *)title
//                       message:(NSString *)message
//              cancelButtonName:(NSString *)cancelButtonName
//             otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;



/**
 *  快速创建UIAlertView视图
 *
 *  @param title              标题
 *  @param viewController     当前控制器
 *  @param cancelStr          取消按钮
 *  @param otherBthStr        确定按钮
 *  @param message            提示信息
 *  @param completionCallback 回调事件
 */
+(void)createAlertViewWithTitle:(NSString *)title withViewController:(UIViewController *)viewController withCancleBtnStr:(NSString *)cancelStr withOtherBtnStr:(NSString *)otherBthStr withMessage:(NSString *)message completionCallback:(void (^)(NSInteger index))completionCallback;

+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock txtField:(NSString *)txtField title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@end
