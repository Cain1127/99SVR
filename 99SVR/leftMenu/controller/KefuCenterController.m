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
    _datas = [NSMutableArray array];
    _listReuqest = [[GroupListRequest alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark get history
- (void)loadData
{
    NSDictionary *parameter = [UserDefaults objectForKey:kVideoList];
    NSArray *aryRoom = [self resolveDict:parameter];
    if(_datas.count>0){[_datas removeAllObjects];}
    for(RoomGroup *group in aryRoom)
    {
        if ([group.groupId isEqualToString:@"16"]) {
            [_datas addObject:group];
            break;
        }
    }
    [self setVideos:_datas];
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak reloadData];
    });
}

- (NSArray *)resolveDict:(NSDictionary *)dict
{
    NSArray *firstArray = [dict objectForKey:@"groups"];
    NSMutableArray *aryRoom = [NSMutableArray array];
    if ([firstArray isKindOfClass:[NSArray class]] && firstArray.count>0)
    {
        for (NSDictionary *group in firstArray)
        {
            RoomGroup *_roomgroup = [RoomGroup resultWithDict:group];
            [aryRoom addObject:_roomgroup];
        }
    }
    NSDictionary *dictService = [dict objectForKey:@"service"];
    if ([dictService objectForKey:@"groupId"] && [dictService objectForKey:@"groupName"] && [dictService objectForKey:@"roomList"])
    {
        RoomGroup *_roomgroup = [RoomGroup resultWithDict:dictService];
        [aryRoom addObject:_roomgroup];
    }
    NSDictionary *dictOther = [dict objectForKey:@"other"];
    if ([dictOther objectForKey:@"groupId"] && [dictOther objectForKey:@"groupName"] && [dictOther objectForKey:@"roomList"])
    {
        RoomGroup *_roomgroup = [RoomGroup resultWithDict:dictOther];
        [aryRoom addObject:_roomgroup];
    }
    return aryRoom;
}

@end
