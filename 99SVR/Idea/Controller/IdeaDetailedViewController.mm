//
//  IdeaDetailedViewController
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 专家观点详情>**********************************/

#import "IdeaDetailedViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "UIAlertView+Block.h"
#import "PaySelectViewController.h"
#import "ZLShareView.h"
#import "ChatRightView.h"
#import "UIImageFactory.h"
#import "GiftShowAnimate.h"
#import "MJRefresh.h"
#import "CommentCell.h"
#import "ZLReply.h"
#import "ZLShareViewController.h"
#import "ReplyNullInfoCell.h"
#import "EmojiTextAttachment.h"
#import "AlertFactory.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "Toast+UIView.h"
#import "MBProgressHUD.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "ChatView.h"
#import "RoomUser.h"
#import "NSAttributedString+EmojiExtension.h"
#import "TQIdeaDetailModel.h"
#import "ViewNullFactory.h"
#import "GiftView.h"
#import "WXApi.h"
#import "UIAlertView+Block.h"

@interface IdeaDetailedViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ChatViewDelegate,UIScrollViewDelegate,DTAttributedTextContentViewDelegate,UIWebViewDelegate,CommentDelegate,GiftDelegate>
{
    UIView *contentView;
    UILabel *lblPlace;
    UITextView *_textChat;
    NSMutableDictionary *dict;
    CGFloat deltaY;
    UIView *downView;
    CGFloat duration;
    CGFloat originalY;
    int _fall;
    int nCurrent;
    UIView *noView;
    GiftView *_giftView;
    NSCache *commentCache;
}
@property (nonatomic,strong) ChatView *chatView;
@property (nonatomic,strong) DTAttributedTextView *textView;
@property (nonatomic,strong) UIView *downContentView;
@property (nonatomic) int keyboardPresentFlag;
@property (nonatomic,strong) UIButton *btnThum;
@property (nonatomic,copy) NSString *strTo;
@property (nonatomic,strong) UIButton *btnSend;
@property (nonatomic,copy) NSArray *aryCommont;

@property (nonatomic,strong) TQIdeaDetailModel *ideaDetail;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) int viewId;
@property (nonatomic,assign) BOOL bHome;

@end

@implementation IdeaDetailedViewController

@synthesize downContentView;

- (void)showPayView
{
    PaySelectViewController *payView = [[PaySelectViewController alloc] init];
    [self.navigationController pushViewController:payView animated:YES];
}

- (void)sendGift:(int)giftId num:(int)giftNum
{
    [kProtocolSingle sendGiftInfo:giftId number:giftNum toUser:[_ideaDetail.authorId intValue] toViewId:_ideaDetail.viewpointid roomId:[_ideaDetail.roomid intValue]];
//    NSDictionary *parameter = @{@"number":@(giftNum),@"gId":@(giftId),@"srcName":@"srcName",@"toName":@"toName",@"srcId":@(1234567)};
//    GiftShowAnimate *giftAnimate = [[GiftShowAnimate alloc] initWithFrame:Rect(0,64,kScreenWidth-60,46) dict:parameter];
//    [UIView animateWithDuration:1.0
//          delay:1.0
//          options:UIViewAnimationOptionCurveEaseOut
//          animations:^{
//              [self.view addSubview:giftAnimate];
//              [giftAnimate addrightViewAnimation];
//           } completion:^(BOOL finished){
//               @WeakObj(giftAnimate)
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                 [giftAnimateWeak removeFromSuperview];
//             });
//     }];
    [_giftView setGestureHidden];
}

- (id)initWithViewId:(int)viewId home:(BOOL)bHome
{
    self = [super init];
    _viewId = viewId;
    _bHome = bHome;
    return self;
}

- (id)initWithViewId:(int)viewId
{
    self = [super init];
    _viewId = viewId;
    return self;
}

- (void)showShareView
{
    NSString *strInfo = [NSString stringWithFormat:@"我在99乐投看到了一篇非常好的分析文章，分享给你，赶快过来看看吧!"];
    
    ZLShareViewController *viewControl = [[ZLShareViewController alloc] initWithTitle:strInfo url:_ideaDetail.html5url];
    
    [viewControl show];
}

