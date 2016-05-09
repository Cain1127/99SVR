//
//  UpdatePwdViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "UpdatePwdViewController.h"
#import "UserInfo.h"
#import "ZLLogonServerSing.h"
#import "Toast+UIView.h"
#import "ProgressHUD.h"
#import "DecodeJson.h"
#import "BaseService.h"

@interface UpdatePwdViewController()<UITextFieldDelegate>
{
    UIButton *_btnCode;
    NSString *strDate;
    int nSecond;
    NSTimer *_timer;
}
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *password;
/**旧密码*/
@property (nonatomic,strong) RegisterTextField *txtOld;
/**新的密码*/
@property (nonatomic,strong) RegisterTextField *txtNew;
/**再次输入密码*/
@property (nonatomic,strong) RegisterTextField *txtCmd;

@property (nonatomic,strong) UITextField *txtMobile;
@property (nonatomic,strong) UITextField *txtCode;

@property (nonatomic,strong) UILabel *lblError;

@property (nonatomic, strong) UIButton *btnDetermine;


@end

@implementation UpdatePwdViewController

- (RegisterTextField *)createTextField:(CGRect)frame
{
    RegisterTextField *textField = [[RegisterTextField alloc] initWithFrame:frame];
    [self.view addSubview:textField];
    [textField setTextColor:UIColorFromRGB(0x555555)];
    [textField setFont:XCFONT(15)];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textField setClearButtonMode:UITextFieldViewModeAlways];
    return textField;
}

- (void)createLabelWithRect:(CGRect)frame
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(frame.origin.x,frame.origin.y+frame.size.height+10,kScreenWidth-frame.origin.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
}

