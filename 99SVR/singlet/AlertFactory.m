//
//  AlertFactory.m
//  99SVR
//
//  Created by xia zhonglin  on 4/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "AlertFactory.h"
#import "LoginViewController.h"
#import "PlayIconView.h"
#import "KefuCenterController.h"
#import "RoomHttp.h"
#import "Toast+UIView.h"
#import "UIAlertView+Block.h"
#import "SearchController.h"
#import "KefuCenterController.h"
#import "RoomViewController.h"

@implementation AlertFactory

/**未登录的操作提示*/
+ (void)createLoginAlert:(UIViewController *)sender withMsg:(NSString *)msg block:(void (^)())block{

   
    __weak typeof(sender) weakSender = sender;
    
    [UIAlertView createAlertViewWithTitle:@"温馨提示" withViewController:sender withCancleBtnStr:@"取消" withOtherBtnStr:@"登录" withMessage:[NSString stringWithFormat:@"登录后才能%@",msg] completionCallback:^(NSInteger index) {
        if (index==1) {
            if (block) {
                block();
            }
            LoginViewController *loginView = [[LoginViewController alloc] init];
            [weakSender.navigationController pushViewController:loginView animated:YES];
        }
        
    }];
}



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
+ (void)createPassswordAlert:(UIViewController *)sender room:(RoomHttp*)room block:(void (^)(NSString *pwd))block
{
    if(IOSVersion<8.1)
    {
        @WeakObj(sender)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入密码"
                                                                       message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
        {
            textField.placeholder = @"输入密码";
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
        {
            UITextField *login = alert.textFields.firstObject;
            if (block)
            {
                block(login.text);
            }
        }];
        [alert addAction:okAction];
        UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
        {
            [senderWeak.view hideToastActivity];
            [[PlayIconView sharedPlayIconView] exitPlay];
            [senderWeak.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:canAction];
        UIAlertAction *requestAction = [UIAlertAction actionWithTitle:@"我要密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
        {
            [senderWeak.view hideToastActivity];
            [[PlayIconView sharedPlayIconView] exitPlay];
            
            DLog(@"%@",senderWeak.navigationController.viewControllers);
            int temp = 0;
            for (int i=0; i!=senderWeak.navigationController.viewControllers.count; i++) {
                UIViewController *vc = senderWeak.navigationController.viewControllers[i];
                if ([vc isKindOfClass:[RoomViewController class]]) {
                    temp=i;
                }
            }
            
            if (temp>0)
            {
                UIViewController *vc = senderWeak.navigationController.viewControllers[(temp-1)];
                [senderWeak.navigationController popViewControllerAnimated:NO];
                @WeakObj(vc)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                ^{
                    [vcWeak.navigationController pushViewController:[[KefuCenterController alloc]init] animated:YES];
                });
            }
        }];
        [alert addAction:requestAction];
        [sender presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        @WeakObj(sender)
        [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView,NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0:
                {
                    [senderWeak.view hideToastActivity];
                    [[PlayIconView sharedPlayIconView] exitPlay];
                    [senderWeak.navigationController popViewControllerAnimated:YES];
                }
                break;
                case 1:
                {
                    UITextField *login = [alertView textFieldAtIndex:0];
                    if (login && block)
                    {
                        block(login.text);
                    }
                }
                break;
                case 2:
                {
                    [senderWeak.view hideToastActivity];
                    [[PlayIconView sharedPlayIconView] exitPlay];
                    
                    DLog(@"%@",senderWeak.navigationController.viewControllers);
                    int temp = 0;
                    for (int i=0; i!=senderWeak.navigationController.viewControllers.count; i++) {
                        UIViewController *vc = senderWeak.navigationController.viewControllers[i];
                        if ([vc isKindOfClass:[RoomViewController class]]) {
                            temp=i;
                        }
                    }
                    
                    if (temp>0)
                    {
                        UIViewController *vc = senderWeak.navigationController.viewControllers[(temp-1)];
                        [senderWeak.navigationController popViewControllerAnimated:NO];
                        @WeakObj(vc)
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                                       ^{
                                           [vcWeak.navigationController pushViewController:[[KefuCenterController alloc]init] animated:YES];
                                       });
                    }
                }
            }
        } txtField:@"输入密码" title:@"请输入密码" message:nil cancelButtonName:nil otherButtonTitles:@"取消",@"确定",@"我要密码", nil];
    }
}

+ (void)createPassswordAlert:(UIViewController *)sender room:(RoomHttp*)room
{
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
       [kProtocolSingle connectVideoRoom:[roomWeak.teamid intValue] roomPwd:login.text];
    }];
    [alert addAction:canAction];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [senderWeak presentViewController:alert animated:YES completion:nil];
    });
}


@end
