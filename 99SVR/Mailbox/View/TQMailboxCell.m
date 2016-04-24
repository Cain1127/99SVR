//
//  TQMailboxCell.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQMailboxCell.h"
@interface TQMailboxCell ()

/** 图标 */
@property (nonatomic ,weak)UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *TItileLabel;
/* 正文*/
@property (nonatomic, weak) UILabel *introLabel;

/** 时间 */
@property (nonatomic ,weak)UILabel *timeLabel;



@end
@implementation TQMailboxCell

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
    self.TItileLabel = TItileLabel;
    TItileLabel.text = @"系统消息";
    TItileLabel.textAlignment = NSTextAlignmentCenter;
    TItileLabel.font = [UIFont boldSystemFontOfSize:25];
    TItileLabel.backgroundColor = [UIColor redColor];
    
    UILabel *introLabel = [[UILabel alloc] init];
    [self.contentView addSubview:introLabel];
    self.introLabel = introLabel;
    introLabel.backgroundColor = [UIColor greenColor];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    timeLabel.backgroundColor = [UIColor redColor];
    
    //设置子空件约束
    [self setUpChildViewLayout];
}

-(void)setUpChildViewLayout{
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.offset(70);
        make.height.offset(70);
    }];
    
    [self.TItileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).offset(0);
        make.left.equalTo(self.iconView.mas_right).offset(20);
        make.width.offset(100);
        make.height.offset(30);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(-30);
        make.width.offset(50);
        make.height.offset(25);
    }];
    
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TItileLabel.mas_bottom).offset(10);
        make.left.equalTo(self.iconView.mas_right).offset(20);
        make.right.equalTo(self.mas_right).offset(-30);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame {
    
    frame.size.height -= 30;
    
    [super setFrame:frame];
    
}


@end
