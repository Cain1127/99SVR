//
//  FinanceOnlineVedioController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/17.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "FinanceOnlineVedioController.h"
#import "RoomViewController.h"
#import "DecodeJson.h"
#import "AlertFactory.h"
#import "ProgressHUD.h"
#import "LSTcpSocket.h"
#import "RoomHttp.h"
#import "RoomGroup.h"
#import "VideoCell.h"
#import "Toast+UIView.h"
#import "GroupHeaderView.h"
#import "UserInfo.h"
#import "RoomTcpSocket.h"
#import "MJRefresh.h"
#import "ConnectRoomViewModel.h"

#define kGroupHeight 40

//uitableviw FinanceOnlineVedioController

@interface FinanceOnlineVedioController()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *_groupStatus;
}

@property (nonatomic,strong) ConnectRoomViewModel *roomViewModel;

@end

@implementation FinanceOnlineVedioController

- (void)reloadData
{
    __weak FinanceOnlineVedioController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.tableView reloadData];
    });
}

- (void)changeLocation
{
    CGRect rect = self.tableView.frame;
    rect.origin.y += 64;
    rect.size.height += 44;
    self.tableView.frame = rect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[VideoCell class] forCellReuseIdentifier:@"cellId"];
    
    [self.view addSubview:self.tableView];
    
    _groupStatus = [NSMutableDictionary dictionary];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma makr tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_videos.count>0)
    {
        RoomGroup *group = [_videos objectAtIndex:0];
        if (group.groupList && group.groupList.count>0)
        {
            return group.groupList.count;
        }
        else
        {
            return 1;
        }
    }
    return _videos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int status = [_groupStatus[@(section)] intValue];
    if (status == 1)
    {
        return 0;
    }
    if (_videos.count > 0)
    {
        RoomGroup *room = _videos[0];
        if (room.groupList && room.groupList.count>0)
        {
            RoomGroup *group = room.groupList[section];
            return (group.roomList.count + 1) / 2;
        }
        else
        {
            return (room.roomList.count + 1) / 2;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(_videos.count>0)
    {
        RoomGroup *roomTemp = _videos[0];
        RoomGroup *room = nil;
        if (roomTemp.groupList && roomTemp.groupList.count>0)
        {
            room = roomTemp.groupList[indexPath.section];
        }
        else
        {
            room = _videos[indexPath.section];
        }
        int length = 2;
        int loc = (int)indexPath.row * length;
        if (loc + length > room.roomList.count)
        {
            length = (int)room.roomList.count - loc;
        }
        NSRange range = NSMakeRange(loc, length);
        NSArray *rowDatas = [room.roomList subarrayWithRange:range];
        __weak FinanceOnlineVedioController *__self = self;
        cell.itemOnClick = ^(RoomHttp *room)
        {
            [__self connectRoom:room];
        };
        [cell setRowDatas:rowDatas];
    }
    return cell;
}

/**
 *  修改加入房间结构
 */
- (void)connectRoom:(RoomHttp *)room
{
   [self.view makeToastActivity];
    if (_roomViewModel==nil) {
        _roomViewModel = [[ConnectRoomViewModel alloc] initWithViewController:self];
    }
    [_roomViewModel connectViewModel:room];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((kScreenWidth-36)/2)*10/16+8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_videos.count>0)
    {
        GroupHeaderView *groupBtn = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kGroupHeight)];
        groupBtn.tag = section;
        int status = [_groupStatus[@(section)] intValue];
        if (status == 1)
        {
            groupBtn.open = NO;
        }
        else
        {
            groupBtn.open = YES;
        }
        RoomGroup *roomTemp = _videos[0];
        RoomGroup *room = nil;
        if (roomTemp.groupList && roomTemp.groupList.count>0)
        {
            room = roomTemp.groupList[section];
        }
        else
        {
            return nil;
        }
        groupBtn.title = room.groupName;
        __weak FinanceOnlineVedioController *__self = self;
        [groupBtn clickWithBlock:^(UIGestureRecognizer *gesture)
         {
             [__self groupClick:groupBtn];
         }];
        
        return groupBtn;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_videos.count>0)
    {
        RoomGroup *roomTemp = _videos[0];
        if (roomTemp.groupList && roomTemp.groupList.count>0)
        {
            return kGroupHeight;
        }
        else
        {
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)groupClick:(UIView *)btn
{
    int status = [_groupStatus[@(btn.tag)] intValue];
    if (status == 0)
    {
        [_groupStatus setObject:@(1) forKey:@(btn.tag)];
    }
    else
    {
        [_groupStatus setObject:@(0) forKey:@(btn.tag)];
    }
    [self.tableView reloadData];
}

- (void)addHeaderView:(NSString *)title
{
    UIView *headView = [[UIView alloc] initWithFrame:Rect(0, 0, self.view.width,64)];
    [self.view addSubview:headView];
    [headView setBackgroundColor:kNavColor];
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 30, kScreenWidth, 25)];
    [headView addSubview:lblName];
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    __weak FinanceOnlineVedioController *__self = self;
    [exitBtn clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        [__self dismissViewControllerAnimated:YES completion:nil];
    }];
    [headView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.left.equalTo(headView);
        make.bottom.equalTo(headView);
    }];
    [lblName setTextColor:[UIColor whiteColor]];
    [lblName setText:title];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    [lblName setFont:XCFONT(17)];
    [self.view setBackgroundColor:RGB(245, 245, 246)];
    [self changeLocation];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
