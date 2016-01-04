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
    [exitBtn clickWithBlock:^(UIGestureRecognizer *gesture) {
        [self dismissViewControllerAnimated:YES completion:nil];
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
    
//    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(15, 91, kScreenWidth-30, 0.5)];
//    [self.view addSubview:lblContent];
//    [lblContent setBackgroundColor:UIColorFromRGBHex(0xd8e6ea)];
    
//    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(kScreenWidth/2-40, 81, 80, 20)];
//    [lblTemp setText:@"登录"];
//    [lblTemp setBackgroundColor:UIColorFromRGBHex(0xf7f7f7)];
//    [lblTemp setTextColor:UIColorFromRGBHex(0xbcc7cb)];
//    [lblTemp setFont:XCFONT(12)];
//    [lblTemp setTextAlignment:NSTextAlignmentCenter];
//    [self.view addSubview:lblTemp];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(81);
        
    }];
    
    CGFloat offsetY = 35;
    _txtUser = [[LoginTextField alloc] initWithFrame:CGRectMake(15 + 32,118 + offsetY + 20, kScreenWidth-30 - 32 * 2, 44)];
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
    [_txtUser setTextColor:RGB(15, 173, 225)];
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
    [_txtPwd setTextColor:RGB(15, 173, 225)];
    
    
//    _txtUser.layer.borderColor = UIColorFromRGBHex(0xc6cfd2).CGColor;
//    _txtUser.layer.borderWidth = 0.5;
//    _txtUser.layer.masksToBounds = YES;
//    _txtUser.layer.cornerRadius = 3;
//    
//    _txtPwd.layer.borderWidth = 0.5;
//    _txtPwd.layer.masksToBounds = YES;
//    _txtPwd.layer.cornerRadius = 3;
//    _txtPwd.layer.borderColor = UIColorFromRGBHex(0xc6cfd2).CGColor;
    
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
    
//    UIFont *font = XCFONT(12);
    
//    CGSize labelsize = [@"自动登录" sizeWithFont:font constrainedToSize:CGSizeMake(200.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    /**_check.frame = Rect(15, _txtPwd.frame.origin.y+_txtPwd.frame.size.height+12, 120, 30);
    [_check setTitle:@"保存密码" forState:UIControlStateNormal];
    [_check setTitleColor:UIColorFromRGBHex(0xaaaaaa) forState:UIControlStateNormal];
    
    [_check.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [self.view addSubview:_check];**/
    
//    _check.checked = [DeviceInfoDb querySavePwd];
    /**_autoLogin = [[QCheckBox alloc] initWithDelegate:self];
    _autoLogin.frame = Rect(kScreenWidth-47-labelsize.width, _txtPwd.frame.origin.y+_txtPwd.frame.size.height+12, labelsize.width+32, 30);
    [_autoLogin setTitle:@"自动登录" forState:UIControlStateNormal];
    [_autoLogin setTitleColor:UIColorFromRGBHex(0xaaaaaa) forState:UIControlStateNormal];
    [_autoLogin.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
    [self.view addSubview:_autoLogin];**/
//    _autoLogin.checked = [DeviceInfoDb queryLogin];
    
    _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRegin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFind = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnLogin setFrame:CGRectMake(15, _autoLogin.frame.origin.y+_autoLogin.frame.size.height+12, _txtUser.width, 44)];
    
//    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"btnBG"] forState:UIControlStateNormal];
//    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"btnBG_H"] forState:UIControlStateHighlighted];
    _btnLogin.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = 3;
    
    
    [_btnFind setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btnFind setTitleColor:RGB(15, 173, 225) forState:UIControlStateNormal];
    [_btnFind setTitle:@"找回密码" forState:UIControlStateNormal];
    _btnFind.titleLabel.font = XCFONT(12);
    CGSize findSize = [@"找回密码" sizeWithFont:XCFONT(12) constrainedToSize:CGSizeMake(200.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    [_btnFind setFrame:Rect(kScreenWidth/2-findSize.width/2,_btnLogin.frame.origin.y+_btnLogin.frame.size.height+20, findSize.width,25)];
    
    [_btnLogin setTitle:@"登 录" forState:UIControlStateNormal];
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogin setBackgroundColor:kNavColor];
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
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor colorWithHex:@"555555"] forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn clickWithBlock:^(UIGestureRecognizer *gesture) {
        NSLog(@"注册...");
    }];
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btnLogin);
        make.top.mas_equalTo(_btnLogin.mas_bottom).offset(53);
    }];
    
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:[UIColor colorWithHex:@"555555"] forState:UIControlStateNormal];
    forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetPwdBtn clickWithBlock:^(UIGestureRecognizer *gesture) {
        NSLog(@"忘记密码...");
    }];
    [self.view addSubview:forgetPwdBtn];
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_btnLogin);
        make.top.mas_equalTo(_btnLogin.mas_bottom).offset(53);
    }];
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
    _txtUser.text = userId == nil ? @"" : userId;
    _txtPwd.text = userPwd == nil ? @"" : userPwd;
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
        [UserDefaults setBool:YES forKey:kIsLogin];
        [UserDefaults setObject:_txtUser.text forKey:kUserId];
        [UserDefaults setObject:_txtPwd.text forKey:kUserPwd];
        [UserDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:MIESSAGE_UPDATE_LOGIN_STATUS object:nil];
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

