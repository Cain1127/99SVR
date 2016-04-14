//
//  AboutController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//  关于我们

#import "AboutController.h"
#import "NNSVRViewController.h"

@interface AboutController()
{
    
}
@property (nonatomic,strong) UIImageView *logoImageView;

@end

@implementation AboutController

- (void)dealloc
{
    DLog(@"释放");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"关于我们"];
    [self initSubviews];
}

- (void)initSubviews
{
    self.view.backgroundColor = RGB(243, 243, 243);
    _logoImageView = [[UIImageView alloc] init];
    [self.view addSubview:_logoImageView];
    
    UILabel *lblName = [UILabel new];
    [lblName setText:@"99乐投"];
    [self.view addSubview:lblName];
    [lblName setTextColor:UIColorFromRGB(0x0078DD)];
    [lblName setFont:XCFONT(16)];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.font = kFontSize(17);
    versionLabel.textColor = [UIColor colorWithHex:@"#343434"];
    #ifdef DEBUG
    char cString[255];
    const char *version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] UTF8String];
    const char *bundle = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] UTF8String];
    sprintf(cString, "版本 V%s,build:%s",version,bundle);
    NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
    versionLabel.text = objCString;
    objCString = nil;
    #else
        char cString[255];
        const char *version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] UTF8String];
        sprintf(cString, "版本 V%s",version);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        versionLabel.text = objCString;
        objCString = nil;
    #endif
    [self.view addSubview:versionLabel];
    __weak AboutController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        char cString[255];
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        sprintf(cString, "%s/bigest_logo.png",path);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        UIImage *image = [UIImage imageWithContentsOfFile:objCString];
        if (image)
        {
           dispatch_async(dispatch_get_main_queue(), ^{
               __self.logoImageView.image = image;
           });
        }
    });
    UIButton *btnPro = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPro setTitle:@"使用条款及隐私政策" forState:UIControlStateNormal];
    [btnPro setTitleColor:UIColorFromRGB(0x0078dd) forState:UIControlStateNormal];
    [self.view addSubview:btnPro];
    btnPro.titleLabel.font = XCFONT(14);
    [btnPro addTarget:self action:@selector(openHttp) forControlEvents:UIControlEventTouchUpInside];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.view).offset(108);
        make.centerX.equalTo(self.view);
    }];
    [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
    }];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.mas_equalTo(_logoImageView.mas_bottom).offset(43);
        make.centerX.equalTo(self.view);
    }];
    [btnPro mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(self.view.mas_bottom).offset(-50);
         make.centerX.equalTo(self.view);
     }];
}

- (void)openHttp
{
    NNSVRViewController *nnView = [[NNSVRViewController alloc] initWithPath:@"http://www.99ducaijing.com/phone/appyhxy.aspx" title:@"使用条款及隐私政策"];
    [self.navigationController pushViewController:nnView animated:YES];
}

@end
