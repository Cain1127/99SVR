//
//  MessageViewController
//  99SVR_UI
//
//  Created by jiangys on 16/4/28.
//  Copyright © 2016年 Jiangys. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "TQMessageModel.h"
#import "MJRefresh.h"
#import "UIViewController+EmpetViewTips.h"

static NSUInteger const kPageCount = 10; // 每页显示多少条

@interface MessageViewController()<UITableViewDelegate,UITableViewDataSource,MessageTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation MessageViewController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    self.view.backgroundColor = COLOR_Bg_Gay;
    [self setTitleText:@"系统消息"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSystemMessage:) name:MESSAGE_SYSTEMMESSAGE_VC object:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_SYSTEMMESSAGE_VC object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark - 懒加载

-(NSMutableArray *)messageArray
{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
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
    [_tableView.footer setHidden:YES];
    
    [self.view addSubview:_tableView];
    [self.view makeToastActivity_bird];
}

#pragma mark - 加载数据

//获取模型,刷新列表
- (void)loadSystemMessage:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if ([dict[@"code"] intValue]==1) {
        NSArray *aryModel = dict[@"data"];
        if ([self.tableView.header isRefreshing]) { // 下拉刷新，清除原来的数据
            [_messageArray removeAllObjects];
        }
        for (TQMessageModel *model in aryModel) {
            [self.messageArray addObject:model];
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
        [self chickEmptyViewShowWithTab:_tableView withData:(NSMutableArray *)_messageArray withCode:[dict[@"code"] intValue]];
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

// 开始请求.结束下拉刷新
-(void)updateRefresh {
    [kHTTPSingle RequestSystemMessage:0 count:kPageCount];
}

// 加载更多
- (void)uploadMore
{
    if (_messageArray.count > 0) {
        TQMessageModel *model = _messageArray[_messageArray.count-1];
        [kHTTPSingle RequestSystemMessage:model.Id count:kPageCount];
    }
}

#pragma mark - UITableViewDataSource数据源方法
// 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

// 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [MessageTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    if (self.messageArray.count > 0) {
        cell.messageModel = self.messageArray[indexPath.row];
    }
    
//    UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 0.5)];
//    lineTop.backgroundColor = COLOR_Line_Small_Gay;
//    [cell addSubview:lineTop];
//    
//    UIView *lineButton = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height - 0.5, kScreenWidth, 0.5)];
//    lineButton.backgroundColor = COLOR_Line_Small_Gay;
//    [cell addSubview:lineButton];
    
    return cell;
}

#pragma mark - UITableViewDelegate 代理方法

// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat LR = 12;
    CGFloat H = 80;
    
    TQMessageModel *model = self.messageArray[indexPath.row];
    CGSize contentSize = [model.content sizeMakeWithFont:Font_14 maxW:kScreenWidth - 2 * LR];
    
    if (contentSize.height > 18 && !model.isShowAllText) {
        H = H + 30;
    } else if(model.isShowAllText){
        H = H + contentSize.height + 10;
    }
    
    return H;
}

#pragma mark - AnswerTableViewCellDelegate 点击全文代理

- (void)messageTableViewCell:(MessageTableViewCell *)messageTableViewCell allTextClick:(NSUInteger)btnId
{
    int index = -1 ;
    
    TQMessageModel *model = [[TQMessageModel alloc] init];
    for (int i = 0; i<self.messageArray.count; i++) {
        TQMessageModel *oldModel = self.messageArray[i];
        if (oldModel.Id == btnId) {
            model = oldModel;
            index = i;
        }
    }
    
    if (index >= 0) {
        model.isShowAllText = !model.isShowAllText;
        [self.messageArray replaceObjectAtIndex:index withObject:model];
        [self.tableView reloadData];
    }
}

@end
