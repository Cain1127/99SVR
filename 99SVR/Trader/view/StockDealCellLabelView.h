
/**股票交易详情cell的 交易动态和 持仓详情的label*/

#import <UIKit/UIKit.h>

@interface StockDealCellLabelView : UIView
/**左边标签*/
@property (nonatomic , strong) UILabel *leftLab;
/**右边标签*/
@property (nonatomic , strong) UILabel *rightLab;

-(void)setLeftLabText:(NSString *)leftStr rightLabText:(NSString *)rightStr;

/**
 *  设置富文本的字体
 *
 *  @param leftAttText       整一个左边富文本的字符串
 *  @param leftAttTextColor  整一个左边富文本的字体颜色
 *  @param leftText          左边富文本需要改变的字体
 *  @param leftTextColor     左边富文本需要改变的字体颜色
 *  @param rightAttText      整一个右边富文本的字符串
 *  @param rightAttTextColor 整一个右边富文本的字体颜色
 *  @param rightText         右边富文本需要改变的字体
 *  @param rightTextColor    右边富文本需要改变的字体颜色
 */
-(void)setLeftLabAttText:(NSString *)leftAttText withLeftAttTextColor:(UIColor *)leftAttTextColor withLeftText:(NSString *)leftText withLeftTextColor:(UIColor *)leftTextColor  rightLabAttText:(NSString *)rightAttText withRightAttTextColor:(UIColor *)rightAttTextColor withRightText:(NSString *)rightText withRightTextColor:(UIColor *)rightTextColor;


@end
