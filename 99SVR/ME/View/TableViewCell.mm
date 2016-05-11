


#define clickBtn_W ValueWithTheIPhoneModelString(@"60,60,100,100")
#define clickBtn_Font ValueWithTheIPhoneModelString(@"12,12,15,15")
#define priceLabView_h ValueWithTheIPhoneModelString(@"60,60,60,60")

#import "TableViewCell.h"
#import "ShareFunction.h"
#import "StockMacro.h"
@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectView.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
    self.selectView.layer.borderWidth = 0.5f;
    self.introduceLab.textColor = COLOR_Text_Black;
    
    self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.clickBtn.titleLabel.font = [UIFont systemFontOfSize:clickBtn_Font];
    [self.clickBtn setTitleColor:COLOR_Text_Black forState:UIControlStateDisabled];
    [self.selectView addSubview:self.clickBtn];
    
    self.priceLabView = [[PriceLabView alloc]initWithFrame:(CGRect){0,0,100,priceLabView_h}];
    [self.selectView addSubview:self.priceLabView];
    
    self.buyLabel = [[UILabel alloc]init];
    self.buyLabel.textAlignment = NSTextAlignmentRight;
    self.buyLabel.font = Font_15;
    self.buyLabel.textColor = COLOR_Text_Black;
    [self.selectView addSubview:self.buyLabel];
    
    
    
}


#pragma mark vip的设置
-(void)vipSettingWithRow:(NSInteger)row withModel:(TQPurchaseModel *)model{

    
    if ([model.isopen isEqualToString:@"1"]) {//已经购买当前的VIP
        self.vipNameLab.textColor = COLOR_Auxiliary_Blue;
        self.clickBtn.enabled = NO;
        self.buyLabel.hidden = YES;
        [self.clickBtn setTitle:@"已兑换" forState:UIControlStateDisabled];
        self.clickBtn.backgroundColor = [UIColor clearColor];
        [self.clickBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@(-10));
            make.bottom.equalTo(@0);
            make.width.equalTo(@(clickBtn_W*0.75));
        }];
        self.priceLabView.oldpriceStr = [NSString stringWithFormat:@"%@%@",model.buyprice,model.vipLevelExpirtiontime];
        self.priceLabView.state = PriceLabViewType_Vip;
        
    }else{
        self.buyLabel.hidden = NO;
        self.vipNameLab.textColor = COLOR_Auxiliary_Orange;
        self.clickBtn.enabled = YES;
        [self.clickBtn setTitle:@"升级" forState:UIControlStateNormal];
        self.clickBtn.backgroundColor = COLOR_Btn_Buy_Normal;
        
        [self.clickBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(@(clickBtn_W));
        }];
        
        self.buyLabel.text = [NSString stringWithFormat:@"限%@个名额",model.maxnum];
        CGSize buyLabelSize = [ShareFunction calculationOfTheText:self.buyLabel.text withFont:15 withMaxSize:(CGSize){200,CGFLOAT_MAX}];
        [self.buyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(self.clickBtn.mas_left).offset(-5);
            make.bottom.equalTo(@0);
            make.width.equalTo(@(buyLabelSize.width+10));
        }];

        self.priceLabView.oldpriceStr = [NSString stringWithFormat:@"%@%@",model.buyprice,model.vipLevelExpirtiontime];
        self.priceLabView.newpriceStr = [NSString stringWithFormat:@"%@%@",model.updateprice,model.vipLevelExpirtiontime];

        self.priceLabView.state = PriceLabViewType_NotVip;
        model.actualPrice = model.updateprice;

    }

}

#pragma mark 不是vip的设置
-(void)notVipSettingWithRow:(NSInteger)row withModel:(TQPurchaseModel *)model{
    
    
    self.vipNameLab.textColor = COLOR_Auxiliary_Orange;
    [self.clickBtn setTitle:@"兑换" forState:UIControlStateNormal];
    self.clickBtn.backgroundColor = COLOR_Btn_Buy_Normal;
    
    [self.clickBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(clickBtn_W));
    }];
    
    
    self.buyLabel.text = [NSString stringWithFormat:@"限%@个名额",model.maxnum];
    CGSize buyLabelSize = [ShareFunction calculationOfTheText:self.buyLabel.text withFont:15 withMaxSize:(CGSize){200,CGFLOAT_MAX}];
    [self.buyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(self.clickBtn.mas_left).offset(-5);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(buyLabelSize.width+10));
    }];
    
    self.priceLabView.oldpriceStr = [NSString stringWithFormat:@"%@%@",model.buyprice,model.vipLevelExpirtiontime];
    self.priceLabView.state = PriceLabViewType_Vip;
    model.actualPrice = model.buyprice;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)clickBtnAction:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(tableViewCellWithClickButton:row:)]) {
        [self.delegate tableViewCellWithClickButton:btn row:_row];
    }
}

-(void)setCellDataWithModel:(TQPurchaseModel *)model withIndexRow:(NSInteger)row{

    //设置VIP的图标
    self.vipIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"customized_vip%d_icon",[model.levelid intValue]]];
    self.vipNameLab.text = model.levelname;
        
    BOOL isVipValue = [model.vipValue isEqualToString:@"0"] ? NO : YES;
    
    self.introduceLab.text = model.descriptionStr;
    if (isVipValue) {
        
        [self vipSettingWithRow:row withModel:model];
    }else{
        [self notVipSettingWithRow:row withModel:model];
    }
}


@end
