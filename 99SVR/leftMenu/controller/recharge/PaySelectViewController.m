//
//  PaySelectViewController.m
//  99SVR
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "PaySelectViewController.h"
#import "Order.h"
#import "Toast+UIView.h"
#import <AlipaySDK/AlipaySDK.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WXApi.h"
#import "UserInfo.h"
#import "RechargeResultViewController.h"
#import "ProgressHUD.h"
#import "UserInfo.h"

@interface PaySelectViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) UIWebView *webView;
//@property (nonatomic, weak) UIActivityIndicatorView *loadingView;

@end

@implementation PaySelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtTitle.text = @"充值";
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 加载充值网页
    [self loadWebView];
}

- (void)loadWebView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = Rect(0, 64, kScreenWidth, kScreenHeight);
    webView.delegate = self;
    self.webView = webView;
    [self.view addSubview:webView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPay_URL]];
    UserInfo *info = [UserInfo sharedUserInfo];
    NSString *body = [NSString stringWithFormat: @"userid=%d&code=%@&client=%@",info.nUserId,info.strToken,@"2"];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [webView loadRequest:request];
    [self.view makeToastActivity_bird];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DLog(@"新的地址:%@",[request.URL absoluteString]);
    if ([[request.URL absoluteString] rangeOfString:@"Wap_Pay_Success"].location != NSNotFound) {
        [self jdAndPayunionPayWithResult:YES];
    }else if([[request.URL absoluteString] rangeOfString:@"Wap_Pay_fail"].location != NSNotFound)
    {
        [self jdAndPayunionPayWithResult:NO];
    }
    
    return YES;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view hideToastActivity];
    @WeakObj(self);
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 定义好JS要调用的方法, AlipayPay就是调用的AlipayPay方法名
    context[@"AlipayPay"] = ^() {
        DLog(@"----支付宝开始充值----");
        NSArray *args = [JSContext currentArguments];
        if(args.count==0)
        {
            [ProgressHUD showError:@"请求支付宝支付失败"];
            return ;
        }
        NSString *param = ((JSValue *)args[0]).toString;
        DLog(@"支付宝开始充值参数-----%@", param);
        [selfWeak payForAlipay:param];
    };
    
    ///微信支付
    context[@"Wxpay"] = ^() {
        DLog(@"----微信开始充值----");
        NSArray *args = [JSContext currentArguments];
        if (args.count==0) {
            [ProgressHUD showError:@"请求微信支付失败"];
            return ;
        }
        NSString *param = ((JSValue *)args[0]).toString;
        if (param) {
            NSData *jsonData = [param dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil removingNulls:YES ignoreArrays:NO];
            // 微信支付充值
            [selfWeak weixinPayWithDict:responseDict];
        }
        DLog(@"微信开始充值参数-----%@", param);
    };
}

#pragma mark -- 京东和银联支付
- (void)jdAndPayunionPayWithResult:(BOOL)reslut
{
    RechargeResultViewController *rechargeResultVc = [[RechargeResultViewController alloc] init];
    rechargeResultVc.title = reslut ? @"支付成功" : @"支付失败";
    rechargeResultVc.isRechargeSucceed = reslut;
    // 这里应该还需要一个订单号
    [self.navigationController pushViewController:rechargeResultVc animated:YES];

}

#pragma mark -- 微信支付
/**
 *  微信支付
 */
- (void)weixinPayWithDict:(NSDictionary *)dict{

    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerId"];
    req.prepayId            = [dict objectForKey:@"prepayId"];
    req.nonceStr            = [dict objectForKey:@"nonceStr"];
    req.timeStamp           = [[dict objectForKey:@"timeStamp"] intValue];
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
}

/**
 *  微信通知结果
 *
 *  @param notify 通知
 */
- (void)sendPayResult:(NSNotification *)notify {
    DLog(@"%@-----",[notify.userInfo[@"key"] isEqualToString:@"1"]?@"支付成功":@"支付失败");
    RechargeResultViewController *rechargeResultVc = [[RechargeResultViewController alloc] init];
    rechargeResultVc.isRechargeSucceed = [notify.userInfo[@"key"] isEqualToString:@"1"];
    rechargeResultVc.title = rechargeResultVc.isRechargeSucceed ? @"支付成功":@"支付失败";
    // 这里应该还需要一个订单号
    [self.navigationController pushViewController:rechargeResultVc animated:YES];
}

#pragma mark -- 支付宝支付

/**
 *  支付宝发起支付
 */
- (void)payForAlipay:(NSString *)param
{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"svrAlipay";
    __weak PaySelectViewController *__self = self;
    [[AlipaySDK defaultService] payOrder:param fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        RechargeResultViewController *rechargeResultVc = [[RechargeResultViewController alloc] init];
        rechargeResultVc.isRechargeSucceed = [resultDic[@"resultStatus"] isEqualToString:@"9000"];
        rechargeResultVc.title = rechargeResultVc.isRechargeSucceed ? @"支付成功":@"支付失败";
        // 这里应该还需要一个订单号
        [__self.navigationController pushViewController:rechargeResultVc animated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendPayResult:) name:@"WXPAY" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    DLog(@"dealloc");
}
@end
