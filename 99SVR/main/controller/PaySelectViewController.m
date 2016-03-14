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
//#import "WXApiManager.h"

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
    
    [self jumpToBizPay];
    return;
    
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
        NSLog(@"%@", param);
        [self payForAlipay:param];
        NSLog(@"-------End Log-------");
    };
    
    context[@"Wxpay"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
                for (JSValue *jsVal in args) {
                    //param = jsVal.toString;
                    NSLog(@"%@", jsVal.toString);
                }
        //NSLog(@"%@", param);
        //[self payForAlipay:param];
        NSLog(@"-------End Log-------");
    };
}
//appid=wxfbfe01336f468525
//partid=1317413201
//prepayid=wx201603141739527f2a460ce20629947657
//noncestr=585E3611C3B2D9BD2E29DD98F7DACE0C
//timestamp=1457948396
//package=Sign=WXPay
//sign=F51048A9D430126E97D2D4A12CA24A62
//{"appId":"wxfbfe01336f468525","partnerId":"1317413201","prepayId":"wx20160314210923a7f4adb4150263043986","nonceStr":"e912fa93abcf47198c08e0b8604bc9cd","timeStamp":635935865429863300,"package":"Sign=WXPay","sign":"C9F82F1D5BCBDC8D4CE9705F6B95D221"}

- (void)jumpToBizPay {
    
                    //调起微信支付
//                    PayReq* req             = [[PayReq alloc] init];
//                    req.partnerId           = @"1317413201";//[dict objectForKey:@"partnerid"];
//                    req.prepayId            = @"wx201603141739527f2a460ce20629947657";//[dict objectForKey:@"prepayid"];
//                    req.nonceStr            = @"585E3611C3B2D9BD2E29DD98F7DACE0C";//[dict objectForKey:@"noncestr"];
//                    req.timeStamp           = [@"1457948396" intValue];
//                    req.package             = @"Sign=WXPay";//[dict objectForKey:@"package"];
//                    req.sign                = @"F51048A9D430126E97D2D4A12CA24A62";//[dict objectForKey:@"sign"];
//                    [WXApi sendReq:req];
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = @"1317413201";//[dict objectForKey:@"partnerid"];
    req.prepayId            = @"wx20160314210923a7f4adb4150263043986";//[dict objectForKey:@"prepayid"];
    req.nonceStr            = @"e912fa93abcf47198c08e0b8604bc9cd";//[dict objectForKey:@"noncestr"];
    req.timeStamp           = [@"635935865429863300" intValue];
    req.package             = @"Sign=WXPay";//[dict objectForKey:@"package"];
    req.sign                = @"C9F82F1D5BCBDC8D4CE9705F6B95D221";//[dict objectForKey:@"sign"];
    [WXApi sendReq:req];
}
-(NSString *)jumpToBizPay1{
    


    //============================================================
//    // V3&V4支付流程实现
//    // 注意:参数配置请查看服务器端Demo
//    // 更新时间：2015年11月20日
//    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}
/**
 *  支付宝支付
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
