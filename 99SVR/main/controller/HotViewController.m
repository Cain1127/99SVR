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
    
    [self.tableView addGifHeaderWithRefreshingBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_INDEX_GET_GROUPLIST_VC object:nil];
    }];

    NSArray *aryRefreshing = [self getRefresh];
    NSArray *aryStart= [self getStartRefresh];
    [self.tableView.gifHeader setImages:aryStart forState:MJRefreshHeaderStateIdle];
    [self.tableView.gifHeader setImages:aryStart forState:MJRefreshHeaderStatePulling];
    [self.tableView.gifHeader setImages:aryRefreshing forState:MJRefreshHeaderStateRefreshing];
    [self.tableView.gifHeader setImages:aryStart forState:MJRefreshHeaderStateWillRefresh];
    self.tableView.gifHeader.updatedTimeHidden = YES;
    ///一开始进行一次主动刷新
    [self.tableView.gifHeader beginRefreshing];

}

- (NSArray *)getStartRefresh
{
    NSMutableArray *refreshingImages = [NSMutableArray array];
    
    UIImage *image = [UIImage imageNamed:@"loading_40x30_0001"];
    [refreshingImages addObject:image];
    return refreshingImages;
}

- (NSArray *)getRefresh
{
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 2; i <= 6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_40x30_000%lu", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    return refreshingImages;
}



- (void)reloadData
{
    [super reloadData];
    [self.tableView.header endRefreshing];
}

@end
