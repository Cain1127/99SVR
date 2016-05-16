//
//  XVideoLiveViewcontroller.m
//  99SVR
//
//  Created by xia zhonglin  on 4/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XVideoLiveViewcontroller.h"
#import "LivePlayViewController.h"
#import "PaySelectViewController.h"
#import "GiftShowAnimate.h"
#import "DecodeJson.h"
#import "RoomChatDataSource.h"
#import "TableViewFactory.h"
#import "XLiveQuestionView.h"
#import "AlertFactory.h"
#import "RoomDownView.h"
#import "RoomService.h"
#import "ZLLogonProtocol.h"
#import "RoomHttp.h"
#import "RoomUser.h"
#import "UserListView.h"
#import "UITableView+reloadComplete.h"
#import "NSAttributedString+EmojiExtension.h"
#import "FloatingView.h"
#import "GiftView.h"
#import "ChatView.h"
#import "RoomDownView.h"
#import "SliderMenuView.h"
#import <DTCoreText/DTCoreText.h>
#import "RoomNoticeDataSource.h"
#import "ChatRightView.h"
#import "ConsumeRankDataSource.h"
#import "HttpManagerSing.h"
#import "UIAlertView+Block.h"

@interface XVideoLiveViewcontroller()<UITableViewDelegate,UserListSelectDelegate,GiftDelegate,
                                ChatRightDelegate,ChatViewDelegate,RoomChatDelegate,XLiveQuestionDelegate>
{
    UserListView *_listView;
    RoomDownView *_infoView;
    GiftView *_giftView;
    XLiveQuestionView *_questionView;
    ChatView *_inputView;
    
    NSMutableDictionary *dictGift;
    NSMutableArray *aryGift;
    BOOL bGiftView;
    BOOL bFull;
    int nColor;
    UIView *downView;
    int toUser;
    UIView  *_topHUD;
    UIView *_downHUD;
    
    DTAttributedTextView *_teachView;
    UIView *_chatAllView;
    ChatRightView *_rightView;
}

@property (nonatomic,assign) int nCurGift;
@property (nonatomic,assign) int question_times;
@property (nonatomic,assign) float question_coin;
@property (nonatomic,strong) RoomHttp *room;
@property (nonatomic,copy) NSArray *aryConsume;

@property (nonatomic,strong) UITableView *chatView;
@property (nonatomic,strong) UITableView *priChatView;
@property (nonatomic,strong) UITableView *noticeView;
@property (nonatomic,strong) UITableView *tableConsumeRank;

@property (nonatomic,strong) UIButton *btnVideo;
@property (nonatomic,strong) UIButton *btnFull;
@property (nonatomic,strong) SliderMenuView *menuView;
@property (nonatomic,assign) NSInteger nSelectIndex;

@property (nonatomic,strong) RoomChatDataSource *chatDataSource;
@property (nonatomic,strong) RoomChatDataSource *prichatDataSource;
@property (nonatomic,strong) RoomNoticeDataSource *noticeDataSource;
@property (nonatomic,strong) ConsumeRankDataSource *consumeDataSource;

@end

@implementation XVideoLiveViewcontroller

- (void)addNotify
{
    [self addNotification];
}

- (void)reloadModel:(RoomHttp *)room
{
    _room = room;
    [_menuView setDefaultIndex:1];
    _ffPlay.roomIsCollet = nRoom_is_collet;
    [_ffPlay setRoomName:_room.teamname];
    [_ffPlay setRoomId:[_room.roomid intValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_TEACH_INFO_VC object:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
    [kHTTPSingle RequestUserTeamRelatedInfo:[_room.teamid intValue]];
}

- (id)initWithModel:(RoomHttp *)room
{
    self = [super init];
    _nSelectIndex = 1;
    _room = room;
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-kRoom_head_view_height)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    aryGift = [NSMutableArray array];
    nColor = 10000;
    [self initUIHead];
    UITapGestureRecognizer* singleRecogn;
    singleRecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTopHUD)];
    singleRecogn.numberOfTapsRequired = 1; // 双击
    [_ffPlay.view setUserInteractionEnabled:YES];
    [_ffPlay.view addGestureRecognizer:singleRecogn];
    _ffPlay.roomIsCollet = nRoom_is_collet;
    [self addNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CONSUMERANK_LIST_VC object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_TEACH_INFO_VC object:@""];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_NOTICE_VC object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
}

