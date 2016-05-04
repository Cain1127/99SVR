//
//  BandNewMobileViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "BandNewMobileViewController.h"
#import "DecodeJson.h"
#import "UserInfo.h"
#import "BaseService.h"
#import "ProgressHUD.h" 
#import "Toast+UIView.h"

@interface BandNewMobileViewController()<UITextFieldDelegate>
{
    NSString *strDate;
    int nSecond;
}
@property (nonatomic,strong) UITextField *txtName;
@property (nonatomic,strong) UITextField *txtCode;
@property (nonatomic,strong) UIButton *btnCode;
@property (nonatomic,strong) UITextField *txtPwd;


@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *password;

@end
@implementation BandNewMobileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleText:@"绑定新手机"];
    
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    strDate = [fmt stringFromDate:date];
    
    [self initView];
}

- (void)initView
{
    CGRect frame = Rect(30, 50+64, kScreenWidth-160, 30);
    
    [self createLabelWithRect:Rect(30, 20+64, 80, 30)];
    _txtName = [self createTextField:Rect(30, 20+64, kScreenWidth-60, 30)];
    [_txtName setPlaceholder:@"请输入手机号码"];
    [_txtName setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self createLabelWithRect:Rect(30, _txtName.y+50,80, 30)];
    _txtCode = [self createTextField:Rect(30, _txtName.y+50, kScreenWidth-160, 30)];
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
    [self createLabelWithRect:Rect(30, _txtCode.y+50,80, 30)];
    _txtPwd = [self createTextField:Rect(_txtCode.x,_txtCode.y+50,_txtName.width,_txtCode.height)];
    [_txtPwd setPlaceholder:@"请输入密码"];
    [_txtPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    frame.origin.y = _txtPwd.y+50;
    

    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(30, _txtPwd.y+40, kScreenWidth-60, 40);
    [btnRegister setTitle:@"确定" forState:UIControlStateNormal];
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

    _mobile = _txtName.text;
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
    [self.view makeToastActivity_bird];
    [self getMobileCode:_mobile];
}

- (void)getMobileCode:(NSString *)strMobile
{
    if(!strDate)
    {
        [ProgressHUD showError:@"系统异常"];
        return ;
    }
    NSString *strMd5;
    strMd5 = [NSString stringWithFormat:@"action=5&date=%@&pnum=%@",strDate,_mobile];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    NSString *strInfo = kBand_mobile_getcode_URL;
    NSDictionary *parameters = nil;
    parameters = @{@"action":@(5),@"pnum":_mobile,@"key":strMd5,@"client":@(2)};
    
    @WeakObj(self)
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id responseObject)
     {
         [selfWeak.view hideToastActivity];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             DLog(@"dict:%@",dict);
             [selfWeak startTimer];
               selfWeak.btnCode.enabled = NO;
               [ProgressHUD showSuccess:@"已发送验证码到目标手机"];
               [selfWeak.txtCode becomeFirstResponder];
         }
         else
         {
             [ProgressHUD showError:[dict objectForKey:@"errmsg"]];
         }
     }
                            fail:^(NSError *error)
     {
            [selfWeak.view hideToastActivity];
            [ProgressHUD showError:@"请求验证码失败"];
     }];
}
- (void)authMobile
{
    _mobile = _txtName.text;
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
    _password = [_txtPwd text];
    if([_password length]==0)
    {
        [ProgressHUD showError:@"必须输入密码才能绑定手机"];
        return ;
    }
    NSString *strCode = _txtCode.text;
    if ([strCode length]==0)
    {
        [ProgressHUD showError:@"验证码不能为空"];
        return ;
    }
    
    NSDictionary *paramters;
    NSString *strInfo;
    [self.view makeToastActivity_bird];
    
        //直接绑定手机
    paramters = @{@"client":@"2",@"userid":@([UserInfo sharedUserInfo].nUserId),@"pnum":_mobile,@"action":@(5),@"code":strCode,@"pwd":_password};
    strInfo = kBand_mobile_setphone_URL;
    @WeakObj(self);
    [BaseService postJSONWithUrl:strInfo parameters:paramters success:^(id responseObject)
     {
         [selfWeak.view hideToastActivity];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if(dict && [dict objectForKey:@"errcode"] && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             //没绑定过的，直接绑定，然后返回
             [selfWeak.navigationController popToRootViewControllerAnimated:YES];
             [ProgressHUD showSuccess:@"绑定新手机成功"];
         }
         else
         {
              [ProgressHUD showError:[dict objectForKey:@"errmsg"]];
         }
     }fail:^(NSError *error)
     {
             [selfWeak.view hideToastActivity];
             [ProgressHUD showError:@"绑定失败"];
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

@end
