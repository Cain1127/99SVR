//
//  GroupHeaderView.m
//  StrechableTableView
//
//  Created by 邹宇彬 on 15/12/16.
//  Copyright © 2015年 邹宇彬. All rights reserved.
//

#import "GroupHeaderView.h"

@interface GroupHeaderView(){
    UIView *_container;
    UIImageView *_arrowImageView;
    UILabel *_titleLabel;
    UIView *_line2;
}

@end

@implementation GroupHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _container = [[UIView alloc] init];
        [self addSubview:_container];
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"arrow_close"];
        [self addSubview:_arrowImageView];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = XCFONT(16);
        _titleLabel.textColor = [UIColor colorWithHex:@"#427ede"];
        [self addSubview:_titleLabel];
        self.backgroundColor = [UIColor clearColor];
        _line2 = [UIView new];
        _line2.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line2];
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-8);
    }];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_arrowImageView.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
//    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(self.width - 16, 0.5));
//        make.left.equalTo(self).offset(8);
//        make.top.equalTo(self);
//    }];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
        make.left.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setOpen:(BOOL)open
{
    _open = open;
    if (open)
    {
        _arrowImageView.image = [UIImage imageNamed:@"arrow_open"];
    }
    else
    {
        _arrowImageView.image = [UIImage imageNamed:@"arrow_close"];
        _container.backgroundColor = [UIColor clearColor];
    }
}

@end
