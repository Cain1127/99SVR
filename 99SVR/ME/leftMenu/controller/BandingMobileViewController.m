//
//  BandingMobileViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "BandingMobileViewController.h"
#import "Toast+UIView.h"
#import "BandNewMobileViewController.h"
#import "ProgressHUD.h"
#import "BaseService.h"
#import "DecodeJson.h"
#import "UserInfo.h"
#import "SettingCenterController.h"
#import "StockDealViewController.h"
#import "RegisterTextField.h"
#import "ZLMeTeamPrivate.h"
#import "RoomViewController.h"
#import "TQMeCustomizedViewController.h"
#import "XMyViewController.h"

@interface BandingMobileViewController ()<UITextFieldDelegate>
{
    int nSecond;
    NSString *strDate;
    int banding;
}
@property (nonatomic,strong) RegisterTextField *txtName;
@property (nonatomic,strong) RegisterTextField *txtCode;
@property (nonatomic,strong) UIButton *btnCode;
@property (nonatomic,strong) RegisterTextField *txtPwd;
/**注册按钮*/
@property (nonatomic , strong) UIButton *btnRegister;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *password;

@end
@implementation BandingMobileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    banding = [UserInfo sharedUserInfo].banding;
    if (banding) {
        [self setTitleText:@"修改绑定手机"];
    }
    else
    {
        [self setTitleText:@"绑定手机"];
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMdd"];
    strDate = [fmt stringFromDate:date];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self createText];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_txtName becomeFirstResponder];
    });
    
}

- (void)createText
{
    CGRect frame = Rect(10.0f, 84.0f, kScreenWidth - 130.0f, 30.0f);
    if (!banding) {
        [self createLabelWithRect:Rect(10.0f, 84.0f, 80.0f, 30.0f)];
        _txtName = [self createTextField:Rect(10.0f, 84.0f, kScreenWidth - 20.0f, 30.0f)];
        [_txtName setPlaceholder:@"请输入手机号码"];
        [_txtName setKeyboardType:UIKeyboardTypeNumberPad];
        frame.origin.y = _txtName.y + 50.0f;
    }
    else
    {
        frame.origin.y = 84.0f;
    }
    
    [self createLabelWithRect:Rect(10, frame.origin.y,80, 30)];
    _txtCode = [self createTextField:frame];
    [_txtCode setPlaceholder:@"请输入验证码"];
    [_txtCode setKeyboardType:UIKeyboardTypeNumberPad];
    
    _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
//    [_btnCode setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [_btnCode setTitleColor:kNavColor forState:UIControlStateNormal];
    [_btnCode setTitleColor:kNavColor forState:UIControlStateHighlighted];
    [_btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    _btnCode.titleLabel.font = XCFONT(15);
    _btnCode.layer.masksToBounds = YES;
    _btnCode.layer.cornerRadius = 3;
    _btnCode.layer.borderColor = [UIColor grayColor].CGColor;
    _btnCode.layer.borderWidth = 0.5;
    [self.view addSubview:_btnCode];
    _btnCode.frame = Rect(kScreenWidth-110,_txtCode.y-3, 95, 36);
    [_btnCode addTarget:self action:@selector(getAuthCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _txtCode.leftViewImageName = @"register_code";
    _txtName.leftViewImageName = @"register_mob";

    
    self.btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.btnRegister];
    self.btnRegister.frame = Rect(10, _btnCode.y+60, kScreenWidth-20, 40);
    [self.btnRegister setTitle:@"确定" forState:UIControlStateNormal];
    [self.btnRegister setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    self.btnRegister.layer.masksToBounds = YES;
    self.btnRegister.layer.cornerRadius = 3;
    [self.btnRegister addTarget:self action:@selector(authMobile) forControlEvents:UIControlEventTouchUpInside];
    self.btnRegister.enabled = NO;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)]];
}

- (void)closeKeyBoard
{
    [self.view endEditing:YES];
}

-(void)textFieldDidChange:(id)sender{
    
    [self checkEnterBtnIsEnableWithPhone:_txtName.text withCode:_txtCode.text];
}

