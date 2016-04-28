//
//  IndexViewController.m
//  FreeCar
//
//  Created by xiongchi on 15/8/5.
//  Copyright (c) 2015年 xiongchi. All rights reserved.
//

#import "IndexViewController.h"
#import "GroupListRequest.h"
#import "TQMailboxViewController.h"
#import "MJRefresh.h"
#import "Toast+UIView.h"
#import "UserInfo.h"
#import "RoomListRequest.h"
#import "RoomGroup.h"
#import "HotViewController.h"
#import "MainViewController.h"
#import "GiftRequest.h"
#import "GroupView.h"
#import "SearchController.h"
#import "MyScrollView.h"

@interface IndexViewController ()<UIScrollViewDelegate,GroupDelegate>
{
    UISwipeGestureRecognizer *gesture;
    int _tag;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    int updateCount;
    int _currentPage;
    CGFloat scalef;
    GiftRequest *_giftRequest;
}

@property (nonatomic,strong) MyScrollView *scrollView;
@property (nonatomic,strong) GroupView *group;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) GroupListRequest *grouRequest;
@property (nonatomic,strong) RoomListRequest *listReuqest;
@property (nonatomic,strong) NSMutableArray *aryHot;
@property (nonatomic,strong) NSMutableArray *aryOnline;
@property (nonatomic,strong) NSMutableArray *aryHistory;
@property (nonatomic,strong) UIView *sonView;

@end

@implementation IndexViewController

//所有房间组数据
- (void)initData
{
    __weak IndexViewController *__self = self;
    [_aryHot removeAllObjects];
    [_aryOnline removeAllObjects];
    _grouRequest.groupBlock = ^(int status,NSArray *aryIndex)
    {
        if (status==1)
        {
            if (aryIndex.count>0)
            {
                [UserInfo sharedUserInfo].aryRoom = aryIndex;
            }
            int i=0;
            for (RoomGroup *group in aryIndex)
            {
                DLog(@"groupid:%@",group.groupId);
                if(i==0){
                    [__self.aryHot addObject:group];
                }
                else if([group.groupId isEqualToString:@"18"] ||[group.groupId isEqualToString:@"200"]){
                    
                }
                else if([group.groupId isEqualToString:@"16"]){
                    if ([UserInfo sharedUserInfo].aryHelp==nil){
                        [UserInfo sharedUserInfo].aryHelp = [[NSArray alloc] initWithObjects:group, nil];
                    }
                }
                else{
                    [__self.aryOnline addObject:group];
                }
                i++;
            }
            for (UIViewController *viewController in __self.childViewControllers)
            {
                if([viewController class]==[HotViewController class]){
                    [__self setUpdate:__self.aryHot obj:viewController];
                    continue;
                }
                if([viewController class] == [MainViewController class]){
                    [__self setUpdate:__self.aryOnline obj:viewController];
                    continue;
                }
            }
        }
        else
        {
            //重新加载load
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0),
            ^{
                [__self reConnect];
            });
        }
    };
    [_grouRequest requestListRequest];
}

#pragma mark 重新加载
- (void)reConnect
{
    for (UIViewController *viewController in self.childViewControllers)
    {
        if([viewController class]==[HotViewController class])
        {
            [self setUpdate:self.aryHot obj:viewController];
            continue;
        }
        if([viewController class] == [MainViewController class])
        {
            [self setUpdate:self.aryOnline obj:viewController];
            continue;
        }
    }
    __weak IndexViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.view makeToast:@"获取房间数据超时,重新房间数据"];
    });
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [__self initData];
    });
}

#pragma mark get history
- (void)initHistoryData
{
    
    if([UserInfo sharedUserInfo].aryCollet==nil)
    {
        [UserInfo sharedUserInfo].aryCollet = [NSMutableArray array];
    }
    
    [[UserInfo sharedUserInfo].aryCollet removeAllObjects];
    __weak IndexViewController *__self = self;
    _listReuqest.historyBlock = ^(int status,NSArray *aryHistory,NSArray *aryColl)
    {
        if (aryHistory && aryHistory.count>0)
        {
            RoomGroup *group = [aryHistory objectAtIndex:0];
            if (__self.aryHistory.count==0)
            {
                [__self.aryHistory addObject:group];
            }
            else
            {
                [__self.aryHistory removeObjectAtIndex:0];
                [__self.aryHistory addObject:group];
            }
        }
        
        if (aryColl && aryColl.count > 0)
        {
            [[UserInfo sharedUserInfo].aryCollet addObject:[aryColl objectAtIndex:0]];
        }
    };
    DLog(@"userid:%d",[UserInfo sharedUserInfo].nUserId);
    [_listReuqest requestRoomByUserId:[UserInfo sharedUserInfo].nUserId];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self setTitleText:@"99乐投"];
    
    updateCount = 0;
    _currentPage = 0;
    [self initUIHead];
    
    _grouRequest = [[GroupListRequest alloc] init];
    _listReuqest = [[RoomListRequest alloc] init];
    
    _aryHistory = [NSMutableArray array];
    _aryHot = [NSMutableArray array];
    _aryOnline = [NSMutableArray array];
    __weak IndexViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [__self initData];
        [__self initHistoryData];
    });
    UIButton *btnSender = [_group viewWithTag:1];
    [self btnEvent:btnSender];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:MESSAGE_INDEX_GET_GROUPLIST_VC object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToHistory) name:MESSAGE_SWITCH_RIGHT_TAB object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initHistoryData) name:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)refreshUI
{
    __weak IndexViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
       [__self initHistoryData];
    });
}

