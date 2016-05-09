

#define name_fot ValueWithTheIPhoneModelString(@"17,17,17,17") //名称大小
#define traderName_h ValueWithTheIPhoneModelString(@"20,20,20,20") //操盘的名称大小
#define traderName_fot ValueWithTheIPhoneModelString(@"15,15,15,15") //操盘的大小
#define targetLab_fot ValueWithTheIPhoneModelString(@"15,15,15,15") //目标收益大小
#define totalNumLab_fot ValueWithTheIPhoneModelString(@"25,30,30,30") //总收益数额大小
#define totalTitLab_fot ValueWithTheIPhoneModelString(@"15,15,15,15") //总收益文字大小
#define icon_w (STORCK_HOME_StockRecordCell_H-30-10) //头像的大小
#define totalJianGe_h ValueWithTheIPhoneModelString(@"15,15,15,15") //总收益文字和总收益数字的间隔


#import "StockMacro.h"
#import "StockHomeCell.h"
#import "ShareFunction.h"
#import "StockDealModel.h"
#import "ZLOperateStock.h"

@implementation StockHomeCell


-(void)initUI{

    self.iconImv = [[UIImageView alloc]init];
    self.iconImv.layer.cornerRadius = icon_w/2.0;
    self.iconImv.layer.masksToBounds = YES;
    self.iconImv.contentMode = UIViewContentModeScaleAspectFill;
    [self.bakImageView addSubview:self.iconImv];
    
    self.nameLab = [[UILabel alloc]init];
    self.nameLab.font = [UIFont systemFontOfSize:name_fot];
    self.nameLab.textColor = COLOR_Text_Black;
    [self.bakImageView addSubview:self.nameLab];
    

    self.traderNameLab = [[UILabel alloc]init];
    self.traderNameLab.textAlignment = NSTextAlignmentLeft;
    self.traderNameLab.textColor = COLOR_Text_B2B2B2;
    self.traderNameLab.font = [UIFont systemFontOfSize:traderName_fot];
    [self.bakImageView addSubview:self.traderNameLab];
    

    self.targetLab = [[UILabel alloc]init];
    self.targetLab.font = [UIFont systemFontOfSize:targetLab_fot];
    self.targetLab.textColor = COLOR_Text_B2B2B2;
    [self.bakImageView addSubview:self.targetLab];
    

    self.totalNumLab = [[UILabel alloc]init];
    self.totalNumLab.textAlignment = NSTextAlignmentRight;
    self.totalNumLab.font = [UIFont systemFontOfSize:totalNumLab_fot];
    self.totalNumLab.textColor = UIColorFromRGB(0xf8b551);
    [self.bakImageView addSubview:self.totalNumLab];
    
    self.totalTitLab = [[UILabel alloc]init];
    self.totalTitLab.textAlignment = NSTextAlignmentRight;
    self.totalTitLab.font = [UIFont systemFontOfSize:totalTitLab_fot];
    self.totalTitLab.textColor = COLOR_Text_B2B2B2;
    [self.bakImageView addSubview:self.totalTitLab];
}

-(void)setAutoLayout{
    
    //头像
    [self.iconImv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(ValueWithTheIPhoneModelString(@"15,15,15,15")));
        make.left.equalTo(@(ValueWithTheIPhoneModelString(@"10,10,10,10")));
        make.height.equalTo(@(icon_w));
        make.width.equalTo(@(icon_w));
    }];
    
    //目标收益
    [self.targetLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImv.mas_right).offset((ValueWithTheIPhoneModelString(@"10,10,10,10")));
        make.width.equalTo(@(kScreenWidth/2.0));
        make.height.equalTo(@(targetLab_fot));
        make.centerY.equalTo(self.iconImv.mas_centerY);
    }];
    
    
    //战队名字
    [self.traderNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.targetLab.mas_left);
        make.right.equalTo(@(-10));
        make.height.equalTo(@(traderName_fot));
        make.bottom.equalTo(self.iconImv.mas_bottom).offset(0);
    }];
    
}