- (void)createView
{
    CGRect frame = Rect(10, 50, kScreenWidth-160, 30);
    if ([UserInfo sharedUserInfo].otherLogin) {
        UILabel *lblMsg = [[UILabel alloc] initWithFrame:Rect(10, 10 + kNavigationHeight, kScreenWidth - 20, 20)];
        [lblMsg setText:@"由于您使用合作账号登录,请通过绑定手机设置密码!"];
        [self.view addSubview:lblMsg];
        [lblMsg setFont:XCFONT(15)];
        [lblMsg setTextColor:UIColorFromRGB(0xeb6100)];
        
        UILabel *line = [[UILabel alloc] initWithFrame:Rect(10, 40+kNavigationHeight,kScreenWidth-20,0.5)];
        [line setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
        [self.view addSubview:line];
        
        [self createLabelWithRect:Rect(10, 45+kNavigationHeight, 80, 30)];
        _txtMobile = [self createTextField:Rect(10, 45+kNavigationHeight, kScreenWidth-20, 30)];
        [_txtMobile setPlaceholder:@"请输入手机号码"];
        [_txtMobile setKeyboardType:UIKeyboardTypeNumberPad];
        frame.origin.y = _txtMobile.y+50;
        
        [self createLabelWithRect:Rect(10, frame.origin.y, 80, 30)];
        _txtCode = [self createTextField:Rect(10, frame.origin.y, kScreenWidth-120, 30)];
        [_txtCode setPlaceholder:@"请输入验证码"];
        [_txtCode setKeyboardType:UIKeyboardTypeNumberPad];
        frame.origin.y = _txtCode.y+50;
        
        _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
        [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
        [_btnCode setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_btnCode setTitleColor:kNavColor forState:UIControlStateHighlighted];
        [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.view addSubview:_btnCode];
        _btnCode.frame = Rect(kScreenWidth-105,_txtCode.y-3, 95, 36);
        [_btnCode addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchUpInside];
        _btnCode.titleLabel.font = XCFONT(15);
        _btnCode.layer.masksToBounds = YES;
        _btnCode.layer.cornerRadius = 3;
        frame.origin.y = _txtCode.y+50;
    }
    else
    {
        [self createLabelWithRect:Rect(10.0f, 20 + kNavigationHeight, 80.0f, 30.0f)];
        _txtOld = [self createTextField:Rect(10, 20+kNavigationHeight, kScreenWidth-20, 30)];
        _txtOld.isShowTextBool = YES;
        _txtOld.leftViewImageName = @"register_pwd";
        [_txtOld setPlaceholder:@"请输入旧密码"];
        frame.origin.y = _txtOld.y+50;
        [_txtOld setSecureTextEntry:YES];
        
        [self createLabelWithRect:Rect(10, frame.origin.y, 80, 30)];
        _txtCmd = [self createTextField:Rect(10, frame.origin.y, kScreenWidth-20, 30)];
        _txtCmd.delegate = self;
        [_txtCmd setPlaceholder:@"请输入新密码"];
        _txtCmd.isShowTextBool = YES;
        _txtCmd.leftViewImageName = @"register_pwd_new";
        frame.origin.y = _txtCmd.y+50;
        [_txtCmd setSecureTextEntry:YES];
    }
    [self createLabelWithRect:Rect(10, frame.origin.y, 80, 30)];
    _txtNew = [self createTextField:Rect(10, frame.origin.y, kScreenWidth-20, 30)];
    if([UserInfo sharedUserInfo].otherLogin)
    {
        [_txtNew setPlaceholder:@"请输入密码"];
    }
    else
    {
        [_txtNew setPlaceholder:@"请再次输入密码"];
        _txtNew.isShowTextBool = YES;
        _txtNew.leftViewImageName = @"register_pwd_ok";

        [_txtNew setSecureTextEntry:YES];
        _txtNew.delegate = self;
        
        [_txtOld addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_txtNew addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_txtCmd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    frame.origin.y = _txtNew.y+50;
    _lblError = [[UILabel alloc] initWithFrame:frame];
    [_lblError setFont:XCFONT(14)];
    [_lblError setTextColor:[UIColor redColor]];
    [self.view addSubview:_lblError];
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDetermine = btnRegister;
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(10, _lblError.y+50, kScreenWidth-20, 40);
    [btnRegister setTitle:@"确定" forState:UIControlStateNormal];
    [btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    btnRegister.layer.masksToBounds = YES;
    btnRegister.layer.cornerRadius = 3;
    [btnRegister addTarget:self action:@selector(authUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
    [self checkLogBtnIsEnableWithOldPwd:_txtOld.text withNewPwd:_txtNew.text withCmdPwd:_txtCmd.text];

}

-(void)textFieldDidChange:(id)sender{
    
    [self checkLogBtnIsEnableWithOldPwd:_txtOld.text withNewPwd:_txtNew.text withCmdPwd:_txtCmd.text];
}


- (void)closeKeyBoard
{
    [self.view endEditing:YES];
}

- (void)getAuthCode
{
    {
        _mobile = _txtMobile.text;
        if (_mobile.length==0)
        {
            [_lblError setText:@"手机号不能为空"];
            return ;
        }
        if (_mobile.length!=11)
        {
            [_lblError setText:@"手机长度错误"];
            return ;
        }
        if(![DecodeJson getSrcMobile:_mobile])
        {
            [_lblError setText:@"请输入正确的手机号"];
            return ;
        }
    }
    [self.view makeToastMsgActivity:@"获取验证码..."];
    [_lblError setText:@""];
    [self getMobileCode:_mobile];
}

- (void)getMobileCode:(NSString *)strMobile
{
    if(!strDate)
    {
        [_lblError setText:@"系统异常"];
        return ;
    }
    NSString *strMd5;
    strMd5 = [NSString stringWithFormat:@"action=3&date=%@&pnum=%@",strDate,_mobile];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    NSDictionary *parameters = nil;
    parameters = @{@"action":@(3),@"pnum":_mobile,@"key":strMd5,@"client":@(2)};
    @WeakObj(self)
    @WeakObj(_btnCode)
    [BaseService postJSONWithUrl:kBand_mobile_getcode_URL parameters:parameters success:^(id responseObject)
     {
         [selfWeak.view hideToastActivity];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [[dict objectForKey:@"status"] intValue]==0)
         {
             DLog(@"dict:%@",dict);
             [selfWeak startTimer];
             _btnCodeWeak.enabled = NO;
             [selfWeak.lblError setText:@"已发送验证码到目标手机"];
             [selfWeak.txtCode becomeFirstResponder];
         }
         else
         {
             [selfWeak.lblError setText:[dict objectForKey:@"info"]];
         }
     }
                            fail:^(NSError *error)
     {
         [selfWeak.view hideToastActivity];
         gcd_main_safe(^{
             [selfWeak.lblError setText:@"请求验证码失败"];
         });
     }];
}

- (void)authUpdate
{
    if ([UserInfo sharedUserInfo].otherLogin)
    {
        [self authOtherLogin];
    }
    else
    {
        NSString *oldPwd = _txtOld.text;
        NSString *newPwd = _txtCmd.text;
        _password = _txtNew.text;
        
        [self checkLogBtnIsEnableWithOldPwd:_txtOld.text withNewPwd:_txtNew.text withCmdPwd:_txtCmd.text];
        
        if (oldPwd.length==0) {
            [ProgressHUD showError:@"旧密码不能为空"];
            return;
        }
        else if(newPwd.length==0){
            [ProgressHUD showError:@"新密码不能为空"];
            return ;
        }
        else if(newPwd.length<6){
            [ProgressHUD showError:@"密码不能小于6位"];
            return ;
        }
        else if([self MatchLetter:newPwd]==-1)
        {
            [ProgressHUD showError:@"密码不能包含空格"];
            return ;
        }
        else if(_password.length==0)
        {
            [ProgressHUD showError:@"确认密码不能为空"];
            return ;
        }else if(![_password isEqualToString:newPwd])
        {
             [ProgressHUD showError:@"新密码与确认密码不一致"];
             return ;
        }
        else if([self MatchLetterNumber:_password]==-1)
        {
            [ProgressHUD showError:@"密码不能为纯数字"];
            return;
        }
        [[ZLLogonServerSing sharedZLLogonServerSing] updatePwd:oldPwd cmd:newPwd];
    }
}

/**
 *  检测修改密码的确定按钮是否可点击
 *
 *  @param oldPwdText 旧密码
 *  @param newPwdText 新密码
 *  @param cmdPwdText 再次输入的密码
 */
-(void)checkLogBtnIsEnableWithOldPwd:(NSString *)oldPwdText withNewPwd:(NSString *)newPwdText withCmdPwd:(NSString *)cmdPwdText{
    
    BOOL isOldPwdBool;
    BOOL isNewPwdBool;
    BOOL isCmdPwdBool;
    
    if (([oldPwdText isEqualToString:@""]||[oldPwdText length]==0)) {
        
        isOldPwdBool = NO;
        
    }else{
        isOldPwdBool = YES;
    }
    
    if (([newPwdText isEqualToString:@""]||[newPwdText length]==0)) {
        isNewPwdBool = NO;
    }else{
        isNewPwdBool = YES;
    }
    
    if (([cmdPwdText isEqualToString:@""]||[cmdPwdText length]==0)) {
        isCmdPwdBool = NO;
    }else{
        isCmdPwdBool = YES;
    }
    
    self.btnDetermine.enabled = (isOldPwdBool && isNewPwdBool && isCmdPwdBool);
}


- (void)authOtherLogin
{
     {
        _mobile = _txtMobile.text;
        if (_mobile.length==0)
        {
            [ProgressHUD showError:@"手机号不能为空"];
            return ;
        }
        if (_mobile.length!=11)
        {
            [ProgressHUD showError:@"手机长度错误"];
            return ;
        }
        if(![DecodeJson getSrcMobile:_mobile])
        {
            [ProgressHUD showError:@"请输入正确的手机号"];
            return ;
        }
        _password = [_txtNew text];
        if([_password length]==0)
        {
            [ProgressHUD showError:@"必须输入密码才能绑定手机"];
            return ;
        }
        else if(_password.length<6){
            [ProgressHUD showError:@"密码不能小于6位"];
            return ;
        }
         else if([self MatchLetter:_password]==-1)
         {
             [ProgressHUD showError:@"密码不能包含空格"];
             return ;
         }else if([self MatchLetterNumber:_password]==-1)
         {
             [ProgressHUD showError:@"密码不能为纯数字"];
             return;
         }
         
    }
    NSString *strCode = _txtCode.text;
    if ([strCode length]==0)
    {
        [_lblError setText:@"验证码不能为空"];
        return ;
    }
    
    NSDictionary *paramters;
    NSString *strInfo;
    [self.view makeToastActivity_bird];
    [_lblError setText:@""];
    {
        //直接绑定手机
        paramters = @{@"client":@"2",@"pwd":_password,@"userid":@([UserInfo sharedUserInfo].nUserId),@"pnum":_mobile,@"action":@(3),@"code":strCode};
        strInfo = kBand_mobile_setphone_URL;
    }
    
    @WeakObj(self);
    [BaseService postJSONWithUrl:strInfo parameters:paramters success:^(id responseObject)
     {
         gcd_main_safe(^{[selfWeak.view hideToastActivity];});
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if(dict && [dict objectForKey:@"status"] && [[dict objectForKey:@"status"] intValue]==0)
         {
             //没绑定过的，直接绑定，然后返回
             [selfWeak.navigationController popViewControllerAnimated:YES];
             [ProgressHUD showSuccess:@"绑定手机成功"];
         }
         else
         {
            [selfWeak.lblError setText:[dict objectForKey:@"info"]];
         }
     }
     fail:^(NSError *error)
     {
         [selfWeak.view hideToastActivity];
         [selfWeak.lblError setText:@"修改失败"];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleText:@"修改密码"];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self createView];
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    strDate = [fmt stringFromDate:date];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_txtOld becomeFirstResponder];

    });
    
}

- (void)dealloc
{
    DLog(@"dealloc");
}
- (void)startTimer
{
    nSecond = 59;
    if (_timer)
    {
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{
    if (nSecond==0)
    {
        _btnCode.enabled  = YES;
        [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        return ;
    }
    NSString *strInfo = [NSString stringWithFormat:@"重新发送(%d)",nSecond];
    [_btnCode setTitle:strInfo forState:UIControlStateNormal];
    nSecond--;
}

- (void)updatePassword:(NSNotification *)notify
{
    int result = [[notify object] intValue];
    if (result==0) {
        KUserSingleton.strPwd = _txtNew.text;
        KUserSingleton.strMd5Pwd = [DecodeJson XCmdMd5String:_txtNew.text];
        [UserDefaults setObject:_txtNew.text forKey:kUserPwd];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showSuccess:@"修改成功"];
             [self.navigationController popViewControllerAnimated:YES];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showError:@"旧密码错误"];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePassword:) name:MESSAGE_UPDATE_PASSWORD_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
        return YES;
    }
    if (_txtNew == textField || _txtCmd == textField) {
        NSString *strCode = @"[^ ]+$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strCode];;
        if (range.location>16 || range.location+string.length>16 || ![predicate evaluateWithObject:string])
        {
            return NO;
        }
    }
    return YES;
}

- (int)MatchLetterNumber:(NSString *)str
{
    NSString *ZIMU ;
    NSPredicate *regextestmobile ;
    ZIMU = @"\\d{1,16}";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    if([regextestmobile evaluateWithObject:str]==YES)
    {
        return -1;
    }
    return 1;
}

-(int)MatchLetter:(NSString *)str
{
    //判断是否以字母开头
    NSString *ZIMU ;
    NSPredicate *regextestmobile ;
    ZIMU = @"^[^ ]+$";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    if([regextestmobile evaluateWithObject:str]==YES)
    {
        return 1;
    }
    return -1;
}

@end
