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

@interface UpdatePwdViewController()
{
    UIButton *_btnCode;
    NSString *strDate;
    int nSecond;
    NSTimer *_timer;
}
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,strong) UITextField *txtOld;
@property (nonatomic,strong) UITextField *txtNew;
@property (nonatomic,strong) UITextField *txtCmd;

@property (nonatomic,strong) UITextField *txtMobile;
@property (nonatomic,strong) UITextField *txtCode;

@property (nonatomic,strong) UILabel *lblError;

@end

@implementation UpdatePwdViewController

- (UITextField *)createTextField:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
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
        [_txtOld setPlaceholder:@"请输入旧密码"];
        frame.origin.y = _txtOld.y+50;
        [_txtOld setSecureTextEntry:YES];
        
        [self createLabelWithRect:Rect(10, frame.origin.y, 80, 30)];
        _txtCmd = [self createTextField:Rect(10, frame.origin.y, kScreenWidth-20, 30)];
        [_txtCmd setPlaceholder:@"请输入新密码"];
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
        [_txtNew setSecureTextEntry:YES];
    }
    frame.origin.y = _txtNew.y+50;
    _lblError = [[UILabel alloc] initWithFrame:frame];
    [_lblError setFont:XCFONT(14)];
    [_lblError setTextColor:[UIColor redColor]];
    [self.view addSubview:_lblError];
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(10, _lblError.y+50, kScreenWidth-20, 40);
    [btnRegister setTitle:@"确定" forState:UIControlStateNormal];
    [btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    btnRegister.layer.masksToBounds = YES;
    btnRegister.layer.cornerRadius = 3;
    [btnRegister addTarget:self action:@selector(authUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
}

- (void)closeKeyBoard
{
    if([_txtOld isFirstResponder])
    {
        [_txtOld resignFirstResponder];
    }
    else if([_txtCode isFirstResponder])
    {
        [_txtCode resignFirstResponder];
    }
    else if([_txtNew isFirstResponder])
    {
        [_txtNew resignFirstResponder];
    }
    else if([_txtCmd isFirstResponder])
    {
        [_txtCmd resignFirstResponder];
    }
    else if([_txtMobile isFirstResponder])
    {
        [_txtMobile resignFirstResponder];
    }

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
    [ProgressHUD show:@"获取验证码..."];
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
         [ProgressHUD dismiss];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             DLog(@"dict:%@",dict);
             [selfWeak startTimer];
             _btnCodeWeak.enabled = NO;
             [selfWeak.lblError setText:@"已发送验证码到目标手机"];
             [selfWeak.txtCode becomeFirstResponder];
         }
         else
         {
             [selfWeak.lblError setText:[dict objectForKey:@"errmsg"]];
         }
     }
                            fail:^(NSError *error)
     {
         [ProgressHUD dismiss];
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
        if (oldPwd.length==0) {
            [ProgressHUD showError:@"旧密码不能为空"];
        }
        else if(newPwd.length==0){
            [ProgressHUD showError:@"新密码不能为空"];
        }
        else if(_password.length==0)
        {
            [ProgressHUD showError:@"确认密码不能为空"];
        }
        [[ZLLogonServerSing sharedZLLogonServerSing] updatePwd:oldPwd cmd:newPwd];
    }
}

- (void)authOtherLogin
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
        _password = [_txtNew text];
        if([_password length]==0)
        {
            [_lblError setText:@"必须输入密码才能绑定手机"];
            return ;
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
    [self.view makeToastActivity];
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
         if(dict && [dict objectForKey:@"errcode"] && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             //没绑定过的，直接绑定，然后返回
             [selfWeak.navigationController popViewControllerAnimated:YES];
             [ProgressHUD showSuccess:@"绑定手机成功"];
         }
         else
         {
            [selfWeak.lblError setText:[dict objectForKey:@"errmsg"]];
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
@end
