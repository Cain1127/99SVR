//
//  SignatureViewController.m
//  99SVR
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()<UITextFieldDelegate>

///最新签名信息输入框
@property(nonatomic,strong) UITextField *signatureTextField;

@end

@implementation SignatureViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    /**
     *  @author yangshengmeng, 16-03-30 17:03:13
     *
     *  @brief  由于当前viewController没有继承自customViewController，
     *          没有自带导航栏，修改为继承后，UI不对。故在加载时添加导航栏创建代码
     *
     *  @since  v1.0.0
     */
    
    UIView *headView  = [[UIView alloc] initWithFrame:Rect(0.0f, 0.0f, kScreenWidth, 64.0f)];
    [self.view addSubview:headView];
    headView.backgroundColor = kNavColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:Rect(44.0f, 33.0f, kScreenWidth - 88.0f, 20.0f)];
    [titleLabel setFont:XCFONT(16)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.text = @"修改签名";
    [headView addSubview:titleLabel];
    
    ///返回按钮
    UIButton *turnBackButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [turnBackButton addTarget:self action:@selector(turnBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置图片
    UIImage *img = [UIImage imageNamed:@"back"];
    [turnBackButton setImage:img forState:UIControlStateNormal];
    [turnBackButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [turnBackButton setFrame:Rect(0.0f, 20.0f, 44.0f, 44.0f)];
    [headView addSubview:turnBackButton];
    
    ///完成提交按钮
    UIButton *completeBackButton =[UIButton buttonWithType:UIButtonTypeCustom];
    completeBackButton.frame = Rect(kScreenWidth - 44.0f, 20.0f, 44.0f, 44.0f);
    [completeBackButton addTarget:self action:@selector(completeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [completeBackButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeBackButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [headView addSubview:completeBackButton];
    
    ///设置状态栏的风格
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setupView];
    
}

- (void)setupView
{
    self.view.backgroundColor = kTableViewBgColor;
    
    //输入框底层
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 10.0f, kScreenWidth, 150.0f)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    
    //签名输入框
    _signatureTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0f, 64.0f + 10.0f, kScreenWidth - 2.0f * 12.0f, 150.0f)];
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
    
    //建议提醒文字
//    UILabel * adviceLabel = [[UILabel alloc] init];
//    adviceLabel.text = @"昵称支持4-20中英文、数字及下划线组合";
//    adviceLabel.textColor = [UIColor blackColor];
//    adviceLabel.font = kFontSize(14);;
//    adviceLabel.numberOfLines = 0;
//    adviceLabel.frame = CGRectMake(12, CGRectGetMaxY(_signatureTextField.frame), kScreenWidth - 12*2, 30);
//    [self.view addSubview:adviceLabel];
}

/**
 *  @author yangshengmeng, 16-03-30 17:03:24
 *
 *  @brief  完成按钮，提交签名信息
 *
 *  @since  v1.0.0
 */
- (void)completeButtonAction
{
    
    ///检测输入的心情
    if (0 >= _signatureTextField.text.length)
    {
        
        return;
        
    }
    
    [MBProgressHUD showMessage:@"正在修改……"];
    
    @WeakObj(self);
    NSString *signatureString = _signatureTextField.text;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (selfWeak.signatureBlock)
        {
            
            selfWeak.signatureBlock(signatureString);
            
        }
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showText:@"签名设置成功!"];
        [selfWeak.navigationController popViewControllerAnimated:YES];
        
    });
}

/**
 *  @author yangshengmeng, 16-03-30 17:03:59
 *
 *  @brief  返回按钮事件
 *
 *  @since  v1.0.0
 */
- (void)turnBackButtonAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
