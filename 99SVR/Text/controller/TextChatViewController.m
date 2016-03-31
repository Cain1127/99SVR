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
#import "GiftView.h"
#import "TextChatView.h"

@interface TextChatViewController ()<UITableViewDataSource ,UITableViewDelegate,DTAttributedTextContentViewDelegate,TextChatViewDelegate>
{
    NSCache *cellCache;
    UILabel *lblPlace;
    CGFloat deltaY;
    CGFloat duration;
    CGFloat originalY;
    TextChatView *_chatView;
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
    
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(0, kScreenHeight-159, kScreenWidth, 1)];
    [self.view addSubview:line];
    [line setBackgroundColor:kLineColor];
    //聊天框
    _chatView = [[TextChatView alloc] initWithFrame:Rect(0, -108, kScreenWidth,kScreenHeight)];
    [self.view addSubview:_chatView];
    _chatView.delegate = self;
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

- (void)sendMessage:(UITextView *)textView userid:(int)nUser
{
    NSString *strContent = [textView.textStorage getPlainString];
    [_textSocket reqLiveChat:strContent to:0 toalias:@""];
}
@end

