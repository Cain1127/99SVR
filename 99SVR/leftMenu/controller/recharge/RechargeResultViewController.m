//
//  RechargeResultViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/17.
//  Copyright © 2016年 Jiangys . All rights reserved.
//  充值结果

#import "RechargeResultViewController.h"

@interface RechargeResultViewController ()

@end

@implementation RechargeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    // 图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.frame = CGRectMake(kScreenWidth/2 - 72/2, 50, 72, 72);
    if (_isRechargeSucceed) {
        iconView.image = [UIImage imageNamed:@"register_prompt-icon"];
    } else{
        // 失败的图片，暂时还没有
        iconView.image = [UIImage imageNamed:@"register_prompt-icon"];
    }
    [bgView addSubview:iconView];
    
    // 文字
    UILabel *explainLable = [[UILabel alloc] init];
    explainLable.frame = CGRectMake(0, CGRectGetMaxY(iconView.frame) + 40, kScreenWidth, 30);
    explainLable.textColor = [UIColor blackColor];
    if (_isRechargeSucceed) {
        explainLable.text = @"支付成功，请稍后查看金币余额";
    } else {
        explainLable.text = @"支付失败，由于网络出错原因，请点击重试";
    }
    explainLable.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:explainLable];
    
    // 重试及点击查看按钮
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeButton.frame = Rect(30, CGRectGetMaxY(explainLable.frame) + 40, kScreenWidth-60, 40);
    [rechargeButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rechargeButton setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [rechargeButton setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    rechargeButton.layer.masksToBounds = YES;
    rechargeButton.layer.cornerRadius = 3;
    if (_isRechargeSucceed) {
    [rechargeButton setTitle:@"确定" forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [rechargeButton setTitle:@"重 试" forState:UIControlStateNormal];
        [rechargeButton addTarget:self action:@selector(retryClick) forControlEvents:UIControlEventTouchUpInside];
    }
    [bgView addSubview:rechargeButton];
}

/**
 *  查看
 */
- (void)checkClick
{
    // 当前改为了确定
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  重试
 */
- (void)retryClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
