//
//  SlideBaseViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/15.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "SlideBaseViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"

#import "UserInfo.h"

#define LeftMenu_X  -[UIScreen mainScreen].bounds.size.width * 0.25
#define LeftMenu_Width [UIScreen mainScreen].bounds.size.width * 0.75
#define LeftMenu_Hight [UIScreen mainScreen].bounds.size.height - 64
#define TIMER 0.25
#define coverViewTag 100

@interface SlideBaseViewController ()
@end

@implementation SlideBaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏左上角按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftItemClick) image:@"setting_normal" highImage:@"setting_high"];
}

//添加手势
-(void)addRecognizer{
    // 添加拖拽
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    
    [self.view addGestureRecognizer:pan];
}

// 添加滑动遮盖层
- (void)addCoverView
{
    //添加一个遮盖层
    UIView *coverView = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
    coverView.tag = coverViewTag;
    [self.navigationController.view addSubview:coverView];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    [coverView addGestureRecognizer:pan];
    
    //单击手势
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverTag:)];
    [tap setNumberOfTapsRequired:1];
    [coverView addGestureRecognizer:tap];
}


@end
