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

@interface NickNameViewController()<UITextFieldDelegate>
/** 昵称输入框 */
@property(nonatomic,strong) UITextField *nickNameTextField;
/**修改昵称按钮*/
@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"修改昵称"];
    [self setupView];
    
    if (_nickName) {
        _nickNameTextField.text = _nickName;
        [self checkLogBtnIsEnableWithText:_nickName];
    }
}

- (void)setupView
{
    self.view.backgroundColor = kTableViewBgColor;
    
    //输入框底层
    UIView *inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
    inputView.layer.borderWidth = 0.5;
    inputView.frame = CGRectMake(0, 84, kScreenWidth, 48);
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
    [_nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _nickNameTextField.frame = CGRectMake(12, 84, kScreenWidth - 2 * 12, 48);
    
    //建议提醒文字
//    UILabel * adviceLabel = [[UILabel alloc] init];
//    adviceLabel.text = @"昵称支持4-20中英文、数字及下划线组合";
//    adviceLabel.textColor = [UIColor blackColor];
//    adviceLabel.font = kFontSize(14);;
//    adviceLabel.numberOfLines = 0;
//    adviceLabel.frame = CGRectMake(12, CGRectGetMaxY(_nickNameTextField.frame), kScreenWidth - 12*2, 30);
//    [self.view addSubview:adviceLabel];

    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setTitle:@"保存" forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    
    btnRight.layer.cornerRadius = 2.5;
    btnRight.layer.masksToBounds = YES;
    
    [self.view addSubview:btnRight];
    self.commitBtn = btnRight;
    [self checkLogBtnIsEnableWithText:self.nickNameTextField.text];
    btnRight.frame = Rect(10,_nickNameTextField.y+_nickNameTextField.height+30, kScreenWidth-20, 40);
    [btnRight setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
}


-(void)textFieldDidChange:(id)sender{
    
    [self checkLogBtnIsEnableWithText:self.nickNameTextField.text];
    
}

/**
 *  检测loginBtn是否可点击
 */
-(void)checkLogBtnIsEnableWithText:(NSString *)text{
    
    BOOL isTextBool;
    
    if (([text isEqualToString:@""]||[text length]==0)) {
        
        isTextBool = NO;
        
    }else{
        isTextBool = YES;
    }
    self.commitBtn.enabled = isTextBool;
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
    [sing updateNick:strMsg intro:[UserInfo sharedUserInfo].strIntro sex:[UserInfo sharedUserInfo].sex];
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
        gcd_main_safe(^{
            [MBProgressHUD showError:@"修改昵称出错"];
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
