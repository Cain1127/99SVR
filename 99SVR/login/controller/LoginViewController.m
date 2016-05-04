//

//  LoginViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/7/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "LoginViewController.h"
#import "DecodeJson.h"
#import "ZLLogonServerSing.h"
#import "ProgressHUD.h"
#import "UserInfo.h"
#import "WXApi.h"
#import "BaseService.h"
#import "QCheckBox.h"
#import "Toast+UIView.h"
#import "RegMobileViewController.h"
#import "LoginTextField.h"
#import "NNSVRViewController.h"
#import "ForgetPwdViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "LoginViewController.h"
#import "StockDealViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,TencentSessionDelegate>
{
    UIView  *headView;
    BOOL _bLogin;
    TencentOAuth *_tencentOAuth;
    UIView *hidenView;
}
@property (nonatomic,copy) NSString *strToken;
@property (nonatomic,copy) NSString *strOpenId;
@property (nonatomic,copy) NSString *strNickName;
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

- (void)popBack
{
    
    //判断有没有高手操盘详情
    
    BOOL backStockDealVCBool = NO;
    UIViewController *stockDealVC = nil;
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[StockDealViewController class]]) {//高手操盘详情
            backStockDealVCBool =  YES;
            stockDealVC = viewController;
            break;
        }
    }
    if (backStockDealVCBool) {//跳转到到股票详情视图
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];
        [self.navigationController popToViewController:stockDealVC animated:YES];
    }else{//正常返回
        
        [self.navigationController popViewControllerAnimated:YES];
    }
        
}