- (void)sendGiftFail:(NSNotification *)notify
{
    
    int errorStr = [[NSString stringWithFormat:@"%@",notify.object] intValue];
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (errorStr==1014) {
            [UIAlertView createAlertViewWithTitle:@"提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"充值" withMessage:@"余额不足请充值" completionCallback:^(NSInteger index) {
                if (index==1) {
                    PaySelectViewController *paySelectVC = [[PaySelectViewController alloc] init];
                    [weakSelf.navigationController pushViewController:paySelectVC animated:YES];
                }
                
            }];
        }else {
            [MBProgressHUD showError:[NSString stringWithFormat:@"错误代码%d",errorStr]];
        }
        
        
    });
    
}

- (void)sendGiftResp:(NSNotification *)notify
{
    
    @WeakObj(self)

    dispatch_async(dispatch_get_main_queue(), ^{
        selfWeak.refreshCellDataBlock(NO,YES);
    });
    DLog(@"送礼成功");
}

- (void)loadGiftNotify:(NSNotification *)notify
{
    NSDictionary *parameter = notify.object;
    if (![parameter isKindOfClass:[NSDictionary class]])
    {
        return ;
    }
    @WeakObj(parameter)
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        
    GiftShowAnimate *giftAnimate = [[GiftShowAnimate alloc] initWithFrame:Rect(0,64,kScreenWidth-60,46) dict:parameterWeak];
    [UIView animateWithDuration:2.0
          delay:1.0
          options:UIViewAnimationOptionCurveEaseOut
          animations:^{
              [selfWeak.view addSubview:giftAnimate];
              [giftAnimate addrightViewAnimation];
           } completion:^(BOOL finished){
               @WeakObj(giftAnimate)
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [giftAnimateWeak removeFromSuperview];
                 });
             });
     }];
        
        
    });
}

- (void)sendTrader_error:(NSNotification *)notify
{
    NSString *strMsg = notify.object;
    if ([strMsg isEqualToString:@"金币不足"])
    {
        @WeakObj(self)
        dispatch_main_async_safe(^{
            [UIAlertView createAlertViewWithTitle:@"提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"充值" withMessage:@"余额不足请充值" completionCallback:^(NSInteger index)
             {
                 if (index==1)
                 {
                     PaySelectViewController *paySelectVC = [[PaySelectViewController alloc] init];
                     [selfWeak.navigationController pushViewController:paySelectVC animated:YES];
                 }
             }];
        });
    }
    else
    {
        @WeakObj(strMsg)
        dispatch_main_async_safe(
        ^{
            [ProgressHUD showError:strMsgWeak];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"观点正文"];
    commentCache = [[NSCache alloc] init];
    [commentCache setTotalCostLimit:10];
    UIButton *btnRight = [CustomViewController itemWithTarget:self action:@selector(showShareView) image:@"video_room_share_icon_n" highImage:@"video_room_share_icon_p"];
    [self setRightBtn:btnRight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTrader_error:) name:MESSAGE_VIEW_POINT_TRADER_ERR_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendGiftResp:) name:MESSAGE_VIEW_DETAILS_GIFT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyResp:) name:MESSAGE_IDEA_REPLY_RESPONSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentView:) name:MESSAGE_HTTP_REQUEST_REPLY_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendGiftFail:) name:MESSAGE_GIFT_VIEW_ERR_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGiftNotify:) name:MESSAGE_VIEWPOINT_GIFT_NOTIFY_VC object:nil];
    
    [self.view setBackgroundColor:COLOR_Bg_Gay];
    _tableView = [[UITableView alloc] initWithFrame:Rect(0,64, kScreenWidth,kScreenHeight-64)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view makeToastActivity_bird];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestMoreReply)];
    [_tableView.footer setHidden:YES];
    
    UIButton *btnGift = [ChatRightView createButton:Rect(kScreenWidth-60, kScreenHeight-155, 45, 45)];
    NSString *strName = [NSString stringWithFormat:@"chatRightView3"];
    [UIImageFactory createBtnImage:strName btn:btnGift state:UIControlStateNormal];
    
    UIButton *btnComment = [ChatRightView createButton:Rect(btnGift.x, kScreenHeight-83,btnGift.width, btnGift.height)];
    NSString *strComment = [NSString stringWithFormat:@"chatRightView4"];
    [UIImageFactory createBtnImage:strComment btn:btnComment state:UIControlStateNormal];
    [btnGift addTarget:self action:@selector(showGiftView) forControlEvents:UIControlEventTouchUpInside];
    [btnComment addTarget:self action:@selector(showChatInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnGift];
    [self.view addSubview:btnComment];
    
    _giftView = [[GiftView alloc] initWithFrame:Rect(0,-kRoom_head_view_height, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_giftView];
    _giftView.frame = Rect(0, kScreenHeight, kScreenWidth, 0);
    _giftView.delegate = self;
    
    _chatView = [[ChatView alloc] initWithFrame:Rect(0, 0, kScreenWidth,kScreenHeight) emoji:YES];
    [self.view addSubview:_chatView];
    _chatView.hidden = YES;
    _chatView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBodyView:) name:MESSAGE_HTTP_VIEWPOINTDETAIL_VC object:nil];
    [self requestView];
}

