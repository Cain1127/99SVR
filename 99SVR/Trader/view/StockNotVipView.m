

#define buyLab_font ValueWithTheIPhoneModelString(@"17,17,17,17") //去购买
#define textLab_font ValueWithTheIPhoneModelString(@"15,15,15,15") //购买交易记录
#define serviceLab_font ValueWithTheIPhoneModelString(@"17,17,17,17")// 什么是私人定制服务
#define buy_top_bottom ValueWithTheIPhoneModelString(@"20,20,20,20")//交易动态上下的间隔
#define storehouse_top_bottom ValueWithTheIPhoneModelString(@"40,40,40,40")//交易动态上下的间隔


#import "StockNotVipView.h"
#import "StockMacro.h"

@implementation StockNotVipView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.userInteractionEnabled = YES;
        [self initUI];
        
        
    }
    return self;
}


-(void)initUI{
    
    self.buyLab = [[UILabel alloc]init];
    self.buyLab.textAlignment = NSTextAlignmentCenter;
    self.buyLab.font = [UIFont systemFontOfSize:buyLab_font];
    self.buyLab.text = @"去购买";
    self.buyLab.textColor = COLOR_STOCK_Orange;
    self.buyLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *buyTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyLabelClick:)];
    buyTap.numberOfTapsRequired = 1;
    [self.buyLab addGestureRecognizer:buyTap];
    [self addSubview:self.buyLab];
    
    self.textLab = [[UILabel alloc]init];
    self.textLab.textAlignment = NSTextAlignmentCenter;
    self.textLab.textColor = COLOR_STOCK_Text_Black;
    self.textLab.font = [UIFont systemFontOfSize:textLab_font];
    [self addSubview:self.textLab];
    
    self.serviceLab = [[UILabel alloc]init];
    self.serviceLab.textAlignment = NSTextAlignmentCenter;
    self.serviceLab.font = [UIFont systemFontOfSize:serviceLab_font];
    self.serviceLab.text = @"什么是私人订制服务";
    self.serviceLab.textColor = COLOR_STOCK_Blue;
    self.serviceLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *serviceTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(serviceLabelClick:)];
    serviceTap.numberOfTapsRequired = 1;
    [self.serviceLab addGestureRecognizer:serviceTap];
    [self addSubview:self.serviceLab];
}

-(void)setType:(StockNotVipViewType)type{
    
    CGFloat buyLab_top = 0;
    if (type==StockNotVipViewType_Business) {//交易动态
        self.frame = (CGRect){0,0,ScreenWidth,STORCK_Deal_BusinessRecordCell_NotVIP_H};
        self.textLab.text = @"购买私人订制服务可查看详细交易记录";
        buyLab_top = buy_top_bottom;
        self.serviceLab.hidden = YES;
        
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.bottom.equalTo(@(-buy_top_bottom));
        }];

        
    }else{//持仓情况
        self.frame = (CGRect){0,0,ScreenWidth,STORCK_Deal_WareHouseRecordCell_NotVIP_H};
        self.textLab.text = @"购买私人订制服务可查看详细持仓情况";
        buyLab_top = storehouse_top_bottom;
        self.serviceLab.hidden = NO;
        
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(self.buyLab.mas_bottom).offset(20);
        }];
    }
    
    
    [self.buyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(buyLab_top));
    }];
    
    
    [self.serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@(-storehouse_top_bottom));
    }];
    
}
/**购买*/
-(void)buyLabelClick:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(stockNotVipViewDidSelectIndex:)]) {
        [self.delegate stockNotVipViewDidSelectIndex:1];
    }
}

/**查看serviceLabelClick*/
-(void)serviceLabelClick:(UITapGestureRecognizer *)tap{

    if ([self.delegate respondsToSelector:@selector(stockNotVipViewDidSelectIndex:)]) {
        [self.delegate stockNotVipViewDidSelectIndex:2];
    }
}


@end
