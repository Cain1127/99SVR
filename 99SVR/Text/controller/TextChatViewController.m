//
//  TextChatViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextChatViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "RoomUser.h"
#import "TextChatModel.h"
#import "ChatViewCell.h"
#import "UITableView+reloadComplete.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImage+animatedGIF.h"
#import "EmojiView.h"
#import "EmojiTextAttachment.h"
#import "Toast+UIView.h"
#import "NSAttributedString+EmojiExtension.h"
#import "TextTcpSocket.h"
#import "GiftView.h"
#import "ChatView.h"
#import "TextChatView.h"

@interface TextChatViewController ()<UITableViewDataSource ,UITableViewDelegate,DTAttributedTextContentViewDelegate,ChatViewDelegate>
{
    NSCache *cellCache;
    UILabel *lblPlace;
    CGFloat deltaY;
    CGFloat duration;
    CGFloat originalY;
    ChatView *_chatView;
}
@property (nonatomic) int keyboardPresentFlag;
@property (nonatomic,strong) UIButton *btnSend;
@property (nonatomic,copy) NSArray *aryChat;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TextTcpSocket *textSocket;

@end

@implementation TextChatViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108)];
}

- (id)initWithSocket:(TextTcpSocket *)textSocket
{
    if(self = [super init])
    {
        _textSocket = textSocket;
        return self;
    }
    return self;
}

- (void)initUIBody
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-159)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(0, kScreenHeight-159, kScreenWidth, 1)];
    [self.view addSubview:line];
    [line setBackgroundColor:kLineColor];
    //聊天框
    
    UIView *bodyView = [[UIView alloc] initWithFrame:Rect(0, self.view.height-50, kScreenWidth,50)];
    [bodyView setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
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
    
    _chatView = [[ChatView alloc] initWithFrame:Rect(0, -108, kScreenWidth,kScreenHeight)];
    [self.view addSubview:_chatView];
    _chatView.hidden = YES;
    _chatView.delegate = self;
    
    @WeakObj(_chatView)
    [bodyView clickWithBlock:^(UIGestureRecognizer *gesture) {
        _chatViewWeak.hidden = !_chatViewWeak.hidden;
    }];
    
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

#pragma mark 点击超链接
- (void)linkPushed:(DTLinkButton *)sender
{
    DLog(@"路径:%@",sender.URL.absoluteString);
    NSArray *array = [sender.URL.absoluteString componentsSeparatedByString:@","];
    if([array[0] rangeOfString:@"sqchatid://"].location != NSNotFound && [array[1] length]>0)
    {
        NSString *strNumber = [sender.URL.absoluteString stringByReplacingOccurrencesOfString:@"sqchatid://" withString:@""];
        RoomUser *rUser = [[RoomUser alloc] init];
        rUser.m_strUserAlias = [array[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        rUser.m_nUserId = [strNumber intValue];
        [_chatView setChatInfo:rUser];
    
    }
}

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
        [selectView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        cell.selectedBackgroundView = selectView;
        [cell setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        [cellCache setObject:cell forKey:key];
    }
    if (_aryChat.count >indexPath.row)
    {
        TextChatModel *model = [_aryChat objectAtIndex:indexPath.row];
        cell.attributedTextContextView.shouldDrawImages = YES;
        cell.attributedTextContextView.shouldDrawLinks = YES;
        cell.attributedTextContextView.delegate = self;
        [cell.attributedTextContextView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
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
}

- (void)reloadChat
{
    _aryChat = _textSocket.aryChat;
    __weak TextChatViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.tableView reloadDataWithCompletion:
         ^{
             NSInteger numberOfRows = [__self.tableView numberOfRowsInSection:0];
             if (numberOfRows > 0)
             {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
                 [__self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             }
         }];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)sendMessage:(UITextView *)textView userid:(int)nUser
{
    NSString *strContent = [textView.textStorage getPlainString];
    [_textSocket reqLiveChat:strContent to:nUser toalias:@""];
    _chatView.hidden = YES;
    textView.text = @"";
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end