- (void)showGiftView
{
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1) {
        [_giftView updateGoid];
        [UIView animateWithDuration:0.5 animations:^{
            _giftView.hidden = NO;
            [_giftView setFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
        } completion:^(BOOL finished) {}];
    }
    else
    {
        [AlertFactory createLoginAlert:self withMsg:@"送礼物" block:^{}];
    }
}

/**
 *  获取更多评论
 */
- (void)requestMoreReply{
    if (_aryCommont.count>0)
    {
        ZLReply *reply = _aryCommont[_aryCommont.count-1];
        [kHTTPSingle RequestReply:_ideaDetail.viewpointid start:reply.replytid count:20];
        nCurrent+=20;
    }else{
        [_tableView.footer endRefreshing];
    }
}

//显示聊天界面
- (void)showChatInfo
{
    UserInfo *info = KUserSingleton;
    if(info.nType == 1 && info.bIsLogin)
    {
        [UIView animateWithDuration:0.5 animations:
         ^{
             _chatView.hidden = NO;
             [self.view addSubview:_chatView];
             [_chatView setFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
         } completion:^(BOOL finished) {}];
    }else{
        
        [AlertFactory createLoginAlert:self withMsg:@"聊天" block:^{
            
        }];
    }
}
/**
 *  退出信息，后退
 */
- (void)MarchBackLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)decodeDiction:(NSDictionary *)parameters
{
    if (parameters)
    {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak createContentView];
        });
    }
}

- (void)createContentView
{
    [self.view hideToastActivity];
    if (contentView)
    {
        for (UIView *view in contentView.subviews)
        {
            [view removeFromSuperview];
        }
        contentView = nil;
    }
    
    //计算正文内容 占据的高度
    _textView = [DTAttributedTextView new];
    _textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[_ideaDetail.content dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    _textView.textDelegate = self;
    _textView.shouldDrawImages = YES;
    _textView.shouldDrawLinks = YES;
    
    CGFloat height = [_textView.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
    
    contentView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, height+142)];
    [contentView addSubview:_textView];
    
    UILabel *lblAuthor = [[UILabel alloc] initWithFrame:Rect(8, 10,100, 20)];
    [lblAuthor setFont:XCFONT(13)];
    [lblAuthor setText:[NSString stringWithFormat:@"作者:%@",_ideaDetail.authorname]];
    [lblAuthor setTextColor:UIColorFromRGB(0x919191)];
    [contentView addSubview:lblAuthor];
    
    UILabel *lblTime = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-160, lblAuthor.y, 150, 20)];
    [lblTime setTextColor:UIColorFromRGB(0x919191)];
    [lblTime setText:_ideaDetail.publishtime];
    [lblTime setFont:XCFONT(13)];
    [lblTime setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:lblTime];
    
    _textView.frame = Rect(10,lblTime.y+lblTime.height+10, kScreenWidth-20, height);
    [self updateContentView];
    
    [_tableView setTableHeaderView:contentView];
    //TODD:请求评论信息

    [kHTTPSingle RequestReply:_viewId start:0 count:20];
    nCurrent = 20;
    [_tableView reloadData];
}

- (void)updateContentView
{
    if (!downContentView) {
        downContentView = [[UIView alloc] initWithFrame:Rect(0, _textView.y+_textView.height+10, kScreenWidth, 67)];
        [contentView addSubview:downContentView];
        
        UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 30)];
        [lblTemp setText:@"【仅代表个人观点,不构成投资建议,风险自负】"];
        [lblTemp setTextColor:UIColorFromRGB(0x555555)];
        [lblTemp setFont:XCFONT(13)];
        lblTemp.numberOfLines = 0;
        [lblTemp setTextAlignment:NSTextAlignmentCenter];
        [downContentView addSubview:lblTemp];
        
        UILabel *lblLine = [[UILabel alloc] initWithFrame:Rect(0,lblTemp.y+lblTemp.height+45,kScreenWidth, 0.5)];
        [lblLine setBackgroundColor:kLineColor];
        [downContentView addSubview:lblLine];
        
        UILabel *lblTalk = [[UILabel alloc] initWithFrame:Rect(10, lblLine.y-11,75, 23)];
        [lblTalk setText:@"发表评论"];
        [lblTalk setTextColor:UIColorFromRGB(0xffffff)];
        [lblTalk setFont:XCFONT(15)];
        [lblTalk setBackgroundColor:UIColorFromRGB(0xffa200)];
        [lblTalk setTextAlignment:NSTextAlignmentCenter];
        lblTalk.layer.masksToBounds= YES;
        lblTalk.layer.cornerRadius = 10;
        [downContentView addSubview:lblTalk];
    }else
    {
        downContentView.frame = Rect(0, _textView.y+_textView.height+10, kScreenWidth,67);
    }
}

