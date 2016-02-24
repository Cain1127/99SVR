//

//  LoginViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/7/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "LoginViewController.h"
#import "QCheckBox.h"
#import "Toast+UIView.h"
#import "SVRSocket.h"
#import "LSTcpSocket.h"
#import "NewViewController.h"
#import "LoginTextField.h"
#import "NNSVRViewController.h"
#import "ForgetPwdViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIView  *headView;
    BOOL _bLogin;
}
@property (nonatomic,strong) UIButton *btnLogin;
@property (nonatomic,strong) UIButton *btnRegin;
@property (nonatomic,strong) UIImageView *imgBg;
@property (nonatomic,strong) LoginTextField *txtUser;
@property (nonatomic,strong) LoginTextField *txtPwd;
@property (nonatomic,strong) QCheckBox *check;
@property (nonatomic,strong) QCheckBox *autoLogin;
@property (nonatomic,strong) UIButton *btnFind;

@end

@implementation LoginViewController

-(void)initUIHead
{
    
    headView = [[UIView alloc] initWithFrame:Rect(0, 0, self.view.width,64)];
    [self.view addSubview:headView];
    [headView setBackgroundColor:kNavColor];
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 30, kScreenWidth, 25)];
    [headView addSubview:lblName];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    __weak LoginViewController *__self = self;
    [exitBtn clickWithBlock:^(UIGestureRecognizer *gesture) {
        [__self dismissViewControllerAnimated:YES completion:nil];
    }];
    [headView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.left.equalTo(headView);
        make.bottom.equalTo(headView);
    }];
    
    [lblName setTextColor:[UIColor whiteColor]];
    [lblName setText:@"登录"];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    [lblName setFont:XCFONT(17)];
    [self.view setBackgroundColor:RGB(245, 245, 246)];
    
    UIView *bodyView = [[UIView alloc] initWithFrame:Rect(0, 64, kScreenWidth, 120)];
    [bodyView setBackgroundColor:RGB(235, 239, 244)];
    [self.view addSubview:bodyView];
    
    UILabel *lblView = [[UILabel alloc] initWithFrame:Rect(kScreenWidth/2-44, 60-44, 88, 88)];
    [lblView setBackgroundColor:RGB(234, 239, 244)];
    [bodyView addSubview:lblView];
    lblView.layer.borderWidth = 0.5;
    lblView.layer.borderColor =UIColorFromRGB(0xcfcfcf).CGColor;
    [lblView.layer setMasksToBounds:YES];
    [lblView.layer setCornerRadius:44];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [bodyView addSubview:logoImageView];
    [logoImageView setFrame:Rect(kScreenWidth/2-39, 60-39, 78,78)];
    
    _txtUser = [[LoginTextField alloc] initWithFrame:CGRectMake(15 + 32,bodyView.y+bodyView.height+30, kScreenWidth-30 - 32 * 2, 44)];
    _txtPwd = [[LoginTextField alloc] initWithFrame:CGRectMake(_txtUser.x, _txtUser.frame.origin.y+_txtUser.frame.size.height+10, _txtUser.width, 44)];
    
    [_txtUser setBorderStyle:UITextBorderStyleNone];
    [_txtPwd setBorderStyle:UITextBorderStyleNone];
    _txtUser.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtUser.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _txtUser.returnKeyType = UIReturnKeyDone;
    _txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    CGFloat imageWidth = 22;
    UIImageView *imgUser = [[UIImageView alloc] init];
    imgUser.frame = Rect(0, 0, imageWidth, imageWidth);
    imgUser.image = [UIImage imageNamed:@"login_icon1"];
    imgUser.contentMode = UIViewContentModeScaleAspectFit;
    
    [_txtUser setReturnKeyType:UIReturnKeyNext];
    [_txtUser setKeyboardType:UIKeyboardTypeASCIICapable];
    _txtUser.leftView = imgUser;
    _txtUser.leftViewMode = UITextFieldViewModeAlways;
    _txtUser.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_txtUser setTextColor:UIColorFromRGB(0x343434)];
    [_txtUser setBackgroundColor:[UIColor clearColor]];
    [_txtPwd setReturnKeyType:UIReturnKeyDone];
    [_txtPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    _txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView *imgPwd = [[UIImageView alloc] init];
    imgPwd.frame = Rect(0, 0, imageWidth, imageWidth);
    imgPwd.image = [UIImage imageNamed:@"login_icon2"];
    imgPwd.contentMode = UIViewContentModeScaleAspectFit;
    _txtPwd.leftView = imgPwd;
    
    _txtPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtPwd.leftViewMode = UITextFieldViewModeAlways;
    [_txtPwd setBackgroundColor:[UIColor clearColor]];
    [_txtPwd setTextColor:UIColorFromRGB(0x343434)];
    
    UIColor *color = [UIColor grayColor];
    _txtUser.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName: color}];
    _txtPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    
    _txtUser.delegate = self;
    _txtPwd.delegate = self;
    
    _txtUser.tag = 1;
    _txtPwd.tag = 2;
    
    [_txtPwd setSecureTextEntry:YES];
    [_txtUser setFont:XCFONT(15)];
    [_txtPwd setFont:XCFONT(15)];
    _check = [[QCheckBox alloc] initWithDelegate:self];
    _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRegin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFind = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btnLogin.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = 3;
    
    
    [_btnFind setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btnFind setTitleColor:RGB(15, 173, 225) forState:UIControlStateNormal];
    [_btnFind setTitle:@"找回密码" forState:UIControlStateNormal];
    _btnFind.titleLabel.font = XCFONT(12);
    CGSize findSize = [@"忘记密码" sizeWithAttributes:@{NSFontAttributeName:XCFONT(12)}];
    [_btnFind setFrame:Rect(kScreenWidth/2-findSize.width/2,_btnLogin.frame.origin.y+_btnLogin.frame.size.height+20, findSize.width,25)];
    
    [_btnLogin setTitle:@"登 录" forState:UIControlStateNormal];
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    _btnLogin.titleLabel.font = XCFONT(15);
    
    [_btnRegin setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [_btnRegin setTitleColor:RGB(252, 173, 113) forState:UIControlStateHighlighted];
    [_btnRegin setTitle:@"注册" forState:UIControlStateNormal];
    [_btnRegin setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    _btnRegin.titleLabel.font = XCFONT(12);
    [_btnRegin addTarget:self action:@selector(registerServver) forControlEvents:UIControlEventTouchUpInside];
    [_btnLogin addTarget:self action:@selector(loginServer) forControlEvents:UIControlEventTouchUpInside];
    [_btnFind addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_txtUser];
    [self.view addSubview:_txtPwd];
    [self.view addSubview:_btnLogin];
    [headView addSubview:_btnRegin];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithHex:@"#c9c9c9"];
    [self.view addSubview:line1];
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = line1.backgroundColor;
    [self.view addSubview:line2];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_txtUser.width, 0.5));
        make.left.equalTo(_txtUser);
        make.bottom.equalTo(_txtUser);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_txtPwd.width, 0.5));
        make.left.equalTo(_txtPwd);
        make.bottom.equalTo(_txtPwd);
    }];
    [_btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_txtUser.width, 45));
        make.left.equalTo(_txtPwd);
        make.top.mas_equalTo(_txtPwd.mas_bottom).offset(38);
    }];
    
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:[UIColor colorWithHex:@"555555"] forState:UIControlStateNormal];
    forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [forgetPwdBtn clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        [__self forgetPassword];
    }];
    [self.view addSubview:forgetPwdBtn];
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_btnLogin);
        make.top.mas_equalTo(_btnLogin.mas_bottom).offset(53);
    }];
}

