//
//  UIColor+Ext.h
//  99SVR
//
//  Created by 邹宇彬 on 15/12/21.
//  Copyright (c) 2015年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Ext)

+ (UIColor *)colorWithHex:(NSString *)hexStr; // 16进制颜色转UIColor

+ (UIColor *)colorWithHex:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
