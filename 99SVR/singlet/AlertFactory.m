//
//  AlertFactory.m
//  99SVR
//
//  Created by xia zhonglin  on 4/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "AlertFactory.h"
#import "LoginViewController.h"
#import "RoomHttp.h"
#import "Toast+UIView.h"

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

+ (void)createPassswordAlert:(UIViewController *)sender room:(RoomHttp*)room{
    @WeakObj(sender)
    @WeakObj(room)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"加入当前房间需要加入密码" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"密码";
     }];
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        dispatch_async(dispatch_get_main_queue(),
           ^{
               //如果不再登录房间，取消notification
               [senderWeak.view hideToastActivity];
           });
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
       UITextField *login = alert.textFields.firstObject;
       if ([login.text length]==0){
           dispatch_async(dispatch_get_main_queue(),
           ^{
                [senderWeak.view hideToastActivity];
                [senderWeak.view makeToast:@"密码不能为空"];
                [AlertFactory createPassswordAlert:senderWeak room:roomWeak];
           });
       }
       else
       {
           [kProtocolSingle connectVideoRoom:[roomWeak.nvcbid intValue] roomPwd:login.text];
       }
    }];
    [alert addAction:canAction];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [senderWeak presentViewController:alert animated:YES completion:nil];
    });
}


@end
