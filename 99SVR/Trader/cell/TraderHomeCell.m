

#define name_fot ValueWithTheIPhoneModelString(@"17,18,20") //名称大小
#define traderName_fot ValueWithTheIPhoneModelString(@"25,28,30") //操盘的名称大小
#define targetLab_fot ValueWithTheIPhoneModelString(@"17,18,20") //目标收益大小
#define totalNumLab_fot ValueWithTheIPhoneModelString(@"30,35,40") //总收益数额大小
#define totalTitLab_fot ValueWithTheIPhoneModelString(@"17,18,20") //总收益文字大小


#import "MacroHeader.h"
#import "TraderHomeCell.h"

@implementation TraderHomeCell


-(void)initUI{

    
    self.iconImv = [[UIImageView alloc]init];
    [self.bakImageView addSubview:self.iconImv];
    
    self.nameLab = [[UILabel alloc]init];
    self.nameLab.font = [UIFont systemFontOfSize:name_fot];
    [self.bakImageView addSubview:self.nameLab];
    

    self.traderNameLab = [[UILabel alloc]init];
    self.traderNameLab.font = [UIFont systemFontOfSize:traderName_fot];
    [self.bakImageView addSubview:self.traderNameLab];
    

    self.targetLab = [[UILabel alloc]init];
    self.targetLab.font = [UIFont systemFontOfSize:targetLab_fot];
    [self.bakImageView addSubview:self.targetLab];
    

    self.totalNumLab = [[UILabel alloc]init];
    self.totalNumLab.font = [UIFont systemFontOfSize:totalNumLab_fot];
    [self.bakImageView addSubview:self.totalNumLab];
    
    self.totalTitLab = [[UILabel alloc]init];
    self.totalTitLab.font = [UIFont systemFontOfSize:totalTitLab_fot];
    [self.bakImageView addSubview:self.totalTitLab];

    
    
    self.iconImv.backgroundColor = [UIColor grayColor];
    self.nameLab.backgroundColor = [UIColor grayColor];
    self.traderNameLab.backgroundColor = [UIColor grayColor];
    self.targetLab.backgroundColor = [UIColor grayColor];
    self.totalNumLab.backgroundColor = [UIColor grayColor];
    self.totalTitLab.backgroundColor = [UIColor grayColor];


    
}

-(void)setAutoLayout{
    
    [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(5));
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@(-5));
    }];
    
    //头像
    [self.iconImv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(ValueWithTheIPhoneModelString(@"10,10,10")));
        make.left.equalTo(@(ValueWithTheIPhoneModelString(@"10,10,10")));
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"40,45,50")));
        make.height.equalTo(@(ValueWithTheIPhoneModelString(@"40,45,50")));
    }];
    
    //名字
    [self.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImv.mas_right).offset((ValueWithTheIPhoneModelString(@"10,10,10")));
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10")));
        make.height.equalTo(@(name_fot));
        make.centerY.equalTo(self.iconImv.mas_centerY).offset(0);
    }];

    //操盘名称
    [self.traderNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImv.mas_bottom).offset((ValueWithTheIPhoneModelString(@"15,15,15")));
        make.left.equalTo(self.iconImv.mas_left);
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"150,200,150")));
        make.height.equalTo(@(traderName_fot));
    }];
    
    //目标收益
    [self.targetLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.traderNameLab.mas_bottom).offset((ValueWithTheIPhoneModelString(@"15,15,15")));
        make.left.equalTo(self.iconImv.mas_left);
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"200,220,250")));
        make.height.equalTo(@(targetLab_fot));
    }];
    
    //总收益文字
    [self.totalTitLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.targetLab.mas_bottom).offset(0);
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10")));
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"60,80,100")));
        make.height.equalTo(@(totalTitLab_fot));
    }];

    //总收益数字
    [self.totalNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.totalTitLab.mas_top).offset(-10);
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10")));
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"80,100,150")));
        make.height.equalTo(@(totalNumLab_fot));
    }];
    
}


@end
