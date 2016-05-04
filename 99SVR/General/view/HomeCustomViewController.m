//
//  HomeCustomViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HomeCustomViewController.h"
#import "TQMailboxViewController.h"
#import "SearchController.h"

@interface HomeCustomViewController()
{
    UILabel *_lblContent;
}

@end

@implementation HomeCustomViewController

+ (UIButton *)itemWithTarget:(id)target action:(SEL)action title:(NSString*)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = UIColorFromRGB(0xffffff);
    
    _txtTitle = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [_txtTitle setFont:XCFONT(16)];
    [_headView addSubview:_txtTitle];
    [_txtTitle setTextAlignment:NSTextAlignmentCenter];
    [_txtTitle setTextColor:UIColorFromRGB(0x4C4C4C)];
    
    UIButton *btnLeft = [CustomViewController itemWithTarget:self action:@selector(MailBoxEvent) image:@"nav_menu_icon_n" highImage:@"nav_menu_icon_p"];
    [_headView addSubview:btnLeft];
    [btnLeft setFrame:Rect(0,20,44,44)];
    _btnLeft = btnLeft;
    
    UIButton *btnRight = [CustomViewController itemWithTarget:self action:@selector(searchViewController) image:@"nav_search_icon_n" highImage:@"nav_search_icon_p"];
    [_headView addSubview:btnRight];
    [btnRight setFrame:Rect(kScreenWidth-44, 20, 44, 44)];
    _btnRight = btnRight;
    
}

- (void)MailBoxEvent
{
    TQMailboxViewController *mailBox = [[TQMailboxViewController alloc] init];
    [self.navigationController pushViewController:mailBox animated:YES];
}

- (void)searchViewController
{
    SearchController *mailBox = [[SearchController alloc] init];
    [self.navigationController pushViewController:mailBox animated:YES];
}

/**
 *  3月写的后退效果
 */
- (void)MarchBackLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

+ (UIButton *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    UIImage *img = [UIImage imageNamed:image];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    return btn;
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
    _btnLeft.frame = Rect(8, 20, 44, 44);
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
    [exitBtn addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)dealloc
{
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TABBAR_DISAPPER_VC object:nil];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_TABBAR_APPER_VC object:nil];
//}

@end
