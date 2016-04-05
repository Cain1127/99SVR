//
//  NewViewDetailsViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "NewDetailsViewController.h"
#import "TextTcpSocket.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "Toast+UIView.h"
#import "MBProgressHUD.h"
#import "ProgressHUD.h"
#import "ProgressHUD.h"
#import "RoomUser.h"
#import "UserInfo.h"
#import "ProgressHUD.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Toast+UIView.h"
#import "IdeaDetailRePly.h"
#import "CommentCell.h"
#import "BaseService.h"
#import "IdeaDetails.h"
#import "TeacherModel.h"
#import "NewDetailsModel.h"
#import "NSAttributedString+EmojiExtension.h"
#import "EmojiTextAttachment.h"
#import "TextChatView.h"
#import "ChatView.h"
#import "TextCommentView.h"
#import <DTCoreText/DTCoreText.h>
//#import "DTCoreText.h"

@interface NewDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ChatViewDelegate,UIScrollViewDelegate,DTAttributedTextContentViewDelegate,CommentDelegate,UIWebViewDelegate>
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
    
}
@property (nonatomic,strong) DTAttributedTextView *textView;
@property (nonatomic,strong) UIView *downContentView;
@property (nonatomic) int keyboardPresentFlag;
@property (nonatomic,strong) UIButton *btnThum;
@property (nonatomic,copy) NSString *strTo;
@property (nonatomic,strong) UIButton *btnSend;
@property (nonatomic,copy) NSArray *aryCommont;
@property (nonatomic,strong) NewDetailsModel *jsonModel;
@property (nonatomic,strong) TextTcpSocket *tcpSocket;
@property (nonatomic,strong) IdeaDetails *details;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) int64_t viewId;

@end

@implementation NewDetailsViewController
@synthesize downContentView;

- (id)initWithSocket:(TextTcpSocket *)tcpSocket viewID:(int64_t)viewId
{
    self = [super init];
    _tcpSocket = tcpSocket;
    _viewId = viewId;
    return self;
}

- (id)initWithSocket:(TextTcpSocket *)tcpSocket model:(IdeaDetails *)details
{
    self = [super init];
    _tcpSocket = tcpSocket;
    _details = details;
    _viewId = _details.messageid;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"观点正文"];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    _tableView = [[UITableView alloc] initWithFrame:Rect(0,64, kScreenWidth,kScreenHeight-114)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view makeToastActivity];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initUIHead];
   
    UIView *bodyView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50, kScreenWidth,50)];
    [bodyView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self.view addSubview:bodyView];
    [bodyView setUserInteractionEnabled:YES];
    
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
    btnEmoji.frame = Rect(whiteView.width-36, 0, 36, 36);
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
    
    @WeakObj(_chatView)
    [bodyView clickWithBlock:^(UIGestureRecognizer *gesture) {
        _chatViewWeak.hidden = !_chatViewWeak.hidden;
    }];
}

- (void)MarchBackLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    [_tcpSocket clearCommentAry];
}

- (void)initUIHead
{
    __weak NewDetailsViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [__self requestView];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)decodeDiction:(NSDictionary *)parameters
{
    if (parameters)
    {
        if(_jsonModel)
        {
            _jsonModel = nil;
        }
        _jsonModel = [NewDetailsModel resultWithDict:parameters];
        __weak NewDetailsViewController *__self = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self createContentView];
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
    _textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[_jsonModel.ccontent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    _textView.textDelegate = self;
    _textView.shouldDrawImages = YES;
    _textView.shouldDrawLinks = YES;
    
    CGFloat height = [_textView.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-16].height;
    DLog(@"height:%f",height);
    
    CGRect frame = [_jsonModel.title boundingRectWithSize:CGSizeMake(kScreenWidth-16, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(17)} context:nil];
    
    contentView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, height+250+frame.size.height)];
    [contentView addSubview:_textView];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:Rect(8, 30, kScreenWidth-16, frame.size.height)];
    [lblTitle setFont:XCFONT(17)];
    [lblTitle setText:_jsonModel.title];
    [contentView addSubview:lblTitle];
    
    UILabel *lblAuthor = [[UILabel alloc] initWithFrame:Rect(8, lblTitle.y+lblTitle.height+20,100, 20)];
    [lblAuthor setFont:XCFONT(13)];
    [lblAuthor setText:[NSString stringWithFormat:@"作者:%@",_jsonModel.calias]];
    [lblAuthor setTextColor:UIColorFromRGB(0x919191)];
    [contentView addSubview:lblAuthor];
    
    UILabel *lblTime = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-160, lblAuthor.y, 150, 20)];
    [lblTime setTextColor:UIColorFromRGB(0x919191)];
    [lblTime setText:_jsonModel.dtime];
    [lblTime setFont:XCFONT(13)];
    [lblTime setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:lblTime];
    
    _textView.frame = Rect(8,lblTime.y+lblTime.height+10, kScreenWidth-16, height);
    [self updateContentView];
   
    [_tableView setTableHeaderView:contentView];
    [_tcpSocket reqIdeaDetails:0 count:20 ideaId:[_jsonModel.viewid integerValue]];
}

