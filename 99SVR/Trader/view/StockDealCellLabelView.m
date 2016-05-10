

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

@end
