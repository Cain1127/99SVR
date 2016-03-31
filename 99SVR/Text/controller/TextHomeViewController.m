//
//  TextHomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextHomeViewController.h"
#import "RightView.h"
#import "TextEsotericaViewController.h"
#import "TeachView.h"
#import "TextHistoryViewController.h"
#import "UIButton+WebCache.h"
#import "UIImage+WebP.h"
#import "GroupView.h"
#import "TeacherModel.h"
#import "ThumButton.h"
#import "TextTcpSocket.h"
#import "TextRoomModel.h"
#import "TextChatViewController.h"
#import "TextLiveViewController.h"
#import "Toast+UIView.h"
#import "TextNewViewController.h"
#import "BaseService.h"
#import "TextRoomModel.h"
#import "TextTodayVPViewController.h"
#import "MyScrollView.h"

@interface TextHomeViewController ()<UIScrollViewDelegate,RightViewDelegate,GroupDelegate>
{
    NSInteger _tag;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    int updateCount;
    int _currentPage;
    int32_t _roomId;
    UIView *hidenView;
    TeachView *_teachView;
}
@property (nonatomic,strong) RightView *rightView;
@property (nonatomic,strong) ThumButton *btnTitle;
@property (nonatomic,strong) GroupView *group;
@property (nonatomic,strong) MyScrollView *scrollView;
@property (nonatomic,strong) TextTcpSocket *textSocket;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) TextRoomModel *model;


@end

@implementation TextHomeViewController

- (id)initWithModel:(TextRoomModel *)model
{
    if (self = [super init])
    {
        _model = model;
        _textSocket = [[TextTcpSocket alloc] init];
        return self;
    }
    return nil;
}

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

- (void)showTeacherView
{
    hidenView.hidden = NO;
    _teachView.hidden = NO;
}

