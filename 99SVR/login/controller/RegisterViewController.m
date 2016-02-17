//
//  RegisterViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RegisterViewController.h"
#import "IdentifyService.h"
#import "DecodeJson.h"
#import "BaseService.h"
#import "QCheckBox.h"
#import "NNSVRViewController.h"
#import "LSTcpSocket.h"
#import "UserInfo.h"
#import "Toast+UIView.h"
#import "RegisterService.h"

@interface RegisterViewController()

@property (nonatomic,strong) IdentifyService *idenServer;
@property (nonatomic,strong) RegisterService *regServer;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UITextField *txtName;
@property (nonatomic,strong) UITextField *txtPwd;
@property (nonatomic,strong) UITextField *txtCmdPwd;
@property (nonatomic,strong) UITextField *txtCode;
@property (nonatomic,copy) NSString *strCode;
@property (nonatomic,strong) QCheckBox *checkAgree;
@end

@implementation RegisterViewController

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

- (void)initUIHead
{
    _idenServer = [[IdentifyService alloc] init];
    _regServer = [[RegisterService alloc] init];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBtn:btnBack];
    
    UILabel *lbl1 = [self createLabelWithRect:Rect(30, 80, 80, 30)];
    [lbl1 setText:@"昵      称"];
    
    _txtName = [self createTextField:Rect(lbl1.x+lbl1.y+13, lbl1.y, kScreenWidth-lbl1.x*2-lbl1.width, 30)];
    [_txtName setPlaceholder:@"请输入昵称"];
    
    UILabel *lbl2 = [self createLabelWithRect:Rect(lbl1.x, lbl1.y+50,lbl1.width, 30)];
    [lbl2 setText:@"密      码"];
    
    _txtPwd = [self createTextField:Rect(_txtName.x,lbl2.y,_txtName.width,_txtName.height)];
    [_txtPwd setPlaceholder:@"请输入密码"];
    [_txtPwd setSecureTextEntry:YES];
    
    UILabel *lbl3 = [self createLabelWithRect:Rect(lbl2.x, lbl2.y+50, lbl1.width, 30)];
    [lbl3 setText:@"确认密码"];
    
    _txtCmdPwd = [self createTextField:Rect(_txtName.x,lbl3.y,_txtName.width,_txtName.height)];
    [_txtCmdPwd setPlaceholder:@"请再次输入密码"];
    [_txtCmdPwd setSecureTextEntry:YES];
    
    
    UILabel *lbl4 = [self createLabelWithRect:Rect(lbl3.x, lbl3.y+50, lbl1.width, 30)];
    [lbl4 setText:@"验 证 码"];
    
    _txtCode = [self createTextField:Rect(_txtName.x,lbl4.y,_txtName.width-80,_txtName.height)];
    [_txtCode setPlaceholder:@"请输入验证码"];
    
    _imgView = [[UIImageView alloc] initWithFrame:Rect(_txtCode.x+_txtCode.width+1,_txtCode.y, 60, _txtName.height)];
    [self.view addSubview:_imgView];
    [_imgView setUserInteractionEnabled:YES];
    [_imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(initData)]];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnRegister];
    btnRegister.frame = Rect(lbl1.x, lbl4.y+70, kScreenWidth-2*lbl1.x, 40);
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

- (void)closeKeyBoard
{
    if ([_txtName isFirstResponder]) {
        [_txtName resignFirstResponder];
    }
    else if ([_txtPwd isFirstResponder]) {
        [_txtPwd resignFirstResponder];
    }
    else if([_txtCmdPwd isFirstResponder])
    {
        [_txtCmdPwd resignFirstResponder];
    }
    else if([_txtCode isFirstResponder])
    {
        [_txtCode resignFirstResponder];
    }
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUIBody
{
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self setTitleText:@"注册"];
    [self initUIHead];
    [self initUIBody];
    [self requestImgCode];
    _checkAgree.checked = YES;
}

- (void)initData
{
    _txtCode.text = @"";
    __weak RegisterViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [__self requestImgCode];
    });
}

