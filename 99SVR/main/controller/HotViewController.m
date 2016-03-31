//
//  HotViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "HotViewController.h"
#import "RoomGroup.h"
#import "MJRefresh.h"
#import "RoomHttp.h"

@interface HotViewController()
{
    
}

@end

@implementation HotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    __weak HotViewController *__self = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:
    ^{
         [__self.tableView.header beginRefreshing];
         [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_INDEX_GET_GROUPLIST_VC object:nil];
    }];
    
}

- (void)reloadData
{
    [super reloadData];
    [self.tableView.header endRefreshing];
}

@end
