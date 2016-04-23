//
//  TQCommentReplyViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 评论回复 >**********************************/

#import "TQCommentReplyViewController.h"
#import "TQAllReplyCell.h"
#import "MJRefresh.h"


@interface TQCommentReplyViewController ()
@property (nonatomic ,strong)NSArray *aryModel;

@end

@implementation TQCommentReplyViewController
static NSString *const commentCell = @"commentCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQAllReplyCell class]) bundle:nil] forCellReuseIdentifier:commentCell];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开始刷新,注册数据接受通知
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.gifHeader beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRplayView:) name:MESSAGE_MAILREPLY_VC object:nil];
    
}

- (void)loadRplayView:(NSNotification *)notify
{
    NSArray *aryModel = notify.object;
    _aryModel = aryModel;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

//开始请求.结束下拉刷新
-(void)updateRefresh {
    [kHTTPSingle RequestMailReply:0 count:10];
    [self.tableView.gifHeader endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _aryModel.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TQAllReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
    cell.model = _aryModel[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}



@end
