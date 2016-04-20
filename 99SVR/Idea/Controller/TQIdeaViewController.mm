//
//  TQIdeaViewController.m
//  99SVR
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/**************************************** < 专家观点首页 >**********************************/
#import "TQIdeaViewController.h"
#import "TQideaTableViewCell.h"
#import "GroupListRequest.h"
#import "MJRefresh.h"
#import "SearchController.h"
#import <AFNetworking/AFNetworking.h>
#import "MJRefresh.h"
#import "TQMailboxViewController.h"
#import "TQcontentView.h"
#import "TQDetailedTableViewController.h"

#include "HttpMessage.pb.h"

@interface TQIdeaViewController ()
/*AFN管理者*/
@property (nonatomic ,weak) AFHTTPSessionManager *manager;

@end

@implementation TQIdeaViewController
static NSString *const ideaCell = @"status";

-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏初始化
    [self initNavgation];
    //tableview初始化
    [self initIdeaTableView];
    
    
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.gifHeader beginRefreshing];
    TQcontentView *view1 = [[TQcontentView alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth, 44)];
    [self.tableView addSubview:view1];
    
//    [kHTTPSingle RequestViewpointSummary:0 start:0 count:20];
}

-(void)updateRefresh {
    [kHTTPSingle RequestViewpointSummary:0 start:0 count:20];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.gifHeader endRefreshing];
    });
}

-(void)initNavgation {
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"信箱" style:0 target:self action:@selector(mailboxClick)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:0 target:self action:@selector(searchClick)];

}

-(void)initIdeaTableView {
//    UITableView *tableView = [[UITableView alloc] init];
//    //    tableView.backgroundColor = [UIColor redColor];
//    tableView.frame = self.view.frame;
//    [self.view addSubview:tableView];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    tableView.rowHeight = 200;
//    self.ideaTableView = tableView;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQideaTableViewCell class]) bundle:nil] forCellReuseIdentifier:ideaCell];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printInfo:) name:MESSAGE_REQUEST_VIEW_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)printInfo:(NSNotification *)notify{
    NSMutableArray *array = notify.object;
    for (NSValue *value in array) {
        ViewpointSummary *summary = (ViewpointSummary*)value.pointerValue;
        DLog(@"%s",summary->authorname().c_str());
    }
}

-(void)mailboxClick {
 
    TQMailboxViewController *mailbox = [[TQMailboxViewController alloc] init];
    [self.navigationController pushViewController:mailbox animated:YES];

}
//- (void)showLeftView
//{
//    [self leftItemClick];
//}

- (void)searchClick
{
    SearchController *search = [[SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}




#pragma mark - TableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TQideaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ideaCell];


    return cell;
}
#pragma mark - TableViewDelegete
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TQDetailedTableViewController *detaileVc = [[TQDetailedTableViewController alloc] init];
//    [self presentViewController:detaileVc animated:YES completion:nil];
    [self.navigationController pushViewController:detaileVc animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}


@end
