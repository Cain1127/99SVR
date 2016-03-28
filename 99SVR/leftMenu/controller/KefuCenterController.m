//
//  KefuCenterController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "KefuCenterController.h"
#import "RoomGroup.h"
#import "UserInfo.h"
#import "GroupListRequest.h"
#import "RoomHttp.h"

@interface KefuCenterController()

@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) GroupListRequest *listReuqest;

@end

@implementation KefuCenterController

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
    title.text = @"客服中心";
    
    UIButton *btnLeft = [CustomViewController itemWithTarget:self action:@selector(navBack) image:@"back" highImage:@"back"];
    [self.view addSubview:btnLeft];
    [btnLeft setFrame:Rect(0,20,44,44)];
    self.navigationController.navigationBar.barTintColor = kNavColor;
    self.tableView.frame = Rect(0, 0+kNavigationHeight, kScreenWidth, kScreenHeight);
    
    _listReuqest = [[GroupListRequest alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserInfo sharedUserInfo].aryHelp)
    {
        [self setVideos:[UserInfo sharedUserInfo].aryHelp];
        [self reloadData];
    }
}

- (void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark get history
- (void)loadData
{
    __weak KefuCenterController *__self = self;
    self.listReuqest.groupBlock = ^(int status,NSArray *aryIndex)
    {
        for (RoomGroup *group in aryIndex)
        {
            if ([group.groupId isEqualToString:@"16"]) {
                [__self.datas addObject:group];
                break;
            }
        }
        [__self setVideos:__self.datas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self reloadData];
        });
    };
    [self.listReuqest requestListRequest];
}

@end
