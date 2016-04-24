
/**
 *  自定义的UITextField 左边显示图片 右边带否显示密码
 */


#import <UIKit/UIKit.h>

@interface RegisterTextField : UITextField

/**左边的提示*/
@property (nonatomic, copy) NSString *leftViewImageName;
/**是否开启安全密码模式*/
@property (nonatomic, assign) BOOL isShowTextBool;

@end
