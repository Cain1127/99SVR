//
//  HomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HomeViewController.h"
#import "ZLTabBar.h"
#import "ZLRoomVideoViewController.h"
#import "UIViewController+EmpetViewTips.h"
#import "TQDetailedTableViewController.h"
#import "TQIdeaModel.h"
#import "TQideaTableViewCell.h"
#import "StockMacro.h"
#import "StockHomeCell.h"
#import "UIButton+WebCache.h"
#import "RoomViewController.h"
#import "ZLOperateStock.h"
#import "AlertFactory.h"
#import "Toast+UIView.h"
#import "DecodeJson.h"
#import "NNSVRViewController.h"
#import "NavigationViewController.h"
#import "NSJSONSerialization+RemovingNulls.h"
#import "TQMailboxViewController.h"
#import "UIImageFactory.h"
#import "BaseService.h"
#import "BannerModel.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "SearchController.h"
#import "VideoCell.h"
#import "RoomHttp.h"
#import "RoomViewController.h"
#import "RightImageButton.h"
#import "MJRefresh.h"
#import "PlayIconView.h"
#import "StockDealViewController.h"
#import "StockDealModel.h"
#import "UIAlertView+Block.h"
#define kPictureHeight kScreenWidth * (0.43)

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
    NSCache *viewCache;
}
@property (nonatomic,strong) NSArray *aryBanner;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *aryLiving;
@property (nonatomic,strong) SDCycleScrollView *scrollView;

///当前数据请求状态:0-未开始请求/1-正在请求/2-banner完成请求/3-列表完成请求
@property (nonatomic,strong) UIView *videoView;
@property (nonatomic,strong) UIView *ideaView;
@property (nonatomic,strong) UIView *operatorView;
@property (nonatomic,strong) UIButton *btnPlay;

@end

@implementation HomeViewController

#pragma mark -
#pragma mark - init default used UI
- (void)createScroll
{
    if (_scrollView)
    {
        return ;
    }
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kPictureHeight) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner_default_img"]];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _scrollView.pageDotColor = UIColorFromRGB(0x4c4c4c); // 自定义分页控件小圆标颜色
    _scrollView.currentPageDotColor = UIColorFromRGB(0xa8a8a8);
    _scrollView.autoScrollTimeInterval = 5;
    [_scrollView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    @WeakObj(self)
    _scrollView.clickItemOperationBlock = ^(NSInteger index) {
         BannerModel *model = [selfWeak.aryBanner objectAtIndex:index];
         if(model.webUrl!=nil && model.webUrl.length>0 && KUserSingleton.nStatus)
         {
             NNSVRViewController *svrView = [[NNSVRViewController alloc] initWithPath:model.webUrl title:model.title];
             [selfWeak.navigationController pushViewController:svrView animated:YES];
         }
    };
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0.0f, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight-44) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    _tableView.tableHeaderView = _scrollView;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)createPage
{
    
}

- (void)initUIBody
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self setTitleText:@"首页"];
    viewCache = [[NSCache alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLiveInfo:) name:MESSAGE_HOME_BANNER_VC object:nil];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _aryBanner = [NSMutableArray array];
    [self createScroll];
    [self createPage];
    [self initTableView];
    ///添加MJ头部刷新
    [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [_tableView.gifHeader loadDefaultImg];
    [_tableView.gifHeader beginRefreshing];
    [_tableView makeToastActivity_bird];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if (roomView.room)
    {
        PlayIconView *iconView = [PlayIconView sharedPlayIconView];
        iconView.frame = Rect(0, kScreenHeight-104, kScreenWidth, 60);
        [self.view addSubview:iconView];
        [roomView removeNotice];
        [iconView setRoom:roomView.room];
    }
}

- (void)updateRefresh
{
    [self initData];
    [self initLivingData];
}

#pragma mark -
#pragma mark - Inner function : Load image for image view and show leftView
- (void)loadImageView
{
    @WeakObj(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          selfWeak.scrollView.imageURLStringsGroup = selfWeak.aryBanner;
    });
}

- (void)showLeftView
{
    TQMailboxViewController *mailbox = [[TQMailboxViewController alloc] init];
    [self.navigationController pushViewController:mailbox animated:YES];
}

- (void)updateBannerInfo:(NSArray *)array
{
    _aryBanner = array;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadImageView];
    });
}

#pragma mark -
#pragma mark - home date init request and analyze
- (void)initData
{
    
}

