//
//  SwitchRootTool.m
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "SwitchRootTool.h"
#import "TabBarController.h"
#import "NewfeatureViewController.h"
#import "AppDelegate.h"
#import "SplashModel.h"
#import "SplashTool.h"
#import "AdViewController.h"
#import "SocketNetworkView.h"

#define bundleVersionKey @"CFBundleVersion"

@implementation SwitchRootTool
// 首次启动切换
+ (void)switchRootForAppDelegate
{
    SplashModel *splash = [SplashTool get];
    double date = (double)[[NSDate  date] timeIntervalSince1970];//当前时间戳
    
    if (!splash.imageUrl    // 图片为空
        ||[splash.imageUrl isEqualToString:@""]
        || date < splash.startTime
        || date > splash.endtime)
    {
        [self switchRootForViewController];
    } else {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.window.rootViewController = [[AdViewController alloc] init];
    }
    
    // 请求下一次广告数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSplash:) name:MESSAGE_HTTP_SPLASH_VC object:nil];
    [kHTTPSingle requestSplashImage];
}

// 广告启动切换
+ (void)switchRootForViewController
{
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:bundleVersionKey];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[bundleVersionKey];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    DLog(@"currentVersion:%@-----lastVersion:%@",currentVersion,lastVersion);
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
        app.window.rootViewController = [[TabBarController alloc] init];
        
//        SocketNetworkView *networkView = [[SocketNetworkView alloc] init];
//        [app.window.rootViewController.view addSubview:networkView];
    } else { // 这次打开的版本和上一次不一样，显示新特性
        app.window.rootViewController = [[NewfeatureViewController alloc] init];
    }
}

// 当前的版本号存进沙盒
+ (void)saveCurrentVersion
{
    // 将当前的版本号存进沙盒
    [[NSUserDefaults standardUserDefaults] setObject:[NSBundle mainBundle].infoDictionary[bundleVersionKey] forKey:bundleVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 保存下一次广告数据
+ (void)loadSplash:(NSNotification *)notify{
    SplashModel *splash = (SplashModel *)notify.object;
    [SplashTool save:splash];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_HTTP_SPLASH_VC object:nil];
}
@end
