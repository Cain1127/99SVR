//
//  TQPersonalTailorViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
///**************************************** < 私人定制 >**********************************/

#import "TQPersonalTailorViewController.h"
#import "TQPersonalTailorCell.h"
#import "NNSVRViewController.h"
#import "XPrivateDetailViewController.h"
#import "TableViewFactory.h"
#import "TQPersonalModel.h"
#import "MJRefresh.h"
#import "UIViewController+EmpetViewTips.h"

static NSUInteger const kPageCount = 10; // 每页显示多少条
static NSString *const PersonalTailorCell = @"PersonalTailorCell.h";

@interface TQPersonalTailorViewController ()<UITableViewDataSource,UITableViewDelegate,TQPersonalTailorCellDelegate>

/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *personalArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TQPersonalTailorViewController


#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"私人定制"];
    // 初始化tableView
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRplayView:) name:MESSAGE_HTTP_TQPERSONAlTAILOR_VC object:nil];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_HTTP_TQPERSONAlTAILOR_VC object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark - 懒加载

-(NSMutableArray *)personalArray
{
    if (!_personalArray) {
        _personalArray = [NSMutableArray array];
    }
    return _personalArray;
}

#pragma mark - 初始化界面

- (void)setupTableView
{
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];;
    _tableView.dataSource = self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_Bg_Gay;
    [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    [_tableView.gifHeader loadDefaultImg];
    [_tableView.gifHeader beginRefreshing];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQPersonalTailorCell class]) bundle:nil] forCellReuseIdentifier:PersonalTailorCell];
    
    [self.view addSubview:_tableView];
    [self.view makeToastActivity_bird];
}

#pragma mark - 加载数据

//开始请求.结束下拉刷新
-(void)updateRefresh {
    [kHTTPSingle RequestPrivateServiceSummary:0 count:kPageCount];
}

// 加载更多
- (void)uploadMore
{
    if (_personalArray.count > 0) {
        TQPersonalModel *model = _personalArray[_personalArray.count-1];
        [kHTTPSingle RequestPrivateServiceSummary:model.ID count:kPageCount];
    }
}

- (void)loadRplayView:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if ([dict[@"code"] intValue]==1) {
        NSArray *aryModel = dict[@"data"];
        
        if ([self.tableView.header isRefreshing]) { // 下拉刷新，清除原来的数据
            [self.personalArray removeAllObjects];
        }
        
        for (TQPersonalModel *model in aryModel) {
            [self.personalArray addObject:model];
        }
        
        // 隐藏上拉刷新
        if ([self.tableView.footer isRefreshing]
            && aryModel.count < kPageCount){
            [self.tableView.footer setHidden:YES];
        } else {
            [self.tableView.footer setHidden:NO];
        }
    }
    
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @StrongObj(self);
        [self.view hideToastActivity];
        if ([self.tableView.header isRefreshing]) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        [self chickEmptyViewShowWithTab:_tableView withData:(NSMutableArray *)_personalArray withCode:[dict[@"code"] intValue]];
    });
}

- (void)chickEmptyViewShowWithTab:(UITableView *)tab withData:(NSMutableArray *)dataArray withCode:(NSInteger)code{
    [self hideEmptyViewInView:tab];
    @WeakObj(self);
    if(code!=1) {
        [self showErrorViewInView:tab withMsg:@"网络请求失败" touchHanleBlock:^{
            @StrongObj(self);
            [self.tableView.gifHeader beginRefreshing];
        }];
    } else if (dataArray.count==0 && code==1){//数据为0 请求成功
        [self showEmptyViewInView:tab withMsg:[NSString stringWithFormat:@"暂无数据"] touchHanleBlock:^{
            @StrongObj(self);
            [self.tableView.gifHeader beginRefreshing];
        }];
    } else{//请求成功
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _personalArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TQPersonalTailorCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalTailorCell];
    cell.delegate = self;
    if (_personalArray.count > indexPath.section) {
        TQPersonalModel *personalModel = _personalArray[indexPath.section];
        cell.TITLELabel.text = personalModel.title;
        cell.summaryLabel.text = personalModel.summary;
        cell.timeLabel.text = personalModel.publishtime;
        cell.nameLabel.text = personalModel.teamname;
        cell.personalModel = personalModel;
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 164;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_personalArray.count>indexPath.section) {
        TQPersonalModel *model = _personalArray[indexPath.section];
//        XPrivateDetailViewController *detailView = [[XPrivateDetailViewController alloc] initWithCustomId:model.ID];
//        [self.navigationController pushViewController:detailView animated:YES];
        NSString *strInfo = [NSString stringWithFormat:@"%@%d.html",kPrivate_detail_url,model.ID];
        NNSVRViewController *svrView = [[NNSVRViewController alloc] initWithPath:strInfo title:model.teamname];
        [self.navigationController pushViewController:svrView animated:YES];
    }
}

# pragma mark -- personalTailorCell点击代理。点击查看

-(void)personalTailorCell:(TQPersonalTailorCell *)personalTailorCell seeButtonClickAtPersonalModel:(TQPersonalModel *)personalModel
{
    XPrivateDetailViewController *detailView = [[XPrivateDetailViewController alloc] initWithCustomId:personalModel.ID];
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
