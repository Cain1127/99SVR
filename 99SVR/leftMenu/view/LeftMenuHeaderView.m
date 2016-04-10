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
    UILabel *_vipLevel; // vip等级
    UILabel *_lineView;
    UIImageView *imageB;
    UILabel *lblBContent;
}

@end

@implementation LeftMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:UIColorFromRGB(0x006dc9)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(frame.size.width/2-kScreenWidth/2, 21, kScreenWidth,88)];
        [self addSubview:imgView];
        [imgView setImage:[UIImage imageNamed:@"left_bg"]];
        
        _circleLine = [UIView new];
        _circleLine.layer.masksToBounds = YES;
        _circleLine.layer.cornerRadius = (kCircle) / 2;
        _circleLine.layer.borderWidth = 0.5;
        _circleLine.layer.borderColor = UIColorFromRGB(0x2180d0).CGColor;
        [self addSubview:_circleLine];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = kImageWidth / 2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"personal_user_head"];
        [_circleLine addSubview:_avatarImageView];
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginDelegate)]];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = kFontSize(15);
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
        
        _vipLevel = [UILabel new];
        _vipLevel.textColor = UIColorFromRGB(0xffffff);
        _vipLevel.font = XCFONT(12);
        [self addSubview:_vipLevel];
        [_vipLevel setTextAlignment:NSTextAlignmentCenter];
        
        _lineView = [UILabel new];
        _lineView.backgroundColor = UIColorFromRGB(0x6EACE0);
        [self addSubview:_lineView];
        
        imageB = [[UIImageView alloc] initWithFrame:Rect(50, 0,18,18)];
        [imageB setImage:[UIImage imageNamed:@"personal_recharge_icon"]];
        [self addSubview:imageB];
        imageB.hidden = YES;
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
        [_vipLevel setText:@"未登录"];
    }
    else
    {
        UserInfo *userInfo = [UserInfo sharedUserInfo];
        _vipLevel.text = NSStringFromInt(userInfo.nUserId);
        if (userInfo.nType == 1)
        {
            _nameLabel.text = userInfo.strName;
            if (KUserSingleton.nStatus) {
                NSString *stringGoid = [NSString stringWithFormat:@"%.01f 玖玖币",userInfo.goldCoin];
                CGFloat width = [stringGoid sizeWithAttributes:@{NSFontAttributeName:XCFONT(12)}].width+10;
                [_vipLevel setText:stringGoid];
                _vipLevel.frame = Rect(kScreenWidth*0.75/2-width/2,_nameLabel.height+_nameLabel.y+5, width,20);
                imageB.frame = Rect(_vipLevel.x-24,_vipLevel.y+1, 18, 18);
                imageB.hidden = NO;
            }
        }
        else
        {
            _nameLabel.text = @"";
            [_vipLevel setText:@"未登录"];
            _vipLevel.frame = Rect(30, _nameLabel.height+_nameLabel.y+5, self.width-60, 20);
            imageB.hidden = YES;
        }
    }
}

- (void)layoutViews
{
    _circleLine.frame = Rect(self.width/2-kCircle/2, 1, kCircle, kCircle);
    _avatarImageView.frame = Rect(6, 6, _circleLine.width-12, _circleLine.height-12);
    _nameLabel.frame = Rect(30, _avatarImageView.height+_avatarImageView.y+15, self.width-60, 20);
    _vipLevel.frame = Rect(30, _nameLabel.height+_nameLabel.y+5, self.width-60, 20);
    _lineView.frame = Rect(8, self.height-1.5, self.width-16, 1);
}

@end