- (void)forgetPassword
{
    ForgetPwdViewController *forget = [[ForgetPwdViewController alloc] init];
    [self presentViewController:forget animated:YES completion:nil];
}

-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

- (void)registerServver
{
    ForgetPwdViewController *forget = [[ForgetPwdViewController alloc] init];
    [self presentViewController:forget animated:YES completion:nil];
}

- (void)loginServer
{
    NSString *strUser = [_txtUser text];
    NSString *strPwd = [_txtPwd text];
    if ([strUser isEqualToString:@""] || [strUser length]==0) {
        [self.view makeToast:@"用户名不能为空"];
        _bLogin = NO;
        return ;
    }else if([strPwd isEqualToString:@""] || [strPwd length]==0)
    {
        _bLogin = NO;
        [self.view makeToast:@"密码不能为空"];
        return ;
    }
    
    //    BOOL bCheck = _check.checked;
    //    int nSave = bCheck ? 1 : 0;
    //    int nLogin = _autoLogin.checked ? 1 : 0;
    
    __weak LoginViewController *__self = self;
    //进入新的界面先
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [__self.view makeToastActivity];
                   });
    __block NSString *__strUser = strUser;
    __block NSString *__strPwd = strPwd;
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:8.0];
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
       LSTcpSocket *tcpSocket = [LSTcpSocket sharedLSTcpSocket];
       [tcpSocket loginServer:__strUser pwd:__strPwd];
    });
}

- (void)findPwd
{
    [self presentViewController:[[ForgetPwdViewController alloc] init] animated:YES completion:nil];
}

-(void)initUIBody
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    [self initUIBody];
    NSString *userId = [UserDefaults objectForKey:kUserId];
    NSString *userPwd = [UserDefaults objectForKey:kUserPwd];
    _txtUser.text = userId == nil ? @"13800138001" : userId;
    _txtPwd.text = userPwd == nil ? @"123123" : userPwd;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_txtUser)
    {
        [_txtPwd becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark 加入通知
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatus:) name:MESSAGE_LOGIN_SUCESS_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatus:) name:MESSAGE_LOGIN_ERROR_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backLeft) name:MESSAGE_UPDATE_PASSWROD_VC object:nil];
}

- (void)backLeft
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginError:(NSNotification *)notify
{
    DLog(@"登录失败");
    NSString *strMsg =  notify.object;
    [self.view makeToast:strMsg];
}

-(void)loginStatus:(NSNotification *)notify
{
    __weak LoginViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:__self];
        [__self.view hideToastActivity];
        [__self.view makeToast:@"登录失败"];
    });
    if (notify==nil)
    {
        return ;
    }
    if ([notify.object isEqualToString:@"登录成功"])
    {
//        [UserDefaults setBool:YES forKey:kIsLogin];
//        [UserDefaults setObject:_txtUser.text forKey:kUserId];
//        [UserDefaults setObject:_txtPwd.text forKey:kUserPwd];
//        [UserDefaults synchronize];
        LSTcpSocket *tcpSocket = [LSTcpSocket sharedLSTcpSocket];
        [tcpSocket closeSocket];
        dispatch_async(dispatch_get_main_queue(),
       ^{
           [__self.view hideToastActivity];
           [__self dismissViewControllerAnimated:YES completion:nil];
       });
    }
    else
    {
        NSString *strMsg = notify.object;
        __block NSString *__strMsg = strMsg;
        dispatch_async(dispatch_get_main_queue(),
       ^{
           [__self.view hideToastActivity];
           [__self.view makeToast:__strMsg];
       });
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loginTimeOut
{
    __weak LoginViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view hideToastActivity];
        [__self.view makeToast:@"登录超时"];
    });
}

@end

