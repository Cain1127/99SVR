//
//  ZLShareView.m
//  99SVR
//
//  Created by xia zhonglin  on 5/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLShareView.h"
#import "UIImageView+WebCache.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UIView+Touch.h"
#import "UserInfo.h"
#import "DecodeJson.h"
#import "UIImageFactory.h"
#import "WeiboSDK.h"

#define kGiftHeight 100
#define kNumberGift 105

@implementation ZLShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initHiddenView];
    }
    return self;
}

- (void)shareEvent:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shareIndex:)]) {
        [_delegate shareIndex:sender.tag];
    }
}

- (UIButton *)createShareBtn:(CGRect)frame normal:(NSString *)normalImg high:(NSString *)highImg
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 25;
    [UIImageFactory createBtnImage:normalImg btn:btn state:UIControlStateNormal];
    btn.frame = frame;
    return btn;
}

- (void)initShare
{
    _btnPar = [[UIView alloc] initWithFrame:Rect(0, self.height-200, kScreenWidth, 200)];
    [self addSubview:_btnPar];
    _btnPar.backgroundColor = UIColorFromRGB(0xffffff);
    
    CGFloat fWidth = kScreenWidth/4;
    UIButton *btnWeChat = [self createShareBtn:Rect(fWidth/2-25, 8, 50, 50) normal:@"video_share_weixi_icon" high:@""];
    UIButton *btnFriend = [self createShareBtn:Rect(fWidth+fWidth/2-25, 8, 50, 50) normal:@"video_share_pengyouquan_icon" high:@""];
    UIButton *btnTenc = [self createShareBtn:Rect(fWidth*2+fWidth/2-25, 8, 50, 50) normal:@"video_share_qq_icon" high:@""];
    UIButton *btnSpace = [self createShareBtn:Rect(fWidth*3+fWidth/2-25, 8, 50, 50) normal:@"video_share_kongjian_icon" high:@""];
    UIButton *btnSina = [self createShareBtn:Rect(fWidth/2-25, 80, 50, 50) normal:@"video_share_weibo_icon" high:@""];
    UIButton *btnCopy = [self createShareBtn:Rect(fWidth+fWidth/2-25, 80, 50, 50) normal:@"video_share_lin_icon" high:@""];
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        [_btnPar addSubview:btnWeChat];
        [_btnPar addSubview:btnFriend];
    }
    if ([TencentOAuth iphoneQQInstalled])
    {
        [_btnPar addSubview:btnTenc];
    }
    if ([TencentOAuth iphoneQQInstalled]) {
        [_btnPar addSubview:btnSpace];
    }
    if ([WeiboSDK isWeiboAppInstalled]) {
        [_btnPar addSubview:btnSina];
    }
    [_btnPar addSubview:btnCopy];
    
    [btnWeChat addTarget:self action:@selector(shareEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btnFriend addTarget:self action:@selector(shareEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btnTenc addTarget:self action:@selector(shareEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btnSpace addTarget:self action:@selector(shareEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btnSina addTarget:self action:@selector(shareEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btnCopy addTarget:self action:@selector(shareEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    btnWeChat.tag = 1;
    btnFriend.tag = 2;
    btnTenc.tag = 3;
    btnSpace.tag =4;
    btnSina.tag = 5;
    btnCopy.tag = 6;
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnPar addSubview:btnClose];
    [btnClose setTitle:@"关 闭" forState:UIControlStateNormal];
    [btnClose setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateNormal];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateHighlighted];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    btnClose.titleLabel.font = XCFONT(15);
    
    btnClose.frame = Rect(10,140, kScreenWidth-20, 44);
    
    [btnClose addTarget:self action:@selector(setGestureHidden) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeView
{
    [self setHidden:YES];
}

- (void)setGestureHidden
{
    if(_delegate && [_delegate respondsToSelector:@selector(hiddenView)])
    {
        [_delegate hiddenView];
    }
}

- (void)initHiddenView
{
    _hiddenView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    [self addSubview:_hiddenView];
    [_hiddenView setUserInteractionEnabled:YES];
    [_hiddenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setGestureHidden)]];
    
    [self initShare];
    //阴影设置
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 4;
}

- (void)updateGoid
{
    char cBuffer[100]={0};
    sprintf(cBuffer, "余额:%.01f",[UserInfo sharedUserInfo].goldCoin);
    [_lblPrice setText:[NSString stringWithUTF8String:cBuffer]];
}

- (void)selectView:(UIView *)view
{
    if (_selectView == nil) {
        _selectView = [[UIImageView alloc] initWithFrame:view.bounds];
        [_selectView setImage:_giftImage];
        [_scrollView addSubview:_selectView];
    }
    _selectView.frame = view.frame;
    _selectView.tag = view.tag;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = page;
}


- (void)createButton:(NSString *)title frame:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:UIColorFromRGB(0xFF87A1E) forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"video_tallk_bg_p"] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = frame;
    [_numberImgView addSubview:btn];
    [btn addTarget:self action:@selector(clickNumber:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickNumber:(UIButton *)button
{
    [_btnNumber setTitle:button.titleLabel.text forState:UIControlStateNormal];
    _numberView.hidden=!_numberView.hidden;
}

- (void)selectNumber
{
    _numberView.hidden=!_numberView.hidden;
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end