- (void)initUIHead
{
    _headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = kNavColor;
    _btnTitle = [[ThumButton alloc] initWithFrame:Rect(kScreenWidth/2-50, 20, 100, 44) size:40 fontSize:16];
    [_btnTitle setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    if (_model)
    {
        NSString *url = [NSString stringWithFormat:@"%@%@",kImage_TEXT_URL,_model.teacherid];
        [_btnTitle setTitle:_model.roomname forState:UIControlStateNormal];
        [_btnTitle sd_setImageWithURL:[NSURL URLWithString:url]
                             forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    else
    {
        [_btnTitle setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
        [_btnTitle setTitle:@"讲师" forState:UIControlStateNormal];
    }
    _btnTitle.imageView.layer.masksToBounds = YES;
    _btnTitle.imageView.layer.cornerRadius = 20;
    [_headView addSubview:_btnTitle];
    _btnTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnTitle.titleLabel.font = XCFONT(16);
    [self refreshBtnTitle];
    [_btnTitle addTarget:self action:@selector(showTeacherView) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *aryMen = @[@"直播",@"聊天",@"观点",@"个人秘籍"];
    _group = [[GroupView alloc] initWithFrame:Rect(0, 64, kScreenWidth, 44) ary:aryMen];
    [self.view addSubview:_group];
    _group.delegate = self;
    
    _scrollView = [[MyScrollView alloc] initWithFrame:Rect(0,_group.y+_group.height,
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
    TextEsotericaViewController *esoster = [[TextEsotericaViewController alloc] initWithSocket:_textSocket];
    
    [self addChildViewController:textLive];
    [self addChildViewController:textChat];
    [self addChildViewController:textNew];
    [self addChildViewController:esoster];
    
    textLive.view.frame = Rect(0, 0, kScreenWidth,_scrollView.height);
    textChat.view.frame = Rect(kScreenWidth, 0, kScreenWidth, _scrollView.height);
    textNew.view.frame  = Rect(kScreenWidth*2, 0, kScreenWidth, _scrollView.height);
    esoster.view.frame = Rect(kScreenWidth*3, 0, kScreenWidth, _scrollView.height);
    
    [_scrollView addSubview:textLive.view];
    [_scrollView addSubview:textChat.view];
    [_scrollView addSubview:textNew.view];
    [_scrollView addSubview:esoster.view];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth*4, _scrollView.height);
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
    
    _teachView = [[TeachView alloc] initWithFrame:Rect(0, 66, kScreenWidth,140)];
    [hidenView addSubview:_teachView];
    _teachView.hidden = YES;
    
    _rightView = [[RightView alloc] initWithFrame:Rect(kScreenWidth-153, 66, 145, 133)];
    [hidenView addSubview:_rightView];
    _rightView.hidden = YES;
    _rightView.delegate = self;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"text_more_h"] forState:UIControlStateHighlighted];
    [rightBtn setImage:[UIImage imageNamed:@"text_more"] forState:UIControlStateNormal];
    
    __weak TextHomeViewController *__self = self;
    __weak UIView *__hidnView = hidenView;
    __weak TeachView *__teachView = _teachView;
    [hidenView clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        __hidnView.hidden = YES;
        __teachView.hidden = YES;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_model)
    {
        [_textSocket connectRoom:[_model.nvcbid intValue]];
    }
    else
    {
        [_textSocket connectRoom:_roomId];
    }
    [self initUIHead];
//    __weak TextHomeViewController *__self = self;
//    [_group addEvent:^(id sender)
//     {
//         [__self btnEvent:sender];
//     }];
    UIButton *btnSender = [_group viewWithTag:1];
    [self btnEvent:btnSender];
}


- (void)clickIndex:(UIButton *)btn tag:(NSInteger)tag
{
    [self btnEvent:btn];
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
            if (_tag<4)
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

- (void)respCollet:(NSNotification *)notify
{
    NSDictionary *dictObj = [notify object];
    NSString *oper = @"取消关注";
    if ([[dictObj objectForKey:@"opertype"] isEqualToString:@"1"])//关注
    {
        oper = @"关注";
    }
    NSString *result = @"失败";
    if ([[dictObj objectForKey:@"result"] isEqualToString:@"1"])
    {
        result = @"成功";
    }
    __weak TextHomeViewController *__self = self;
    __weak NSString *__oper = oper;
    __weak NSString *__result = result;
    __weak RightView *__rightView = _rightView;
    dispatch_async(dispatch_get_main_queue(),
   ^{
       [__self.view makeToast:[NSString stringWithFormat:@"%@%@",__oper,__result]];
       if ([__result isEqualToString:@"成功"])
       {
           if([__oper isEqualToString:@"关注"])
           {
               __rightView.btnFirst.selected = YES;
           }
           else
           {
              __rightView.btnFirst.selected = NO;
           }
       }
   });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTeacherInfo) name:MESSAGE_TEXT_TEACHER_INFO_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reconnectTextRoom) name:MESSAGE_RECONNECT_TIMER_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respCollet:) name:MESSAGE_TEXT_COLLET_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showJoinErr:) name:MESSAGE_TEXT_JOIN_ROOM_ERR_VC object:nil];
}

- (void)showJoinErr:(NSNotification *)notify
{
    if (notify.object)
    {
        NSString *strMsg = notify.object;
        DLog(@"strMsg:%@",strMsg);
        __block NSString *__strMsg = strMsg;
        __weak TextHomeViewController *__self = self;
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self.view makeToast:__strMsg];
        });
    }
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
    __weak TeachView *__teachView = _teachView;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.btnTitle setTitle:__self.textSocket.teacher.strName forState:UIControlStateNormal];
        [__self refreshBtnTitle];
        [__teachView setTeachModel:__self.textSocket.teacher];
        if(__self.textSocket.teacher.fansflag==1)
        {
            __self.rightView.btnFirst.selected = YES;
        }
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
        {
            TextTodayVPViewController *todayVIP = [[TextTodayVPViewController alloc] initWithSocket:_textSocket];
            [self presentViewController:todayVIP animated:YES completion:nil];
        }
        break;
        case 3:
        {
            TextHistoryViewController *historyView = [[TextHistoryViewController alloc] initWithSocket:_textSocket];
            [self presentViewController:historyView animated:YES completion:nil];
        }
        break;
        default:
            break;
    }
    hidenView.hidden = YES;
    _rightView.hidden = YES;
}

- (void)sendCollet
{
    [_textSocket reqTeacherCollet:_rightView.btnFirst.selected ? 2 : 1];
    
}

- (void)gotoTextTodayVI
{
    
}

- (void)gotoHistory
{
    
}

@end
