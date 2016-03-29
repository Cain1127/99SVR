//
//  HomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HomeViewController.h"
#import "ZLTabBar.h"
#import "NavigationViewController.h"
#import "NSJSONSerialization+RemovingNulls.h"
#import "BaseService.h"
#import "IndexViewController.h"
#import "TeacherModel.h"
#import "TextHomeViewController.h"
#import "HomeTextLivingCell.h"
#import "BannerModel.h"
#import "TextRoomModel.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "SearchController.h"
#import "WonderfullView.h"
#import "RoomHttp.h"
#import "VideoLivingCell.h"
#import "ViewPointCell.h"
#import "RightImageButton.h"

#define kPictureHeight 0.3 * kScreenHeight

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

#pragma mark -
#pragma mark - Banner autoscroll view init
- (void)createScroll
{
    
    if (_scrollView)
    {
        return ;
    }
    
    ///CGRectMake(0.0f, 10 + kNavigationHeight, kScreenWidth, kPictureHeight)
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kPictureHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _scrollView.currentPageDotColor = UIColorFromRGB(0xff7a1e); // 自定义分页控件小圆标颜色
    _scrollView.pageDotColor = UIColorFromRGB(0xa8a8a8);
    _scrollView.autoScrollTimeInterval = 2;
}

- (void)createPage
{
    
}

- (void)initUIBody
{
    
}

#pragma mark -
#pragma mark - viewController life circle
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
    [self initTableView];
    [self initData];
    [self initLivingData];
}

#pragma mark -
#pragma mark - asy load image for image view
- (void)loadImageView
{
    @WeakObj(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          selfWeak.scrollView.imageURLStringsGroup = selfWeak.aryBanner;
    });
}

#pragma mark -
#pragma mark - pop show left menu
- (void)showLeftView
{
    [self leftItemClick];
}

#pragma mark -
#pragma mark - home date init request and analyze
- (void)initData
{
    NSString *strUrl = [[NSString alloc] initWithUTF8String:kHome_Banner_URL];
    @WeakObj(self);
    [BaseService postJSONWithUrl:strUrl parameters:nil success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        NSLog(@":::::::: Banner Data : %@", dict);
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

/**
 *  @author yangshengmeng, 16-03-29 09:03:43
 *
 *  @brief  request home list data
 *
 *  @since  v1.0.0
 */
- (void)initLivingData
{
    __weak HomeViewController *__self = self;
    NSString *requestAPI = @"http://172.16.41.99/test/index.php";
    [BaseService getJSONWithUrl:requestAPI parameters:nil success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
         
         ///check response data
         if (!dict)
         {
             DLog(@"home list data is null. http API: %@", requestAPI);
             return;
         }
         
         if (0 >= [[dict allKeys] count])
         {
             DLog(@"home list data is empty, don't include any data. http API: %@", requestAPI);
             return;
         }
         
         ///reset data model
         if (__self.aryLiving)
         {
             [__self.aryLiving removeAllObjects];
         }
         else
         {
             __self.aryLiving = [NSMutableArray array];
         }
         
         ///check videoroom data
         if ([dict objectForKey:@"videoroom"])
         {
             ///初始化数据模型
             NSArray *roomHttpDictionaryArray = [dict objectForKey:@"videoroom"];
             
             NSMutableArray *roomHttpModelArray = [NSMutableArray array];
             for (int i = 0; i < [roomHttpDictionaryArray count]; i++) {
                 
                 RoomHttp *roomHttpModel = [RoomHttp resultWithDict:roomHttpDictionaryArray[i]];
                 [roomHttpModelArray addObject:roomHttpModel];
                 
             }
             
             [__self.aryLiving addObject:roomHttpModelArray];
         }
         else
         {
             DLog(@"home list data is not include videoroom data. http API: %@", requestAPI);
         }
         
         ///check textroom data
         if ([dict objectForKey:@"textroom"])
         {
             ///初始化数据模型
             NSArray *textRoomModelDictionaryArray = [dict objectForKey:@"textroom"];
             
             NSMutableArray *textRoomModelArray = [NSMutableArray array];
             for (int i = 0; i < [textRoomModelDictionaryArray count]; i++) {
                 
                 TextRoomModel *textRoomModel = [TextRoomModel resultWithDict:textRoomModelDictionaryArray[i]];
                 [textRoomModelArray addObject:textRoomModel];
                 
             }
             
             [__self.aryLiving addObject:textRoomModelArray];
         }
         else
         {
             DLog(@"home list data is not include textroom data. http API: %@", requestAPI);
         }
         
         ///check WonderfullView data
         if ([dict objectForKey:@"viewpoint"])
         {
             ///初始化数据模型
             NSArray *wonderfullViewModelDictionaryArray = [dict objectForKey:@"viewpoint"];
             
             NSMutableArray *wonderfullViewModelArray = [NSMutableArray array];
             for (int i = 0; i < [wonderfullViewModelDictionaryArray count]; i++) {
                 
                 WonderfullView *wonderfullViewModel = [WonderfullView resultWithDict:wonderfullViewModelDictionaryArray[i]];
                 [wonderfullViewModelArray addObject:wonderfullViewModel];
                 
             }
             
             [__self.aryLiving addObject:wonderfullViewModelArray];
         }
         else
         {
             DLog(@"home list data is not include viewpoint data. http API: %@", requestAPI);
         }
         
         ///主线程刷新UI
         if ([NSThread isMainThread])
         {
             
             [__self.tableView reloadData];
             
         }
         else
         {
         
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [__self.tableView reloadData];
                 
             });
         
         }
         
     } fail:nil];
    
}

