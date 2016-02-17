//
//  TextHomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextHomeViewController.h"
#import "RightView.h"
#import "GroupView.h"
#import "TeacherModel.h"
#import "ThumButton.h"
#import "TextTcpSocket.h"
#import "TextChatViewController.h"
#import "TextLiveViewController.h"
#import "TextNewViewController.h"

@interface TextHomeViewController ()<UIScrollViewDelegate,RightViewDelegate>
{
    NSInteger _tag;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    int updateCount;
    int _currentPage;
    int32_t _roomId;
    UIView *hidenView;
}
@property (nonatomic,strong) RightView *rightView;
@property (nonatomic,strong) ThumButton *btnTitle;
@property (nonatomic,strong) GroupView *group;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) TextTcpSocket *textSocket;
@property (nonatomic,strong) UIView *headView;
@end

@implementation TextHomeViewController


- (id)initWithRoom:(int32_t)roomid
{
    if(self = [super init])
    {
        _textSocket = [[TextTcpSocket alloc] init];
        _roomId = roomid;
        return self;
    }
    return nil;
}

- (void)refreshBtnTitle
{
    CGSize size = [_btnTitle.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:XCFONT(16)}];
    CGFloat width = size.width+49;
    _btnTitle.frame = Rect(kScreenWidth/2-width/2, 20, width, 44);
}

- (void)initWithRightView
{
    
}

- (void)initUIHead
{
    _headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = kNavColor;
    
    _btnTitle = [[ThumButton alloc] initWithFrame:Rect(kScreenWidth/2-50, 20, 100, 44) size:40 fontSize:16];
    [_btnTitle setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [_btnTitle setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_btnTitle setTitle:@"讲师" forState:UIControlStateNormal];
    [_headView addSubview:_btnTitle];
    _btnTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnTitle.titleLabel.font = XCFONT(16);
    
    [self refreshBtnTitle];
    
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
    
    TextLiveViewController *textLive = [[TextLiveViewController alloc] initWithSocket:_textSocket];
    TextChatViewController *textChat = [[TextChatViewController alloc] initWithSocket:_textSocket];
    TextNewViewController *textNew = [[TextNewViewController alloc] initWithSocket:_textSocket];
   
    [self addChildViewController:textLive];
    [self addChildViewController:textChat];
    [self addChildViewController:textNew];
    
    textLive.view.frame = Rect(0, 0, kScreenWidth,_scrollView.height);
    textChat.view.frame = Rect(kScreenWidth, 0, kScreenWidth, _scrollView.height);
    textNew.view.frame  = Rect(kScreenWidth*2, 0, kScreenWidth, _scrollView.height);

    [_scrollView addSubview:textLive.view];
    [_scrollView addSubview:textChat.view];
    [_scrollView addSubview:textNew.view];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth*3, _scrollView.height);
    
    _tag = 0;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [_headView addSubview:leftBtn];
    leftBtn.frame = Rect(0, 20, 44, 44);
    [leftBtn addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    hidenView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:hidenView];
    hidenView.hidden = YES;
    
    _rightView = [[RightView alloc] initWithFrame:Rect(kScreenWidth-153, 64, 145, 133)];
    [hidenView addSubview:_rightView];
    _rightView.hidden = YES;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"text_more_h"] forState:UIControlStateHighlighted];
    [rightBtn setImage:[UIImage imageNamed:@"text_more"] forState:UIControlStateNormal];
    
    __weak TextHomeViewController *__self = self;
    __weak UIView *__hidnView = hidenView;
    
    [hidenView clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        __hidnView.hidden = YES;
        __self.rightView.hidden = YES;
    }];
    
    [rightBtn clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        hidenView.hidden = NO;
        __self.rightView.hidden = NO;
    }];
    
    [_headView addSubview:rightBtn];
    rightBtn.frame = Rect(kScreenWidth-50, 20, 44, 44);
}

- (void)navBack
{
    [_textSocket exitRoom];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_textSocket connectRoom:_roomId];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTeacherInfo) name:MESSAGE_TEXT_TEACHER_INFO_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reconnectTextRoom) name:MESSAGE_RECONNECT_TIMER_VC object:nil];
}

- (void)reconnectTextRoom
{
    [_textSocket reconnectTextRoom];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateTeacherInfo
{
    __weak TextHomeViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.btnTitle setTitle:_textSocket.teacher.strName forState:UIControlStateNormal];
        [__self refreshBtnTitle];
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)rightView:(RightView *)rightView index:(NSInteger)nNumber
{
    switch (nNumber) {
        case 1:
           //关注
            [self sendCollet];
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
}

- (void)sendCollet
{
    [_textSocket reqTeacherCollet];
}

- (void)gotoTextTodayVI
{
//    [_textSocket req];
    
}

- (void)gotoHistory
{
    
}

@end
