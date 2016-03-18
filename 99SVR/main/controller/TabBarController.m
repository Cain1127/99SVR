//
//  TabBarController.m
//  99SVR
//
//  Created by Jiangys on 16/3/14.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "TabBarController.h"
#import "NavigationViewController.h"
#import "HomeViewController.h"
#import "IndexViewController.h"
#import "TextViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 统一设置Item的文字属性
        [self setUpItemTextAttrs];
        
        // 添加所以子控制器
        [self setUpAllChildViewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  统一设置Item文字的属性
 */
- (void)setUpItemTextAttrs{
    // 统一设置Item文字的属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = RGB(39, 39, 39);
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    // 选中状态
    NSMutableDictionary *selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];
}

/**
 *  添加所有子控制器
 */
- (void)setUpAllChildViewControllers{
    
    [self setUpOneViewController:[[HomeViewController alloc]init] title:@"首页" image:@"home" selectImage:@"home_h"];
    
    [self setUpOneViewController:[[IndexViewController alloc]init] title:@"视频直播" image:@"video_live" selectImage:@"video_live_h"];
    [self setUpOneViewController:[[TextViewController alloc]init] title:@"文字直播" image:@"text_live" selectImage:@"text_live_h"];
}

/**
 *  添加一个子控制器
 */

- (void)setUpOneViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    NavigationViewController *nav = [[NavigationViewController alloc]initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

@end