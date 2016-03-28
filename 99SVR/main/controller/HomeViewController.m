//
//  HomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HomeViewController.h"
#import "ZLTabBar.h"
#import "NSJSONSerialization+RemovingNulls.h"
#import "BaseService.h"
#import "IndexViewController.h"
#import "TeacherModel.h"
#import "TextHomeViewController.h"
#import "TextLivingCell.h"
#import "BannerModel.h"
#import "TextRoomModel.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "SearchController.h"

#define kPictureHeight 0.3*kScreenHeight

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
    
}
@property (nonatomic,strong) NSMutableArray *aryBanner;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *aryLiving;
@property (nonatomic,copy) NSTimer *timer;
@property (nonatomic,strong) SDCycleScrollView *scrollView;

@end

@implementation HomeViewController

- (void)createScroll
{
    if (_scrollView) {
        return ;
    }
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 10+kNavigationHeight, kScreenWidth, kPictureHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _scrollView.currentPageDotColor = UIColorFromRGB(0xff7a1e); // 自定义分页控件小圆标颜色
    _scrollView.pageDotColor = UIColorFromRGB(0xa8a8a8);
    [self.view addSubview:_scrollView];
    _scrollView.autoScrollTimeInterval = 2;
}

- (void)createPage
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _aryBanner = [NSMutableArray array];
    [self createScroll];
    [self createPage];
    [self initData];
}

- (void)loadImageView
{
    @WeakObj(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          selfWeak.scrollView.imageURLStringsGroup = selfWeak.aryBanner;
    });
}
- (void)showLeftView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SHOW_LEFT_VC object:nil];
}

- (void)initData
{
    NSString *strUrl = [[NSString alloc] initWithUTF8String:kHome_Banner_URL];
//    __weak HomeViewController *__self = self;
    @WeakObj(self);
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        if ([dict objectForKey:@"banner"]) {
            NSArray *array = [dict objectForKey:@"banner"];
            for (NSDictionary *param in array) {
                BannerModel *model = [BannerModel resultWithDict:param];
                [selfWeak.aryBanner addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfWeak loadImageView];
            });
        }
    } fail:^(NSError *error) {
        
    }];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
