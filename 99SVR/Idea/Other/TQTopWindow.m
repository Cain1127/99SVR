//
//  TQTopWindow.m
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 white flag. All rights reserved.
//

#import "TQTopWindow.h"

@interface TQTopviewController : UIViewController
@property (nonatomic ,strong) void (^statusBarCilckBlock)();
@end

@implementation TQTopviewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.statusBarCilckBlock) self.statusBarCilckBlock();
    
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end


@implementation TQTopWindow

static TQTopWindow *_topWindow;

+(void)showWithStatusBarCilickBlock:(void(^)())block

{
    _topWindow = [[TQTopWindow alloc] init];
    _topWindow.windowLevel = UIWindowLevelAlert;
    _topWindow.backgroundColor = [UIColor clearColor];
    _topWindow.hidden = NO;
    
    TQTopviewController *topVC = [[TQTopviewController alloc] init];
    topVC.view.backgroundColor = [UIColor clearColor];
    topVC.view.frame = [UIApplication sharedApplication].statusBarFrame;
    topVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topVC.statusBarCilckBlock = block;
    _topWindow.rootViewController = topVC;
    
    
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
     if (point.y > 20) return nil;
        
     return [super hitTest:point withEvent:event];
        
}







@end
