

#define titleFont ValueWithTheIPhoneModelString(@"12,12,15,15")

#import "StockDealCellLabelView.h"
#import "ShareFunction.h"
#import "StockMacro.h"

@implementation StockDealCellLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
        [self initUI];
    }
    return self;
}


-(void)initUI{
    
    self.leftLab = [[UILabel alloc]init];
    self.leftLab.font = [UIFont systemFontOfSize:titleFont];
    self.leftLab.textAlignment = NSTextAlignmentLeft;
    self.leftLab.textColor = COLOR_Text_Black;
    [self addSubview:self.leftLab];
    
    
    self.rightLab = [[UILabel alloc]init];
    self.rightLab.font = [UIFont systemFontOfSize:titleFont];
    self.rightLab.textAlignment = NSTextAlignmentRight;
    self.rightLab.textColor = COLOR_Text_Black;
    [self addSubview:self.rightLab];
}

-(void)setLeftLabText:(NSString *)leftStr rightLabText:(NSString *)rightStr{

    self.leftLab.text = leftStr;
    self.rightLab.text = rightStr;

    
    CGSize leftLabSize = [ShareFunction calculationOfTheText:self.leftLab.text withFont:titleFont withMaxSize:(CGSize){self.width,CGFLOAT_MAX}];
    CGSize rightLabSize = [ShareFunction calculationOfTheText:self.rightLab.text withFont:titleFont withMaxSize:(CGSize){self.width,CGFLOAT_MAX}];


    if (leftLabSize.width>rightLabSize.width) {//左边大过右边
        
        self.leftLab.frame = (CGRect){10,0,leftLabSize.width + 10,self.height};
        self.rightLab.frame = (CGRect){CGRectGetMaxX(self.leftLab.frame),0,(self.width-CGRectGetMaxX(self.leftLab.frame)-10),self.height};

        
    }else{//右边大过左边
        
        self.rightLab.frame = (CGRect){self.width-(rightLabSize.width+10)-10,0,rightLabSize.width+10,self.height};
        self.leftLab.frame = (CGRect){10,0,self.width-(CGRectGetWidth(self.rightLab.frame)),self.height};
    }
}
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
-(void)setLeftLabAttText:(NSString *)leftAttText withLeftAttTextColor:(UIColor *)leftAttTextColor withLeftText:(NSString *)leftText withLeftTextColor:(UIColor *)leftTextColor  rightLabAttText:(NSString *)rightAttText withRightAttTextColor:(UIColor *)rightAttTextColor withRightText:(NSString *)rightText withRightTextColor:(UIColor *)rightTextColor{
    
    
//    self.leftLab.text = leftAttText;
//    self.rightLab.text = rightAttText;
    
    //计算长度
    CGSize leftLabSize = [ShareFunction calculationOfTheText:leftAttText withFont:titleFont withMaxSize:(CGSize){self.width,CGFLOAT_MAX}];
    CGSize rightLabSize = [ShareFunction calculationOfTheText:rightAttText withFont:titleFont withMaxSize:(CGSize){self.width,CGFLOAT_MAX}];
    
    if (leftLabSize.width>rightLabSize.width) {//左边大过右边
        self.leftLab.frame = (CGRect){10,0,leftLabSize.width + 10,self.height};
        self.rightLab.frame = (CGRect){CGRectGetMaxX(self.leftLab.frame),0,(self.width-CGRectGetMaxX(self.leftLab.frame)-10),self.height};
        
    }else{//右边大过左边
        
        self.rightLab.frame = (CGRect){self.width-(rightLabSize.width+10)-10,0,rightLabSize.width+10,self.height};
        self.leftLab.frame = (CGRect){10,0,self.width-(CGRectGetWidth(self.rightLab.frame)),self.height};
    }

    //设置左边的富文本
    NSMutableAttributedString *leftAtt = [[NSMutableAttributedString alloc]initWithString:leftAttText];
    NSRange leftRang = [leftAttText rangeOfString:leftText];
    //设置左边的字体颜色
    [leftAtt addAttribute:NSForegroundColorAttributeName
                    value:leftAttTextColor
                    range:NSMakeRange(0, [leftAttText length])];
    //设置左边查找的字体颜色
    [leftAtt addAttribute:NSForegroundColorAttributeName
                    value:leftTextColor
                    range:NSMakeRange(leftRang.location, leftRang.length)];


    //设置右边的富文本
    NSMutableAttributedString *rightAtt = [[NSMutableAttributedString alloc]initWithString:rightAttText];
    NSRange rightRang = [rightAttText rangeOfString:rightText];
    
    [rightAtt addAttribute:NSForegroundColorAttributeName
                    value:rightAttTextColor
                    range:NSMakeRange(0, [rightAttText length])];
    //设置右边查找的字体颜色
    [rightAtt addAttribute:NSForegroundColorAttributeName
                     value:rightTextColor
                     range:NSMakeRange(rightRang.location, rightRang.length)];

    
    self.leftLab.attributedText = leftAtt;
    self.rightLab.attributedText = rightAtt;
    
}



@end
