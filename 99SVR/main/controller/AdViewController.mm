//
//  AdViewController.m
//  99SVR
//
//  Created by jiangys on 16/4/23.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "AdViewController.h"
#import "UIImageView+WebCache.h"
#import "NewfeatureViewController.h"
#import "SplashModel.h"
#import "SplashTool.h"
#import "SwitchRootTool.h"
#import "AdLinkShowViewController.h"
#import "AppDelegate.h"

@interface AdViewController ()
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *adButton;
@end

@implementation AdViewController

NSUInteger secondsCountDown = 3;//倒计时秒数

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.背景图片
    UIImageView *bg = [[UIImageView alloc] init];
    // 显示图片
    NSString *name=@"start_page_750x1334";
    if (kiPhone4_OR_4s) {
        name = @"start_page_640x960";
    } else if(kiPhone5_OR_5c_OR_5s){
        name = @"start_page_640x1136";
    } else if(kiPhone6_OR_6s){
        name = @"start_page_750x1334";
    } else if(kiPhone6Plus_OR_6sPlus){
        name = @"start_page_1242x2208";
    }
    // 为了释放图片内存，imageWithContentsOfFile 代替 [UIImage imageNamed:name];
    bg.image = kPNG_IMAGE_FILE(name);
    bg.frame = self.view.bounds;
    [self.view addSubview:bg];
    
    // 2.广告图片
    SplashModel *splash = [SplashTool get];
    NSString *str = splash.imageUrl;
    UIImageView *adImageView = [[UIImageView alloc] init];
    adImageView.contentMode = UIViewContentModeScaleAspectFill;
    adImageView.clipsToBounds = YES;
    adImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.80);
    adImageView.userInteractionEnabled = YES;
    [adImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"start-mascot"]];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageViewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [adImageView addGestureRecognizer:tapGr];
    [self.view addSubview:adImageView];
    
    // 3.多少秒后跳过，广告倒计时
    _adButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _adButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_adButton setTitle:[NSString stringWithFormat:@"%lu 跳过",(unsigned long)secondsCountDown] forState:UIControlStateNormal];
    _adButton.backgroundColor = [UIColor whiteColor];
    [_adButton setTitleColor:COLOR_Text_Gay forState:UIControlStateNormal];
    [_adButton addTarget:self action:@selector(adSkipClick) forControlEvents:UIControlEventTouchUpInside];
    _adButton.frame = CGRectMake(kScreenWidth - 75, 25 , 60, 35);
    _adButton.titleLabel.font = XCFONT(14);
    _adButton.layer.cornerRadius = 2.5f;
    _adButton.layer.masksToBounds = YES;
    [self.view addSubview:_adButton];
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

/**
 *  广告倒计时
 */
- (void)timerCountDown
{
    secondsCountDown--;
    [_adButton setTitle:[NSString stringWithFormat:@"%lu 跳过",(unsigned long)secondsCountDown] forState:UIControlStateNormal];
    if(secondsCountDown==0){
        [self adSkipClick];
    }
}

/**
 *  点击跳过
 */
- (void)adSkipClick
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer=nil;
    
    [SwitchRootTool switchRootForViewController];
}

// 广告跳转
-(void)adImageViewTapped:(UITapGestureRecognizer*)tapGr
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer=nil;
    
    SplashModel *splash = [SplashTool get];
    if (splash.url) {
        AdLinkShowViewController *adLinkShowVc = [[AdLinkShowViewController alloc] init];
        adLinkShowVc.linkShowUrl = splash.url;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.window.rootViewController = adLinkShowVc;
    }
}

@end