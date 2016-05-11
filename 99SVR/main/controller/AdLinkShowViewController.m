//
//  AdLinkShowViewController.m
//  99SVR
//
//  Created by jiangys on 16/5/6.
//  Copyright © 2016年 jiangys . All rights reserved.
//  广告点击显示

#import "AdLinkShowViewController.h"
#import "SwitchRootTool.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface AdLinkShowViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NJKWebViewProgressView *webViewProgressView;
@property (nonatomic,strong) NJKWebViewProgress *webViewProgress;
@end

@implementation AdLinkShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:_webView];
    
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    CGFloat progressBarHeight = 3.f;
    CGRect navigationBarBounds = CGRectMake(0, 0, kScreenWidth, 64);
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_linkShowUrl]];
    [_webView loadRequest:request];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:@"暂时无法显示，请检查网络"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.headView addSubview:_webViewProgressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_webViewProgressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self setTitleText:title];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

// 关闭广告
- (void)MarchBackLeft
{
     [SwitchRootTool switchRootForViewController];
}

@end
