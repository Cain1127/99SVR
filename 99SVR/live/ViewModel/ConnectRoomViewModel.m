//
//  ConnectRoomViewModel.m
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ConnectRoomViewModel.h"
#import "RoomHttp.h"
#import "UIAlertView+Block.h"
#import "playiconView.h"
#import "RoomViewController.h"
#import "DecodeJson.h"
#import "AlertFactory.h"
#import "Toast+UIView.h"
#import "ZLLogonServerSing.h"
#import "ZLRoomVideoViewController.h"

@implementation ConnectRoomViewModel

- (id)initWithViewController:(UIViewController *)control
{
    self = [super init];
    _control = control;
    return self;
}

- (void)connectViewModel:(RoomHttp *)room
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomErr:) name:MESSAGE_JOIN_ROOM_ERR_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinSuc) name:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
    _room = room;
    [[ZLLogonServerSing sharedZLLogonServerSing] exitRoom];
    [kProtocolSingle connectVideoRoom:[room.roomid intValue] roomPwd:_room.password];
}

- (void)joinRoomErr:(NSNotification *)notify{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @WeakObj(self)
    dispatch_main_async_safe(^{
        [NSObject cancelPreviousPerformRequestsWithTarget:selfWeak];
    });
    if ([notify.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = [notify object];
        int errid = [[dict objectForKey:@"err"] intValue];
        NSString *strMsg = [dict objectForKey:@"msg"];
        [[RoomViewController sharedRoomViewController] stopVideoPlay];
        if (errid==201)
        {
            @WeakObj(self)
            _nTimes++;
            if (_nTimes>1)
            {
                dispatch_main_async_safe(^{
                    [ProgressHUD showError:@"输入密码错误"];
                });
            }
            if ([UserInfo sharedUserInfo].nStatus)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AlertFactory createPassswordAlert:_control room:_room block:^(NSString *pwd)
                     {
                         selfWeak.room.password = pwd;
                         [selfWeak connectViewModel:selfWeak.room];
                     }];
                });
            }
            else
            {}
        }
        else
        {
            @WeakObj(strMsg)
            @WeakObj(_control)
            if (errid==101)
            {
                dispatch_main_async_safe(^{
                    [[PlayIconView sharedPlayIconView] exitPlay];
                    [_controlWeak.navigationController popViewControllerAnimated:YES];
                });
            }
            else if (errid == 502)
            {
                dispatch_main_async_safe(^{
                [UIAlertView createAlertViewWithTitle:@"提示" withViewController:_controlWeak withCancleBtnStr:nil withOtherBtnStr:@"知道了" withMessage:@"房间人数已满" completionCallback:^(NSInteger index) {
                    if (index==1)
                    {
                            [[PlayIconView sharedPlayIconView] exitPlay];
                            [_controlWeak.navigationController popViewControllerAnimated:YES];
                    }
                    }];
                });
            }
            else
            {
                if (_ConnectRoomResult)
                {
                    _ConnectRoomResult(0);
                }
                dispatch_async(dispatch_get_main_queue(),
                ^{
                    [ProgressHUD showError:strMsgWeak];
                });
            }
        }
    }
}

- (void)joinSuc
{
    @WeakObj(self)
    dispatch_main_async_safe(^{
        [NSObject cancelPreviousPerformRequestsWithTarget:selfWeak];
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_ConnectRoomResult)
    {
        _ConnectRoomResult(1);
    }
}

- (void)joinRoomTimeOut
{
    @WeakObj(self)
    dispatch_main_async_safe(^{
        [NSObject cancelPreviousPerformRequestsWithTarget:selfWeak];
    });
    if (_ConnectRoomResult)
    {
        _ConnectRoomResult(999);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
