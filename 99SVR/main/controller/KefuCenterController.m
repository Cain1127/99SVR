//
//  KefuCenterController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "KefuCenterController.h"
#import "RoomGroup.h"
#import "UserInfo.h"
#import "GroupListRequest.h"
#import "RoomHttp.h"

@interface KefuCenterController()

@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) GroupListRequest *listReuqest;

@end

@implementation KefuCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addHeaderView:@"客服中心"];
    self.listReuqest = [[GroupListRequest alloc] init];
    if ([UserInfo sharedUserInfo].aryHelp)
    {
        [self setVideos:[UserInfo sharedUserInfo].aryHelp];
        [self reloadData];
    }
}

#pragma mark get history
- (void)loadData
{
    __weak KefuCenterController *__self = self;
    self.listReuqest.groupBlock = ^(int status,NSArray *aryIndex)
    {
        for (RoomGroup *group in aryIndex)
        {
            if ([group.groupid isEqualToString:@"16"]) {
                [__self.datas addObject:group];
                break;
            }
        }
        [__self setVideos:__self.datas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self reloadData];
        });
    };
    [self.listReuqest requestListRequest];
}

@end
