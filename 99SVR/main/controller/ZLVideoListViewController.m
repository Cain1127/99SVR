//
//  ZLVideoListViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLVideoListViewController.h"
#import "RoomHttp.h"
#import "HttpManagerSing.h"
#import "TableViewFactory.h"
#import "VideoCell.h"
#import "ConnectRoomViewModel.h"

@interface ZLVideoListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) ConnectRoomViewModel *roomViewModel;
@property (nonatomic,copy) NSArray *aryVideo;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ZLVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-108) withStyle:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideo:) name:MESSAGE_HOME_VIDEO_LIST_VC object:nil];
    [kHTTPSingle RequestTeamList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)loadVideo:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if([dict isKindOfClass:[NSDictionary class]])
    {
        int nStatus = [dict[@"code"] intValue];
        if(nStatus==1)
        {
            _aryVideo = dict[@"data"];
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfWeak.tableView reloadData];
            });
        }
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
    [self.view makeToastActivity];
    if (_roomViewModel==nil)
    {
        _roomViewModel = [[ConnectRoomViewModel alloc] initWithViewController:self];
    }
    [_roomViewModel connectViewModel:room];
}

@end
