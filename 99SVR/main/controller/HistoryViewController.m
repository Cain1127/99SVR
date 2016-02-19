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
    logoImageView.frame = Rect(kScreenWidth/2-53,container.height/2-142,116.5, 92);
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, logoImageView.y+logoImageView.height+20, self.view.width, 40)];
    [lblName setText:@"暂时没有足迹"];
    [lblName setFont:XCFONT(14)];
    [container addSubview:lblName];
    [lblName setTextColor:[UIColor grayColor]];
    lblName.textAlignment = NSTextAlignmentCenter;
/*
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 30, self.view.width, 40)];
    [lblName setText:@"没有足迹"];
    [lblName setFont:XCFONT(14)];
    [container addSubview:lblName];
    lblName.textAlignment = NSTextAlignmentCenter;
 */
    
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
    __weak HistoryViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__self.videos.count>0)
        {
            RoomGroup *group = [__self.videos objectAtIndex:0];
            if (group.aryRoomHttp.count>0)
            {
                [__self setEmptyData:NO];
            }
            else
            {
                [__self setEmptyData:YES];
            }
        }
        else
        {
            [__self setEmptyData:YES];
        }
    });
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
