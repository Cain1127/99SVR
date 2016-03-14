//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 15-4-18.
//  Copyright (c) 2015年 All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

/**
 *  显示带图标的成功信息，1.5秒自动关闭
 *  调用 [MBProgressHUD showSuccess:@"请求成功"];
 *
 *  @param success 要显示的文字
 */
+ (void)showSuccess:(NSString *)success;
/**
 *  显示带图标的成功信息，1.5秒自动关闭
 *
 *  @param success 要显示的文字
 *  @param view    要显示的View上
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示带图标的失败信息，1.5秒自动关闭
 *  调用 [MBProgressHUD showError:@"请求失败"];
 *
 *  @param error 要显示的失败文字
 */
+ (void)showError:(NSString *)error;

/**
 *  显示带图标的失败信息，1.5秒自动关闭
 *
 *  @param error 要显示的失败文字
 *  @param view  要显示的View上
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示带转圈标的信息，需要手动关闭，结合hideHUD使用
 *
 *  @param message 要显示的信息
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  显示纯文字信息 ，1.5秒自动消失
 *  [MBProgressHUD showText:@"请求失败"];
 *
 *  @param message 要显示的信息
 */
+ (void)showText:(NSString *)message;
/**
 *  显示纯文字信息 ，1.5秒自动消失
 *
 *  @param message 要显示的信息
 *  @param view    要显示的View
 */
+ (void)showText:(NSString*)message toView:(UIView *)view;

/**
 *  关闭HUD
 */
+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;
@end
