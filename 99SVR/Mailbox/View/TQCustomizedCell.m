//
//  TQCustomizedCell.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQCustomizedCell.h"
#import "Masonry.h"
@interface TQCustomizedCell()
/** 图标 */
@property (nonatomic ,weak)UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *TItileLabel;
/* 正文*/
//@property (nonatomic, weak) UILabel *introLabel;

/** 红色图标 */
@property (nonatomic ,weak)UIView *redIconView;
/** 时间 */
@property (nonatomic ,weak)UILabel *timeLabel;

@end

@implementation TQCustomizedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子控件
        [self initChildView];
    }
    return self;
}
-(void)initChildView {
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    iconView.backgroundColor = [UIColor redColor];
    self.iconView = iconView;
    
    UILabel *TItileLabel = [[UILabel alloc] init];
    [self.contentView addSubview:TItileLabel];
    TItileLabel.text = @"私人定制";
    TItileLabel.textAlignment = NSTextAlignmentCenter;
    TItileLabel.font = [UIFont boldSystemFontOfSize:22];
    TItileLabel.backgroundColor = [UIColor redColor];
    self.TItileLabel = TItileLabel;

//    UILabel *introLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:introLabel];
//    self.introLabel = introLabel;
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    timeLabel.backgroundColor = [UIColor redColor];

    UIView *redIconView = [[UIView alloc] init];
    [self.contentView addSubview:redIconView];
    self.redIconView = redIconView;
    redIconView.backgroundColor = [UIColor redColor];

    //设置子空件约束
    [self setUpChildViewLayout];
}

-(void)setUpChildViewLayout{
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.offset(80);
        make.height.offset(80);
    }];
    
    [self.TItileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).offset(0);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.width.offset(80);
        make.height.offset(40);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(-30);
        make.width.offset(50);
        make.height.offset(30);
    }];

    [self.redIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.TItileLabel.mas_right).offset(10);
        make.width.offset(30);
        make.height.offset(30);
    }];

}

-(void)setFrame:(CGRect)frame {
    
    frame.size.height -= 30;
    
    [super setFrame:frame];

}






@end
