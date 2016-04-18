//
//  UIView+TQFram.h
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 white flag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TQFram)
// 在分类中@property 仅仅会生成set get 方法,并不会成成下划线的成员属性

@property (nonatomic ,assign) CGFloat TQ_x;
@property (nonatomic ,assign) CGFloat TQ_y;
@property (nonatomic ,assign) CGFloat TQ_width;
@property (nonatomic ,assign) CGFloat TQ_height;
@property (nonatomic ,assign) CGFloat TQ_centerX;
@property (nonatomic ,assign) CGFloat TQ_centerY;

-(BOOL)TQ_intersectWithView:(UIView *)view;

+(instancetype)viewFromXib;

@end
