//
//  PaySelectViewController.m
//  99SVR
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "PaySelectViewController.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WXApi.h"
#import "UserInfo.h"

@interface PaySelectViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) UIWebView *webView;
//@property (nonatomic, weak) UIActivityIndicatorView *loadingView;

@end

@implementation PaySelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"充值";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 加载充值网页
    [self loadWebView];
}

- (void)loadWebView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = Rect(0, 64, kScreenWidth, kScreenHeight - 64);
    webView.delegate = self;
    // 伸缩页面至填充整个webView
    webView.scalesPageToFit = YES;
    self.webView = webView;
    
    [self.view addSubview:webView];
    
    // 2.加载网页
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPay_URL]];
    NSString *body = [NSString stringWithFormat: @"userid=%@&code=%@&client=%@", @"1680010",@"12345678911",@"2"];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [webView loadRequest:request];
    
    // 3.加载蒙板
    [MBProgressHUD showMessage:@"加载中..."];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 删除蒙板
    [MBProgressHUD hideHUD];
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 定义好JS要调用的方法, AlipayPay就是调用的AlipayPay方法名
    context[@"AlipayPay"] = ^() {
        DLog(@"----支付宝开始充值----");
        NSArray *args = [JSContext currentArguments];
        NSString *param = ((JSValue *)args[0]).toString;
        DLog(@"支付宝开始充值参数-----%@", param);
        [self payForAlipay:param];
    };
    
    context[@"Wxpay"] = ^() {
        DLog(@"----微信开始充值----");
        NSArray *args = [JSContext currentArguments];
        NSString *param = ((JSValue *)args[0]).toString;
        DLog(@"微信开始充值参数-----%@", param);
    };
}

/**
 *  微信支付
 */
- (void)weixinPayWithDict:(NSDictionary *)dict{

    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = [[dict objectForKey:@"timeStamp"] intValue];
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
}

/**
 *  支付宝发起支付
 */
- (void)payForAlipay:(NSString *)param
{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"99svrAlipay";
    
    [[AlipaySDK defaultService] payOrder:param fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
