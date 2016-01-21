//
//  AppDelegate.m
//  99SVR
//
//  Created by xia zhonglin  on 12/7/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LSTcpSocket.h"
#import "UserInfo.h"
#import "WWSideslipViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "DecodeJson.h"
#import "MobClick.h"
#import "SVRInitLBS.h"

@interface AppDelegate ()
{
    WWSideslipViewController *_sides;
    RightViewController *rightView;
    LeftViewController *leftView;
    BOOL bStatus;
    BOOL bGGLogin;
}

@property (nonatomic,unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic,strong) NSTimer *myTimer;
    
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //友盟
    [MobClick startWithAppkey:@"568388ebe0f55a1537000bfa" reportPolicy:BATCH channelId:@""];
    sleep(1);
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window makeKeyAndVisible];
    leftView = [[LeftViewController alloc] init];
    rightView = [[RightViewController alloc] init];
    _sides = [[WWSideslipViewController alloc] initWithLeftView:leftView andMainView:rightView andRightView:nil andBackgroundImage:nil];
    [_window setRootViewController:_sides];
    _sides.speedf = 0.5;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_REMOVE_NOTIFY_VC object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{}

-(void)setEndBackground
{
    if (bStatus)
    {
        DLog(@"等待时间不够");
        return ;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ENTER_BACK_VC object:nil];
    DLog(@"进入后台!");
    bGGLogin = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    bStatus = NO;
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void)
    {
         [self endBackgroundTask];
    }];
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                target:self
                                              selector:@selector(timerMethod:)
                                              userInfo:nil
                                               repeats:YES];
    [self performSelector:@selector(setEndBackground) withObject:nil afterDelay:180.0];
    
}

-(void)timerMethod:(NSTimer *)paramSender
{
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX)
    {}
    else
    {
        if (backgroundTimeRemaining<=0)
        {
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
        if (strongSelf != nil){
            [strongSelf.myTimer invalidate];// 停止定时器
            // 每个对 beginBackgroundTaskWithExpirationHandler:方法的调用,必须要相应的调用 endBackgroundTask:方法。这样，来告诉应用程序你已经执行完成了。
            // 也就是说,我们向 iOS 要更多时间来完成一个任务,那么我们必须告诉 iOS 你什么时候能完成那个任务。
            // 也就是要告诉应用程序：“好借好还”嘛。
            // 标记指定的后台任务完成
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
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ADD_NOTIFY_VC object:nil];
    bStatus = YES;
    [self.myTimer invalidate];
    if (bGGLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_COME_BACK_VC object:nil];
        bGGLogin = NO;
    }
}
@end
