//
//  LeftHeaderView.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/18.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "LeftHeaderView.h"
#import "UserInfo.h"

#define kImageWidth 84
#define kCircle (kImageWidth + 6)

@interface LeftHeaderView()
{
    UIView *_circleLine;
    UIImageView *_avatarImageView; // 头像
    UILabel *_nameLabel; // 名称
    UIButton *_vipLevel; // vip等级
    UIView *_lineView;
}

@end

@implementation LeftHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _circleLine = [UIView new];
        _circleLine.backgroundColor = RGB(59, 97, 166);
        _circleLine.layer.masksToBounds = YES;
        _circleLine.layer.cornerRadius = (kCircle) / 2;
        _circleLine.layer.borderColor = [RGBA(255, 255, 255, 0.13) CGColor];
        _circleLine.layer.borderWidth = 1.5;
        [self addSubview:_circleLine];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = kImageWidth / 2;
        _avatarImageView.layer.masksToBounds = YES;
//        _avatarImageView.layer.borderColor = [[UIColor clearColor] CGColor];
//        _avatarImageView.layer.borderWidth = 0;
        _avatarImageView.image = [UIImage imageNamed:@"logo"];
        [_circleLine addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = kFontSize(24);
        _nameLabel.text = @"天天开心";
        [self addSubview:_nameLabel];

        _vipLevel = [UIButton buttonWithType:UIButtonTypeCustom];
        _vipLevel.titleLabel.textColor = [UIColor whiteColor];
        _vipLevel.titleLabel.font = kFontSize(10);
        [self addSubview:_vipLevel];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = RGBA(255, 255, 255, 0.43);
        [self addSubview:_lineView];
        [self layoutViews];
    }
    return self;
}

- (void)setLogin:(BOOL)login
{
    _login = login;
    if (!login)
    {
        _nameLabel.text = @"99度财经";
        [_vipLevel setTitle:@"未登录" forState:UIControlStateNormal];
    }
    else
    {
        UserInfo *userInfo = [UserInfo sharedUserInfo];
        _nameLabel.text = NSStringFromInt(userInfo.nUserId);
        [_vipLevel setTitle:[userInfo getVipDescript] forState:UIControlStateNormal];
    }
}

- (void)layoutViews
{
    CGFloat offsetValue = -23;
    
    [_circleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kCircle, kCircle));
        make.top.equalTo(self).offset(1);
        make.centerX.equalTo(self).offset(offsetValue);
    }];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kImageWidth, kImageWidth));
        make.center.equalTo(_circleLine);
//        make.top.equalTo(self).offset(1);
//        make.centerX.equalTo(self).offset(offsetValue);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_avatarImageView.mas_bottom).offset(19);
        make.centerX.equalTo(self).offset(offsetValue);
    }];
    
    [_vipLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self).offset(offsetValue);
    }];
    CGFloat space = 8;
    CGFloat rightSpace = 75;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.width - space - rightSpace, 1));
        make.left.equalTo(self).offset(space);
        make.right.equalTo(self).offset(-rightSpace);
        make.bottom.equalTo(self);
    }];
}

@end
