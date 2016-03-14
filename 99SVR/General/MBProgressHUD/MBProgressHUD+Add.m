//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 15-4-18.
//  Copyright (c) 2015年 All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
/**
 *  显示信息
 *
 *  @param text 显示信息
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
}

#pragma mark 显示错误信息
/**
 *  显示带图标的成功信息，1.0秒自动关闭
 *  调用 [MBProgressHUD showSuccess:@"请求成功"];
 *
 *  @param success 要显示的文字
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  显示带图标的成功信息，1.0秒自动关闭
 *
 *  @param success 要显示的文字
 *  @param view    要显示的View上
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

/**
 *  显示带图标的失败信息，1.0秒自动关闭
 *  调用 [MBProgressHUD showError:@"请求失败"];
 *
 *  @param error 要显示的失败文字
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 *  显示带图标的失败信息，1.0秒自动关闭
 *
 *  @param error 要显示的失败文字
 *  @param view  要显示的View上
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

#pragma mark 显示一些信息
/**
 *  显示一些信息，有蒙版
 *
 *  @param message 显示的信息
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view dimBackground:(BOOL)dimBackground{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    //hud.opacity = 0.8;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = dimBackground;
    return hud;
}

/**
 *  显示带转圈标的信息，需要手动关闭，结合hideHUD使用
 *
 *  @param message 要显示的信息
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil dimBackground:NO];
}

/**
 *  显示带转圈标的信息，需要手动关闭，结合hideHUD使用
 *
 *  @param message 要显示的信息
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    return [self showMessage:message toView:view dimBackground:NO];
}

/**
 *  显示纯文字信息 ，1.5秒自动消失
 *  [MBProgressHUD showText:@"请求失败"];
 *
 *  @param message 要显示的信息
 */
+ (void)showText:(NSString *)message
{
    [self showText:message toView:nil];
}

/**
 *  显示纯文字信息 ，1.5秒自动消失
 *  [MBProgressHUD showText:@"请求失败"];
 *
 *  @param message 要显示的信息
 *  @param view  要显示的View上
 */
+ (void)showText:(NSString*)message toView:(UIView *)view {
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.opacity = 0.8;
    hud.margin = 12.f;
    //hud.cornerRadius = 3; // 圆角
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.2];
}

/**
 *  显示纯文字信息 ，1.5秒自动消失
 *
 *  @param message 要显示的信息
 *  @param view    要显示的View
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

@end