- (void)connectUnVideo:(UIButton *)sender
{
    if (_ffPlay.playing)
    {
        [_ffPlay setOnlyAudio:sender.selected];
        sender.selected = !sender.selected;
    }
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_MIC_UPDATE_VC object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (_menuView)
    {
        [_menuView resetSelectFirstIndex];
    }
}

- (void)initTableView
{
    CGRect frame = Rect(0,kVideoImageHeight,kScreenWidth,self.view.height-44-kVideoImageHeight);
    _chatAllView = [[UIView alloc] initWithFrame:frame];
    
    _chatView = [TableViewFactory createTableViewWithFrame:Rect(0,0,kScreenWidth-54,frame.size.height) withStyle:UITableViewStylePlain];
    [_chatView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    [_chatAllView addSubview:_chatView];
    
    _rightView = [[ChatRightView alloc] initWithFrame:Rect(kScreenWidth-54, 0, 54, frame.size.height)];
    [_rightView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    [_chatAllView addSubview:_rightView];
    
    _rightView.delegate = self;
    
    _chatDataSource = [[RoomChatDataSource alloc] init];
    _chatView.dataSource = _chatDataSource;
    _chatView.delegate = _chatDataSource;
    _chatDataSource.delegate = self;
    
    _priChatView = [TableViewFactory createTableViewWithFrame:frame withStyle:UITableViewStylePlain];
    [_priChatView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    _prichatDataSource = [[RoomChatDataSource alloc] init];
    _priChatView.dataSource = _prichatDataSource;
    _priChatView.delegate = _prichatDataSource;
    
    _noticeView = [TableViewFactory createTableViewWithFrame:frame withStyle:UITableViewStylePlain];
    _noticeDataSource = [[RoomNoticeDataSource alloc] init];
    _noticeView.dataSource = _noticeDataSource;
    _noticeView.delegate = _noticeDataSource;
    [_noticeView setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    _teachView = [[DTAttributedTextView alloc] initWithFrame:frame];
    
    _tableConsumeRank = [TableViewFactory createTableViewWithFrame:frame withStyle:UITableViewStylePlain];
    _consumeDataSource = [[ConsumeRankDataSource alloc] init];
    _tableConsumeRank.dataSource = _consumeDataSource;
    _tableConsumeRank.delegate = _consumeDataSource;
    [_tableConsumeRank setBackgroundColor:UIColorFromRGB(0xffffff)];
}

- (void)initSlideView{
    _menuView = [[SliderMenuView alloc] initWithFrame:Rect(0,kVideoImageHeight, kScreenWidth,self.view.height-kVideoImageHeight)
                                           withTitles:@[@"聊天",@"我的",@"公告",@"课程表",@"贡献榜"] withDefaultSelectIndex:1];
    _menuView.viewArrays = @[_chatAllView,_priChatView,_noticeView,_teachView,_tableConsumeRank];
    _menuView.bottomScroView.scrollEnabled = NO;
    _menuView.DidSelectSliderIndex = ^(NSInteger index)
    {
        _nSelectIndex = index;
    };
}

- (void)initUIHead{
    
    _ffPlay = [[LivePlayViewController alloc] init];
    [self.view addSubview:_ffPlay.view];
    _ffPlay.view.frame = Rect(0,0, kScreenWidth, kScreenHeight);
    [_ffPlay setRoomId:[_room.roomid intValue]];
    [self addChildViewController:_ffPlay];
    [_ffPlay setRoomName:_room.teamname];
    
    [self initTableView];
    [self initSlideView];
    
    [self.view addSubview:_menuView];
    self.menuView.DidSelectSliderIndex = ^(NSInteger index){
        NSLog(@"模块%ld",(long)index);
    };
    
    UILabel *lblDownLine = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 0.5)];
    [lblDownLine setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [downView addSubview:lblDownLine];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:Rect(10, 7, kScreenWidth-20, 36)];
    [whiteView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [downView addSubview:whiteView];
    
    //发送消息按钮
    _giftView = [[GiftView alloc] initWithFrame:Rect(0,0, kScreenWidth, kScreenHeight)];
    [self.parentViewController.view addSubview:_giftView];
    _giftView.frame = Rect(0, kScreenHeight, kScreenWidth, 0);
    _giftView.hidden = YES;
    _giftView.delegate = self;
    
    _listView = [[UserListView alloc] initWithFrame:Rect(0,0, kScreenWidth, kScreenHeight) array:nil];
    [self.parentViewController.view addSubview:_listView];
    _listView.frame = Rect(0, kScreenHeight, kScreenWidth, 0);
    _listView.hidden = YES;
    _listView.delegate = self;

    _inputView = [[ChatView alloc] initWithFrame:Rect(0,0, kScreenWidth,kScreenHeight)];
    [self.parentViewController.view addSubview:_inputView];
    _inputView.hidden = YES;
    _inputView.delegate = self;
    
    _questionView = [[XLiveQuestionView alloc] initWithFrame:Rect(0,0,kScreenWidth,self.view.height)];
    [self.parentViewController.view addSubview:_questionView];
    _questionView.hidden = YES;
    _questionView.delegate = self;
    
    
}

#pragma mark 提问完再次检测提问次数
- (void)requestQuestion:(NSString *)strName content:(NSString *)strContent
{
    
    if ((_questionView==0&&KUserSingleton.goldCoin<=10)) {//提问次数为0且金币小于提问的10玖玖币
        
        [UIAlertView createAlertViewWithTitle:@"提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"充值" withMessage:@"余额不足请充值" completionCallback:^(NSInteger index) {
            
            if (index==1) {
                PaySelectViewController *paySelectVC = [[PaySelectViewController alloc] init];
                [self.navigationController pushViewController:paySelectVC animated:YES];
            }else{//取消充值就隐藏
                [_questionView setGestureHidden];
            }
        }];
        return;
    }
    
    [[ZLLogonServerSing sharedZLLogonServerSing] requestQuestion:[_room.roomid intValue] team:[_room.teamid intValue] stock:strName question:strContent];
    DLog(@"提问 roomid==%@ 提问的次数%d",_room.roomid,_question_times);
    [_questionView.txtName resignFirstResponder];
    [_questionView.txtContent resignFirstResponder];
    [_questionView setGestureHidden];
}

- (void)loadConsumeRank:(NSNotification *)notify
{
    NSArray *aryConsume = notify.object;
    if ([aryConsume isKindOfClass:[NSArray class]] && aryConsume.count>0) {
        [_consumeDataSource setAryModel:aryConsume];
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak.tableConsumeRank reloadData];
        });
    }
}

