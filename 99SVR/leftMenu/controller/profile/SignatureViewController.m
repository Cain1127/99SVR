//
//  SignatureViewController.m
//  99SVR
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "SignatureViewController.h"
#import "ZLLogonServerSing.h"
#import "UserInfo.h"

@interface SignatureViewController ()<UITextFieldDelegate>

///最新签名信息输入框
@property(nonatomic,strong) UITextField *signatureTextField;

@property (nonatomic, strong) UIButton *commitBtn;


@end

@implementation SignatureViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setTitleText:@"修改个性签名"];
     
    [self setupView];
}

- (void)setupView
{
    self.view.backgroundColor = kTableViewBgColor;
    
    //签名输入框
    _signatureTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0f, 64.0f + 10.0f, kScreenWidth - 2.0f * 12.0f, 150.0f)];
    _signatureTextField.placeholder = @"请输入签名";
    _signatureTextField.delegate = self;
    _signatureTextField.font = kFontSize(14);
    _signatureTextField.textColor = [UIColor blackColor];
    _signatureTextField.keyboardType = UIKeyboardTypeDefault;
    _signatureTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _signatureTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_signatureTextField setValue:kFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    [_signatureTextField setValue:RGB(151, 151, 151) forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_signatureTextField];
    [_signatureTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    //建议提醒文字
//    UILabel * adviceLabel = [[UILabel alloc] init];
//    adviceLabel.text = @"昵称支持4-20中英文、数字及下划线组合";
//    adviceLabel.textColor = [UIColor blackColor];
//    adviceLabel.font = kFontSize(14);;
//    adviceLabel.numberOfLines = 0;
//    adviceLabel.frame = CGRectMake(12, CGRectGetMaxY(_signatureTextField.frame), kScreenWidth - 12*2, 30);
//    [self.view addSubview:adviceLabel];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setTitle:@"保存" forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    [self.view addSubview:btnRight];
    self.commitBtn = btnRight;
    [self checkLogBtnIsEnableWithText:self.signatureTextField.text];
    btnRight.frame = Rect(10,_signatureTextField.y+_signatureTextField.height+30, kScreenWidth-20, 40);
    [btnRight setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)textFieldDidChange:(id)sender{
    
    [self checkLogBtnIsEnableWithText:self.signatureTextField.text];
    
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
    NSString *strMsg = _signatureTextField.text;
    if ([strMsg length]==0) {
        [MBProgressHUD showError:@"个性签名不能为空"];
        return ;
    }
    ZLLogonServerSing *sing = [ZLLogonServerSing sharedZLLogonServerSing];
    [sing updateNick:[UserInfo sharedUserInfo].strName intro:strMsg sex:[UserInfo sharedUserInfo].sex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updatePro:(NSNotification *)notify
{
    NSString *strMsg = _signatureTextField.text;
    __weak NSString *__strMsg = strMsg;
    NSNumber *number = notify.object;
    if ([number intValue]==0) {
        @WeakObj(self)
        gcd_main_safe(^{
            [MBProgressHUD showSuccess:@"修改个性签名成功"];
            [selfWeak.navigationController popViewControllerAnimated:YES];
            selfWeak.signatureBlock(__strMsg);
        });
    }
    else
    {
        gcd_main_safe(
            ^{
            [MBProgressHUD showError:@"修改个性签名出错"];
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
