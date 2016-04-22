

#define name_fot ValueWithTheIPhoneModelString(@"15,17,18,20") //名称大小
#define traderName_h ValueWithTheIPhoneModelString(@"15,17,18,20") //操盘的名称大小
#define traderName_fot ValueWithTheIPhoneModelString(@"11,12,14,16") //操盘的大小
#define targetLab_fot ValueWithTheIPhoneModelString(@"15,15,17,18") //目标收益大小
#define totalNumLab_fot ValueWithTheIPhoneModelString(@"25,30,35,40") //总收益数额大小
#define totalTitLab_fot ValueWithTheIPhoneModelString(@"25,17,18,20") //总收益文字大小
#define icon_w (ValueWithTheIPhoneModelString(@"100,120,140,160")-30-10) //头像的大小

#import "StockMacro.h"
#import "StockHomeCell.h"
#import "ShareFunction.h"

@implementation StockHomeCell


-(void)initUI{


    self.iconImv = [[UIImageView alloc]init];
    self.iconImv.layer.cornerRadius = icon_w/2.0;
    self.iconImv.layer.masksToBounds = YES;
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
    [self.bakImageView addSubview:self.targetLab];
    

    self.totalNumLab = [[UILabel alloc]init];
    self.totalNumLab.textAlignment = NSTextAlignmentRight;
    self.totalNumLab.font = [UIFont systemFontOfSize:totalNumLab_fot];
    [self.bakImageView addSubview:self.totalNumLab];
    
    self.totalTitLab = [[UILabel alloc]init];
    self.totalTitLab.textAlignment = NSTextAlignmentRight;
    self.totalTitLab.font = [UIFont systemFontOfSize:totalTitLab_fot];
    [self.bakImageView addSubview:self.totalTitLab];

    
    
    
    self.iconImv.backgroundColor = [UIColor grayColor];
    self.nameLab.backgroundColor = [UIColor grayColor];
    self.targetLab.backgroundColor = [UIColor grayColor];
    self.totalNumLab.backgroundColor = [UIColor grayColor];
    self.totalTitLab.backgroundColor = [UIColor grayColor];

        self.nameLab.text =  @"追击涨停";
        self.traderNameLab.text =  @"专注断线";
        self.targetLab.text =  @"目标收益：8%";
        self.totalNumLab.text =  @"13.88%";
        self.totalTitLab.text = @"总收益";
}

-(void)setAutoLayout{
    
    [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(5));
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
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

    //计算字体
    NSString *str = @"专注断线";
    
    CGSize textSize = [ShareFunction calculationOfTheText:str withFont:traderName_h withMaxSize:(CGSize){150,50}];
    
    //操盘名称
    [self.traderNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_left);
        make.width.equalTo(@(textSize.width - 6));
        make.height.equalTo(@(traderName_h));
        make.centerY.equalTo(self.iconImv.mas_centerY);
    }];
    
    //目标收益
    [self.targetLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_left);
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"100,100,100,100")));
        make.height.equalTo(@(targetLab_fot));
        make.bottom.equalTo(self.iconImv.mas_bottom);
    }];
    
    //总收益文字
    [self.totalTitLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.targetLab.mas_bottom).offset(0);
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"40,60,80,100")));
        make.height.equalTo(@(totalTitLab_fot));
    }];

    //总收益数字
    [self.totalNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImv.mas_top);
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"80,80,80,80")));
        make.height.equalTo(@(totalNumLab_fot));
    }];
    
}


@end