/**
 *  不使用赞
 */
- (void)zanViewDeatails
{
    
}

//请求详情
- (void)requestView
{
    [kHTTPSingle RequestViewpointDetail:_viewId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_aryCommont.count==0 && _ideaDetail)
    {
        return 1;
    }
    return _aryCommont.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_aryCommont.count==0)
    {
        [_tableView.footer setHidden:YES];
        ReplyNullInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyNullInfocell"];
        if (!cell) {
            cell = [[ReplyNullInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReplyNullInfocell"];
        }
        @WeakObj(self)
        [cell clickWithBlock:^(UIGestureRecognizer *gesture) {
            [UIView animateWithDuration:0.5 animations:
             ^{
                 selfWeak.chatView.hidden = NO;
                 [selfWeak.view addSubview:selfWeak.chatView];
                 [selfWeak.chatView setFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
             } completion:^(BOOL finished) {}];
            [selfWeak showChatInfo];
        }];
        return cell;
    }
    DTAttributedTextCell *cell = [self bufferView:tableView index:indexPath];
    
    return cell;
}

- (DTAttributedTextCell *)bufferView:(UITableView *)tableView index:(NSIndexPath *)indexPath
{
    NSString *strKey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    CommentCell *cell = [commentCache objectForKey:strKey];
    if(!cell)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentIdentifier"];
        [commentCache setObject:cell forKey:strKey];
    }
    if(_aryCommont.count > indexPath.row)
    {
        ZLReply *reply = [_aryCommont objectAtIndex:indexPath.row];
        cell.textDelegate = self;
        [cell setReplyModel:reply];
    }
    return cell;
}

- (void)updateTextView:(NSURL*)url changeSize:(CGSize)size
{
    CGSize imageSize ;
    if (size.width>kScreenWidth) {
        imageSize.width = (kScreenWidth-20);
        CGFloat width = imageSize.width;
        imageSize.height = size.height/(size.width/width);
    }
    else
    {
        imageSize = size;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    BOOL didUpdate = NO;
    for (DTTextAttachment *oneAttachment in [_textView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            didUpdate = YES;
        }
    }
    if (didUpdate)
    {
        //重新加载图片
        [_textView relayoutText];
        CGRect frame = contentView.frame;
        CGFloat height = [_textView.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
        CGRect textFrame = _textView.frame;
        contentView.frame = Rect(0, 0, kScreenWidth,frame.size.height-textFrame.size.height+height);
        //需要重新设置contentView  刷新tableview table HeaderView 更新
        [_tableView setTableHeaderView:contentView];
        _textView.frame = Rect(10,textFrame.origin.y, kScreenWidth-20, height);
        [self updateContentView];
    }
}

#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = nil;
        if (_textView.attributedTextContentView == attributedTextContentView ) {
            imageView = [[UIImageView alloc] initWithFrame:frame];
            @WeakObj(self)
            [imageView sd_setImageWithURL:attachment.contentURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [selfWeak updateTextView:imageURL changeSize:image.size];
            }];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageInfo:)]];
            return imageView;
        }
        else {
            imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView sd_setImageWithURL:attachment.contentURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            imageView.userInteractionEnabled = YES;
            return imageView;
        }
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

/**
 *  超链接点击后的事件
 */
