
#import "PriceLabView.h"
#import "ShareFunction.h"
@interface PriceLabView ()
@property (nonatomic , strong) UILabel *oldpriceLab;
@property (nonatomic , strong) UILabel *newpriceLab;
/**字体分割线*/
@property (nonatomic , strong) UIView *oleLabLineView;
@end

@implementation PriceLabView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.oldpriceLab = [[UILabel alloc]init];
        self.oldpriceLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.oldpriceLab];
        
        
        self.newpriceLab = [[UILabel alloc]init];
        self.newpriceLab.font = Font_15;
        [self addSubview:self.newpriceLab];
        
        self.oleLabLineView = [[UIView alloc]init];
        self.oleLabLineView.backgroundColor = COLOR_Text_919191;
        [self addSubview:self.oleLabLineView];
    }
    return self;
}


-(void)setState:(PriceLabViewState)state{
    _state = state;
    
    if (state==PriceLabViewType_Vip) {//已经购买了VIP
        
        self.newpriceLab.hidden = YES;
        self.oleLabLineView.hidden = YES;
        self.oldpriceLab.font = Font_15;
        self.oldpriceLab.textColor = COLOR_Text_919191;
        self.oldpriceLab.text = _oldpriceStr;
        [self.oldpriceLab sizeToFit];
        self.oldpriceLab.frame = (CGRect){10,0,self.oldpriceLab.width,self.height};
        self.newpriceLab.text = @"";
    }else{
        
        self.newpriceLab.hidden = NO;
        self.oleLabLineView.hidden = NO;
        self.newpriceLab.text = _newpriceStr;
        [self.newpriceLab sizeToFit];
        self.newpriceLab.frame = (CGRect){10,5,self.newpriceLab.width,self.height/2.0};
        self.oldpriceLab.frame = (CGRect){10,self.height/2.0-5,self.newpriceLab.width,self.height/2.0};

        [self.oleLabLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.oldpriceLab.mas_centerY);
            make.left.equalTo(self.oldpriceLab.mas_left).offset(0);
            make.right.equalTo(self.oldpriceLab.mas_right).offset(0);
            make.height.equalTo(@1);
        }];
        
        self.oldpriceLab.text = _oldpriceStr;
        self.oldpriceLab.font = Font_12;
        self.newpriceLab.textColor = COLOR_Auxiliary_Orange;
        self.oldpriceLab.textColor = COLOR_Text_919191;
        self.width = self.newpriceLab.width;
    }

}


-(void)setOldpriceStr:(NSString *)oldpriceStr{
    
    _oldpriceStr = oldpriceStr;
}


-(void)setNewpriceStr:(NSString *)newpriceStr{
    
    _newpriceStr = newpriceStr;
}



@end
