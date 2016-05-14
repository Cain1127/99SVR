//
//  KefuCenterController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "KefuCenterController.h"
#import "RoomGroup.h"
#import "RoomViewController.h"
#import "VideoCell.h"
#import "UserInfo.h"
#import "GroupListRequest.h"
#import "RoomHttp.h"
#import "ConnectRoomViewModel.h"
#import "TableViewFactory.h"

@interface KefuCenterController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSArray *aryVideo;
@property (nonatomic,strong) GroupListRequest *listReuqest;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ConnectRoomViewModel *roomViewModel;
@end

@implementation KefuCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"客服中心"];
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) withStyle:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark get history
- (void)loadData
{
    if ([UserInfo sharedUserInfo].aryHelp)
    {
        _aryVideo = [UserInfo sharedUserInfo].aryHelp;
        [self.tableView reloadData];
    }
    else
    {
        [self.view makeToastActivity_bird];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideoList:) name:MESSAGE_HOME_VIDEO_LIST_VC object:nil];
        [kHTTPSingle RequestTeamList];
    }
}

- (void)loadVideoList:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.view hideToastActivity];
    });
    if([dict isKindOfClass:[NSDictionary class]])
    {
        int nStatus = [dict[@"code"] intValue];
        if(nStatus==1)
        {
            NSArray *aryVideo = dict[@"show"];
            NSMutableArray *aryAll = [NSMutableArray array];
            [aryAll addObjectsFromArray:aryVideo];
            NSArray *aryHidden = dict[@"hidden"];
            for (RoomHttp *room in aryHidden)
            {
                [aryAll addObject:room];
            }
            
            NSArray *aryHelp = dict[@"help"];
            [UserInfo sharedUserInfo].aryHelp = aryHelp;
            _aryVideo = aryHelp;
            for (RoomHttp *room in aryHelp)
            {
                [aryAll addObject:room];
            }
            [UserInfo sharedUserInfo].aryRoom = aryAll;
            
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
               [selfWeak.tableView reloadData];
            });
            return ;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showError:@"获取财经直播团队列表失败，无法搜索"];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"dealloc");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *videoCellName = @"videoCellName";
    VideoCell *tempCell = [_tableView dequeueReusableCellWithIdentifier:videoCellName];
    
    if(!tempCell)
    {
        tempCell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellName];
    }
    @WeakObj(self);
    tempCell.itemOnClick = ^(RoomHttp *room)
    {
        [selfWeak connectRoom:room];
    };
    int length = 2;
    int loc = (int)indexPath.row * length;
    if (loc + length > _aryVideo.count)
    {
        length = (int)_aryVideo.count - loc;
    }
    NSRange range = NSMakeRange(loc, length);
    NSArray *aryIndex = [_aryVideo subarrayWithRange:range];
    [tempCell setRowDatas:aryIndex isNew:1];
    return tempCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = (NSInteger)ceilf((1.0f * _aryVideo.count) / 2.0f);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat height = ((kScreenWidth - 36.0f) / 2.0f) * 10 / 16 + 8;
    return height;
}

- (void)connectRoom:(RoomHttp *)room{
//    [self.view makeToastActivity_bird];
//    if (_roomViewModel==nil)
//    {
//        _roomViewModel = [[ConnectRoomViewModel alloc] initWithViewController:self];
//    }
//    [_roomViewModel connectViewModel:room];
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if ([roomView.room.roomid isEqualToString:room.roomid])
    {
        [roomView addNotify];
        [self.navigationController pushViewController:roomView animated:YES];
        return ;
    }
    [roomView setRoom:room];
    [self.navigationController pushViewController:roomView animated:YES];
}

@end
