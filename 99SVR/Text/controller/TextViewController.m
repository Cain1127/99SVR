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
#import "TextGroupList.h"

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

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryHot;
@property (nonatomic,copy) NSArray *aryLiving;
@property (nonatomic,strong) UIScrollView *scrollHeader;
@property (nonatomic,strong) NSMutableArray *aryGroup;

@end

@implementation TextViewController

- (void)initHeadScroller
{
    _scrollHeader = [[UIScrollView alloc] initWithFrame:Rect(0, 64, kScreenWidth, 46)];
    [self.view addSubview:_scrollHeader];
    _scrollHeader.clipsToBounds = YES;
    _scrollHeader.pagingEnabled = YES;
    _scrollHeader.showsHorizontalScrollIndicator = NO;
    _scrollHeader.showsVerticalScrollIndicator = NO;
    _scrollHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollHeader.contentSize = CGSizeMake(0, 46);
    
    CGSize sizeWidth = [@"视频直播间" sizeWithAttributes:@{NSFontAttributeName:XCFONT(15)}];
    fWidth = sizeWidth.width;
}

- (void)settingTextGroup
{
    __weak TextViewController *__self = self;
    __weak UILabel *__line1 = _line1;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        int i=0;
        for (TextGroupList *textList in __self.aryGroup)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:textList.gname forState:UIControlStateNormal];
            UIColor *titleColor = [UIColor colorWithHex:@"#555555"];
            UIColor *selectedColor = [UIColor colorWithHex:@"#427ede"];
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            [btn setTitleColor:selectedColor forState:UIControlStateHighlighted];
            [btn setTitleColor:selectedColor forState:UIControlStateSelected];
            btn.titleLabel.font = XCFONT(14);
            btn.frame = Rect(__self.scrollHeader.contentSize.width,0, fWidth, 44);
            [__self.scrollHeader addSubview:btn];
            __self.scrollHeader.contentSize = CGSizeMake(btn.x+btn.width, 44);
            btn.tag = i;
            i++;
            [btn addTarget:__self action:@selector(selectTabButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        [__self.scrollHeader addSubview:__line1];
        __line1.frame = Rect(0, 44, fWidth, 2);
        
        NSInteger tag = 0;
        int  nCount = (int)[_aryGroup count];
        for (tag = 0 ; tag<nCount;tag++)
        {
            UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(tag*kScreenWidth,0,kScreenWidth,__self.scrollView.height)];
            tableView.tag = tag;
            tableView.delegate = __self;
            tableView.dataSource = __self;
            [__self.scrollView addSubview:tableView];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [tableView reloadData];
        }
        __self.scrollView.contentSize = CGSizeMake(kScreenWidth * nCount,__self.scrollView.height);
        [__self setSelectInfo:0];
    });
}

- (void)setSelectInfo:(NSInteger)tag
{
    for (UIButton *btn in _scrollHeader.subviews)
    {
        if (![btn isKindOfClass:[UIButton class]])
        {
            continue;
        }
        if(btn.tag == tag)
        {
            btn.selected = YES;
        }
        else
        {
            if(btn.selected)
            {
                btn.selected = NO;
            }
        }
    }
}

- (void)selectTabButton:(UIButton *)btn
{
    for (UIView *sender in _scrollHeader.subviews)
    {
        if([sender isKindOfClass:[UIButton class]])
        {
            [(UIButton *)sender setSelected:NO];
        }
    }
    [btn setSelected:YES];
    _tag = (int)btn.tag;
    [_scrollView setContentOffset:CGPointMake(btn.tag*kScreenWidth, 0)];
    [self setBluePointX:_scrollView.contentOffset.x];
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _aryGroup = [NSMutableArray array];
    [self setTitleText:@"文字直播"];
    [self initHeadScroller];
    [self initUIHead];
    _line1 = [UILabel new];
    _line1.backgroundColor = UIColorFromRGB(0x629aff);
    [_line1 setFrame:Rect(0,2,fWidth,2)];
    
    [self initScrollView];
    [self initLivingData];
}

- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, 110, kScreenWidth,kScreenHeight - 160)];
    [self.view addSubview:_scrollView];
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight - 110);
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
    __weak TextViewController *__self = self;
    [rightBtn clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        [__self initLivingData];
    }];
    [self setRightBtn:rightBtn];
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
        return textList.rooms.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellIdentifier = @"TextLivingIdentifier";
    TextLivingCell *cell = [_tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if(cell==nil)
    {
        cell = [[TextLivingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIdentifier];
    }
    if(_aryGroup.count > tableView.tag)
    {
        TextGroupList *textList = [_aryGroup objectAtIndex:tableView.tag];
        TextRoomModel *model = [textList.rooms objectAtIndex:indexPath.row];
        [cell setTextRoomModel:model];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_aryGroup.count > tableView.tag)
    {
        TextGroupList *textList = [_aryGroup objectAtIndex:tableView.tag];
        TextRoomModel *teach = [textList.rooms objectAtIndex:indexPath.row];
        TextHomeViewController *textHome = [[TextHomeViewController alloc] initWithModel:teach];
        [self presentViewController:textHome animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView)
    {
        return ;
    }
    //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView != _scrollView)
    {
        return ;
    }
    //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView || (willEndContentOffsetX == 0 && startContentOffsetX ==0) )
    {
        return ;
    }
    [self setBluePointX:scrollView.contentOffset.x];
    int temp = floor((scrollView.contentOffset.x - kScreenWidth/2.0)/kScreenWidth +1);//判断是否翻页
    if (temp != _currentPage)
    {
        if (temp > _currentPage)
        {
            if (_tag<_aryGroup.count)
            {
                _tag ++;
                [self setSelectInfo:_tag];
                CGFloat x = (_scrollHeader.contentOffset.x+fWidth*0.5+kScreenWidth) >= _scrollHeader.contentSize.width ? _scrollHeader.contentSize.width-kScreenWidth : (_scrollHeader.contentOffset.x+fWidth*0.5);
                
                _scrollHeader.contentOffset = CGPointMake(x, 0);
            }
        }
        else
        {
            if (_tag>=1)
            {
                _tag--;
                [self setSelectInfo:_tag];
                CGFloat x = (_scrollHeader.contentOffset.x-fWidth*0.5) <= 0 ? 0 : (_scrollHeader.contentOffset.x-fWidth*0.5);
                _scrollHeader.contentOffset = CGPointMake(x, 0);
            }
        }
        updateCount++;
        _currentPage = temp;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView)
    {
        return ;
    }
    if (updateCount ==1)//正常
    {
        
    }
    else if(updateCount==0 && _currentPage ==0)
    {
    }
    updateCount = 0;
    startContentOffsetX = 0;
    willEndContentOffsetX = 0;
}

- (void)setBluePointX:(CGFloat)fPointX
{
    CGFloat fx = fPointX/kScreenWidth * fWidth;
    [_line1 setFrame:Rect(fx,44,fWidth,2)];
}


@end
