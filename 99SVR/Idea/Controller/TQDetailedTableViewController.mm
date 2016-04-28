//
//  TQDetailedTableViewController.m
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 专家观点详情>**********************************/

#import "TQDetailedTableViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "MJRefresh.h"
#import "CommentCell.h"
#import "ZLReply.h"
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

@interface TQDetailedTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ChatViewDelegate,UIScrollViewDelegate,DTAttributedTextContentViewDelegate,UIWebViewDelegate,CommentDelegate>
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
    ChatView *_chatView;
    int nCurrent;
    UIView *noView;
}
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

@implementation TQDetailedTableViewController

@synthesize downContentView;

- (id)initWithViewId:(int)viewId home:(BOOL)bHome{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"观点正文"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyRepson:) name:MESSAGE_IDEA_REPLY_RESPONSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentView:) name:MESSAGE_HTTP_REQUEST_REPLY_VC object:nil];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    _tableView = [[UITableView alloc] initWithFrame:Rect(0,64, kScreenWidth,kScreenHeight-114)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view makeToastActivity];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *bodyView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50, kScreenWidth,50)];
    [bodyView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [self.view addSubview:bodyView];
    [bodyView setUserInteractionEnabled:YES];
    
    UILabel *lblLine = [UILabel new];
    [lblLine setBackgroundColor:UIColorFromRGB(0xCFCFCF)];
    [bodyView addSubview:lblLine];
    lblLine.frame = Rect(0, 0.1, kScreenWidth, 0.5);
    
    UIView *whiteView = [[UIView alloc] initWithFrame:Rect(8,8,kScreenWidth-76,36)];
    [bodyView addSubview:whiteView];
    [whiteView setBackgroundColor:UIColorFromRGB(0xffffff)];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 3;
    whiteView.layer.borderColor = UIColorFromRGB(0xE3E3E3).CGColor;
    whiteView.layer.borderWidth = 0.5;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:Rect(10,5, kScreenWidth-20, 40)];
    [bodyView addSubview:textField];
    [textField setFont:XCFONT(15)];
    [textField setTextColor:UIColorFromRGB(0x343434)];
    [textField setPlaceholder:@"点此和大家说点什么吧"];
    textField.enabled = NO;
    textField.userInteractionEnabled = NO;
    
    UIButton *btnEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEmoji setImage:[UIImage imageNamed:@"Expression"] forState:UIControlStateNormal];
    [btnEmoji setImage:[UIImage imageNamed:@"Expression_t"] forState:UIControlStateHighlighted];
    [whiteView addSubview:btnEmoji];
    btnEmoji.frame = Rect(whiteView.width-40, 0, 40, 40);
    btnEmoji.userInteractionEnabled = NO;
    
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [btnSend setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateNormal];
    btnSend.titleLabel.font = XCFONT(15);
    [bodyView addSubview:btnSend];
    btnSend.frame = Rect(kScreenWidth-60,whiteView.y, 50, 36);
    btnSend.layer.masksToBounds = YES;
    btnSend.layer.cornerRadius = 3;
    btnSend.layer.borderWidth = 0.5;
    [btnSend setBackgroundColor:UIColorFromRGB(0xffffff)];
    btnSend.layer.borderColor = UIColorFromRGB(0xf0f0f0).CGColor;
    [btnSend setBackgroundImage:[UIImage imageNamed:@"video_present_number_bg"] forState:UIControlStateHighlighted];
    btnSend.userInteractionEnabled = NO;
    
    _chatView = [[ChatView alloc] initWithFrame:Rect(0, 0, kScreenWidth,kScreenHeight)];
    [self.view addSubview:_chatView];
    _chatView.hidden = YES;
    _chatView.delegate = self;
    
    @WeakObj(self)
    [bodyView clickWithBlock:^(UIGestureRecognizer *gesture) {
        [selfWeak showChatInfo];
    }];
    
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestMoreReply)];
}

/**
 *  获取更多评论
 */
