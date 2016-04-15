//
//  AppDelegate.m
//  99SVR
//
//  Created by xia zhonglin  on 12/7/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ZLLogonServerSing.h"
#import "Toast+UIView.h"
#import "Reachability.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DecodeJson.h"
#import "GiftModel.h"
#import <AVFoundation/AVAudioSession.h>
#import "NSJSONSerialization+RemovingNulls.h"
#import "LSTcpSocket.h"
#import "WeiboSDK.h"
#import "UserInfo.h"
#import "DecodeJson.h"
#import "SVRInitLBS.h"
#import "IndexViewController.h"
#import "BaseService.h"
#import <Bugly/BuglyLog.h>
#import <Bugly/CrashReporter.h>
#import "MTA.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "MTAConfig.h"
#import "WXApi.h"
#import "TabBarController.h"
#import "MainViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "TQTopWindow.h"
#import "UIView+TQFram.h"

#define APP_URL @"http://itunes.apple.com/lookup?id=1074104620"

@interface AppDelegate ()<UIAlertViewDelegate,WeiboSDKDelegate,WXApiDelegate>
{
    IndexViewController *indexView;
    BOOL bStatus;
    BOOL bGGLogin;
    Reachability *hostReach;
    NetworkStatus nowStatus;
}

@property (nonatomic,unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic,strong) NSTimer *myTimer;
    
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[CrashReporter sharedInstance] installWithAppId:@"900018787" applicationGroupIdentifier:@"com.hctt.fae99"];
    [[MTAConfig getInstance] setDebugEnable:TRUE];
    [[MTAConfig getInstance] setAutoExceptionCaught:FALSE];
    [[MTAConfig getInstance] setSmartReporting:false];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];
    [MTA startWithAppkey:@"ILQ4T8A5X5JA"];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaKey];
    [WXApi registerApp:@"wxfbfe01336f468525" withDescription:@"weixin"];
    
    [self onCheckVersion];
    
    NSDictionary *dict = [UserDefaults objectForKey:kVideoList];
    
    if (!dict){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"video_list"
                                                         ofType:@"txt"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        [UserDefaults setObject:parameters forKey:kVideoList];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[TabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    NSDictionary *dictGift = [UserDefaults objectForKey:kGiftInfo];
    if (dictGift){
        [DecodeJson setGiftInfo:dictGift];
    }
    else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gift"
                                                         ofType:@"txt"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        [UserDefaults setObject:parameters forKey:kGiftInfo];
        [DecodeJson setGiftInfo:parameters];
    }
    
    
    hostReach = [Reachability reachabilityWithHostName:@"www.163.com"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    //添加状态栏统一颜色设置及点导航栏,tableview返回顶部功能
    [TQTopWindow showWithStatusBarCilickBlock:^{
        
        [self searchAllscrollViewInView:application.keyWindow];
    }];
    
    //开启网络通知
    [hostReach startNotifier];
    
    return YES;
}



-(void)searchAllscrollViewInView:(UIView *)view
{
    
    if (![view TQ_intersectWithView:nil]) return;
    
    for (UIView * subView in view.subviews) {
        [self searchAllscrollViewInView:subView];
    }
    //    TQLog(@"%@", view);
    if (![view isKindOfClass:[UIScrollView class]]) return;
    
    UIScrollView *scrollView = (UIScrollView *)view;
    CGPoint offset = scrollView.contentOffset;
    offset.y = - scrollView.contentInset.top;
    
    [scrollView setContentOffset:offset animated:YES];
    
}


/**
*  网络更改通知
*/
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == nowStatus) {
        return ;
    }
    
    if (status == NotReachable)
    {
        DLog(@"网络状态:中断");
        __weak UIWindow *__windows = self.window;
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__windows makeToast:@"无网络"];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NETWORK_ERR_VC object:nil];
        if(!nowStatus == status){
            
        }
        nowStatus = status;
        return ;
    }
    else if(status == ReachableViaWiFi)
    {
        __weak UIWindow *__windows = self.window;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__windows makeToast:@"当前网络:WIFI"];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NETWORK_OK_VC object:nil];
    }
    else if(status == ReachableViaWWAN)
    {
        __weak UIWindow *__windows = self.window;
        dispatch_async(dispatch_get_main_queue(),
           ^{
               [__windows makeToast:@"当前网络:移动网络"];
           });
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NETWORK_OK_VC object:nil];
    }
    nowStatus = status;
    [KUserSingleton.dictRoomGate removeAllObjects];
    [KUserSingleton.dictRoomMedia removeAllObjects];
    [KUserSingleton.dictRoomText removeAllObjects];
}

