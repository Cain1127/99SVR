//
//  FinanceOnlineVedioController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/17.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "FinanceOnlineVedioController.h"
#import "RoomViewController.h"
#import "LSTcpSocket.h"
#import "RoomHttp.h"
#import "RoomGroup.h"
#import "VideoCell.h"
#import "Toast+UIView.h"
#import "GroupHeaderView.h"
#define kGroupHeight 40

@interface FinanceOnlineVedioController()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *_groupStatus;
}
@property(nonatomic, strong) UITableView *tableView;
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
    self.tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return _vedios.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int status = [_groupStatus[@(section)] intValue];
    if (status == 1)
    {
        return 0;
    }
    else
    {
        RoomGroup *room = _vedios[section];
        return (room.aryRoomHttp.count + 1) / 2;
    }
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
    RoomGroup *room = _vedios[indexPath.section];
    int length = 2;
    int loc = (int)indexPath.row * length;
    if (loc + length > room.aryRoomHttp.count)
    {
        length = (int)room.aryRoomHttp.count - loc;
    }
    NSRange range = NSMakeRange(loc, length);
    NSArray *rowDatas = [room.aryRoomHttp subarrayWithRange:range];
    __weak FinanceOnlineVedioController *__self = self;
    cell.itemOnClick = ^(RoomHttp *room)
    {
        [__self connectRoom:room];
    };
    [cell setRowDatas:rowDatas];
    return cell;
}

- (void)connectRoom:(RoomHttp *)room
{
    LSTcpSocket *socket = [LSTcpSocket sharedLSTcpSocket];
    NSString *strAry = [room.cgateaddr componentsSeparatedByString:@";"][0];
    NSString *strAddress = [strAry componentsSeparatedByString:@":"][0];
    __weak FinanceOnlineVedioController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.view makeToastActivity];
    });
    NSString *strPort = [strAry componentsSeparatedByString:@":"][1];
    [self performSelector:@selector(joinRoomTimeOut) withObject:nil afterDelay:6];
//    [socket connectRoomInfo:room.nvcbid address:@"172.16.41.215" port:22706];
//    [socket connectRoomInfo:roomi.nvcbid address:@"42.62.11.116" port:22706];
    [socket connectRoomInfo:room.nvcbid address:strAddress port:[strPort intValue]];
//    [socket connectRoomInfo:room.nvcbid address:strAddress port:22790];
    DLog(@"请求房间:room.nvcbid:%@--%@--%@",room.nvcbid,strAddress,strPort);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomSuc:) name:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomErr:) name:MESSAGE_JOIN_ROOM_ERR_VC object:nil];
}

- (void)joinRoomTimeOut
{
    __weak FinanceOnlineVedioController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.view hideToastActivity];
        [__self.view makeToast:@"加入房间超时"];
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)joinRoomErr:(NSNotification*)notify
{
    __weak FinanceOnlineVedioController *__self =self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:__self];
    });
    NSString *strMsg = notify.object;
    if ([strMsg isEqualToString:@"需要输入密码"])
    {
        [self createAlertController];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        __block NSString *__strMsg = strMsg;
        dispatch_async(dispatch_get_main_queue(),
       ^{
           [__self.view hideToastActivity];
           [__self.view makeToast:__strMsg];
       });
    }
}

#pragma mark 创建alert
- (void)createAlertController
{
    __weak FinanceOnlineVedioController *__self =self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
         textField.placeholder = @"密码";
    }];
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            //如果不再登录房间，取消notification
            [__self.view hideToastActivity];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        });
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
        UITextField *login = alert.textFields.firstObject;
        if ([login.text length]==0)
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [__self.view hideToastActivity];
                [__self.view makeToast:@"密码不能为空"];
                [__self createAlertController];
            });
        }
        else
        {
            [self performSelector:@selector(joinRoomTimeOut) withObject:nil afterDelay:10];
            dispatch_async(dispatch_get_global_queue(0, 0),
            ^{
                [[LSTcpSocket sharedLSTcpSocket] connectRoomAndPwd:login.text];
            });
        }
    }];
    [alert addAction:canAction];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)joinRoomSuc:(NSNotification *)notify
{
    __weak FinanceOnlineVedioController *__self =self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:__self];
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.view hideToastActivity];
        RoomViewController *roomView = [[RoomViewController alloc] init];
        [__self presentViewController:roomView animated:YES completion:nil];
    });   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_vedios.count==1)
    {
        return nil;
    }
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
    RoomGroup *group = _vedios[section];
    groupBtn.title = group.groupname;
    [groupBtn clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        [self groupClick:groupBtn];
    }];
    return groupBtn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_vedios.count<=1)
    {
        return 1;
    }
    return kGroupHeight;
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
    [exitBtn clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
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