- (void)linkPushed:(DTLinkButton *)sender
{
    DLog(@"路径:%@",sender.URL.absoluteString);
    //只针对特殊的超链接做处理
    if ([sender.URL.absoluteString rangeOfString:@","].location != NSNotFound) {
        NSArray *array = [sender.URL.absoluteString componentsSeparatedByString:@","];
        if([array[0] rangeOfString:@"sqchatid://"].location != NSNotFound && [array[1] length]>0)
        {
            NSString *strNumber = [sender.URL.absoluteString stringByReplacingOccurrencesOfString:@"sqchatid://" withString:@""];
            if([strNumber intValue] == KUserSingleton.nUserId)
            {
                [ProgressHUD showError:@"不能对自己回复"];
            }
            else {
                RoomUser *rUser = [[RoomUser alloc] init];
                rUser.m_strUserAlias = [array[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                rUser.m_nUserId = [strNumber intValue];
                _chatView.nDetails = [array[2] intValue];
                [UIView animateWithDuration:0.5 animations:
                 ^{
                     _chatView.hidden = NO;
                     [self.view addSubview:_chatView];
                     [_chatView setFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
                 } completion:^(BOOL finished) {}];
                [_chatView setChatInfo:rUser];
            }
        }
    }
}

/**
 *
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_aryCommont.count==0) {
        return 200;
    }
    if (_aryCommont.count>indexPath.row)
    {
        DTAttributedTextCell *cell = [self bufferView:tableView index:indexPath];
        return [cell requiredRowHeightInTableView:tableView]+40;
    }
    return 0;
}

/**
 *  加载评论信息,执行刷新操作
 */
- (void)loadCommentView:(NSNotification  *)notify
{
    NSDictionary *parameters = [notify object];
    if ([[parameters objectForKey:@"code"] intValue]==1)
    {
        if (_aryCommont.count>0 && _aryCommont.count != nCurrent)
        {
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:_aryCommont];
            NSArray *aryParameters = parameters[@"model"];
            for (ZLReply *model in aryParameters)
            {
                [array addObject:model];
            }
            _aryCommont = array;
        }
        else
        {
            _aryCommont = parameters[@"model"];
        }
        __weak UITableView *__tableView = _tableView;
        __block int __ncurrent = nCurrent;
        dispatch_async(dispatch_get_main_queue(),
        ^{
           [__tableView.footer endRefreshing];
           if (__ncurrent!=_aryCommont.count)
           {
               [__tableView.footer noticeNoMoreData];
           }else
           {
               [__tableView.footer setHidden:NO];
               [__tableView.footer resetNoMoreData];
           }
           [__tableView reloadData];
        });
    }
}

- (void)replyResp:(NSNotification *)notify
{
    NSDictionary *parameters = [notify object];
    @WeakObj(self)

    if ([[parameters objectForKey:@"code"] intValue]==1) {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [ProgressHUD showSuccess:@"评论成功!"];
            selfWeak.refreshCellDataBlock(YES,NO);
        });
        NSMutableArray *aryTemp = [NSMutableArray array];
        ZLReply *reply = parameters[@"model"];
        [aryTemp addObject:reply];
        for (ZLReply *ply in _aryCommont)
        {
            [aryTemp addObject:ply];
        }
        _aryCommont = aryTemp;
        nCurrent++;
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak.tableView reloadData];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showError:@"评论失败!"];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
    
}

- (void)loadBodyView:(NSNotification *)notify
{
    NSDictionary *parameters = notify.object;
    DLog(@"dict:%@",parameters);
    if ([[parameters objectForKey:@"code"] intValue]==1) {
        TQIdeaDetailModel *model =[parameters objectForKey:@"model"];
        if (model!=nil) {
            _ideaDetail = model;
            @WeakObj(self)
            @WeakObj(noView)
            dispatch_async(dispatch_get_main_queue(), ^{
                if (noViewWeak) {
                    [noViewWeak removeFromSuperview];
                }
                [selfWeak createContentView];
            });
        }
    }else
    {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak.view hideToastActivity];
            //[selfWeak loadNullView];
            [selfWeak showErrorViewInView:selfWeak.tableView withMsg:RequestState_NetworkErrorStr(@"AnswerViewController") touchHanleBlock:^{
                @StrongObj(self);
                [self.view makeToastActivity_bird];
                [self requestView];
            }];
        });
    }
}

