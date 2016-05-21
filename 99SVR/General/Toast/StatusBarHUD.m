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
@property (nonatomic , assign) __block int showCount;
@end

@implementation StatusBarHUD

+ (StatusBarHUD *)shared
{
    static dispatch_once_t once = 0;
    static StatusBarHUD *statusBarHUD;
    dispatch_once(&once, ^{
        
        statusBarHUD = [[StatusBarHUD alloc] init];
        statusBarHUD.showCount = 0;
    });
    return statusBarHUD;
}

- (void)hudCreate:(UIImage *)image text:(NSString *)text bgColor:(UIColor *)bgColor belowSubview:(UIView *)belowSubview
{
 
    self.showCount ++;
    
    if (self.showCount==1) {
        
        CGFloat scroView_w = belowSubview.frame.size.width;
        CGFloat scroView_h = 44;
        UIViewController *viewController =[self parentControllerWithView:belowSubview];
        CGFloat navBarMaxY = CGRectGetMaxY(viewController.navigationController.navigationBar.frame);
        UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:(CGRect){0,navBarMaxY,scroView_w,scroView_h}];
        scroView.userInteractionEnabled = NO;
        scroView.contentSize = (CGSize){scroView_w,scroView_h*3.0};
        [belowSubview addSubview:scroView];
        [belowSubview bringSubviewToFront:scroView];
        [scroView setContentOffset:(CGPoint){0,scroView_h*3}];
        
        // 添加按钮
        UIButton *statusButton = [[UIButton alloc] init];
        statusButton.frame =  CGRectMake(0, scroView_h, scroView_w, scroView_h);
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
        
        
        
        __weak typeof(scroView) weakScroView = scroView;
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:1.0 animations:^{
            
            [weakScroView setContentOffset:(CGPoint){0,scroView_h}];
            
        } completion:^(BOOL finished) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:1 animations:^{
                    
                    [weakScroView setContentOffset:(CGPoint){0,scroView_h*3}];
                } completion:^(BOOL finished) {
                    [weakScroView removeFromSuperview];
                    weakSelf.showCount = 0;
                }];
            });
        }];
    }
    
    
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

- (UIViewController *)parentControllerWithView:(UIView *)view
{
    UIResponder *responder = [view nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end
