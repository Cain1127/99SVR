//
//  ConnectRoomViewModel.m
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ConnectRoomViewModel.h"
#import "RoomHttp.h"
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
    [self performSelector:@selector(joinRoomTimeOut) withObject:nil afterDelay:8.0];

}

- (void)joinRoomErr:(NSNotification *)notify{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [DecodeJson cancelPerfor:self];
    if ([notify.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = [notify object];
        int errid = [[dict objectForKey:@"err"] intValue];
        NSString *strMsg = [dict objectForKey:@"msg"];
        if (errid==201)
        {
            @WeakObj(self)
            if ([UserInfo sharedUserInfo].nStatus)
            {
                [AlertFactory createPassswordAlert:_control room:_room block:^(NSString *pwd) {
                    selfWeak.room.password = pwd;
                    [selfWeak connectViewModel:selfWeak.room];
                }];
            }
            else
            {
                @WeakObj(_control)
                dispatch_async(dispatch_get_main_queue(),
                ^{
                    [_controlWeak.view hideToastActivity];
                    [ProgressHUD showError:@"加入房间失败或房间被关闭"];
                });
            }
        }
        else
        {
            @WeakObj(strMsg)
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD showError:strMsgWeak];
            });
        }
    }
}

- (void)joinSuc
{
    [DecodeJson cancelPerfor:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_ConnectRoomResult)
    {
        _ConnectRoomResult(1);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (KUserSingleton.nStatus)
        {
//            [_controlWeak.view hideToastActivity];
//            RoomViewController *roomView = [RoomViewController sharedRoomViewController];
//            [roomView setRoom:_room];
//            [_controlWeak.navigationController pushViewController:roomView animated:YES];
        }
        else
        {
//            [_controlWeak.view hideToastActivity];
//            ZLRoomVideoViewController *control = [[ZLRoomVideoViewController alloc] initWithModel:_room];
//            [_controlWeak.navigationController pushViewController:control animated:YES];
        }
    });
    
}

- (void)joinRoomTimeOut
{
    [DecodeJson cancelPerfor:self];
    @WeakObj(_control)
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_controlWeak.view hideToastActivity];
//        [ProgressHUD showError:@"加入房间失败"];
//    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
