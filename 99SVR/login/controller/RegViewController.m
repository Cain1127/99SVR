//
//  RegViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/30/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController()<UIWebViewDelegate>
{

}

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation RegViewController

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    btnBack.tag = 2;
    btnBack.frame = Rect(0, 20, 44, 44);
    [self.view addSubview:btnBack];
    [self setTitleText:@"注册"];
    _webView = [[UIWebView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:
                             [[NSURL alloc] initWithString:@"http://www.99ducaijing.com/phone/register.aspx"]];
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载，可以加上风火轮
    DLog(@"webView:%@",[webView request].URL.absoluteString);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"加载完成");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //加载出错
}

@end
