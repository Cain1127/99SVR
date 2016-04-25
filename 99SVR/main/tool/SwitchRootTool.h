//
//  SwitchRootTool.h
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchRootTool : NSObject
+ (void)switchRootForAppDelegate;
+ (void)switchRootForViewController;
+ (void)saveCurrentVersion;
@end