-(void)initUIHead
{
    [self.view setBackgroundColor:RGB(245, 245, 246)];
    UIImageView *bodyView = [[UIImageView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenWidth*12/25)];
    [self.view addSubview:bodyView];
    bodyView.contentMode = UIViewContentModeScaleAspectFit;
    @WeakObj(bodyView)
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
       char cString[255];
       const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
       sprintf(cString, "%s/login_bg.png",path);
       NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
       UIImage *image = [UIImage imageWithContentsOfFile:objCString];
       if (image)
       {
           dispatch_async(dispatch_get_main_queue(), ^{
               bodyViewWeak.image = image;
           });
       }
    });
    
    _txtUser = [[LoginTextField alloc] initWithFrame:CGRectMake(15,bodyView.y+bodyView.height, kScreenWidth-30, 44)];
    _txtPwd = [[LoginTextField alloc] initWithFrame:CGRectMake(_txtUser.x, _txtUser.frame.origin.y+_txtUser.frame.size.height+10, _txtUser.width, 44)];
    _txtUser.delegate = self;
    _txtPwd.delegate = self;
    
    [_txtUser addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtPwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
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
    _txtUser.leftView = imgUser;
    _txtUser.leftViewMode = UITextFieldViewModeAlways;
    _txtUser.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_txtUser setTextColor:UIColorFromRGB(0x343434)];
    [_txtUser setBackgroundColor:[UIColor clearColor]];
    [_txtPwd setReturnKeyType:UIReturnKeyDone];
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
    
    UIColor *color = UIColorFromRGB(0xB2B2B2);
    _txtUser.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"99账号/手机号码/用户名" attributes:@{NSForegroundColorAttributeName: color}];
    _txtPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    
    _txtUser.delegate = self;
    _txtPwd.delegate = self;
    
    _txtUser.tag = 1;
    _txtPwd.tag = 2;
    
    [_txtPwd setSecureTextEntry:YES];
    [_txtUser setFont:XCFONT(15)];
    [_txtPwd setFont:XCFONT(15)];
    
    [_txtUser setKeyboardType:UIKeyboardTypeASCIICapable];
    [_txtPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    
    _check = [[QCheckBox alloc] initWithDelegate:self];
    _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRegin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFind = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btnLogin.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = 3;
    
    [_btnFind setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_btnFind setTitleColor:UIColorFromRGB(0x0078DD) forState:UIControlStateNormal];
    [_btnFind setTitle:@"忘记密码" forState:UIControlStateNormal];
    CGSize findSize = [@"忘记密码" sizeWithAttributes:@{NSFontAttributeName:XCFONT(15)}];
    [self.view addSubview:_btnFind];
    
    [_btnLogin setTitle:@"登 录" forState:UIControlStateNormal];
    [_btnLogin setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateNormal];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateHighlighted];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    _btnLogin.titleLabel.font = XCFONT(15);
    
    [_btnRegin setTitleColor:UIColorFromRGB(0x0078DD) forState:UIControlStateNormal];
    [_btnRegin setTitle:@"快速注册" forState:UIControlStateNormal];
    [_btnRegin setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    _btnRegin.titleLabel.font = XCFONT(15);
    
    [_btnRegin addTarget:self action:@selector(registerServver) forControlEvents:UIControlEventTouchUpInside];
    [_btnLogin addTarget:self action:@selector(loginServer) forControlEvents:UIControlEventTouchUpInside];
    [_btnFind addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_txtUser];
    [self.view addSubview:_txtPwd];
    [self.view addSubview:_btnLogin];
    [self.view addSubview:_btnRegin];
    
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

    _btnLogin.frame = Rect(15, _txtPwd.y+_txtPwd.height+30, kScreenWidth-30, 40);
    _btnFind.titleLabel.font = XCFONT(15);
    _btnRegin.titleLabel.font = XCFONT(15);
    _btnRegin.frame = Rect(20, kScreenHeight-50, findSize.width, 40);
    [_btnFind setFrame:Rect(kScreenWidth-findSize.width-20,kScreenHeight-50, findSize.width,40)];
    
    hidenView = [[UIView alloc] initWithFrame:Rect(0, _btnLogin.y+_btnLogin.height, kScreenWidth,100)];
    [self.view addSubview:hidenView];
    if ([UserInfo sharedUserInfo].nStatus) {
        hidenView.hidden = NO;
    }
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(15, 30, kScreenWidth-30, 0.5)];
    [line setBackgroundColor:kLineColor];
    [hidenView addSubview:line];
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(kScreenWidth/2-10, 20, 20, 20)];
    [lblTemp setText:@"或"];
    [lblTemp setTextColor:UIColorFromRGB(0x555555)];
    [hidenView addSubview:lblTemp];
    [lblTemp setTextAlignment:NSTextAlignmentCenter];
    [lblTemp setBackgroundColor:RGB(245, 245, 246)];
    [lblTemp setFont:XCFONT(15)];
    
    UIButton *btnQQ = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([TencentOAuth iphoneQQInstalled])
    {
        [hidenView addSubview:btnQQ];
    }
    btnQQ.frame = Rect(kScreenWidth/2-22, 50, 44, 44);
    [btnQQ setImage:[UIImage imageNamed:@"QQLogin"] forState:UIControlStateNormal];
    [btnQQ setImage:[UIImage imageNamed:@"QQLogin_h"] forState:UIControlStateHighlighted];
    [btnQQ addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnWeiBo = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([WeiboSDK isWeiboAppInstalled]) {
        [hidenView addSubview:btnWeiBo];
    }
    [btnWeiBo setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [btnWeiBo setImage:[UIImage imageNamed:@"weibo_h"] forState:UIControlStateHighlighted];
    btnWeiBo.frame = Rect(kScreenWidth/2+62, 50, 44, 44);
    [btnWeiBo addTarget:self action:@selector(sinaLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnWeiChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [hidenView addSubview:btnWeiChat];
    [btnWeiChat setImage:[UIImage imageNamed:@"weichat"] forState:UIControlStateNormal];
    [btnWeiChat setImage:[UIImage imageNamed:@"weichat_h"] forState:UIControlStateHighlighted];
    [btnWeiChat addTarget:self action:@selector(weiChatLogin) forControlEvents:UIControlEventTouchUpInside];
    btnWeiChat.frame = Rect(kScreenWidth/2-102, 50, 44, 44);
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        [hidenView addSubview:btnWeiChat];
    }
    
    UIButton *btnLeft = [CustomViewController itemWithTarget:self action:@selector(popBack) image:@"back" highImage:@"back"];
    [self.view addSubview:btnLeft];
    [btnLeft setFrame:Rect(0,20,44,44)];
}

-(void)textFieldDidChange:(id)sender{
    
    [self checkLogBtnIsEnableWithPwd:_txtPwd.text withUser:_txtUser.text];
    
}


#pragma mark 微信登录请求
- (void)weiChatLogin
{
    [self.view makeToastActivity];
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744";
    [WXApi sendReq:req];
}

- (void)forgetPassword
{
    ForgetPwdViewController *forget = [[ForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
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
    RegMobileViewController *regMobile = [[RegMobileViewController alloc] init];
    [self.navigationController pushViewController:regMobile animated:YES];
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
    __weak LoginViewController *__self = self;
    //进入新的界面先
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.view makeToastActivity];
    });
    __block NSString *__strUser = strUser;
    __block NSString *__strPwd = strPwd;
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:8.0];
    [UserInfo sharedUserInfo].observationInfo = 0;
    [UserInfo sharedUserInfo].otherLogin = 0;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:__strUser pwd:__strPwd];
    });
}

