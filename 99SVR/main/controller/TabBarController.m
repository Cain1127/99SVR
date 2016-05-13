//
//  TabBarController.m
//  99SVR
//
//  Created by Jiangys on 16/3/14.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "TabBarController.h"
#import "ZLVideoListViewController.h"
#import "GFNavigationController.h"
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
#import "Reachability.h"
#import "AppDelegate.h"
#import "UIAlertView+Block.h"
#import "SocketNetworkView.h"

@interface TabBarController ()<PlayIconDelegate>
{
    NetworkStatus nowStatus;
}
@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) PlayIconView *iConView;
@property (nonatomic, strong) UIButton *btnPlay;
//@property (nonatomic, strong) SocketNetworkView *networkView;
@end

@implementation TabBarController

- (void)exitPlay{
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    [roomView exitRoom];
    _iConView.hidden = YES;
}

- (void)gotoPlay
{
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    [self.navigationController pushViewController:roomView animated:YES];
}

- (void)hidenPlay
{
    _btnPlay.hidden = NO;
    _iConView.hidden = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 统一设置Item的文字属性
        [self setUpItemTextAttrs];
        // 添加所以子控制器
        [self setUpAllChildViewControllers];
    }
    return self;
}

- (void)loadInfo:(NSNotification *)notify
{
    int nAllNum = [notify.object[@"privateservice"] intValue] + [notify.object[@"system"] intValue] +
    [notify.object[@"reply"] intValue]+[notify.object[@"answer"] intValue];
    DLog(@"总数字:%d",nAllNum);
    KUserSingleton.nUnRead = nAllNum;
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UNREAD_NUMBER_VC object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfo:) name:MESSAGE_UNREAD_INFO_VC object:nil];
    [kHTTPSingle RequestUnreadCount];
    
    // 网络检测
    _hostReach = [Reachability reachabilityWithHostName:@"www.163.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    //开启网络通知
    [_hostReach startNotifier];
    
    // Socket没网监控,当前只有tabbar底部的几个按钮有效果显示，子页不显示
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kSocketNetworkKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Socket没网监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketNetworkState:) name:MESSAGE_NETWORK_TCP_SOCKET_STATE_VC object:nil];
}

- (void)socketNetworkState:(NSNotification *)notify
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = notify.object;
        //当childVcCount为0，表示是根目录，>0表示子view
        NSString *childVcCount = [[NSUserDefaults standardUserDefaults] objectForKey:kSocketNetworkKey];
        
        // 保存当前网络状态，在pust里使用
        [[NSUserDefaults standardUserDefaults] setObject:[dict[@"code"] description] forKey:kSocketNetworkStateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!app.socketNetworkView) {
            app.socketNetworkView = [[SocketNetworkView alloc] init];
            [[UIApplication sharedApplication].keyWindow addSubview:app.socketNetworkView];
        }
        
        // tabbar 根目录，显示
        if ([childVcCount isEqualToString:@"0"]) {
            if ([dict[@"code"] intValue]==1) { // 连接成功
                app.socketNetworkView.socketNetworkViewState = SocketNetworkViewStateNormal;
                app.socketNetworkView.hidden = YES;
                
            } else { // 连接失败
                app.socketNetworkView.hidden = NO;
                app.socketNetworkView.socketNetworkViewState = SocketNetworkViewStateNoNetwork;
            }
            
        } else { // PUST的子View，隐藏
            app.socketNetworkView.hidden = YES;
        }
    });
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
- (void)setUpAllChildViewControllers
{
    [self setUpOneViewController:[[HomeViewController alloc]init] title:@"首页" image:@"home" selectImage:@"home_h"];
    [self setUpOneViewController:[[ZLVideoListViewController alloc]init] title:@"财经直播" image:@"video_live" selectImage:@"video_live_h"];
    if ([UserInfo sharedUserInfo].nStatus)
    {
        [self setUpOneViewController:[[TQIdeaViewController alloc]init] title:@"专家观点" image:@"tab_text_icon_normal" selectImage:@"tab_text_icon_pressed"];
        [self setUpOneViewController:[[StockHomeViewController alloc]init] title:@"高手操盘" image:@"tab_operate_n" selectImage:@"tab_operate_h"];
    }
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
    GFNavigationController *nav = [[GFNavigationController alloc]initWithRootViewController:vc];
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

/**
 *  网络更改通知
 */
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZLLogonServerSing *sing = [ZLLogonServerSing sharedZLLogonServerSing];
        [sing onNetWorkChange]; // 网络变更
    });
    
    if (status == NotReachable)
    {
        DLog(@"网络状态:中断");
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        __weak UIWindow *__windows = app.window;
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           //            [__windows makeToast:@"无网络"];
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [UIAlertView createAlertViewWithTitle:@"提示" withViewController:__windows.rootViewController withCancleBtnStr:@"取消" withOtherBtnStr:@"设置" withMessage:@"网络连接失败，请点击设置去检查网络" completionCallback:^(NSInteger index) {
                                       
                                       if (index==1) {
                                           NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                           
                                           if([[UIApplication sharedApplication] canOpenURL:url]) {
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Setting"]];
                                           }
                                       }
                                       
                                   }];
                                   
                               });
                               
                           });
                           
                       });
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NETWORK_ERR_VC object:nil];
        if(!(nowStatus == status)){
            
        }
        nowStatus = status;
        return ;
    }
    else if(status == ReachableViaWiFi)
    {
        //        __weak UIWindow *__windows = self.window;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [__windows makeToast:@"当前网络:WIFI"];
        //        });
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NETWORK_OK_VC object:nil];
    }
    else if(status == ReachableViaWWAN)
    {
        //        __weak UIWindow *__windows = self.window;
        //        dispatch_async(dispatch_get_main_queue(),
        //           ^{
        //               [__windows makeToast:@"当前网络:移动网络"];
        //           });
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NETWORK_OK_VC object:nil];
    }
    nowStatus = status;
    [KUserSingleton.dictRoomGate removeAllObjects];
    [KUserSingleton.dictRoomMedia removeAllObjects];
    [KUserSingleton.dictRoomText removeAllObjects];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
