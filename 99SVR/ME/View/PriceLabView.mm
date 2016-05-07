

#define vipOldPriceText_Font ValueWithTheIPhoneModelString(@"12,12,15,15") //vip
#define notVipOldPriceText_Font ValueWithTheIPhoneModelString(@"10,10,12,12")//没有vip
#define newPriceText_Font ValueWithTheIPhoneModelString(@"12,12,15,15")//


#import "PriceLabView.h"
#import "ShareFunction.h"
#import "StockMacro.h"
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
        self.newpriceLab.font = [UIFont systemFontOfSize:newPriceText_Font];
        [self addSubview:self.newpriceLab];
        
        self.oleLabLineView = [[UIView alloc]init];
        self.oleLabLineView.backgroundColor = COLOR_Text_Gay;
        [self addSubview:self.oleLabLineView];
        
    }
    return self;
}


-(void)setState:(PriceLabViewState)state{
    _state = state;
    
    if (state==PriceLabViewType_Vip) {//已经购买了VIP
        
        self.newpriceLab.hidden = YES;
        self.oleLabLineView.hidden = YES;
        self.oldpriceLab.font = [UIFont systemFontOfSize:vipOldPriceText_Font];
        self.oldpriceLab.textColor = COLOR_Text_Gay;
        self.oldpriceLab.text = _oldpriceStr;
        [self.oldpriceLab sizeToFit];
        self.oldpriceLab.frame = (CGRect){10,0,self.oldpriceLab.width,self.height};
        self.newpriceLab.text = @"";
    }else{
        
        self.newpriceLab.hidden = NO;
        self.oleLabLineView.hidden = NO;
        self.newpriceLab.text = _newpriceStr;
        [self.newpriceLab sizeToFit];
        self.newpriceLab.frame = Rect(10,5,self.newpriceLab.width,self.height/2.0f);
        self.oldpriceLab.frame = Rect(10,self.height/2.0-5,self.newpriceLab.width,self.height/2.0f);

        [self.oleLabLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.oldpriceLab.mas_centerY);
            make.left.equalTo(self.oldpriceLab.mas_left).offset(0);
            make.right.equalTo(self.oldpriceLab.mas_right).offset(0);
            make.height.equalTo(@1);
        }];
        
        self.oldpriceLab.text = _oldpriceStr;
        self.oldpriceLab.font = [UIFont systemFontOfSize:notVipOldPriceText_Font];
        self.newpriceLab.textColor = COLOR_Auxiliary_Orange;
        self.oldpriceLab.textColor = COLOR_Text_Gay;
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
