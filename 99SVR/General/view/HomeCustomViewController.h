//
//  HomeCustomViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCustomViewController : UIViewController


@property (nonatomic,strong) UILabel *txtTitle;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,weak) UIButton *btnLeft;
@property (nonatomic,weak) UIButton *btnRight;

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
