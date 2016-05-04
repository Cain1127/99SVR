//
//  ZLVideoListViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLVideoListViewController.h"
#import "RoomHttp.h"
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
    [kHTTPSingle RequestTeamList];
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView.gifHeader loadDefaultImg];
}

- (void)updateRefresh
{
    if (_aryVideo.count==0)
    {
        [self.view makeToastActivity_bird];
    }
    [kHTTPSingle RequestTeamList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideo:) name:MESSAGE_HOME_VIDEO_LIST_VC object:nil];
    if (_aryVideo.count==0) {
        [_tableView.gifHeader beginRefreshing];
    }
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if (roomView.room)
    {
        PlayIconView *iconView = [PlayIconView sharedPlayIconView];
        iconView.frame = Rect(0, kScreenHeight-104, kScreenWidth, 60);
        [self.view addSubview:iconView];
        [iconView setRoom:roomView.room];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)loadVideo:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.view hideToastActivity];
        [selfWeak.noView removeFromSuperview];
    });
    if([dict isKindOfClass:[NSDictionary class]])
    {
        int nStatus = [dict[@"code"] intValue];
        if(nStatus==1)
        {
            _aryVideo = dict[@"show"];
            NSMutableArray *aryAll = [NSMutableArray array];
            [aryAll addObjectsFromArray:_aryVideo];
            NSArray *aryHidden = dict[@"hidden"];
            for (RoomHttp *room in aryHidden)
            {
                [aryAll addObject:room];
            }
            NSArray *aryHelp = dict[@"help"];
            [UserInfo sharedUserInfo].aryHelp = aryHelp;
            for (RoomHttp *room in aryHelp)
            {
                [aryAll addObject:room];
            }
            [UserInfo sharedUserInfo].aryRoom = aryAll;
        }
    }
    if (_aryVideo.count==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak createView];
        });
    }
    dispatch_async(dispatch_get_main_queue(),
    ^{
         [selfWeak.tableView.header endRefreshing];
         [selfWeak.tableView reloadData];
    });
}

- (void)createView
{
    if (nil==_noView)
    {
        char cString[255];
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        sprintf(cString, "%s/network_anomaly_fail.png",path);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        UIImage *image = [UIImage imageWithContentsOfFile:objCString];
        if(image)
        {
            _noView = [ViewNullFactory createViewBg:Rect(0,0,kScreenWidth,_tableView.height) imgView:image msg:@"没有专家发布观点"];
        }
    }
    [_tableView addSubview:_noView];
    @WeakObj(self)
    [_noView clickWithBlock:^(UIGestureRecognizer *gesture)
     {
         [selfWeak.noView removeFromSuperview];
         [selfWeak.view makeToastActivity_bird];
         [selfWeak updateRefresh];
     }];
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
    [self.view makeToastActivity_bird];
    if (_roomViewModel==nil)
    {
        _roomViewModel = [[ConnectRoomViewModel alloc] initWithViewController:self];
    }
    [_roomViewModel connectViewModel:room];
}

@end
