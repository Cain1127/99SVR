//
//  AppDelegate.h
//  99SVR
//
//  Created by xia zhonglin  on 12/7/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketNetworkView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 *  Socket网络状态
 */
@property (nonatomic, strong) SocketNetworkView *socketNetworkView;

@end

