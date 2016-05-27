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
#import "CustomViewController.h"
#import "IdeaDetailedViewController.h"
#import "TQIdeaModel.h"
#import "RoomHttp.h"
#import "ViewNullFactory.h"

#import "XIdeaDataSource.h"
#import "LHDNewIdeaPromptView.h"//新的观点提示的view

@interface XIdeaViewController ()<XIdeaDelegate,LHDNewIdeaPromptViewDelegate>
{
    UIView *noView;
}
/** 数据数租 */
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryModel;
@property (nonatomic,strong) RoomHttp *room;
@property (nonatomic) NSInteger nCurrent;
@property (nonatomic,strong) XIdeaDataSource *dataSource;
/**下拉刷新需要清空数据！上啦不需要*/
@property (nonatomic , assign) __block MJRefreshState refreshState;
@property (nonatomic , strong) LHDNewIdeaPromptView *ideaPromptView;
@property (nonatomic , assign) BOOL tableTopBool;

@property (nonatomic , strong) __block NSIndexPath *selectIndexPath;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewPoint:) name:MESSAGE_XTRADER_HTTP_VIEWPOINTSUMMARY_VC object:nil];
    //添加更新专家观点的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newIdeaNotifi:) name:MESSAGE_TQIdeaView_NewNotifi_VC object:nil];
}
#pragma mark 专家观点的请求 为了和房间内的专家观点的区别
-(void)setRequestUserDefaults{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:MESSAGE_XTRADER_HTTP_VIEWPOINTSUMMARY_VC forKey:@"ViewpointSummaryListener"];
    [user synchronize];
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

/**新的专家观点*/
- (void)newIdeaNotifi:(NSNotification *)notify{

    dispatch_async(dispatch_get_main_queue(), ^{
        TQIdeaModel *ideaModel = [notify.object valueForKey:@"data"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSource.aryModel];
        [array insertObject:ideaModel atIndex:0];
        self.dataSource.aryModel = array;
        if (self.tableTopBool) {
            self.ideaPromptView.isShow = YES;
        }else{
            if (noView) {
                [noView removeFromSuperview];
                self.tableView.footer.hidden = YES;
            }
            self.ideaPromptView.isShow = NO;
            [self.tableView reloadData];
        }
    });
}


- (void)loadViewPoint:(NSNotification *)notify{
    NSDictionary *dict = notify.object;
    dispatch_async(dispatch_get_main_queue(), ^{

    if([[dict objectForKey:@"code"] intValue]==1)
    {
        
        if (self.refreshState == MJRefreshState_Header) {
            _dataSource.aryModel = @[];
        }
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
    if(_dataSource.aryModel.count==0)
    {
        [self createView];
    }else
    {
            if (noView) {
                [noView removeFromSuperview];
                noView=nil;
            }
    }
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        if (self.nCurrent != self.dataSource.aryModel.count && self.dataSource.aryModel.count!=0)
        {
            [self.tableView.footer setHidden:YES];
        }else
        {
            [self.tableView.footer setHidden:NO];
        }
        
        if (self.dataSource.aryModel.count==0) {
            [self.tableView.footer setHidden:YES];

        }
        
        [self.tableView reloadData];
    });
}

- (void)createView
{
    
    if (noView) {
        [noView removeFromSuperview];
        noView=nil;
    }

    
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
    self.refreshState = MJRefreshState_Header;
    [self setRequestUserDefaults];
    [kHTTPSingle RequestViewpointSummary:[_room.teamid intValue] start:0 count:20];
}

- (void)uploadMore
{
    self.refreshState = MJRefreshState_Footer;
    [self setRequestUserDefaults];
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
    
    self.ideaPromptView = [[LHDNewIdeaPromptView alloc]init];
    self.ideaPromptView.delegate = self;
    [self addSubview:self.ideaPromptView];
}

#pragma mark - TableView dataSource
-(void)tqIdeaModelSelectIndexPath:(NSIndexPath *)indexPath withModel:(TQIdeaModel *)model{
    IdeaDetailedViewController *detaileVc = [[IdeaDetailedViewController alloc] initWithViewId:model.viewpointid];
    @WeakObj(_tableView)
    __block TQIdeaModel *weaeModel = model;
    detaileVc.refreshCellDataBlock = ^(BOOL replyValue,BOOL giftValue){
        if (replyValue)
        {
            weaeModel.replycount +=1;
        }
        if (giftValue)
        {
            weaeModel.giftcount  +=1;
        }
        [_tableViewWeak reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [[self viewController].navigationController pushViewController:detaileVc animated:YES];

}


-(void)ideaPromptViewIsShowBool:(BOOL)value tabToTopValue:(BOOL)topValue{
    
    self.tableTopBool = value;

    if (topValue) {
        self.ideaPromptView.isShow = NO;
    }
    
}

#pragma mark LHDNewIdeaPromptViewDelegate
-(void)clickInViewHanle{
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.tableView reloadData];
    self.ideaPromptView.isShow = NO;
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
