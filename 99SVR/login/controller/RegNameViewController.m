//
//  RegNameViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 2/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RegNameViewController.h"
#import "QCheckBox.h"
#import "Toast+UIView.h"
#import "NNSVRViewController.h"
#import "BaseService.h"
#import "DecodeJson.h"
@interface RegNameViewController ()

@property (nonatomic,strong) UIButton *btnCode;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UITextField *txtName;
@property (nonatomic,strong) UITextField *txtPwd;
@property (nonatomic,strong) UITextField *txtCmdPwd;
@property (nonatomic,copy) NSString *strCode;
@property (nonatomic,strong) QCheckBox *checkAgree;

@end

@implementation RegNameViewController
- (void)regMobile
{
    NSDictionary *dict = @{@"type":@"2",@"account":@"17727610912",@"pwd":@"g123456",@"vcode":@"8162"};
    [BaseService postJSONWithUrl:@"http://172.16.41.237:8088/mapi/phoneregister" parameters:dict success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dict:%@",dict);
    }
    fail:nil];
}

- (void)getMobileCode:(NSString *)strMobile
{
    srand((unsigned int)time(NULL));
    long  randomNum = rand();
    NSString *strMd5 = [NSString stringWithFormat:@"action=reg&account=%@&guid=%ld",strMobile,randomNum];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    DLog(@"strMd5:%@",strMd5);
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    DLog(@"strMd5:%@",strMd5);
    NSString *strInfo = [NSString stringWithFormat:@"http://172.16.41.237:8088/mapi/getregmsgcode?pnum=%@&key=%@&Guid=%ld",strMobile,strMd5,randomNum];
    [BaseService getJSONWithUrl:strInfo parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         DLog(@"dict:%@",dict);
         
     } fail:nil];
}

- (void)addLineHeight:(UILabel *)lblTemp
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(lblTemp.x,lblTemp.y+lblTemp.height+10,kScreenWidth-lblTemp.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
}

- (UILabel *)createLabelWithRect:(CGRect)frame
{
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:frame];
    [self.view addSubview:lbl1];
    [lbl1 setFont:XCFONT(14)];
    [lbl1 setTextColor:UIColorFromRGB(0x343434)];
    [self addLineHeight:lbl1];
    return lbl1;
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

- (void)getAuthCode
{

   
    
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
    [_txtName setPlaceholder:@"请输入账号"];
    
    [self createLabelWithRect:Rect(30, 130,80, 30)];
    _txtPwd = [self createTextField:Rect(_txtName.x,130,_txtName.width-100,_txtName.height)];
    [_txtPwd setPlaceholder:@"请输入密码"];
    _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [_btnCode setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_btnCode setTitleColor:kNavColor forState:UIControlStateHighlighted];
    [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:_btnCode];
    _btnCode.frame = Rect(_txtPwd.x+_txtPwd.width+5,_txtPwd.y, 95, 30);
    [_btnCode addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchUpInside];
    _btnCode.titleLabel.font = XCFONT(15);
    
    [self createLabelWithRect:Rect(30, 180, 80, 30)];
    _txtCmdPwd = [self createTextField:Rect(_txtName.x,180,_txtName.width,_txtName.height)];
    [_txtCmdPwd setPlaceholder:@"请再次输入密码"];
    [_txtCmdPwd setSecureTextEntry:YES];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(30, 250, kScreenWidth-60, 40);
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    btnRegister.layer.masksToBounds = YES;
    btnRegister.layer.cornerRadius = 3;
    [btnRegister addTarget:self action:@selector(registerServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
    
    _checkAgree = [[QCheckBox alloc] initWithDelegate:self];
    _checkAgree.frame = Rect(btnRegister.x, btnRegister.y+btnRegister.height+30,60,30);
    [_checkAgree setTitle:@"同意" forState:UIControlStateNormal];
    [_checkAgree setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [self.view addSubview:_checkAgree];
    _checkAgree.titleLabel.font = XCFONT(14);
    _checkAgree.checked = YES;
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