- (void)updateLiveInfo:(NSNotification *)notify
{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [selfWeak.tableView hideToastActivity];
        [selfWeak.tableView.header endRefreshing];
    });
    NSDictionary *parameters = notify.object;
    int code = [parameters[@"code"] intValue];
    NSArray *aryBanner = parameters[@"banner"];
    NSArray *aryVideo = parameters[@"video"];
    NSArray *aryOperator = parameters[@"operate"];
    NSArray *aryViewPoint = parameters[@"viewpoint"];
    if (code!=1 && _aryLiving.count == 0 )
    {
        [self showErrorViewInView:_tableView withMsg:RequestState_NetworkErrorStr(code) touchHanleBlock:^{
            Loading_Bird_Show(selfWeak.tableView);
            [selfWeak.tableView.header beginRefreshing];
        }];
    }
    else if (aryBanner.count==0 && aryVideo.count ==0 && aryOperator.count == 0 && aryViewPoint.count == 0 && code==1 && _aryLiving.count == 0)
    {
        [self showEmptyViewInView:_tableView withMsg:RequestState_EmptyStr(code) touchHanleBlock:^{
                Loading_Bird_Show(selfWeak.tableView);
                [selfWeak.tableView.header beginRefreshing];
        }];
    }
    else
    {
        [self hideEmptyViewInView:_tableView];
        if (aryBanner.count==0 && aryVideo.count ==0 && aryOperator.count == 0 && aryViewPoint.count == 0) {
            return ;
        }
        if (self.aryLiving)
        {
            [self.aryLiving removeAllObjects];
        }
        else
        {
            self.aryLiving = [NSMutableArray array];
        }
        ///清空原数据
        [self.aryLiving removeAllObjects];
        [self updateBannerInfo:aryBanner];
        [self.aryLiving addObject:aryVideo];
        if (KUserSingleton.nStatus)
        {
            [self.aryLiving addObject:aryOperator];
            [self.aryLiving addObject:aryViewPoint];
        }
        dispatch_main_async_safe(
        ^{
            [selfWeak.tableView reloadData];
        });
    }
}

- (void)initLivingData
{
    [kHTTPSingle RequestHomePage];
}

