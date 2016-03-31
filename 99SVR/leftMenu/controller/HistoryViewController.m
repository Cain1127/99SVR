//
//  HistoryViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "HistoryViewController.h"
#import "RoomGroup.h"

#import "RoomListRequest.h"

#import "UserInfo.h"

@interface HistoryViewController()
{
    UIView *_noDataView;
}

@property (nonatomic,strong) RoomListRequest *listReuqest;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    /**
     *  @author yangshengmeng, 16-03-31 16:03:34
     *
     *  @brief  添加导航栏，代码是复制[我的收藏]页面
     *
     *  @since  v1.0.0
     */
    UIView *_headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = kNavColor;
    UILabel *title;
    title = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [title setFont:XCFONT(16)];
    [_headView addSubview:title];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor whiteColor]];
    UILabel *_lblContent;
    _lblContent = [[UILabel alloc] initWithFrame:Rect(0, 63.5, kScreenWidth, 0.5)];
    [_lblContent setBackgroundColor:[UIColor whiteColor]];
    [_headView addSubview:_lblContent];
    title.text = @"我的足迹";
    
    UIButton *btnLeft = [CustomViewController itemWithTarget:self action:@selector(navBack) image:@"back" highImage:@"back"];
    [self.view addSubview:btnLeft];
    [btnLeft setFrame:Rect(0,20,44,44)];
    
    ///重置一下列表的位置和大小
    self.tableView.frame = Rect(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight);
    
    [self initHistoryData];
}

- (void)addNoDataView
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, self.view.width, self.view.height - kNavigationHeight)];
    [self.view addSubview:container];
    _noDataView = container;
    
    container.backgroundColor = [UIColor colorWithHex:@"#f3f3f3"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"big_logo"]];
    [container addSubview:logoImageView];
    logoImageView.frame = Rect(kScreenWidth/2-53,container.height/2-142,116.5, 92);
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, logoImageView.y+logoImageView.height+20, self.view.width, 40)];
    [lblName setText:@"暂时没有足迹"];
    [lblName setFont:XCFONT(14)];
    [container addSubview:lblName];
    [lblName setTextColor:[UIColor grayColor]];
    lblName.textAlignment = NSTextAlignmentCenter;
/*
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 30, self.view.width, 40)];
    [lblName setText:@"没有足迹"];
    [lblName setFont:XCFONT(14)];
    [container addSubview:lblName];
    lblName.textAlignment = NSTextAlignmentCenter;
 */
    
//    UIButton *btnRand = [UIButton buttonWithType:UIButtonTypeCustom];
//    [container addSubview:btnRand];
//    [btnRand setTitle:@"随便看看" forState:UIControlStateNormal];
//    btnRand.frame = Rect(30, 80, kScreenWidth-60, 44);
//    [btnRand setTitleColor:kNavColor forState:UIControlStateNormal];
//    [btnRand addTarget:self action:@selector(randEnterRoom) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.videos == nil || self.videos.count == 0)
    {
        _noDataView.hidden = NO;
    }
    else
    {
        _noDataView.hidden = YES;
    }
}

#pragma mark - get history
- (void)initHistoryData
{
    
    ///清空本地原来的数据
    if([UserInfo sharedUserInfo].aryCollet==nil)
    {
        [UserInfo sharedUserInfo].aryCollet = [NSMutableArray array];
    }
    [[UserInfo sharedUserInfo].aryCollet removeAllObjects];
    
    ///判断历史数据是否为空
    if (!_listReuqest)
    {
        
        _listReuqest = [[RoomListRequest alloc] init];
        
    }
    
    @WeakObj(self);
    _listReuqest.historyBlock = ^(int status,NSArray *aryHistory,NSArray *aryColl)
    {
        for (RoomGroup *group in aryHistory)
        {
            [[UserInfo sharedUserInfo].aryCollet addObject:group];
        }
        [selfWeak setVideos:[UserInfo sharedUserInfo].aryCollet];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ///判断是否存在历史数据
            if (0 >= selfWeak.videos.count)
            {
                
                [selfWeak addNoDataView];
                return;
                
            }
            
            [selfWeak reloadData];
            
        });
    };
    
    [_listReuqest requestRoomByUserId:[UserInfo sharedUserInfo].nUserId];
    
}

- (void)reloadData
{
    [super reloadData];
    __weak HistoryViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__self.videos.count > 0)
        {
            RoomGroup *group = [__self.videos objectAtIndex:0];
            if (group.roomList.count > 0)
            {
                [__self setEmptyData:NO];
            }
            else
            {
                [__self setEmptyData:YES];
            }
        }
        else
        {
            [__self setEmptyData:YES];
        }
    });
}

- (void)setEmptyData:(BOOL)emptyData
{
    _emptyData = emptyData;
    if (emptyData)
    {
        _noDataView.hidden = NO;
    } else {
        _noDataView.hidden = YES;
    }
}

- (void)navBack
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
