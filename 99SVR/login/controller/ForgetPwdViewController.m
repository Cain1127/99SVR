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

@interface ForgetPwdViewController ()
{
    NSTimer *_timer;
    int nSecond;
}
@property (nonatomic,copy) NSString *strMobile;
@property (nonatomic,strong) UITextField *txtName;
@property (nonatomic,strong) UITextField *txtCode;
@property (nonatomic,strong) UIButton *btnCode;

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
    NSString *strInfo = [NSString stringWithFormat:@"重新发送(%d)",nSecond];
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
    if (strMobile.length!=11)
    {
        [self.view makeToast:@"手机长度错误"];
        return ;
    }
    if(![DecodeJson getSrcMobile:strMobile])
    {
        [self.view makeToast:@"手机格式不正确"];
        return ;
    }
    srand((unsigned int)time(NULL));
    long  randomNum = rand();
    NSString *strMd5 = [NSString stringWithFormat:@"action=find&account=%@&guid=%ld",strMobile,randomNum];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    NSString *strInfo = [NSString stringWithFormat:@"%@MApi/GetFindPasswordMsgCode?pnum=%@&key=%@&Guid=%ld",kFindServer,strMobile,strMd5,randomNum];
    __weak ForgetPwdViewController *__self = self;
    
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if (dict && [[dict objectForKey:@"errcode"] intValue]==1)
         {
             DLog(@"dict:%@",dict);
             [__self startTimer];
             dispatch_async(dispatch_get_main_queue(),
                ^{
                    __self.btnCode.enabled = NO;
                    [__self.view makeToast:@"已发送验证码到目标手机"];
                });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(),
                ^{
                    [__self.view makeToast:[dict objectForKey:@"errmsg"]];
                });
         }
     }fail:^(NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self.view makeToast:@"请求验证码失败"];
        });
     }];
}

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
    [_txtName setPlaceholder:@"请输入手机号码"];
    
    [self createLabelWithRect:Rect(30, 130,80, 30)];
    _txtCode = [self createTextField:Rect(_txtName.x,130,_txtName.width-100,_txtName.height)];
    [_txtCode setPlaceholder:@"请输入验证码"];
    _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [_btnCode setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_btnCode setTitleColor:kNavColor forState:UIControlStateHighlighted];
    [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:_btnCode];
    _btnCode.frame = Rect(_txtCode.x+_txtCode.width+5,_txtCode.y, 95, 30);
    [_btnCode addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchUpInside];
    _btnCode.titleLabel.font = XCFONT(15);
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(30, 200, kScreenWidth-60, 40);
    [btnRegister setTitle:@"下一步" forState:UIControlStateNormal];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backLeft) name:MESSAGE_UPDATE_PASSWROD_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_UPDATE_PASSWROD_VC object:nil];
}

- (void)backLeft
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_PASSWROD_VC object:nil];
    }];
}

- (void)authMobile
{
    NSString *strMobile = _txtName.text;
    if ([strMobile length]==0)
    {
        [self.view makeToast:@"手机号不能为空"];
        return ;
    }
    NSString *strCode = _txtCode.text;
    if ([strCode length]==0)
    {
        [self.view makeToast:@"验证码不能为空"];
        return ;
    }
    NSDictionary *parameters = @{@"phone":strMobile,@"code":strCode};
    NSString *strInfo = [NSString stringWithFormat:@"%@MApi/MobileFindPasswordCheckSMS",kFindServer];
    _strMobile = strMobile;
    __weak ForgetPwdViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:parameters success:^(id response)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        if (dict && [[dict objectForKey:@"errcode"] intValue]==1)
        {
            DLog(@"dict:%@",dict);
            [__self startTimer];
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               __self.btnCode.enabled = NO;
                               [__self.view makeToast:@"验证成功"];
                           });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                InputPwdViewController *input = [[InputPwdViewController alloc] initWithMobile:__self.strMobile];
                [self presentViewController:input animated:YES completion:nil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    _txtName.text = @"17727610912";
    _txtCode.text = @"5614";
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

@end
