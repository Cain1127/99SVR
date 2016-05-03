//
//  RegMobileViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 2/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RegMobileViewController.h"
#import "RoomViewController.h"
#import "ZLLogonServerSing.h"
#import "ProgressHUD.h"
#import "Toast+UIView.h"
#import "NNSVRViewController.h"
#import "BaseService.h"
#import "QCheckBox.h"
#import "DecodeJson.h"
#import "RegNameViewController.h"

@interface RegMobileViewController ()<UITextFieldDelegate>
{
    NSTimer *_timer;
    int nSecond;
    NSString *strDate;
}

@property (nonatomic,strong) UIImageView *imgView;
/**手机号*/
@property (nonatomic,strong) RegisterTextField *txtName;
/**密码*/
@property (nonatomic,strong) RegisterTextField *txtPwd;
/**验证码*/
@property (nonatomic,strong) RegisterTextField *txtCode;

@property (nonatomic,copy) NSString *strCode;

@property (nonatomic,strong) QCheckBox *checkAgree;

@property (nonatomic,strong) UIButton *btnCode;
/**注册*/
@property (nonatomic, strong) UIButton *btnDetermine;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;

@end

@implementation RegMobileViewController

- (void)regMobile
{
    _username = _txtName.text;
    if (_username.length==0)
    {
        [ProgressHUD showError:@"手机号不能为空"];
        return ;
        
    }
    if (_username.length!=11)
    {
        [ProgressHUD showError:@"手机长度错误"];
        return ;
    }
    if(![DecodeJson getSrcMobile:_username])
    {
        [ProgressHUD showError:@"请输入正确的手机号"];
        return ;
    }
    NSString *strCode = _txtCode.text;
    if ([strCode length]==0)
    {
        [ProgressHUD showError:@"验证码不能为空"];
        return ;
    }
    _password = _txtPwd.text;
    if([_password length]==0)
    {
        [ProgressHUD showError:@"密码不能为空"];
        return ;
    }
    if (!_checkAgree.checked) {
        [ProgressHUD showError:@"必须同意《用户服务协议》和《隐私权条款》"];
        return ;
    }
    [self.view makeToastActivity];
    NSDictionary *paramters = @{@"type":@"2",@"account":_username,@"pwd":_password,@"vcode":strCode};
    NSString *strInfo = [NSString stringWithFormat:@"%@mapi/registerMulti",kRegisterNumber];
    @WeakObj(self)
    [BaseService postJSONWithUrl:strInfo parameters:paramters success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        gcd_main_safe(^{
            [selfWeak.view hideToastActivity];}
        );
        if(dict && [dict objectForKey:@"errcode"] && [[dict objectForKey:@"errcode"] intValue]==1)
        {
            [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:selfWeak.username pwd:selfWeak.password];
            [self navBack];
            [ProgressHUD showSuccess:@"注册成功"];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [ProgressHUD showError:[dict objectForKey:@"errmsg"]];
            });
        }
    }
    fail:^(NSError *error)
    {
         [selfWeak.view hideToastActivity];
         [ProgressHUD showError:@"注册失败"];
         NSString *strUrl = [NSString stringWithFormat:@"ReportItem=Register&ClientType=1&RegType=2&ServerIP=%@&Error=%@",
                            @"120.55.105.224",@"err_fail"];
         [DecodeJson postPHPServerMsg:strUrl];
    }];
}