/**
 *  课程表数据   响应消息
 *
 *  @param notify
 */
#pragma mark 课程表数据   响应消息
- (void)updateRoomTeachInfo:(NSNotification *)notify
{
    
    if (roomTeachInfo != nil && roomTeachInfo.length > 0)
    {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(),
           ^{
               if (selfWeak.nSelectIndex != 4) {
                   selfWeak.menuView.showBadgeIndex = 4;
               }
           });
        @WeakObj(roomTeachInfo)
        @WeakObj(_teachView)
        
        dispatch_async(dispatch_get_main_queue(),
           ^{
               _teachViewWeak.attributedString = [[NSAttributedString alloc] initWithHTMLData:[roomTeachInfoWeak dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
           });
    }
}

/**
 *  提问后相应
 */
- (void)responseQuestion:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    [kHTTPSingle RequestUserTeamRelatedInfo:[_room.teamid intValue]];
    if ([dict[@"code"] intValue]==1)
    {
        @WeakObj(_questionView)
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showSuccess:@"提问成功"];
            _questionViewWeak.txtName.text = @"";
            _questionViewWeak.txtContent.text = @"";
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showError:@"提问请求失败"];
        });
    }
}

- (void)loadAllInfo:(NSNotification *)notify
{
     dispatch_async(dispatch_get_main_queue(), ^{
         [ProgressHUD showError:@"提问失败"];
     });
}

