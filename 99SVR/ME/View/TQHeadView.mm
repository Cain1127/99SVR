//
//  HeadView.m
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

#import "TQHeadView.h"

@implementation TQHeadView

+(instancetype)headView
{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TQHeadView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    
    self.IconImageView.layer.cornerRadius = 40;
    self.IconImageView.layer.masksToBounds = YES;
    self.nameLab.textColor = COLOR_Text_Black;
    self.timeLab.textColor = COLOR_Text_Black;
    self.attentionLab.textColor = COLOR_Auxiliary_Red;
}

-(void)setHeaderViewWithModel:(TQPurchaseModel *)model{

    [self.IconImageView sd_setImageWithURL:[NSURL URLWithString:model.teamIcon] placeholderImage:[UIImage imageNamed:@"default"]];
    self.timeLab.text = [NSString stringWithFormat:@"有效日期：%@",model.expirtiontime];
    self.nameLab.text = [NSString stringWithFormat:@"团队名称：%@",model.teamName];
}

@end
