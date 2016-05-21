//
//  ForgetPwdViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 2/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "DecodeJson.h"

#import "InputPwdViewController.h"
#import "BaseService.h"
#import "Toast+UIView.h"
#import "KefuCenterController.h"

@interface ForgetPwdViewController ()<UITextFieldDelegate>
{
    NSTimer *_timer;
    int nSecond;
    NSString *strDate;
}

@property (nonatomic,copy) NSString *strMobile;
@property (nonatomic,strong) RegisterTextField *txtName;
@property (nonatomic,strong) RegisterTextField *txtCode;
@property (nonatomic,strong) UIButton *btnCode;
@property (nonatomic, strong) UIButton *nextBtn;
/**注意文本*/
@property (nonatomic , strong) UILabel *attentionLab;
/**联系客服按钮*/
@property (nonatomic , strong) UIButton *attentionBtn;

@end

@implementation ForgetPwdViewController

-(void)animation1
{
    if (nSecond==0)
    {
        _btnCode.enabled  = YES;
        [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        return ;
    }
    NSString *strInfo = [NSString stringWithFormat:@"%d s后重试",nSecond];
    [_btnCode setTitle:strInfo forState:UIControlStateNormal];
    nSecond--;
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
        
        [StatusBarHUD showError:@"手机号不能为空" belowSubview:self.view];
        
//        [ProgressHUD showError:@"手机号不能为空"];
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
    [self.view makeToastActivity_bird];
    if(!strDate)
    {
        [ProgressHUD showError:@"手机异常"];
        return ;
    }
    NSString *strMd5 = [NSString stringWithFormat:@"action=find&account=%@&date=%@",strMobile,strDate];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    NSString *strInfo = [NSString stringWithFormat:@"%@Message/GetFindPasswordMsgCode&pnum=%@&key=%@",[kHTTPSingle getHttpApi],strMobile,strMd5];
    __weak ForgetPwdViewController *__self = self;
    [BaseService get:strInfo dictionay:nil timeout:8 success:^(id responseObject)
     {
         [__self.view hideToastActivity];
         NSDictionary *dict = nil;;
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             dict = responseObject;
         }
         else{
             dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         }
         if (dict && [[dict objectForKey:@"status"] intValue]==0)
         {
             DLog(@"dict:%@",dict);
             [__self startTimer];
             __self.btnCode.enabled = NO;
             [ProgressHUD showSuccess:@"已发送验证码到目标手机"];
             [__self.txtCode becomeFirstResponder];
         }
         else
         {
             [ProgressHUD showError:[dict objectForKey:@"info"]];
         }
     }fail:^(NSError *error)
     {
             [__self.view hideToastActivity];
         [ProgressHUD showError:@"请求验证码失败"];
     }];
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
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    return textField;
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUIHead
{
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    [self createLabelWithRect:Rect(10, 8+kNavigationHeight, 80, 30)];
    _txtName = [self createTextField:Rect(10, 8+kNavigationHeight, kScreenWidth-20, 30)];
    [_txtName setPlaceholder:@"请输入手机号码"];
    _txtName.leftViewImageName = @"register_mob";
    
    [self createLabelWithRect:Rect(10, _txtName.y+50,80, 30)];
    _txtCode = [self createTextField:Rect(_txtName.x, _txtName.y+50,_txtName.width-100,_txtName.height)];
    _txtCode.leftViewImageName = @"register_code";
    
    [_txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_txtCode setPlaceholder:@"请输入验证码"];
    _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    //[_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    
    [_btnCode setTitleColor:kNavColor forState:UIControlStateNormal];
    [_btnCode setTitleColor:kNavColor forState:UIControlStateHighlighted];
    [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    _btnCode.titleLabel.font = XCFONT(15);
    _btnCode.layer.masksToBounds = YES;
    _btnCode.layer.cornerRadius = 3;
    _btnCode.layer.borderColor = [UIColor grayColor].CGColor;
    _btnCode.layer.borderWidth = 0.5;
    [self.view addSubview:_btnCode];
    _btnCode.frame = Rect(_txtCode.x+_txtCode.width+5,_txtCode.y-3, 95, 36);
    [_btnCode addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(10, _btnCode.y+50, kScreenWidth-20, 40);
    [btnRegister setTitle:@"下一步" forState:UIControlStateNormal];
    [btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    self.nextBtn = btnRegister;
    [self checkLogBtnIsEnableWithPhone:_txtName.text withCode:_txtCode.text];

    btnRegister.layer.masksToBounds = YES;
    btnRegister.layer.cornerRadius = 3;
    [btnRegister addTarget:self action:@selector(authMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
    
    //注意事项
    self.attentionLab = [[UILabel alloc]init];
    self.attentionLab.text = @"注：如未使用手机号注册或绑定手机，请";
    self.attentionLab.textColor = COLOR_Text_Gay;
    self.attentionLab.font = Font_12;
    [self.attentionLab sizeToFit];
    [self.view addSubview:self.attentionLab];
    self.attentionLab.frame = (CGRect){self.nextBtn.x,CGRectGetMaxY(self.nextBtn.frame)+10,self.attentionLab.width,self.attentionLab.height};
    //联系客服的按钮
    self.attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.attentionBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    self.attentionBtn.titleLabel.font = Font_12;
    [self.attentionBtn sizeToFit];
    [self.attentionBtn setTitleColor:COLOR_Bg_Blue forState:UIControlStateNormal];
    self.attentionBtn.frame = (CGRect){CGRectGetMaxX(self.attentionLab.frame),CGRectGetMaxY(self.nextBtn.frame)+10,self.attentionBtn.width,self.attentionLab.height};
    [self.attentionBtn addTarget:self action:@selector(contactService) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.attentionBtn];
    
}

#pragma mark 联系客服
-(void)contactService{
    
    [self.view endEditing:YES];
    KefuCenterController *kefuVc = [[KefuCenterController alloc]init];
    [self.navigationController pushViewController:kefuVc animated:YES];
}

- (void)closeKeyBoard
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_UPDATE_PASSWROD_VC object:nil];
}

- (void)authMobile
{
    NSString *strMobile = _txtName.text;
    if ([strMobile length]==0)
    {
        [ProgressHUD showError:@"手机号不能为空"];
        return ;
    }
    if ([strMobile length]!=11)
    {
        [ProgressHUD showError:@"手机号格式错误"];
        return ;
    }
    NSString *strCode = _txtCode.text;
    if ([strCode length]==0)
    {
        [ProgressHUD showError:@"验证码不能为空"];
        return ;
    }
    [self.view makeToastActivity_bird];
    NSDictionary *parameters = @{@"phone":strMobile,@"code":strCode};
    NSString *strInfo = [NSString stringWithFormat:@"%@Verify/MobileFindPasswordCheckSMS",[kHTTPSingle getHttpApi]];
    _strMobile = strMobile;
    __weak ForgetPwdViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id response)
    {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self.view hideToastActivity];
        });
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        if (dict && [[dict objectForKey:@"status"] intValue]==0)
        {
            __self.btnCode.enabled = NO;
            [ProgressHUD showSuccess:@"验证成功"];
            InputPwdViewController *input = [[InputPwdViewController alloc] initWithMobile:__self.strMobile];
            [self.navigationController pushViewController:input animated:YES];
        }
        else
        {
            [ProgressHUD showError:[dict objectForKey:@"info"]];
        }
    } fail:^(NSError *error) {
        [ProgressHUD showError:@"连接服务器失败"];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    [self setTitleText:@"忘记密码"];
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    strDate = [fmt stringFromDate:date];
    [_txtName setDelegate:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_txtName becomeFirstResponder];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textFieldDidChange:(id)sender{
    
    [self checkLogBtnIsEnableWithPhone:_txtName.text withCode:_txtCode.text];
    
}


/**
 *  检测loginBtn是否可点击
 *
 *  @param pwdText  密码
 *  @param userText 账号
 */
-(void)checkLogBtnIsEnableWithPhone:(NSString *)phoneText withCode:(NSString *)codeText{
    
    BOOL isPhoneBool;
    BOOL isCodeBool;
    
    if (([phoneText isEqualToString:@""]||[phoneText length]==0)) {
        
        isPhoneBool = NO;
        
    }else{
        isPhoneBool = YES;
    }
    
    if (([codeText isEqualToString:@""]||[codeText length]==0)) {
        isCodeBool = NO;
    }else{
        isCodeBool = YES;
    }
    self.nextBtn.enabled = (isCodeBool && isPhoneBool);
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
