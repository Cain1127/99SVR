//
//  TabBarController.m
//  99SVR
//
//  Created by Jiangys on 16/3/14.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "TabBarController.h"
#import "ZLVideoListViewController.h"
#import "NavigationViewController.h"
#import "HomeViewController.h"
#import "IndexViewController.h"
#import "StockHomeViewController.h"
#import "TQIdeaViewController.h"
#import "TQMeCustomizedViewController.h"
#import "MyNavigationViewController.h"
#import "XMyViewController.h"
#import "TQMyViewController.h"
#import "PlayIconView.h"
#import "UIImageFactory.h"
#import "RoomHttp.h"
#import "RoomViewController.h"

@interface TabBarController ()<PlayIconDelegate>

@property (nonatomic,strong) PlayIconView *iConView;
@property (nonatomic,strong) UIButton *btnPlay;

@end

@implementation TabBarController

- (void)exitPlay{
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    [roomView exitRoom];
    _iConView.hidden = YES;
}

- (void)gotoPlay{
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    [self.navigationController pushViewController:roomView animated:YES];
}

- (void)hidenPlay{
    _btnPlay.hidden = NO;
    _iConView.hidden = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 统一设置Item的文字属性
//        [self setUpItemTextAttrs];
//        
        // 添加所以子控制器
//        [self setUpAllChildViewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlayIconView) name:MESSAGE_TABBAR_APPER_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenPlayIconView) name:MESSAGE_TABBAR_DISAPPER_VC object:nil];
    // 统一设置Item的文字属性
    [self setUpItemTextAttrs];
    
    // 添加所以子控制器
    [self setUpAllChildViewControllers];
    
    _iConView = [[PlayIconView alloc] initWithFrame:Rect(0, kScreenHeight-108, kScreenWidth, 64)];
    [self.view addSubview:_iConView];
    _iConView.hidden = YES;
    _iConView.delegate = self;
    
    _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_btnPlay];
    _btnPlay.frame = Rect(kScreenWidth-55, kScreenHeight-98, 44, 44);
    [UIImageFactory createBtnImage:@"home_play_icon" btn:_btnPlay state:UIControlStateNormal];
    _btnPlay.hidden=YES;
    [_btnPlay addTarget:self action:@selector(showPlayInfo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showPlayInfo
{
    _btnPlay.hidden = YES;
    _iConView.hidden = NO;
}

- (void)showIconView
{
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    NSString *strUrl=nil;
    if([roomView.room.teamicon length]==0)
    {
        strUrl = @"";
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_URL,roomView.room.croompic];
    }
    [_iConView.imgView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    [_iConView.lblName setText:roomView.room.teamname];
    [_iConView.lblNumber setText:roomView.room.teamid];
    [_iConView.btnQuery setTitle:roomView.room.onlineusercount forState:UIControlStateNormal];
    _iConView.hidden = NO;
}

/**
 *  统一设置Item文字的属性
 */
- (void)setUpItemTextAttrs{
    // 统一设置Item文字的属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x919191);
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    // 选中状态
    NSMutableDictionary *selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x0078DD);
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];
}

/**
 *  添加所有子控制器
 */
- (void)setUpAllChildViewControllers{
    
    [self setUpOneViewController:[[HomeViewController alloc]init] title:@"首页" image:@"home" selectImage:@"home_h"];
    [self setUpOneViewController:[[ZLVideoListViewController alloc]init] title:@"财经直播" image:@"video_live" selectImage:@"video_live_h"];
    [self setUpOneViewController:[[TQIdeaViewController alloc]init] title:@"专家观点" image:@"tab_text_icon_normal" selectImage:@"tab_text_icon_pressed"];
    [self setUpOneViewController:[[StockHomeViewController alloc]init] title:@"高手操盘" image:@"tab_operate_n" selectImage:@"tab_operate_h"];
    [self setUpOneViewController:[[XMyViewController alloc]init] title:@"我" image:@"tab_me_n" selectImage:@"tab_me_p"];
    
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

- (void)setUpMyViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    MyNavigationViewController *nav = [[MyNavigationViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)showPlayIconView
{
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if (roomView.room!=nil) {
        [self showIconView];
    }
}

- (void)hiddenPlayIconView
{
    _btnPlay.hidden = YES;
    _iConView.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