#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryLiving.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section <= _aryLiving.count)
    {
        
        if ([_aryLiving[section] isKindOfClass:[NSArray class]] ||
            [_aryLiving[section] isKindOfClass:[NSMutableArray class]])
        {
            NSArray *tempArray = _aryLiving[section];
            if (0 >= tempArray.count)
            {
                return 0;
            }
            NSObject *tempObject = [tempArray firstObject];
            
            ///文字直接数量
            if ([tempObject isKindOfClass:[RoomHttp class]])
            {
                NSInteger count = (NSInteger)ceilf((1.0f * tempArray.count) / 2.0f);
                return count;
            }
            return tempArray.count;
        }
        NSArray *tempArray = _aryLiving[section];
        return tempArray.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///判断不同的section数据模型，返回不同的view
    if (indexPath.section > _aryLiving.count)
    {
        return [self createDefaultTableViewCell:tableView];
    }
    if (!([_aryLiving[indexPath.section] isKindOfClass:[NSArray class]]))
    {
        return [self createDefaultTableViewCell:tableView];;
    }
    ///根据对象数组内的类型加载HeaderView
    NSArray *tempArray = _aryLiving[indexPath.section];
    if (0 >= tempArray.count)
    {
        return [self createDefaultTableViewCell:tableView];
    }
    if (indexPath.row >= tempArray.count)
    {
        return [self createDefaultTableViewCell:tableView];
    }
    NSObject *tempObject = tempArray[0];
    ///视频直播内容
    if ([tempObject isKindOfClass:[RoomHttp class]])
    {
        static NSString *videoCellName = @"videoCellName";
        VideoCell *tempCell = [_tableView dequeueReusableCellWithIdentifier:videoCellName];
        if(!tempCell)
        {
            tempCell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellName];
        }
        @WeakObj(self);
        tempCell.itemOnClick = ^(RoomHttp *room)
        {
            [selfWeak connectRoom:room];
        };
        int length = 2;
        int loc = (int)indexPath.row * length;
        if (loc + length > tempArray.count)
        {
            length = (int)tempArray.count - loc;
        }
        NSRange range = NSMakeRange(loc, length);
        NSArray *aryIndex = [tempArray subarrayWithRange:range];
        [tempCell setRowDatas:aryIndex isNew:1];
        return tempCell;
    }
    if([tempObject isKindOfClass:[ZLOperateStock class]])
    {
        static NSString * cellId = @"cellId";
        
        StockHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[StockHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        if(tempArray.count>indexPath.row)
        {
            ZLOperateStock *model = tempArray[indexPath.row];
            StockDealModel *stockModel = [[StockDealModel alloc]init];
            stockModel.operateid = [NSString stringWithFormat:@"%d",model.operateid];
            stockModel.teamid = [NSString stringWithFormat:@"%@",model.teamid];
            stockModel.teamname = [NSString stringWithFormat:@"%@",model.teamname];
            stockModel.teamicon = [NSString stringWithFormat:@"%@",model.teamicon];
            stockModel.focus = [NSString stringWithFormat:@"%@",model.focus];
            stockModel.goalprofit = [NSString stringWithFormat:@"%.2f%%",model.goalprofit];
            stockModel.totalprofit = [NSString stringWithFormat:@"%.2f%%",model.totalprofit];
            stockModel.dayprofit = [NSString stringWithFormat:@"%.2f%%",model.dayprofit];
            stockModel.monthprofit = [NSString stringWithFormat:@"%.2f%%",model.monthprofit];
            stockModel.winrate = [NSString stringWithFormat:@"%.2f%%",model.winrate];
            [cell setCellDataWithModel:stockModel withTabBarInteger:1];
            cell.backgroundColor = [UIColor clearColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }
    //精彩视点
    if ([tempObject isKindOfClass:[TQIdeaModel class]])
    {
        static NSString *viewPointCellName = @"TQIdeaTableViewIdentifier";
        TQIdeaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:viewPointCellName];
        NSString *strInfo = cell.content;
        if (!cell)
        {
            cell = [[TQIdeaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:viewPointCellName];
        }
        if (tempArray.count>indexPath.row)
        {
            TQIdeaModel *model = tempArray[indexPath.row];
            [cell setIdeaModel:model line:YES];
        }
        return cell;
    }
    
    return [self createDefaultTableViewCell:tableView];
}

/**
 *  @author yangshengmeng, 16-03-29 13:03:16
 *
 *  @brief  用来生成暂时的系统cell
 *
 *  @return 返回一个无任何内容的系统cell
 *
 *  @since  v1.0.0
 */
- (UITableViewCell *)createDefaultTableViewCell:(UITableView *)tableView
{

    static NSString *defaultCell = @"defaultCellName";
    UITableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    if (tempCell)
    {
        tempCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCell];
    }
    return tempCell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *tempArray = _aryLiving[section];
    if (0 >= tempArray.count)
    {
        return nil;
    }
    NSObject *tempObject = tempArray[0];
    CGFloat rightButtonWidth = 140.0f;
    ///视频直播内容
    if ([tempObject isKindOfClass:[RoomHttp class]])
    {
        if (!_videoView)
        {
            _videoView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 34)];
            [_videoView setBackgroundColor:UIColorFromRGB(0xffffff)];
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f, rightButtonWidth, 44)];
            [lblHot setText:@"财经直播"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x4c4c4c)];
            lblHot.textAlignment = NSTextAlignmentLeft;
            [_videoView addSubview:lblHot];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [button setFrame:Rect(kScreenWidth-44, 0, 44, 44)];
            button.tag = 1;
            [button addTarget:self action:@selector(enterEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_videoView addSubview:button];
            @WeakObj(self)
            [_videoView clickWithBlock:^(UIGestureRecognizer *gesture)
            {
                UIButton *btn = (UIButton *)[selfWeak.videoView viewWithTag:1];
                [selfWeak enterEvent:btn];
            }];
        }
        return _videoView;
        
    }
    ///文字直播内容
    if ([tempObject isKindOfClass:[ZLOperateStock class]])
    {
        if(!_operatorView)
        {
            _operatorView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 44)];
            [_operatorView setBackgroundColor:UIColorFromRGB(0xffffff)];
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f, rightButtonWidth, 44)];
            [lblHot setText:@"高手操盘"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x4c4c4c)];
            [_operatorView addSubview:lblHot];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [button setFrame:Rect(kScreenWidth-44, 0, 44, 44)];
            button.tag = 3;
            [button addTarget:self action:@selector(enterEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_operatorView addSubview:button];
            
            @WeakObj(self)
            [_operatorView clickWithBlock:^(UIGestureRecognizer *gesture)
             {
                 UIButton *btn = (UIButton *)[selfWeak.operatorView viewWithTag:3];
                 [selfWeak enterEvent:btn];
             }];
        }
        return _operatorView;
    }
    
    ///精彩视点
    if ([tempObject isKindOfClass:[TQIdeaModel class]])
    {
        if (!_ideaView) {
            _ideaView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 44)];
            [_ideaView setBackgroundColor:UIColorFromRGB(0xffffff)];
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f,rightButtonWidth,44)];
            [lblHot setText:@"专家观点"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x4c4c4c)];
            [_ideaView addSubview:lblHot];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [button setFrame:Rect(kScreenWidth-44, 0, 44, 44)];
            button.tag = 2;
            [button addTarget:self action:@selector(enterEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_ideaView addSubview:button];
            
            @WeakObj(self)
            [_ideaView clickWithBlock:^(UIGestureRecognizer *gesture)
             {
                 UIButton *btn = (UIButton *)[selfWeak.ideaView viewWithTag:2];
                 [selfWeak enterEvent:btn];
             }];
        }
        return _ideaView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///取消选择状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ///判断不同的section数据模型，返回不同的view
    if (indexPath.section > _aryLiving.count)
    {
        return;
    }
    if (!([_aryLiving[indexPath.section] isKindOfClass:[NSArray class]]))
    {
        return;
    }
    
    ///根据对象数组内的类型加载HeaderView
    NSArray *tempArray = _aryLiving[indexPath.section];
    if (0 >= tempArray.count)
    {
        return;
    }
    NSObject *tempObject = tempArray[0];
    ///精彩观点项点击
    if ([tempObject isKindOfClass:[ZLOperateStock class]])
    {
        ///获取直播数据模型
        if(tempArray.count>indexPath.row)
        {
            ZLOperateStock *stockModel = tempArray[indexPath.row];
            StockDealViewController *Stock = [[StockDealViewController alloc]init];
            StockDealModel *stockDelModel = [[StockDealModel alloc]init];
            stockDelModel.operateid = [NSString stringWithFormat:@"%d",stockModel.operateid];
            stockDelModel.teamname = stockModel.teamname;
            Stock.stockModel = stockDelModel;
            [self.navigationController pushViewController:Stock animated:YES];
        }
    }
    
    if([tempObject isKindOfClass:[TQIdeaModel class]])
    {
        if(tempArray.count>indexPath.row)
        {
            TQIdeaModel *ideaModel = tempArray[indexPath.row];
            TQDetailedTableViewController *viewcontrol = [[TQDetailedTableViewController alloc] initWithViewId:ideaModel.viewpointid];
            [self.navigationController pushViewController:viewcontrol animated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!([_aryLiving[indexPath.section] isKindOfClass:[NSArray class]]))
    {
        return 0.0f;
    }
    NSArray *tempArray = _aryLiving[indexPath.section];
    NSObject *tempObject = tempArray[0];
    if ([tempObject isKindOfClass:[RoomHttp class]])
    {
        CGFloat height = ((kScreenWidth - 36.0f) / 2.0f) * 10 / 16 + 8;
        return height;
    }else if([tempObject isKindOfClass:[ZLOperateStock class]])
    {
        return ValueWithTheIPhoneModelString(@"110,110,110,110");
    }
    return 130.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        
        return 34.0;
    }else{
        
        return 44.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark hotViewDelegate
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)connectRoom:(RoomHttp *)room{
    if (KUserSingleton.nStatus) {
        RoomViewController *roomView = [RoomViewController sharedRoomViewController];
        if ([roomView.room.roomid isEqualToString:room.roomid])
        {
            [roomView addNotify];
            [self.navigationController pushViewController:roomView animated:YES];
            return ;
        }
        [roomView setRoom:room];
        [self.navigationController pushViewController:roomView animated:YES];
    }
    else
    {
        ZLRoomVideoViewController *viewVC = [[ZLRoomVideoViewController alloc] initWithModel:room];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
}

- (void)enterEvent:(UIButton *)sender
{
    UITabBarController *rootTabbarVC = self.tabBarController;
    if (rootTabbarVC)
    {
        rootTabbarVC.selectedIndex = sender.tag;
    }
    
}

@end
