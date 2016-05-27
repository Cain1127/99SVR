//
//  ZLVideoListViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLVideoListViewController.h"
#import "ZLRoomVideoViewController.h"
#import "RoomHttp.h"
#import "UIViewController+EmpetViewTips.h"
#import "RoomViewController.h"
#import "PlayIconView.h"
#import "HttpManagerSing.h"
#import "TableViewFactory.h"
#import "VideoCell.h"
#import "ConnectRoomViewModel.h"
#import "MJRefresh.h"
#import "ViewNullFactory.h"

@interface ZLVideoListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
}
@property (nonatomic,strong) UIView *noView;
@property (nonatomic,strong) ConnectRoomViewModel *roomViewModel;
@property (nonatomic,copy) NSArray *aryVideo;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ZLVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self setTitleText:@"财经直播"];
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-108) withStyle:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideo:) name:MESSAGE_HOME_VIDEO_LIST_VC object:nil];
    //切换皮肤的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThemeSkin:) name:MESSAGE_CHANGE_THEMESKIN object:nil];

    [kHTTPSingle RequestTeamList];

    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView.gifHeader loadDefaultImg];
    if (_aryVideo.count==0) {
        [_tableView.gifHeader beginRefreshing];
    }
}

- (void)updateRefresh
{
    if (_aryVideo.count==0)
    {
        [self hideEmptyViewInView:_tableView];
        [_tableView makeToastActivity_bird];
    }
    [kHTTPSingle RequestTeamList];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_HOME_VIDEO_LIST_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_CHANGE_THEMESKIN object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if (roomView.room)
    {
        PlayIconView *iconView = [PlayIconView sharedPlayIconView];
        iconView.frame = Rect(0, kScreenHeight-104, kScreenWidth, 60);
        [self.view addSubview:iconView];
        [roomView removeNotice];
        [iconView setRoom:roomView.room];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)loadVideo:(NSNotification *)notify
{
    
    Loading_Hide(self.tableView);
    NSDictionary *parameters = notify.object;
    @WeakObj(self)
    int code = [parameters[@"code"] intValue];
    NSArray *aryShow = parameters[@"show"];

    dispatch_async(dispatch_get_main_queue(), ^{

        [self.tableView.gifHeader endRefreshing];
        
        if (code==1) {//请求成功
            _aryVideo = nil;
            _aryVideo = aryShow;
            NSMutableArray *aryAll = [NSMutableArray array];
            [aryAll addObjectsFromArray:_aryVideo];
            NSArray *aryHidden = parameters[@"hidden"];
            for (RoomHttp *room in aryHidden)
            {
                [aryAll addObject:room];
            }
            NSArray *aryHelp = parameters[@"help"];
            
            [UserInfo sharedUserInfo].aryHelp = aryHelp;
            for (RoomHttp *room in aryHelp)
            {
                [aryAll addObject:room];
            }
            [UserInfo sharedUserInfo].aryRoom = aryAll;
        }
        
            [selfWeak.tableView reloadData];
        
        [selfWeak chickEmptyViewShowWithTab:selfWeak.tableView withData:_aryVideo withCode:[NSString stringWithFormat:@"%d",code]];
    });

}

#pragma mark 请求成功时候-检测是否出现提示图
-(void)chickEmptyViewShowWithTab:(UITableView *)tab withData:(NSArray *)dataArray withCode:(NSString *)code{
    
    WeakSelf(self);
    
    if (dataArray.count==0&&[code intValue]!=1) {//数据为0 请求失败
        
        [self showErrorViewInView:tab withMsg:RequestState_NetworkErrorStr(code) touchHanleBlock:^{
            
            Loading_Bird_Show(self.tableView);
            [weakSelf.tableView.footer beginRefreshing];
        }];
    }else if (dataArray.count==0&&[code intValue]==1){//数据为0 请求成功
        
        [self showEmptyViewInView:tab withMsg:RequestState_EmptyStr(code) touchHanleBlock:^{
            

        }];
        
    }else{//请求成功
        
        [self hideEmptyViewInView:tab];
        
    }
    
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
    if (KUserSingleton.nStatus) {
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
    else
    {
        ZLRoomVideoViewController *viewVC = [[ZLRoomVideoViewController alloc] initWithModel:room];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
}

#pragma mark 皮肤切换
-(void)changeThemeSkin:(NSNotification *)notfication{
    DLog(@"切换皮肤");
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}


@end
