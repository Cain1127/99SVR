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

@interface XIdeaViewController ()<XIdeaDelegate>
{
    UIView *noView;
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

- (id)initWithFrame:(CGRect)frame model:(RoomHttp *)room
{
    self = [super initWithFrame:frame];
    _room = room;
    [self addNotify];
    [self initBody];
    return self;
}

- (void)setModel:(RoomHttp *)room
{
    _room = room;
    [self addNotify];
    [self.tableView.gifHeader beginRefreshing];
    
}

- (void)addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewPoint:) name:MESSAGE_HTTP_VIEWPOINTSUMMARY_VC object:nil];
}

- (void)removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initBody
{
    self.backgroundColor = [UIColor whiteColor];
    [self setIdeaTableView];
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    [self.tableView.gifHeader loadDefaultImg];
    _nCurrent = 0;
    [self.tableView.gifHeader beginRefreshing];
}

- (void)loadViewPoint:(NSNotification *)notify{
    NSDictionary *dict = notify.object;
    if([[dict objectForKey:@"code"] intValue]==1)
    {
        NSArray *aryIndex = [dict objectForKey:@"model"];
        if (_dataSource.aryModel.count>0) {
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
            [self.tableView.footer setHidden:YES];
        }else
        {
            [self.tableView.footer setHidden:NO];
        }
        [self.tableView reloadData];
    });
}

- (void)createView
{
    if (nil==noView)
    {
        char cString[255];
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        sprintf(cString, "%s/network_anomaly_fail.png",path);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        UIImage *image = [UIImage imageWithContentsOfFile:objCString];
        if(image)
        {
            noView = [ViewNullFactory createViewBg:Rect(0,0,kScreenWidth,_tableView.height) imgView:image msg:@"没有专家发布观点"];
            [noView setUserInteractionEnabled:NO];
            [_tableView addSubview:noView];
        }
    }
}

-(void)updateRefresh
{
    _nCurrent = 20;
    _dataSource.aryModel = nil;
    [kHTTPSingle RequestViewpointSummary:[_room.teamid intValue] start:0 count:20];
}

- (void)uploadMore
{
    if (_dataSource.aryModel.count>0) {
        TQIdeaModel *model = _dataSource.aryModel[_dataSource.aryModel.count-1];
        _nCurrent += 20;
        [kHTTPSingle RequestViewpointSummary:[_room.teamid intValue] start:model.viewpointid count:20];
    }
}

-(void)setIdeaTableView
{
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0,0,kScreenWidth,self.height) withStyle:UITableViewStyleGrouped];
    [self addSubview:_tableView];
    _dataSource = [[XIdeaDataSource alloc] init];
    _dataSource.delegate = self;
    _tableView.dataSource = _dataSource;
    _tableView.delegate = _dataSource;
}

#pragma mark - TableView dataSource

- (void)selectIdea:(TQIdeaModel *)model
{
    TQDetailedTableViewController *detaileVc = [[TQDetailedTableViewController alloc] initWithViewId:model.viewpointid];
    [[self viewController].navigationController pushViewController:detaileVc animated:YES];
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