- (void)requestImgCode
{
    __weak RegisterViewController *__self = self;
    _idenServer.identiBlock = ^(int nStatus,NSString *strId,UIImage *img)
    {
        if(nStatus==1)
        {
            __self.strCode = strId;
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [__self.imgView setImage:img];
                           });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [__self.view makeToast:@"加载验证码失败"];
                           });
        }
    };
    [_idenServer requestIdentifier];
}

- (void)registerServer
{
    NSString *strPwd = _txtPwd.text;
    NSString *strName = _txtName.text;
    NSString *strCmdPwd = _txtCmdPwd.text;
    NSString *strCode = _txtCode.text;
    if ([strName length]<1)
    {
        [self.view makeToast:@"昵称不能为空"];
        return ;
    }
    if ([self convertToInt:strName]<4)
    {
        [self.view makeToast:@"昵称太短"];
        return ;
    }
    if ([strPwd length]<1)
    {
        [self.view makeToast:@"密码长度不能为空"];
        return ;
    }
    if ([strPwd length]<6) {
        [self.view makeToast:@"密码长度不能小于6"];
        return ;
    }
    if (![strPwd isEqualToString:strCmdPwd])
    {
        [self.view makeToast:@"两次输入的密码不同"];
        return ;
    }
    if ([strCode length]<1)
    {
        [self.view makeToast:@"验证码不能为空"];
        return ;
    }
    if(!_checkAgree.checked)
    {
        [self.view makeToast:@"必须同意服务条款"];
        return ;
    }
    
    if (!_strCode || !strCode)
    {
        [self.view makeToast:@"验证码信息异常"];
        return ;
    }
    
    NSString *strUrl = @"http://api.99ducaijing.com/mapi/register";
    
    NSDictionary *parameters = @{@"type":[NSNumber numberWithInt:2],@"account":strName,@"pwd":strPwd,@"codeid":_strCode,@"code":strCode};
    
    __weak RegisterViewController *__self = self;
    __weak NSString *__strPwd = strPwd;
    [BaseService postJSONWithUrl:strUrl parameters:parameters success:^(id response)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
         if (dict)
         {
             int nValue = [[dict objectForKey:@"errcode"] intValue];
             if(nValue==1)
             {
                 NSDictionary *data = [dict objectForKey:@"data"];
                 if ([data objectForKey:@"userid"])
                 {
                     [UserDefaults setBool:YES forKey:kIsLogin];
                     [UserDefaults setObject:[data objectForKey:@"userid"] forKey:kUserId];
                     [UserDefaults setObject:__strPwd forKey:kUserPwd];
                     [UserDefaults synchronize];
                     [UserInfo sharedUserInfo].nUserId = [[UserDefaults objectForKey:kUserId] intValue];
                     NSString *userPwd = [UserDefaults objectForKey:kUserPwd];
                     [UserInfo sharedUserInfo].strPwd = userPwd;
                     if(userPwd)
                     {
                         [UserInfo sharedUserInfo].strMd5Pwd = [DecodeJson XCmdMd5String:userPwd];
                     }
                     [[LSTcpSocket sharedLSTcpSocket] setUserInfo];
                     [[LSTcpSocket sharedLSTcpSocket] loginServer:[data objectForKey:@"userid"] pwd:__strPwd];
                     
                     dispatch_async(dispatch_get_main_queue(), ^
                    {
                        [__self.view makeToastActivity];
                        [__self.view makeToast:@"注册成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [__self dismissViewControllerAnimated:YES completion:^{
                            }];
                        });
                    });
                 }
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    [__self.view hideToastActivity];
                                    [__self.view makeToast:[dict objectForKey:@"errmsg"]];
                                    
                                });
             }
         }
         else
         {
             //注册失败
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [__self.view hideToastActivity];
                                [__self.view makeToast:@"连接服务器失败"];
                                
                            });
         }
     }
                            fail:^(NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [__self.view hideToastActivity];
                            [__self.view makeToast:@"连接服务器失败"];
                            
                        });
     }];
}

- (int)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

@end
