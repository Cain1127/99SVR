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
//#import "UIWindow+Extension.h"
#import "SplashModel.h"
#import "SplashTool.h"
#import "SwitchRootTool.h"

@interface AdViewController ()
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *adButton;
@end

@implementation AdViewController

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
    UIImageView *ad = [[UIImageView alloc] init];
    ad.contentMode = UIViewContentModeScaleAspectFit;
    ad.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.80);
    [ad sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"start-mascot"]];
    [self.view addSubview:ad];
    
    // 3.多少秒后跳过，广告倒计时
    _adButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _adButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_adButton setTitle:[NSString stringWithFormat:@"%@ 跳过",@"3"] forState:UIControlStateNormal];
    _adButton.backgroundColor = [UIColor whiteColor];
    [_adButton setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [_adButton addTarget:self action:@selector(adSkipClick) forControlEvents:UIControlEventTouchUpInside];
    _adButton.frame = CGRectMake(kScreenWidth - 85, 25 , 75, 40);
    [self.view addSubview:_adButton];
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

/**
 *  广告倒计时
 */
NSUInteger secondsCountDown = 3;//60秒倒计时
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

@end