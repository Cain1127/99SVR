//
//  TextTodayVPViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/4/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextTodayVPViewController.h"
#import "TextTcpSocket.h"
#import "AlertFactory.h"
#import "LoginViewController.h"
#import "MarchLiveTextCell.h"
#import "Toast+UIView.h"
#import "MJRefresh.h"
#import "LiveCoreTextCell.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "LiveCoreTextCell.h"
#import "TextLiveModel.h"
#import <DTCoreText/DTCoreText.h>

@interface TextTodayVPViewController ()<UITableViewDelegate,UITableViewDataSource,
                DTAttributedTextContentViewDelegate,ThumCellDelagate,MarchLiveTextDelegate>
{
    NSCache *cellCache;
    NSMutableDictionary *dict;
}
@property (nonatomic) int nCurrent;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *aryLive;
@property (nonatomic,strong) TextTcpSocket *tcpSocket;

@end

@implementation TextTodayVPViewController

- (id)initWithSocket:(TextTcpSocket *)tcpSocket
{
    self = [super init];
    _tcpSocket = tcpSocket;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"直播重点"];
    [self initUIHead];
    cellCache = [[NSCache alloc] init];
    dict = [NSMutableDictionary dictionary];
    [self requestPoint];
}

- (void)requestPoint
{
    [_tcpSocket reqTextRoomList:0 count:20 type:2];
    _nCurrent += 20;
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUIHead
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth,kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestInfo)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestMore)];
    [_tableView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [_tableView.gifHeader loadDefaultImg];
}

- (void)requestInfo
{
    [_tcpSocket reqTextRoomList:0 count:20 type:2];
    _nCurrent = 20;
}

- (void)requestMore
{
    if(_aryLive.count>0)
    {
        TextLiveModel *model = [_aryLive objectAtIndex:[_aryLive count]-1];
        [_tcpSocket reqTextRoomList:model.messageid count:20 type:2];
        [_tableView.footer beginRefreshing];
        _nCurrent += 20;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryLive.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        if([attachment.contentURL.absoluteString isEqualToString:@"text_live_ask_icon"])
        {
            [imageView setImage:[UIImage imageNamed:@"text_live_ask_icon"]];
        }
        else if([attachment.contentURL.absoluteString isEqualToString:@"text_live_answer_icon"])
        {
            [imageView setImage:[UIImage imageNamed:@"text_live_answer_icon"]];
        }
        else if([attachment.contentURL.absoluteString isEqualToString:@"text_live_notice_icon"])
        {
            [imageView setImage:[UIImage imageNamed:@"text_live_notice_icon"]];
        }
        else
        {
            @WeakObj(self)
            [imageView sd_setImageWithURL:attachment.contentURL
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 MarchLiveTextCell *cell = (MarchLiveTextCell*)attributedTextContentView.superview.superview;
                 [selfWeak updateTextView:cell url:imageURL changeSize:image.size];
             }];
        }
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
        MarchLiveTextCell *cell = (MarchLiveTextCell*)attributedTextContentView.superview.superview.superview;
        [cell setNeedsLayout];
        return imageView;
    }
    return nil;
}

- (void)updateTextView:(MarchLiveTextCell*)text url:(NSURL*)url changeSize:(CGSize)size
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
    for (DTTextAttachment *oneAttachment in [text.attributedTextContextView.layoutFrame textAttachmentsWithPredicate:pred])
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
        [text relayoutText];
//        NSString *cacheKey = nil;
//        cacheKey =[NSString stringWithFormat:@"LiveText-%zi", text.section];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:text.section];
//        NSArray *array = [[NSArray alloc] initWithObjects:indexPath, nil];
//        [_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
//        [text setNeedsLayout];
        [_tableView reloadData];
    }
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

