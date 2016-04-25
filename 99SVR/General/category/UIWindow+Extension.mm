//
//  UIWindow+Extension.m
//  Haigoucang
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 apple开发. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "TabBarController.h"
#import "NewfeatureViewController.h"
#import "AppDelegate.h"
#import "SplashModel.h"
#import "SplashTool.h"
#import "AdViewController.h"

#define bundleVersionKey @"CFBundleVersion"

@implementation UIWindow (Extension)

// 首次启动切换
- (void)switchRootAppDelegate
{
    SplashModel *splash = [SplashTool get];
    if (!splash.imageUrl||[splash.imageUrl isEqualToString:@""]) {
        [self switchRootViewController];
    } else {
         self.rootViewController = [[AdViewController alloc] init];
    }
    
    // 请求下一次广告数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSplash:) name:MESSAGE_HTTP_SPLASH_VC object:nil];
    [kHTTPSingle requestSplashImage];
}

// 广告启动切换
- (void)switchRootViewController
{
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:bundleVersionKey];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[bundleVersionKey];
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
        self.rootViewController = [[TabBarController alloc] init];
    } else { // 这次打开的版本和上一次不一样，显示新特性
        self.rootViewController = [[NewfeatureViewController alloc] init];
    }
}

// 当前的版本号存进沙盒
- (void)saveCurrentVersion
{
    // 将当前的版本号存进沙盒
    [[NSUserDefaults standardUserDefaults] setObject:[NSBundle mainBundle].infoDictionary[bundleVersionKey] forKey:bundleVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 保存下一次广告数据
- (void)loadSplash:(NSNotification *)notify{
    SplashModel *splash = (SplashModel *)notify.object;
    [SplashTool save:splash];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_HTTP_SPLASH_VC object:nil];
}

@end
