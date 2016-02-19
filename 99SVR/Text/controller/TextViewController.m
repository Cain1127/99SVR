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
#import "TeacherModel.h"
#import "TextHomeViewController.h"
#import "TextLivingCell.h"

@interface TextViewController ()<UITableViewDataSource,UITableViewDelegate,HotTeachDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryHot;
@property (nonatomic,copy) NSArray *aryLiving;

@end

@implementation TextViewController

//- (void)initLivingData
//{
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i=0; i<10; i++)
//    {
//        TeacherModel *model = [[TeacherModel alloc] init];
//        model.strImg=@"";
//        model.strName = @"帅哥";
//        model.strContent = @"投资市场人才辈出，各领风骚载！他一历经多年钻石，鹤立鸡群，他...";
//        model.zans = 200;
//        [array addObject:model];
//    }
//    _aryLiving = array;
//}

- (void)initLivingData
{
     __weak TextViewController *__self = self;
     [BaseService postJSONWithUrl:@"http://172.16.41.99/test/test.php?act=script" parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitleText:@"文字直播"];
    [self initLivingData];
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<2; i++)
    {
        TeacherModel *model = [[TeacherModel alloc] init];
        model.strImg=@"";
        model.strName = @"帅哥";
        model.strContent = @"投资市场人才辈出，各领风骚载！他一历经多年钻石，鹤立鸡群，他...";
        model.zans = 200;
        [array addObject:model];
    }
    _aryHot = array;
    [self initUIHead];
    [self initScrollView];
}

- (void)initScrollView
{
/*
    UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(8, 74, kScreenWidth, 20)];
    [lblHot setText:@"热门讲师"];
    [lblHot setFont:XCFONT(15)];
    [lblHot setTextColor:UIColorFromRGB(0x427ede)];
    [self.view addSubview:lblHot];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, lblHot.y+lblHot.height+10, kScreenWidth, (kScreenWidth/2+80)*(_aryHot.count/2))];
    [self.view addSubview:_scrollView];
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.contentSize = CGSizeMake(kScreenWidth,(kScreenWidth/2+70)*(_aryHot.count/2));
    [self initWithHot];
*/
    [self initTableView];
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
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightBtn clickWithBlock:^(UIGestureRecognizer *gesture)
    {
    
    }];
    [self setRightBtn:rightBtn];
}

- (void)initWithHot
{
    int nX,nY;
    int nWidth = kScreenWidth/2;
    int nHeight = (kScreenWidth/2+80);
    for (int i=0;i<_aryHot.count; i++)
    {
        nX = i%2*kScreenWidth/2;
        nY = i/2*(kScreenWidth/2+80);
        HotTextView *hotView = [[HotTextView alloc] initWithFrame:Rect(nX, nY,nWidth,nHeight)];
        [_scrollView addSubview:hotView];
        [hotView setHotText:[_aryHot objectAtIndex:i]];
        hotView.delegate = self;
    }
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
    TextRoomModel *teach = [_aryLiving objectAtIndex:indexPath.row];
    TextHomeViewController *textHome = [[TextHomeViewController alloc] initWithModel:teach];
    [self presentViewController:textHome animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
