//
//  UIImage+RGB.m
//  99SVR
//
//  Created by 刘海东 on 16/5/27.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "UIImage+RGB.h"

@implementation UIImage (RGB)
/**
 *  返回一个组合带渐变的颜色
 *
 *  @param colors       颜色数组
 *  @param gradientType 渐变的方向类型 0,//从上到下 1,//从左到右 2,//左到右 3,//右到左
 *  @param frame        frame
 *
 *  @return  返回一个组合带渐变的颜色
 */
+(UIImage *)imageFromColors:(NSArray *)colors byGradientType:(NSInteger)gradientType withFrame:(CGRect)frame{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0://上到下
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, frame.size.height);
            break;
        case 1://下到上
            start = CGPointMake(0.0, frame.size.height);
            end = CGPointMake(0, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(frame.size.width,frame.size.height);
            break;
        case 3:
            start = CGPointMake(frame.size.width, 0.0);
            end = CGPointMake(0.0, frame.size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