- (void)searchClick
{
    SearchController *search = [[SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)initUIHead
{
    NSArray *aryMen = @[@"热点时评",@"财经在线"];
    _group = [[GroupView alloc] initWithFrame:Rect(0, 64, kScreenWidth, 44) ary:aryMen];
    [self.view addSubview:_group];
    _group.delegate = self;
    _scrollView = [[MyScrollView alloc] initWithFrame:Rect(0,_group.y+_group.height, kScreenWidth, kScreenHeight-152)];
    [self.view addSubview:_scrollView];
    
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.delegate = self;
    
    HotViewController *hotController = [[HotViewController alloc] init];
    MainViewController *mainView = [[MainViewController alloc] init];
//    HistoryViewController *historyView = [[HistoryViewController alloc] init];
    
    [self addChildViewController:hotController];
//    [self addChildViewController:historyView];
    [self addChildViewController:mainView];
    
    hotController.view.frame = Rect(0, 0, kScreenWidth,_scrollView.height);
    mainView.view.frame = Rect(kScreenWidth, 0, kScreenWidth, _scrollView.height);
//    historyView.view.frame = Rect(kScreenWidth*2, 0, kScreenWidth, _scrollView.height);
    
    [_scrollView addSubview:hotController.view];
    [_scrollView addSubview:mainView.view];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, _scrollView.height);
    
    _tag = 1;
}

- (void)clickIndex:(UIButton *)btn tag:(NSInteger)tag
{
    [self btnEvent:btn];
}

- (void)btnEvent:(id)sender
{
    UIButton *btnSender = sender;
    if(_tag == btnSender.tag)
    {
        return ;
    }
    int tag = (int)btnSender.tag;
    [_group setBtnSelect:tag];
    [_scrollView setContentOffset:CGPointMake((tag-1)*kScreenWidth, 0)];
    _tag = (int)btnSender.tag;
    
}

- (void)switchController:(int)tag
{
    for (UIView *view in _sonView.subviews)
    {
        [view removeFromSuperview];
    }
    
    for (UIViewController *viewController in self.childViewControllers)
    {
        if(tag==1 && [viewController class] == [HotViewController class])
        {
            [_sonView addSubview:viewController.view];
        }
        if(tag==2 && [viewController class] == [MainViewController class])
        {
            [_sonView addSubview:viewController.view];
        }
    }
}


- (void)setUpdate:(NSArray *)array obj:(id)object
{
    FinanceOnlineVedioController *finan = object;
    [finan setVideos:array];
    [finan reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)leftSwitch
{
    if (_tag > 1)
    {
        UIButton *btnSender = [_group viewWithTag:_tag - 1];
        [self btnEvent:btnSender];
    }
}

- (void)rightSwitch
{
    if (_tag < 2)
    {
        UIButton *btnSender = [_group viewWithTag:_tag + 1];
        [self btnEvent:btnSender];
    }
}

- (BOOL)isHot
{
    if(_tag == 1)
    {
        DLog(@"hotController");
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    
}

- (void)enterBack
{}

#pragma mark 重力感应设置
-(BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_group setBluePointX:scrollView.contentOffset.x];
    int temp = floor((scrollView.contentOffset.x - kScreenWidth/2.0)/kScreenWidth +1);//判断是否翻页
    if (temp != _currentPage)
    {
        if (temp > _currentPage)
        {
            if (_tag <= 1)
            {
                _tag++;
                [_group setBtnSelect:_tag];
            }
        }
        else
        {
            if (_tag > 1)
            {
                _tag--;
                [_group setBtnSelect:_tag];
            }
        }
        updateCount++;
        _currentPage = temp;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (updateCount == 1)//正常
    {
        
    }
    else if(updateCount == 0 && _currentPage == 0)
    {
        if (_tag == 1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SHOW_LEFT_VC object:nil];
        }
    }
    else//加速
    {}
    updateCount = 0;
}

- (void)panGestureCallback:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture translationInView:self.view];
    scalef = (point.x+scalef);
    if (panGesture.view.frame.origin.x>=0)
    {
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    //手势结束后修正位置
    if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        if (scalef>=100)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SHOW_LEFT_VC object:nil];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
