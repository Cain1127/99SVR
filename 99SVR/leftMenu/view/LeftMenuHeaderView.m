//
//  LeftMenuHeaderView.m
//  99SVR
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "LeftMenuHeaderView.h"
#import "UserInfo.h"


#define kImageWidth 107
#define kCircle (kImageWidth + 12)

@interface LeftMenuHeaderView()
{
    UIView *_circleLine;
    UIImageView *_avatarImageView; // 头像
    UILabel *_nameLabel; // 名称
    UIButton *_vipLevel; // vip等级
    UILabel *_lineView;
}

@end

@implementation LeftMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(frame.size.width/2-kScreenWidth/2, 21, kScreenWidth,88)];
        [self addSubview:imgView];
        [imgView setImage:[UIImage imageNamed:@"left_bg"]];
        
        _circleLine = [UIView new];
        _circleLine.layer.masksToBounds = YES;
        _circleLine.layer.cornerRadius = (kCircle) / 2;
        _circleLine.layer.borderWidth = 0.5;
        _circleLine.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        [self addSubview:_circleLine];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = kImageWidth / 2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"logo"];
        [_circleLine addSubview:_avatarImageView];
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginDelegate)]];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = kFontSize(15);
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
        
        _vipLevel = [UIButton buttonWithType:UIButtonTypeCustom];
        _vipLevel.titleLabel.textColor = UIColorFromRGB(0xbbd0ed);
        _vipLevel.titleLabel.font = kFontSize(13);
        _vipLevel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_vipLevel];
        
        _lineView = [UILabel new];
        _lineView.backgroundColor = UIColorFromRGB(0x8EB1E2);
        [self addSubview:_lineView];
        
        [self layoutViews];
    }
    return self;
}

- (void)loginDelegate
{
    if (_delegate && [_delegate respondsToSelector:@selector(enterLogin)])
    {
        [_delegate enterLogin];
    }
}

- (void)setLogin:(BOOL)login
{
    _login = login;
    if (!login)
    {
        _nameLabel.text = @"";
        [_vipLevel setTitle:@"未登录" forState:UIControlStateNormal];
    }
    else
    {
        UserInfo *userInfo = [UserInfo sharedUserInfo];
        if (userInfo.nType == 1)
        {
            _nameLabel.text = userInfo.strName;
            [_vipLevel setTitle:NSStringFromInt(userInfo.nUserId) forState:UIControlStateNormal];
        }
        else
        {
            _nameLabel.text = @"";
            [_vipLevel setTitle:@"未登录" forState:UIControlStateNormal];
        }
    }
}

- (void)layoutViews
{
    _circleLine.frame = Rect(self.width/2-kCircle/2, 1, kCircle, kCircle);
    _avatarImageView.frame = Rect(6, 6, _circleLine.width-12, _circleLine.height-12);
    _nameLabel.frame = Rect(30, _avatarImageView.height+_avatarImageView.y+15, self.width-60, 20);
    _vipLevel.frame = Rect(30, _nameLabel.height+_nameLabel.y+5, self.width-60, 20);
    _lineView.frame = Rect(8, self.height-1.5, self.width-24, 1);
}

@end