- (void)loadNullView
{
    [self.tableView.header endRefreshing];
    if (!noView) {
        char cString[255];
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        sprintf(cString, "%s/network_anomaly_fail.png",path);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        UIImage *image = [UIImage imageWithContentsOfFile:objCString];
        if(image)
        {
            noView = [ViewNullFactory createViewBg:Rect(0,0,kScreenWidth,_tableView.height-0) imgView:image msg:@"获取观点详情失败"];
            [noView setUserInteractionEnabled:NO];
            [_tableView addSubview:noView];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/**
 * 评论成功响应
 */
- (void)addCommentView:(NSNotification *)notify
{
//    NSNumber *number = notify.object;
//    if([number intValue])
//    {
//        [_tcpSocket reqIdeaDetails:0 count:20 ideaId:[_jsonModel.viewid integerValue]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [ProgressHUD showSuccess:@"评论成功"];
//        });
//    }
}

/**
 *  选中行后，互动
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_aryCommont.count > indexPath.row) {
        ZLReply *reply = [_aryCommont objectAtIndex:indexPath.row];
        if([reply.authorid intValue]== KUserSingleton.nUserId)
        {
            [ProgressHUD showError:@"不能回复自己的信息"];
        }
        else
        {
            [self showChatView:[reply.authorid intValue] name:reply.authorname commentId:reply.replytid];
        }
    }
}

//加入表情图片
- (void)insertEmoji:(NSInteger)nId
{
    NSString *strInfo = [NSString stringWithFormat:@"%zi",nId];
    NSString *strContent = [NSString stringWithFormat:@"[$%zi$]",nId];
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    emojiTextAttachment.emojiTag = strContent;
    emojiTextAttachment.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:strInfo ofType:@"gif"]];
    emojiTextAttachment.emojiSize = CGSizeMake(15,15);
    [_textChat.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                          atIndex:_textChat.selectedRange.location];
    _textChat.selectedRange = NSMakeRange(_textChat.selectedRange.location + 1, _textChat.selectedRange.length);
    if ([_textChat.textStorage getPlainString].length==0){
        lblPlace.text = @"点此和大家说点什么吧";
    }
    else{
        lblPlace.text = @"";
    }
    [self resetTextStyle];
}


#pragma mark TextChat CoreText
- (void)resetTextStyle
{
    NSRange wholeRange = NSMakeRange(0, _textChat.textStorage.length);
    [_textChat.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textChat.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22.0f] range:wholeRange];
}

/**
 *  发送评论
 *
 */
- (void)sendMessage:(UITextView *)textView userid:(int)nUser reply:(int32_t)nDetails
{
    
    // 不能发送空字符和全部换行符号
    NSString *str = textView.text;
    NSString *textStr =[str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSString *textNewStr = [textStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (textNewStr.length==0) {
        [ProgressHUD showError:@"不能发送空信息"];
        textView.text = @"";

        return ;
    }
    
    
    UserInfo *info = KUserSingleton;
    if (info.nType != 1 && info.bIsLogin) {
        
        [AlertFactory createLoginAlert:self withMsg:@"发表评论" block:^{
            
        }];

        
        return ;
    }
    if ([textView.textStorage getPlainString].length == 0)
    {
        [ProgressHUD showError:@"不能发送空信息"];
        return ;
    }
    int toUser = !nUser ? [_ideaDetail.authorId intValue] : nUser;
    NSString *strComment = [textView.textStorage getPlainString];

    char cBuf[1024]={0};
    ::strcpy(cBuf,[strComment UTF8String]);
    [kHTTPSingle PostReply:_viewId replyId:nDetails author:KUserSingleton.nUserId content:cBuf fromId:toUser];
    textView.text = @"";
    [_chatView setHidden:YES];
    _chatView.nUserId = 0;
}

/**
 *  cell设置
 */
- (void)commentCell:(ZLReply *)reply
{
    if (reply)
    {
        [self showChatView:reply.parentreplyid name:reply.authorname commentId:[reply.fromauthorid intValue]];
    }
}
/**
 *  根据评论记录，显示回复信息
 */

- (void)showChatView:(int)viewuserid name:(NSString *)strName commentId:(int)commentId
{
    UserInfo *__userInfo = [UserInfo sharedUserInfo];
    if (viewuserid != __userInfo.nUserId) {
        RoomUser *user = [[RoomUser alloc] init];
        user.m_nUserId = viewuserid;
        user.m_strUserAlias = strName;
        _chatView.nDetails = commentId;
        [UIView animateWithDuration:0.5 animations:
         ^{
             _chatView.hidden = NO;
             [self.view addSubview:_chatView];
             [_chatView setFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
         } completion:^(BOOL finished) {}];
        [_chatView setChatInfo:user];
    }
    else
    {
        [MBProgressHUD showError:@"不能对自己回复"];
    }
}

/**
 *  释放
 */
- (void)dealloc
{
    DLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

/**
 *  显示图片
 */
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


@end
