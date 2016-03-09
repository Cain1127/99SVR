//
//  NewViewDetailsViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "NewDetailsViewController.h"
#import "TextTcpSocket.h"
#import "UIImageView+WebCache.h"
#import "Toast+UIView.h"
#import "IdeaDetailRePly.h"
#import "CommentCell.h"
#import <DTCoreText/DTCoreText.h>
#import "BaseService.h"
#import "IdeaDetails.h"
#import "TeacherModel.h"
#import "NewDetailsModel.h"
#import "EmojiView.h"
#import "NSAttributedString+EmojiExtension.h"
#import "EmojiTextAttachment.h"

@interface NewDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,EmojiViewDelegate,UIScrollViewDelegate,DTAttributedTextContentViewDelegate>
{
    UIView *contentView;
    UILabel *lblPlace;
    UITextView *_textChat;
    CGFloat deltaY;
    UIView *downView;
    CGFloat duration;
    CGFloat originalY;
    EmojiView *_emojiView;
}
@property (nonatomic) int keyboardPresentFlag;
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
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initUIHead];
}

- (void)navBack
{
    [_tcpSocket clearCommentAry];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUIHead
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = Rect(0, 20, 44, 44);
    [self setLeftBtn:btnBack];
    
    __weak NewDetailsViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [__self requestView];
    });
    
//    [_tcpSocket reqIdeaDetails:0 count:20 ideaId:_details.messageid];
    
    downView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50, kScreenWidth, 50)];
    [downView setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:downView];
    
    //聊天框
    _textChat = [[UITextView alloc] initWithFrame:Rect(8,7, kScreenWidth-100, 36)];
    [_textChat setFont:XCFONT(15)];
    _textChat.delegate = self;
    [_textChat setReturnKeyType:UIReturnKeySend];
    [_textChat setBackgroundColor:UIColorFromRGB(0xffffff)];
    [downView addSubview:_textChat];
    
    lblPlace = [[UILabel alloc] initWithFrame:Rect(_textChat.x+5,_textChat.y,_textChat.width,_textChat.height)];
    lblPlace.text = @"点此和大家说点什么吧";
    lblPlace.font = XCFONT(14);
    lblPlace.enabled = NO;
    lblPlace.backgroundColor = [UIColor clearColor];
    [lblPlace setTextColor:UIColorFromRGB(0xcfcfcf)];
    [downView addSubview:lblPlace];
    
    //发送消息按钮
    UIButton *btnEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEmoji setImage:[UIImage imageNamed:@"Expression"] forState:UIControlStateNormal];
    [btnEmoji setImage:[UIImage imageNamed:@"Expression_H"] forState:UIControlStateHighlighted];
    [btnEmoji setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [btnEmoji setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateHighlighted];
    [downView addSubview:btnEmoji];
    btnEmoji.frame = Rect(kScreenWidth-85,7, 36, 36);
    [btnEmoji addTarget:self action:@selector(showEmojiView) forControlEvents:UIControlEventTouchUpInside];
    
    _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [downView addSubview:_btnSend];
    _btnSend.frame = Rect(kScreenWidth - 44, 7, 36, 36);
    [_btnSend addTarget:self action:@selector(sendInfo) forControlEvents:UIControlEventTouchUpInside];
    [self createEmojiKeyboard];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)decodeDiction:(NSDictionary *)dict
{
    if (dict)
    {
        if(_jsonModel)
        {
            _jsonModel = nil;
        }
        _jsonModel = [NewDetailsModel resultWithDict:dict];
        __weak NewDetailsViewController *__self = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self createContentView];
        });
    }
}

