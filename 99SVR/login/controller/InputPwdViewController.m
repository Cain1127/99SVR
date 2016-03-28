//
//  InputPwdViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 2/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "InputPwdViewController.h"
#import "UserInfo.h"
#import "LSTcpSocket.h"
#import "Toast+UIView.h"
#import "BaseService.h"

@interface InputPwdViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *txtName;
@property (nonatomic,copy) NSString *strMobile;
@property (nonatomic,strong) UILabel *lblError;
@property (nonatomic,copy) NSString *strPwd;
@property (nonatomic,strong) UITextField *txtCode;
@end

@implementation InputPwdViewController

- (void)createLabelWithRect:(CGRect)frame
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(frame.origin.x,frame.origin.y+frame.size.height+10,kScreenWidth-frame.origin.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
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
    [textField setKeyboardType:UIKeyboardTypeASCIICapable];
//    [textField setSecureTextEntry:YES];
    return textField;
}

- (void)authMobile
{
    NSString *strMobile = _txtName.text;
    if ([strMobile length]==0)
    {
        [_lblError setText:@"密码不能为空"];
        return ;
    }
    NSString *strCode = _txtCode.text;
    if ([strCode length]==0)
    {
        [_lblError setText:@"确认密码不能为空"];
        return ;
    }
    if (![strCode isEqualToString:strMobile])
    {
        [_lblError setText:@"两次密码不一致"];
        return ;
    }
    [_lblError setText:@""];
    [self.view makeToastActivity];
    NSDictionary *parameters = @{@"phone":_strMobile,@"password":strMobile};
    NSString *strInfo = [NSString stringWithFormat:@"%@MApi/MobileFindPassword",kRegisterNumber];
    _strPwd = strMobile;
    __weak InputPwdViewController *__self = self;
    __weak LSTcpSocket *__lsTcp = [LSTcpSocket sharedLSTcpSocket];
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id response)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [__self.view hideToastActivity];
         });
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             [__lsTcp loginServer:__self.strMobile pwd:__self.strPwd];
             dispatch_async(dispatch_get_main_queue(),
             ^{
                 [__self.lblError setText:@"密码设置成功"];
             });
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
             ^{
                 [__self dismissViewControllerAnimated:YES completion:
                  ^{
                      [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_PASSWROD_VC object:nil];
                  }];
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(),
                            ^{
                                [__self.lblError setText:[dict objectForKey:@"errmsg"]];
                            });
         }
         
     } fail:^(NSError *error) {
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [__self.view hideToastActivity];
                            [__self.lblError setText:@"连接服务器失败"];
                        });
     }];
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUIHead
{
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];

    [self createLabelWithRect:Rect(30, 8, 80, 30)];
    _txtName = [self createTextField:Rect(30, 8, kScreenWidth-60, 30)];
    [_txtName setPlaceholder:@"请输入密码"];
    
    [self createLabelWithRect:Rect(30, _txtName.y+50,80, 30)];
    _txtCode = [self createTextField:Rect(_txtName.x,_txtName.y+50,_txtName.width,_txtName.height)];
    [_txtCode setPlaceholder:@"请确认密码"];
    
    _lblError = [[UILabel alloc] initWithFrame:Rect(30, _txtCode.y+40, kScreenWidth-60, 20)];
    [_lblError setFont:XCFONT(14)];
    [_lblError setTextColor:[UIColor redColor]];
    [self.view addSubview:_lblError];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(30, _lblError.y+35, kScreenWidth-60, 40);
    [btnRegister setTitle:@"完成" forState:UIControlStateNormal];
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
    
}
    // Do any additional setup after loading the view.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    [_txtName setDelegate:self];
    [_txtCode setDelegate:self];
    [_txtName becomeFirstResponder];
    [self setTitleText:@"设置密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (id)initWithMobile:(NSString *)strMobile
{
    self = [super init];
    _strMobile = strMobile;
    return  self;
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
