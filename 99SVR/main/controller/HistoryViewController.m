//
//  HistoryViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "HistoryViewController.h"
#import "RoomGroup.h"

@interface HistoryViewController()
{
    UIView *_noDataView;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self addNoDataView];
}

- (void)addNoDataView
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 104)];
    [self.view addSubview:container];
    _noDataView = container;
    container.backgroundColor = [UIColor colorWithHex:@"#f3f3f3"];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"big_logo"]];
    [container addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(54);
        make.right.equalTo(container).offset(-54);
        make.top.equalTo(container).offset(98);
    }];
    
    if (self.videos == nil || self.videos.count == 0) {
        _noDataView.hidden = NO;
    } else {
        _noDataView.hidden = YES;
    }
}

- (void)reloadData
{
    [super reloadData];
    if (self.videos.count>0)
    {
        RoomGroup *group = [self.videos objectAtIndex:0];
        if (group.aryRoomHttp.count>0)
        {
            [self setEmptyData:NO];
        }
        else
        {
            [self setEmptyData:YES];
        }
    }
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

@end
