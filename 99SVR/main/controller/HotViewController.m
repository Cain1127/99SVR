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
    self.tableView.frame = Rect(0, 0, kScreenWidth, kScreenHeight-152);
    [self.tableView addGifHeaderWithRefreshingBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_INDEX_GET_GROUPLIST_VC object:nil];
    }];

    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.gifHeader beginRefreshing];
}

- (void)reloadData
{
    [super reloadData];
    [self.tableView.header endRefreshing];
}

@end
