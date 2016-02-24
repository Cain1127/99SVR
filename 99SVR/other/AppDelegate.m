//
//  AppDelegate.m
//  99SVR
//
//  Created by xia zhonglin  on 12/7/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <AVFoundation/AVAudioSession.h>
#import "LSTcpSocket.h"
#import "UserInfo.h"
#import "WWSideslipViewController.h"
#import "LeftViewController.h"
#import "DecodeJson.h"
#import "SVRInitLBS.h"
#import "IndexViewController.h"
#import "BaseService.h"
#import "RightViewController.h"
#import <Bugly/BuglyLog.h>
#import <Bugly/CrashReporter.h>
#import "MTA.h"
#import "MTAConfig.h"

#define APP_URL @"http://itunes.apple.com/lookup?id=1074104620"

@interface AppDelegate ()<UIAlertViewDelegate>
{
    WWSideslipViewController *_sides;
    IndexViewController *indexView;
    LeftViewController *leftView;
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
    
    
    [self onCheckVersion];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window makeKeyAndVisible];
    leftView = [[LeftViewController alloc] init];
    indexView = [[IndexViewController alloc] init];
//    rightView = [[RightViewController alloc] init];
//    _sides = [[WWSideslipViewController alloc] initWithLeftView:leftView andMainView:rightView andRightView:nil andBackgroundImage:nil];
    _sides = [[WWSideslipViewController alloc] initWithLeftView:leftView andMainView:indexView andRightView:nil andBackgroundImage:nil];
    [_window setRootViewController:_sides];
    _sides.speedf = 0.5;
    return YES;
}

-(void)onCheckVersion
{
    __weak AppDelegate *__self = self;
    [BaseService postJSONWithUrl:APP_URL parameters:nil success:^(id responseObject)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
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
@end
