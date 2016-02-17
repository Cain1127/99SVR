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
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 30, self.view.width, 40)];
    [lblName setText:@"没有足迹"];
    [lblName setFont:XCFONT(14)];
    [container addSubview:lblName];
    lblName.textAlignment = NSTextAlignmentCenter;
    
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

- (void)randEnterRoom
{
    
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
    else
    {
        [self setEmptyData:YES];
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
