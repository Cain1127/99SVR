//
//  NavigationViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/14.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "NavigationViewController.h"
#import "XMyViewController.h"

@interface NavigationViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *popPanGesture;
@end

@implementation NavigationViewController

/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
+ (void)initialize
{
    // 1.设置导航栏主题
//    [self setupNavBarTheme];
    // 2.设置导航栏按钮主题
    //[self setupBarButtonItemTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置pop手势代理
    self.interactivePopGestureRecognizer.delegate = self;
    
}

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
     navBar.translucent = NO;
    [navBar setShadowImage:[[UIImage alloc] init]];
    [navBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

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
    if (self.childViewControllers.count > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TABBAR_DISAPPER_VC object:nil];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(blackBtnClick) image:@"back" highImage:@"back"];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    DLog(@"class:%@",NSStringFromClass([viewController class]));
    if(self.childViewControllers.count==1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TABBAR_APPER_VC object:nil];
    }
    return viewController;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray<UIViewController *> *array = [super popToRootViewControllerAnimated:animated];
    return array;
}

/**
 *  - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TABBAR_DISAPPER_VC object:nil];
 }
 
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TABBAR_APPER_VC object:nil];
 }
 */

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
    if (self.viewControllers.count==1) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

#pragma mark -- 点击空白处收起键盘
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    [self.view endEditing:YES];
//}

#pragma mark - <UIGestureRecognizerDelegate>
/**
 *  push进来的控制器大于1个，手势有效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return self.viewControllers.count > 1;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewDidAppear:animated];
}

@end
