//
//  AlertFactory.m
//  99SVR
//
//  Created by xia zhonglin  on 4/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "AlertFactory.h"
#import "LoginViewController.h"

@implementation AlertFactory

+ (void)createLoginAlert:(UIViewController *)sender block:(void (^)())block
{
    @WeakObj(sender)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"游客无法互动，请登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                               {
                                   dispatch_async(dispatch_get_main_queue(),
                                                  ^{
                                                      if (block) {
                                                          block();
                                                      }
                                                      LoginViewController *loginView = [[LoginViewController alloc] init];
                                                      [senderWeak.navigationController pushViewController:loginView animated:YES];
                                                  });
                               }];
    [alert addAction:canAction];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [senderWeak presentViewController:alert animated:YES completion:nil];
    });
}

@end
