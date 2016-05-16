//
//  MyCollectionController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/22.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "VideoColletionViewController.h"
#import "UserInfo.h"
#import "RoomViewController.h"
#import "CustomViewController.h"
#import "VideoCell.h"
#import "UserInfo.h"
#import "RoomHttp.h"
#import "ConnectRoomViewModel.h"
#import "TableViewFactory.h"
#import "ViewNullFactory.h"

@interface VideoColletionViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSArray *aryVideo;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ConnectRoomViewModel *roomViewModel;
@property (nonatomic,strong) UIView *noView;
@end

@implementation VideoColletionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"我的关注"];
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) withStyle:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView setBackgroundColor:UIColorFromRGB(0xffffff)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideoList:) name:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark get history
- (void)loadData
{
    [self.view makeToastActivity_bird];
    [kHTTPSingle RequestCollection];
}

- (void)loadVideoList:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.view hideToastActivity];
        [selfWeak.noView removeFromSuperview];
    });
    if([dict isKindOfClass:[NSDictionary class]])
    {
        int nStatus = [dict[@"code"] intValue];
        if(nStatus==1)
        {
            NSArray *aryCollet = dict[@"data"];
            _aryVideo = aryCollet;
            if (aryCollet.count==0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [selfWeak createView:@"nav_search_no_result" msg:@"没有关注记录"];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [selfWeak.tableView reloadData];
                });
            }
            return ;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak createView:@"network_anomaly_fail" msg:@"请求关注列表失败"];
    });
}

- (void)createView:(NSString *)strName msg:(NSString *)strMsg
{
    if (!_noView) {
        char cString[255];
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        sprintf(cString, "%s/%s.png",path,[strName UTF8String]);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        UIImage *image = [UIImage imageWithContentsOfFile:objCString];
        if(image)
        {
            _noView = [ViewNullFactory createViewBg:Rect(0,0,kScreenWidth,_tableView.height) imgView:image msg:strMsg];
        }
    }
    [_tableView addSubview:_noView];
    @WeakObj(self)
    if ([strMsg isEqualToString:@"请求关注列表失败"])
    {
        [_noView setUserInteractionEnabled:YES];
        [_noView clickWithBlock:^(UIGestureRecognizer *gesture) {
            [selfWeak.view makeToastActivity_bird];
            [kHTTPSingle RequestCollection];
        }];
    }else
    {
        [_noView setUserInteractionEnabled:NO];
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"dealloc");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *videoCellName = @"videoCellName";
    VideoCell *tempCell = [_tableView dequeueReusableCellWithIdentifier:videoCellName];
    
    if(!tempCell)
    {
        tempCell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellName];
    }
    @WeakObj(self);
    tempCell.itemOnClick = ^(RoomHttp *room)
    {
        [selfWeak connectRoom:room];
    };
    int length = 2;
    int loc = (int)indexPath.row * length;
    if (loc + length > _aryVideo.count)
    {
        length = (int)_aryVideo.count - loc;
    }
    NSRange range = NSMakeRange(loc, length);
    NSArray *aryIndex = [_aryVideo subarrayWithRange:range];
    [tempCell setRowDatas:aryIndex isNew:1];
    return tempCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = (NSInteger)ceilf((1.0f * _aryVideo.count) / 2.0f);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat height = ((kScreenWidth - 36.0f) / 2.0f) * 10 / 16 + 8;
    return height;
}

- (void)connectRoom:(RoomHttp *)room{
    /*
    [self.view makeToastActivity_bird];
    if (_roomViewModel==nil)
    {
        _roomViewModel = [[ConnectRoomViewModel alloc] initWithViewController:self];
    }
    [_roomViewModel connectViewModel:room];
   */
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if ([roomView.room.roomid isEqualToString:room.roomid])
    {
        [roomView addNotify];
        [self.navigationController pushViewController:roomView animated:YES];
        return ;
    }
    [roomView setRoom:room];
    [self.navigationController pushViewController:roomView animated:YES];
}

@end
