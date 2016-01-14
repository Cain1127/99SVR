//
//  SearchController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/23.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "SearchController.h"
#import "MySearchBar.h"
#import "GroupListRequest.h"
#import "RoomGroup.h"
#import "RoomHttp.h"
#import "VideoCell.h"
#import "LSTcpSocket.h"
#import "Toast+UIView.h"
#import "RoomViewController.h"
#import "UserInfo.h"
#import "SearchButton.h"

#define kLineColor RGB(205, 204, 204)

@interface SearchController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSArray *_keywordsArr;
    MySearchBar *_mySearchBar; // 搜索框
    UIView *_accessoryView; // 遮盖层
    UIView *headView;
    GroupListRequest *_grouRequest;
    UIView *_defaultView;
}

@property(nonatomic, strong) UITableView *searchResultsTable;

//@property (nonatomic, strong) NSMutableArray *allDatas;
//@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic,copy) NSArray *aryResult;
@property (nonatomic,copy) NSArray *allDatas;

@end

@implementation SearchController

- (void)initDefaultView
{
    _defaultView = [[UIView alloc] initWithFrame:Rect(0,_searchResultsTable.y,kScreenWidth,_searchResultsTable.height)];
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 30, kScreenWidth,20)];
    [lblName setText:@"热门搜索"];
    [lblName setFont:XCFONT(15)];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    [_defaultView addSubview:lblName];
    [self.view addSubview:_defaultView];
    [self addTitleGroup];
}

