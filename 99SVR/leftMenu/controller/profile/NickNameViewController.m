//
//  NickNameViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/17.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "NickNameViewController.h"

@interface NickNameViewController ()<UITextFieldDelegate>
/** 昵称输入框 */
@property(nonatomic,strong) UITextField *nickNameTextField;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"修改昵称"];
    [self setupView];
}

- (void)setupView
{
    self.view.backgroundColor = kTableViewBgColor;
    
    //输入框底层
    UIView *inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.frame = CGRectMake(0, 74, kScreenWidth, 48);
    [self.view addSubview:inputView];
    
    //昵称输入框
    _nickNameTextField = [[UITextField alloc] init];
    _nickNameTextField.placeholder = @"请输入昵称";
    _nickNameTextField.delegate = self;
    _nickNameTextField.font = kFontSize(14);
    _nickNameTextField.textColor = [UIColor blackColor];
    _nickNameTextField.keyboardType = UIKeyboardTypeDefault;
    _nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nickNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_nickNameTextField setValue:kFontSize(14) forKeyPath:@"_placeholderLabel.font"];
    [_nickNameTextField setValue:RGB(151, 151, 151) forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_nickNameTextField];
    _nickNameTextField.frame = CGRectMake(12, 74, kScreenWidth - 2 * 12, 48);
    
    //建议提醒文字
    UILabel * adviceLabel = [[UILabel alloc] init];
    adviceLabel.text = @"昵称支持4-20中英文、数字及下划线组合";
    adviceLabel.textColor = [UIColor blackColor];
    adviceLabel.font = kFontSize(14);;
    adviceLabel.numberOfLines = 0;
    adviceLabel.frame = CGRectMake(12, CGRectGetMaxY(_nickNameTextField.frame), kScreenWidth - 12*2, 30);
    [self.view addSubview:adviceLabel];

    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setTitle:@"保存" forState:UIControlStateNormal];
    [btnRight setBackgroundColor:UIColorFromRGB(0x7fbbee)];
    [self.view addSubview:btnRight];
    btnRight.frame = Rect(10,_nickNameTextField.y+_nickNameTextField.height+30, kScreenWidth-20, 40);
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
        if (self.nickNameBlock) {
            self.nickNameBlock(@"123");
        }
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showText:@"昵称设置成功!"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //[MBProgressHUD hideHUD];
}


@end
