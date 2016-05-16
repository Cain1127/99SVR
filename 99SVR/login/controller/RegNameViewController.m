//
//  RegNameViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 2/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RegNameViewController.h"
#import "QCheckBox.h"
#import "RoomViewController.h"
#import "UserInfo.h"
#import "Toast+UIView.h"
#import "NNSVRViewController.h"
#import "BaseService.h"
#import "ZLLogonServerSing.h"
#import "ProgressHUD.h"
#import "DecodeJson.h"
#import "NSString+Regex.h"
@interface RegNameViewController ()<UITextFieldDelegate>
{
    NSString *strDate;
}

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,strong) UIButton *btnCode;
/**注册*/
@property (nonatomic, strong) UIButton *btnDetermine;

@property (nonatomic,strong) UIImageView *imgView;
/**用户名*/
@property (nonatomic,strong) RegisterTextField *txtName;
/**密码*/
@property (nonatomic,strong) RegisterTextField *txtPwd;
/**再次输入密码*/
@property (nonatomic,strong) RegisterTextField *txtCmd;
@property (nonatomic,copy) NSString *strCode;
@property (nonatomic,strong) QCheckBox *checkAgree;

@end

@implementation RegNameViewController
- (void)registerServer
{
    // 退出键盘
    [self.view endEditing:YES];
    
    if (strDate==nil)
    {
        return ;
    }
    _username = _txtName.text;
    if ([_username length]==0)
    {
        [ProgressHUD showError:@"用户名不能为空"];
        return ;
    }
    int flag = [self MatchLetter:_username];
    if (flag==0)
    {
        [ProgressHUD showError:@"用户名第一位必须是字母"];
        return ;
    }
    else if(flag == -1)
    {
        [ProgressHUD showError:@"用户名只能包含数字、字母、下划线"];
        return ;
    }
    _password = _txtPwd.text;
    if ([_password length]==0)
    {
        [ProgressHUD showError:@"密码不能为空"];
        return ;
    }
    if (![_txtPwd.text isEqualToString:_txtCmd.text]) {
        [ProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    if (!_checkAgree.checked) {
        [ProgressHUD showError:@"必须同意《用户服务协议》和《隐私权条款》"];
        return ;
    }
    
    //判断密码是否为空 并且是在6到16位
    if (!([_txtPwd.text isPassword] && [_txtCmd.text isPassword])) {
        [ProgressHUD showError:@"密码包含空格或密码长度不为6到16个字符"];
        _txtPwd.text = @"";
        _txtCmd.text = @"";
        [_txtName becomeFirstResponder];
        [self checkLogBtnIsEnableWithPwd:_txtPwd.text withCmdPwd:_txtCmd.text withUser:_txtName.text];
        return ;
    }
    
    [self.view makeToastActivity_bird];
    NSString *strMd5 = [NSString stringWithFormat:@"action=reg&account=%@&date=%@",_username,strDate];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    NSString *strInfo = [NSString stringWithFormat:@"%@User/registerMulti",[kHTTPSingle getHttpApi]];
    NSDictionary *parameters = @{@"account":_username,@"key":strMd5,@"pwd":_password,@"type":@"21"};
//    __weak LSTcpSocket *__tcpSocket = [LSTcpSocket sharedLSTcpSocket];
    @WeakObj(self)
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         [selfWeak.view hideToastActivity];
         if ([dict objectForKey:@"status"] && [[dict objectForKey:@"status"] intValue]==0)
         {
             [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:selfWeak.username pwd:selfWeak.password];
             [selfWeak navBack];
             [ProgressHUD showSuccess:@"注册成功"];
         }
         else
         {
                 NSString *strNull = [dict objectForKey:@"info"];
                 if(strNull)
                 {
                     [ProgressHUD showError:[dict objectForKey:@"info"]];
                 }
                 else
                 {
                     [ProgressHUD showError:@"服务器异常"];
                 }
         }
     }fail:^(NSError *error)
     {
         [selfWeak.view hideToastActivity];
         [ProgressHUD showError:@"连接服务器失败"];
         NSString *strUrl = [NSString stringWithFormat:@"ReportItem=Register&ClientType=2&RegType=2&ServerIP=%@&Error=%@",
                             @"120.55.105.224",@"err_fail"];
         [DecodeJson postPHPServerMsg:strUrl];
     }];
}

