//
//  TQMessageViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 系统消息 >**********************************/

#import "TQMessageViewController.h"
#import "TQMessageCell.h"
#import "TQMessageModel.h"
#import "Masonry.h"
#import "TableViewFactory.h"
#import "MJRefresh.h"
#import "UIViewController+EmpetViewTips.h"

@interface TQMessageViewController ()<UITableViewDataSource,UITableViewDelegate,TQMessageDelegate>
{
    NSCache *cellCache;
}
/** 模型数组 */
@property (nonatomic,copy) NSMutableArray *aryMessage;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TQMessageViewController
static NSString *const messageCell = @"messageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"系统消息"];
    cellCache = [[NSCache alloc] init];
    [cellCache setTotalCostLimit:10];
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0,64,kScreenWidth,kScreenHeight-64) withStyle:UITableViewStylePlain];
    [_tableView setBackgroundColor:UIColorFromRGB(0xffffff)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//     // 估算高度
//    self.tableView.estimatedRowHeight = 44;
    [self.view addSubview:_tableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SystemMessage:) name:MESSAGE_SYSTEMMESSAGE_VC object:nil];
    //开始刷新,注册数据接受通知
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.gifHeader beginRefreshing];
    [self.view makeToastActivity_bird_bird];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_SYSTEMMESSAGE_VC object:nil];
}

#pragma mark - 懒加载

-(NSMutableArray *)aryMessage
{
    if (!_aryMessage) {
        _aryMessage = [NSMutableArray array];
    }
    return _aryMessage;
}

//获取模型,刷新列表
- (void)SystemMessage:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if ([dict[@"code"] intValue]==1) {
        NSArray *aryModel = dict[@"data"];
        for (TQMessageModel *model in aryModel) {
            [self.aryMessage addObject:model];
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
        [self chickEmptyViewShowWithTab:_tableView withData:(NSMutableArray *)_aryMessage withCode:[dict[@"code"] intValue]];
    });
}

-(void)chickEmptyViewShowWithTab:(UITableView *)tab withData:(NSMutableArray *)dataArray withCode:(NSInteger)code{
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

//开始请求.结束下拉刷新
-(void)updateRefresh {
    [_aryMessage removeAllObjects];
    [kHTTPSingle RequestSystemMessage:0 count:10];
}

// 加载更多
- (void)uploadMore
{
    if (_aryMessage.count > 0) {
        TQMessageModel *model = _aryMessage[_aryMessage.count-1];
        [kHTTPSingle RequestSystemMessage:model.Id count:10];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _aryMessage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *strKey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    TQMessageCell *cell = [cellCache objectForKey:strKey];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TQMessageCell" owner:nil options:nil] lastObject];
        [cellCache setObject:cell forKey:strKey];
    }
    
    if(_aryMessage.count>indexPath.section)
    {
        cell.section = indexPath.section;
        cell.messageModel = _aryMessage[indexPath.section];
        cell.delegate = self;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strKey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    TQMessageCell *cell = [cellCache objectForKey:strKey];
    return [cell requiredRowHeightInTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)clickCell:(TQMessageCell *)cell show:(BOOL)bAll
{
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cell.section];
    //[_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //[_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
