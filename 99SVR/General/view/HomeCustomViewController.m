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
#import "LoginViewController.h"
#import "UIImage+RGB.h"

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

- (void)loadInfo:(NSNotification *)notify
{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.readBtn showNumber:KUserSingleton.nUnRead];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_readBtn showNumber:KUserSingleton.nUnRead];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = ThemeSkinManagers.navBarColor;
    
    _txtTitle = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [_txtTitle setFont:XCFONT(15)];
    [_headView addSubview:_txtTitle];
    [_txtTitle setTextAlignment:NSTextAlignmentCenter];
    [_txtTitle setTextColor:ThemeSkinManagers.navBarTitColor];
    
    if ([UserInfo sharedUserInfo].nStatus)
    {
        _readBtn = [[UnReadButton alloc] initWithFrame:Rect(0, 20, 44, 44)];
        [_readBtn addTarget:self action:@selector(MailBoxEvent) forControlEvents:UIControlEventTouchUpInside];
        // 设置图片
        UIImage *img = [UIImage imageNamed:ThemeSkinManagers.navBarLBtnNImage];
        [_readBtn setImage:img forState:UIControlStateNormal];
        [_readBtn setImage:[UIImage imageNamed:ThemeSkinManagers.navBarLBtnHImage] forState:UIControlStateHighlighted];
        [_headView addSubview:_readBtn];
    }
    UIButton *btnRight = [CustomViewController itemWithTarget:self action:@selector(searchViewController) image:ThemeSkinManagers.navBarRBtnNImage highImage:ThemeSkinManagers.navBarRBtnHImage];
    [_headView addSubview:btnRight];
    [btnRight setFrame:Rect(kScreenWidth-44, 20, 44, 44)];
    _btnRight = btnRight;
    _headLine = [[UILabel alloc] initWithFrame:Rect(0, 63.5, kScreenWidth, 0.5)];
    [_headLine setBackgroundColor:COLOR_Line_Big_Gay];
    [self.view addSubview:_headLine];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInfo:) name:MESSAGE_UNREAD_NUMBER_VC object:nil];
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
- (void)setTitleTextColor:(UIColor *)titleColor{
    
    [_txtTitle setTextColor:titleColor];

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

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark 切换皮肤
-(void)changeNavBarThemeSkin{
    
    //标题的颜色
    [_txtTitle setTextColor:ThemeSkinManagers.navBarTitColor];

    //左边按钮
    [_readBtn setImage:[UIImage imageNamed:ThemeSkinManagers.navBarLBtnNImage] forState:UIControlStateNormal];
    [_readBtn setImage:[UIImage imageNamed:ThemeSkinManagers.navBarLBtnHImage] forState:UIControlStateHighlighted];
    
    //右边按钮
    [_btnRight setImage:[UIImage imageNamed:ThemeSkinManagers.navBarRBtnNImage] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:ThemeSkinManagers.navBarLBtnHImage] forState:UIControlStateHighlighted];
}


@end
