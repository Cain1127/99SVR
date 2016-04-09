//
//  AlertFactory.h
//  99SVR
//
//  Created by xia zhonglin  on 4/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertFactory : NSObject

+ (void)createLoginAlert:(UIViewController *)sender block:(void (^)())block;

@end
