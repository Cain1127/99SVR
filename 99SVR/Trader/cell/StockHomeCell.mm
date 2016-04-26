

#define name_fot ValueWithTheIPhoneModelString(@"17,17,17,17") //名称大小
#define traderName_h ValueWithTheIPhoneModelString(@"20,20,20,20") //操盘的名称大小
#define traderName_fot ValueWithTheIPhoneModelString(@"15,15,15,15") //操盘的大小
#define targetLab_fot ValueWithTheIPhoneModelString(@"15,15,15,15") //目标收益大小
#define totalNumLab_fot ValueWithTheIPhoneModelString(@"25,30,30,30") //总收益数额大小
#define totalTitLab_fot ValueWithTheIPhoneModelString(@"15,15,15,15") //总收益文字大小
#define icon_w (STORCK_HOME_StockRecordCell_H-30-10) //头像的大小

#import "StockMacro.h"
#import "StockHomeCell.h"
#import "ShareFunction.h"

@implementation StockHomeCell


-(void)initUI{

    self.iconImv = [[UIImageView alloc]init];
    self.iconImv.layer.cornerRadius = icon_w/2.0;
    self.iconImv.layer.masksToBounds = YES;
    self.iconImv.contentMode = UIViewContentModeScaleAspectFill;
    [self.bakImageView addSubview:self.iconImv];
    
    self.nameLab = [[UILabel alloc]init];
    self.nameLab.font = [UIFont systemFontOfSize:name_fot];
    [self.bakImageView addSubview:self.nameLab];
    

    self.traderNameLab = [[UILabel alloc]init];
    self.traderNameLab.backgroundColor = UIColorFromRGB(0xf8b551);
    self.traderNameLab.layer.cornerRadius = 3.0f;
    self.traderNameLab.layer.masksToBounds = YES;
    self.traderNameLab.textAlignment = NSTextAlignmentCenter;
    self.traderNameLab.textColor = [UIColor whiteColor];
    self.traderNameLab.font = [UIFont systemFontOfSize:traderName_fot];
    [self.bakImageView addSubview:self.traderNameLab];
    

    self.targetLab = [[UILabel alloc]init];
    self.targetLab.font = [UIFont systemFontOfSize:targetLab_fot];
    self.targetLab.textColor = COLOR_STOCK_Text_Gay;
    [self.bakImageView addSubview:self.targetLab];
    

    self.totalNumLab = [[UILabel alloc]init];
    self.totalNumLab.textAlignment = NSTextAlignmentRight;
    self.totalNumLab.font = [UIFont systemFontOfSize:totalNumLab_fot];
    self.totalNumLab.textColor = UIColorFromRGB(0xf8b551);
    [self.bakImageView addSubview:self.totalNumLab];
    
    self.totalTitLab = [[UILabel alloc]init];
    self.totalTitLab.textAlignment = NSTextAlignmentRight;
    self.totalTitLab.font = [UIFont systemFontOfSize:totalTitLab_fot];
    self.totalTitLab.textColor = COLOR_STOCK_Text_Gay;
    [self.bakImageView addSubview:self.totalTitLab];
}

-(void)setAutoLayout{
    
    self.lineView.hidden = YES;
    [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
    }];
    
    self.bakImageView.layer.borderWidth = 1.0f;
    self.bakImageView.layer.borderColor = [COLOR_StyleLines colorWithAlphaComponent:0.5].CGColor;
    [self.bakImageView layoutIfNeeded];
    
    //头像
    [self.iconImv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(ValueWithTheIPhoneModelString(@"15,15,15,15")));
        make.left.equalTo(@(ValueWithTheIPhoneModelString(@"10,10,10,10")));
        make.height.equalTo(@(icon_w));
        make.width.equalTo(@(icon_w));
    }];
    
    //名字
    [self.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImv.mas_right).offset((ValueWithTheIPhoneModelString(@"10,10,10,10")));
        make.right.equalTo(self.totalNumLab.mas_left).offset(-10);
        make.height.equalTo(@(name_fot));
        make.top.equalTo(self.iconImv.mas_top);
    }];
    
    //目标收益
    [self.targetLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_left);
        make.height.equalTo(@(targetLab_fot));
        make.right.equalTo(self.totalTitLab.mas_left).offset(-10);
        make.bottom.equalTo(self.iconImv.mas_bottom);
    }];
    
    //总收益文字
    [self.totalTitLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.targetLab.mas_bottom).offset(0);
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"60,60,60,60")));
        make.height.equalTo(@(totalTitLab_fot));
    }];

    
}

-(void)setCellDataWithModel:(StockDealModel *)model{

    //计算字体
    NSString *str =  model.focus;
    CGSize textSize = [ShareFunction calculationOfTheText:str withFont:traderName_h withMaxSize:(CGSize){150,50}];
    //操盘名称
    [self.traderNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_left);
        make.width.equalTo(@(textSize.width -4));
        make.height.equalTo(@(traderName_h));
        make.centerY.equalTo(self.iconImv.mas_centerY);
    }];
    
    //计算总收益字体
    NSString *totalNum = model.totalprofit;
    CGSize totalNumSize = [ShareFunction calculationOfTheText:totalNum withFont:totalNumLab_fot withMaxSize:(CGSize){200,50}];
    
    //总收益数字
    [self.totalNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImv.mas_top);
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
        make.width.equalTo(@(totalNumSize.width));
        make.height.equalTo(@(totalNumLab_fot));
    }];

    [self.iconImv sd_setImageWithURL:[NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/pic/item/e1fe9925bc315c6001e93f3388b1cb13485477e9.jpg"]];
    self.nameLab.text =  model.teamname;
    self.traderNameLab.text =  model.focus;
    self.targetLab.text =  [NSString stringWithFormat:@"目标收益：%@",model.goalprofit];
    self.totalNumLab.text =  model.totalprofit;
    self.totalTitLab.text = @"总收益";
}


@end