#pragma mark 获取手机验证码
- (void)getMobileCode:(NSString *)strMobile
{
    if(!strDate)
    {
        [ProgressHUD showError:@"系统异常"];
        return ;
    }
    NSString *strMd5 = [NSString stringWithFormat:@"action=reg&account=%@&date=%@",strMobile,strDate];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    NSString *strInfo = [NSString stringWithFormat:@"%@mapi/getregmsgcode?pnum=%@&key=%@",kRegisterNumber,strMobile,strMd5];
    __weak RegMobileViewController *__self = self;
    [BaseService get:strInfo dictionay:nil timeout:8 success:^(id responseObject)
     {
         NSDictionary *dict = nil;;
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             dict = responseObject;
         }
         else{
             dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         }
         if (dict && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             DLog(@"dict:%@",dict);
             [__self startTimer];
             dispatch_async(dispatch_get_main_queue(),
             ^{
                 [__self.view hideToastActivity];
                 __self.btnCode.enabled = NO;
                 [ProgressHUD showSuccess:@"已发送验证码到目标手机"];
                 [__self.txtCode becomeFirstResponder];
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(),
             ^{
                 [__self.view hideToastActivity];
                 [ProgressHUD showError:[dict objectForKey:@"errmsg"]];
             });
         }
     }
     fail:^(NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),
         ^{
             [__self.view hideToastActivity];
             [ProgressHUD showError:@"请求验证码失败"];
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

- (void)getAuthCode
{
    NSString *strMobile = _txtName.text;
    if (strMobile.length==0)
    {
       [ProgressHUD showError:@"手机号不能为空"];
       return ;
    }
    if (strMobile.length!=11)
    {
        [ProgressHUD showError:@"手机长度错误"];
        return ;
    }
    if(![DecodeJson getSrcMobile:strMobile])
    {
        [ProgressHUD showError:@"请输入正确的手机号"];
        return ;
    }
    [self.view makeToastActivity];
    [self getMobileCode:strMobile];
}

- (void)addLineHeight:(UILabel *)lblTemp
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(lblTemp.x,lblTemp.y+lblTemp.height+10,kScreenWidth-lblTemp.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
}

- (void)createLabelWithRect:(CGRect)frame
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(frame.origin.x,frame.origin.y+frame.size.height+10,kScreenWidth-frame.origin.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
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

- (void)gotoRegName
{
    RegNameViewController *regName= [[RegNameViewController alloc] init];
    [self.navigationController pushViewController:regName animated:YES];
}

- (void)initUIHead
{
    UIButton *btnRight = [CustomViewController itemWithTarget:self action:@selector(gotoRegName) title:@"账号注册"];
    [self.view addSubview:btnRight];
    btnRight.frame = Rect(kScreenWidth-60, 20, 60, 44);
    btnRight.titleLabel.font = XCFONT(13);
    
    //手机号
    [self createLabelWithRect:Rect(10, 8+kNavigationHeight, 80, 30)];
    _txtName = [self createTextField:Rect(10, 8+kNavigationHeight, kScreenWidth-20, 30)];
    [_txtName setKeyboardType:UIKeyboardTypeNumberPad];
    UIColor *color = UIColorFromRGB(0xB2B2B2);
    _txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: color}];
    _txtName.leftViewImageName = @"register_mob";
    
    
    [self createLabelWithRect:Rect(10, _txtName.y+50,80, 30)];
    _txtCode = [self createTextField:Rect(_txtName.x,_txtName.y+50,_txtName.width-100,_txtName.height)];
    _txtCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: color}];
    [_txtCode setKeyboardType:UIKeyboardTypeNumberPad];
    _txtCode.leftViewImageName = @"register_code";

    _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCode setTitleColor:UIColorFromRGB(0x0078dd) forState:UIControlStateNormal];
    [_btnCode setTitleColor:kNavColor forState:UIControlStateHighlighted];
    [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:_btnCode];
    _btnCode.frame = Rect(_txtCode.x+_txtCode.width+5,_txtCode.y-3, 95, 36);
    [_btnCode addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchUpInside];
    _btnCode.titleLabel.font = XCFONT(15);
    _btnCode.layer.masksToBounds = YES;
    _btnCode.layer.cornerRadius = 3;
    _btnCode.layer.borderColor = [UIColor grayColor].CGColor;
    _btnCode.layer.borderWidth = 0.5;
    
    [self createLabelWithRect:Rect(10, _txtCode.y+50, 80, 30)];
    _txtPwd = [self createTextField:Rect(_txtName.x,_txtCode.y+50,_txtName.width,_txtName.height)];
    _txtPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    [_txtPwd setDelegate:self];
    [_txtPwd setKeyboardType:UIKeyboardTypeASCIICapable];
    _txtPwd.leftViewImageName = @"register_pwd";
    _txtPwd.isShowTextBool =YES;

    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDetermine = btnRegister;
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(10, _txtPwd.y+_txtPwd.height+42,kScreenWidth-20, 40);
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    btnRegister.layer.masksToBounds = YES;
    btnRegister.layer.cornerRadius = 3;
    [btnRegister addTarget:self action:@selector(regMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
    
    [_txtPwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self checkLogBtnIsEnableWithPhoneNum:_txtName.text withCode:_txtCode.text withPwd:_txtPwd.text];
    
    _checkAgree = [[QCheckBox alloc] initWithDelegate:self];
    _checkAgree.frame = Rect(btnRegister.x, btnRegister.y+btnRegister.height+10,45,30);
    [_checkAgree setTitle:@"同意" forState:UIControlStateNormal];
    [_checkAgree setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [self.view addSubview:_checkAgree];
    _checkAgree.titleLabel.font = XCFONT(14);
    
    UIButton *btnPro = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btnPri = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPro setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
    [btnPri setTitle:@"《隐私权条款》" forState:UIControlStateNormal];
    [btnPro setTitleColor:UIColorFromRGB(0x0078dd) forState:UIControlStateNormal];
    [btnPri setTitleColor:UIColorFromRGB(0x0078dd) forState:UIControlStateNormal];
    
    [self.view addSubview:btnPri];
    [self.view addSubview:btnPro];
    btnPri.titleLabel.font = XCFONT(14);
    btnPro.titleLabel.font = XCFONT(14);
    CGSize sizePro = [@"《用户服务协议》" sizeWithAttributes:@{NSFontAttributeName:XCFONT(14)}];
    CGSize sizePri = [@"《隐私权条款》" sizeWithAttributes:@{NSFontAttributeName:XCFONT(14)}];
    btnPro.frame = Rect(_checkAgree.x+_checkAgree.width+2, _checkAgree.y,sizePro.width,30);
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(btnPro.x+btnPro.width, _checkAgree.y,15,30)];
    
    [lblTemp setText:@"和"];
    [lblTemp setFont:XCFONT(14)];
    [lblTemp setTextColor:UIColorFromRGB(0x343434)];
    [self.view addSubview:lblTemp];
    
    btnPri.frame = Rect(btnPro.x+btnPro.width+12, _checkAgree.y, sizePri.width, 30);
    [btnPro addTarget:self action:@selector(openHttpView:) forControlEvents:UIControlEventTouchUpInside];
    [btnPri addTarget:self action:@selector(openHttpView:) forControlEvents:UIControlEventTouchUpInside];
    btnPro.tag = 101;
    btnPri.tag = 102;
    _checkAgree.checked = YES;
    
}

- (void)closeKeyBoard
{
    if ([_txtName isFirstResponder])
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

- (void)registerServer
{

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
    _txtName.delegate = self;
    _txtPwd.delegate = self;
    [self setTitleText:@"手机注册"];
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    strDate = [fmt stringFromDate:date];
    //设置定时器
    [_txtName becomeFirstResponder];
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

-(void)textFieldDidChange:(id)sender{
    
    [self checkLogBtnIsEnableWithPhoneNum:_txtName.text withCode:_txtCode.text withPwd:_txtPwd.text];
}


/**
 *  检测修改密码的确定按钮是否可点击
 *
 *  @param oldPwdText 旧密码
 *  @param newPwdText 新密码
 *  @param cmdPwdText 再次输入的密码
 */
-(void)checkLogBtnIsEnableWithPhoneNum:(NSString *)phoneNum withCode:(NSString *)code withPwd:(NSString *)pwdText{
    
    BOOL isPhoneNumBool;
    BOOL isCodeBool;
    BOOL isPwdBool;
    
    if (([phoneNum isEqualToString:@""]||[phoneNum length]==0)) {
        
        isPhoneNumBool = NO;
        
    }else{
        isPhoneNumBool = YES;
    }
    
    if (([code isEqualToString:@""]||[code length]==0)) {
        isCodeBool = NO;
    }else{
        isCodeBool = YES;
    }
    
    if (([pwdText isEqualToString:@""]||[pwdText length]==0)) {
        isPwdBool = NO;
    }else{
        isPwdBool = YES;
    }
    
    self.btnDetermine.enabled = (isPhoneNumBool && isCodeBool && isPwdBool);
}


- (void)dealloc
{
    DLog(@"dealloc");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_txtName == textField)
    {
        [_txtCode becomeFirstResponder];
    }
    else if(_txtCode == textField)
    {
        [_txtPwd becomeFirstResponder];
    }
    else if(_txtPwd == textField)
    {
        [self regMobile];
    }
    return YES;
}

- (void)backRegister
{
    __weak RegMobileViewController *__self = self;
    dispatch_async(dispatch_get_main_queue()
    ,^{
        [__self dismissViewControllerAnimated:YES completion:
        ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_PASSWROD_VC object:nil];
        }];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backRegister) name:MESSAGE_UPDATE_PASSWROD_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
