//
//  SlideBaseViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/15.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "SlideBaseViewController.h"
#import "LeftMenu.h"
#import "LeftViewController.h"
#import "LoginViewController.h"

#define LeftMenu_X  -[UIScreen mainScreen].bounds.size.width * 0.25
#define LeftMenu_Width [UIScreen mainScreen].bounds.size.width * 0.75
#define LeftMenu_Hight [UIScreen mainScreen].bounds.size.height - 64
#define TIMER 0.25
#define coverViewTag 100

@interface SlideBaseViewController ()<LeftMenuDegelate>
@property (nonatomic, strong) LeftMenu *leftMenu;
@end

@implementation SlideBaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏左上角按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftItemClick) image:@"setting_normal" highImage:@"setting_high"];
    
    // 添加左边的菜单
    [self addLeftMenu];
    
    // 添加手势
    [self addRecognizer];
}

//添加手势
-(void)addRecognizer{
    // 添加拖拽
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    
    [self.view addGestureRecognizer:pan];
}

//实现拖拽
-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    _leftMenu.hidden = NO;
    // 1. 获取手指拖拽的时候, 平移的值
    CGPoint translation = [recognizer translationInView:self.tabBarController.view];
    
    // 2. 让当前控件做响应的平移
    self.tabBarController.view.transform = CGAffineTransformTranslate(self.tabBarController.view.transform, translation.x, 0);
    _leftMenu.ttx = self.tabBarController.view.ttx/3;
    
    // 3. 每次平移手势识别完毕后, 让平移的值不要累加
    [recognizer setTranslation:CGPointZero inView:self.tabBarController.view];
    
    //获取最右边范围
    CGAffineTransform rightScopeTransform=CGAffineTransformTranslate(self.view.transform,LeftMenu_Width, 0);
    
    //  当移动到右边极限时
    if (self.tabBarController.view.transform.tx > rightScopeTransform.tx) {
        
        // 限制最右边的范围
        self.tabBarController.view.transform = rightScopeTransform;
        // 限制透明view最右边的范围
        _leftMenu.ttx=self.tabBarController.view.ttx/3;
        
        // 当移动到左边极限时
    }else if (self.tabBarController.view.transform.tx < 0.0){
        
        //  限制最左边的范围
        self.tabBarController.view.transform=CGAffineTransformTranslate(self.view.transform,0, 0);
        //  限制透明view最左边的范围
        _leftMenu.ttx=self.tabBarController.view.ttx / 3;
        
    }
    //    当托拽手势结束时执行
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^{
            if (self.tabBarController.view.x >[UIScreen mainScreen].bounds.size.width*0.5) {
                
                self.tabBarController.view.transform = rightScopeTransform;
                _leftMenu.ttx=self.tabBarController.view.ttx/3;
                //添加一个遮盖层
                [self addCoverView];
                
            }else{
                // 移除覆盖
                [self coverClick:[self.navigationController.view viewWithTag:coverViewTag]];
            }
        }];
    }
}

-(void)addLeftMenu
{
    _leftMenu = [[LeftMenu alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width * 0.25, 0, kScreenWidth,kScreenHeight)];
    _leftMenu.degelate = self;
    _leftMenu.hidden = YES;
    [[UIApplication sharedApplication].keyWindow insertSubview:_leftMenu atIndex:0];
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

#pragma mark - 点击事件
-(void)leftItemClick
{
    CGAffineTransform rightScopeTransform=CGAffineTransformTranslate(CGAffineTransformIdentity,LeftMenu_Width, 0);
    _leftMenu.hidden = NO;
    
    [UIView animateWithDuration:TIMER animations:^{
        self.tabBarController.view.transform=rightScopeTransform;
        _leftMenu.ttx=self.tabBarController.view.ttx/3;
        //添加一个遮盖层
        [self addCoverView];
    }];
}

/**
 *  手势单击
 */
- (void)coverTag:(UITapGestureRecognizer *)recognizer
{
    [self coverClick:recognizer.view];
}

// 菜单回退到原位
-(void)coverClick:(UIView *)coverView
{
    [UIView animateWithDuration:TIMER animations:^{
        self.tabBarController.view.transform = CGAffineTransformIdentity;
        _leftMenu.ttx=self.tabBarController.view.ttx/3;
    } completion:^(BOOL finished) {
        self.leftMenu.hidden = YES;
        [coverView removeFromSuperview];
    }];
}

#pragma mark - leftMenuDegelate
- (void)leftMenuDidSeletedAtRow:(NSInteger)row title:(NSString *)title vc:(UIViewController *)vc
{
    [self coverClick:[self.navigationController.view viewWithTag:coverViewTag]];
    [self.navigationController pushViewController:vc animated:YES];
}

// 点击头像，登陆
- (void)leftMenuIconDidClick{
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
    [self coverClick:[self.navigationController.view viewWithTag:coverViewTag]];
}

@end
