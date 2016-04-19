//
//  RoomViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomViewController.h"

#import "XTraderView.h"
#import "XExpertIdeaView.h"
#import "XPriPersonView.h"

#import "RoomService.h"
#import "AlertFactory.h"

#import "ZLLogonProtocol.h"
#import "ZLLogonServerSing.h"

#import "InAppPurchasesViewController.h"
#import "PaySelectViewController.h"

#import "LivePlayViewController.h"
#import "Photo.h"
#import "PhotoViewController.h"

#import "ZLCoreTextCell.h"
#import "RoomCoreTextCell.h"

#import "NoticeModel.h"
#import "RoomHttp.h"
#import "RoomGroup.h"

#import "ChatView.h"
#import "MyScrollView.h"
#import "FloatingView.h"
#import "GiftView.h"
#import "RoomDownView.h"
#import "RoomUserCell.h"
#import "RoomUser.h"
#import "RoomTitleView.h"
#import "RoomInfo.h"
#import "UserListView.h"
#import "SliderMenuView.h"
#import "RoomHeaderView.h"

#import "NSAttributedString+EmojiExtension.h"
#import "UIControl+UIControl_XY.h"
#import "UITableView+reloadComplete.h"
#import <DTCoreText/DTCoreText.h>

#import "XVideoLiveViewcontroller.h"

#define TABLEVIEW_ARRAY_PREDICATE(A) [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",A];

@interface RoomViewController ()<UITableViewDelegate,UITableViewDataSource,TitleViewDelegate,
                                UITextViewDelegate,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate,UIScrollViewDelegate,
                                RoomDownDelegate,ChatViewDelegate,GiftDelegate,UserListSelectDelegate>
{
    //聊天view
    UIView *bodyView;
    UIView *downView;
    BOOL bDrag;
    UIView *defaultHeadView;
    UIView *defaultDownView;
    UIButton *_btnSend;
    UITextView *_textChat;
    UILabel *_lblBlue;
    CGFloat deltaY;
    float duration;    // 动画持续时间
    CGFloat originalY; // TextField原来的纵坐标
    int toUser;
   
    UILabel *_lblName;
    UIButton *_btnVideo;
    NSInteger _nTag;
    dispatch_queue_t room_gcd;
    int _tag;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    int updateCount;
    int _currentPage;
    CGFloat fTempWidth;
    BOOL bFull;
    RoomHttp *_room;
    NSCache *chatCache;
    DTAttributedLabel *lblTeachInfo;
    BOOL bGiftView;
    NSMutableDictionary *dictGift;
    
}



@property (nonatomic,strong) NSCache *cellCache;

@property (nonatomic,strong) UIButton *btnRight;
@property (nonatomic,strong) UIButton *btnFull;
@property (nonatomic,assign) CGFloat fChatHeight;

@property (nonatomic,strong) RoomTitleView *group;

@property (nonatomic,strong) UITableView *priChatView;
@property (nonatomic,strong) UITableView *noticeView;
@property (nonatomic,strong) UITableView *chatView;
@property (assign,nonatomic) NSInteger keyboardPresentFlag;

@property (nonatomic,strong) MyScrollView *scrollView;

@property (nonatomic,copy) NSArray *aryUser;
@property (nonatomic,copy) NSArray *aryNotice;
@property (nonatomic,copy) NSArray *aryPriChat;
@property (nonatomic,copy) NSArray *aryChat;

@property (nonatomic,strong) XExpertIdeaView *expertView;
@property (nonatomic,strong) XTraderView *tradeView;
@property (nonatomic,strong) XPriPersonView *personView;
@property (nonatomic,strong) XVideoLiveViewcontroller *liveControl;

@end

@implementation RoomViewController

//-(SliderMenuView *)sliderMenuView{
//    if (!sliderMenu) {
//        
//        CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
//        CGFloat tabbarH = CGRectGetHeight(self.tabBarController.tabBar.frame);
//        sliderMenu = [[SliderMenuView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH-tabbarH} withTitles:@[@"日收益",@"月收益",@"总收益"]];
//        sliderMenu.viewArrays = @[self.dayTab,self.monTab,self.totalTab];
//    }
//    return _sliderMenuView;
//}

