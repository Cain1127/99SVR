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

#define kLineColor RGB(205, 204, 204)

@interface SearchController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSArray *_keywordsArr;
    MySearchBar *_mySearchBar; // 搜索框
    UIView *_accessoryView; // 遮盖层
    UIView *headView;
    GroupListRequest *_grouRequest;
}

@property(nonatomic, strong) UITableView *searchResultsTable;

@property (nonatomic, strong) NSMutableArray *allDatas;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation SearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _grouRequest = [[GroupListRequest alloc] init];
    self.allDatas = [NSMutableArray array];
    _searchResults = [NSMutableArray array];
    [self addSubviews];
    [self loadData];
}

- (void)loadData {
    __weak SearchController *__self = self;
    _grouRequest.groupBlock = ^(int status,NSArray *aryIndex)
    {
        for (RoomGroup *group in aryIndex)
        {
            for (RoomHttp *item in group.aryRoomHttp) {
                BOOL repeat = NO;
                for (RoomHttp *innerItem in __self.allDatas) {
                    if ([innerItem.nvcbid isEqualToString:item.nvcbid]) {
                        repeat = YES;
                        break;
                    }
                }
                if (!repeat) {
                    [__self.allDatas addObject:item];
                }
            }
        }
        [__self.searchResultsTable reloadData];
    };
    [_grouRequest requestListRequest];
}

- (void)addHeaderView {
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
    CGFloat searchBarHeight = 44;
    MySearchBar *searchBar = [[MySearchBar alloc] init];
    [searchBar setPlaceholder:@"请输入搜索关键字"];
    [searchBar setShowsScopeBar:YES];
    searchBar.delegate = self;
    searchBar.layer.borderColor = [kLineColor CGColor];
    searchBar.layer.borderWidth = 0.5;
    searchBar.layer.masksToBounds = YES;
    [self.view addSubview:searchBar];
    _mySearchBar = searchBar;
    
    
    
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(space);
        make.right.equalTo(self.view).offset(-space);
        make.height.mas_equalTo(searchBarHeight);
        make.top.equalTo(self.view).offset(64 + space);
    }];
    
    UITableView *keywordsTable = [[UITableView alloc] init];
    keywordsTable.layer.borderColor = [kLineColor CGColor];
    keywordsTable.layer.borderWidth = 0.5;
    keywordsTable.layer.masksToBounds = YES;
    keywordsTable.delegate = self;
    keywordsTable.dataSource = self;
    keywordsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:keywordsTable];
    self.searchResultsTable = keywordsTable;
    [self.searchResultsTable registerClass:[VideoCell class] forCellReuseIdentifier:@"cellId"];
    
    [keywordsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchBar.mas_bottom).offset(space);
        make.left.equalTo(self.view).offset(space);
        make.right.equalTo(self.view).offset(-space);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    _accessoryView = [UIView new];
    _accessoryView.backgroundColor = [UIColor blackColor];
    _accessoryView.alpha = 0;
    [self.view addSubview:_accessoryView];
    [_accessoryView clickWithBlock:^(UIGestureRecognizer *gesture) {
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
    } completion:^(BOOL finished) {
        
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
    [self changeView:_accessoryView withAlpha:0.5];
}

#pragma mark 开始搜索
- (void)startSearch:(NSString *)keywords
{
    NSString *searchWords = [NSString stringWithFormat:@"cname like '*%@*' or nvcbid like '*%@*'", keywords, keywords];
    NSPredicate *pre = [NSPredicate predicateWithFormat:searchWords];
    NSArray *resultArr = [self.allDatas filteredArrayUsingPredicate:pre];
    if (resultArr.count == 0)
    {
        [self noFindTips];
    }
    else
    {
        self.searchResults = [NSMutableArray arrayWithArray:resultArr];
        [self.searchResultsTable reloadData];
    }
}

- (void)noFindTips
{
    NSString *tipsStr = [NSString stringWithFormat:@"未找到包含\"%@\"的结果", _mySearchBar.text];
    UIAlertView *tips = [[UIAlertView alloc] initWithTitle:nil message:tipsStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [tips show];
}

- (void)changeBtnStyle:(UIView *)superView
{
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if ([btn.titleLabel.text isEqualToString:@"Cancel"]) {
                [btn setTitle:@"搜索" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                [btn clickWithBlock:^(UIGestureRecognizer *gesture) {
                    
                }];
            }
            break;
        } else {
            [self changeBtnStyle:view];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return (self.searchResults.count + 1) / 2;
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
    if (loc + length > self.searchResults.count)
    {
        length = (int)self.searchResults.count - loc;
    }
    NSRange range = NSMakeRange(loc, length);
    NSArray *rowDatas = [self.searchResults subarrayWithRange:range];
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