- (void)onLoadDict:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if ([dict[@"code"] intValue]==1) {
        _question_coin = [dict[@"askcoin"] floatValue];
        _question_times = [dict[@"askremain"] floatValue];
    }
}

- (void)loadFailQuestion:(NSNotification *)notify
{
    NSString *strMsg = notify.object;
    __weak NSString *__strMsg = strMsg;
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showError:__strMsg];
    });
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadDict:) name:MESSAGE_REQSTION_REMAIN_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFailQuestion:) name:MESSAGE_QUESTION_FAIL_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseQuestion:) name:MESSAGE_ROOM_QUESTION_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoomTeachInfo:) name:MESSAGE_ROOM_TEACH_INFO_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadConsumeRank:) name:MESSAGE_CONSUMERANK_LIST_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:MESSAGE_NETWORK_ERR_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TradeGiftError:) name:MESSAGE_TRADE_GIFT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayThread:) name:MESSAGE_ROOM_MIC_UPDATE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomChatPriMsg) name:MESSAGE_ROOM_TO_ME_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomChatMsg) name:MESSAGE_ROOM_CHAT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomListNotice) name:MESSAGE_ROOM_NOTICE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomUserList:) name:MESSAGE_ROOM_ALL_USER_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomBeExit:) name:MESSAGE_ROOM_BE_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(room_kickout) name:MESSAGE_ROOM_KICKOUT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:MESSAGE_ROOM_MIC_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLiwuRespInfo) name:MEESAGE_ROOM_SEND_LIWU_RESP_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLiwuNotifyInfo:) name:MEESAGE_ROOM_SEND_LIWU_NOTIFY_VC object:nil];
}

/**
 *  停止播放
 */
- (void)stopPlay
{
    if(_ffPlay)
    {
        [_ffPlay stop];
    }
    @WeakObj(_ffPlay)
    dispatch_main_async_safe(
     ^{
         [_ffPlayWeak setNullMic];
     });
}

/**
 *  停止播放接口
 */
- (void)stopNewPlay
{
    if(_ffPlay)
    {
        [_ffPlay stop];
    }
    @WeakObj(_ffPlay)
    dispatch_main_async_safe(
     ^{
         [_ffPlayWeak setDefaultImg];
     });
}

/**
 *  赠送礼物失败
 */
- (void)TradeGiftError:(NSNotification *)notify
{
    NSNumber *number = notify.object;
    if ([number intValue]==202) {
//      @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
//            [selfWeak createPaySVR];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showError:@"赠送礼物失败"];
        });
    }
}

/**
 *  播放线程
 */
- (void)startPlayThread:(NSNotification *)notify
{
    @WeakObj(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
    dispatch_get_global_queue(0, 0),
    ^{
       [selfWeak startNewPlay];
    });
}

/**
 *  开始播放
 */
- (void)startNewPlay
{
    for (RoomUser *user in currentRoom.aryUser)
    {
        if ([user isOnMic])
        {
            _ffPlay.nuserid = user.m_nUserId;
            [_ffPlay startPlayRoomId:[_room.roomid intValue] user:1801124 name:_room.teamname];
            [kHTTPSingle RequestConsumeRank:user.m_nUserId];
            return ;
        }
    }
    _ffPlay.nuserid = 0;
    [_ffPlay stop];
    @WeakObj(_ffPlay)
    dispatch_main_async_safe(
    ^{
        [_ffPlayWeak setNullMic];
    });
}

/**
 *  私聊数据更新
 */
