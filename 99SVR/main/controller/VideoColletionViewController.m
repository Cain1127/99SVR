//
//  MyCollectionController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/22.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "VideoColletionViewController.h"
#import "UserInfo.h"
#import "RoomListRequest.h"
#import "RoomGroup.h"

@interface VideoColletionViewController()
{
//    UIView *headView;
}

@property (nonatomic,strong) RoomListRequest *listReuqest;

@end

@implementation VideoColletionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _listReuqest = [[RoomListRequest alloc] init];
    self.tableView.frame = Rect(0, 0, kScreenWidth, kScreenHeight-108);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initHistoryData) name:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
    [self initHistoryData];
}

#pragma mark get history
- (void)initHistoryData
{
    if([UserInfo sharedUserInfo].aryCollet==nil)
    {
        [UserInfo sharedUserInfo].aryCollet = [NSMutableArray array];
    }
    [[UserInfo sharedUserInfo].aryCollet removeAllObjects];
    __weak VideoColletionViewController *__self = self;
    _listReuqest.historyBlock = ^(int status,NSArray *aryHistory,NSArray *aryColl)
    {
        for (RoomGroup *group in aryColl)
        {
            [[UserInfo sharedUserInfo].aryCollet addObject:group];
        }
        [__self setVideos:[UserInfo sharedUserInfo].aryCollet];
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self reloadData];
        });
    };
    [_listReuqest requestRoomByUserId:[UserInfo sharedUserInfo].nUserId];
}



@end