- (void)findPwd
{
    [self.navigationController pushViewController:[[ForgetPwdViewController alloc] init] animated:YES];
}

-(void)initUIBody
{
    
}

- (void)requestLbsSettingServer
{
//    __weak LoginViewController *__self = self;

}

- (void)sinaLogin
{
    [self.view makeToastActivity];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)qqLogin
{
//    [ProgressHUD show:@"QQ授权中..." viewInfo:self.view];
    [self.view makeToastActivity];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105298719" andDelegate:self];
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    [self initUIBody];
    [self requestLbsSettingServer];
    NSString *userId = [UserDefaults objectForKey:kUserId];
    NSString *userPwd = [UserDefaults objectForKey:kUserPwd];
    _txtUser.text = userId == nil ? @"" : userId;
    _txtPwd.text = userPwd == nil ? @"" : userPwd;
    
    if ([userId isEqualToString:@""] || [userId length]==0) {

        self.btnLogin.enabled = NO;
        
    }else if([userPwd isEqualToString:@""] || [userPwd length]==0)
    {
        self.btnLogin.enabled = NO;
    }
    
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
    [_txtUser becomeFirstResponder];
}

- (void)closeKeyBoard
{
    if ([_txtUser isFirstResponder]) {
        [_txtUser resignFirstResponder];
    }
    else if ([_txtPwd isFirstResponder])
    {
        [_txtPwd resignFirstResponder];
    }
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
    
    [self checkLogBtnIsEnableWithPwd:_txtPwd.text withUser:_txtUser.text];
    
    return YES;
}

/**
 *  检测loginBtn是否可点击
 *
 *  @param pwdText  密码
 *  @param userText 账号
 */
-(void)checkLogBtnIsEnableWithPwd:(NSString *)pwdText withUser:(NSString *)userText{
    
    BOOL isPwdBool;
    BOOL isUserBool;
    
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
    _btnLogin.enabled = (isPwdBool && isUserBool);
}

#pragma mark 加入通知
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatus:) name:MESSAGE_LOGIN_SUCESS_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatus:) name:MESSAGE_LOGIN_ERROR_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backLeft) name:MESSAGE_UPDATE_PASSWROD_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sinaLogin_response:) name:MESSAGE_LOGIN_SINA_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weichat_login:) name:MESSAGE_LOGIN_WEICHAT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:)
                                                  name:UIKeyboardWillHideNotification object:nil];
}



- (void)weichat_login:(NSNotification *)notify
{
    NSDictionary *dict = [notify object];
    __weak LoginViewController *__self = self;
    if (dict && [dict objectForKey:@"errcode"])
    {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self.view hideToastActivity];
            [__self.view makeToast:@"微信登录失败"];
        });
        return ;
    }
    if (dict && [dict objectForKey:@"code"])
    {
        NSString *strInfo = [NSString stringWithFormat:@"%@loginapi/VailUserByWeixin?client=2&code=%@",kRegisterNumber,[dict objectForKey:@"code"]];
        __weak LoginViewController *__self = self;
        __weak UserInfo *__user = [UserInfo sharedUserInfo];
        [BaseService get:strInfo dictionay:nil timeout:10 success:^(id responseObject)
         {
             dispatch_async(dispatch_get_main_queue(),
             ^{
                 [__self.view hiddenActivityInView];
             });
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
             if (dict && [[dict objectForKey:@"openid"] isKindOfClass:[NSString class]] &&
                 [[dict objectForKey:@"token"] isKindOfClass:[NSString class]])
             {
                 __user.strOpenId = [dict objectForKey:@"openid"];
                 __user.strToken = [dict objectForKey:@"token"];
                 __user.nUserId = [[dict objectForKey:@"userid"] intValue];
                 __user.otherLogin = [[dict objectForKey:@"type"] intValue];
                 DLog(@"登录成功");
                 [ProgressHUD showSuccess:@"微信授权成功"];
                 [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:NSStringFromInt(__user.nUserId) pwd:@""];
                 [__self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:8.0];
             }
             else
             {
                [__self.view hideToastActivity];
                [__self.view makeToast:@"微信登录授权失败"];
             }
             
         }
         fail:^(NSError *error)
         {
                 [__self.view hideToastActivity];
                 [__self.view makeToast:@"微信登录授权失败"];
         }];
    }
}

