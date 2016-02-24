//
//  RegMobileViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 2/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RegMobileViewController.h"
#import "IdeaDetailRePly.h"
#import "Toast+UIView.h"
#import "NNSVRViewController.h"
#import "RegisterService.h"
#import "BaseService.h"
#import "IdentifyService.h"
#import "QCheckBox.h"
#import "DecodeJson.h"


@interface RegMobileViewController ()
{
    NSTimer *_timer;
    int nSecond;
}

@property (nonatomic,strong) IdentifyService *idenServer;
@property (nonatomic,strong) RegisterService *regServer;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UITextField *txtName;
@property (nonatomic,strong) UITextField *txtPwd;
@property (nonatomic,strong) UITextField *txtCmdPwd;
@property (nonatomic,strong) UITextField *txtCode;
@property (nonatomic,copy) NSString *strCode;
@property (nonatomic,strong) QCheckBox *checkAgree;
@property (nonatomic,strong) UIButton *btnCode;

@end

@implementation RegMobileViewController

- (void)regMobile
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
    NSString *strCode = _txtCode.text;
    if ([strCode length]==0)
    {
        [self.view makeToast:@"验证码不能为空"];
        return ;
    }
    NSString *strPwd = _txtPwd.text;
    if([strPwd length]==0)
    {
        [self.view makeToast:@"密码不能为空"];
        return ;
    }
    NSDictionary *dict = @{@"type":@"2",@"account":strMobile,@"pwd":strPwd,@"vcode":strCode};
    __weak RegMobileViewController *__self = self;
    NSString *strInfo = [NSString stringWithFormat:@"%@mapi/phoneregister",kRegisterNumber];
    [BaseService postJSONWithUrl:strInfo parameters:dict success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if(dict && [[dict objectForKey:@"errcode"] intValue]==1)
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                 [__self.view makeToast:@"注册成功"];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
            ^{
                [__self navBack];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view makeToast:[dict objectForKey:@"errmsg"]];
            });
        }
    } fail:nil];
}

- (void)getMobileCode:(NSString *)strMobile
{
    srand((unsigned int)time(NULL));
    long  randomNum = rand();
    NSString *strMd5 = [NSString stringWithFormat:@"action=reg&account=%@&guid=%ld",strMobile,randomNum];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    NSString *strInfo = [NSString stringWithFormat:@"%@mapi/getregmsgcode?pnum=%@&key=%@&Guid=%ld",kRegisterNumber,strMobile,strMd5,randomNum];
    __weak RegMobileViewController *__self = self;
    [BaseService getJSONWithUrl:strInfo parameters:nil success:^(id responseObject)
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
     }
     fail:^(NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),
         ^{
             [__self.view makeToast:@"请求验证码失败"];
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
    _idenServer = [[IdentifyService alloc] init];
    _regServer = [[RegisterService alloc] init];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBtn:btnBack];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setTitle:@"账号注册" forState:UIControlStateNormal];
    [btnRight setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBtn:btnRight];
    
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
    
    [self createLabelWithRect:Rect(30, 180, 80, 30)];
    _txtPwd = [self createTextField:Rect(_txtName.x,180,_txtName.width,_txtName.height)];
    [_txtPwd setPlaceholder:@"请输入密码"];
    [_txtPwd setSecureTextEntry:YES];
    
//    UILabel *lbl4 = [self createLabelWithRect:Rect(lbl3.x, lbl3.y+50, lbl1.width, 30)];
//    [lbl4 setText:@"确认密码"];
    
//    _txtCmdPwd = [self createTextField:Rect(_txtName.x,lbl4.y,_txtName.width,_txtName.height)];
//    [_txtCmdPwd setPlaceholder:@"请输入确认密码"];
//    [_txtCmdPwd setSecureTextEntry:YES];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(30, 180+70, kScreenWidth-60, 40);
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    btnRegister.layer.masksToBounds = YES;
    btnRegister.layer.cornerRadius = 3;
    [btnRegister addTarget:self action:@selector(regMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
    
    _checkAgree = [[QCheckBox alloc] initWithDelegate:self];
    _checkAgree.frame = Rect(btnRegister.x, btnRegister.y+btnRegister.height+30,60,30);
    [_checkAgree setTitle:@"同意" forState:UIControlStateNormal];
    [_checkAgree setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [self.view addSubview:_checkAgree];
    _checkAgree.titleLabel.font = XCFONT(14);
    
    UIButton *btnPro = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *btnPri = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPro setTitle:@"用户服务协议、" forState:UIControlStateNormal];
    [btnPri setTitle:@"隐私权条款" forState:UIControlStateNormal];
    [btnPro setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateNormal];
    [btnPri setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateNormal];
    
    [self.view addSubview:btnPri];
    [self.view addSubview:btnPro];
    btnPri.titleLabel.font = XCFONT(14);
    btnPro.titleLabel.font = XCFONT(14);
    CGSize sizePro = [@"用户服务协议、" sizeWithAttributes:@{NSFontAttributeName:XCFONT(14)}];
    CGSize sizePri = [@"隐私权条款" sizeWithAttributes:@{NSFontAttributeName:XCFONT(14)}];
    btnPro.frame = Rect(_checkAgree.x+_checkAgree.width+2, _checkAgree.y,sizePro.width,30);
    btnPri.frame = Rect(btnPro.x+btnPro.width, _checkAgree.y, sizePri.width, 30);
    [btnPro addTarget:self action:@selector(openHttpView:) forControlEvents:UIControlEventTouchUpInside];
    [btnPri addTarget:self action:@selector(openHttpView:) forControlEvents:UIControlEventTouchUpInside];
    btnPro.tag = 101;
    btnPri.tag = 102;
}

- (void)closeKeyBoard
{
    
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
    [self presentViewController:nnView animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    [self setTitleText:@"手机注册"];
    _txtName.text = @"17727610912";
    //设置定时器
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

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
