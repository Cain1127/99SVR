//
//  AdLinkShowViewController.m
//  99SVR
//
//  Created by jiangys on 16/5/6.
//  Copyright © 2016年 jiangys . All rights reserved.
//  广告点击显示

#import "AdLinkShowViewController.h"
#import "SwitchRootTool.h"

@interface AdLinkShowViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation AdLinkShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    
    [MBProgressHUD showMessage:@"加载中..."];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_linkShowUrl]]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"暂时无法显示，请检查网络"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
}

// 关闭广告
- (void)MarchBackLeft
{
     [SwitchRootTool switchRootForViewController];
}

@end