-(int)MatchLetter:(NSString *)str
{
    //判断是否以字母开头
    NSString *ZIMU = @"^[^a-zA-Z][a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    if ([regextestmobile evaluateWithObject:str]==YES)
    {
        DLog(@"账号第一为只能是字符");
        return 0;
    }
    ZIMU = @"^[a-zA-Z][a-zA-Z0-9_\u4e00-\u9fa5]+$";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    if([regextestmobile evaluateWithObject:str]==YES)
    {
        return 1;
    }
    DLog(@"用户名只能包含数字、字母、下划线");
    return -1;
}

- (void)addLineHeight:(UILabel *)lblTemp
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(lblTemp.x,lblTemp.y+lblTemp.height+10,kScreenWidth-lblTemp.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
}

- (UILabel *)createLabelWithRect:(CGRect)frame
{
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:frame];
    [self.view addSubview:lbl1];
    [lbl1 setFont:XCFONT(14)];
    [lbl1 setTextColor:UIColorFromRGB(0x343434)];
    [self addLineHeight:lbl1];
    return lbl1;
}

- (RegisterTextField *)createTextField:(CGRect)frame
{
    RegisterTextField *textField = [[RegisterTextField alloc] initWithFrame:frame];
    [self.view addSubview:textField];
    [textField setTextColor:UIColorFromRGB(0x555555)];
    [textField setFont:XCFONT(15)];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textField setClearButtonMode:UITextFieldViewModeAlways];
    [textField setKeyboardType:UIKeyboardTypeASCIICapable];
    return textField;
}

