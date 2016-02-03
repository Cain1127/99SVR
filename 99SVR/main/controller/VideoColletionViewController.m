//
//  MyCollectionController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/22.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "VideoColletionViewController.h"
#import "UserInfo.h"
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
    UIView *_headView = nil;
    _headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = kNavColor;
    
    UILabel *_txtTitle = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [_txtTitle setFont:XCFONT(16)];
    [_headView addSubview:_txtTitle];
    [_txtTitle setTextAlignment:NSTextAlignmentCenter];
    [_txtTitle setTextColor:[UIColor whiteColor]];
    [_txtTitle setText:@"我的收藏"];
    
    UILabel *_lblContent = [[UILabel alloc] initWithFrame:Rect(0, 63.5, kScreenWidth, 0.5)];
    [_lblContent setBackgroundColor:[UIColor whiteColor]];
    [_headView addSubview:_lblContent];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:btnBack];
    btnBack.frame = Rect(0, 20, 44, 44);
    
    _listReuqest = [[RoomListRequest alloc] init];
    
    self.tableView.frame = Rect(0, 64, kScreenWidth, kScreenHeight-64);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initHistoryData) name:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
    [self initHistoryData];
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
