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

#define bundleVersionKey @"CFBundleVersion"

@implementation UIWindow (Extension)

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


@end
