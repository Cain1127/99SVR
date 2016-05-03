//
//  StockDealCellView.m
//  99SVR
//
//  Created by 刘海东 on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockDealCellLabelView.h"
#import "ShareFunction.h"


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
    self.leftLab.font = [UIFont systemFontOfSize:15];
    self.leftLab.textAlignment = NSTextAlignmentLeft;
    self.leftLab.textColor = COLOR_Text_Black;
    [self addSubview:self.leftLab];
    
    
    self.rightLab = [[UILabel alloc]init];
    self.rightLab.font = [UIFont systemFontOfSize:15];
    self.rightLab.textAlignment = NSTextAlignmentRight;
    self.rightLab.textColor = COLOR_Text_Black;
    [self addSubview:self.rightLab];
    
//    self.leftLab.backgroundColor = [UIColor yellowColor];
//    
//    self.rightLab.backgroundColor = [UIColor grayColor];

}

-(void)setLeftLabText:(NSString *)leftStr rightLabText:(NSString *)rightStr{

    self.leftLab.text = leftStr;
    self.rightLab.text = rightStr;

    
    CGSize leftLabSize = [ShareFunction calculationOfTheText:self.leftLab.text withFont:15 withMaxSize:(CGSize){self.width,CGFLOAT_MAX}];
    CGSize rightLabSize = [ShareFunction calculationOfTheText:self.rightLab.text withFont:15 withMaxSize:(CGSize){self.width,CGFLOAT_MAX}];


    if (leftLabSize.width>rightLabSize.width) {//左边大过右边
        
        NSLog(@"%@",self.leftLab.text);
        
        self.leftLab.frame = (CGRect){10,0,leftLabSize.width + 10,self.height};
        self.rightLab.frame = (CGRect){CGRectGetMaxX(self.leftLab.frame),0,(self.width-CGRectGetMaxX(self.leftLab.frame)-10),self.height};
        
    }else{//右边大过左边
        
        self.rightLab.frame = (CGRect){self.width-(rightLabSize.width+10)-10,0,rightLabSize.width+10,self.height};
        self.leftLab.frame = (CGRect){10,0,self.width-(CGRectGetWidth(self.rightLab.frame)),self.height};
    }
}

@end
