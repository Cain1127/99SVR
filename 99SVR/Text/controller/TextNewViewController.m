//
//  TextNewViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//  观点类

#import "TextNewViewController.h"
#import "DTCoreText.h"
#import "MJRefresh.h"
//#import <DTCoreText/DTCoreText.h>
#import "NewDetailsViewController.h"
#import "TextNewCell.h"
#import "IdeaDetails.h"
#import "TextLiveModel.h"
#import "LiveCoreTextCell.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImage+animatedGIF.h"
#import "TextTcpSocket.h"
#import "EmojiView.h"

@interface TextNewViewController ()<UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate>
{
    NSCache *cellCache;
    NSMutableDictionary *_dictIcon;
}
@property (nonatomic) int current;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryNew;
@property (nonatomic,strong) TextTcpSocket *textSocket;

@end

@implementation TextNewViewController

- (id)initWithSocket:(TextTcpSocket *)textSocket
{
    if(self = [super  init])
    {
        _textSocket = textSocket;
        return self;
    }
    return nil;
}

- (void)initUIBody
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIBody];
    [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(reqTextNewMessage)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(reqMoreNewMsg)];
    [_tableView.gifHeader loadDefaultImg];
}

- (void)didReceiveMemoryWarning {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryNew.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strTextNew = @"textnewtableviewcellidentifier";
    TextNewCell *cell = [tableView dequeueReusableCellWithIdentifier:strTextNew];
    if(cell==nil)
    {
        cell = [[TextNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTextNew];
    }
    if(_aryNew.count > indexPath.section)
    {
        IdeaDetails *idea = [_aryNew objectAtIndex:indexPath.section];
        [cell setDetails:idea];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IdeaDetails *idea = [_aryNew objectAtIndex:indexPath.section];
    NewDetailsViewController *detailView = [[NewDetailsViewController alloc] initWithSocket:_textSocket model:idea];
    [self.navigationController pushViewController:detailView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNew) name:MESSAGE_TEXT_NEW_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reqTextNewMessage) name:MESSAGE_TEXT_TEACHER_INFO_VC object:nil];
}

- (void)reqTextNewMessage
{
    [_textSocket reqNewList:0 count:20];
    _current = 20;
}

- (void)reqMoreNewMsg
{
    [_textSocket reqNewList:_current count:20];
    _current += 20;
}

- (void)reloadNew
{
    _aryNew = _textSocket.aryNew;
    _current = (int)_aryNew.count;
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(),
    ^{
        if ([selfWeak.tableView.gifHeader isRefreshing]) {
            [selfWeak.tableView.gifHeader endRefreshing];
        }
        else
        {
            [selfWeak.tableView.footer endRefreshing];
            if (selfWeak.current != selfWeak.textSocket.aryText.count)
            {
                [selfWeak.tableView.footer noticeNoMoreData];
                selfWeak.current = (int)selfWeak.textSocket.aryText.count;
            }
        }
        [selfWeak.tableView reloadData];
    });
}

@end