- (void)addTitleGroup
{
    NSArray *arySB = @[@"股林争霸",@"财富一家",@"股上云霄"];
    for (int i=0; i<arySB.count; i++)
    {
        SearchButton *sb1 = [[SearchButton alloc] initWithFrame:Rect(0, (30*i+1)+60, kScreenWidth, 16)];
        [_defaultView addSubview:sb1];
        [sb1 setTitle:[arySB objectAtIndex:i] forState:UIControlStateNormal];
        [sb1 addTarget:self action:@selector(searchBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)searchBtnEvent:(UIButton *)sender
{
    NSString *strInfo = sender.titleLabel.text;
    [self startSearch:strInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _grouRequest = [[GroupListRequest alloc] init];
    [self addSubviews];
    [self loadData];
    [self initDefaultView];
}

- (void)loadData
{
    if ([UserInfo sharedUserInfo].aryRoom.count>0)
    {
        NSMutableArray *aryDatas = [NSMutableArray array];
        RoomGroup *group = [[RoomGroup alloc] init];
        group.groupid = @"1";
        group.groupname = @"搜索";
        group.aryRoomHttp = [NSMutableArray array];
        [aryDatas addObject:group];
        for (RoomGroup *rGroup in [UserInfo sharedUserInfo].aryRoom)
        {
            for (RoomHttp *item in rGroup.aryRoomHttp)
            {
                [group.aryRoomHttp removeObject:item];
                [group.aryRoomHttp addObject:item];
            }
        }
        _allDatas = aryDatas;
    }
    else
    {
        __weak SearchController *__self = self;
        __block NSMutableArray *__aryDatas = [NSMutableArray array];
        _grouRequest.groupBlock = ^(int status,NSArray *aryIndex)
        {
            if (status==1)
            {
                RoomGroup *group = [[RoomGroup alloc] init];
                group.groupid = @"1";
                group.groupname = @"搜索";
                group.aryRoomHttp = [NSMutableArray array];
                [__aryDatas addObject:group];
                for (RoomGroup *rGroup in aryIndex)
                {
                    for (RoomHttp *item in rGroup.aryRoomHttp)
                    {
                        [group.aryRoomHttp removeObject:item];
                        [group.aryRoomHttp addObject:item];
                    }
                }
                __self.allDatas = __aryDatas;
            }
        };
        [_grouRequest requestListRequest];
    }
}

- (void)addHeaderView
{
    headView = [[UIView alloc] initWithFrame:Rect(0, 0, self.view.width,64)];
    [self.view addSubview:headView];
    [headView setBackgroundColor:kNavColor];
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
    [lblName setText:@"搜索"];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    [lblName setFont:XCFONT(17)];
    [self.view setBackgroundColor:RGB(245, 245, 246)];
}

- (void)addSubviews
{
    [self addHeaderView];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat space = 8;
//    CGFloat searchBarHeight = 44;
    MySearchBar *searchBar = [[MySearchBar alloc] init];
    [searchBar setPlaceholder:@"请输入搜索关键字"];
    [searchBar setShowsScopeBar:YES];
    searchBar.delegate = self;
    searchBar.layer.borderColor = [kLineColor CGColor];
    searchBar.layer.borderWidth = 0.5;
    searchBar.layer.masksToBounds = YES;
    [self.view addSubview:searchBar];
    _mySearchBar = searchBar;
    
    _mySearchBar.frame = Rect(8,72, kScreenWidth-16, 44);
    
    UITableView *keywordsTable = [[UITableView alloc] init];
    keywordsTable.layer.masksToBounds = YES;
    keywordsTable.delegate = self;
    keywordsTable.dataSource = self;
    keywordsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:keywordsTable];
    _searchResultsTable = keywordsTable;
    _searchResultsTable.frame = Rect(0,_mySearchBar.y+_mySearchBar.height+8,kScreenWidth,kScreenHeight-(_mySearchBar.y+_mySearchBar.height+8));
    [_searchResultsTable registerClass:[VideoCell class] forCellReuseIdentifier:@"cellId"];
    
    _accessoryView = [UIView new];
    _accessoryView.backgroundColor = [UIColor whiteColor];
    _accessoryView.alpha = 0;
    [self.view addSubview:_accessoryView];
    [_accessoryView clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        [self startSearch:_mySearchBar.text];
        [self changeView:_accessoryView withAlpha:0];
        [_mySearchBar endEditing:YES];
    }];
    [_accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(searchBar.mas_bottom).offset(space);
        make.bottom.equalTo(self.view);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:[NSString stringWithFormat:@"未搜索到包含\"%@\"的结果", _mySearchBar.text] forState:UIControlStateNormal];
    btn.titleLabel.font = kFontSize(18);
    btn.titleLabel.textColor = [UIColor redColor];
    [self.view addSubview:btn];
}

- (void)changeView:(UIView *)view withAlpha:(CGFloat)alpha
{
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = alpha;
    }
    completion:^(BOOL finished)
    {
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self startSearch:_mySearchBar.text];
    [self changeView:_accessoryView withAlpha:0];
    [_mySearchBar endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self changeView:_accessoryView withAlpha:0.9];
}

#pragma mark 开始搜索
- (void)startSearch:(NSString *)keywords
{
    if ([keywords isEqualToString:@""])
    {
        _aryResult = [NSArray array];
        [_searchResultsTable reloadData];
        _defaultView.hidden = NO; 
    }
    else
    {
        if(_allDatas.count>0)
        {
            _defaultView.hidden = YES;
            RoomGroup *group = [_allDatas objectAtIndex:0];
            NSString *searchWords = [NSString stringWithFormat:@"cname like '*%@*' or nvcbid like '*%@*'", keywords, keywords];
            NSPredicate *pre = [NSPredicate predicateWithFormat:searchWords];
            _aryResult = [group.aryRoomHttp filteredArrayUsingPredicate:pre];
            if (_aryResult.count == 0)
            {
                [self noFindTips];
            }
            else
            {
                [_searchResultsTable reloadData];
            }
        }
        else
        {
            _defaultView.hidden = NO;
        }
    }
}

- (void)noFindTips
{
    NSString *tipsStr = [NSString stringWithFormat:@"未找到包含\"%@\"的结果", _mySearchBar.text];
    [self.view makeToast:tipsStr];
}

- (void)changeBtnStyle:(UIView *)superView
{
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)view;
            if ([btn.titleLabel.text isEqualToString:@"Cancel"])
            {
                [btn setTitle:@"搜索" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                [btn clickWithBlock:^(UIGestureRecognizer *gesture) {
                    
                }];
            }
            break;
        } else
        {
            [self changeBtnStyle:view];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_aryResult.count + 1) / 2;
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
    int length = 2;
    int loc = (int)indexPath.row * length;
    if (loc + length > _aryResult.count)
    {
        length = (int)_aryResult.count - loc;
    }
    NSRange range = NSMakeRange(loc, length);
    NSArray *rowDatas = [_aryResult subarrayWithRange:range];
    cell.itemOnClick = ^(RoomHttp *room)
    {
        [self connectRoom:room];
    };
    [cell setRowDatas:rowDatas];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (void)connectRoom:(RoomHttp *)room
{
    LSTcpSocket *socket = [LSTcpSocket sharedLSTcpSocket];
    NSString *strAry = [room.cgateaddr componentsSeparatedByString:@";"][0];
    NSString *strAddress = [strAry componentsSeparatedByString:@":"][0];
    __weak SearchController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [__self.view makeToastActivity];
                   });
    NSString *strPort = [strAry componentsSeparatedByString:@":"][1];
    [self performSelector:@selector(joinRoomTimeOut) withObject:nil afterDelay:10];
    [socket connectRoomInfo:room.nvcbid address:strAddress port:[strPort intValue]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomSuc:) name:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomErr:) name:MESSAGE_JOIN_ROOM_ERR_VC object:nil];
}

- (void)joinRoomTimeOut
{
    __weak SearchController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.view hideToastActivity];
        [__self.view makeToast:@"加入房间超时"];
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)joinRoomErr:(NSNotification*)notify
{
    __weak SearchController *__self =self;
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
    __weak SearchController *__self =self;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
    __weak SearchController *__self =self;
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

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
