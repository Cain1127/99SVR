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
#import "MobClick.h"
#import "SVRInitLBS.h"
#import "IndexViewController.h"

@interface AppDelegate ()
{
    WWSideslipViewController *_sides;
    IndexViewController *indexView;
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
    indexView = [[IndexViewController alloc] init];
    _sides = [[WWSideslipViewController alloc] initWithLeftView:leftView andMainView:indexView andRightView:nil andBackgroundImage:nil];
    [_window setRootViewController:_sides];
    _sides.speedf = 0.5;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_REMOVE_NOTIFY_VC object:nil];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ENTER_BACK_VC object:nil];
}

-(void)endBackgroundTask
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    AppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void)
    {
        AppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil){
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
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ADD_NOTIFY_VC object:nil];
    bStatus = YES;
    [self.myTimer invalidate];
    if (bGGLogin)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_COME_BACK_VC object:nil];
        bGGLogin = NO;
    }
}
@end