#pragma mark 新浪登录响应
- (void)sinaLogin_response:(NSNotification *)notify
{
    NSDictionary *dict = [notify object];
    DLog(@"dict:%@",dict);
    if(dict && [dict objectForKey:@"error"])
    {
        __weak LoginViewController *__self = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view hideToastActivity];
            [__self.view makeToast:@"新浪微博授权失败"];
        });
        return ;
    }
    //检测 user id
    if (dict && [dict objectForKey:@"userID"] && [dict objectForKey:@"accessToken"]) {
        NSString *strInfo = [NSString stringWithFormat:@"%@loginapi/VailUserByWeibo?client=2&openid=%@&token=%@",
                             kRegisterNumber,[dict objectForKey:@"userID"],[dict objectForKey:@"accessToken"]];
        __weak UserInfo *__user = [UserInfo sharedUserInfo];
        @WeakObj(self)
        [BaseService get:strInfo dictionay:nil timeout:8 success:^(id responseObject) {
           [selfWeak.view hiddenActivityInView];
            NSDictionary *dict = nil;;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                dict = responseObject;
            }
            else{
                dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
            }
            if (dict && [[dict objectForKey:@"openid"] isKindOfClass:[NSString class]] &&
                [[dict objectForKey:@"token"] isKindOfClass:[NSString class]])
            {
                __user.strOpenId = [dict objectForKey:@"openid"];
                __user.strToken = [dict objectForKey:@"token"];
                __user.nUserId = [[dict objectForKey:@"userid"] intValue];
                __user.otherLogin = [[dict objectForKey:@"type"] intValue];
                [ProgressHUD showSuccess:@"授权成功"];
                [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:NSStringFromInt(__user.nUserId) pwd:@""];
                [selfWeak performSelector:@selector(loginTimeOut) withObject:nil afterDelay:8.0];
            }
            else
            {
               [selfWeak.view hideToastActivity];
               [selfWeak.view makeToast:@"新浪微博登录失败"];
            }
        } fail:^(NSError *error)
        {
            [selfWeak.view hideToastActivity];
            [selfWeak.view makeToast:@"新浪微博登录失败"];
        }];
    }
}

- (void)backLeft
{
    __weak LoginViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self popBack];
    });
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
    });
    if (notify==nil)
    {
        return ;
    }
    if ([notify.object isEqualToString:@"登录成功"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self popBack];
            [ProgressHUD showSuccess:@"登录成功"];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self.view hideToastActivity];
            [ProgressHUD showError:@"账号或密码错误，请重新输入"];
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
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [self.view hideToastActivity];
        [__self.view makeToast:@"登录超时"];
    });
}

- (void)tencentDidLogin
{
    if ([_tencentOAuth accessToken] && 0 != [[_tencentOAuth accessToken] length])
    {
        DLog(@"token:%@ openId;%@",[_tencentOAuth accessToken],[_tencentOAuth openId]);
        NSString *strInfo = [NSString stringWithFormat:@"%@loginapi/VailUserByQQ?client=2&openid=%@&token=%@",
                             kRegisterNumber,[_tencentOAuth openId],[_tencentOAuth accessToken]];
        @WeakObj(self)
        [BaseService get:strInfo dictionay:nil timeout:8 success:^(id responseObject)
        {
            UserInfo *__user = [UserInfo sharedUserInfo];
            gcd_main_safe(^{
                [selfWeak.view hiddenActivityInView];
            });
            NSDictionary *dict = nil;;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                dict = responseObject;
            }
            else{
                dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
            }
            if (dict && [[dict objectForKey:@"openid"] isKindOfClass:[NSString class]] &&
                [[dict objectForKey:@"token"] isKindOfClass:[NSString class]] )
            {
                __user.strOpenId = [dict objectForKey:@"openid"];
                __user.strToken = [dict objectForKey:@"token"];
                __user.nUserId = [[dict objectForKey:@"userid"] intValue];
                __user.otherLogin = [[dict objectForKey:@"type"] intValue];
                [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:NSStringFromInt(__user.nUserId) pwd:@""];
                [ProgressHUD showSuccess:@"授权成功"];
                [selfWeak performSelector:@selector(loginTimeOut) withObject:nil afterDelay:8.0];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
               ^{
                   [selfWeak.view hideToastActivity];
                   [selfWeak.view makeToast:@"QQ登录授权失败"];
               });
            }
        }
        fail:^(NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [selfWeak.view hideToastActivity];
                [selfWeak.view makeToast:@"QQ登录授权失败"];
            });
        }];
    }
    else
    {
        __weak LoginViewController *__self = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.view hideToastActivity];
            [__self.view makeToast:@"QQ登录授权失败"];
        });
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSString *strMsg = nil;
    if (cancelled)
    {
        strMsg = @"取消登录";
    }
    else
    {
        strMsg = @"登录失效";
    }
    __weak LoginViewController *__self = self;
    __weak NSString *__strMsg = strMsg;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.view hideToastActivity];
        [__self.view makeToast:__strMsg];
    });
}