#pragma mark - 
#pragma mark - UITableView init
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0.0f, 10.0f + kNavigationHeight, kScreenWidth, kScreenHeight - (10.0f + kNavigationHeight + 5.0f + 50.0f)) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _aryLiving.count + 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    ///banner not include any row
    if (0 == section)
    {
        return 0;
    }
    
    if (section <= _aryLiving.count)
    {
        
        if ([_aryLiving[section - 1] isKindOfClass:[NSArray class]] ||
            [_aryLiving[section - 1] isKindOfClass:[NSMutableArray class]])
        {
            
            NSArray *tempArray = _aryLiving[section - 1];
            return tempArray.count;
            
        }
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///判断不同的section数据模型，返回不同的view
    if (indexPath.section > _aryLiving.count)
    {
        
        return [self createDefaultTableViewCell:tableView];
        
    }
    
    if (!([_aryLiving[indexPath.section - 1] isKindOfClass:[NSArray class]]))
    {
        
        return [self createDefaultTableViewCell:tableView];;
        
    }
    
    ///根据对象数组内的类型加载HeaderView
    NSArray *tempArray = _aryLiving[indexPath.section - 1];
    if (0 >= tempArray.count)
    {
        
        return [self createDefaultTableViewCell:tableView];
        
    }
    
    if (indexPath.row >= tempArray.count)
    {
        
        return [self createDefaultTableViewCell:tableView];
        
    }
    
    NSObject *tempObject = tempArray[indexPath.row];
    
    ///视频直播内容
    if ([tempObject isKindOfClass:[RoomHttp class]])
    {
        
        static NSString *vedioCellName = @"vedioCellName";
        VideoLivingCell *tempCell = [_tableView dequeueReusableCellWithIdentifier:vedioCellName];
        if(!tempCell)
        {
            tempCell = [[VideoLivingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vedioCellName];
        }
        [tempCell setVideoLivingRoomModel:(RoomHttp *)tempObject];
        
        return tempCell;
        
    }
    
    ///文字直播内容
    if ([tempObject isKindOfClass:[TextRoomModel class]])
    {
        
        static NSString *textCellName = @"textCellName";
        HomeTextLivingCell *tempCell = [_tableView dequeueReusableCellWithIdentifier:textCellName];
        if(!tempCell)
        {
            tempCell = [[HomeTextLivingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellName];
        }
        [tempCell setTextRoomModel:(TextRoomModel *)tempObject];
        
        return tempCell;
        
    }
    
    ///精彩视点
    if ([tempObject isKindOfClass:[WonderfullView class]])
    {
        
        static NSString *viewPointCellName = @"viewPointCellName";
        ViewPointCell *tempCell = [_tableView dequeueReusableCellWithIdentifier:viewPointCellName];
        if(!tempCell)
        {
            tempCell = [[ViewPointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:viewPointCellName];
        }
        [tempCell setViewPointModel:(WonderfullView *)tempObject];
        
        return tempCell;
        
    }
    
    return [self createDefaultTableViewCell:tableView];
}

/**
 *  @author yangshengmeng, 16-03-29 13:03:16
 *
 *  @brief  用来生成暂时的系统cell
 *
 *  @return 返回一个无任何内容的系统cell
 *
 *  @since  v1.0.0
 */
- (UITableViewCell *)createDefaultTableViewCell:(UITableView *)tableView
{

    static NSString *defaultCell = @"defaultCellName";
    UITableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    if (tempCell)
    {
        
        tempCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCell];
        
    }
    
    return tempCell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    ///banner
    if (0 == section)
    {
        
        return _scrollView;
        
    }

    ///判断不同的section数据模型，返回不同的view
    if (section > _aryLiving.count)
    {
        
        return nil;
        
    }
    
    if (!([_aryLiving[section - 1] isKindOfClass:[NSArray class]]))
    {
        
        return nil;
        
    }
    
    ///根据对象数组内的类型加载HeaderView
    NSArray *tempArray = _aryLiving[section - 1];
    if (0 >= tempArray.count)
    {
        
        return nil;
        
    }
    
    NSObject *tempObject = tempArray[0];
    CGFloat tempHeight = 44.0f;
    CGFloat rightButtonWidth = 140.0f;
    
    ///视频直播内容
    if ([tempObject isKindOfClass:[RoomHttp class]])
    {
        
        static NSString *vedioHeaderViewName = @"vedioHeaderViewName";
        UIView *tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:vedioHeaderViewName];
        if (!tempHeaderView)
        {
            
            tempHeaderView = [[UIView alloc] initWithFrame:Rect(0.0f, 0.0f, CGRectGetWidth(tableView.frame), tempHeight)];
            
            ///title label
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f, CGRectGetWidth(tempHeaderView.frame) - rightButtonWidth - 30.0f, tempHeight)];
            [lblHot setText:@"视频直播"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x0078DD)];
            lblHot.textAlignment = NSTextAlignmentLeft;
            [tempHeaderView addSubview:lblHot];
            
            ///see all button
            @WeakObj(self);
            RightImageButton *seeAllButton = [[RightImageButton alloc] initWithFrame:Rect(CGRectGetWidth(tempHeaderView.frame) - 15.0f - rightButtonWidth, 0.0f, rightButtonWidth, tempHeight) rightImageWidth:30.0f tapActionBlock:^(UIButton *button) {
                
                UITabBarController *rootTabbarVC = selfWeak.tabBarController;
                if (rootTabbarVC)
                {
                    rootTabbarVC.selectedIndex = 1;
                }
                
            }];
            [seeAllButton setTitle:@"查看全部" forState:UIControlStateNormal];
            [seeAllButton setTitleColor:UIColorFromRGB(0x0078DD) forState:UIControlStateNormal];
            seeAllButton.titleLabel.font = XCFONT(12);
            [seeAllButton setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [tempHeaderView addSubview:seeAllButton];
            
        }
        
        return tempHeaderView;
        
    }
    
    ///文字直播内容
    if ([tempObject isKindOfClass:[TextRoomModel class]])
    {
        
        static NSString *textHeaderViewName = @"textHeaderViewName";
        UIView *tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:textHeaderViewName];
        if (!tempHeaderView)
        {
            
            tempHeaderView = [[UIView alloc] initWithFrame:Rect(0.0f, 0.0f, CGRectGetWidth(tableView.frame), tempHeight)];
            
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f, CGRectGetWidth(tempHeaderView.frame) - rightButtonWidth - 30.0f, tempHeight)];
            [lblHot setText:@"文字直播"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x0078DD)];
            [tempHeaderView addSubview:lblHot];
            
            ///see all button
            @WeakObj(self);
            RightImageButton *seeAllButton = [[RightImageButton alloc] initWithFrame:Rect(CGRectGetWidth(tempHeaderView.frame) - 15.0f - rightButtonWidth, 0.0f, rightButtonWidth, tempHeight) rightImageWidth:30.0f tapActionBlock:^(UIButton *button) {
                
                UITabBarController *rootTabbarVC = selfWeak.tabBarController;
                if (rootTabbarVC)
                {
                    rootTabbarVC.selectedIndex = 2;
                }
                
            }];
            [seeAllButton setTitle:@"查看全部" forState:UIControlStateNormal];
            [seeAllButton setTitleColor:UIColorFromRGB(0x0078DD) forState:UIControlStateNormal];
            seeAllButton.titleLabel.font = XCFONT(12);
            [seeAllButton setImage:[UIImage imageNamed:@"home_seeall_arrow"] forState:UIControlStateNormal];
            [tempHeaderView addSubview:seeAllButton];
            
        }
        
        return tempHeaderView;
        
    }
    
    ///精彩视点
    if ([tempObject isKindOfClass:[WonderfullView class]])
    {
        
        static NSString *viewPointHeaderViewName = @"viewPointHeaderViewName";
        UIView *tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewPointHeaderViewName];
        if (!tempHeaderView)
        {
            
            tempHeaderView = [[UIView alloc] initWithFrame:Rect(0.0f, 0.0f, CGRectGetWidth(tableView.frame), tempHeight)];
            
            UILabel *lblHot = [[UILabel alloc] initWithFrame:Rect(15.0f, 0.0f, CGRectGetWidth(tempHeaderView.frame) - 30.0f, tempHeight)];
            [lblHot setText:@"精彩观点"];
            [lblHot setFont:XCFONT(15)];
            [lblHot setTextColor:UIColorFromRGB(0x0078DD)];
            [tempHeaderView addSubview:lblHot];
            
            UILabel *line = [[UILabel alloc] initWithFrame:Rect(0.0f, CGRectGetHeight(tempHeaderView.frame) - 0.5f, kScreenWidth, 0.5f)];
            [line setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
            [tempHeaderView addSubview:line];
            
        }
        
        return tempHeaderView;
        
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"::::::::::tap cell: %@", indexPath);
//    TextRoomModel *model = [_aryLiving objectAtIndex:indexPath.row];
//    TextHomeViewController *textHome = [[TextHomeViewController alloc] initWithModel:model];
//    [self presentViewController:textHome animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //banner height
    if (0 == indexPath.section)
    {
        
        return 0.0f;
        
    }
    
    ///判断不同的section数据模型，返回不同的view
    if (indexPath.section > _aryLiving.count)
    {
        
        return 0.0f;
        
    }
    
    if (!([_aryLiving[indexPath.section - 1] isKindOfClass:[NSArray class]]))
    {
        
        return 0.0f;
        
    }
    
    ///根据对象数组内的类型加载HeaderView
    NSArray *tempArray = _aryLiving[indexPath.section - 1];
    if (0 >= tempArray.count)
    {
        
        return 0.0f;
        
    }
    
    NSObject *tempObject = tempArray[0];
    if ([tempObject isKindOfClass:[RoomHttp class]] ||
        [tempObject isKindOfClass:[TextRoomModel class]])
    {
        
        return 155.0f + 10.0f;
        
    }
    
    return 100.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    //banner height
    if (0 == section)
    {
        
        return kPictureHeight;
        
    }

    return 44.0f;

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
