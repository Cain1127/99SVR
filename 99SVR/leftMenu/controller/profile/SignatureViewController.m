//
//  SignatureViewController.m
//  99SVR
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "SignatureViewController.h"
#import "ZLLogonServerSing.h"
#import "UserInfo.h"

@interface SignatureViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIView *bgView;        /**<背景view*/
@property (nonatomic, strong) UITextView *contentTV;        /**<输入内容框*/
@property (nonatomic, strong) UILabel *confineLabel;        /**<字体长度限制*/
@property (nonatomic, strong) UILabel *lssuePlaceHolderLab;        /**提示*/
@end

@implementation SignatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"修改个性签名"];
    
    [self setupView];
    
    // 赋值
    if (_signature) {
        _contentTV.text = _signature;
        [self textViewDidChange:_contentTV];
    }
}

- (void)setupView {
    
    // 背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.bgView.backgroundColor = COLOR_Bg_Gay;
    [self.view addSubview:self.bgView];
    
    // 签名框
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 100)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.borderWidth = 0.5;
    contentView.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
    [self.bgView addSubview:contentView];
    [self setupContentView:contentView];
    
    // 保存
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    saveButton.layer.cornerRadius = 2.5;
    saveButton.layer.masksToBounds = YES;
    saveButton.frame = Rect(10,CGRectGetMaxY(contentView.frame)+30, kScreenWidth-20, 40);
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateDisabled];
    [saveButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:saveButton];
    _commitBtn = saveButton;
    [self checkLogBtnIsEnableWithText:_contentTV.text];
}

- (void)setupContentView:(UIView *)view {
    self.contentTV = [[UITextView alloc] init];
    self.contentTV.font = Font_15;
    self.contentTV.textColor = COLOR_Text_Gay;
    self.contentTV.keyboardType = UIKeyboardTypeDefault;
    self.contentTV.returnKeyType = UIReturnKeyDone;
    self.contentTV.delegate = self;
    [view addSubview:self.contentTV];
    
    [self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(5, 12, 30, 12));
    }];
    
    self.confineLabel = [[UILabel alloc] init];
    self.confineLabel.text = @"0/20";
    self.confineLabel.font = Font_14;
    self.confineLabel.textColor = COLOR_Text_Gay;
    [view addSubview:self.confineLabel];
    [self.confineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-12);
        make.bottom.equalTo(view.mas_bottom).offset(-12);
    }];
    
    UILabel *lssuePlaceHolderLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 120, 23.5)];
    lssuePlaceHolderLab.font = Font_15;
    lssuePlaceHolderLab.textColor = COLOR_Text_Gay;
    lssuePlaceHolderLab.text = @"请输入个性签名...";
    _lssuePlaceHolderLab = lssuePlaceHolderLab;
    [self.contentTV addSubview:lssuePlaceHolderLab];
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSString *str = [NSString stringWithFormat:@"%d/20",(int)textView.text.length];
    
    if (textView.text.length == 0) {
       _lssuePlaceHolderLab.text= @"请输入个性签名...";
        str = @"0/20";
    }
    else {
        _lssuePlaceHolderLab.text= @"";
    }
    
    if (textView.text.length>20) {
        self.contentTV.text = [textView.text substringToIndex:20];
        str = @"20字";
    }
    self.confineLabel.text  = str ;
    [self checkLogBtnIsEnableWithText:self.contentTV.text];
}

/**
 *  检测loginBtn是否可点击
 */
-(void)checkLogBtnIsEnableWithText:(NSString *)text{
    
    BOOL isTextBool;
    
    if (([text isEqualToString:@""]||[text length]==0)) {
        
        isTextBool = NO;
        
    }else{
        isTextBool = YES;
    }
    self.commitBtn.enabled = isTextBool;
}

/**
 *  完成
 */
- (void)rightItemClick
{
    NSString *strMsg = _contentTV.text;
    if ([strMsg length]==0) {
        [ProgressHUD showError:@"个性签名不能为空"];
        return ;
    }
    ZLLogonServerSing *sing = [ZLLogonServerSing sharedZLLogonServerSing];
    [sing updateNick:[UserInfo sharedUserInfo].strName intro:strMsg sex:[UserInfo sharedUserInfo].sex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updatePro:(NSNotification *)notify
{
    NSString *strMsg = _contentTV.text;
    __weak NSString *__strMsg = strMsg;
    NSNumber *number = notify.object;
    if ([number intValue]==0) {
        @WeakObj(self)
        gcd_main_safe(^{
            [ProgressHUD showSuccess:@"修改个性签名成功"];
            [selfWeak.navigationController popViewControllerAnimated:YES];
            selfWeak.signatureBlock(__strMsg);
        });
    }
    else
    {
        gcd_main_safe(
                      ^{
                          [ProgressHUD showError:@"修改个性签名出错"];
                      });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePro:) name:MEESAGE_LOGIN_SET_PROFILE_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
