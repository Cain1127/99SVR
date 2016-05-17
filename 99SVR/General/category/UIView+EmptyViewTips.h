//
//  UIView+EmptyViewTips.h
//  99SVR
//
//  Created by jiangys on 16/5/17.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EmptyViewTips)

+ (UIView *)initWithFrame:(CGRect)frame message:(NSString *)message;

+ (UIView *)initWithFrame:(CGRect)frame imageName:(NSString *)imageName message:(NSString *)message;

@end