- (void)createContentView
{
    if (contentView)
    {
        for (UIView *view in contentView.subviews)
        {
            [view removeFromSuperview];
        }
        contentView = nil;
    }
    
    //计算正文内容 占据的高度
    DTAttributedTextView *textView = [DTAttributedTextView new];
    textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[_jsonModel.ccontent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    CGFloat height = [textView.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-16].height;
    DLog(@"height:%f",height);
    
    CGRect frame = [_jsonModel.title boundingRectWithSize:CGSizeMake(kScreenWidth-16, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(17)} context:nil];

    contentView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, height+250+frame.size.height)];
    [contentView addSubview:textView];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:Rect(8, 30, kScreenWidth-16, frame.size.height)];
    [lblTitle setFont:XCFONT(17)];
    [lblTitle setText:_jsonModel.title];
    [contentView addSubview:lblTitle];
    
    UILabel *lblAuthor = [[UILabel alloc] initWithFrame:Rect(8, lblTitle.y+lblTitle.height+20,100, 20)];
    [lblAuthor setFont:XCFONT(13)];
    [lblAuthor setText:[NSString stringWithFormat:@"作者:%@",_tcpSocket.teacher.strName]];
    [lblAuthor setTextColor:UIColorFromRGB(0x919191)];
    [contentView addSubview:lblAuthor];
    
    UILabel *lblTime = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-120, lblAuthor.y, 110, 20)];
    [lblTime setTextColor:UIColorFromRGB(0x919191)];
    [lblTime setText:@"今天 08:30"];
    [contentView addSubview:lblTime];
    
    textView.frame = Rect(8,lblTime.y+lblTime.height+20, kScreenWidth-16, height);
   
    UIButton *btnThum = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *temp = [NSString stringWithFormat:@"%d  赞一个",[_jsonModel.czans intValue]];
    [btnThum setTitle:temp forState:UIControlStateNormal];
    [btnThum setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btnThum setTitleColor:kNavColor forState:UIControlStateHighlighted];
    
    [btnThum setImage:[UIImage imageNamed:@"text_viewpoint_like_icon"] forState:UIControlStateNormal];
    [btnThum setImage:[UIImage imageNamed:@"thum_h"] forState:UIControlStateHighlighted];
    [btnThum setBackgroundColor:kNavColor];
    [contentView addSubview:btnThum];
    btnThum.layer.masksToBounds = YES;
    btnThum.layer.cornerRadius = 3;
    btnThum.titleLabel.font = XCFONT(17);
    btnThum.frame = Rect(contentView.width/2-92, textView.y+textView.height+30, 194,40);
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(0, btnThum.y+btnThum.height+20, kScreenWidth, 10)];
    [lblTemp setText:@"【仅代表个人观点,不构成投资建议,风险自负】"];
    [lblTemp setTextColor:UIColorFromRGB(0x555555)];
    [lblTemp setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:lblTemp];
    
    UILabel *lblLine = [[UILabel alloc] initWithFrame:Rect(76,lblTemp.y+lblTemp.height+45,kScreenWidth-76, 0.5)];
    [lblLine setBackgroundColor:kLineColor];
    [contentView addSubview:lblLine];
    
    UILabel *lblTalk = [[UILabel alloc] initWithFrame:Rect(0, lblLine.y-11,75, 23)];
    [lblTalk setText:@"发表评论"];
    [lblTalk setTextColor:UIColorFromRGB(0xffffff)];
    [lblTalk setFont:XCFONT(15)];
    [lblTalk setBackgroundColor:UIColorFromRGB(0xffa200)];
    [lblTalk setTextAlignment:NSTextAlignmentCenter];
    lblTalk.layer.masksToBounds= YES;
    lblTalk.layer.cornerRadius = 10;
    [contentView addSubview:lblTalk];
    
    [_tableView setTableHeaderView:contentView];
    
    [_tcpSocket reqIdeaDetails:0 count:20 ideaId:[_jsonModel.viewid integerValue]];
}

