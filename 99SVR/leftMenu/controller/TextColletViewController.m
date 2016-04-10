//
//  TextColletViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextColletViewController.h"
#import "TextGroupList.h"
#import "UserInfo.h"
#import "TextHomeViewController.h"
#import "TextCell.h"
#import "BaseService.h"

@interface TextColletViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UILabel *lblLine2;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryHot;
@property (nonatomic,copy) NSArray *aryLiving;
@property (nonatomic,strong) NSMutableArray *aryGroup;

@end

@implementation TextColletViewController

- (void)settingTextGroup
{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(),
    ^{
       [selfWeak.tableView reloadData];
    });
}

- (void)initLivingData
{
    [_aryGroup removeAllObjects];
    @WeakObj(self)
    NSString *strUrl = [NSString stringWithFormat:@"%@%d",kTEXT_FOLLOW_URL,[UserInfo sharedUserInfo].nUserId];
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [dict respondsToSelector:@selector(objectForKey:)] && [dict objectForKey:@"rooms"])
         {
             NSArray *aryResult = [dict objectForKey:@"rooms"];
             for (NSDictionary *roomDict in aryResult)
             {
                 TextRoomModel *textModel = [TextRoomModel resultWithDict:roomDict];
                 [selfWeak.aryGroup addObject:textModel];
             }
         }
         dispatch_async(dispatch_get_main_queue(),
         ^{
            [selfWeak settingTextGroup];
            [selfWeak.tableView reloadData];
         });
     } fail:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"关注讲师"];
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _aryGroup = [NSMutableArray array];
    [self initUIHead];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initLivingData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initUIHead
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0,64,kScreenWidth,kScreenHeight-114)];
    _tableView.tag = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_aryGroup.count > tableView.tag)
    {
        NSInteger count = (_aryGroup.count%2 == 0) ? _aryGroup.count/2 : (_aryGroup.count/2+1);
        return count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellIdentifier = @"TextLivingIdentifier";
    TextCell *cell = [_tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if(cell==nil)
    {
        cell = [[TextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIdentifier];
    }
    NSInteger count = (_aryGroup.count%2 == 0) ? _aryGroup.count/2 : (_aryGroup.count/2+1);
    if(count > indexPath.row)
    {
        int length = 2;
        int loc = (int)indexPath.row * length;
        if (loc + length >_aryGroup.count)
        {
            length = (int)_aryGroup.count - loc;
        }
        NSRange range = NSMakeRange(loc, length);
        NSArray *rowDatas = [_aryGroup subarrayWithRange:range];
        @WeakObj(self)
        cell.itemOnClick = ^(TextRoomModel *room)
        {
            TextHomeViewController *roomView = [[TextHomeViewController alloc] initWithModel:room];
            [selfWeak.navigationController pushViewController:roomView animated:YES];
        };
        [cell setRowDatas:rowDatas];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((kScreenWidth-36)/2)*10/16+8;;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