- (void)updateContentView
{
    if (!_btnThum) {
        _btnThum = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *temp = [NSString stringWithFormat:@"%d  赞一个",[_jsonModel.czans intValue]];
        [_btnThum setTitle:temp forState:UIControlStateNormal];
        [_btnThum setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_btnThum setTitleColor:kNavColor forState:UIControlStateHighlighted];
        
        [_btnThum setImage:[UIImage imageNamed:@"text_viewpoint_like_icon"] forState:UIControlStateHighlighted];
        [_btnThum setImage:[UIImage imageNamed:@"thun_new"] forState:UIControlStateNormal];
        
        [_btnThum setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
        [_btnThum setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
        _btnThum.tag = 1008;
        [contentView addSubview:_btnThum];
        _btnThum.layer.masksToBounds = YES;
        _btnThum.layer.cornerRadius = 3;
        _btnThum.titleLabel.font = XCFONT(17);
        _btnThum.frame = Rect(contentView.width/2-92, _textView.y+_textView.height+30, 194,40);
        UIEdgeInsets inset = _btnThum.imageEdgeInsets;
        inset.left -= 10;
        _btnThum.imageEdgeInsets = inset;
        [_btnThum addTarget:self action:@selector(zanViewDeatails) forControlEvents:UIControlEventTouchUpInside];
    }
    _btnThum.frame = Rect(contentView.width/2-92, _textView.y+_textView.height+30, 194,40);
    if (!downContentView) {
        downContentView = [[UIView alloc] initWithFrame:Rect(0, _btnThum.y+_btnThum.height+10, kScreenWidth, 67)];
        [contentView addSubview:downContentView];
        
        UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 10)];
        [lblTemp setText:@"【仅代表个人观点,不构成投资建议,风险自负】"];
        [lblTemp setTextColor:UIColorFromRGB(0x555555)];
        [lblTemp setTextAlignment:NSTextAlignmentCenter];
        [downContentView addSubview:lblTemp];
        
        UILabel *lblLine = [[UILabel alloc] initWithFrame:Rect(76,lblTemp.y+lblTemp.height+45,kScreenWidth-76, 0.5)];
        [lblLine setBackgroundColor:kLineColor];
        [downContentView addSubview:lblLine];
        
        UILabel *lblTalk = [[UILabel alloc] initWithFrame:Rect(0, lblLine.y-11,75, 23)];
        [lblTalk setText:@"发表评论"];
        [lblTalk setTextColor:UIColorFromRGB(0xffffff)];
        [lblTalk setFont:XCFONT(15)];
        [lblTalk setBackgroundColor:UIColorFromRGB(0xffa200)];
        [lblTalk setTextAlignment:NSTextAlignmentCenter];
        lblTalk.layer.masksToBounds= YES;
        lblTalk.layer.cornerRadius = 10;
        [downContentView addSubview:lblTalk];
    }
    downContentView.frame = Rect(0, _btnThum.y+_btnThum.height+10, kScreenWidth,67);
}

- (void)zanViewDeatails
{
    [self performSelector:@selector(zanFailInfo) withObject:nil afterDelay:5.0];
    [self.view makeToastActivity];
    
    [_tcpSocket reqCommentZan:[_jsonModel.viewid integerValue]];
}

- (void)zanFailInfo
{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.view hideToastActivity];
        [ProgressHUD showError:@"点赞响应超时"];
    });
}


- (void)zanResult:(NSNotification *)notify
{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.view hideToastActivity];
        [NSObject cancelPreviousPerformRequestsWithTarget:selfWeak];
    });
    NSNumber *result = notify.object;
    @WeakObj(contentView)
    if ([result intValue]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *sender = [contentViewWeak viewWithTag:1008];
            [ProgressHUD showSuccess:@"点赞成功"];
            [sender setTitle:[NSString stringWithFormat:@"已赞"] forState:UIControlStateNormal];
            [sender setEnabled:NO];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showError:@"点赞失败"];
        });
    }
}