- (void)roomChatPriMsg
{
    @WeakObj(self)
    [_prichatDataSource setModel:aryRoomPrichat];
    if (aryRoomPrichat.count>0) {
        dispatch_async(dispatch_get_main_queue(),
       ^{
           if (selfWeak.nSelectIndex != 2) {
               selfWeak.menuView.showBadgeIndex = 2;
           }
       });
    }
    dispatch_async(dispatch_get_main_queue(),^{
        [selfWeak.priChatView reloadDataWithCompletion:
         ^{
             NSInteger numberOfRows = [selfWeak.priChatView numberOfRowsInSection:0];
             if (numberOfRows > 0)
             {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
                 [selfWeak.priChatView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             }
         }];
    });
}

/**
 *  聊天响应
 */
- (void)roomChatMsg
{
    [_chatDataSource setModel:aryRoomChat];
    @WeakObj(self)
    if (aryRoomChat.count>0) {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            if (selfWeak.nSelectIndex != 1) {
                selfWeak.menuView.showBadgeIndex = 1;
            }
        });
    }
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [selfWeak.chatView reloadDataWithCompletion:
        ^{
            NSInteger numberOfRows = [selfWeak.chatView numberOfRowsInSection:0];
            if (numberOfRows > 0)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
                [selfWeak.chatView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }];
    });
}

/**
 *  公告刷新
 */
- (void)roomListNotice
{
    @WeakObj(self)
    [_noticeDataSource setModel:aryRoomNotice];
    if (aryRoomNotice.count>0) {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            if (selfWeak.nSelectIndex != 3) {
                selfWeak.menuView.showBadgeIndex = 3;
            }
        });
    }
    @WeakObj(aryRoomNotice)
    dispatch_async(dispatch_get_main_queue(),
    ^{
       [selfWeak.noticeView reloadDataWithCompletion:
        ^{
            if (aryRoomNoticeWeak.count > 0)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:aryRoomNoticeWeak.count-1];
                [selfWeak.noticeView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }];
    });
}

/**
 *  用户记录更新
 */
- (void)roomUserList:(NSNotification*)notify
{
    [_listView reloadItems:currentRoom.aryUser];
}
/**
 *  后退
 */
- (void)roomBeExit:(NSNotification *)notify
{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(),
       ^{
           [selfWeak.view makeToast:@"当前房间被关闭" duration:2.0 position:@"center"];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),
              ^{
                  [selfWeak.navigationController popViewControllerAnimated:YES];
              });
       });
}

/**
 *  被人踢出
 */
- (void)room_kickout
{
    @WeakObj(self)
    dispatch_main_async_safe(
     ^{
         [selfWeak.view makeToast:@"您被人踢出当前房间" duration:2 position:@"center"];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [selfWeak.navigationController popViewControllerAnimated:YES];
         });
     });
}

/**
 *  赠送礼物成功
 */
- (void)sendLiwuRespInfo
{
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [ProgressHUD showSuccess:@"赠送礼物成功"];
    });
}

/**
 *  赠送礼物成功
 */
- (void)sendLiwuNotifyInfo:(NSNotification *)notify
{
    /**
     *  1.加入dictGift
     *  2.查看当前是否有显示的
     */
    NSDictionary *parameter = notify.object;
    @WeakObj(self)
    [aryGift addObject:parameter];
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak showGiftInfo];
    });
}

/**
 *  显示礼物赠送效果
 */
- (void)showGiftInfo
{
    
}

- (FloatingView*)createFloatView:(NSDictionary *)parameter color:(int)ncolor onlyOne:(int)nOnly{
    
    NSString *strName = nil;
    int gid ;
    int num ;
    if ([parameter objectForKey:@"name"] && [parameter objectForKey:@"gitId"] && [parameter objectForKey:@"num"]) {
        strName = [parameter objectForKey:@"name"];
        gid = [[parameter objectForKey:@"gitId"] intValue];
        num = [[parameter objectForKey:@"num"] intValue];
        FloatingView *floatView = [[FloatingView alloc] initWithFrame:Rect(0,kVideoImageHeight+nOnly*45,kScreenWidth, 45) color:ncolor++ name:strName number:num gid:gid userid:[[parameter objectForKey:@"userid"] intValue]];
        return floatView;
    }
    return nil;
}

