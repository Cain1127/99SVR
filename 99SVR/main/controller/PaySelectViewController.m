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

@interface PaySelectViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) UIWebView *webView;
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;

@end

@implementation PaySelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultHeader:@"充值"];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = Rect(0, 64, kScreenWidth, kScreenHeight - 64);
    webView.delegate = self;
    // 伸缩页面至填充整个webView
    webView.scalesPageToFit = YES;
    self.webView = webView;
    
    [self.view addSubview:webView];
    
    [webView setBackgroundColor:[UIColor redColor]];
    
    // 2.加载网页
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPay_URL]];
    NSString *body = [NSString stringWithFormat: @"userid=%@&code=%@&client=%@", @"1680010",@"12345678911",@"2"];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [webView loadRequest:request];
    
    // 3.创建一个加载蒙板
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(self.view.centerX, self.view.centerY);
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 删除圈圈
    [self.loadingView removeFromSuperview];
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //    //定义好JS要调用的方法, share就是调用的share方法名
    context[@"AlipayPay"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        
        //NSString *param = @"partner=\"2088221194296626\"&seller_id=\"linghongli@99cj.com.cn\"&out_trade_no=\"GK1FGHI1WYBCEU8\"&subject=\"支付宝测试商品\"&body=\"支付宝测试商品描述\"&total_fee=\"0.01\"&notify_url=\"http://www.xxx.com\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&sign=\"J1j9cMcnWtTShMST1dWcHPKZ5JocQAatwvLRURk3UTaSJW6Q6kBqIEhOQb78UjoFRYHCjBo4aYczeGpxaEtikT3IEG%2FfDR5d3K7kTnnUq96ZZU35EiodFrAGUsYXQanuIeABcUvJsHHtybNQKFncy6DrhYxIgRfLYKHno9p5r0E%3D\"&sign_type=\"RSA\"";
        //JSValue *jsVal = args[0];
        NSString *param = ((JSValue *)args[0]).toString;
        //        for (JSValue *jsVal in args) {
        //            param = jsVal.toString;
        //            //NSLog(@"%@", jsVal.toString);
        //        }
        NSLog(@"%@", param);
        [self payForAlipay:param];
        NSLog(@"-------End Log-------");
    };
}


/**
 *  支付宝支付
 */
- (void)payForAlipay:(NSString *)param
{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"99SVR_alipay";
    
    [[AlipaySDK defaultService] payOrder:param fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
