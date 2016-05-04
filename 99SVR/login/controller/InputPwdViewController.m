//
//  InputPwdViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 2/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "InputPwdViewController.h"
#import "UserInfo.h"
#import "RoomViewController.h"
#import "ZLLogonServerSing.h"
#import "ProgressHUD.h"
#import "Toast+UIView.h"
#import "BaseService.h"

@interface InputPwdViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) RegisterTextField *txtName;
@property (nonatomic,copy) NSString *strMobile;
@property (nonatomic,strong) UILabel *lblError;
@property (nonatomic,copy) NSString *strPwd;
@property (nonatomic,strong) RegisterTextField *txtCode;
/**完成*/
@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation InputPwdViewController

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
    [textField setKeyboardType:UIKeyboardTypeASCIICapable];
//    [textField setSecureTextEntry:YES];
    return textField;
}

- (void)authMobile
{
    NSString *strPassword = _txtName.text;
    if ([strPassword length]==0)
    {
        [ProgressHUD showError:@"密码不能为空"];
        return ;
    }
    NSString *strCode = _txtCode.text;
    if ([strCode length]==0)
    {
        [ProgressHUD showError:@"确认密码不能为空"];
        return ;
    }
    if (![strCode isEqualToString:strPassword])
    {
        [ProgressHUD showError:@"两次密码不一致"];
        return ;
    }
    [self.view makeToastActivity_bird];
    NSDictionary *parameters = @{@"phone":_strMobile,@"password":strPassword};
    NSString *strInfo = [NSString stringWithFormat:@"%@MApi/MobileFindPassword",kRegisterNumber];
    _strPwd = strPassword;
    __weak InputPwdViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id response)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [__self.view hideToastActivity];
         });
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:__self.strMobile pwd:__self.strPwd];
             [self navBack];
             [ProgressHUD showSuccess:@"重设密码成功"];
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(),
             ^{
                 [ProgressHUD showError:[dict objectForKey:@"errmsg"]];
             });
         }
         
     } fail:^(NSError *error) {
         dispatch_async(dispatch_get_main_queue(),
         ^{
             [__self.view hideToastActivity];
             [ProgressHUD showError:@"连接服务器失败"];
         });
     }];
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
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];

    [self createLabelWithRect:Rect(30, 72, 80, 30)];
    _txtName = [self createTextField:Rect(30, 72, kScreenWidth-60, 30)];
    _txtName.leftViewImageName = @"register_pwd_new";
    _txtName.isShowTextBool = YES;
    [_txtName setPlaceholder:@"请输入新密码"];
    
    [self createLabelWithRect:Rect(30, _txtName.y+50,80, 30)];
    _txtCode = [self createTextField:Rect(_txtName.x,_txtName.y+50,_txtName.width,_txtName.height)];
    _txtCode.leftViewImageName = @"register_pwd_ok";
    _txtCode.isShowTextBool = YES;
    [_txtCode setPlaceholder:@"请再次输入密码"];
    
    [_txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    _lblError = [[UILabel alloc] initWithFrame:Rect(30, _txtCode.y+40, kScreenWidth-60, 20)];
    [_lblError setFont:XCFONT(14)];
    [self.view addSubview:_lblError];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(30, _lblError.y+35, kScreenWidth-60, 40);
    [btnRegister setTitle:@"完成" forState:UIControlStateNormal];
    [btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    btnRegister.layer.masksToBounds = YES;
    btnRegister.layer.cornerRadius = 3;
    self.commitBtn = btnRegister;
    [self checkLogBtnIsEnableWithPwd:_txtName.text withAgainPwd:_txtCode.text];
    [btnRegister addTarget:self action:@selector(authMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
}

- (void)closeKeyBoard
{
    
}
    // Do any additional setup after loading the view.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    [_txtName setDelegate:self];
    [_txtCode setDelegate:self];
    [_txtName becomeFirstResponder];
    [self setTitleText:@"设置新密码"];
    [_txtName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithMobile:(NSString *)strMobile
{
    self = [super init];
    _strMobile = strMobile;
    return  self;
}

-(void)textFieldDidChange:(id)sender{
    
    [self checkLogBtnIsEnableWithPwd:_txtName.text withAgainPwd:_txtCode.text];
    
}

/**
 *  检测loginBtn是否可点击
 *
 *  @param pwdText  密码
 *  @param userText 账号
 */
-(void)checkLogBtnIsEnableWithPwd:(NSString *)pwdText withAgainPwd:(NSString *)againPwdText{
    
    BOOL isPwdBool;
    BOOL isAgainPwdBool;
    
    if (([pwdText isEqualToString:@""]||[pwdText length]==0)) {
        
        isPwdBool = NO;
        
    }else{
        isPwdBool = YES;
    }
    
    if (([againPwdText isEqualToString:@""]||[againPwdText length]==0)) {
        isAgainPwdBool = NO;
    }else{
        isAgainPwdBool = YES;
    }
    self.commitBtn.enabled = (isPwdBool && isAgainPwdBool);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_txtName == textField)
    {
        if (range.location>16 || range.location+string.length>16)
        {
            return NO;
        }
    }
    else if(_txtCode == textField)
    {
        if(range.location>16 || range.location+string.length > 16)
        {
            return NO;
        }
    }
    return YES;
}

@end