#pragma mark RoomDwonDelegate
- (void)clickRoom:(UIButton *)button index:(NSInteger)nIndex
{
    switch (nIndex) {
        case 4://显示聊天
        {
            if (([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1) ||
                ([_room.roomid intValue]==10000 || [_room.roomid intValue]==10001)) {
                [UIView animateWithDuration:0.5 animations:
                 ^{
                     _inputView.hidden = NO;
                 } completion:^(BOOL finished) {}];
            }
            else
            {
                @WeakObj(self)
                
                [AlertFactory createLoginAlert:self withMsg:@"聊天" block:^{
                    [selfWeak closeRoomInfo];
                }];
            }
        }
            break;
        case 5://显示成员
        {
            [UIView animateWithDuration:0.5 animations:
             ^{
                 _listView.hidden = NO;
                 [_listView setFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
             } completion:^(BOOL finished) {}];
        }
            break;
        case 3://显示礼物
        {
            if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1) {
                [_giftView updateGoid];
                [UIView animateWithDuration:0.5 animations:
                ^{
                    _giftView.hidden = NO;
                    [_giftView setFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
                } completion:^(BOOL finished) {}];
            }
            else
            {
                @WeakObj(self)
                [AlertFactory createLoginAlert:self withMsg:@"送礼物" block:^{
                    [selfWeak closeRoomInfo];
                }];
            }
        }
        break;
        case 2:
        {
            [self sendRose];
        }
        break;
        case 1:
        {
            if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1) {

                [_giftView updateGoid];
                [UIView animateWithDuration:0.5 animations:^{
                    _questionView.hidden = NO;
                    [_questionView setFrame:Rect(0,0, kScreenWidth, kScreenHeight)];
                    NSString *strmsg = [NSString stringWithFormat:@"温馨提示:您还剩%d次免费提问的机会，问股仅供参考，不构成投资建议",_question_times];
                    _questionView.lblTimes.text = strmsg;
                } completion:^(BOOL finished) {}];
            }
            else
            {
                @WeakObj(self)
                [AlertFactory createLoginAlert:self withMsg:@"提问" block:^{
                    [selfWeak closeRoomInfo];
                }];
            }
        }
        break;
    }
}

#pragma mark ChatViewDelegate
- (void)sendMessage:(UITextView *)textView userid:(int)nUser
{
    RoomUser *user = [currentRoom findUser:[UserInfo sharedUserInfo].nUserId];
    NSString *strInfo = [textView.textStorage getPlainString];
    if (user.m_nVipLevel>2) {}
    else{
        if ([strInfo length]>=20)
        {
            [ProgressHUD showError:@"不能发送超过20个字符内容"];
            return ;
        }
    }
    toUser = nUser;
    [self sendChatMessage:strInfo];
}

- (void)sendChatMessage:(NSString *)strInfo
{
    if([UserInfo sharedUserInfo].nType != 1 && ![_room.roomid isEqualToString:@"10000"] && ![_room.roomid isEqualToString:@"10001"])
    {
        [ProgressHUD showError:@"游客不能发送信息"];
        return ;
    }
    if ([DecodeJson isEmpty:strInfo])
    {
        [ProgressHUD showError:@"请输入聊天内容"];
        return ;
    }
    [kProtocolSingle sendMessage:strInfo toId:toUser];
    [_inputView.textView setText:@""];
    [_inputView setGestureHidden];
}

#pragma mark 送礼物
- (void)sendGift:(int)giftId num:(int)giftNum
{
    if (_ffPlay.playing) {
        [kProtocolSingle sendGiftInfo:giftId number:giftNum];
        [_giftView setGestureHidden];
    }else{
        [ProgressHUD showError:@"只能对在线讲师送礼"];
    }
}

- (void)showPayView
{
    PaySelectViewController *selectView = [[PaySelectViewController alloc] init];
    [self.navigationController pushViewController:selectView animated:YES];
}

#pragma mark 用户列表选择某一列
- (void)selectUser:(NSInteger)nIndex
{
    if(currentRoom.aryUser.count>nIndex)
    {
        RoomUser *_user = [currentRoom.aryUser objectAtIndex:nIndex];
        if(_user.m_nUserId != [UserInfo sharedUserInfo].nUserId)
        {
            [_listView setGestureHidden];
            toUser = _user.m_nUserId;
            [_inputView setChatInfo:_user];
        }
        else
        {
            [ProgressHUD showError:@"不能@自己"];
        }
    }
}

/**
 *  释放房间中的内容
 */
- (void)closeRoomInfo
{
    //TODD:关闭房间
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)sendRose
{
    if([UserInfo sharedUserInfo].nType != 1 && ![_room.roomid isEqualToString:@"10000"] && ![_room.roomid isEqualToString:@"10001"])
    {        
        [AlertFactory createLoginAlert:self withMsg:@"给讲师喝彩" block:^{
            
        }];

        return ;
    }
//    [RoomService sendLocalInfo:@"[$999$]" toid:0 roomInfo:currentRoom aryChat:aryRoomChat];
    [kProtocolSingle sendRose];
}

- (void)showTopHUD
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if(_downHUD.alpha==0)
    {
        _downHUD.alpha = 1;
        [self performSelector:@selector(hiddenTopHud) withObject:nil afterDelay:2.0];
    }
    else
    {
        _downHUD.alpha = 0;
    }
}

