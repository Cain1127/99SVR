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
#import "RoomTcpSocket.h"



@interface SearchController()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
{
    NSArray *_keywordsArr;
    UIView *_accessoryView; // 遮盖层
    UIView *headView;
    GroupListRequest *_grouRequest;
    UIView *_defaultView;
    UITextField *_mySearchBar;
}

@property(nonatomic, strong) UITableView *searchResultsTable;
@property (nonatomic,copy) NSArray *aryResult;
@property (nonatomic,copy) NSArray *allDatas;

@end

@implementation SearchController

- (void)initDefaultView
{

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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)]];
    [self.view setUserInteractionEnabled:YES];
    [_mySearchBar becomeFirstResponder];
}

- (void)hiddenKeyBoard
{
    [_mySearchBar resignFirstResponder];
}

- (void)loadData
{
    if ([UserInfo sharedUserInfo].aryRoom.count>0)
    {
        NSMutableArray *aryDatas = [NSMutableArray array];
        RoomGroup *group = [[RoomGroup alloc] init];
        group.groupId = @"1";
        group.groupName = @"搜索";
        NSMutableArray *array = [NSMutableArray array];
        for (RoomGroup *rGroup in [UserInfo sharedUserInfo].aryRoom)
        {
            [rGroup.groupId isEqualToString:@"4"];
        }
        for (RoomGroup *rGroup in [UserInfo sharedUserInfo].aryRoom)
        {
            for (RoomHttp *item in rGroup.roomList)
            {
                [array removeObject:item];
                [array addObject:item];
            }
            for (RoomGroup *sonGroup in rGroup.groupList)
            {
                for (RoomHttp *item in sonGroup.roomList) {
                    [array removeObject:item];
                    [array addObject:item];
                }
            }
        }
        group.roomList = array;
        [aryDatas addObject:group];
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
                group.groupId = @"1";
                group.groupName = @"搜索";
                NSMutableArray *array = [NSMutableArray array];
                for (RoomGroup *rGroup in aryIndex)
                {
                    for (RoomHttp *item in rGroup.roomList)
                    {
                        [array removeObject:item];
                        [array addObject:item];
                    }
                    for (RoomGroup *sonGroup in rGroup.groupList)
                    {
                        for (RoomHttp *item in sonGroup.roomList) {
                            [array removeObject:item];
                            [array addObject:item];
                        }
                    }
                }
                group.roomList = array;
                [__aryDatas addObject:group];
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
    __weak SearchController *__self = self;
    [exitBtn clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        [__self dismissViewControllerAnimated:YES completion:nil];
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

- (void)navback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSubviews
{
//    [self addHeaderView];
//    [self setTitle:@"搜索"];
    self.view.backgroundColor = [UIColor whiteColor];
#if 0
    CGFloat space = 8;
    MySearchBar *searchBar = [[MySearchBar alloc] init];
    [searchBar setPlaceholder:@"输入房间ID或者房间名称"];
    searchBar.text = @"";
    [searchBar setShowsScopeBar:YES];
    searchBar.delegate = self;
    searchBar.layer.borderColor = [kLineColor CGColor];
    searchBar.layer.borderWidth = 0.5;
    searchBar.layer.masksToBounds = YES;
    [self.view addSubview:searchBar];
    _mySearchBar = searchBar;
    
    _mySearchBar.frame = Rect(8,72, kScreenWidth-16, 44);
#endif
    
    UIView *_headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = kNavColor;
    UILabel *title;
    title = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [title setFont:XCFONT(16)];
    [_headView addSubview:title];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:UIColorFromRGB(0xffffff)];
    title.text = @"搜索";
    
    UIButton *btnLeft = [CustomViewController itemWithTarget:self action:@selector(navback) image:@"back" highImage:@"back"];
    [_headView addSubview:btnLeft];
    [btnLeft setFrame:Rect(0,20,44,44)];
    
    _mySearchBar = [[UITextField alloc] initWithFrame:Rect(0,70,kScreenWidth, 44)];
    [self.view addSubview:_mySearchBar];
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:Rect(0,0,44,44)];
    _mySearchBar.leftView = imgHead;
    imgHead.image = [UIImage imageNamed:@"search_high"];
    _mySearchBar.leftViewMode = UITextFieldViewModeAlways;
    _mySearchBar.font = XCFONT(14);
    _mySearchBar.placeholder = @"请输入房间ID或者房间名称";
    _mySearchBar.layer.borderColor = UIColorFromRGB(0xcfcfcf).CGColor;
    _mySearchBar.layer.borderWidth = 0.5;
    _mySearchBar.returnKeyType = UIReturnKeySearch;
    _mySearchBar.delegate = self;
    
    UITableView *keywordsTable = [[UITableView alloc] init];
    keywordsTable.layer.masksToBounds = YES;
    keywordsTable.delegate = self;
    keywordsTable.dataSource = self;
    keywordsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:keywordsTable];
    _searchResultsTable = keywordsTable;
    _searchResultsTable.frame = Rect(0,_mySearchBar.y+_mySearchBar.height+8,kScreenWidth,kScreenHeight-(_mySearchBar.y+_mySearchBar.height+8));
    [_searchResultsTable registerClass:[VideoCell class] forCellReuseIdentifier:@"cellId"];
    
//    _accessoryView = [UIView new];
//    _accessoryView.backgroundColor = [UIColor blackColor];
//    _accessoryView.alpha = 0;
//    [self.view addSubview:_accessoryView];
//    [_accessoryView clickWithBlock:^(UIGestureRecognizer *gesture)
//     {
//         [self startSearch:_mySearchBar.text];
//         [self changeView:_accessoryView withAlpha:0];
//         [_mySearchBar endEditing:YES];
//     }];
//    [_accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.top.mas_equalTo(searchBar.mas_bottom).offset(space);
//        make.bottom.equalTo(self.view);
//    }];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:[NSString stringWithFormat:@"未搜索到包含\"%@\"的结果", _mySearchBar.text] forState:UIControlStateNormal];
//    btn.titleLabel.font = kFontSize(18);
//    btn.titleLabel.textColor = [UIColor redColor];
//    [self.view addSubview:btn];
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
            NSString *searchWords = [NSString stringWithFormat:@"cname like '*%@*' or nvcbid like '*%@*'" , keywords, keywords];
            NSPredicate *pre = [NSPredicate predicateWithFormat:searchWords];
            _aryResult = [group.roomList filteredArrayUsingPredicate:pre];
            [_searchResultsTable reloadData];
        }
        else
        {
            _defaultView.hidden = NO;
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
#if 0
    __weak SearchController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.view makeToastActivity];
    });
    NSString *strAddress;
    NSString *strPort;
    if([UserInfo sharedUserInfo].strRoomAddr)
    {
        NSString *strAry = [[UserInfo sharedUserInfo].strRoomAddr componentsSeparatedByString:@";"][0];
        strAddress = [strAry componentsSeparatedByString:@":"][0];
        strPort = [strAry componentsSeparatedByString:@":"][1];
    }
    else
    {
        NSString *strAry = [room.cgateaddr componentsSeparatedByString:@";"][0];
        strAddress = [strAry componentsSeparatedByString:@":"][0];
        strPort = [strAry componentsSeparatedByString:@":"][1];
    }
    [self performSelector:@selector(joinRoomTimeOut) withObject:nil afterDelay:6];
    [socket connectRoomInfo:room.nvcbid address:strAddress port:[strPort intValue]];
#endif
#if 1
    RoomViewController *roomView = [[RoomViewController alloc] initWithModel:room];
//    [self presentViewController:roomView animated:YES completion:nil];
    [self.navigationController pushViewController:roomView animated:YES];
#endif
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
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        dispatch_async(dispatch_get_main_queue(),
        ^{
           [__self.view hideToastActivity];
           [__self.view makeToast:@"连接失败"];
        });
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

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    DLog(@"string:%@",string);
//    if (textField.text.length>0)
//    {
//        [self startSearch:textField.text];
//    }
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length>0)
    {
        [self startSearch:textField.text];
        [textField resignFirstResponder];
    }
    return YES;
}

@end
