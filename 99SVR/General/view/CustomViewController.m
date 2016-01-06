//
//  CustomViewController.m
//  FreeCar
//
//  Created by xiongchi on 15/8/1.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "CustomViewController.h"
#import "UIView+Extension.h"

@interface CustomViewController ()
{
    UILabel *_lblContent;
}

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *btnLeft;
@property (nonatomic,strong) UIButton *btnRight;
@property (nonatomic,strong) UILabel *txtTitle;

@end

@implementation CustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = kNavColor;
    
    _txtTitle = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [_txtTitle setFont:XCFONT(16)];
    [_headView addSubview:_txtTitle];
    [_txtTitle setTextAlignment:NSTextAlignmentCenter];
    [_txtTitle setTextColor:[UIColor whiteColor]];
    
    _lblContent = [[UILabel alloc] initWithFrame:Rect(0, 63.5, kScreenWidth, 0.5)];
    [_lblContent setBackgroundColor:[UIColor whiteColor]];
    [_headView addSubview:_lblContent];
}

- (void)setUserInter
{
    _headView.userInteractionEnabled = NO;
}

- (void)setHeadBackGroup:(UIColor *)color
{
    [_headView setBackgroundColor:color];
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setViewBgColor:(UIColor *)bgColor
{
    [_headView setBackgroundColor:bgColor];
}

-(void)setTitleText:(NSString *)strText
{
    [_txtTitle setText:strText];
}
-(void)setLeftBtn:(UIButton *)btnLeft
{
    _btnLeft = btnLeft;
    _btnLeft.frame = Rect(5, 20, 44, 44);
    [_headView addSubview:_btnLeft];
}

-(void)setRightBtn:(UIButton *)btnRight
{
    _btnRight = btnRight;
    _btnRight.frame = Rect(_headView.width-44, 20, 44, 44);
    _btnRight.titleLabel.font = XCFONT(12);
    [_headView addSubview:_btnRight];
}

-(void)setHeadViewHidden:(BOOL)bFlag
{
    _headView.hidden = bFlag;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)addDefaultHeader:(NSString *)title
{
    _txtTitle.text = title;
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [exitBtn clickWithBlock:^(UIGestureRecognizer *gesture) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.headView addSubview:exitBtn];
    [self.headView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.left.equalTo(self.headView);
        make.bottom.equalTo(self.headView);
    }];
}

- (void)setLineHidden:(BOOL)bHidden
{
    [_lblContent setHidden:bHidden];
}

@end
