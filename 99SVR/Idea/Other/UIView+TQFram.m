//
//  UIView+TQFram.m
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 white flag. All rights reserved.
//

#import "UIView+TQFram.h"

@implementation UIView (TQFram)

+(instancetype)viewFromXib
{
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
}

-(BOOL)TQ_intersectWithView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    CGRect rect1 = [self convertRect:self.bounds toView:nil];
    CGRect rect2 = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(rect1, rect2);
}


-(void)setTQ_x:(CGFloat)TQ_x
{
    CGRect fram = self.frame;
    fram.origin.x = TQ_x;
    self.frame = fram;
}
-(CGFloat)TQ_x
{
    return self.frame.origin.x;
}
-(void)setTQ_y:(CGFloat)TQ_y
{
    CGRect fram = self.frame;
    fram.origin.y = TQ_y;
    self.frame = fram;
}
-(CGFloat)TQ_y
{
    return self.frame.origin.y;
}

-(void)setTQ_width:(CGFloat)TQ_width
{
    CGRect fram = self.frame;
    fram.size.width = TQ_width;
    self.frame = fram;

}

-(CGFloat)TQ_width
{
    return self.frame.size.width;
}


-(void)setTQ_height:(CGFloat)TQ_height
{
    CGRect fram = self.frame;
    fram.size.height = TQ_height;
    self.frame = fram;
    
}

-(CGFloat)TQ_height
{
    return self.frame.size.height;
}

-(void)setTQ_centerX:(CGFloat)TQ_centerX
{
    CGPoint center = self.center;
    center.x = TQ_centerX;
    self.center = center;

}

-(CGFloat)TQ_centerX
{
    return self.center.x;
}

-(void)setTQ_centerY:(CGFloat)TQ_centerY
{
    CGPoint center = self.center;
    center.y = TQ_centerY;
    self.center = center;
    
}

-(CGFloat)TQ_centerY
{
    return self.center.y;
}





@end
