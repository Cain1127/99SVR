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
    
    CGFloat scroView_w = belowSubview.frame.size.width;
    CGFloat scroView_h = 44;
    
//    DLog(@"%@",[self activityViewController]);
    
    UIViewController *viewController = [self getViewControllerInView:belowSubview];
    CGFloat navBarMaxY = CGRectGetMaxY(viewController.navigationController.navigationBar.frame);
    DLog(@"%f",navBarMaxY);
    UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:(CGRect){0,0,scroView_w,scroView_h}];
    scroView.backgroundColor = [UIColor yellowColor];
    scroView.contentSize = (CGSize){scroView_w,scroView_h*3.0};
    [belowSubview addSubview:scroView];
    [belowSubview bringSubviewToFront:scroView];
    // 添加按钮
    UIButton *statusButton = [[UIButton alloc] init];
    statusButton.frame =  CGRectMake(0, 0, scroView_w, scroView_h);
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
    [scroView addSubview:statusButton];
    
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
//获取当前屏幕显示的viewcontroller
- (UIViewController*)getViewControllerInView:(UIView *)view{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
