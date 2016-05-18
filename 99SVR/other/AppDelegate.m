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
#import <AlipaySDK/AlipaySDK.h>
#import "DecodeJson.h"
#import "GiftModel.h"
#import <AVFoundation/AVAudioSession.h>
#import "NSJSONSerialization+RemovingNulls.h"
#import "WeiboSDK.h"
#import "UserInfo.h"
#import "DecodeJson.h"
#import "SVRInitLBS.h"
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
#import "AdViewController.h"
#import "SwitchRootTool.h"
#import "IQKeyboardManager.h"
//#import "UIAlertView+Block.h"
#define APP_URL @"http://itunes.apple.com/lookup?id=1074104620"

@interface AppDelegate ()<UIAlertViewDelegate,WeiboSDKDelegate,WXApiDelegate>
{
    BOOL bStatus;
    BOOL bGGLogin;
}

@property (nonatomic,unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic,strong) NSTimer *myTimer;
    
@end

@implementation AppDelegate

- (void)createUpdateAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
    [alert show];
}

- (void)updateVersion{
    @WeakObj(self)
    [BaseService post:@"http://hall.99ducaijing.cn:8081/iosVersionUpdate.php?version_code=1" dictionay:nil timeout:10 success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil removingNulls:YES ignoreArrays:NO];
        if([dict objectForKey:@"update"]!=nil){
            if ([[dict objectForKey:@"update"] intValue]==1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_VERSION_VC object:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [selfWeak createUpdateAlert];
                });
            }
            DLog(@"update:%@",[dict objectForKey:@"update"]);
        }
    } fail:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[ZLLogonServerSing sharedZLLogonServerSing] serverInit];
    [SVRInitLBS loadAllInfo];
    [[CrashReporter sharedInstance] installWithAppId:@"900018787" applicationGroupIdentifier:@"com.hctt.fae99"];
    [[MTAConfig getInstance] setDebugEnable:TRUE];
    [[MTAConfig getInstance] setAutoExceptionCaught:FALSE];
    [[MTAConfig getInstance] setSmartReporting:false];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];
    [MTA startWithAppkey:@"ILQ4T8A5X5JA"];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaKey];
    
    [WXApi registerApp:@"wxfbfe01336f468525" withDescription:@"weixin"];
    
   // [self onCheckVersion];
    
    NSDictionary *dict = [UserDefaults objectForKey:kVideoList];
    
    if (!dict){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"video_list"
                                                         ofType:@"txt"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        [UserDefaults setObject:parameters forKey:kVideoList];
    }
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   // self.window.rootViewController = [[TabBarController alloc] init];
     [SwitchRootTool switchRootForAppDelegate];
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
    
    [self updateVersion];
    
    return YES;
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
                alert.tag = 100;
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
    }
    else
    {
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
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
        {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    if([url.absoluteString rangeOfString:@"tencent"].location !=NSNotFound)
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if([url.absoluteString rangeOfString:@"wx"].location != NSNotFound)
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    // 微博返回来的，不是weibo，是wb+kSinaKey
    else if([url.absoluteString rangeOfString:@"wb4288225685"].location != NSNotFound)
    {
        [WeiboSDK handleOpenURL:url delegate:self] ;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] rangeOfString:@"svrAlipay"].location != NSNotFound) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@",resultDic);
         }];
        return YES;
    }
    if([url.absoluteString rangeOfString:@"tencent"].location !=NSNotFound)
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if([url.absoluteString rangeOfString:@"wx"].location != NSNotFound)
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    // 微博返回来的，不是weibo，是wb+kSinaKey
    else if([url.absoluteString rangeOfString:@"wb4288225685"].location != NSNotFound)
    {
        [WeiboSDK handleOpenURL:url delegate:self] ;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([url.absoluteString rangeOfString:@"tencent"].location !=NSNotFound)
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if([url.absoluteString rangeOfString:@"wx"].location != NSNotFound)
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    // 微博返回来的，不是weibo，是wb+kSinaKey
    else if([url.absoluteString rangeOfString:@"wb4288225685"].location != NSNotFound)
    {
        [WeiboSDK handleOpenURL:url delegate:self] ;
    }
    return YES;
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
        if([resp isKindOfClass:[SendAuthResp class]])
        {
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
}

@end
