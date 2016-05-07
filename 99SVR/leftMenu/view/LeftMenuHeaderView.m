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

#define kImageWidth 85
#define kCircle 95

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

@property (nonatomic,strong) UIView *loginView;
@property (nonatomic,strong) UIView *unLoginView;

@end

@implementation LeftMenuHeaderView

- (UIView *)loginView
{
    if (_loginView==nil)
    {
        _loginView = [[UIView alloc] initWithFrame:Rect(0, _circleLine.y+_circleLine.height+10,kScreenWidth,40)];
        UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 20)];
        [lblName setFont:XCFONT(15)];
        [_loginView addSubview:lblName];
        [lblName setTextColor:UIColorFromRGB(0xffffff)];
        lblName.tag = 1;
        [lblName setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *lblUserId = [[UILabel alloc] initWithFrame:Rect(0, 20, kScreenWidth, 20)];
        [_loginView addSubview:lblUserId];
        [lblUserId setFont:XCFONT(13)];
        [lblUserId setTextColor:UIColorFromRGB(0xffffff)];
        lblUserId.tag = 2;
        [lblUserId setTextAlignment:NSTextAlignmentCenter];
    }
    return _loginView;
}

- (UIView *)unLoginView
{
    if (_unLoginView==nil) {
        _unLoginView = [[UIView alloc] initWithFrame:Rect(0, _circleLine.y+_circleLine.height+10,kScreenWidth,40)];
        UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLogin.frame = Rect(kScreenWidth/2-80, 5, 70, 35);
        [_unLoginView addSubview:btnLogin];
        btnLogin.titleLabel.font = XCFONT(15);
        [btnLogin setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        btnLogin.tag = 2;
        [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        
        UILabel *line = [[UILabel alloc] initWithFrame:Rect(kScreenWidth/2-0.25, 10, 0.5, 20)];
        [_unLoginView addSubview:line];
        [line setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
        
        UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        btnRight.frame = Rect(kScreenWidth/2+10, 5, 70, 35);
        [_unLoginView addSubview:btnRight];
        btnRight.titleLabel.font = XCFONT(15);
        [btnRight setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        btnRight.tag = 2;
        [btnRight setTitle:@"注册" forState:UIControlStateNormal];
        
        [btnLogin addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
        [btnRight addTarget:self action:@selector(regEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unLoginView;
}

- (void)loginEvent
{
    if (_delegate && [_delegate respondsToSelector:@selector(enterLogin)]) {
        [_delegate enterLogin];
    }
}

- (void)regEvent
{
    if (_delegate && [_delegate respondsToSelector:@selector(enterRegister)]) {
        [_delegate enterRegister];
    }
}


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
        _circleLine.layer.borderWidth = 1;
        _circleLine.layer.borderColor = UIColorFromRGB(0xcfcfcf).CGColor;
        [self addSubview:_circleLine];
        
        _circleLine.frame = Rect(self.width/2-kCircle/2, 10, kCircle, kCircle);
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = kImageWidth / 2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"personal_user_head"];
        [_circleLine addSubview:_avatarImageView];
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginDelegate)]];
        _avatarImageView.frame = Rect(6, 6, _circleLine.width-12, _circleLine.height-12);
        
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
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    if (login && userInfo.nType == 1)
    {
        self.unLoginView.hidden = YES;
        [self addSubview:self.loginView];
        self.loginView.hidden = NO;
        UILabel *lblName = (UILabel *)[_loginView viewWithTag:1];
        UILabel *lblUserId = (UILabel *)[_loginView viewWithTag:2];
        NSString *strInfo = [[NSString alloc] initWithFormat:@"ID:%d",userInfo.nUserId];
        [lblName setText:userInfo.strName];
        [lblUserId setText:strInfo];
    }
    else
    {
        self.loginView.hidden = YES;
        [self addSubview:self.unLoginView];
        self.unLoginView.hidden = NO;
    }
}

@end
