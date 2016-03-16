//
//  UIView+Frame.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
// shortcuts for frame properties
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;


@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

-(void)radiusCilck;  //画圆
-(void)CABasicAnimation; //颤抖

#pragma mark - ============活动指示器============================
-(void)showActivityInView:(CGPoint )point;
-(void)hiddenActivityInView;

// 滑动
@property(nonatomic,assign)CGFloat ttx;
@property(nonatomic,assign)CGFloat tty;

@end
