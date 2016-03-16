//
//  UIView+Frame.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
#pragma mark - Shortcuts for the coords

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - Shortcuts for frame properties

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
#pragma mark - Shortcuts for positions

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

-(void)radiusCilck{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width/2;
}
-(void)CABasicAnimation{
    
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = [NSNumber numberWithFloat:-5];
    shake.toValue = [NSNumber numberWithFloat:5];
    shake.byValue = [NSNumber numberWithFloat:1];
    shake.duration = 0.2;//执行时间
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 1;//次数
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
    
}

#pragma mark - ============活动指示器============================
-(void)showActivityInView:(CGPoint )point
{
    [self showActivityInView:self style:UIActivityIndicatorViewStyleWhite point:point];
}

-(void)showActivityInView:(UIView *)View style:(UIActivityIndicatorViewStyle)style point:(CGPoint )point
{
    UIActivityIndicatorView *activity = nil;
    for (UIActivityIndicatorView *act in View.subviews) {
        if ([act isKindOfClass:[UIActivityIndicatorView class]]) {
            activity = act;
        }
    }
    
    if (!activity) {
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        activity.center=point;
        [View addSubview:activity];
    }
    
    [activity startAnimating];
}

-(void)hiddenActivityInView
{
    if (self==nil) {
        return;
    }
    for (UIActivityIndicatorView *Design in self.subviews) {
        if ([Design isKindOfClass:[UIActivityIndicatorView class]]) {
            [Design stopAnimating];
        }
    }
}

// 滑动
-(CGFloat)ttx{
    return self.transform.tx;
}

-(void)setTtx:(CGFloat)ttx{
    CGAffineTransform  transform=self.transform;
    transform.tx=ttx;
    self.transform=transform;
    
    
}

-(CGFloat)tty{
    return self.transform.ty;
}

-(void)setTty:(CGFloat)tty{
    CGAffineTransform  transform=self.transform;
    transform.ty=tty;
    self.transform=transform;
}


@end
