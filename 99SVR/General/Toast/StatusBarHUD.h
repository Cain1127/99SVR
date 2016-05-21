//
//  StatusBarHUD.h
//  XMGStatusBarHUDDemo
//
//  Created by jiangys on 16/5/20.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StatusBarHUD : UIView

+ (StatusBarHUD *)shared;

/**
 * 显示图片+文字信息
 */
+ (void)showImage:(UIImage *)image text:(NSString *)text bgColor:(UIColor *)bgColor belowSubview:(UIView *)belowSubview;

/**
 * 显示成功信息
 */
+ (void)showSuccess:(NSString *)text belowSubview:(UIView *)belowSubview;

/**
 * 显示失败信息
 */
+ (void)showError:(NSString *)text belowSubview:(UIView *)belowSubview;

/**
 * 显示普通信息
 */
+ (void)showText:(NSString *)text belowSubview:(UIView *)belowSubview;

@end
