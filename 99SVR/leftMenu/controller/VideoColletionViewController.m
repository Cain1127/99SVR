//
//  MyCollectionController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/22.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "VideoColletionViewController.h"
#import "UserInfo.h"
#import "CustomViewController.h"
#import "RoomListRequest.h"
#import "RoomGroup.h"

@interface VideoColletionViewController()
{
//    UIView *headView;
}

@property (nonatomic,strong) RoomListRequest *listReuqest;

@end

@implementation VideoColletionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    title.text = @"我的收藏";
    
    UIButton *btnLeft = [CustomViewController itemWithTarget:self action:@selector(navBack) image:@"back" highImage:@"back"];
    [self.view addSubview:btnLeft];
    [btnLeft setFrame:Rect(0,20,44,44)];
    _listReuqest = [[RoomListRequest alloc] init];
    self.tableView.frame = Rect(0, kNavigationHeight, kScreenWidth, kScreenHeight);
}

- (void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initHistoryData];
}

#pragma mark get history
- (void)initHistoryData
{
    if([UserInfo sharedUserInfo].aryCollet==nil)
    {
        [UserInfo sharedUserInfo].aryCollet = [NSMutableArray array];
    }
    [[UserInfo sharedUserInfo].aryCollet removeAllObjects];
    __weak VideoColletionViewController *__self = self;
    _listReuqest.historyBlock = ^(int status,NSArray *aryHistory,NSArray *aryColl)
    {
        for (RoomGroup *group in aryColl)
        {
            [[UserInfo sharedUserInfo].aryCollet addObject:group];
        }
        [__self setVideos:[UserInfo sharedUserInfo].aryCollet];
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self reloadData];
        });
    };
    [_listReuqest requestRoomByUserId:[UserInfo sharedUserInfo].nUserId];
}



@end
