//
//  TextHomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextHomeViewController.h"
#import "GroupView.h"
#import "TextChatViewController.h"
#import "TextLiveViewController.h"
#import "TextNewViewController.h"

@interface TextHomeViewController ()<UIScrollViewDelegate>
{
    NSInteger _tag;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    int updateCount;
    int _currentPage;
}

@property (nonatomic,strong) GroupView *group;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation TextHomeViewController

- (void)initUIHead
{
    NSArray *aryMen = @[@"直播",@"聊天",@"观点"];
    _group = [[GroupView alloc] initWithFrame:Rect(0, 64, kScreenWidth, 44) ary:aryMen];
    [self.view addSubview:_group];
    [_group setBtnTag:1 tag1:2 tag2:3];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:Rect(0,_group.y+_group.height,
                                kScreenWidth, kScreenHeight-_group.y-_group.height)];
    [self.view addSubview:_scrollView];
    
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.userInteractionEnabled = YES; 
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.delegate = self;
    
    TextLiveViewController *textLive = [[TextLiveViewController alloc] init];
    TextChatViewController *textChat = [[TextChatViewController alloc] init];
    TextNewViewController *textNew = [[TextNewViewController alloc] init];
   
    [self addChildViewController:textLive];
    [self addChildViewController:textChat];
    [self addChildViewController:textNew];
    
    textLive.view.frame = Rect(0, 0, kScreenWidth,_scrollView.height);
    textChat.view.frame = Rect(kScreenWidth, 0, kScreenWidth, _scrollView.height);
    textNew.view.frame = Rect(kScreenWidth*2, 0, kScreenWidth, _scrollView.height);
    
    [_scrollView addSubview:textLive.view];
    [_scrollView addSubview:textChat.view];
    [_scrollView addSubview:textNew.view];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth*3, _scrollView.height);
    
    _tag = 0;
    
    __weak TextHomeViewController *__self = self;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [leftBtn clickWithBlock:^(UIGestureRecognizer *gesture)
     {
         [__self dismissViewControllerAnimated:YES completion:nil];
     }];
    [self setLeftBtn:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightBtn clickWithBlock:^(UIGestureRecognizer *gesture) {
        
    }];
    [self setRightBtn:rightBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    
    __weak TextHomeViewController *__self = self;
    [_group addEvent:^(id sender)
     {
         [__self btnEvent:sender];
     }];
    UIButton *btnSender = [_group viewWithTag:1];
    [self btnEvent:btnSender];
}

- (void)btnEvent:(id)sender
{
    UIButton *btnSender = sender;
    if(_tag == btnSender.tag)
    {
        return ;
    }
    [_group setBtnSelect:btnSender.tag];
    [_scrollView setContentOffset:CGPointMake((btnSender.tag-1)*kScreenWidth, 0)];
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
            if (_tag<=2)
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
    else if(updateCount==0 && _currentPage ==0)
    {
        if (_tag==1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SHOW_LEFT_VC object:nil];
        }
    }
    else//加速
    {}
    updateCount = 0;
}


@end
