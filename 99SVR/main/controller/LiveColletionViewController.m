//
//  MyCollectionController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/22.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "MyCollectionController.h"
#import "UserInfo.h"
#import "RoomListRequest.h"
#import "RoomGroup.h"

@interface LiveColletionViewController()
{
    UIView  *headView;
}

@property (nonatomic,strong) NSMutableArray *aryHistory;
@property (nonatomic,strong) RoomListRequest *listReuqest;

@end

@implementation LiveColletionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addHeaderView:@"我的收藏"];
    self.aryHistory = [NSMutableArray array];
    self.listReuqest = [[RoomListRequest alloc] init];
    [self initHistoryData];
}

- (void)addHeaderView
{
    headView = [[UIView alloc] initWithFrame:Rect(0, 0, self.view.width,64)];
    [self.view addSubview:headView];
    [headView setBackgroundColor:RGB(15,173,225)];
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 30, kScreenWidth, 25)];
    [headView addSubview:lblName];
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [exitBtn clickWithBlock:^(UIGestureRecognizer *gesture) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [headView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.left.equalTo(headView);
        make.bottom.equalTo(headView);
    }];
    
    [lblName setTextColor:[UIColor whiteColor]];
    [lblName setText:@"我的收藏"];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    [lblName setFont:XCFONT(17)];
    [self.view setBackgroundColor:RGB(245, 245, 246)];
    
    [self changeLocation];
}

#pragma mark get history
- (void)initHistoryData
{
    if([UserInfo sharedUserInfo].aryCollet==nil)
    {
        [UserInfo sharedUserInfo].aryCollet = [NSMutableArray array];
        __weak MyCollectionController *__self = self;
        _listReuqest.historyBlock = ^(int status,NSArray *aryHistory,NSArray *aryColl)
        {
            for (RoomGroup *group in aryColl)
            {
                [[UserInfo sharedUserInfo].aryCollet addObject:group];
            }
            [__self setVideos:[UserInfo sharedUserInfo].aryCollet];
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self updateTableView];
            });
        };
        [_listReuqest requestRoomByUserId:[UserInfo sharedUserInfo].nUserId];
    }
    else
    {
        __weak MyCollectionController *__self = self;
        [__self setVideos:[UserInfo sharedUserInfo].aryCollet];
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self updateTableView];
        });
    }
}

- (void)updateTableView
{
    [self reloadData];
}

@end
