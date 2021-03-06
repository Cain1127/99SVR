//
//  IdeaHomeViewController
//  99SVR
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/**************************************** < 专家观点首页 >**********************************/

#import "IdeaHomeViewController.h"
#import "RoomViewController.h"
#import "PlayIconView.h"
#import "roomhttp.h"
#import "TableViewFactory.h"
#import "TQideaTableViewCell.h"
#import "XIdeaDataSource.h"
#import "MJRefresh.h"
#import "SearchController.h"
#import <AFNetworking/AFNetworking.h>
#import "MJRefresh.h"
#import "TQMailboxViewController.h"
#import "CustomViewController.h"
#import "IdeaDetailedViewController.h"
#import "TQIdeaModel.h"
#import "ViewNullFactory.h"
#import "UIImage+MultiFormat.h"
#import "Toast+UIView.h"
#import "UIViewController+EmpetViewTips.h"

@interface IdeaHomeViewController ()<XIdeaDelegate>
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

@implementation IdeaHomeViewController

static NSString *const ideaCell = @"TQIdeaTableViewIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewPoint:) name:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:nil];
    //切换皮肤的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThemeSkin:) name:MESSAGE_CHANGE_THEMESKIN object:nil];

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
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.tabBarController.tabBar setHidden:NO];
    });
    
    
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
    [self setRequestUserDefaults];
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
    [self setRequestUserDefaults];
    if (_dataSource.aryModel.count>0)
    {
        TQIdeaModel *model = _dataSource.aryModel[_dataSource.aryModel.count-1];
        _nCurrent += 20;
        [kHTTPSingle RequestViewpointSummary:0 start:model.viewpointid count:20];
    }
}

#pragma mark 专家观点的请求 为了和房间内的专家观点的区别
-(void)setRequestUserDefaults{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC forKey:@"ViewpointSummaryListener"];
    [user synchronize];
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

-(void)tqIdeaModelSelectIndexPath:(NSIndexPath *)indexPath withModel:(TQIdeaModel *)model{

    IdeaDetailedViewController *detaileVc = [[IdeaDetailedViewController alloc] initWithViewId:model.viewpointid];
    @WeakObj(_tableView)
    __block TQIdeaModel *weaeModel = model;
    detaileVc.refreshCellDataBlock = ^(BOOL replyValue,BOOL giftValue){
        if (replyValue) {
            weaeModel.replycount +=1;
        }
        if (giftValue) {
            weaeModel.giftcount  +=1;
        }
        [_tableViewWeak reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:detaileVc animated:YES];
}

#pragma mark 皮肤切换
-(void)changeThemeSkin:(NSNotification *)notfication{
    DLog(@"切换皮肤");
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}


@end
