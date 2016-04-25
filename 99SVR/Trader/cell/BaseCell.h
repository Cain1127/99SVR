

/**
 *  若继承这个cell 则控件都是添加在bakImageView上去
 */


#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell
/**背景图片*/
@property (nonatomic, strong) UIImageView *bakImageView;
/**底部线条*/
@property (nonatomic, strong) UIView *lineView;

/**初始化控件*/
-(void)initUI;
/**进行布局*/
-(void)setAutoLayout;


@end
