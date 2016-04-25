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
#import "UIWindow+Extension.h"
#import "SplashModel.h"
#import "SplashTool.h"

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
    // TODO : 当前只是适配iphone6，图片过来再做修改
    bg.image = [UIImage imageNamed:@"start_page_640x1136"];
    bg.frame = self.view.bounds;
    [self.view addSubview:bg];
    
    // 2.广告图片
    NSString *str = @"http://pic.nipic.com/2008-04-01/20084113367207_2.jpg";
    UIImageView *ad = [[UIImageView alloc] init];
    ad.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.85);
    [ad sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage new]];
    [self.view addSubview:ad];
    
    // 3.多少秒后跳过，广告倒计时
    _adButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _adButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_adButton setTitle:@"5秒跳过" forState:UIControlStateNormal];
    _adButton.backgroundColor = [UIColor redColor];
    [_adButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_adButton addTarget:self action:@selector(adSkipClick) forControlEvents:UIControlEventTouchUpInside];
    _adButton.frame = CGRectMake(kScreenWidth - 120, 50 , 100, 40);
    [self.view addSubview:_adButton];
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

/**
 *  广告倒计时
 */
NSUInteger secondsCountDown = 5;//60秒倒计时
- (void)timerCountDown
{
    secondsCountDown--;
    [_adButton setTitle:[NSString stringWithFormat:@"%lu秒跳过",(unsigned long)secondsCountDown] forState:UIControlStateNormal];
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
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window switchRootViewController];
}

@end