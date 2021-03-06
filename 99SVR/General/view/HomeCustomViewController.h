//
//  HomeCustomViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFBaseViewController.h"
#import "UnReadButton.h"

@interface HomeCustomViewController : GFBaseViewController

@property (nonatomic,strong) UnReadButton *readBtn;
@property (nonatomic,strong) UILabel *txtTitle;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,weak) UIButton *btnLeft;
@property (nonatomic,weak) UIButton *btnRight;
@property (nonatomic,strong) UILabel *headLine;

- (void)setHeadViewHidden:(BOOL)bFlag;
- (void)setViewBgColor:(UIColor *)bgColor;
- (void)setTitleText:(NSString *)strText;
- (void)setTitleTextColor:(UIColor *)titleColor;
- (void)setLeftBtn:(UIButton *)btnLeft;
- (void)setRightBtn:(UIButton *)btnRight;
- (void)setUserInter;
- (void)setHeadBackGroup:(UIColor *)color;
- (void)addDefaultHeader:(NSString *)title;
- (void)setLineHidden:(BOOL)bHidden;
/**切换皮肤*/
-(void)changeNavBarThemeSkin;

+ (UIButton *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
+ (UIButton *)itemWithTarget:(id)target action:(SEL)action title:(NSString*)title;



@end
