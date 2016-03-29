//
//  TextChatViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextChatViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "TextChatModel.h"
#import "ChatViewCell.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImage+animatedGIF.h"
#import "EmojiView.h"
#import "EmojiTextAttachment.h"
#import "Toast+UIView.h"
#import "NSAttributedString+EmojiExtension.h"
#import "TextTcpSocket.h"

@interface TextChatViewController ()<UITableViewDataSource ,UITableViewDelegate,DTAttributedTextContentViewDelegate,EmojiViewDelegate,UITextViewDelegate>
{
    NSCache *cellCache;
    UILabel *lblPlace;
    UITextView *_textChat;
    CGFloat deltaY;
    UIView *downView;
    CGFloat duration;
    CGFloat originalY;
    EmojiView *_emojiView;
}
@property (nonatomic) int keyboardPresentFlag;
@property (nonatomic,strong) UIButton *btnSend;

@property (nonatomic,copy) NSArray *aryChat;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TextTcpSocket *textSocket;

@end

@implementation TextChatViewController

- (id)initWithSocket:(TextTcpSocket *)textSocket
{
    if(self = [super init])
    {
        _textSocket = textSocket;
        return self;
    }
    return self;
}

#pragma mark 表情键盘
- (void)createEmojiKeyboard
{
    //216+108   324
    _emojiView = [[EmojiView alloc] initWithFrame:Rect(0, kScreenHeight-324,kScreenWidth, 216)];
    [self.view addSubview:_emojiView];
    [_emojiView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [_emojiView setHidden:YES];
    _emojiView.delegate = self;
}

- (void)initUIBody
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-159)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(0, kScreenHeight-159, kScreenWidth, 1)];
    [self.view addSubview:line];
    [line setBackgroundColor:kLineColor];
    
    downView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-158, kScreenWidth, 50)];
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

- (void)sendInfo
{
    if ([_textChat.textStorage getPlainString].length == 0)
    {
        [self.view makeToast:@"不能发送空信息"];
        return ;
    }
    NSString *strContent = [_textChat.textStorage getPlainString];
    [_textSocket reqLiveChat:strContent to:0 toalias:@""];
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
    downView.frame = Rect(0, kScreenHeight-266-108,kScreenWidth, 50);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellCache = [[NSCache alloc] init];
    [self initUIBody];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (void)showImageInfo:(UITapGestureRecognizer *)tapGest
{
    UIImageView *imageView = (UIImageView *)tapGest.view;
    NSMutableArray *aryIndex = [NSMutableArray array];
    Photo *_photo = [[Photo alloc] init];
    _photo.nId = 0;
    _photo.imgName = imageView.image;
    [aryIndex addObject:_photo];
    PhotoViewController *photoControl = [[PhotoViewController alloc] initWithArray:aryIndex current:0];
    [photoControl show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryChat.count;
}

- (DTAttributedTextCell *)tableView:(UITableView *)tableView chatRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"textChatViewIdentifier";
    char cBuffer[100]={0};
    sprintf(cBuffer,"%zi-%zi",indexPath.row,indexPath.section);
    NSString *key = [[NSString alloc] initWithUTF8String:cBuffer];
    DTAttributedTextCell *cell = [cellCache objectForKey:key];
    if (cell==nil)
    {
        cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:strIdentifier];
        UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
        [selectView setBackgroundColor:[UIColor clearColor]];
        cell.selectedBackgroundView = selectView;
        [cellCache setObject:cell forKey:key];
    }
    if (_aryChat.count >indexPath.row)
    {
        TextChatModel *model = [_aryChat objectAtIndex:indexPath.row];
        cell.attributedTextContextView.shouldDrawImages = YES;
        cell.attributedTextContextView.delegate = self;
        [cell setHTMLString:model.content];
        CGFloat height = [cell.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
        cell.frame = Rect(10, 5, kScreenWidth-20, height+10);
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTAttributedTextCell *cell = [self tableView:tableView chatRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTAttributedTextCell *cell = [self tableView:tableView chatRowAtIndexPath:indexPath];
    return [cell requiredRowHeightInTableView:tableView];
}

- (void)viewWillAppear:(BOOL)animate
{
    [super viewWillAppear:animate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChat) name:MESSAGE_TEXT_NEW_CHAT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:)
                                                  name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardDidChangeFrameNotification object:nil];
    
}

- (void)reloadChat
{
    _aryChat = _textSocket.aryChat;
    __weak TextChatViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.tableView reloadData];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

/**
 * 键盘frame变化时执行的通知方法
 * @note 键盘弹出，收起，改变输入法时这个方法都会执行
 */
- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat keyboardOriginY = self.view.frame.size.height - keyboardSize.height;
    deltaY = downView.frame.origin.y + downView.frame.size.height - keyboardOriginY;
    
    if (self.keyboardPresentFlag == 1)
    {
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
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
        [downView setFrame:Rect(0, kScreenHeight-158, kScreenWidth, 50)];
    }
    if(_emojiView.hidden==NO)
    {
        [_emojiView setHidden:YES];
        [downView setFrame:Rect(0,kScreenHeight-158,kScreenWidth,50)];
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
    emojiTextAttachment.emojiSize = CGSizeMake(16,16);
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

@end
