//
//  SplashTool.m
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "SplashTool.h"

// 闪屏的存储路径
#define SplashPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"splash.archive"]

@implementation SplashTool

/**
 *  存储闪屏信息
 *
 *  @param account 账号模型
 */
+ (void)save:(SplashModel *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:SplashPath];
}

/**
 *  返回账号信息
 *
 *  @return 闪屏模型（如果闪屏过期，返回nil）
 */
+ (SplashModel *)get
{
    SplashModel *splash = [NSKeyedUnarchiver unarchiveObjectWithFile:SplashPath];
    return splash;
}

@end