- (id)initWithModel:(RoomHttp *)room
{
    self = [super init];
    _room = room;
    return self;
}

<<<<<<< HEAD

=======
- (void)connectRoomInfo
{
    NSString *strAddress;
    NSString *strPort;
    NSString *roomAddr = [KUserSingleton.dictRoomGate objectForKey:@(0)];
//    _tcpSocket.strRoomId = _room.nvcbid;
    if(roomAddr!=nil)
    {
        NSString *strAry = [roomAddr componentsSeparatedByString:@","][0];
        strAddress = [strAry componentsSeparatedByString:@":"][0];
        strPort = [strAry componentsSeparatedByString:@":"][1];
    }
    else
    {
        strAddress = @"";
        strPort = @"0";
    }
//    [_tcpSocket connectRoomInfo:_room.nvcbid address:strAddress port:[strPort intValue]];
//    [self performSelector:@selector(joinRoomTimeOut) withObject:nil afterDelay:6];
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
>>>>>>> LiuHaiDong

- (void)dealloc
{
    DLog(@"room view");
<<<<<<< HEAD
    [kProtocolSingle exitRoom];
    [[SDImageCache sharedImageCache] clearMemory];
=======
//    [_tcpSocket exit_Room:YES];
//    _tcpSocket = nil;
    [_ffPlay stop];
    [_ffPlay stop];
    //TODD:关闭房间   清楚所有信息
    [kProtocolSingle exitRoom];
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _ffPlay = nil;
>>>>>>> LiuHaiDong
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    [_chatView removeFromSuperview];
    _chatView = nil;
    [_noticeView removeFromSuperview];
    _noticeView = nil;
    [_priChatView removeFromSuperview];
    _priChatView = nil;
}



- (void)colletRoom
{
    if([UserInfo sharedUserInfo].aryCollet.count>=1)
    {
        RoomGroup *group = [[UserInfo sharedUserInfo].aryCollet objectAtIndex:0];
        for (RoomHttp *room in group.roomList)
        {
            if([_room.nvcbid isEqualToString:room.nvcbid])
            {
                __weak RoomViewController *__self = self;
                dispatch_main_async_safe(
                ^{
                   [__self.btnRight setSelected:YES];
                });
                break;
            }
        }
    }
}

#pragma mark 关注
- (void)colletCurrentRoom
{
    if([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        _btnRight.selected = !_btnRight.selected;
        NSString *strMsg = _btnRight.selected ? @"关注成功" : @"取消关注";
        [self.view makeToast:strMsg];
//        [_tcpSocket sendColletRoom:_btnRight.selected];
        //发送关注
        
    }
    else
    {
        [self.view makeToast:@"游客不能关注"];
    }
}

- (void)createScrolView:(CGRect)frame{
    if (_scrollView==nil) {
        _scrollView = [[MyScrollView alloc] initWithFrame:frame];
        [self.view addSubview:_scrollView];
        _scrollView.clipsToBounds = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _scrollView.delegate = self;
        [_scrollView setBackgroundColor:UIColorFromRGB(0xffffff)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth*4, _scrollView.height);
    }
}

/**
 *  新初始化方案
 */
- (void)initUIHead
{
    RoomHeaderView *headView = [[RoomHeaderView alloc] initWithFrame:Rect(0, 0, kScreenWidth,kRoom_head_view_height)];
    [self.view addSubview:headView];
    
    [self createScrolView:Rect(0, headView.height, kScreenWidth, kScreenHeight-headView.height)];
    CGRect frame = _scrollView.bounds;
    _liveControl = [[XVideoLiveViewcontroller alloc] initWithModel:_room];
    [self addChildViewController:_liveControl];
    _liveControl.view.frame = frame;
    
    frame.origin.x += kScreenWidth;
    _expertView = [[XExpertIdeaView alloc] initWithFrame:frame];
    
    frame.origin.x += kScreenWidth;
    _tradeView = [[XTraderView alloc] initWithFrame:frame];
    
    frame.origin.x += kScreenWidth;
    _personView = [[XPriPersonView alloc] initWithFrame:frame];
    
    [_scrollView addSubview:_liveControl.view];
    [_scrollView addSubview:_expertView];
    [_scrollView addSubview:_tradeView];
    [_scrollView addSubview:_personView];
   
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_ALL_USER_VC object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_TO_ME_VC object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_NOTICE_VC object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_MIC_UPDATE_VC object:nil];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    room_gcd = dispatch_queue_create("decode_gcd",0);
    _cellCache = [[NSCache alloc] init];
    [_cellCache setTotalCostLimit:20];
    [self initUIHead];
    dictGift = [NSMutableDictionary dictionary];
    @WeakObj(self)
    dispatch_async(dispatch_get_global_queue(0,0),
    ^{
        [selfWeak colletRoom];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"收到内存警告");
}


- (void)createPaySVR
{
    __weak RoomViewController *__self =self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"余额不足" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self.view hideToastActivity];
        });
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
           dispatch_async(dispatch_get_main_queue(),
           ^{
                  PaySelectViewController *paySelectVC = [[PaySelectViewController alloc] init];
                  [self.navigationController pushViewController:paySelectVC animated:YES];
           });
    }];
    [alert addAction:canAction];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_noticeView)
    {
        return _aryNotice.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _noticeView)
    {
        return 1;
    }
    else if(tableView == _chatView)
    {
        return _aryChat.count;
    }
    else if(tableView == _priChatView)
    {
        return _aryPriChat.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == _noticeView)
    return 10;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _noticeView)
    {
        return 10;
    }
    return 0;
}