- (void)requestMoreReply{
    if (_aryCommont.count>0) {
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
        _chatView.hidden = NO;
    }else{
//        @WeakObj(self)
        [AlertFactory createLoginAlert:self block:^{
            
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
    
    CGFloat height = [_textView.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-16].height;
    
    contentView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, height+102)];
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
    
    _textView.frame = Rect(8,lblTime.y+lblTime.height+10, kScreenWidth-16, height);
    [self updateContentView];
    
    [_tableView setTableHeaderView:contentView];
    //TODD:请求评论信息

    [kHTTPSingle RequestReply:_viewId start:0 count:20];
    nCurrent = 20;
    [_tableView reloadData];
//    [_tableView.footer noticeNoMoreData];
//    [_tableView.footer ];
    
}

- (void)updateContentView
{
    if (!downContentView) {
        downContentView = [[UIView alloc] initWithFrame:Rect(0, _textView.y+_textView.height+10, kScreenWidth, 67)];
        [contentView addSubview:downContentView];
        
        UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 10)];
        [lblTemp setText:@"【仅代表个人观点,不构成投资建议,风险自负】"];
        [lblTemp setTextColor:UIColorFromRGB(0x555555)];
        [lblTemp setTextAlignment:NSTextAlignmentCenter];
        [downContentView addSubview:lblTemp];
        
        UILabel *lblLine = [[UILabel alloc] initWithFrame:Rect(76,lblTemp.y+lblTemp.height+45,kScreenWidth-76, 0.5)];
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
    if (_aryCommont.count==0)
    {
        return 1;
    }
    return _aryCommont.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"commentIdentifier";
    
    if(_aryCommont.count==0)
    {
        ReplyNullInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyNullInfocell"];
        if (!cell) {
            cell = [[ReplyNullInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReplyNullInfocell"];
        }
        return cell;
    }
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(_aryCommont.count > indexPath.row)
    {
        ZLReply *reply = [_aryCommont objectAtIndex:indexPath.row];
        cell.textView.shouldDrawImages = YES;
        cell.textView.delegate = self;
        
        cell.textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[reply.strContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
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
        CGFloat height = [_textView.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-16].height;
        CGRect textFrame = _textView.frame;
        contentView.frame = Rect(0, 0, kScreenWidth,frame.size.height-textFrame.size.height+height);
        //需要重新设置contentView  刷新tableview table HeaderView 更新
        [_tableView setTableHeaderView:contentView];
        _textView.frame = Rect(8,textFrame.origin.y, kScreenWidth-16, height);
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
        ZLReply *comment = [_aryCommont objectAtIndex:indexPath.row];
        DTAttributedTextContentView *content = [DTAttributedTextContentView new];
        content.attributedString = [[NSAttributedString alloc] initWithHTMLData:[comment.strContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
        CGFloat height = [content suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-80].height;
        return height+34;
    }
    return 0;
}

/**
 *  加载评论信息,执行刷新操作
 */
- (void)loadCommentView:(NSNotification  *)notify
{
    NSDictionary *parameters = [notify object];
    if ([[parameters objectForKey:@"code"] intValue]==1) {
        _aryCommont = parameters[@"model"];
        __weak UITableView *__tableView = _tableView;
        __block int __ncurrent = nCurrent;
        dispatch_async(dispatch_get_main_queue(),
        ^{
           [__tableView.footer endRefreshing];
           if (__ncurrent!=_aryCommont.count) {
               [__tableView.footer noticeNoMoreData];
           }
           [__tableView reloadData];
        });
    }
}

- (void)replyRepson:(NSNotification *)notify
{
    NSDictionary *parameters = [notify object];
    if ([[parameters objectForKey:@"code"] intValue]==1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showSuccess:@"评论成功!"];
        });
        [kHTTPSingle RequestReply:_viewId start:0 count:20];
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
   //可能需要重连
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBodyView:) name:MESSAGE_HTTP_VIEWPOINTDETAIL_VC object:nil];
    [self requestView];
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
            [selfWeak loadNullView];
        });
    }
}

- (void)loadNullView
{
    [self.tableView.header endRefreshing];
    if (!noView) {
        char cString[255];
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        sprintf(cString, "%s/customized_no_opened.png",path);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        UIImage *image = [UIImage imageWithContentsOfFile:objCString];
        if(image)
        {
            noView = [ViewNullFactory createViewBg:Rect(0,10,kScreenWidth,_tableView.height-10) imgView:image msg:@"获取观点详情失败"];
            [_tableView addSubview:noView];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [self showChatView:reply.parentreplyid name:reply.authorname commentId:[reply.fromauthorid intValue]];
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
    UserInfo *info = KUserSingleton;
    if (info.nType != 1 && info.bIsLogin) {
        [AlertFactory createLoginAlert:self block:^{
        }];
        return ;
    }
    if ([textView.textStorage getPlainString].length == 0)
    {
        [ProgressHUD showError:@"不能发送空信息"];
        return ;
    }
    
    NSString *strComment = [textView.textStorage getPlainString];
    int toId = !nUser?[_ideaDetail.authorId intValue]:nUser;

    char cBuf[1024]={0};
    ::strcpy(cBuf,[strComment UTF8String]);
    [kHTTPSingle PostReply:_viewId replyId:nDetails author:KUserSingleton.nUserId content:cBuf fromId:toId];
    
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
        [_chatView setChatInfo:user];
    }
    else{
        [MBProgressHUD showError:@"不能对自己回复"];
    }
}

/**
 *  释放
 */
- (void)dealloc
{
    DLog(@"dealloc");
    if(_bHome){
        
    }
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