- (void)tencentDidNotNetWork
{
    __weak LoginViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.view hideToastActivity];
        [__self.view makeToast:@"网络故障"];
    });
}

-(void)getAccess_token:(NSString *)strCode
{
    
//    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SEC,strCode];
//    DLog(@"url:%@",url);
    return ;
//    __weak LoginViewController *__self = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *zoneUrl = [NSURL URLWithString:url];
//        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_global_queue(0, 0),
//        ^{
//           if (data)
//           {
//               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//               NSString *strToken = [dic objectForKey:@"access_token"];
//               NSString *strOpenId = [dic objectForKey:@"openid"];
//               __self.strOpenId = strOpenId;
//               __self.strToken = strToken;
//               DLog(@"strToken:%@,strOpenId:%@",strToken,strOpenId);
//               [__self getUserInfo:strToken openid:strOpenId];
//           }
//        });
//    });
}

-(void)getUserInfo:(NSString *)access_token openid:(NSString *)openid
{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    DLog(@"url:%zi",url.length);
    __weak LoginViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_global_queue(0, 0),
        ^{
           if (data)
           {
               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               DLog(@"昵称:%@",[dic objectForKey:@"nickname"]);
               __self.strNickName = [dic objectForKey:@"nickname"];
               [__self request_api_weichat_login];
           }
        });
    });
}

- (void)request_api_weichat_login
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    NSString *strDate = [fmt stringFromDate:date];
    NSString *strKey = [NSString stringWithFormat:@"appid=wxfbfe01336f468525&openid=%@&token=%@&date=%@",_strOpenId,_strToken,strDate];
    NSString *strMd5 = [DecodeJson XCmdMd5String:strKey];
    strMd5 = [DecodeJson XCmdMd5String:strKey];
    @WeakObj(self)
    __weak UserInfo *__user = [UserInfo sharedUserInfo];
    NSString *strInfo = [NSString stringWithFormat:@"%@loginapi/VailUserByWeixin",kRegisterNumber];
    NSDictionary *dict = @{@"client":@"2",@"openid":_strOpenId,@"token":_strToken,@"nick":_strNickName,@"key":strMd5};
    DLog(@"strInfo:%zi",strInfo.length);
    [BaseService postJSONWithUrl:strInfo parameters:dict success:^(id responseObject)
    {
        [selfWeak.view hiddenActivityInView];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        if (dict && [[dict objectForKey:@"openid"] isKindOfClass:[NSString class]] &&
            [[dict objectForKey:@"token"] isKindOfClass:[NSString class]])
        {
            __user.strOpenId = [dict objectForKey:@"openid"];
            __user.strToken = [dict objectForKey:@"token"];
            __user.nUserId = [[dict objectForKey:@"userid"] intValue];
            __user.otherLogin = [[dict objectForKey:@"type"] intValue];
            [ProgressHUD showSuccess:@"授权成功"];
            [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:NSStringFromInt(__user.nUserId) pwd:@""];
            [selfWeak performSelector:@selector(loginTimeOut) withObject:nil afterDelay:8];
        }
        else{
            [ProgressHUD showError:@"授权失败"];
        }
    }
    fail:^(NSError *error)
    {
        [selfWeak.view hiddenActivityInView];
        [selfWeak.view makeToast:@"微信登录授权失败"];
    }];
}

- (void) keyboardWasShown:(NSNotification *) notification
{
    [UIView animateWithDuration:1.0 delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:
     ^{
         if (kScreenHeight <= 480)
         {
             [self.view setFrame:Rect(0, -64, kScreenWidth, kScreenHeight)];
         }
     } completion:nil];
}
- (void) keyboardWasHidden:(NSNotification *) notification
{
    self.view.frame = Rect(0, 0, kScreenWidth, kScreenHeight);
}



@end

