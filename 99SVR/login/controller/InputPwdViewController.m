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

@interface InputPwdViewController ()
@property (nonatomic,strong) UITextField *txtName;
@property (nonatomic,copy) NSString *strMobile;
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
    return textField;
}

- (void)authMobile
{
    NSString *strMobile = _txtName.text;
    if ([strMobile length]==0)
    {
        [self.view makeToast:@"密码不能为空"];
        return ;
    }
    NSString *strCode = _txtCode.text;
    if ([strCode length]==0)
    {
        [self.view makeToast:@"确认密码不能为空"];
        return ;
    }
    NSDictionary *parameters = @{@"phone":_strMobile,@"password":strMobile};
    NSString *strInfo = [NSString stringWithFormat:@"%@MApi/MobileFindPassword",kFindServer];
    _strPwd = strMobile;
    __weak InputPwdViewController *__self = self;
    __weak LSTcpSocket *__lsTcp = [LSTcpSocket sharedLSTcpSocket];
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id response)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
         if (dict && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             [__lsTcp loginServer:__self.strMobile pwd:__self.strPwd];
             dispatch_async(dispatch_get_main_queue(),
             ^{
                 [__self.view makeToast:@"密码设置成功"];
             });
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 
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
                                [__self.view makeToast:[dict objectForKey:@"errmsg"] duration:2.0 position:@"center"];
                            });
         }
         
     } fail:^(NSError *error) {
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [__self.view makeToast:@"连接服务器失败"];
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
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBtn:btnBack];
    
    [self createLabelWithRect:Rect(30, 80, 80, 30)];
    _txtName = [self createTextField:Rect(30, 80, kScreenWidth-60, 30)];
    [_txtName setPlaceholder:@"请输入密码"];
    
    [self createLabelWithRect:Rect(30, 130,80, 30)];
    _txtCode = [self createTextField:Rect(_txtName.x,130,_txtName.width,_txtName.height)];
    [_txtCode setPlaceholder:@"请确认密码"];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(30, 200, kScreenWidth-60, 40);
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
    _txtName.text =@"qwerty";
    _txtCode.text =@"qwerty";
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
@end