- (void)navBack
{
    NSArray *aryIndex = self.navigationController.viewControllers;
    for (UIViewController *control in aryIndex) {
        if ([control isKindOfClass:[RoomViewController class]]) {
            [self.navigationController popToViewController:control animated:YES];
            return ;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initUIHead
{
    [self createLabelWithRect:Rect(10, 80, kScreenWidth-20, 30)];
    _txtName = [self createTextField:Rect(10, 80, kScreenWidth-20, 30)];
    _txtName.leftViewImageName = @"register_mob";

    [_txtName setPlaceholder:@"请输入用户名"];
    
    [self createLabelWithRect:Rect(10, _txtName.y+50,kScreenWidth-20, 30)];
    _txtPwd = [self createTextField:Rect(_txtName.x,_txtName.y+50,kScreenWidth-20,_txtName.height)];
    _txtPwd.leftViewImageName = @"register_pwd";
    _txtPwd.isShowTextBool = YES;
    [_txtPwd setPlaceholder:@"请输入密码"];
    [_txtPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    
    CGRect frame;
    
    frame.origin.y = _txtPwd.y+50;
    
    [self createLabelWithRect:Rect(10, frame.origin.y, kScreenWidth-20, 30)];
    _txtCmd = [self createTextField:Rect(10, frame.origin.y, kScreenWidth-20, 30)];
    _txtCmd.delegate = self;
    [_txtCmd setPlaceholder:@"请重复输入密码"];
    _txtCmd.isShowTextBool = YES;
    _txtCmd.leftViewImageName = @"register_pwd_ok";
    frame.origin.y = _txtCmd.y+50;
    [_txtCmd setSecureTextEntry:YES];

    [_txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtPwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtCmd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];


    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(30, _txtCmd.y+50, kScreenWidth-60, 40);
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];

    btnRegister.layer.masksToBounds = YES;
    btnRegister.layer.cornerRadius = 3;
    self.btnDetermine = btnRegister;
    [self checkLogBtnIsEnableWithPwd:_txtPwd.text withCmdPwd:_txtCmd.text withUser:_txtName.text];
    [btnRegister addTarget:self action:@selector(registerServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
    
    _checkAgree = [[QCheckBox alloc] initWithDelegate:self];
    _checkAgree.frame = Rect(btnRegister.x, btnRegister.y+btnRegister.height+10,60,30);
    [_checkAgree setTitle:@"同意" forState:UIControlStateNormal];
    [_checkAgree setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [self.view addSubview:_checkAgree];
    _checkAgree.titleLabel.font = XCFONT(14);
    _checkAgree.checked = YES;
    
    UIButton *btnPro = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btnPri = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPro setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
    [btnPri setTitle:@"《隐私权条款》" forState:UIControlStateNormal];
    [btnPro setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateNormal];
    [btnPri setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateNormal];
    
    [self.view addSubview:btnPri];
    [self.view addSubview:btnPro];
    btnPri.titleLabel.font = XCFONT(14);
    btnPro.titleLabel.font = XCFONT(14);
    CGSize sizePro = [@"《用户服务协议》" sizeWithAttributes:@{NSFontAttributeName:XCFONT(14)}];
    CGSize sizePri = [@"《隐私权条款》" sizeWithAttributes:@{NSFontAttributeName:XCFONT(14)}];
    btnPro.frame = Rect(_checkAgree.x+_checkAgree.width+2, _checkAgree.y,sizePro.width,30);
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(btnPro.x+btnPro.width+3, _checkAgree.y,15,30)];
    [lblTemp setText:@"和"];
    [lblTemp setFont:XCFONT(14)];
    [lblTemp setTextColor:UIColorFromRGB(0x343434)];
    [self.view addSubview:lblTemp];
    
    btnPri.frame = Rect(btnPro.x+btnPro.width+18, _checkAgree.y, sizePri.width, 30);
    [btnPro addTarget:self action:@selector(openHttpView:) forControlEvents:UIControlEventTouchUpInside];
    [btnPri addTarget:self action:@selector(openHttpView:) forControlEvents:UIControlEventTouchUpInside];
    btnPro.tag = 101;
    btnPri.tag = 102;
    
}

- (void)closeKeyBoard
{
    [self.view endEditing:YES];
}


- (void)openHttpView:(UIButton *)btnSender
{
    NSString *strTitle;
    NSString *strPath;
    if (btnSender.tag==101)
    {
        strTitle = @"用户服务协议";
        strPath = @"http://www.99ducaijing.com/phone/appyhxy.aspx";
    }
    else if(btnSender.tag == 102)
    {
        strTitle = @"隐私权条款";
        strPath = @"http://www.99ducaijing.com/phone/appysxy.aspx";
    }
    NNSVRViewController *nnView = [[NNSVRViewController alloc] initWithPath:strPath title:strTitle];
    [self.navigationController pushViewController:nnView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self setTitleText:@"用户名注册"];
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    strDate = [fmt stringFromDate:date];
    [_txtName setDelegate:self];
    [_txtPwd setDelegate:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_txtName becomeFirstResponder];        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)textFieldDidChange:(id)sender{
    
    [self checkLogBtnIsEnableWithPwd:_txtPwd.text withCmdPwd:_txtCmd.text withUser:_txtName.text];
    
}


/**
 *  检测loginBtn是否可点击
 *
 *  @param pwdText  密码
 *  @param userText 账号
 */
-(void)checkLogBtnIsEnableWithPwd:(NSString *)pwdText withCmdPwd:(NSString *)cmdPwdText withUser:(NSString *)userText{
    
    BOOL isPwdBool;
    BOOL isUserBool;
    BOOL isCmdPwdBool;
    
    if (([pwdText isEqualToString:@""]||[pwdText length]==0)) {
        
        isPwdBool = NO;
        
    }else{
        isPwdBool = YES;
    }
    
    if (([userText isEqualToString:@""]||[userText length]==0)) {
        isUserBool = NO;
    }else{
        isUserBool = YES;
    }
    
    if (([cmdPwdText isEqualToString:@""]||[cmdPwdText length]==0)) {
        isCmdPwdBool = NO;
    }else{
        isCmdPwdBool = YES;
    }

    self.btnDetermine.enabled = (isPwdBool && isUserBool && isCmdPwdBool);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
        return YES;
    }
    if (_txtName == textField)
    {
        NSString *strCode = @"[a-zA-Z0-9_\u4e00-\u9fa5]+$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strCode];;
        if (range.location>16 || range.location+string.length>16 || ![predicate evaluateWithObject:string])
        {
            return NO;
        }
    }
    else if(_txtPwd == textField)
    {
        NSString *strCode = @"[^ ]+$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strCode];;
        if (range.location>16 || range.location+string.length>16 || ![predicate evaluateWithObject:string])
        {
            return NO;
        }
    }
    return YES;
}

@end
