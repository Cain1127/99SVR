//
//  SearchController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/23.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "SearchController.h"
#import "MySearchBar.h"
#import "ZLRoomVideoViewController.h"
#import "RoomViewController.h"
#import "ConnectRoomViewModel.h"
#import "AlertFactory.h"
#import "DecodeJson.h"
#import "IQKeyboardManager.h"
#import "RoomGroup.h"
#import "RoomHttp.h"
#import "VideoCell.h"
#import "Toast+UIView.h"
#import "RoomViewController.h"
#import "UserInfo.h"
#import "SearchButton.h"
#import "HistorySearchDataSource.h"
#import "TableViewFactory.h"
#import "UIViewController+EmpetViewTips.h"

@interface SearchController()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,HistoryDelegate,UIScrollViewDelegate>
{
    NSArray *_keywordsArr;
    UIView *_accessoryView; // 遮盖层
    UIView *headView;
    UIView *_defaultView;
    UITextField *_mySearchBar;
    HistorySearchDataSource *_dataSource;
    UITableView *_historyTable;
}
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) ConnectRoomViewModel *roomViewModel;
@property(nonatomic, strong) UITableView *searchResultsTable;
@property (nonatomic,copy) NSArray *aryResult;
@property (nonatomic,copy) NSArray *allDatas;
@property (nonatomic,strong) RoomHttp *room;

@end

@implementation SearchController

- (UIView *)footView
{
    NSArray *array = [UserDefaults objectForKey:kHistoryList];
    if (array.count==0) {
        _footView = nil;
        return nil;
    }
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 44)];
        UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClear.frame = Rect(0, 0, kScreenWidth, 44);
        [_footView addSubview:btnClear];
        [btnClear setTitle:@"清除搜索记录" forState:UIControlStateNormal];
        [btnClear setTitleColor:COLOR_Text_0078DD forState:UIControlStateNormal];
        [btnClear setTitleColor:COLOR_Text_Black forState:UIControlStateHighlighted];
        [btnClear addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

- (void)searchBtnEvent:(UIButton *)sender
{
    NSString *strInfo = sender.titleLabel.text;
    [self startSearch:strInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self addSubviews];
    [self loadData];
    [_mySearchBar becomeFirstResponder];
}

- (void)hiddenKeyBoard
{
    [_mySearchBar resignFirstResponder];
}

- (void)loadVideoList:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.view hideToastActivity];
    });
    if([dict isKindOfClass:[NSDictionary class]])
    {
        int nStatus = [dict[@"code"] intValue];
        if(nStatus==1)
        {
            NSArray *aryVideo = dict[@"show"];
            NSMutableArray *aryAll = [NSMutableArray array];
            [aryAll addObjectsFromArray:aryVideo];
            NSArray *aryHidden = dict[@"hidden"];
            for (RoomHttp *room in aryHidden)
            {
                [aryAll addObject:room];
            }
            
            NSArray *aryHelp = dict[@"help"];
            [UserInfo sharedUserInfo].aryHelp = aryHelp;
            for (RoomHttp *room in aryHelp)
            {
                [aryAll addObject:room];
            }
            [UserInfo sharedUserInfo].aryRoom = aryAll;
            _allDatas = aryAll;
            return ;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showError:@"获取财经直播团队列表失败，无法搜索"];
    });
}

- (void)loadData
{
    if ([UserInfo sharedUserInfo].aryRoom.count>0)
    {
        _allDatas = [UserInfo sharedUserInfo].aryRoom;
    }
    else
    {
        [self.view makeToastActivity_bird];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideoList:) name:MESSAGE_HOME_VIDEO_LIST_VC object:nil];
        [kHTTPSingle RequestTeamList];
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
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    _mySearchBar = [[UITextField alloc] initWithFrame:Rect(0,64,kScreenWidth, 44)];
    [self.view addSubview:_mySearchBar];
    
    UIView *leftView = [[UIView alloc] initWithFrame:Rect(0, 0, 38, 44)];
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:Rect(10,13,18,18)];
    
    imgHead.image = [UIImage imageNamed:@"search_icon"];
    imgHead.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:imgHead];
    _mySearchBar.leftView = leftView;
    _mySearchBar.leftViewMode = UITextFieldViewModeAlways;
    _mySearchBar.font = XCFONT(14);
    _mySearchBar.placeholder = @"请输入房间ID或者房间名称";
    _mySearchBar.layer.borderColor = UIColorFromRGB(0xcfcfcf).CGColor;
    _mySearchBar.layer.borderWidth = 0.5;
    _mySearchBar.returnKeyType = UIReturnKeySearch;
    [_mySearchBar setBackgroundColor:UIColorFromRGB(0xffffff)];
    [_mySearchBar addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventEditingChanged];
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
    
    // 历史记录
    _historyTable = [TableViewFactory createTableViewWithFrame:Rect(0, _mySearchBar.y+_mySearchBar.height, kScreenWidth, kScreenHeight - (_mySearchBar.y+_mySearchBar.height)) withStyle:UITableViewStylePlain];
    [self.view addSubview:_historyTable];
    [_historyTable setBackgroundColor:UIColorFromRGB(0xffffff)];
    _dataSource = [[HistorySearchDataSource alloc] init];
    _historyTable.dataSource = _dataSource;
    _historyTable.delegate = _dataSource;
    _dataSource.delegate = self;
    NSArray *array = [UserDefaults objectForKey:kHistoryList];
    if (array.count)
    {
        [_dataSource setModel:array];
        _historyTable.tableFooterView = self.footView;
        [_historyTable reloadData];
    }
    // 给历史记录添加关闭键盘手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHideTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [_historyTable addGestureRecognizer:tapGr];
}

