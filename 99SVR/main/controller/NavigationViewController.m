//
//  NavigationViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/14.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigationViewController

/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
+ (void)initialize
{
    // 1.设置导航栏主题
    [self setupNavBarTheme];
    // 2.设置导航栏按钮主题
    //[self setupBarButtonItemTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置pop手势代理
    self.interactivePopGestureRecognizer.delegate = self;
}


/**
 *  设置导航栏按钮主题
 */
//+ (void)setupBarButtonItemTheme
//{
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    // 设置文字属性
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    //textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
//    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
//    disableTextAttrs[NSForegroundColorAttributeName] =  [UIColor lightGrayColor];
//    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
//}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme
{
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 设置bar的颜色
    [navBar setBarTintColor:kNavColor];
    // 关闭半透明开关
    // navBar.translucent = NO;
//    [navBar setShadowImage:[[UIImage alloc] init]];
//    [navBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    navBar.tintColor = [UIColor whiteColor];
    // 设置状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [navBar setTitleTextAttributes:textAttrs];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMax) forBarMetrics:UIBarMetricsDefault];
}

/**
 *  跳转到下一个界面
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置左边的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(blackBtnClick) image:@"back" highImage:@"back"];
    }
    [super pushViewController:viewController animated:animated];
}

/**
 *  返回关闭窗口
 */
- (void)blackBtnClick{
    
    [self popViewControllerAnimated:YES];
}

/**
 *  统一设置所有的界面状态栏
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- 点击空白处收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - <UIGestureRecognizerDelegate>

/**
 *  push进来的控制器大于1个，手势有效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return self.viewControllers.count > 1;
}
@end