- (void)liveCore:(LiveCoreTextCell *)liveCore msgid:(int64_t)messageid
{
    if (liveCore.btnThum.selected)
    {
        return ;
    }
    [_tcpSocket reqZans:messageid];
    liveCore.btnThum.selected = YES;
    [dict setObject:liveCore forKey:NSStringFromInt((int)messageid)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarchLiveTextCell *cell = [self tableView:tableView marchCellForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarchLiveTextCell *cell = [self tableView:tableView marchCellForIndexPath:indexPath];
    CGFloat height = [cell.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height+86;
    return height;
}

- (MarchLiveTextCell *)tableView:(UITableView *)tableView marchCellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = nil;
    NSString *strInfo = nil;
    MarchLiveTextCell *cell;
    cacheKey =[NSString stringWithFormat:@"LiveText-%zi", indexPath.section];
    if (_aryLive.count>indexPath.section) {
        TextLiveModel *textModel = [_aryLive objectAtIndex:indexPath.section];
        strInfo = textModel.strContent;
        cell = [cellCache objectForKey:cacheKey];
        if (cell==nil)
        {
            cell = [[MarchLiveTextCell alloc] initWithReuseIdentifier:@"TextLiveIdentifier"];
            UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
            [selectView setBackgroundColor:[UIColor clearColor]];
            cell.selectedBackgroundView = selectView;
            [cellCache setObject:cell forKey:cacheKey];
        }
        if(![strInfo isEqualToString:cell.strInfo])
        {
            cell.attributedString = [[NSAttributedString alloc] initWithHTMLData:[strInfo dataUsingEncoding:NSUTF8StringEncoding]
                                                              documentAttributes:nil];
            cell.section = indexPath.section;
            cell.delegate = self;
            [cell setTextModel:textModel];
            cell.messageid = textModel.messageid;
            cell.textDelegate = self;
        }else{
            [cell setTextModel:textModel];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextLiveIdentifier"];
        if (cell==nil) {
            cell = [[MarchLiveTextCell alloc] initWithReuseIdentifier:@"TextLiveIdentifier"];
        }
    }
    return cell;
}

- (void)textLive:(MarchLiveTextCell *)liveCore msgid:(int64_t)messageid
{

    if (liveCore.btnThum.selected)
    {
        return ;
    }
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1) {
        [_tcpSocket reqZans:messageid];
        liveCore.btnThum.selected = YES;
        [dict setObject:liveCore forKey:NSStringFromInt((int)messageid)];
    }else{
        @WeakObj(self)
        [AlertFactory createLoginAlert:self block:^{
            [selfWeak.tcpSocket closeSocket];
        }];
    }
    
}



- (void)respTablView
{
    _aryLive = _tcpSocket.aryVIP;
    __weak TextTodayVPViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        if ([__self.tableView.header isRefreshing])
        {
            [__self.tableView.header endRefreshing];
            [__self.tableView.footer resetNoMoreData];
        }
        else
        {
            [__self.tableView.footer endRefreshing];
            if (__self.nCurrent != __self.tcpSocket.aryVIP.count)
            {
                [__self.tableView.footer noticeNoMoreData];
                __self.nCurrent = (int)__self.tcpSocket.aryVIP.count;
            }
        }
        [__self.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respTablView) name:MESSAGE_TEXT_TODAY_VIP_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respZanSuccess:) name:MESSAGE_TEXT_ZAN_SUC_VC object:nil];
}

- (void)respZanSuccess:(NSNotification *)notify
{
    NSString *messageid = notify.object;
    if (messageid && [dict objectForKey:messageid])
    {
        LiveCoreTextCell *cell =  [dict objectForKey:messageid];
        if(_aryLive.count>cell.section)
        {
            TextLiveModel *textModel = [_aryLive objectAtIndex:cell.section];
            textModel.bZan = YES;
            __weak LiveCoreTextCell *__cell = cell;
            __weak TextTodayVPViewController *__self = self;
            [dict removeObjectForKey:messageid];
            dispatch_async(dispatch_get_main_queue(),
            ^{
               [__self.view makeToast:@"点赞成功"];
               NSInteger message = [__cell.btnThum.titleLabel.text integerValue];
               message++;
               [__cell.btnThum setTitle:NSStringFromInteger(message) forState:UIControlStateNormal];
           });
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
