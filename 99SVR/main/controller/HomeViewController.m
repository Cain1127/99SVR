//
//  HomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HomeViewController.h"
#import "ZLTabBar.h"
#import "BaseService.h"
#import "IndexViewController.h"
#import "TeacherModel.h"
#import "TextHomeViewController.h"
#import "TextLivingCell.h"
#import "TextRoomModel.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *aryLiving;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitleText:@"首页"];
    [self initUIHead];
    [self initTableView];
    [self initLivingData];
}

- (void)initUIHead
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"switcher"] forState:UIControlStateNormal];
    [leftBtn clickWithBlock:^(UIGestureRecognizer *gesture)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SHOW_LEFT_VC object:nil];
     }];
    [self setLeftBtn:leftBtn];
}

- (void)initUIBody
{
    
}

- (void)initLivingData
{
    __weak HomeViewController *__self = self;
    [BaseService postJSONWithUrl:@"http://172.16.41.99/test/test.php?act=script" parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         if (dict && [dict objectForKey:@"groups"])
         {
             NSMutableArray *array = [NSMutableArray array];
             NSArray *aryResult = [dict objectForKey:@"groups"];
             for (NSDictionary *roomDict in aryResult)
             {
                 if ([roomDict objectForKey:@"rooms"])
                 {
                     NSArray *aryRoom = [roomDict objectForKey:@"rooms"];
                     for (NSDictionary *textRoom in aryRoom) {
                         TextRoomModel *room = [TextRoomModel resultWithDict:textRoom];
                         [array addObject:room];
                     }
                 }
             }
             __self.aryLiving = array;
         }
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            [__self.tableView reloadData];
                        });
     } fail:nil];
}

- (void)initTableView
{
    UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(8,70, kScreenWidth, 20)];
    [lblHot setText:@"正在直播"];
    [lblHot setFont:XCFONT(15)];
    [lblHot setTextColor:UIColorFromRGB(0x427ede)];
    [self.view addSubview:lblHot];
    
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(8,92, kScreenWidth-16, 0.5)];
    [self.view addSubview:line];
    [line setBackgroundColor:kLineColor];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, lblHot.y+lblHot.height+5, kScreenWidth,kScreenHeight-(lblHot.y+lblHot.height+5+50))];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryLiving.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellIdentifier = @"TextLivingIdentifier";
    TextLivingCell *cell = [_tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if(cell==nil)
    {
        cell = [[TextLivingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIdentifier];
    }
    TextRoomModel *model = [_aryLiving objectAtIndex:indexPath.row];
    [cell setTextRoomModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TextRoomModel *model = [_aryLiving objectAtIndex:indexPath.row];
    TextHomeViewController *textHome = [[TextHomeViewController alloc] initWithModel:model];
    [self presentViewController:textHome animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark hotViewDelegate
- (void)clickTeach:(TeacherModel *)teach
{
    TextHomeViewController *textHome = [[TextHomeViewController alloc] initWithRoom:80001];
    [self presentViewController:textHome animated:YES completion:nil];
}

@end
