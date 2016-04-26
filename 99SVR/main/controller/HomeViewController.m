//
//  HomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HomeViewController.h"
#import "ZLTabBar.h"
#import "UIButton+WebCache.h"
#import "ConnectRoomViewModel.h"
#import "RoomViewController.h"
#import "AlertFactory.h"
#import "Toast+UIView.h"
#import "DecodeJson.h"
#import "NNSVRViewController.h"
#import "TextCell.h"
#import "NavigationViewController.h"
#import "NSJSONSerialization+RemovingNulls.h"
#import "TQMailboxViewController.h"
#import "UIImageFactory.h"
#import "BaseService.h"
#import "IndexViewController.h"
#import "TeacherModel.h"
#import "BannerModel.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "SearchController.h"
#import "VideoCell.h"
#import "TextRoomModel.h"
#import "HomeTextLivingCell.h"
#import "TextHomeViewController.h"
#import "RoomHttp.h"
#import "VideoLivingCell.h"
#import "RoomViewController.h"
#import "ViewPointCell.h"
#import "WonderfullView.h"
#import "NewDetailsViewController.h"
#import "RightImageButton.h"
#import "MJRefresh.h"
#import "PlayIconView.h"

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

@property (nonatomic,strong) NSMutableArray *aryBanner;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *aryLiving;
@property (nonatomic,strong) SDCycleScrollView *scrollView;

///当前数据请求状态:0-未开始请求/1-正在请求/2-banner完成请求/3-列表完成请求
@property (nonatomic, assign) CJHomeRequestType refreshStatus;
@property (nonatomic,strong) ConnectRoomViewModel *roomViewModel;

