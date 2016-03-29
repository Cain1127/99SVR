//
//  SignatureViewController.m
//  99SVR
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()<UITextFieldDelegate>
/** 昵称输入框 */
@property(nonatomic,strong) UITextField *signatureTextField;
@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"修改个性签名"];
    [self setupView];
}

- (void)setupView
{
    self.view.backgroundColor = kTableViewBgColor;
    
    //输入框底层
    UIView *inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.frame = CGRectMake(0, 70, kScreenWidth, 150);
    [self.view addSubview:inputView];
    
    //签名输入框
    _signatureTextField = [[UITextField alloc] init];
    _signatureTextField.placeholder = @"请输入签名";
    _signatureTextField.delegate = self;
    _signatureTextField.font = kFontSize(14);
    _signatureTextField.textColor = [UIColor blackColor];
    _signatureTextField.keyboardType = UIKeyboardTypeDefault;
    _signatureTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _signatureTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_signatureTextField setValue:kFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    [_signatureTextField setValue:RGB(151, 151, 151) forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_signatureTextField];
    _signatureTextField.frame = CGRectMake(12, 74, kScreenWidth - 2 * 12, 150);
    
    //建议提醒文字
//    UILabel * adviceLabel = [[UILabel alloc] init];
//    adviceLabel.text = @"昵称支持4-20中英文、数字及下划线组合";
//    adviceLabel.textColor = [UIColor blackColor];
//    adviceLabel.font = kFontSize(14);;
//    adviceLabel.numberOfLines = 0;
//    adviceLabel.frame = CGRectMake(12, CGRectGetMaxY(_signatureTextField.frame), kScreenWidth - 12*2, 30);
//    [self.view addSubview:adviceLabel];
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setTitle:@"保存" forState:UIControlStateNormal];
    [btnRight setBackgroundColor:UIColorFromRGB(0x7fbbee)];
    [self.view addSubview:btnRight];
    btnRight.frame = Rect(10,_signatureTextField.y+_signatureTextField.height+30, kScreenWidth-20, 40);
    [btnRight setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  完成
 */
- (void)rightItemClick
{
    [MBProgressHUD showMessage:@""];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.signatureBlock) {
            self.signatureBlock(@"123");
        }
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showText:@"签名设置成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