- (void)dealloc
{
    DLog(@"dealloc");
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

- (void)createLabelWithRect:(CGRect)frame
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(frame.origin.x,frame.origin.y+frame.size.height+10,kScreenWidth-frame.origin.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
}

- (void)getAuthCode
{
    _mobile = _txtName.text;
    if(!banding)
    {
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
    }
//    [ProgressHUD show:@"获取验证码..."];
    [self.view makeToastMsgActivity:@"获取验证码..."];
    [self getMobileCode:_mobile];
}

- (void)getMobileCode:(NSString *)strMobile
{
    if(!strDate)
    {
        [ProgressHUD showError:@"获取信息失败"];
        return ;
    }
    NSString *strMd5;
    if(banding)
    {
        strMd5 = [NSString stringWithFormat:@"action=4&date=%@&userid=%d",strDate,[UserInfo sharedUserInfo].nUserId];
    }
    else
    {
        strMd5 = [NSString stringWithFormat:@"action=3&date=%@&pnum=%@",strDate,_mobile];
    }
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    strMd5 = [DecodeJson XCmdMd5String:strMd5];
    NSDictionary *parameters = nil;
    if(!banding)
    {
        parameters = @{@"action":@(3),@"pnum":_mobile,@"key":strMd5,@"client":@(2)};
    }
    else
    {
        parameters = @{@"action":@(4),@"userid":@([UserInfo sharedUserInfo].nUserId),@"key":strMd5,@"client":@(2)};
    }
    @WeakObj(self)
    NSString *strUrl = [NSString stringWithFormat:@"%@Message/getmsgcode",[kHTTPSingle getHttpApi]];
    [BaseService postJSONWithUrl:strUrl parameters:parameters success:^(id responseObject)
    {
         [self.view hideToastActivity];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [[dict objectForKey:@"status"] intValue]==0)
         {
             DLog(@"dict:%@",dict);
             [selfWeak startTimer];
            selfWeak.btnCode.enabled = NO;
            [ProgressHUD showSuccess:@"已发送验证码到目标手机"];
            [selfWeak.txtCode becomeFirstResponder];
         
         }
         else
         {
             [ProgressHUD showError:[dict objectForKey:@"info"]];
         }
     }
     fail:^(NSError *error)
     {
         [self.view hideToastActivity];
         [ProgressHUD showError:@"连接服务器失败"];
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
        if (range.location>11 || range.location+string.length>11){
            return NO;
        }
    }
    return YES;
}



- (void)authMobile
{
    if (!banding) {
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
    
    if(!banding)
    {
        //直接绑定手机
        paramters = @{@"client":@"2",@"userid":@([UserInfo sharedUserInfo].nUserId),@"pnum":_mobile,@"action":@(3),@"code":strCode};
        strInfo = [NSString stringWithFormat:@"%@User/bindPhone",[kHTTPSingle getHttpApi]];
    }
    else
    {
        paramters = @{@"client":@"2",@"userid":@([UserInfo sharedUserInfo].nUserId),@"action":@(4),@"code":strCode};
        strInfo = [NSString stringWithFormat:@"%@User/checkphonecode",[kHTTPSingle getHttpApi]];
    }
    @WeakObj(self);
    __block int __banding = banding;
    [BaseService postJSONWithUrl:strInfo parameters:paramters success:^(id responseObject)
     {
         [selfWeak.view hideToastActivity];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if(dict && [dict objectForKey:@"status"] && [[dict objectForKey:@"status"] intValue]==0)
         {
             //没绑定过的，直接绑定，然后返回
             if (!__banding) {
                 
                 [UserInfo sharedUserInfo].banding = 1;
                 [UserInfo sharedUserInfo].strMobile = _mobile;
                 [ProgressHUD showSuccess:@"绑定手机成功"];
                 
                 [self MarchBackLeft];
                 
                 //判断是不是返回上一个界面还是要返回刷新兑换私人定制的页面
//                 [selfWeak.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [selfWeak.navigationController pushViewController:[[BandNewMobileViewController alloc] init] animated:YES];
             }
         }
         else
         {
             gcd_main_safe(
             ^{
                   [ProgressHUD showError:[dict objectForKey:@"info"]];
             });
         }
     }fail:^(NSError *error)
     {
         gcd_main_safe(^{
             [selfWeak.view hideToastActivity];
             [ProgressHUD showError:@"连接服务器失败"];
         });
     }];
}

#pragma mark 重写父类返回方法
-(void)MarchBackLeft{
    

    //判断有没有高手操盘详情

    BOOL backotherVCBool = NO;
    UIViewController *stockDealVC = nil;
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[StockDealViewController class]]) {//高手操盘详情
            backotherVCBool =  YES;
            stockDealVC = viewController;
            break;
        }
    }
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[TQMeCustomizedViewController class]]) {//查看我的私私人定制的列表看有几个
            backotherVCBool =  YES;
            stockDealVC = viewController;
            break;
        }
    }
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[ZLMeTeamPrivate class]]) {//团队的vip详情页面
            backotherVCBool =  YES;
            stockDealVC = viewController;
            break;
        }
    }
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[RoomViewController class]]) {//团队的vip详情页面
            backotherVCBool =  YES;
            stockDealVC = viewController;
            break;
        }
    }
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[XMyViewController class]]) {//团队的vip详情页面
            backotherVCBool =  YES;
            stockDealVC = viewController;
            break;
        }
    }
    
    if (backotherVCBool) {//跳转到到股票详情视图
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];
        [self.navigationController popToViewController:stockDealVC animated:YES];
    }else{//正常返回
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**
 *  检测确定按钮是否可以点击
 *
 *  @param phoneText 手机号
 *  @param pwdText   密码
 *  @param codeText  验证码
 */

-(void)checkEnterBtnIsEnableWithPhone:(NSString *)phoneText withCode:(NSString *)codeText{
    
    BOOL phoneTextBool;
    BOOL codeTextBool;
    

    
    
    if (([phoneText isEqualToString:@""]||[phoneText length]==0)) {
        
        phoneTextBool = NO;
        
    }else{
        phoneTextBool = YES;
    }

    if (([codeText isEqualToString:@""]||[codeText length]==0)) {
        codeTextBool = NO;
    }else{
        codeTextBool = YES;
    }

    
    
    if (banding) {//已绑定过手机号
        
        self.btnRegister.enabled = codeTextBool;

        
    }else{//未绑定手机号

        if (_txtName.text.length >=11) {
            _txtName.text = [_txtName.text substringToIndex:11];
        }
        self.btnRegister.enabled = (codeTextBool && phoneTextBool);
    
    }
    
}


@end
