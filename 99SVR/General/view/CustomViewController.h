//
//  CustomViewController.h
//  FreeCar
//
//  Created by xiongchi on 15/8/1.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIViewController

@property (nonatomic,strong) UILabel *txtTitle;

- (void)setHeadViewHidden:(BOOL)bFlag;
- (void)setViewBgColor:(UIColor *)bgColor;
- (void)setTitleText:(NSString *)strText;
- (void)setLeftBtn:(UIButton *)btnLeft;
- (void)setRightBtn:(UIButton *)btnRight;
- (void)setUserInter;
- (void)setHeadBackGroup:(UIColor *)color;
- (void)addDefaultHeader:(NSString *)title;
- (void)setLineHidden:(BOOL)bHidden;

+ (UIButton *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
+ (UIButton *)itemWithTarget:(id)target action:(SEL)action title:(NSString*)title;


@end
