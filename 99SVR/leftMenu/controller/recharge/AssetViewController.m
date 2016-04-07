//
//  AssetViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/10.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "AssetViewController.h"
#import "NSString+Size.h"
#import "UserInfo.h"
#import "PaySelectViewController.h"

#import "InAppPurchasesViewController.h"

@interface AssetViewController ()

/**
 *  @author yangshengmeng, 16-03-31 22:03:07
 *
 *  @brief  用来区分是跳转到苹果内购页面：YES-跳转苹果内购页面进行采购金币，NO-跳转的是公司支付页面
 *
 *  @since  v1.0.0
 */
@property (nonatomic, assign) BOOL isInAppPurchases;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *amountLabel;

@end

@implementation AssetViewController

@synthesize amountLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtTitle.text = @"我的资产";
    
    ///初始化时默认采用苹果内购
    self.isInAppPurchases = YES;
    
    [self initSubviews];
}

// 初始化View
- (void)initSubviews{
    
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.tintColor = UIColorFromRGB(0x555555);
    titleLable.frame = Rect(30,15+kNavigationHeight,80,25);
    titleLable.font = XCFONT(15);
    titleLable.text = @"玖玖币";
    [self.view addSubview:titleLable];
    
    amountLabel = [[UILabel alloc] init];
    amountLabel.tintColor = UIColorFromRGB(0x555555);
    NSString *strText = [NSString stringWithFormat:@"%.01f币",[UserInfo sharedUserInfo].goldCoin];
    amountLabel.text = strText;
    amountLabel.font = XCFONT(15);
    amountLabel.tintColor = UIColorFromRGB(0x555555);
    CGFloat fWidth = [amountLabel.text sizeMakeWithFont:XCFONT(15)].width+10;
    CGFloat amountLabelX = ScreenWidth - 30 - fWidth;
    amountLabel.frame = Rect(amountLabelX, 80,fWidth, 25);
    [self.view addSubview:amountLabel];
    
    [self createLabelWithRect:Rect(30, CGRectGetMaxY(titleLable.frame),80, 1)];
    
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:rechargeButton];
    rechargeButton.frame = Rect(30, CGRectGetMaxY(titleLable.frame) + 40, kScreenWidth-60, 40);
    [rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rechargeButton setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [rechargeButton setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    rechargeButton.layer.masksToBounds = YES;
    rechargeButton.layer.cornerRadius = 3;
    [rechargeButton addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshGoid
{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.amountLabel setText:[NSString stringWithFormat:@"%.01f币",[UserInfo sharedUserInfo].goldCoin]];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoid) name:MEESAGE_LOGIN_SET_PROFILE_VC object:nil];
}

- (void)createLabelWithRect:(CGRect)frame
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(frame.origin.x,frame.origin.y+frame.size.height+10,kScreenWidth-frame.origin.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
}

- (UITextField *)createTextField:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [self.view addSubview:textField];
    [textField setTextColor:UIColorFromRGB(0x555555)];
    [textField setFont:XCFONT(15)];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textField setClearButtonMode:UITextFieldViewModeAlways];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    return textField;
}

/**
 *  跳转去充值
 */
- (void)rechargeClick
{
    ///默认进入苹果的内购页面
    if ([UserInfo sharedUserInfo].nStatus)
    {
        PaySelectViewController *paySelectVC = [[PaySelectViewController alloc] init];
        [self.navigationController pushViewController:paySelectVC animated:YES];
    }
    else
    {
        InAppPurchasesViewController *inAppPurechasesVC = [[InAppPurchasesViewController alloc] init];
        [self.navigationController pushViewController:inAppPurechasesVC animated:YES];
    }
    
    ///进入公司集成的支付系统
}


- (void)dealloc
{
    DLog(@"dealloc");
}

@end
