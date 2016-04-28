//
//  SplashTool.h
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SplashModel.h"

@interface SplashTool : NSObject

/**
 *  存储闪屏信息
 *
 *  @param account 闪屏模型
 */
+ (void)save:(SplashModel *)splash;

/**
 *  返回闪屏信息
 *
 *  @return 闪屏模型
 */
+ (SplashModel *)get;

@end