#pragma mark 横屏
- (void)horizontalViewControl
{

}

#pragma mark 竖屏
- (void)verticalViewControl
{
//    _topHUD.frame = Rect(0, 0, kScreenWidth, 64);
//    [_topHUD viewWithTag:1].frame = Rect(0, 0, kScreenWidth, 64);
//    _lblName.frame = Rect(50, 35, kScreenWidth-100, 15);
//    [_topHUD viewWithTag:2].frame = Rect(0, 20, 44, 44);
//    _btnRight.frame = Rect(kScreenWidth-50, 20, 44, 44);
//    _downHUD.frame = Rect(0, kVideoImageHeight-24, kScreenWidth, 44);
//    _ffPlay.view.frame = Rect(0, 0, kScreenWidth, kScreenHeight);
//    _ffPlay.glView.frame = Rect(0,0,kScreenWidth, kVideoImageHeight);
//
//    _btnFull.frame = Rect(kScreenWidth-54, 0, 44, 44);
//    
//    _group.hidden = NO;
//    downView.hidden = NO;
//    _lblBlue.hidden = NO;
//    _scrollView.hidden = NO;
//    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    if (!bFull)
    {
        return NO;
    }
    return YES;
}

#pragma mark ViewLayout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(!bFull)
    {
        [self verticalViewControl];
    }
    else
    {
        [self horizontalViewControl];
    }
}

- (void)hiddenTopHud
{
    __weak UIView *__downHUD = _downHUD;
    dispatch_main_async_safe(
     ^{
         __downHUD.alpha = 0;
     });
}

- (void)dealloc{
    [_ffPlay stop];
}

- (void)showKeyboard:(int)nToUser
{
    if (currentRoom != nil)
    {
        RoomUser *rUser = [currentRoom findUser:nToUser];
        [_inputView setChatInfo:rUser];
    }
}

- (void)removeAllNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_QUESTION_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_NETWORK_ERR_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_TRADE_GIFT_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_TO_ME_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_CHAT_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_NOTICE_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_ALL_USER_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_BE_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_KICKOUT_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_MIC_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEESAGE_ROOM_SEND_LIWU_RESP_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEESAGE_ROOM_SEND_LIWU_NOTIFY_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_TEACH_INFO_VC object:nil];
}

@end
