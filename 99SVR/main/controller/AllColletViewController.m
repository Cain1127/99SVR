//
//  AllColletViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "AllColletViewController.h"
#import "DoubleView.h"
#import "VideoColletionViewController.h"

@interface AllColletViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    DoubleView *_group;
    UIScrollView *_scrollView;
    int _tag;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    int updateCount;
    int _currentPage;
    UITableView *_tableView;
}

@end

@implementation AllColletViewController

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"收藏"];
    
    [self initUIBody];
}

- (void)initUIBody
{
    NSArray *items = @[@"讲师",@"视频"];
    _group = [[DoubleView alloc] initWithFrame:Rect(0, 64, kScreenWidth, 44) ary:items];
    [self.view addSubview:_group];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:Rect(0,_group.y+_group.height, kScreenWidth, kScreenHeight-_group.y-_group.height)];
    [self.view addSubview:_scrollView];
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.delegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, _scrollView.height)];
    [_scrollView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollView addSubview:_tableView];
    
    VideoColletionViewController *videoView = [[VideoColletionViewController alloc] init];
    videoView.view.frame = Rect(kScreenWidth, 0, kScreenWidth, _scrollView.height);
    [_scrollView addSubview:videoView.view];
    [self addChildViewController:videoView];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth*2,_scrollView.height);
    
    [_group setBtnTag:1 tag:2];
    __weak AllColletViewController *__self = self;
    [_group addEvent:^(id sender)
    {
        [__self btnEvent:sender];
    }];
}

- (void)btnEvent:(id)sender
{
    UIButton *btnSender = sender;
    if(_tag == btnSender.tag)
    {
        return ;
    }
    int tag = (int)btnSender.tag;
    [_group setBtnSelect:tag];
    [_scrollView setContentOffset:CGPointMake((tag-1)*kScreenWidth, 0)];
    _tag = (int)btnSender.tag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_group setBluePointX:scrollView.contentOffset.x];
    int temp = floor((scrollView.contentOffset.x - kScreenWidth/2.0)/kScreenWidth +1);//判断是否翻页
    if (temp != _currentPage)
    {
        if (temp > _currentPage)
        {
            if (_tag<=1)
            {
                _tag ++;
                [_group setBtnSelect:_tag];
            }
        }
        else
        {
            if (_tag>1)
            {
                _tag--;
                [_group setBtnSelect:_tag];
            }
        }
        updateCount++;
        _currentPage = temp;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (updateCount ==1)//正常
    {
        
    }
    {}
    updateCount = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"TextColletionView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    return cell;
}

@end
