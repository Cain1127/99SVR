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
#import "ViewNullFactory.h"

#import "XIdeaDataSource.h"

@interface XIdeaViewController ()<UITableViewDataSource,UITableViewDelegate,XIdeaDelegate>
{
    UIView *noView;
    NSCache *viewCache;
}
/** 数据数租 */
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryModel;
@property (nonatomic,strong) RoomHttp *room;
@property (nonatomic) NSInteger nCurrent;
@property (nonatomic,strong) XIdeaDataSource *dataSource;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewPoint:) name:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:nil];
    [self initUi];
    [self setIdeaTableView];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"专家观点";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHex:@"#0062D5"];
    self.navigationItem.titleView = title;
    viewCache = [[NSCache alloc] init];
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.gifHeader beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewPoint:) name:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadViewPoint:(NSNotification *)notify{
    NSDictionary *dict = notify.object;
    if([[dict objectForKey:@"code"] intValue]==1)
    {
        NSArray *aryIndex = [dict objectForKey:@"model"];
        if (_dataSource.aryModel.count>0) {
            NSMutableArray *aryAll = [NSMutableArray array];
            [aryAll addObjectsFromArray:_dataSource.aryModel];
            [aryAll addObject:aryIndex];
            _dataSource.aryModel = aryAll;
            DLog(@"count:%zi",_dataSource.aryModel.count);
        }
        else
        {
            _dataSource.aryModel = aryIndex;
        }
    }
    @WeakObj(self)
    if(_dataSource.aryModel.count==0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            @StrongObj(self)
            [self createView];
        });
    }else
    {
        @WeakObj(noView)
        dispatch_async(dispatch_get_main_queue(), ^{
            if (noViewWeak) {
                [noViewWeak removeFromSuperview];
            }
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        @StrongObj(self)
        if ([self.tableView.header isRefreshing]) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        if (self.nCurrent != self.dataSource.aryModel.count && self.dataSource.aryModel.count!=0)
        {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView reloadData];
    });
}

- (void)createView
{
    if (nil==noView) {
        char cString[255];
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        sprintf(cString, "%s/customized_no_opened.png",path);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        UIImage *image = [UIImage imageWithContentsOfFile:objCString];
        if(image)
        {
            noView = [ViewNullFactory createViewBg:Rect(0,10,kScreenWidth,_tableView.height-10) imgView:image msg:@"没有专家发布观点"];
            [_tableView addSubview:noView];
        }
    }
}

-(void)updateRefresh {
    _nCurrent = 20;
    _dataSource.aryModel = nil;
    [kHTTPSingle RequestViewpointSummary:0 start:0 count:20];
}

- (void)uploadMore
{
    if (_dataSource.aryModel.count>0) {
        TQIdeaModel *model = _dataSource.aryModel[_dataSource.aryModel.count-1];
        [kHTTPSingle RequestViewpointSummary:0 start:model.viewpointid count:20];
    }
}

-(void)setIdeaTableView {
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0,0,kScreenWidth,kScreenHeight-108) withStyle:UITableViewStylePlain];
    [_tableView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    [self.view addSubview:_tableView];
    _dataSource = [[XIdeaDataSource alloc] init];
    _dataSource.delegate = self;
    _tableView.dataSource = _dataSource;
    _tableView.delegate = _dataSource;
    // cell自动计算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
}

- (void)selectIdea:(TQIdeaModel *)model
{
    TQDetailedTableViewController *detaileVc = [[TQDetailedTableViewController alloc] initWithViewId:model.viewpointid];
    [self.navigationController pushViewController:detaileVc animated:YES];
}

@end

