//
//  LeftHeaderView.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/18.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "LeftHeaderView.h"
#import "UserInfo.h"

#define kImageWidth 117
#define kCircle (kImageWidth + 6)

@interface LeftHeaderView()
{
    UIView *_circleLine;
    UIImageView *_avatarImageView; // 头像
    UILabel *_nameLabel; // 名称
    UIButton *_vipLevel; // vip等级
    UILabel *_lineView;
}

@end

@implementation LeftHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(0, 21, kScreenWidth,88)];
        [self addSubview:imgView];
        [imgView setImage:[UIImage imageNamed:@"left_bg"]];
        
        _circleLine = [UIView new];
        _circleLine.layer.masksToBounds = YES;
        _circleLine.layer.cornerRadius = (kCircle) / 2;
        [self addSubview:_circleLine];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = (kImageWidth-6) / 2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"logo"];
        [_circleLine addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = kFontSize(15);
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];

        _vipLevel = [UIButton buttonWithType:UIButtonTypeCustom];
        _vipLevel.titleLabel.textColor = UIColorFromRGB(0xbbd0ed);
        _vipLevel.titleLabel.font = kFontSize(12);
        _vipLevel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_vipLevel];
        
        _lineView = [UILabel new];
        _lineView.backgroundColor = kLineColor;
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
    _circleLine.frame = Rect(self.width/2-kCircle/2, 1, kCircle, kCircle);
    _avatarImageView.frame = Rect(3, 3, _circleLine.width-6, _circleLine.height-6);
    _nameLabel.frame = Rect(30, _avatarImageView.height+_avatarImageView.y+19, self.width-60, 20);
    _vipLevel.frame = Rect(30, _nameLabel.height+_nameLabel.y+8, self.width-60, 20);
    _lineView.frame = Rect(8, self.height-1.5, self.width-24, 1);
    
}

@end
