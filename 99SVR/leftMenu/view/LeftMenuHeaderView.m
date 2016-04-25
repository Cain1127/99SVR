//
//  LeftMenuHeaderView.m
//  99SVR
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "LeftMenuHeaderView.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"

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
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imgView];
        char cBuffer[100]={0};
        sprintf(cBuffer,"video_profiles_bg@2x");
        NSString *strName = [NSString stringWithUTF8String:cBuffer];
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
        [imgView sd_setImageWithURL:url1];
        
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
        
        _lineView = [UILabel new];
        _lineView.backgroundColor = UIColorFromRGB(0x6EACE0);
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
    }
    else
    {
        UserInfo *userInfo = [UserInfo sharedUserInfo];
        _vipLevel.text = NSStringFromInt(userInfo.nUserId);
        if (userInfo.nType == 1)
        {
            NSString *strInfo = [[NSString alloc] initWithFormat:@"%@ ID:%d",userInfo.strName,userInfo.nUserId];
            _nameLabel.text = strInfo;
        }
        else
        {
            _nameLabel.text = @"";
        }
    }
}

- (void)layoutViews
{
    _circleLine.frame = Rect(self.width/2-kCircle/2, 40, kCircle, kCircle);
    _avatarImageView.frame = Rect(6, 6, _circleLine.width-12, _circleLine.height-12);
    _nameLabel.frame = Rect(30,self.height-25, self.width-60, 20);
}

@end
