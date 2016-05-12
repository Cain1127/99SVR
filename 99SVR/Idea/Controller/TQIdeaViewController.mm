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
    if(_dataSource.aryModel.count==0)
    {
        [self.tableView.gifHeader beginRefreshing];
    }

    [self setTitleText:@"专家观点"];
    
    viewCache = [[NSCache alloc] init];
    [viewCache setTotalCostLimit:10];
    
    [self setIdeaTableView];
    
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.footer setHidden:YES];
    
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
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**新的专家观点通知*/
- (void)newIdeaNotifi:(NSNotification *)notify{
    
    DLog(@"新的专家观点%@",notify.object);
    
}

- (void)loadViewPoint:(NSNotification *)notify{
    
    NSDictionary *parameters = notify.object;

    DLog(@"--------------------😍-------------😍%@",parameters);
    
//    NSDictionary *parameters = notify.object;
//    @WeakObj(self)
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [selfWeak.tableView hideToastActivity];
//        [selfWeak.tableView.header endRefreshing];
//    });
//    int code = [parameters[@"code"] intValue];
//    NSArray *aryIndex = parameters[@"model"];
//    if (code!=1 && _dataSource.aryModel.count ==0)
//    {
////        [self showErrorViewInView:_tableView withMsg:RequestState_NetworkErrorStr(code) touchHanleBlock:^{
////            Loading_Bird_Show(selfWeak.tableView);
////            [selfWeak.tableView.header beginRefreshing];
////        }];
//    }
//    else if (aryIndex.count==0 && code==1 && _dataSource.aryModel.count ==0 )
//    {
////        [self showEmptyViewInView:_tableView withMsg:RequestState_EmptyStr(code) touchHanleBlock:^{
////            Loading_Bird_Show(selfWeak.tableView);
////            [selfWeak.tableView.header beginRefreshing];
////        }];
//    }
//    else
//    {
//        [self hideEmptyViewInView:_tableView];
//        if (_dataSource.aryModel.count>0)
//        {
//            NSMutableArray *aryAll = [NSMutableArray array];
//            [aryAll addObjectsFromArray:_dataSource.aryModel];
//            for (TQIdeaModel *model in aryIndex) {
//                [aryAll addObject:model];
//            }
//            _dataSource.aryModel = aryAll;
//        }
//        else
//        {
//            _dataSource.aryModel = aryIndex;
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            @StrongObj(self)
//            if ([self.tableView.header isRefreshing]) {
//                [self.tableView.header endRefreshing];
//            }else{
//                [self.tableView.footer endRefreshing];
//            }
//            if (self.nCurrent != self.dataSource.aryModel.count && self.dataSource.aryModel.count!=0)
//            {
//                [self.tableView.footer setHidden:YES];
//            }
//            else
//            {
//                [self.tableView.footer setHidden:NO];
//            }
//            [self.tableView reloadData];
//        });
//    }
}

-(void)updateRefresh
{
    _nCurrent = 20;
    if (_dataSource.aryModel.count==0)
    {
        [self hideEmptyViewInView:_tableView];
        [_tableView makeToastActivity_bird];
    }
    _dataSource.aryModel = nil;
    [kHTTPSingle RequestViewpointSummary:0 start:0 count:20];
}

- (void)uploadMore
{
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