-(void)onCheckVersion
{
    __weak AppDelegate *__self = self;
    [BaseService postJSONWithUrl:APP_URL parameters:nil success:^(id responseObject)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        NSArray *infoArray = [dic objectForKey:@"results"];
        if ([infoArray count])
        {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [[infoDic objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *lastVersion = [[releaseInfo objectForKey:@"version"] stringByReplacingOccurrencesOfString:@"." withString:@""];
            CGFloat fLast = [lastVersion intValue] > 100 ? [lastVersion intValue] : [lastVersion intValue]*10;
            CGFloat fCurrent = [currentVersion intValue] > 100 ? [currentVersion intValue] : [currentVersion intValue]*10;
            if (fLast>fCurrent)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:__self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                [alert show];
            }
        }
    } fail:^(NSError *error)
    {
        DLog(@"获取失败");
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/99-ccai-jing/id1074104620?l=en&mt=8"]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

-(void)setEndBackground
{
    if (bStatus)
    {
        DLog(@"等待时间不够");
        return ;
    }
    [[ZLLogonServerSing sharedZLLogonServerSing] closeProtocol];
    bGGLogin = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    bStatus = NO;
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void)
     {
         [self endBackgroundTask];
     }];
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                target:self
                                              selector:@selector(timerMethod:)
                                              userInfo:nil
                                               repeats:YES];
    [self performSelector:@selector(setEndBackground) withObject:nil afterDelay:180.0f];
}

-(void)timerMethod:(NSTimer *)paramSender
{
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX)
    {
        DLog(@"Background Time Remaining = Undetermined");
    }
    else
    {
        DLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
        if (backgroundTimeRemaining<10) {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    }
}

-(void)endBackgroundTask
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    AppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void)
    {
        AppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil)
        {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            // 销毁后台任务标识符
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

/**
 *  从后台返回
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    bStatus = YES;
    [self.myTimer invalidate];
    if (bGGLogin)
    {
        [SVRInitLBS loginLocal];
    }
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ENTER_BACK_VC object:@"OFF"];
}





/**
 *  连接跳转
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([[url absoluteString] rangeOfString:@"svrAlipay"].location != NSNotFound) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    return [TencentOAuth HandleOpenURL:url] ||
    [WeiboSDK handleOpenURL:url delegate:self] ||
    [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [TencentOAuth HandleOpenURL:url] ||
    [WeiboSDK handleOpenURL:url delegate:self] ||
    [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url] ||
    [WeiboSDK handleOpenURL:url delegate:self] ||
    [WXApi handleOpenURL:url delegate:self];;
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if ((int)response.statusCode == 0)
        {
            NSDictionary *dic = @{@"userID":[(WBAuthorizeResponse *)response userID],
                                  @"accessToken" :[(WBAuthorizeResponse *)response accessToken]};
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_SINA_VC object:dic];
        }
        else
        {
            NSDictionary *dic = @{@"error":@"授权失败"};
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_SINA_VC object:dic];
        }
    }
}

// 微信回调
-(void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) { // 微信支付
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:self userInfo:@{@"key":@"1"}];
                break;
            case WXErrCodeCommon:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:self userInfo:@{@"key":@"0", @"error":@"普通错误类型"}];
                break;
            case WXErrCodeUserCancel:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:self userInfo:@{@"key":@"0", @"error":@"取消支付"}];
                break;
            case WXErrCodeSentFail:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:self userInfo:@{@"key":@"0", @"error":@"发送失败"}];
                break;
            case WXErrCodeAuthDeny:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:self userInfo:@{@"key":@"0", @"error":@"授权失败"}];
                break;
            case WXErrCodeUnsupport:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:self userInfo:@{@"key":@"0", @"error":@"微信不支持"}];
                break;
                
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:self userInfo:@{@"key":@"0", @"error":@"支付失败"}];
                break;
        }
    } else{//微信授权登录回调
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{@"code":code};
            DLog(@"dic:%@",dic);
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_WEICHAT_VC object:dic];
        }
        else
        {
            NSDictionary *dict = @{@"errcode":@"取消"};
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_LOGIN_WEICHAT_VC object:dict];
        }
    }
}

@end
