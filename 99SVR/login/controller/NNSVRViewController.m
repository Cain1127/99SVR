//
//  NNSVRViewController.m
//  99SVR
//  99乐投协议
//  Created by xia zhonglin  on 1/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "NNSVRViewController.h"
#import "AdaptiveWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "StockDealViewController.h"
#import "StockDealModel.h"

@interface NNSVRViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) AdaptiveWebView *adaptiveWebView;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation NNSVRViewController

- (id)initWithPath:(NSString *)strPath title:(NSString *)strTitle
{
    if(self = [super init])
    {
        _strPath = strPath;
        _strTitle = strTitle;
        return self;
    }
    return nil;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self setTitleText:_strTitle];
//
//    _adaptiveWebView = [[AdaptiveWebView alloc] initWithFrame:Rect(0.0f, 64.0f, kScreenWidth, kScreenHeight - 64.0f)];
//    _adaptiveWebView.url = _strPath;
//
//    [self.view addSubview:_adaptiveWebView];
//}
//
//- (void)dealloc
//{
//    _adaptiveWebView = nil;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:_strTitle];
    
     NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_strPath]];
    
    _webView = [[UIWebView alloc] initWithFrame:Rect(0.0f, 64.0f, kScreenWidth, kScreenHeight - 64.0f)];
    _webView.delegate = self;
    [_webView loadRequest:urlRequest];
    
    [self.view addSubview:_webView];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    @WeakObj(self);
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 定义好JS要调用的方法, AlipayPay就是调用的AlipayPay方法名
    context[@"openStockRecord"] = ^() {
        @StrongObj(self);
        NSArray *args = [JSContext currentArguments];
        NSString *operateId = @"";
        NSString *teamname = @"";
        if (args[0]) {
            operateId = ((JSValue *)args[0]).toString;
        }
        if (args[1]) {
            teamname = ((JSValue *)args[1]).toString;
        }
        
        StockDealModel *stockModel = [[StockDealModel alloc] init];
        stockModel.operateid = operateId;
        stockModel.teamname = teamname;
        StockDealViewController *stockVC = [[StockDealViewController alloc]init];
        stockVC.stockModel = stockModel;
        [self.navigationController pushViewController:stockVC animated:YES];
    };
}

- (void)dealloc
{
    _webView = nil;
}

@end
