//
//  BaseCell.m
//  99SVR
//
//  Created by 刘海东 on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //隐藏分割线
        self.bakImageView = [[UIImageView alloc]init];
        self.bakImageView.userInteractionEnabled = YES;
        self.bakImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bakImageView];
        [self.bakImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(@0);
            make.height.equalTo(@(LineView_Height));
        }];
        
        [self initUI];
        [self setAutoLayout];
        
    }
    return self;
}

-(void)initUI{
    
    
}

-(void)setAutoLayout{

}



@end