- (DTAttributedTextCell *)tableView:(UITableView *)tableView chatPreparedCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    NSString *key=nil;
    if (tableView==_chatView) {
        char cBuffer[100];
        sprintf(cBuffer,"chatView%zi-%zi",indexPath.section,indexPath.row);
        key = [[NSString alloc] initWithUTF8String:cBuffer];
    }
    else if(tableView == _priChatView){
        char cBuffer[100];
        sprintf(cBuffer,"private%zi-%zi",indexPath.section,indexPath.row);
        key = [[NSString alloc] initWithUTF8String:cBuffer];
    }
    if (!chatCache)
    {
        chatCache = [[NSCache alloc] init];
    }
    DTAttributedTextCell *cell = [chatCache objectForKey:key];
    if (!cell)
    {
        cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:cellIdentifier];
        UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
        [selectView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        cell.selectedBackgroundView = selectView;
        [chatCache setObject:cell forKey:key];
    }
    NSArray *aryInfo = (tableView==_chatView) ? _aryChat : _aryPriChat;
    if(aryInfo.count>indexPath.row)
    {
        [self configureCell:cell forIndexPath:indexPath array:aryInfo];
    }
    [cell.attributedTextContextView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    return cell;
}

//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _noticeView)
    {
        ZLCoreTextCell *cell = [self tableView:tableView preparedCellForZLIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    DTAttributedTextCell *cell = [self tableView:tableView chatPreparedCellForIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(DTAttributedTextCell *)cell forIndexPath:(NSIndexPath *)indexPath array:(NSArray *)aryInfo
{
    NSString *html = [aryInfo objectAtIndex:indexPath.row];
    [cell setHTMLString:html];
    cell.attributedTextContextView.shouldDrawImages = YES;
    cell.attributedTextContextView.delegate = self;
}

//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _noticeView && _aryNotice.count > indexPath.section)
    {
        ZLCoreTextCell *coreText = [self tableView:tableView preparedCellForZLIndexPath:indexPath];
        return [coreText.lblInfo.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
    }
    else
    {
        DTAttributedTextCell *cell = [self tableView:tableView chatPreparedCellForIndexPath:indexPath];
        return [cell requiredRowHeightInTableView:tableView];
    }
    return 60;
}

- (ZLCoreTextCell *)tableView:(UITableView *)tableView preparedCellForZLIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    NSString *strInfo;
    ZLCoreTextCell *cell = nil;
    NSString *strIdentifier = @"kNoticeIdentifier";
    cell = [_cellCache objectForKey:cacheKey];
    if (cell==nil)
    {
        cell = [[ZLCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
        [_cellCache setObject:cell forKey:cacheKey];
    }
    if(_aryNotice.count > indexPath.section)
    {
        char cString[150] = {0};
        sprintf(cString,"noticeView-%zi",indexPath.section);
        cacheKey = [[NSString alloc] initWithUTF8String:cString];
        NoticeModel *notice = [_aryNotice objectAtIndex:indexPath.section];
        strInfo = notice.strContent;
        strIdentifier = @"kNoticeIdentifier";
    }
    else
    {
        return cell;
    }
    cell.lblInfo.attributedTextContentView.delegate = self;
    cell.lblInfo.attributedTextContentView.shouldDrawImages = YES;
    cell.lblInfo.attributedTextContentView.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    NSData *data = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
    cell.lblInfo.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    [selectView setBackgroundColor:[UIColor clearColor]];
    cell.selectedBackgroundView = selectView;
    return cell;
}

- (void)showImageInfo:(UITapGestureRecognizer *)tapGest
{
    UIImageView *imageView = (UIImageView *)tapGest.view;
    if (imageView.image)
    {
        NSMutableArray *aryIndex = [NSMutableArray array];
        Photo *_photo = [[Photo alloc] init];
        _photo.nId = 0;
        _photo.imgName = imageView.image;
        [aryIndex addObject:_photo];
        PhotoViewController *photoControl = [[PhotoViewController alloc] initWithArray:aryIndex current:0];
        [photoControl show];
    }
}

#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:attachment.contentURL];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(showImageInfo:)]];
        return imageView;
    }
    else if([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        NSString *strName = [attachment.attributes objectForKey:@"value"];
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"gif"];
        [imageView sd_setImageWithURL:url1];
        return imageView;
    }
    return nil;
}

#pragma mark Custom Views on Text
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    //超链接操作
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark 点击超链接
- (void)linkPushed:(DTLinkButton *)sender
{
    DLog(@"路径:%@",sender.URL.absoluteString);
    if([sender.URL.absoluteString rangeOfString:@"sqchatid://"].location != NSNotFound)
    {
        NSString *strNumber = [sender.URL.absoluteString stringByReplacingOccurrencesOfString:@"sqchatid://" withString:@""];
        toUser = [strNumber intValue];
//        if (_tcpSocket.getRoomInfo != nil)
//        {
//            RoomUser *rUser = [_tcpSocket.getRoomInfo findUser:toUser];
//            [_inputView setChatInfo:rUser];
//        }
    }
}

#pragma mark 重力感应设置
-(BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        //拖动前的起始坐标
        startContentOffsetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == _scrollView) {
        //将要停止前的坐标
        willEndContentOffsetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        if (willEndContentOffsetX == 0 && startContentOffsetX ==0 )
        {
            return ;
        }
        [self setBluePointX:scrollView.contentOffset.x];
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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _scrollView)
    {
        if (updateCount ==1)//正常
        {
            
        }
        else if(updateCount==0 && _currentPage ==0)
        {
        
        }
        else//加速
        {}
        updateCount = 0;
        startContentOffsetX = 0;
        willEndContentOffsetX = 0;
    }
}


- (void)setBluePointX:(CGFloat)fPointX
{
    CGFloat fx = kScreenWidth/4/2-fTempWidth/2+fPointX/kScreenWidth * kScreenWidth/4;
    [_lblBlue setFrame:Rect(fx,_group.y+_group.height-2,fTempWidth,2)];
}

- (void)showInputView
{
    if ([UserInfo sharedUserInfo].nType != 1 && ![_room.nvcbid isEqualToString:@"10000"] && ![_room.nvcbid isEqualToString:@"10001"]) {
        
    }
    else{
        
    }
}



@end

