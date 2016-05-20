//
//  StatusBarHUD.m
//  XMGStatusBarHUDDemo
//
//  Created by jiangys on 16/5/20.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import "StatusBarHUD.h"

#define StatusBarHUD_BGColor_Seccess [UIColor colorWithRed:15.0/255.0f green:193.0/255.0f blue:103.0/255.0f alpha:0.8]
#define StatusBarHUD_BGColor_Error   [UIColor colorWithRed:246.0/255.0f green:89.0/255.0f blue:78.0/255.0f alpha:0.8]

/** HUD控件的距离顶部Y值 */
static CGFloat const StatusBarHUDWindowY = 64;
/** HUD控件的高度 */
static CGFloat const StatusBarHUDWindowH = 44;
/** HUD控件的动画持续时间（出现\隐藏） */
static CGFloat const StatusBarHUDAnimationDuration = 0.25;
/** HUD控件默认会停留多长时间 */
static CGFloat const StatusBarHUDHUDStayDuration = 1.5;

@interface StatusBarHUD()
@property (nonatomic, strong) UIButton *statusButton;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation StatusBarHUD

+ (StatusBarHUD *)shared
{
    static dispatch_once_t once = 0;
    static StatusBarHUD *statusBarHUD;
    dispatch_once(&once, ^{ statusBarHUD = [[StatusBarHUD alloc] init]; });
    return statusBarHUD;
}

- (void)hudCreate:(UIImage *)image text:(NSString *)text bgColor:(UIColor *)bgColor belowSubview:(UIView *)belowSubview
{
    // 停止之前的定时器
    [_timer invalidate];
    
    // 添加按钮
    UIButton *statusButton = [[UIButton alloc] init];
    statusButton.frame =  CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 44);
    statusButton.userInteractionEnabled = NO;
    [statusButton setBackgroundColor:bgColor];
    [statusButton setTitle:text forState:UIControlStateNormal];
    [statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    statusButton.titleLabel.font = [UIFont systemFontOfSize:15];
    if (image)
    {
        [statusButton setImage:image forState:UIControlStateNormal];
        statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    statusButton.hidden = YES;
    [belowSubview addSubview:statusButton];
//    [belowSubview insertSubview:statusButton atIndex:1];
    // 动画
    CGFloat duration = 2; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        statusButton.hidden = NO;
    } completion:^(BOOL finished)
    {
        @WeakObj(statusButton)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
        ^{
            [statusButtonWeak removeFromSuperview];
        });
    
    }];
//     
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    DLog(@"%@",window.rootViewController.navigationController);
//    [window insertSubview:_statusButton belowSubview:belowSubview];
//    
//    // 动画
//    CGFloat duration = StatusBarHUDAnimationDuration; // 动画的时间
//    [UIView animateWithDuration:duration animations:^{
//        _statusButton.transform = CGAffineTransformMakeTranslation(0, StatusBarHUDWindowH);
//    } completion:^(BOOL finished) {
//        CGFloat delay = StatusBarHUDHUDStayDuration; // 延迟1s
//        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
//            _statusButton.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            [_statusButton removeFromSuperview];
//        }];
//    }];
}

+ (void)showImage:(UIImage *)image text:(NSString *)text bgColor:(UIColor *)bgColor belowSubview:(UIView *)belowSubview
{
    [[self shared] hudCreate:image text:text bgColor:bgColor belowSubview:belowSubview];
}

+ (void)showSuccess:(NSString *)text belowSubview:(UIView *)belowSubview
{
    [self showImage:[UIImage imageNamed:@"prompt_ok_icon"] text:text bgColor:StatusBarHUD_BGColor_Seccess belowSubview:belowSubview];
}

+ (void)showError:(NSString *)text belowSubview:(UIView *)belowSubview
{
    [self showImage:[UIImage imageNamed:@"prompt_wrong_icon"] text:text bgColor:StatusBarHUD_BGColor_Error belowSubview:belowSubview];
}

+ (void)showText:(NSString *)text belowSubview:(UIView *)belowSubview
{
    [self showImage:nil text:text bgColor:StatusBarHUD_BGColor_Error belowSubview:belowSubview];
}

@end
