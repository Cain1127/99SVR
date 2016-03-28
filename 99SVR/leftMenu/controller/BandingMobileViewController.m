//
//  BandingMobileViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "BandingMobileViewController.h"
#import "Toast+UIView.h"
#import "BandNewMobileViewController.h"
#import "LSTcpSocket.h"
#import "ProgressHUD.h"
#import "BaseService.h"
#import "DecodeJson.h"
#import "UserInfo.h"
@interface BandingMobileViewController ()<UITextFieldDelegate>
{
    int nSecond;
    NSString *strDate;
    int banding;
}
@property (nonatomic,strong) UILabel *lblError;
@property (nonatomic,strong) UITextField *txtName;
@property (nonatomic,strong) UITextField *txtCode;
@property (nonatomic,strong) UIButton *btnCode;
@property (nonatomic,strong) UITextField *txtPwd;


@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *password;

@end
@implementation BandingMobileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    banding = [UserInfo sharedUserInfo].banding;
    if (banding) {
        [self setTitleText:@"修改绑定手机"];
    }
    else
    {
        [self setTitleText:@"绑定手机"];
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    strDate = [fmt stringFromDate:date];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self createText];
}

- (void)createText
{
    CGRect frame = Rect(30, 50, kScreenWidth-160, 30);
    if (!banding) {
        [self createLabelWithRect:Rect(30, 20, 80, 30)];
        _txtName = [self createTextField:Rect(30, 20, kScreenWidth-60, 30)];
        [_txtName setPlaceholder:@"请输入手机号码"];
        [_txtName setKeyboardType:UIKeyboardTypeNumberPad];
        frame.origin.y = _txtName.y+50;
    }
    else
    {
        frame.origin.y = 20;
    }
    
    [self createLabelWithRect:Rect(30, frame.origin.y,80, 30)];
    _txtCode = [self createTextField:frame];
    [_txtCode setPlaceholder:@"请输入验证码"];
    [_txtCode setKeyboardType:UIKeyboardTypeNumberPad];
    
    _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [_btnCode setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_btnCode setTitleColor:kNavColor forState:UIControlStateHighlighted];
    [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:_btnCode];
    _btnCode.frame = Rect(_txtCode.x+_txtCode.width+5,_txtCode.y-3, 95, 36);
    [_btnCode addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchUpInside];
    _btnCode.titleLabel.font = XCFONT(15);
    _btnCode.layer.masksToBounds = YES;
    _btnCode.layer.cornerRadius = 3;
    frame = Rect(30, _txtCode.y+50, kScreenWidth-60, 20);
    if (!banding) {
        [self createLabelWithRect:Rect(30, _txtCode.y+50,80, 30)];
        _txtPwd = [self createTextField:Rect(_txtCode.x,_txtCode.y+50,_txtName.width,_txtCode.height)];
        [_txtPwd setPlaceholder:@"请输入密码"];
        [_txtPwd setKeyboardType:UIKeyboardTypeASCIICapable];
        frame.origin.y = _txtPwd.y+50;
    }
    _lblError = [[UILabel alloc] initWithFrame:frame];
    [_lblError setFont:XCFONT(14)];
    [_lblError setTextColor:[UIColor redColor]];
    [self.view addSubview:_lblError];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(30, _lblError.y+40, kScreenWidth-60, 40);
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    btnRegister.layer.masksToBounds = YES;
    btnRegister.layer.cornerRadius = 3;
    [btnRegister addTarget:self action:@selector(authMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
}

- (void)closeKeyBoard
{
    if([_txtName isFirstResponder])
    {
        [_txtName resignFirstResponder];
    }
    else if([_txtCode isFirstResponder])
    {
        [_txtCode resignFirstResponder];
    }
    else if([_txtPwd isFirstResponder])
    {
        [_txtPwd resignFirstResponder];
    }
}

- (void)dealloc
{
    DLog(@"dealloc");
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
    return textField;
}

- (void)createLabelWithRect:(CGRect)frame
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(frame.origin.x,frame.origin.y+frame.size.height+10,kScreenWidth-frame.origin.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
}

- (void)getAuthCode
{
    if(!banding)
    {
        _mobile = _txtName.text;
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
    if(banding)
    {
        strMd5 = [NSString stringWithFormat:@"action=4&date=%@&userid=%d",strDate,[UserInfo sharedUserInfo].nUserId];
    }
    else
    {
        strMd5 = [NSString stringWithFormat:@"action=3&date=%@&pnum=%@",strDate,_mobile];
    }
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    NSDictionary *parameters = nil;
    if(!banding)
    {
        parameters = @{@"action":@(3),@"pnum":_mobile,@"key":strMd5,@"client":@(2)};
    }
    else
    {
        parameters = @{@"action":@(4),@"userid":@([UserInfo sharedUserInfo].nUserId),@"key":strMd5,@"client":@(2)};
    }
    @WeakObj(self)
    [BaseService postJSONWithUrl:kBand_mobile_getcode_URL parameters:parameters success:^(id responseObject)
    {
         [ProgressHUD dismiss];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             DLog(@"dict:%@",dict);
             [selfWeak startTimer];
             gcd_main_safe(
             ^{
                selfWeak.btnCode.enabled = NO;
                [selfWeak.lblError setText:@"已发送验证码到目标手机"];
                [selfWeak.txtCode becomeFirstResponder];
             });
         }
         else
         {
             gcd_main_safe(^{
                 [selfWeak.lblError setText:[dict objectForKey:@"errmsg"]];
             });
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_txtName == textField)
    {
        if (range.location>11 || range.location+string.length>11)
        {
            return NO;
        }
    }
    return YES;
}



- (void)authMobile
{
    if (!banding) {
        _mobile = _txtName.text;
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
//        _password = [_txtPwd text];
//        if([_password length]==0)
//        {
//            [_lblError setText:@"必须输入密码才能绑定手机"];
//            return ;
//        }
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
    if(!banding)
    {
        //直接绑定手机
        paramters = @{@"client":@"2",@"userid":@([UserInfo sharedUserInfo].nUserId),@"pnum":_mobile,@"action":@(3),@"code":strCode};
        strInfo = kBand_mobile_setphone_URL;
    }
    else
    {
        paramters = @{@"client":@"2",@"userid":@([UserInfo sharedUserInfo].nUserId),@"action":@(4),@"code":strCode};
        strInfo = kBand_mobile_checkcode_URL;
    }
    @WeakObj(self);
    __block int __banding = banding;
    [BaseService postJSONWithUrl:strInfo parameters:paramters success:^(id responseObject)
     {
         gcd_main_safe(^{[selfWeak.view hideToastActivity];});
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if(dict && [dict objectForKey:@"errcode"] && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             //没绑定过的，直接绑定，然后返回
             if (!__banding) {
                 [selfWeak.navigationController popViewControllerAnimated:YES];
                 [ProgressHUD showSuccess:@"绑定手机成功"];
             }
             else
             {
                 [selfWeak.navigationController pushViewController:[[BandNewMobileViewController alloc] init] animated:YES];
             }
         }
         else
         {
             gcd_main_safe(
             ^{
                   [selfWeak.lblError setText:[dict objectForKey:@"errmsg"]];
             });
         }
     }fail:^(NSError *error)
     {
         gcd_main_safe(^{
             [selfWeak.view hideToastActivity];
             [selfWeak.lblError setText:@"注册失败"];
         });
     }];
}

@end