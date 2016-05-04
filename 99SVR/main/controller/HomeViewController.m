//
//  HomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HomeViewController.h"
#import "ZLTabBar.h"
#import "TQIdeaModel.h"
#import "TQideaTableViewCell.h"
#import "StockMacro.h"
#import "StockHomeCell.h"
#import "UIButton+WebCache.h"
#import "ConnectRoomViewModel.h"
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
#import "IndexViewController.h"
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

#define kPictureHeight 0.3 * kScreenHeight

/**
 *  @brief  当前请求的类型，用来处理请求事件
 */
typedef enum : NSUInteger
{
    
    cCJHomeRequestTypeDefault = 1,  //!<默认状态
    cCJHomeRequestTypeRequesting,   //!<正在请求，同时所有请求都没有完成
    cCJHomeRequestTypeBannerFinish, //!<banner信息请求完成
    cCJHomeRequestTypeListFinish,   //!<列表信息请求完成
    cCJHomeRequestTypeRequestFail   //!<请求失败或者中途断开
    
} CJHomeRequestType;

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,PlayIconDelegate>
{
    NSCache *viewCache;
}
@property (nonatomic,strong) NSArray *aryBanner;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *aryLiving;
@property (nonatomic,strong) SDCycleScrollView *scrollView;

///当前数据请求状态:0-未开始请求/1-正在请求/2-banner完成请求/3-列表完成请求
@property (nonatomic, assign) CJHomeRequestType refreshStatus;
@property (nonatomic,strong) ConnectRoomViewModel *roomViewModel;
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
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kPictureHeight) delegate:self placeholderImage:nil];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _scrollView.currentPageDotColor = UIColorFromRGB(0x4c4c4c); // 自定义分页控件小圆标颜色
    _scrollView.pageDotColor = UIColorFromRGB(0xa8a8a8);
    _scrollView.autoScrollTimeInterval = 5;
    [_scrollView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    @WeakObj(self)
    _scrollView.clickItemOperationBlock = ^(NSInteger index) {
         BannerModel *model = [selfWeak.aryBanner objectAtIndex:index];
         DLog(@"type:%@",model.type);
         if([model.type isEqualToString:@"web"] && model.webUrl!=nil && model.webUrl.length>10){
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
    self.refreshStatus = cCJHomeRequestTypeDefault;
    [self setTitleText:@"首页"];
    viewCache = [[NSCache alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLiveInfo:) name:MESSAGE_HOME_BANNER_VC object:nil];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _aryBanner = [NSMutableArray array];
    [self createScroll];
    [self createPage];
    [self initTableView];
    [self.view makeToastActivity_bird_bird];
    ///添加MJ头部刷新
    [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [_tableView.gifHeader loadDefaultImg];
    [_tableView.gifHeader beginRefreshing];
    
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
        [iconView setRoom:roomView.room];
    }
}

- (void)updateRefresh
{
    self.refreshStatus = cCJHomeRequestTypeRequesting;
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
    
    selfWeak.scrollView.clickItemOperationBlock = ^(NSInteger currentIndex)
    {
        if(selfWeak.aryBanner.count>currentIndex)
        {
            BannerModel *model = selfWeak.aryBanner[currentIndex];
            if (model.webUrl!=nil) {
                NNSVRViewController *svr = [[NNSVRViewController alloc] initWithPath:model.webUrl title:@""];
                [selfWeak.navigationController pushViewController:svr animated:YES];
            }
        }
    };
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
        [self updateRefreshStatus:cCJHomeRequestTypeBannerFinish];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.tableView.header endRefreshing];
        [selfWeak.view hideToastActivity];
    });
    if (!notify.object)
    {
        [self updateRefreshStatus:cCJHomeRequestTypeListFinish];
        return;
    }
    
    if (1 != [notify.object[@"code"] intValue])
    {
        [self updateRefreshStatus:cCJHomeRequestTypeListFinish];
        return;
    }
    
    ///reset data model
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
    NSDictionary *dict = notify.object;
    NSArray *bannerList = dict[@"banner"];
    [self updateBannerInfo:bannerList];
    if ([dict objectForKey:@"video"])
    {
        ///初始化数据模型
        NSArray *roomHttpDictionaryArray = [dict objectForKey:@"video"];
        [self.aryLiving addObject:roomHttpDictionaryArray];
    }
    else
    {
        DLog(@"home list data is not include videoroom data. http API: %@", kHome_LivingList_URL);
    }
    // NSDictionary *dict = @{@"code":@(1),@"video":videoRoom,@"viewpoint":aryViewPoint,@"operate":aryOperate};
    if ([dict objectForKey:@"operate"])
    {
        ///初始化数据模型
        NSArray *operate = [dict objectForKey:@"operate"];
        [self.aryLiving addObject:operate];
    }
    else
    {
        DLog(@"home list data is not include textroom data. http API: %@", kHome_LivingList_URL);
    }
    if ([dict objectForKey:@"viewpoint"])
    {
        ///初始化数据模型
        NSArray *viewPoint = [dict objectForKey:@"viewpoint"];
        [self.aryLiving addObject:viewPoint];
    }
    else
    {
        DLog(@"home list data is not include viewpoint data. http API: %@", kHome_LivingList_URL);
    }
    
    ///主线程刷新UI
    if ([NSThread isMainThread])
    {
        [self updateRefreshStatus:cCJHomeRequestTypeListFinish];
        [self.tableView reloadData];
    }
    else
    {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak updateRefreshStatus:cCJHomeRequestTypeListFinish];
            [selfWeak.tableView reloadData];
        });
    }
}

