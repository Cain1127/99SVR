//
//  XIdeaViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XIdeaViewController.h"
#import "TableViewFactory.h"
#import "TQideaTableViewCell.h"
#import "GroupListRequest.h"
#import "MJRefresh.h"
#import "SearchController.h"
#import <AFNetworking/AFNetworking.h>
#import "MJRefresh.h"
#import "TQMailboxViewController.h"
#import "TQcontentView.h"
#import "CustomViewController.h"
#import "UIBarButtonItem+Item.h"
#import "TQDetailedTableViewController.h"
#import "TQIdeaModel.h"
#import "RoomHttp.h"

@interface XIdeaViewController ()<UITableViewDataSource,UITableViewDelegate>
/** 数据数租 */
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryModel;
@property (nonatomic,strong) RoomHttp *room;

@end

@implementation XIdeaViewController

static NSString *const ideaCell = @"TQIdeaTableViewIdentifier";

- (id)initWihModel:(RoomHttp *)room
{
    self = [super init];
    _room = room;
    return self;
}

- (void)setModel:(RoomHttp *)room
{
    _room = room;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-kRoom_head_view_height)];
}

-(void)initUi{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    //导航栏初始化
    [self initUi];
    //tableview初始化
    [self setIdeaTableView];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"专家观点";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHex:@"#0062D5"];
    self.navigationItem.titleView = title;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.gifHeader beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewPoint:) name:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)loadViewPoint:(NSNotification *)notify{
    NSArray *aryModel = notify.object;
    _aryModel = aryModel;
    @WeakObj(_tableView)
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableViewWeak reloadData];
        [_tableViewWeak.gifHeader endRefreshing];
    });
}

-(void)updateRefresh {
    if (_room) {
        [kHTTPSingle RequestViewpointSummary:[_room.nvcbid intValue] start:0 count:10];
    }else{
        [kHTTPSingle RequestViewpointSummary:0 start:0 count:10];
    }
    
    [self.tableView.gifHeader endRefreshing];
}

-(void)setIdeaTableView {
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0,0,kScreenWidth,self.view.height) withStyle:UITableViewStylePlain];
    [_tableView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQideaTableViewCell class]) bundle:nil] forCellReuseIdentifier:ideaCell];
}

-(void)mailboxClick {
    TQMailboxViewController *mailbox = [[TQMailboxViewController alloc] init];
    [self.navigationController pushViewController:mailbox animated:YES];
}

- (void)searchClick
{
    SearchController *search = [[SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - TableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _aryModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TQideaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ideaCell];
    
    if (_aryModel.count>indexPath.row) {
        [cell setIdeaModel:[_aryModel objectAtIndex:indexPath.row]];
    }
    
    return cell;
}
#pragma mark - TableViewDelegete
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_aryModel.count>indexPath.row) {
        TQDetailedTableViewController *detaileVc = [[TQDetailedTableViewController alloc] init];
        [self.navigationController pushViewController:detaileVc animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}


@end

