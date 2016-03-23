//
//  AppDelegate.m
//  99SVR
//
//  Created by xia zhonglin  on 12/7/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
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
#import "RightViewController.h"
#import <Bugly/BuglyLog.h>
#import <Bugly/CrashReporter.h>
#import "MTA.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "MTAConfig.h"
#import "WXApi.h"
#import "TabBarController.h"

#define APP_URL @"http://itunes.apple.com/lookup?id=1074104620"

@interface AppDelegate ()<UIAlertViewDelegate,WeiboSDKDelegate,WXApiDelegate>
{
    IndexViewController *indexView;
    RightViewController *rightView;
    BOOL bStatus;
    BOOL bGGLogin;
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
//    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [_window makeKeyAndVisible];
//    leftView = [[LeftViewController alloc] init];
//    
//    rightView = [[RightViewController alloc] init];
//    _sides = [[WWSideslipViewController alloc] initWithLeftView:leftView andMainView:rightView andRightView:nil andBackgroundImage:nil];
//    [_window setRootViewController:_sides];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[TabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    NSString *strGift = [UserDefaults objectForKey:kGiftInfo];
    if (strGift){
        [self setGiftInfo:strGift];
    }
    else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gift"
                                                         ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
        [self setGiftInfo:content];
        [UserDefaults setObject:content forKey:kGiftInfo];
        DLog(@"第一次拿到");
    }
    return YES;
}

- (void)setGiftInfo:(NSString *)strGift
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[strGift dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
    if (dict && [dict objectForKey:@"gift"]) {
        [UserInfo sharedUserInfo].giftVer = [[dict objectForKey:@"ver"] intValue];
        NSArray *array = [dict objectForKey:@"gift"];
        NSMutableArray *aryIndex = [NSMutableArray array];
        for (NSDictionary *dictionary in array) {
            [aryIndex addObject:[GiftModel resultWithDict:dictionary]];
        }
        [UserInfo sharedUserInfo].aryGift = aryIndex;
    }
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
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ENTER_BACK_VC object:@"ON"];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"返回");
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ENTER_BACK_VC object:@"OFF"];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [TencentOAuth HandleOpenURL:url] ||
    [WeiboSDK handleOpenURL:url delegate:self] ||
    [WXApi handleOpenURL:url delegate:self];;
    return YES;
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

-(void)getAccess_token:(NSString *)strCode
{
    char cString[600]={0};
    sprintf(cString, "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SEC,
            [strCode UTF8String]);
    NSString *url = [[NSString alloc] initWithUTF8String:cString];
    __weak AppDelegate *__self = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_global_queue(0, 0),
        ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *strToken = [dic objectForKey:@"access_token"];
                NSString *strOpenId = [dic objectForKey:@"openid"];
                [__self getUserInfo:strToken openid:strOpenId];
            }
        });
    });
}

-(void)getUserInfo:(NSString *)access_token openid:(NSString *)openid
{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_global_queue(0, 0),
        ^{
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                DLog(@"昵称:%@",[dic objectForKey:@"nickname"]);
            }
        });
    });
}



@end