#pragma mark 开始搜索
- (void)startSearch:(NSString *)keywords
{
    if ([keywords isEqualToString:@""])
    {
        _aryResult = [NSArray array];
        [_searchResultsTable reloadData];
        _defaultView.hidden = NO;
        _historyTable.hidden =  NO;
        NSArray *array = [UserDefaults objectForKey:kHistoryList];
        if (array.count)
        {
            [_dataSource setModel:array];
            _historyTable.tableFooterView = self.footView;
            [_historyTable reloadData];
        }
        else
        {
            _historyTable.tableFooterView = self.footView;
        }
    }
    else
    {
        if(_allDatas.count>0)
        {
            _defaultView.hidden = YES;
            
            NSString *searchWords = [NSString stringWithFormat:@"teamname like '*%@*' or roomid like '*%@*'" , keywords, keywords];
            NSPredicate *pre = [NSPredicate predicateWithFormat:searchWords];
            
            _aryResult = [_allDatas filteredArrayUsingPredicate:pre];
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            for (RoomHttp *room in _aryResult) {
                [dictionary setObject:room forKey:room.roomid];
            };
            _aryResult = [dictionary allValues];
            if (_aryResult.count) {
                [self hideEmptyViewInView:_searchResultsTable];
            }else{
                @WeakObj(self);
                [self showEmptyViewInView:_searchResultsTable withMsg:@"没有搜索结果" touchHanleBlock:^{
                    @StrongObj(self);
                    [self.view endEditing:YES]; // 关闭键盘
                    [self startSearch:_mySearchBar.text];
                }];
            }
            _historyTable.hidden = YES;
            [_searchResultsTable reloadData];
        }
        else
        {
            _defaultView.hidden = NO;
            _historyTable.hidden =  NO;
            NSArray *array = [UserDefaults objectForKey:kHistoryList];
            if (array.count)
            {
                [_dataSource setModel:array];
                [_historyTable reloadData];
            }
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
    [cell setRowDatas:rowDatas isNew:1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (void)connectRoom:(RoomHttp *)room
{
    NSArray *array = [UserDefaults objectForKey:kHistoryList];
    NSMutableArray *tableAry = [NSMutableArray array];
    if (array!=nil) {
        [tableAry addObjectsFromArray:array];
    }
    NSString *strText = _mySearchBar.text;
    for (int i=0; i<tableAry.count; i++) {
        if ([tableAry[i] isEqualToString:strText]) {
            [tableAry removeObjectAtIndex:i];
            break ;
        }
    }
    
    //[tableAry addObject:strText];
    [tableAry insertObject:strText atIndex:0]; // 插入排在最上面
    if (tableAry.count > 5) {
        [tableAry removeObject:tableAry.lastObject]; // 删除最后一条搜索记录
    }
    [UserDefaults setObject:tableAry forKey:kHistoryList];
    [UserDefaults synchronize];
    
    if (KUserSingleton.nStatus) {
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
    else
    {
        ZLRoomVideoViewController *viewVC = [[ZLRoomVideoViewController alloc] initWithModel:room];
        [self.navigationController pushViewController:viewVC animated:YES];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length>0)
    {
        [self startSearch:textField.text];
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)onChange:(UITextField *)textField{
    [self startSearch:textField.text];
}

#pragma mark - HistorySearch代理方法

// HistorySearch代理方法 -- 清除搜索记录
- (void)delSelectIndex:(NSString *)strInfo{
    NSArray *array = [UserDefaults objectForKey:kHistoryList];
    NSMutableArray *tableAry = [NSMutableArray array];
    if (array!=nil)
    {
        [tableAry addObjectsFromArray:array];
    }
    for (int i=0; i<tableAry.count; i++) {
        if([strInfo isEqualToString:tableAry[i]])
        {
            [tableAry removeObjectAtIndex:i];
            break;
        }
    }
    [UserDefaults setObject:tableAry forKey:kHistoryList];
    [UserDefaults synchronize];
    
    if(tableAry.count)
    {
        [_dataSource setModel:tableAry];
        [_historyTable reloadData];
    } else {
        [_dataSource setModel:tableAry];
        _historyTable.tableFooterView = nil;
        [_historyTable reloadData];
    }
}

// HistorySearch代理方法 -- 选择搜索记录
- (void)selectIndex:(NSString *)strInfo
{
    _mySearchBar.text = strInfo;
    [self startSearch:strInfo];
}

// HistorySearch代理方法 -- 删除搜索记录
- (void)deleteAll
{
    NSArray *array = [UserDefaults objectForKey:kHistoryList];
    NSMutableArray *tableAry = [NSMutableArray array];
    if (array!=nil) {
        [tableAry addObjectsFromArray:array];
    }
    [tableAry removeAllObjects];
    
    [UserDefaults setObject:tableAry forKey:kHistoryList];
    [UserDefaults synchronize];
    
    [_dataSource setModel:tableAry];
    _historyTable.tableFooterView = nil;
    [_historyTable reloadData];
}

- (void)dealloc
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

// 隐藏键盘
-(void)keyboardHideTapped:(UITapGestureRecognizer*)tapGr
{
    [_mySearchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if (roomView.room)
    {
        [roomView removeNotice];
    }
}

@end