/**
 *  @author yangshengmeng, 16-03-29 09:03:43
 *
 *  @brief  request home list data
 *
 *  @since  v1.0.0
 */
- (void)initLivingData
{
    [kHTTPSingle RequestHomePage];
}

/**
 *  @author                     yangshengmeng, 16-03-30 09:03:31
 *
 *  @brief                      更新当前的网络请求状态，方便进行请求的处理
 *
 *  @param currentRequestStatus 当前完成的请求类型
 *
 *  @since                      v1.0.0
 */
- (void)updateRefreshStatus:(CJHomeRequestType)currentRequestStatus
{
    if ([NSThread isMainThread])
    {
        switch (self.refreshStatus)
        {
                ///之前处于正在请求状态
            case cCJHomeRequestTypeRequesting:
            {
            
                ///banner 完成请求
                if (cCJHomeRequestTypeBannerFinish == currentRequestStatus)
                {
                    
                    self.refreshStatus = cCJHomeRequestTypeBannerFinish;
                    return;
                    
                }
                ///列表完成请求
                else if (cCJHomeRequestTypeListFinish == currentRequestStatus)
                {
                    
                    self.refreshStatus = cCJHomeRequestTypeListFinish;
                    return;
                    
                }
            
            }
                break;
                
                ///之前已完成banner请求
            case cCJHomeRequestTypeBannerFinish:
            {
            
                ///列表完成请求
                if (cCJHomeRequestTypeListFinish == currentRequestStatus)
                {
                    
                    ///完成头部刷新动画
                    [self.tableView.gifHeader endRefreshing];
                    self.refreshStatus = cCJHomeRequestTypeDefault;
                    return;
                    
                }
            
            }
                break;
                
                ///之前已完成list请求
            case cCJHomeRequestTypeListFinish:
            {
                ///banner 完成请求
                if (cCJHomeRequestTypeBannerFinish == currentRequestStatus)
                {
                    ///完成头部刷新动画
                    [self.tableView.gifHeader endRefreshing];
                    self.refreshStatus = cCJHomeRequestTypeDefault;
                    return;
                }
            }
            break;
            ///当前处于默认状态，无请求
            case cCJHomeRequestTypeDefault:
            case cCJHomeRequestTypeRequestFail:
            default:
            {
            
                ///完成头部刷新动画
                [self.tableView.header endRefreshing];
                self.refreshStatus = cCJHomeRequestTypeDefault;
            
            }
                break;
        }
        
    }
    else
    {
    
        @WeakObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak updateRefreshStatus:currentRequestStatus];
        });
    }
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
            [cell setCellStockModel:model];
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
            if (![strInfo isEqualToString:model.content]) {
                [cell setIdeaModel:model line:YES];
            }
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
            _videoView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 44)];
            [_videoView setBackgroundColor:UIColorFromRGB(0xffffff)];
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f, rightButtonWidth, 44)];
            [lblHot setText:@"财经直播"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x0078DD)];
            lblHot.textAlignment = NSTextAlignmentLeft;
            [_videoView addSubview:lblHot];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [button setFrame:Rect(kScreenWidth-44, 0, 44, 44)];
            button.tag = 1;
            [button addTarget:self action:@selector(enterEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_videoView addSubview:button];
            
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
            [lblHot setTextColor:UIColorFromRGB(0x0078DD)];
            [_operatorView addSubview:lblHot];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [button setFrame:Rect(kScreenWidth-44, 0, 44, 44)];
            button.tag = 3;
            [button addTarget:self action:@selector(enterEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_operatorView addSubview:button];
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
            [lblHot setTextColor:UIColorFromRGB(0x0078DD)];
            [_ideaView addSubview:lblHot];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [button setFrame:Rect(kScreenWidth-44, 0, 44, 44)];
            button.tag = 2;
            [button addTarget:self action:@selector(enterEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_ideaView addSubview:button];
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
    return 44.0f;
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
    [self.view makeToastActivity_bird];
    if (_roomViewModel==nil) {
        _roomViewModel = [[ConnectRoomViewModel alloc] initWithViewController:self];
    }
    [_roomViewModel connectViewModel:room];
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
