//
//  TextViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextViewController.h"
#import "HotTextView.h"
#import "TeacherModel.h"
#import "TextHomeViewController.h"

@interface TextViewController ()<UITableViewDataSource,UITableViewDelegate,HotTeachDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryHot;

@end

@implementation TextViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-50)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitleText:@"文字直播"];
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<2; i++)
    {
        TeacherModel *model = [[TeacherModel alloc] init];
        model.strImg=@"";
        model.strName = @"帅哥";
        model.strContent = @"投资市场人才辈出，各领风骚载！他一历经多年钻石，鹤立鸡群，他...";
        model.nThum = 200;
        [array addObject:model];
    }
    _aryHot = array;
    [self initUIHead];
    [self initScrollView];
}

- (void)initScrollView
{
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
    {}];
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
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, _scrollView.y+_scrollView.height+5, kScreenWidth, 320)];
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark hotViewDelegate
- (void)clickTeach:(TeacherModel *)teach
{
    TextHomeViewController *textHome = [[TextHomeViewController alloc] init];
    [self presentViewController:textHome animated:YES completion:nil];
}

@end