- (void)requestView
{
    NSString *strInfo = [NSString stringWithFormat:@"%@%lld.html",kTEXT_NEW_DETAILS_URL,_viewId];
    __weak NewDetailsViewController *__self = self;
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
        if (dict && [dict objectForKey:@"data"])
        {
            [__self decodeDiction:[dict objectForKey:@"data"]];
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
//        cell.textView.shouldDrawLinks = YES;
        cell.textView.delegate = self;
        cell.textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[comment.strContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
        [cell setModel:comment];
    }
    return cell;
}


#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:attachment.contentURL];
        imageView.userInteractionEnabled = YES;
//        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                action:@selector(showImageInfo:)]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_aryCommont.count>indexPath.row)
    {
        IdeaDetailRePly *comment = [_aryCommont objectAtIndex:indexPath.row];
        DTAttributedTextContentView *content = [DTAttributedTextContentView new];
        content.attributedString = [[NSAttributedString alloc] initWithHTMLData:[comment.strContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
        CGFloat height = [content suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-80].height;
        return height+91;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentView) name:MESSAGE_TEXT_NEW_COMMENT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentView) name:MESSAGE_TEXT_COMMENT_LIST_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:)
                                                  name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardDidChangeFrameNotification object:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark 表情键盘
- (void)createEmojiKeyboard
{
    //216+108   324
    _emojiView = [[EmojiView alloc] initWithFrame:Rect(0, kScreenHeight-216,kScreenWidth, 216)];
    [self.view addSubview:_emojiView];
    [_emojiView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [_emojiView setHidden:YES];
    _emojiView.delegate = self;
}

- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat keyboardOriginY = self.view.frame.size.height - keyboardSize.height;
    deltaY = downView.frame.origin.y + downView.frame.size.height - keyboardOriginY;
    
    if (self.keyboardPresentFlag == 1)
    {
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:
        ^{
            downView.frame = CGRectOffset(downView.frame, 0, -deltaY);
        } completion:nil];
    }
}

- (void) keyboardWasShown:(NSNotification *) notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // 获得弹出keyboard的动画时间，也可以手动赋值，如0.25f
    duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 得到keyboard在当前controller的view中的Y轴坐标
    DLog(@"keyboardSize:%f",keyboardSize.height);
    CGFloat keyboardOriginY = self.view.frame.size.height - keyboardSize.height;
    // textField下边到view顶点的距离减去keyboard的Y轴坐标就是textField要移动的距离，
    // 这里是刚好让textField完全显示出来，也可以再在deltaY的基础上再加上一定距离，如20f、30f等
    deltaY = downView.frame.origin.y + downView.frame.size.height - keyboardOriginY;
    // 当deltaY大于0时说明textField会被键盘遮住，需要上移
    // 以动画的方式改变textField的frame
    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:
     ^{
         downView.frame = CGRectOffset(downView.frame, 0, -deltaY);
     } completion:nil];
    
    if (_emojiView.hidden == NO)
    {
        _emojiView.hidden = YES;
    }
}
- (void) keyboardWasHidden:(NSNotification *) notification
{
    CGRect frame = self.view.frame;
    frame.origin.y = originalY;
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (keyboardSize.height==282)
    {
        downView.frame = Rect(0, kScreenHeight-50, kScreenWidth, 50);
    }
}

- (void)closeKeyBoard
{
    if([_textChat isFirstResponder])
    {
        [_textChat resignFirstResponder];
        [downView setFrame:Rect(0, kScreenHeight-50, kScreenWidth, 50)];
    }
    if(_emojiView.hidden==NO)
    {
        [_emojiView setHidden:YES];
        [self.view setFrame:Rect(0,0,kScreenWidth,kScreenHeight)];
        [downView setFrame:Rect(0, kScreenHeight-50, kScreenWidth, 50)];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self sendInfo];
        return NO;
    }
    return YES;
}
- (void)sendInfo
{
    if ([_textChat.textStorage getPlainString].length == 0)
    {
        [self.view makeToast:@"不能发送空信息"];
        return ;
    }
    NSString *strComment = [_textChat.textStorage getPlainString];
    [_tcpSocket replyCommentReq:strComment msgid:[_jsonModel.viewid integerValue] toid:[_jsonModel.teacherid integerValue] srccom:0];
    [self closeKeyBoard];
    _textChat.text = @"";
}

- (void)showEmojiView
{
    if ([_textChat isFirstResponder])
    {
        [_textChat resignFirstResponder];
    }
    _emojiView.hidden = NO;
    downView.frame = Rect(0, kScreenHeight-266,kScreenWidth, 50);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([_textChat isFirstResponder])
    {
        [_textChat resignFirstResponder];
    }
}


@end