@property (nonatomic,strong) PlayIconView *iConView;
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
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kPictureHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _scrollView.currentPageDotColor = UIColorFromRGB(0x4c4c4c); // 自定义分页控件小圆标颜色
    _scrollView.pageDotColor = UIColorFromRGB(0xa8a8a8);
    _scrollView.autoScrollTimeInterval = 2;
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
    _tableView = [[UITableView alloc] initWithFrame:Rect(0.0f, kNavigationHeight, kScreenWidth, kScreenHeight - (10.0f + kNavigationHeight + 5.0f + 50.0f)) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
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
    [self setTitleText:@"99乐投"];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _aryBanner = [NSMutableArray array];
    [self createScroll];
    [self createPage];
    [self initTableView];
    
    ///添加MJ头部刷新
    [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [_tableView.gifHeader loadDefaultImg];
    [_tableView.gifHeader beginRefreshing];
    
    _iConView = [[PlayIconView alloc] initWithFrame:Rect(0, kScreenHeight-108, kScreenWidth, 64)];
    [self.view addSubview:_iConView];
    _iConView.hidden = YES;
    _iConView.delegate = self;
    
    _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_btnPlay];
    _btnPlay.frame = Rect(kScreenWidth-55, kScreenHeight-98, 44, 44);
    [UIImageFactory createBtnImage:@"home_play_icon" btn:_btnPlay state:UIControlStateNormal];
    _btnPlay.hidden=YES;
    [_btnPlay addTarget:self action:@selector(showPlayInfo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showPlayInfo
{
    _btnPlay.hidden = YES;
    _iConView.hidden = NO;
}

- (void)showIconView
{
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    NSString *strUrl=nil;
    if([roomView.room.croompic length]==0)
    {
        strUrl = @"";
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_URL,roomView.room.croompic];
    }
    [_iConView.imgView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    [_iConView.lblName setText:roomView.room.cname];
    [_iConView.lblNumber setText:roomView.room.nvcbid];
    [_iConView.btnQuery setTitle:roomView.room.ncount forState:UIControlStateNormal];
    _iConView.hidden = NO;
}

- (void)exitPlay{
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    [roomView exitRoom];
    _iConView.hidden = YES;
}

- (void)gotoPlay{
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    [self.navigationController pushViewController:roomView animated:YES];
}

- (void)hidenPlay{
    _btnPlay.hidden = NO;
    _iConView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if (roomView.room!=nil) {
        [self showIconView];
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
}

- (void)showLeftView
{
    TQMailboxViewController *mailbox = [[TQMailboxViewController alloc] init];
    [self.navigationController pushViewController:mailbox animated:YES];
}

- (void)updateBannerInfo:(NSDictionary *)dict
{
    NSArray *array = [dict objectForKey:@"banner"];
    if (0 < array.count)
    {
        [_aryBanner removeAllObjects];
    }
    for (NSDictionary *param in array)
    {
        BannerModel *model = [BannerModel resultWithDict:param];
        [self.aryBanner addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateRefreshStatus:cCJHomeRequestTypeBannerFinish];
        [self loadImageView];
    });
}

#pragma mark -
#pragma mark - home date init request and analyze
- (void)initData
{
    NSString *strUrl = [[NSString alloc] initWithUTF8String:kHome_Banner_URL];
    @WeakObj(self);
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        if ([dict objectForKey:@"banner"])
        {
            [UserDefaults setObject:dict forKey:kBannerInfo];
            [selfWeak updateBannerInfo:dict];
        }
    } fail:^(NSError *error) {
        NSDictionary *dict = [UserDefaults objectForKey:kBannerInfo];
        [self updateBannerInfo:dict];
    }];
}

- (void)updateLiveInfo:(NSDictionary *)dict
{
    if (!dict)
    {
        DLog(@"home list data is null. http API: %@", kHome_LivingList_URL);
        [self updateRefreshStatus:cCJHomeRequestTypeListFinish];
        return;
    }
    
    if (0 >= [[dict allKeys] count])
    {
        DLog(@"home list data is empty, don't include any data. http API: %@", kHome_LivingList_URL);
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
    
    ///check videoroom data
    if ([dict objectForKey:@"videoroom"])
    {
        ///初始化数据模型
        NSArray *roomHttpDictionaryArray = [dict objectForKey:@"videoroom"];
        
        NSMutableArray *roomHttpModelArray = [NSMutableArray array];
        for (int i = 0; i < [roomHttpDictionaryArray count]; i++) {
            
            RoomHttp *roomHttpModel = [RoomHttp resultWithDict:roomHttpDictionaryArray[i]];
            [roomHttpModelArray addObject:roomHttpModel];
            
        }
        
        [self.aryLiving addObject:roomHttpModelArray];
    }
    else
    {
        DLog(@"home list data is not include videoroom data. http API: %@", kHome_LivingList_URL);
    }
    
    ///check textroom data
    if ([dict objectForKey:@"textroom"])
    {
        ///初始化数据模型
        NSArray *textRoomModelDictionaryArray = [dict objectForKey:@"textroom"];
        
        NSMutableArray *textRoomModelArray = [NSMutableArray array];
        for (int i = 0; i < [textRoomModelDictionaryArray count]; i++) {
            TextRoomModel *textRoomModel = [TextRoomModel resultWithDict:textRoomModelDictionaryArray[i]];
            [textRoomModelArray addObject:textRoomModel];
        }
        [self.aryLiving addObject:textRoomModelArray];
    }
    else
    {
        DLog(@"home list data is not include textroom data. http API: %@", kHome_LivingList_URL);
    }
    
    if ([dict objectForKey:@"viewpoint"])
    {
        ///初始化数据模型
        NSArray *wonderfullViewModelDictionaryArray = [dict objectForKey:@"viewpoint"];
        
        NSMutableArray *wonderfullViewModelArray = [NSMutableArray array];
        for (int i = 0; i < [wonderfullViewModelDictionaryArray count]; i++) {
            
            WonderfullView *wonderfullViewModel = [WonderfullView resultWithDict:wonderfullViewModelDictionaryArray[i]];
            [wonderfullViewModelArray addObject:wonderfullViewModel];
            
        }
        
        [self.aryLiving addObject:wonderfullViewModelArray];
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
    __weak HomeViewController *__self = self;
    [BaseService postJSONWithUrl:kHome_LivingList_URL parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = nil;;
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             dict = responseObject;
         }
         else{
             dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         }
         [UserDefaults setObject:dict forKey:kLiveInfo];
         [__self updateLiveInfo:dict];
     } fail:^(NSError *error) {
         NSDictionary *dict = [UserDefaults objectForKey:kLiveInfo];
         [__self updateLiveInfo:dict];
         [UserDefaults setObject:dict forKey:kLiveInfo];
         [UserDefaults synchronize];
         int nUserid = [UserInfo sharedUserInfo].nUserId;
         NSString *strMsg =[NSString stringWithFormat:@"ReportItem=GetRoomList&ClientType=3&UserId=%d&ServerIP=58.210.107.53&Error=request_home_fail_%d",
                            nUserid,(int)error.code];
         [DecodeJson postPHPServerMsg:strMsg];
     }];
    
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
    return _aryLiving.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0;
    }
    if (section <= _aryLiving.count)
    {
        
        if ([_aryLiving[section - 1] isKindOfClass:[NSArray class]] ||
            [_aryLiving[section - 1] isKindOfClass:[NSMutableArray class]])
        {
            
            NSArray *tempArray = _aryLiving[section - 1];
            
            if (0 >= tempArray.count)
            {
                
                return 0;
                
            }
            
            NSObject *tempObject = [tempArray firstObject];
            
            ///文字直接数量
            if ([tempObject isKindOfClass:[TextRoomModel class]] ||
                [tempObject isKindOfClass:[RoomHttp class]])
            {
                return (NSInteger)ceilf((1.0f * tempArray.count) / 2.0f);
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
    if (!([_aryLiving[indexPath.section - 1] isKindOfClass:[NSArray class]]))
    {
        return [self createDefaultTableViewCell:tableView];;
    }
    ///根据对象数组内的类型加载HeaderView
    NSArray *tempArray = _aryLiving[indexPath.section - 1];
    if (0 >= tempArray.count)
    {
        return [self createDefaultTableViewCell:tableView];
    }
    
    if (indexPath.row >= tempArray.count)
    {
        return [self createDefaultTableViewCell:tableView];
    }
    NSObject *tempObject = tempArray[indexPath.row];
    
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
//            RoomViewController *roomView = [[RoomViewController alloc] initWithModel:room];
//            [selfWeak.navigationController pushViewController:roomView animated:YES];
            [selfWeak connectRoom:room];
        };
        [tempCell setRowDatas:tempArray];
        return tempCell;
    }
    
    ///文字直播内容
    if ([tempObject isKindOfClass:[TextRoomModel class]])
    {
        static NSString *textCellName = @"textCellName";
        TextCell *tempCell = [_tableView dequeueReusableCellWithIdentifier:textCellName];
        @WeakObj(self);
        if(!tempCell)
        {
            tempCell = [[TextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellName];
        }
        ///左侧view
        tempCell.itemOnClick = ^(TextRoomModel *room)
        {
            TextHomeViewController *roomView = [[TextHomeViewController alloc] initWithModel:room];
            [selfWeak.navigationController pushViewController:roomView animated:YES];
        };
        [tempCell setRowDatas:tempArray];
        return tempCell;
    }
    
    //精彩视点
    if ([tempObject isKindOfClass:[WonderfullView class]])
    {
        static NSString *viewPointCellName = @"viewPointCellName";
        ViewPointCell *tempCell = [_tableView dequeueReusableCellWithIdentifier:viewPointCellName];
        if(!tempCell)
        {
            tempCell = [[ViewPointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:viewPointCellName];
        }
        [tempCell setViewPointModel:(WonderfullView *)tempObject];
        return tempCell;
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
    
    ///banner
    if (0 == section)
    {
        
        return _scrollView;
        
    }

    ///判断不同的section数据模型，返回不同的view
    if (section > _aryLiving.count)
    {
        
        return nil;
        
    }
    
    if (!([_aryLiving[section - 1] isKindOfClass:[NSArray class]]))
    {
        
        return nil;
        
    }
    
    ///根据对象数组内的类型加载HeaderView
    NSArray *tempArray = _aryLiving[section - 1];
    if (0 >= tempArray.count)
    {
        return nil;
    }
    
    NSObject *tempObject = tempArray[0];
    CGFloat tempHeight = 44.0f;
    CGFloat rightButtonWidth = 140.0f;
    ///视频直播内容
    if ([tempObject isKindOfClass:[RoomHttp class]])
    {
        static NSString *vedioHeaderViewName = @"vedioHeaderViewName";
        UIView *tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:vedioHeaderViewName];
        if (!tempHeaderView)
        {
            
            tempHeaderView = [[UIView alloc] initWithFrame:Rect(0.0f, 0.0f, CGRectGetWidth(tableView.frame), tempHeight)];
            
            ///title label
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f, CGRectGetWidth(tempHeaderView.frame) - rightButtonWidth - 30.0f, tempHeight)];
            [lblHot setText:@"视频直播"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x0078DD)];
            lblHot.textAlignment = NSTextAlignmentLeft;
            [tempHeaderView addSubview:lblHot];
            
            ///see all button
            @WeakObj(self);
            RightImageButton *seeAllButton = [[RightImageButton alloc] initWithFrame:Rect(CGRectGetWidth(tempHeaderView.frame) - 15.0f - rightButtonWidth, 0.0f, rightButtonWidth, tempHeight) rightImageWidth:30.0f tapActionBlock:^(UIButton *button) {
                UITabBarController *rootTabbarVC = selfWeak.tabBarController;
                if (rootTabbarVC)
                {
                    rootTabbarVC.selectedIndex = 1;
                }
            }];
            [seeAllButton setTitle:@"查看全部" forState:UIControlStateNormal];
            [seeAllButton setTitleColor:UIColorFromRGB(0x0078DD) forState:UIControlStateNormal];
            seeAllButton.titleLabel.font = XCFONT(12);
            [seeAllButton setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [tempHeaderView addSubview:seeAllButton];
            
        }
        
        return tempHeaderView;
        
    }
    ///文字直播内容
    if ([tempObject isKindOfClass:[TextRoomModel class]])
    {
        static NSString *textHeaderViewName = @"textHeaderViewName";
        UIView *tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:textHeaderViewName];
        if (!tempHeaderView)
        {
            tempHeaderView = [[UIView alloc] initWithFrame:Rect(0.0f, 0.0f,kScreenWidth, tempHeight)];
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f, tempHeaderView.width - rightButtonWidth - 30.0f, tempHeight)];
            [lblHot setText:@"文字直播"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x0078DD)];
            [tempHeaderView addSubview:lblHot];
            ///see all button
            @WeakObj(self);
            RightImageButton *seeAllButton = [[RightImageButton alloc] initWithFrame:Rect(CGRectGetWidth(tempHeaderView.frame) - 15.0f - rightButtonWidth, 0.0f, rightButtonWidth, tempHeight) rightImageWidth:30.0f tapActionBlock:^(UIButton *button) {
                
                UITabBarController *rootTabbarVC = selfWeak.tabBarController;
                if (rootTabbarVC)
                {
                    rootTabbarVC.selectedIndex = 2;
                }
            }];
            [seeAllButton setTitle:@"查看全部" forState:UIControlStateNormal];
            [seeAllButton setTitleColor:UIColorFromRGB(0x0078DD) forState:UIControlStateNormal];
            seeAllButton.titleLabel.font = XCFONT(12);
            [seeAllButton setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [tempHeaderView addSubview:seeAllButton];
        }
        return tempHeaderView;
        
    }
    
    ///精彩视点
    if ([tempObject isKindOfClass:[WonderfullView class]])
    {
        
        static NSString *viewPointHeaderViewName = @"viewPointHeaderViewName";
        UIView *tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewPointHeaderViewName];
        if (!tempHeaderView)
        {
            
            tempHeaderView = [[UIView alloc] initWithFrame:Rect(0.0f, 0.0f, CGRectGetWidth(tableView.frame), tempHeight)];
            
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f, CGRectGetWidth(tempHeaderView.frame) - 30.0f, tempHeight)];
            [lblHot setText:@"精彩观点"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x0078DD)];
            [tempHeaderView addSubview:lblHot];
            
            UILabel *line = [[UILabel alloc] initWithFrame:Rect(0.0f, CGRectGetHeight(tempHeaderView.frame) - 0.5f, kScreenWidth, 0.5f)];
            [line setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
            [tempHeaderView addSubview:line];
            
        }
        
        return tempHeaderView;
        
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///取消选择状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ///判断点击的section
    if (0 == indexPath.section)
    {
        
        return;
        
    }
    
    ///判断不同的section数据模型，返回不同的view
    if (indexPath.section > _aryLiving.count)
    {
        
        return;
        
    }
    
    if (!([_aryLiving[indexPath.section - 1] isKindOfClass:[NSArray class]]))
    {
        
        return;
        
    }
    
    ///根据对象数组内的类型加载HeaderView
    NSArray *tempArray = _aryLiving[indexPath.section - 1];
    if (0 >= tempArray.count)
    {
        
        return;
        
    }
    
    NSObject *tempObject = tempArray[0];
    
    ///精彩观点项点击
    if ([tempObject isKindOfClass:[WonderfullView class]])
    {
        ///获取直播数据模型
        WonderfullView *model = [tempArray objectAtIndex:indexPath.row];
        TextTcpSocket *textSocket = [[TextTcpSocket alloc] init];
        textSocket.roomid = [model.roomid intValue];
        NewDetailsViewController *detailView = [[NewDetailsViewController alloc]
                                                initWithSocket:textSocket viewID:[model.viewid intValue] home:YES];
        [self.navigationController pushViewController:detailView animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //banner height
    if (0 == indexPath.section)
    {
        
        return 0.0f;
        
    }
    
    ///判断不同的section数据模型，返回不同的view
    if (indexPath.section > _aryLiving.count)
    {
        
        return 0.0f;
        
    }
    
    if (!([_aryLiving[indexPath.section - 1] isKindOfClass:[NSArray class]]))
    {
        
        return 0.0f;
        
    }
    
    ///根据对象数组内的类型加载HeaderView
    NSArray *tempArray = _aryLiving[indexPath.section - 1];
    if (0 >= tempArray.count)
    {
        return 0.0f;
    }
    NSObject *tempObject = tempArray[0];
    if ([tempObject isKindOfClass:[RoomHttp class]] ||
        [tempObject isKindOfClass:[TextRoomModel class]])
    {
        CGFloat height = ((kScreenWidth - 36.0f) / 2.0f) * 10 / 16 + 8;
        return height;
    }
    
    ///精彩观点的cell高度
    return 100.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    //banner height
    if (0 == section)
    {
        return kPictureHeight;
    }
    return 44.0f;

}

#pragma mark hotViewDelegate
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)connectRoom:(RoomHttp *)room{
    [self.view makeToastActivity];
    if (_roomViewModel==nil) {
        _roomViewModel = [[ConnectRoomViewModel alloc] initWithViewController:self];
    }
    [_roomViewModel connectViewModel:room];
}

@end
