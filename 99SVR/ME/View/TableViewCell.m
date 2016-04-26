//
//  TableViewCell.m
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
        
    self.selectView.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
    self.selectView.layer.borderWidth = 0.5f;
    self.introduceLab.textColor = COLOR_Text_919191;
    
    self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.clickBtn.titleLabel.font = Font_15;
    [self.clickBtn setTitleColor:COLOR_Text_919191 forState:UIControlStateDisabled];
    [self.selectView addSubview:self.clickBtn];
    
}


-(void)setRow:(NSInteger)row{
    
    _row = row;
    //设置VIP的图标
    self.vipIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"customized_vip%d_icon",((int)row+1)]];
#warning 默认vip3
    if (row<=3) {//vip = 4
        self.vipNameLab.textColor = COLOR_Auxiliary_Blue;
        self.clickBtn.enabled = NO;
        [self.clickBtn setTitle:@"已购买" forState:UIControlStateDisabled];
        self.clickBtn.backgroundColor = [UIColor clearColor];
        [self.clickBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@(-10));
            make.bottom.equalTo(@0);
            make.width.equalTo(@46);
        }];
        
    }else{
        self.vipNameLab.textColor = COLOR_Auxiliary_Orange;
        self.clickBtn.enabled = YES;
        [self.clickBtn setTitle:@"升级" forState:UIControlStateNormal];
        self.clickBtn.backgroundColor = COLOR_Btn_Buy_Normal;
       
        [self.clickBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(@100);
        }];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(void)clickBtnAction:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(tableViewCellWithClickButton:row:)]) {
        [self.delegate tableViewCellWithClickButton:btn row:_row];
    }
}




@end
