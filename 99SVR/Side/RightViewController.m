//
//  RightViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RightViewController.h"
#import "ZLTabBar.h" 
#import "HomeViewController.h"
#import "IndexViewController.h"
#import "TextViewController.h"
#import "ZLButton.h"

#define kSelect_view_control_tag 100

@interface RightViewController ()<ZLTabBarDelegate>
{
}

@property (nonatomic,strong) ZLTabBar *tabBar;

@end

@implementation RightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initUIHead];
}

- (void)initUIHead
{
    ZLTabInfo *tabInfo1 = [[ZLTabInfo alloc] initWithTabInfo:@"首页" normal:@"home" high:@"home_h" viewControl:[[HomeViewController alloc] init]];
    ZLTabInfo *tabInfo2 = [[ZLTabInfo alloc] initWithTabInfo:@"视频直播" normal:@"video_live" high:@"video_live_h" viewControl:[[IndexViewController alloc] init]];
    ZLTabInfo *tabInfo3 = [[ZLTabInfo alloc] initWithTabInfo:@"文字直播" normal:@"text_live" high:@"text_live_h" viewControl:[[TextViewController alloc] init]];
    
    NSArray *aryTab = @[tabInfo1,tabInfo2,tabInfo3];
    [self addSonView:aryTab];
    
    _tabBar = [[ZLTabBar alloc] initWithItems:aryTab];
    [self.view addSubview:_tabBar];
    _tabBar.delegate = self;
    [_tabBar setSelectIndex:0];
    
    tabInfo1.viewController.view.tag = kSelect_view_control_tag;
}

- (void)addSonView:(NSArray *)array
{
    for (ZLTabInfo *tabInfo in array)
    {
        [self addChildViewController:tabInfo.viewController];
    }
}

- (void)selectIndex:(UIViewController *)viewController
{
    [UIView animateWithDuration:0.1f animations:
     ^{
         UIView *currentView = [self.view viewWithTag:kSelect_view_control_tag];
         [currentView removeFromSuperview];
         viewController.view.frame = CGRectMake(0,0,kScreenWidth, kScreenHeight);
         viewController.view.tag = kSelect_view_control_tag;
         [self.view insertSubview:viewController.view belowSubview:self.tabBar];
     }];
}

- (void)initUIBody
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)selectIndex:(UIViewController *)viewController
//{
//    
//}

@end