/**tabbar高手操盘 和 首页的高手操盘的cell 1是财经直播tabbar的，2是高手操盘tabbar的*/
-(void)setCellDataWithModel:(StockDealModel *)model withTabBarInteger:(NSInteger)integer{

    
    CGFloat totalNum_top_h  = 0.0;
    
    if (integer==1) {//财经直播tabbar
        
        totalNum_top_h  = ((110  - (totalNumLab_fot) - (totalJianGe_h) - (totalTitLab_fot))/2.0);//总收益数字距离顶部的距离，cell的高度 - 总收益数字 - 总收益文字 -数字和文字的间隔
        
        self.lineView.hidden = YES;
        [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
        }];
        
        self.bakImageView.layer.borderWidth = 0.5f;
        self.bakImageView.layer.borderColor = [COLOR_Line_Big_Gay colorWithAlphaComponent:0.5].CGColor;
        
    }else{//高手操盘tabbar
        
        totalNum_top_h  = ((STORCK_HOME_StockRecordCell_H -10 - (totalNumLab_fot) - (totalJianGe_h) - (totalTitLab_fot))/2.0);//总收益数字距离顶部的距离，cell的高度 -blackView距离顶部的像素10  - 总收益数字 - 总收益文字 -数字和文字的间隔
        
        self.lineView.hidden = YES;
        [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
        }];
        
        self.bakImageView.layer.borderWidth = LineView_Height;
        self.bakImageView.layer.borderColor = [COLOR_Line_Big_Gay colorWithAlphaComponent:0.5].CGColor;

        
    }
    
    //计算总收益字体
    self.totalNumLab.text =  model.totalprofit;
    CGSize totalNumLabSize = [ShareFunction calculationOfTheText:self.totalNumLab.text withFont:totalNumLab_fot withMaxSize:(CGSize){200,CGFLOAT_MAX}];

    //总收益数字
    [self.totalNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(totalNum_top_h));
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
        make.width.equalTo(@(totalNumLabSize.width + 10));
        make.height.equalTo(@(totalNumLab_fot));
    }];

    //操盘名字
    [self.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.targetLab.mas_left);
        make.right.equalTo(self.totalNumLab.mas_left).offset(-10);
        make.height.equalTo(@(name_fot));
        make.top.equalTo(self.iconImv.mas_top);
    }];

    //总收益文字
    [self.totalTitLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"60,60,60,60")));
        make.height.equalTo(@(totalTitLab_fot));
        make.top.equalTo(self.totalNumLab.mas_bottom).offset(totalJianGe_h);
    }];

    
    [self.iconImv sd_setImageWithURL:[NSURL URLWithString:model.teamicon]];
    self.nameLab.text =  model.focus;
    self.targetLab.text =  [NSString stringWithFormat:@"目标收益：%@",model.goalprofit];
    self.totalTitLab.text = @"总收益";
    self.traderNameLab.text = model.teamname;
}

/**房间内高手操盘*/
- (void)setXTraderVCcellStockModel:(StockDealModel *)model
{

    self.traderNameLab.hidden = YES;
    self.iconImv.hidden = YES;
    
    
    
    CGFloat totalNum_top_h  = 0.0;
    totalNum_top_h  = ((STORCK_HOME_StockRecordCell_H -10 - (totalNumLab_fot) - (totalJianGe_h) - (totalTitLab_fot))/2.0);//总收益数字距离顶部的距离，cell的高度 -blackView距离顶部的像素10  - 总收益数字 - 总收益文字 -数字和文字的间隔
        
    self.lineView.hidden = YES;
    [self.bakImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
    }];
        
    self.bakImageView.layer.borderWidth = LineView_Height;
    self.bakImageView.layer.borderColor = [COLOR_Line_Big_Gay colorWithAlphaComponent:0.5].CGColor;
        
    
    //计算总收益字体
    self.totalNumLab.text =  model.totalprofit;
    CGSize totalNumLabSize = [ShareFunction calculationOfTheText:self.totalNumLab.text withFont:totalNumLab_fot withMaxSize:(CGSize){200,CGFLOAT_MAX}];
    
    //总收益数字
    [self.totalNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(totalNum_top_h));
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
        make.width.equalTo(@(totalNumLabSize.width + 10));
        make.height.equalTo(@(totalNumLab_fot));
    }];
    
    //总收益文字
    [self.totalTitLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"60,60,60,60")));
        make.height.equalTo(@(totalTitLab_fot));
        make.top.equalTo(self.totalNumLab.mas_bottom).offset(totalJianGe_h);
    }];

    
    CGFloat totalName_top_h  = 0.0;
    totalName_top_h  = ((STORCK_HOME_StockRecordCell_H -10 - (name_fot) - (15) - (targetLab_fot))/2.0);//总收益数字距离顶部的距离，cell的高度 -blackView距离顶部的像素10  - 操盘的名字 - 操盘的名字和收益文字的间隔 -收益的文字高度
    
    
    //操盘名字
    [self.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(ValueWithTheIPhoneModelString(@"10,10,10,10")));
        make.right.equalTo(self.totalNumLab.mas_left).offset(-10);
        make.height.equalTo(@(name_fot));
        make.top.equalTo(@(totalName_top_h));
    }];
    
    //目标收益文字
    [self.targetLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_left);
        make.height.equalTo(@(targetLab_fot));
        make.top.equalTo(self.nameLab.mas_bottom).offset(totalJianGe_h);
        make.right.equalTo(self.nameLab.mas_right);
    }];
    
    
    self.nameLab.text =  model.focus;
    self.targetLab.text =  [NSString stringWithFormat:@"目标收益：%@",model.goalprofit];
    self.totalTitLab.text = @"总收益";
    self.traderNameLab.text = model.teamname;


}

@end