- (void)requestView
{
    
    _fall++;
    if (_fall>3) {
        DLog(@"请求不到数据信息");
        dispatch_main_async_safe(^{
           [self.view hideToastActivity];
           [ProgressHUD showError:@"加载观点信息失败"];
        });
        return ;
    }
    NSString *strInfo = [NSString stringWithFormat:@"%@%lld.html",kTEXT_NEW_DETAILS_URL,_viewId];
    __weak NewDetailsViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject)
    {
        NSDictionary *parameter = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil removingNulls:YES ignoreArrays:NO];
        if (parameter && [parameter objectForKey:@"data"])
        {
            [__self decodeDiction:[parameter objectForKey:@"data"]];
        }
    }
    fail:^(NSError *error)
    {
        DLog(@"请求失败,重新请求");
        [__self requestView];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryCommont.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"commentIdentifier";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(_aryCommont.count > indexPath.row)
    {
        IdeaDetailRePly *comment = [_aryCommont objectAtIndex:indexPath.row];
        cell.textView.shouldDrawImages = YES;
        cell.textView.delegate = self;
        cell.textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[comment.strContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
        [cell setModel:comment];
    }
    return cell;
}

- (void)updateTextView:(NSURL*)url changeSize:(CGSize)size
{
    CGSize imageSize = size;
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
 *  超链接组装
 */
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    [attributes objectForKey:@"value"];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25);
    button.GUID = identifier;
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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
            RoomUser *rUser = [[RoomUser alloc] init];
            rUser.m_strUserAlias = [array[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            rUser.m_nUserId = [strNumber intValue];
            _chatView.nDetails = [array[2] intValue];
            [_chatView setChatInfo:rUser];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_aryCommont.count>indexPath.row)
    {
        IdeaDetailRePly *comment = [_aryCommont objectAtIndex:indexPath.row];
        DTAttributedTextContentView *content = [DTAttributedTextContentView new];
        content.attributedString = [[NSAttributedString alloc] initWithHTMLData:[comment.strContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
        CGFloat height = [content suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-80].height;
        return height+34;
    }
    return 0;
}

- (void)loadCommentView
{
    _aryCommont = _tcpSocket.aryComment;
    __weak UITableView *__tableView = _tableView;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentView) name:MESSAGE_TEXT_COMMENT_LIST_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommentView:) name: MESSAGE_TEXT_ROOM_REPLAY_NEW_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zanResult:) name:MESSAGE_TEXT_VIEW_ZAN_RESP_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addCommentView:(NSNotification *)notify
{
    NSNumber *number = notify.object;
    if([number intValue])
    {
        [_tcpSocket reqIdeaDetails:0 count:20 ideaId:[_jsonModel.viewid integerValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showSuccess:@"评论成功"];
        });
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_aryCommont.count > indexPath.row) {
        IdeaDetailRePly *reply = [_aryCommont objectAtIndex:indexPath.row];
        [self showChatView:reply.viewuserid name:reply.strName commentId:reply.commentid];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([_textChat.textStorage getPlainString].length==0)
    {
        lblPlace.text = @"点此和大家说点什么吧";
    }
    else
    {
        lblPlace.text = @"";
    }
}

#pragma mark EmojiViewDelegate
- (void)sendEmojiInfo:(NSInteger)nId
{
    [self insertEmoji:nId];
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
    if ([_textChat.textStorage getPlainString].length==0)
    {
        lblPlace.text = @"点此和大家说点什么吧";
    }
    else
    {
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

- (void)sendMessage:(UITextView *)textView userid:(int)nUser reply:(int64_t)nDetails
{
    if ([textView.textStorage getPlainString].length == 0)
    {
        [self.view makeToast:@"不能发送空信息"];
        return ;
    }
    NSString *strComment = [textView.textStorage getPlainString];
    int toId = !nUser?[_jsonModel.teacherid intValue]:nUser;
    [_tcpSocket replyCommentReq:strComment msgid:[_jsonModel.viewid integerValue]
                           toid:toId srccom:nDetails];
    textView.text = @"";
    [_chatView setHidden:YES];
}

- (void)commentCell:(IdeaDetailRePly *)Reply
{
    if (Reply) {
        [self showChatView:Reply.viewuserid name:Reply.strName commentId:Reply.commentid];
    }
}
/**
 *  根据评论记录，显示回复信息
 */

- (void)showChatView:(int)viewuserid name:(NSString *)strName commentId:(int64_t)commentId
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

- (void)dealloc
{
    DLog(@"dealloc");
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
@end
