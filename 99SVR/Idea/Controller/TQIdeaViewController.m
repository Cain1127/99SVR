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
#import "UIBarButtonItem+Item.h"
#import "TQDetailedTableViewController.h"

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
    [self setNavgation];
    //tableview初始化
    [self setIdeaTableView];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"专家观点";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHex:@"#0062D5"];
    self.navigationItem.titleView = title;
    
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.gifHeader beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printInfo:) name:@"TQ_ideaLiist_VC" object:nil];
    
    [kHTTPSingle RequestViewpointSummary:16 start:0 count:20];

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

-(void)updateRefresh {
    

    [self.tableView.gifHeader endRefreshing];
    });
}

-(void)setNavgation {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_menu_icon_n"] highImage:[UIImage imageNamed:@"nav_menu_icon_p"] target:self action:@selector(mailboxClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_search_icon_p"] highImage:[UIImage imageNamed:@"nav_search_icon_n"] target:self action:@selector(searchClick)];
    

}

-(void)setIdeaTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQideaTableViewCell class]) bundle:nil] forCellReuseIdentifier:ideaCell];
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
