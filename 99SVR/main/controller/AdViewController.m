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

@interface AdViewController ()

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
    UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
    adButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [adButton setTitle:@"15秒跳过" forState:UIControlStateNormal];
    adButton.backgroundColor = [UIColor redColor];
    [adButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [adButton addTarget:self action:@selector(adSkipClick) forControlEvents:UIControlEventTouchUpInside];
    adButton.frame = CGRectMake(kScreenWidth - 120, 50 , 100, 40);
    [self.view addSubview:adButton];
    
    [self startTimerWithSeconds:15 showButton:adButton strFormat:@"%@秒跳过" endBlock:^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
    }];
}

// 点击跳过广告
- (void)adSkipClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window switchRootViewController];
}

/**
 *  倒计时GCD通用方法
 *  通常用的计时器都是用NSTimer，但是NSTimer在线程很吃紧的时候效果不佳，使用GCD计时相对更好
 *
 *  @param seconds   倒计时间 单位：秒
 *  @param strFormat 格式化样式，如 "剩%@自动关闭"
 *  @param showLable 需要显示的文本框
 *  @param endBlock  倒计时结束后，回调的Block
 */
- (void)startTimerWithSeconds:(long)seconds showButton:(UIButton *)showButton strFormat:(NSString *)format endBlock:(void (^)())endBlock
{
    __block long timeout = seconds; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout < 0){ // 倒计时结束，回调block
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                showButton.userInteractionEnabled = YES;
                if (endBlock) {
                    endBlock();
                }
            });
        } else{
            
            NSString *strTime = [NSString stringWithFormat:@"%02ld",timeout];
            //[NSString stringWithFormat:@"%02ld分%02ld秒",(long)(timeout % 3600 / 60), (long)(timeout  % 60)];
            //回到主界面,显示倒计时
            dispatch_async(dispatch_get_main_queue(), ^{
                if (format) { // 判断是否要格式化
                    [showButton setTitle:[NSString stringWithFormat:format,strTime] forState:(UIControlStateNormal)];
                    //showLable.text = [NSString stringWithFormat:format,strTime];
                } else {
                    [showButton setTitle:strTime forState:(UIControlStateNormal)];
                }
            });
            
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

@end