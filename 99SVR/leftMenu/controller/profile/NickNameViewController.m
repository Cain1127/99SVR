//
//  NickNameViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/17.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "NickNameViewController.h"
#import "UserInfo.h"
#import "ZLLogonServerSing.h"

@interface NickNameViewController ()<UITextFieldDelegate>
/** 昵称输入框 */
@property(nonatomic,strong) UITextField *nickNameTextField;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"修改昵称"];
    [self setupView];
}

- (void)setupView
{
    self.view.backgroundColor = kTableViewBgColor;
    
    //输入框底层
    UIView *inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.frame = CGRectMake(0, 74, kScreenWidth, 48);
    [self.view addSubview:inputView];
    
    //昵称输入框
    _nickNameTextField = [[UITextField alloc] init];
    _nickNameTextField.placeholder = @"请输入昵称";
    _nickNameTextField.delegate = self;
    _nickNameTextField.font = kFontSize(14);
    _nickNameTextField.textColor = [UIColor blackColor];
    _nickNameTextField.keyboardType = UIKeyboardTypeDefault;
    _nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nickNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_nickNameTextField setValue:kFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    [_nickNameTextField setValue:RGB(151, 151, 151) forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_nickNameTextField];
    _nickNameTextField.frame = CGRectMake(12, 74, kScreenWidth - 2 * 12, 48);
    
    //建议提醒文字
    UILabel * adviceLabel = [[UILabel alloc] init];
    adviceLabel.text = @"昵称支持4-20中英文、数字及下划线组合";
    adviceLabel.textColor = [UIColor blackColor];
    adviceLabel.font = kFontSize(14);;
    adviceLabel.numberOfLines = 0;
    adviceLabel.frame = CGRectMake(12, CGRectGetMaxY(_nickNameTextField.frame), kScreenWidth - 12*2, 30);
    [self.view addSubview:adviceLabel];

    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setTitle:@"保存" forState:UIControlStateNormal];
    [btnRight setBackgroundColor:UIColorFromRGB(0x7fbbee)];
    [self.view addSubview:btnRight];
    btnRight.frame = Rect(10,_nickNameTextField.y+_nickNameTextField.height+30, kScreenWidth-20, 40);
    [btnRight setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  完成
 */
- (void)rightItemClick
{
    NSString *strMsg = _nickNameTextField.text;
    if ([strMsg length]==0) {
        [MBProgressHUD showError:@"昵称不能为空"];
        return ;
    }
    ZLLogonServerSing *sing = [ZLLogonServerSing sharedZLLogonServerSing];
    [sing updateNick:strMsg intro:[UserInfo sharedUserInfo].strIntro];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updatePro:(NSNotification *)notify
{
    NSString *strMsg = _nickNameTextField.text;
    __weak NSString *__strMsg = strMsg;
    NSNumber *number = notify.object;
    if ([number intValue]==0) {
        @WeakObj(self)
        gcd_main_safe(^{
            [MBProgressHUD showSuccess:@"修改昵称成功"];
            [selfWeak.navigationController popViewControllerAnimated:YES];
            selfWeak.nickNameBlock(__strMsg);
        });
    }
    else
    {
        @WeakObj(self)
        gcd_main_safe(^{
            [MBProgressHUD showError:@"修改昵称出错"];
            [selfWeak.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePro:) name:MEESAGE_LOGIN_SET_PROFILE_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
