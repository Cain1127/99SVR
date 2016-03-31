//
//  TextViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextViewController.h"
#import "HotTextView.h"
#import "BaseService.h"
#import "TextRoomModel.h"
#import "TextTcpSocket.h"
#import "TextCell.h"
#import "TeacherModel.h"
#import "TextHomeViewController.h"
#import "TextLivingCell.h"
#import "TextGroupList.h"
#import "MyScrollView.h"

@interface TextViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger _tag;
    CGFloat fWidth;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    NSInteger _currentPage;
    int updateCount;
    UILabel *_line1;
    
}
@property (nonatomic,strong) UILabel *lblLine2;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryHot;
@property (nonatomic,copy) NSArray *aryLiving;
@property (nonatomic,strong) NSMutableArray *aryGroup;

@end

@implementation TextViewController

- (void)settingTextGroup
{
    __weak TextViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.tableView reloadData];
    });
}

- (void)initLivingData
{
     __weak TextViewController *__self = self;
     [BaseService postJSONWithUrl:kTEXT_GROUP_URL parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [dict objectForKey:@"groups"])
         {
             NSArray *aryResult = [dict objectForKey:@"groups"];
             for (NSDictionary *roomDict in aryResult)
             {
                 TextGroupList *groupList = [TextGroupList resultWithDict:roomDict];
                 [__self.aryGroup addObject:groupList];
             }
         }
         dispatch_async(dispatch_get_main_queue(),
         ^{
             [__self settingTextGroup];
             [__self.tableView reloadData];
         });
     } fail:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *_headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *title;
    title = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [title setFont:XCFONT(16)];
    [_headView addSubview:title];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:UIColorFromRGB(0x0078DD)];
    UILabel *_lblContent;
    _lblContent = [[UILabel alloc] initWithFrame:Rect(0, 63.5, kScreenWidth, 0.5)];
    [_lblContent setBackgroundColor:[UIColor whiteColor]];
    [_headView addSubview:_lblContent];
    title.text = @"99财经";
    
    UIButton *btnLeft = [CustomViewController itemWithTarget:self action:@selector(showLeftView) image:@"nav_menu_icon_n" highImage:@"nav_menu_icon_p"];
    [self.view addSubview:btnLeft];
    [btnLeft setFrame:Rect(0,20,44,44)];
    
    _aryGroup = [NSMutableArray array];
    [self initUIHead];
    _line1 = [UILabel new];
    _line1.backgroundColor = UIColorFromRGB(0x629aff);
    [_line1 setFrame:Rect(0,2,fWidth,2)];
    
    [self initScrollView];
    [self initLivingData];
}

- (void)showLeftView
{
    [self leftItemClick];
}

- (void)initScrollView
{

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
        TextGroupList *textList = [_aryGroup objectAtIndex:tableView.tag];
        NSInteger count = (textList.rooms.count%2 == 0) ? textList.rooms.count/2 : (textList.rooms.count/2+1);
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
    TextGroupList *textList = [_aryGroup objectAtIndex:tableView.tag];
    NSInteger count = (textList.rooms.count%2 == 0) ? textList.rooms.count/2 : (textList.rooms.count/2+1);
    if(count > indexPath.row)
    {

        TextGroupList *textList = [_aryGroup objectAtIndex:tableView.tag];
        int length = 2;
        int loc = (int)indexPath.row * length;
        if (loc + length > textList.rooms.count)
        {
            length = (int)textList.rooms.count - loc;
        }
        NSRange range = NSMakeRange(loc, length);
        NSArray *rowDatas = [textList.rooms subarrayWithRange:range];
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
