//
//  TQIdeaViewController.m
//  99SVR
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/**************************************** < 专家观点首页 >**********************************/

#import "TQIdeaViewController.h"
#import "RoomViewController.h"
#import "PlayIconView.h"
#import "roomhttp.h"
#import "TableViewFactory.h"
#import "TQideaTableViewCell.h"
#import "XIdeaDataSource.h"
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
#import "ViewNullFactory.h"
#import "UIImage+MultiFormat.h"
#import "Toast+UIView.h"
#import "UIViewController+EmpetViewTips.h"

@interface TQIdeaViewController ()<XIdeaDelegate>
{
    NSCache *viewCache;
}
/** 数据数租 */
@property (nonatomic,strong) UIView *noView;
@property (nonatomic,assign) NSInteger nCurrent;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) XIdeaDataSource *dataSource;
/**下拉刷新需要清空数据！上啦不需要*/
@property (nonatomic , assign) __block MJRefreshState refreshState;


@end

@implementation TQIdeaViewController

static NSString *const ideaCell = @"TQIdeaTableViewIdentifier";

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);

    //添加更新专家观点的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newIdeaNotifi:) name:MESSAGE_TQIdeaView_NewNotifi_VC object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewPoint:) name:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:nil];

    [self setTitleText:@"专家观点"];
    
    viewCache = [[NSCache alloc] init];
    [viewCache setTotalCostLimit:10];
    
    [self setIdeaTableView];
    
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.footer setHidden:YES];
    if(_dataSource.aryModel.count==0)
    {
        [self.tableView.gifHeader beginRefreshing];
    }

    _nCurrent = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if (roomView.room)
    {
        PlayIconView *iconView = [PlayIconView sharedPlayIconView];
        iconView.frame = Rect(0, kScreenHeight-104, kScreenWidth, 60);
        [roomView removeNotice];
        [self.view addSubview:iconView];
        [iconView setRoom:roomView.room];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

/**新的专家观点通知*/
- (void)newIdeaNotifi:(NSNotification *)notify{
    
    DLog(@"新的专家观点%@",notify.object);
    
}

- (void)loadViewPoint:(NSNotification *)notify{
    

    
    NSDictionary *parameters = notify.object;
    @WeakObj(self)
    
    int code = [parameters[@"code"] intValue];
    NSArray *aryIndex = parameters[@"model"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        Loading_Hide(selfWeak.tableView);
        [selfWeak.tableView.header endRefreshing];
        [selfWeak.tableView.footer endRefreshing];
        if (code==1) {//请求成功
            
            if (self.refreshState == MJRefreshState_Header) {//头部
                _dataSource.aryModel = nil;
            }
            
            if (_dataSource.aryModel.count>0)
            {
                NSMutableArray *aryAll = [NSMutableArray array];
                [aryAll addObjectsFromArray:_dataSource.aryModel];
                for (TQIdeaModel *model in aryIndex) {
                    [aryAll addObject:model];
                }
                _dataSource.aryModel = aryAll;
            }
            else
            {
                _dataSource.aryModel = aryIndex;
            }
        }else{//请求失败
        
        }
        
        if (self.nCurrent != self.dataSource.aryModel.count && self.dataSource.aryModel.count!=0)
        {
            [self.tableView.footer setHidden:YES];
        }
        else
        {
            [self.tableView.footer setHidden:NO];
        }
        [self.tableView reloadData];
        
        [self chickEmptyViewShowWithTab:self.tableView withData:self.dataSource.aryModel withCode:code];

    });
}

#pragma mark 请求成功时候-检测是否出现提示图
-(void)chickEmptyViewShowWithTab:(UITableView *)tab withData:(NSArray *)dataArray withCode:(int)code{
    
    NSString *codeStr = [NSString stringWithFormat:@"%d",code];
    WeakSelf(self);
    
    if (dataArray.count==0&&(code!=1)) {//数据为0 请求失败
        
        [self showErrorViewInView:tab withMsg:RequestState_NetworkErrorStr(codeStr) touchHanleBlock:^{
            [weakSelf.tableView.gifHeader beginRefreshing];
        }];
    }else if (dataArray.count==0&&(code==1)){//数据为0 请求成功
        
        [self showEmptyViewInView:tab withMsg:RequestState_EmptyStr(codeStr) touchHanleBlock:^{
            
            
        }];
        
    }else{//请求成功
        
        [self hideEmptyViewInView:tab];
    }
    
}


-(void)updateRefresh
{
    self.refreshState = MJRefreshState_Header;
    _nCurrent = 20;
    if (_dataSource.aryModel.count==0)
    {
        [self hideEmptyViewInView:_tableView];
        [_tableView makeToastActivity_bird];
    }
    [kHTTPSingle RequestViewpointSummary:0 start:0 count:20];
}

- (void)uploadMore
{
    self.refreshState = MJRefreshState_Footer;
    if (_dataSource.aryModel.count>0)
    {
        TQIdeaModel *model = _dataSource.aryModel[_dataSource.aryModel.count-1];
        _nCurrent += 20;
        [kHTTPSingle RequestViewpointSummary:0 start:model.viewpointid count:20];
    }
}

-(void)setIdeaTableView {
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0,64,kScreenWidth,kScreenHeight-108) withStyle:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _dataSource = [[XIdeaDataSource alloc] init];
    _dataSource.delegate = self;
    _tableView.dataSource = _dataSource;
    _tableView.delegate = _dataSource;
    [_tableView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
}

#pragma mark - TableView dataSource

- (void)selectIdea:(TQIdeaModel *)model
{
    TQDetailedTableViewController *detaileVc = [[TQDetailedTableViewController alloc] initWithViewId:model.viewpointid];
    [self.navigationController pushViewController:detaileVc animated:YES];
}

@end
