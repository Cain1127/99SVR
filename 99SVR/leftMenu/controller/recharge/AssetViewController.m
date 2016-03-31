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

@interface AssetViewController ()


@property (nonatomic,weak) UILabel *titleLable;
@property (nonatomic,weak) UILabel *amountLabel;

@end

@implementation AssetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtTitle.text = @"我的资产";
    
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
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.tintColor = UIColorFromRGB(0x555555);
    NSString *strText = [NSString stringWithFormat:@"%.01f币",[UserInfo sharedUserInfo].goldCoin];
    amountLabel.text = strText;
    amountLabel.font = XCFONT(15);
    amountLabel.tintColor = UIColorFromRGB(0x555555);
    CGSize amountLabelSize = [amountLabel.text sizeMakeWithFont:XCFONT(15)];
    CGFloat amountLabelX = ScreenWidth - 30 - amountLabelSize.width;
    amountLabel.frame = Rect(amountLabelX, 80,amountLabelSize.width, 25);
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
    PaySelectViewController *paySelectVc = [[PaySelectViewController alloc] init];
    [self.navigationController pushViewController:paySelectVc animated:YES];
}


- (void)dealloc
{
    DLog(@"dealloc");
}

@end
